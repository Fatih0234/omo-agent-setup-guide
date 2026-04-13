# Prerequisites

Before setting up Oh My OpenAgent, you must have the following tools installed and configured.

---

## Required Tools

### 1. bun (JavaScript Runtime)

**What it is:** Fast JavaScript runtime and package manager

**Check if installed:**
```bash
bun --version
```

**Expected output:**
```
1.x.x
```

**Install if missing:**
```bash
curl -fsSL https://bun.sh/install | bash
```

**After installation:**
```bash
# Restart your shell or run:
source ~/.bashrc

# Verify installation
bun --version
```

---

### 2. npm (Node Package Manager)

**What it is:** Backup package manager (Node.js comes with npm)

**Check if installed:**
```bash
npm --version
```

**Expected output:**
```
10.x.x
```

**Install if missing:**

**Ubuntu/Debian:**
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

**macOS:**
```bash
brew install node
```

**Other systems:** See [nodejs.org](https://nodejs.org/)

---

### 3. gh (GitHub CLI)

**What it is:** Command-line interface for GitHub

**Check if installed:**
```bash
gh --version
```

**Expected output:**
```
gh version 2.x.x
```

**Install if missing:**

**Ubuntu/Debian:**
```bash
sudo apt install gh
```

**macOS:**
```bash
brew install gh
```

**Other systems:** See [GitHub CLI installation](https://github.com/cli/cli#installation)

---

### 4. git (Version Control)

**What it is:** Distributed version control system

**Check if installed:**
```bash
git --version
```

**Expected output:**
```
git version 2.x.x
```

**Install if missing:**

**Ubuntu/Debian:**
```bash
sudo apt install git
```

**macOS:**
```bash
brew install git
```

---

## GitHub Authentication

The `gh` CLI must be authenticated to access private repositories.

### Check Authentication Status

```bash
gh auth status
```

**Expected output (authenticated):**
```
✓ Logged in to github.com as Fatih0234
✓ Git operations for github.com configured to use https protocol.
✓ Token: gho_************************************
✓ Token scopes: gist, read:org, repo, workflow
```

### Authenticate if Needed

```bash
gh auth login
```

**Follow the prompts:**
1. Select `GitHub.com`
2. Select `HTTPS` protocol
3. Select `Login with a web browser`
4. Copy the one-time code
5. Press Enter to open browser
6. Paste the code in the browser
7. Authorize GitHub CLI

### Verify User

Ensure you're authenticated as the correct user:

```bash
gh api user -q .login
```

**Expected output:**
```
Fatih0234
```

---

## Quick Prerequisites Check

Run this single command to check everything:

```bash
echo "=== Checking Prerequisites ===" && \
echo "bun:" && bun --version && \
echo "" && \
echo "npm:" && npm --version && \
echo "" && \
echo "git:" && git --version && \
echo "" && \
echo "gh:" && gh --version | head -1 && \
echo "" && \
echo "GitHub auth:" && gh auth status
```

**If all checks pass, you're ready to proceed!**

---

## Common Issues

### "command not found: bun"

**Cause:** bun is installed but not in PATH

**Fix:**
```bash
export PATH="$HOME/.bun/bin:$PATH"
echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
```

### "gh auth status" shows "You are not logged into any GitHub hosts"

**Cause:** Not authenticated with GitHub

**Fix:**
```bash
gh auth login
```

### Permission denied when running bun

**Cause:** bun binary doesn't have execute permissions

**Fix:**
```bash
chmod +x ~/.bun/bin/bun
```

---

## Next Steps

Once all prerequisites are met:

1. Run the [automated setup script](../setup.sh)
2. Or follow the [Step-by-Step Guide](./STEP-BY-STEP.md)
