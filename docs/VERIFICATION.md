# Verification Guide

How to verify that Oh My OpenAgent is properly installed and configured.

---

## Quick Verification

Run this comprehensive check:

```bash
echo "=== Oh My OpenAgent Verification ===" && \
echo "" && \
echo "1. Checking bun..." && \
bun --version && \
echo "" && \
echo "2. Checking oh-my-opencode..." && \
(oh-my-opencode --version 2>/dev/null || bunx oh-my-opencode --version) && \
echo "" && \
echo "3. Checking GitHub auth..." && \
gh auth status && \
echo "" && \
echo "4. Checking config files..." && \
ls -la ~/.config/oh-my-opencode/ && \
echo "" && \
echo "5. Checking projects..." && \
ls ~/projects/ && \
echo "" && \
echo "=== Verification Complete ==="
```

---

## Detailed Verification Steps

### 1. Verify bunx oh-my-opencode doctor

This is the primary diagnostic tool:

```bash
oh-my-opencode doctor
```

**Expected output:**
```
✓ bun is installed (version 1.x.x)
✓ oh-my-opencode is available
✓ GitHub CLI is authenticated
✓ Configuration directory exists
✓ Configuration files present
✓ Projects directory exists
✓ All repositories cloned
✓ Dependencies installed
```

**If any checks fail:** See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)

---

### 2. Check Configuration Files Exist

Verify all config files are in place:

```bash
ls -la ~/.config/oh-my-opencode/
```

**Expected files:**
```
config.json          # Main configuration
agents.json          # Agent definitions
providers.json       # Provider settings
```

**Verify file contents:**
```bash
# Check main config
cat ~/.config/oh-my-opencode/config.json

# Validate JSON
python3 -m json.tool ~/.config/oh-my-opencode/config.json > /dev/null && echo "✓ Valid JSON"
```

---

### 3. Verify Projects Cloned

Check that all 8 repositories are present:

```bash
cd ~/projects
ls -la
```

**Expected output:**
```
drwxr-xr-x  project-1/
drwxr-xr-x  project-2/
drwxr-xr-x  project-3/
drwxr-xr-x  project-4/
drwxr-xr-x  project-5/
drwxr-xr-x  project-6/
drwxr-xr-x  project-7/
drwxr-xr-x  pi-pomodoro/
```

**Verify each project:**
```bash
for dir in */; do
    if [ -d "$dir/.git" ]; then
        echo "✓ $dir - Git repository"
    else
        echo "✗ $dir - Not a Git repository"
    fi
done
```

---

### 4. Verify Submodules (pi-pomodoro)

Check that submodules are properly initialized:

```bash
cd ~/projects/pi-pomodoro
git submodule status
```

**Expected output:**
```
 4a20283f8d8d3e9e7f8a9b0c1d2e3f4a5b6c7d8e9 path/to/submodule (v1.0.0)
```

**If submodules are not initialized:**
```bash
git submodule update --init --recursive
```

---

### 5. Test Agent Availability

Verify that AI agents are accessible:

```bash
oh-my-opencode list-agents
```

**Expected output:**
```
Available Agents:
  ✓ fireworks-ai (Kimi K2.5 Turbo)
  ✓ openai (GPT 5.4)
```

**Test agent connectivity:**
```bash
oh-my-opencode test-agent fireworks-ai
oh-my-opencode test-agent openai
```

---

### 6. Verify Dependencies Installed

Check that all projects have their dependencies:

```bash
cd ~/projects

for dir in */; do
    cd "$dir"
    
    if [ -f "package.json" ]; then
        if [ -d "node_modules" ]; then
            module_count=$(ls node_modules | wc -l)
            echo "✓ $dir - $module_count packages installed"
        else
            echo "✗ $dir - node_modules missing"
        fi
    else
        echo "- $dir - No package.json (skipping)"
    fi
    
    cd ..
done
```

---

### 7. Test Basic Operations

#### Test 1: Status Check
```bash
oh-my-opencode status
```

**Expected:** Shows current harness status without errors

#### Test 2: List Projects
```bash
oh-my-opencode list-projects
```

**Expected:** Lists all 8 projects

#### Test 3: Configuration Check
```bash
oh-my-opencode config --validate
```

**Expected:** "Configuration is valid"

---

## Automated Verification Script

Save this as `verify.sh`:

