# Step-by-Step Setup Guide

Complete walkthrough for setting up Oh My OpenAgent on a new VPS.

---

## Pre-Flight Checks

Before starting, verify:

1. **All prerequisites are installed** (see [PREREQUISITES.md](./PREREQUISITES.md))
2. **GitHub CLI is authenticated** as Fatih0234
3. **You have internet access** (for cloning repositories)
4. **You have sufficient disk space** (at least 2GB recommended)

**Quick verification:**
```bash
bun --version && npm --version && gh auth status && git --version
```

---

## Step 1: Install Oh My OpenAgent Harness

### 1.1 Install via bunx

```bash
bunx oh-my-opencode --version
```

**Expected output:**
```
oh-my-opencode version x.x.x
```

### 1.2 Verify Installation

```bash
# Check if oh-my-opencode is in PATH
which oh-my-opencode || echo "$HOME/.bun/bin/oh-my-opencode"
```

**If not found, add to PATH:**
```bash
export PATH="$HOME/.bun/bin:$PATH"
echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 1.3 Test the CLI

```bash
oh-my-opencode --help
```

**Expected output:** Shows available commands and options

---

## Step 2: Download Configurations

### 2.1 Create Config Directory

```bash
mkdir -p ~/.config/oh-my-opencode
```

### 2.2 Clone Configuration Repository

```bash
cd /tmp
gh repo clone Fatih0234/omo-configs
```

**Expected output:**
```
Cloning into 'omo-configs'...
remote: Enumerating objects: XX, done.
remote: Counting objects: 100% (XX/XX), done.
remote: Compressing objects: 100% (XX/XX), done.
remote: Total XX (delta X), reused X (delta X), pack-reused X
Receiving objects: 100% (XX/XX), XX KiB | XX MiB/s, done.
Resolving deltas: 100% (X/X), done.
```

### 2.3 Copy Configuration Files

```bash
cp /tmp/omo-configs/* ~/.config/oh-my-opencode/
```

### 2.4 Verify Config Files

```bash
ls -la ~/.config/oh-my-opencode/
```

**Expected output:** Shows configuration files (e.g., `config.json`, `agents.json`, etc.)

---

## Step 3: Authenticate Providers

### 3.1 Configure API Keys

Edit the configuration file to add API keys:

```bash
# View current config
cat ~/.config/oh-my-opencode/config.json
```

**Add your API keys:**
- Fireworks AI API key (for Kimi K2.5 Turbo)
- OpenAI API key (for GPT 5.4)

**Note:** API keys are NOT included in this guide for security reasons. The user must provide their own keys.

### 3.2 Verify Provider Access

```bash
oh-my-opencode doctor
```

**Expected output:** Shows provider status (green checkmarks for working providers)

---

## Step 4: Clone Projects

### 4.1 Create Projects Directory

```bash
mkdir -p ~/projects
cd ~/projects
```

### 4.2 Clone All 8 Repositories

```bash
# Clone each repository
gh repo clone Fatih0234/project-1
gh repo clone Fatih0234/project-2
gh repo clone Fatih0234/project-3
gh repo clone Fatih0234/project-4
gh repo clone Fatih0234/project-5
gh repo clone Fatih0234/project-6
gh repo clone Fatih0234/project-7
gh repo clone Fatih0234/pi-pomodoro
```

**Note:** Replace `project-1`, `project-2`, etc. with actual repository names.

### 4.3 Initialize Submodules (for pi-pomodoro)

```bash
cd pi-pomodoro
git submodule update --init --recursive
cd ..
```

**Expected output:**
```
Submodule 'path/to/submodule' (https://github.com/...) registered for path 'path/to/submodule'
Cloning into '/home/user/projects/pi-pomodoro/path/to/submodule'...
Submodule path 'path/to/submodule': checked out 'abc123...'
```

### 4.4 Verify All Projects Cloned

```bash
ls -la ~/projects/
```

**Expected output:** Shows all 8 project directories

---

## Step 5: Install Dependencies

### 5.1 Install for Each Project

```bash
cd ~/projects

for dir in */; do
    echo "Installing dependencies for $dir..."
    cd "$dir"
    
    if [ -f "package.json" ]; then
        bun install || npm install
    fi
    
    cd ..
done
```

### 5.2 Verify Installations

Check that `node_modules` exists in projects with package.json:

```bash
for dir in */; do
    if [ -f "$dir/package.json" ]; then
        if [ -d "$dir/node_modules" ]; then
            echo "✓ $dir - dependencies installed"
        else
            echo "✗ $dir - dependencies NOT installed"
        fi
    fi
done
```

---

## Step 6: Verify Installation

### 6.1 Run Oh My OpenAgent Doctor

```bash
oh-my-opencode doctor
```

**Expected output:**
```
✓ Configuration file exists
✓ GitHub CLI authenticated
✓ bun is installed
✓ Projects directory exists
✓ All 8 projects cloned
✓ Dependencies installed
```

### 6.2 Test Agent Availability

```bash
oh-my-opencode list-agents
```

**Expected output:** Shows available AI agents (Fireworks AI, OpenAI, etc.)

### 6.3 Test Basic Operation

```bash
# Test with a simple command
oh-my-opencode status
```

**Expected output:** Shows current status of the harness

---

## Summary

You should now have:

- [ ] Oh My OpenAgent installed and in PATH
- [ ] Configuration files in `~/.config/oh-my-opencode/`
- [ ] API keys configured (provided by user)
- [ ] All 8 projects cloned to `~/projects/`
- [ ] Submodules initialized for pi-pomodoro
- [ ] Dependencies installed for all projects

---

## Next Steps

1. **Review the [Verification Guide](./VERIFICATION.md)** for detailed testing
2. **Check [Troubleshooting](./TROUBLESHOOTING.md)** if you encounter issues
3. **See [Example Session](../examples/sample-session.md)** for real usage

---

## Quick Reference Commands

```bash
# Check everything is working
oh-my-opencode doctor

# List available agents
oh-my-opencode list-agents

# View configuration
cat ~/.config/oh-my-opencode/config.json

# Check project status
cd ~/projects && ls -la

# Update all projects
for dir in */; do cd "$dir" && git pull && cd ..; done
```
