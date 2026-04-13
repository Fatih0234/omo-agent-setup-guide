#!/bin/bash

# Oh My OpenAgent Setup Script
# For AI agents setting up Oh My OpenAgent harness on a new VPS
# Repository: Fatih0234/omo-agent-setup-guide

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Error handler
error_exit() {
    log_error "$1"
    exit 1
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Print banner
echo "========================================"
echo "  Oh My OpenAgent Setup"
echo "  For AI Agents - VPS Configuration"
echo "========================================"
echo ""

# ============================================
# PHASE 1: Check Prerequisites
# ============================================
log_info "Phase 1: Checking Prerequisites..."

# Check bun
if command_exists bun; then
    BUN_VERSION=$(bun --version)
    log_success "bun is installed (version $BUN_VERSION)"
else
    log_error "bun is not installed"
    echo ""
    echo "To install bun, run:"
    echo "  curl -fsSL https://bun.sh/install | bash"
    echo ""
    echo "Then restart your shell or run:"
    echo "  source ~/.bashrc"
    error_exit "Please install bun and re-run this script"
fi

# Check npm
if command_exists npm; then
    NPM_VERSION=$(npm --version)
    log_success "npm is installed (version $NPM_VERSION)"
else
    log_warning "npm is not installed (bun will be used as primary)"
fi

# Check git
if command_exists git; then
    GIT_VERSION=$(git --version | awk '{print $3}')
    log_success "git is installed (version $GIT_VERSION)"
else
    error_exit "git is required but not installed. Please install git first."
fi

# Check gh CLI
if command_exists gh; then
    GH_VERSION=$(gh --version | head -1 | awk '{print $3}')
    log_success "gh CLI is installed (version $GH_VERSION)"
    
    # Check authentication
    if gh auth status >/dev/null 2>&1; then
        GH_USER=$(gh api user -q .login 2>/dev/null || echo "unknown")
        log_success "gh CLI is authenticated as: $GH_USER"
        
        if [ "$GH_USER" != "Fatih0234" ]; then
            log_warning "Authenticated as $GH_USER, but Fatih0234 is expected"
            log_warning "You may need to run: gh auth login"
        fi
    else
        log_error "gh CLI is not authenticated"
        echo ""
        echo "To authenticate, run:"
        echo "  gh auth login"
        echo ""
        echo "Follow the prompts to authenticate with GitHub"
        error_exit "Please authenticate gh CLI and re-run this script"
    fi
else
    error_exit "gh CLI is required but not installed."
    echo ""
    echo "To install gh CLI:"
    echo "  # On Ubuntu/Debian:"
    echo "  sudo apt install gh"
    echo ""
    echo "  # On macOS:"
    echo "  brew install gh"
    echo ""
    echo "  # For other systems, see: https://github.com/cli/cli#installation"
    error_exit "Please install gh CLI and re-run this script"
fi

echo ""

# ============================================
# PHASE 2: Install Oh My OpenAgent
# ============================================
log_info "Phase 2: Installing Oh My OpenAgent..."

if command_exists oh-my-opencode || [ -d "$HOME/.bun/bin/oh-my-opencode" ]; then
    log_success "Oh My OpenAgent is already installed"
else
    log_info "Installing Oh My OpenAgent via bunx..."
    bunx oh-my-opencode --version >/dev/null 2>&1 || true
    
    # Check if it was installed
    if command_exists oh-my-opencode || [ -f "$HOME/.bun/bin/oh-my-opencode" ]; then
        log_success "Oh My OpenAgent installed successfully"
    else
        log_warning "Oh My OpenAgent may not be in PATH"
        log_info "Adding to PATH..."
        export PATH="$HOME/.bun/bin:$PATH"
        echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
    fi
fi

echo ""

# ============================================
# PHASE 3: Download Configurations
# ============================================
log_info "Phase 3: Downloading configurations from Fatih0234/omo-configs..."

CONFIG_DIR="$HOME/.config/opencode"
mkdir -p "$CONFIG_DIR"

# Create temporary directory for cloning configs
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

log_info "Cloning omo-configs repository..."
if gh repo clone Fatih0234/omo-configs "$TEMP_DIR/omo-configs" 2>/dev/null; then
    log_success "Cloned omo-configs repository"
    
    # Copy configuration files
    if [ -d "$TEMP_DIR/omo-configs" ]; then
        log_info "Copying configuration files..."
        
        # Copy all config files
        for file in "$TEMP_DIR/omo-configs"/*; do
            if [ -f "$file" ]; then
                filename=$(basename "$file")
                cp "$file" "$CONFIG_DIR/"
                log_success "Copied $filename"
            fi
        done
        
        log_success "All configurations installed to $CONFIG_DIR"
    fi
else
    log_error "Failed to clone omo-configs repository"
    log_info "This may be due to:"
    log_info "  - Repository doesn't exist or is private"
    log_info "  - gh CLI not authenticated correctly"
    log_info "  - Network issues"
    error_exit "Please verify access to Fatih0234/omo-configs"
fi

echo ""

# ============================================
# PHASE 4: Clone Project Repositories
# ============================================
log_info "Phase 4: Cloning project repositories..."

PROJECTS_DIR="$HOME/projects"
mkdir -p "$PROJECTS_DIR"
cd "$PROJECTS_DIR"

# List of repositories to clone
REPOS=(
    "Fatih0234/pi-mono"
    "Fatih0234/pi-agent-extensions"
    "Fatih0234/agent-stuff"
    "Fatih0234/pi-pomodoro"
    "Fatih0234/pi-todo-ext"
    "Fatih0234/symphony-orchestrator"
    "Fatih0234/better-context"
    "Fatih0234/career-ops"
)

cloned_count=0
failed_repos=()

for repo in "${REPOS[@]}"; do
    repo_name=$(basename "$repo")
    
    if [ -d "$repo_name" ]; then
        log_warning "$repo_name already exists, skipping..."
        ((cloned_count++)) || true
    else
        log_info "Cloning $repo..."
        if gh repo clone "$repo" "$repo_name" 2>/dev/null; then
            log_success "Cloned $repo_name"
            ((cloned_count++)) || true
            
            # Special handling for pi-pomodoro (has submodules)
            if [ "$repo_name" = "pi-pomodoro" ]; then
                log_info "Initializing submodules for pi-pomodoro..."
                cd "$repo_name"
                git submodule update --init --recursive || log_warning "Some submodules failed to initialize"
                cd "$PROJECTS_DIR"
            fi
        else
            log_error "Failed to clone $repo"
            failed_repos+=("$repo")
        fi
    fi
done

echo ""
log_info "Cloned $cloned_count/${#REPOS[@]} repositories"

if [ ${#failed_repos[@]} -gt 0 ]; then
    log_warning "Failed to clone: ${failed_repos[*]}"
fi

echo ""

# ============================================
# PHASE 5: Install Dependencies
# ============================================
log_info "Phase 5: Installing dependencies for all projects..."

cd "$PROJECTS_DIR"

for dir in */; do
    if [ -d "$dir" ]; then
        project_name=$(basename "$dir")
        log_info "Installing dependencies for $project_name..."
        
        cd "$dir"
        
        # Check for package.json
        if [ -f "package.json" ]; then
            if bun install 2>/dev/null; then
                log_success "Installed dependencies for $project_name (using bun)"
            elif npm install 2>/dev/null; then
                log_success "Installed dependencies for $project_name (using npm)"
            else
                log_warning "Failed to install dependencies for $project_name"
            fi
        else
            log_info "No package.json found in $project_name, skipping..."
        fi
        
        cd "$PROJECTS_DIR"
    fi
done

echo ""

# ============================================
# PHASE 6: Verification
# ============================================
log_info "Phase 6: Running verification checks..."

echo ""
echo "========================================"
echo "  Setup Complete!"
echo "========================================"
echo ""

# Check Oh My OpenAgent
if command_exists oh-my-opencode || [ -f "$HOME/.bun/bin/oh-my-opencode" ]; then
    log_success "Oh My OpenAgent is available"
    
    # Try to run doctor command
    export PATH="$HOME/.bun/bin:$PATH"
    if oh-my-opencode doctor 2>/dev/null || bunx oh-my-opencode doctor 2>/dev/null; then
        log_success "Oh My OpenAgent doctor check passed"
    else
        log_warning "Oh My OpenAgent doctor check had issues (non-critical)"
    fi
else
    log_warning "Oh My OpenAgent may not be in PATH"
    log_info "Run: export PATH=\"\$HOME/.bun/bin:\$PATH\""
fi

# Check config files
if [ -d "$CONFIG_DIR" ] && [ "$(ls -A "$CONFIG_DIR" 2>/dev/null)" ]; then
    config_count=$(ls -1 "$CONFIG_DIR" 2>/dev/null | wc -l)
    log_success "Configuration files installed: $config_count files in $CONFIG_DIR"
else
    log_warning "Configuration directory is empty or missing"
fi

# Check projects
project_count=$(ls -1 "$PROJECTS_DIR" 2>/dev/null | wc -l)
log_success "Projects directory: $project_count repositories in $PROJECTS_DIR"

echo ""
echo "========================================"
echo "  Next Steps"
echo "========================================"
echo ""
echo "1. Verify GitHub authentication:"
echo "   gh auth status"
echo ""
echo "2. Check Oh My OpenAgent:"
echo "   oh-my-opencode doctor"
echo "   # or: bunx oh-my-opencode doctor"
echo ""
echo "3. Review configuration files:"
echo "   ls -la ~/.config/opencode/"
echo ""
echo "4. Navigate to your projects:"
echo "   cd ~/projects"
echo ""
echo "5. Configure API keys (if not already done):"
echo "   # Edit ~/.config/opencode/config.json"
echo "   # Add your Fireworks AI and OpenAI API keys"
echo ""

if [ ${#failed_repos[@]} -gt 0 ]; then
    echo "⚠️  Note: Some repositories failed to clone:"
    printf '   - %s\n' "${failed_repos[@]}"
    echo ""
    echo "   You may need to:"
    echo "   - Check repository names and permissions"
    echo "   - Verify gh CLI authentication"
    echo "   - Clone them manually if needed"
    echo ""
fi

log_success "Setup script completed!"
echo ""
echo "For troubleshooting, see: https://github.com/Fatih0234/omo-agent-setup-guide/blob/main/docs/TROUBLESHOOTING.md"