```bash
#!/bin/bash

set -e

echo "========================================"
echo "  Oh My OpenAgent Verification"
echo "========================================"
echo ""

ERRORS=0

# Check 1: bun
echo "[1/7] Checking bun..."
if bun --version >/dev/null 2>&1; then
    echo "  ✓ bun is installed"
else
    echo "  ✗ bun is NOT installed"
    ERRORS=$((ERRORS + 1))
fi

# Check 2: oh-my-opencode
echo "[2/7] Checking oh-my-opencode..."
if (oh-my-opencode --version || bunx oh-my-opencode --version) >/dev/null 2>&1; then
    echo "  ✓ oh-my-opencode is available"
else
    echo "  ✗ oh-my-opencode is NOT available"
    ERRORS=$((ERRORS + 1))
fi

# Check 3: GitHub auth
echo "[3/7] Checking GitHub authentication..."
if gh auth status >/dev/null 2>&1; then
    echo "  ✓ GitHub CLI is authenticated"
else
    echo "  ✗ GitHub CLI is NOT authenticated"
    ERRORS=$((ERRORS + 1))
fi

# Check 4: Config files
echo "[4/7] Checking configuration files..."
if [ -d "$HOME/.config/oh-my-opencode" ] && [ "$(ls -A $HOME/.config/oh-my-opencode)" ]; then
    count=$(ls -1 $HOME/.config/oh-my-opencode | wc -l)
    echo "  ✓ Configuration directory exists ($count files)"
else
    echo "  ✗ Configuration directory is empty or missing"
    ERRORS=$((ERRORS + 1))
fi

# Check 5: Projects directory
echo "[5/7] Checking projects directory..."
if [ -d "$HOME/projects" ]; then
    count=$(ls -1 $HOME/projects 2>/dev/null | wc -l)
    echo "  ✓ Projects directory exists ($count projects)"
else
    echo "  ✗ Projects directory is missing"
    ERRORS=$((ERRORS + 1))
fi

# Check 6: pi-pomodoro submodules
echo "[6/7] Checking pi-pomodoro submodules..."
if [ -d "$HOME/projects/pi-pomodoro" ]; then
    cd "$HOME/projects/pi-pomodoro"
    if git submodule status >/dev/null 2>&1; then
        echo "  ✓ Submodules are initialized"
    else
        echo "  ⚠ Submodules may not be fully initialized"
    fi
else
    echo "  ✗ pi-pomodoro directory is missing"
    ERRORS=$((ERRORS + 1))
fi

# Check 7: Dependencies
echo "[7/7] Checking dependencies..."
cd "$HOME/projects"
projects_with_deps=0
for dir in */; do
    if [ -f "$dir/package.json" ] && [ -d "$dir/node_modules" ]; then
        projects_with_deps=$((projects_with_deps + 1))
    fi
done
echo "  ✓ $projects_with_deps projects have dependencies installed"

echo ""
echo "========================================"
if [ $ERRORS -eq 0 ]; then
    echo "  ✓ All checks passed!"
    echo "========================================"
    exit 0
else
    echo "  ✗ $ERRORS check(s) failed"
    echo "========================================"
    exit 1
fi
```

**Run it:**
```bash
chmod +x verify.sh
./verify.sh
```

---

## What to Do If Verification Fails

### If bun check fails:
- See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) - bun/bunx Issues

### If oh-my-opencode check fails:
- Re-run: `bunx oh-my-opencode --version`
- Check PATH: `echo $PATH`

### If GitHub auth fails:
- Run: `gh auth login`
- See [PREREQUISITES.md](./PREREQUISITES.md) - GitHub Authentication

### If config files are missing:
- Re-run setup script
- Or manually clone: `gh repo clone Fatih0234/omo-configs`

### If projects are missing:
- Check repository names are correct
- Verify GitHub permissions
- Clone manually: `gh repo clone Fatih0234/project-name`

---

## Final Checklist

Before declaring setup complete, verify:

- [ ] `bun --version` returns version number
- [ ] `oh-my-opencode doctor` shows all green checks
- [ ] `~/.config/oh-my-opencode/` contains config files
- [ ] `~/projects/` contains all 8 repositories
- [ ] `pi-pomodoro` submodules are initialized
- [ ] At least one project has `node_modules/` directory
- [ ] `gh auth status` shows authenticated user
- [ ] API keys are configured (by user)

**All checks passed?** You're ready to use Oh My OpenAgent!
