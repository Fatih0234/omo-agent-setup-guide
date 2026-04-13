# Troubleshooting Guide

Common issues and solutions when setting up Oh My OpenAgent.

---

## GitHub Authentication Issues

### Issue: "gh auth login" fails or times out

**Symptoms:**
```
Failed to authenticate via web browser
```

**Solutions:**

1. **Try token-based authentication:**
```bash
gh auth login --with-token
```
Then paste your GitHub Personal Access Token.

2. **Create a token manually:**
   - Go to https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Select scopes: `repo`, `read:org`, `gist`, `workflow`
   - Generate and copy the token
   - Use: `gh auth login --with-token` and paste it

3. **Check browser availability:**
```bash
# If running on headless VPS, use:
gh auth login --web
# Then manually open the URL on your local machine
```

---

### Issue: "Could not resolve to a Repository"

**Symptoms:**
```
GraphQL: Could not resolve to a Repository with the name 'Fatih0234/omo-configs'.
```

**Solutions:**

1. **Verify repository exists:**
```bash
gh repo view Fatih0234/omo-configs
```

2. **Check authentication user:**
```bash
gh api user -q .login
```
Should return `Fatih0234`

3. **Re-authenticate if wrong user:**
```bash
gh auth logout
gh auth login
```

4. **Check repository permissions:**
   - Ensure the repository is not private without access
   - Verify your token has `repo` scope

---

## bun/bunx Issues

### Issue: "bunx command not found"

**Symptoms:**
```
bash: bunx: command not found
```

**Solutions:**

1. **Check bun installation:**
```bash
ls -la ~/.bun/bin/
```

2. **Add to PATH:**
```bash
export PATH="$HOME/.bun/bin:$PATH"
echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

3. **Reinstall bun if needed:**
```bash
curl -fsSL https://bun.sh/install | bash
```

---

### Issue: "oh-my-opencode: command not found"

**Symptoms:**
```
bash: oh-my-opencode: command not found
```

**Solutions:**

1. **Install via bunx:**
```bash
bunx oh-my-opencode --version
```

2. **Check if binary exists:**
```bash
ls -la ~/.bun/bin/oh-my-opencode
```

3. **Add bun bin to PATH:**
```bash
echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

4. **Use bunx directly:**
```bash
alias oh-my-opencode='bunx oh-my-opencode'
echo "alias oh-my-opencode='bunx oh-my-opencode'" >> ~/.bashrc
```

---

## Permission Denied Errors

### Issue: "Permission denied" when running setup.sh

**Symptoms:**
```
bash: ./setup.sh: Permission denied
```

**Solution:**
```bash
chmod +x setup.sh
./setup.sh
```

---

### Issue: "Permission denied" when cloning repositories

**Symptoms:**
```
fatal: could not create work tree dir 'project-name': Permission denied
```

**Solutions:**

1. **Check directory permissions:**
```bash
ls -la ~/projects/
```

2. **Fix ownership:**
```bash
sudo chown -R $USER:$USER ~/projects/
```

3. **Create directory with correct permissions:**
```bash
mkdir -p ~/projects
chmod 755 ~/projects
```

---

## Submodule Clone Issues

### Issue: "Submodule failed to clone"

**Symptoms:**
```
fatal: clone of 'https://github.com/...' into submodule path '...' failed
```

**Solutions:**

1. **Initialize submodules recursively:**
```bash
cd pi-pomodoro
git submodule update --init --recursive --force
```

2. **Clean and re-initialize:**
```bash
cd pi-pomodoro
git submodule deinit -f .
git submodule update --init --recursive
```

3. **Clone with submodules:**
```bash
gh repo clone Fatih0234/pi-pomodoro -- --recursive
```

4. **Check submodule URLs:**
```bash
cat .gitmodules
```

---

### Issue: "Submodule path not found"

**Symptoms:**
```
fatal: not a git repository: ../../.git/modules/...
```

**Solution:**
```bash
cd pi-pomodoro
rm -rf .git/modules/
git submodule update --init --recursive
```

---

## Config File Conflicts

### Issue: "Config file already exists"

**Symptoms:**
Setup script warns about existing config files.

**Solutions:**

1. **Backup existing config:**
```bash
mv ~/.config/oh-my-opencode ~/.config/oh-my-opencode.backup.$(date +%Y%m%d)
mkdir -p ~/.config/oh-my-opencode
```

2. **Merge configs manually:**
```bash
# Compare old and new
diff ~/.config/oh-my-opencode.backup.*/config.json ~/.config/oh-my-opencode/config.json

# Manually merge important settings
```

3. **Force overwrite (careful!):**
```bash
rm -rf ~/.config/oh-my-opencode/*
cp /tmp/omo-configs/* ~/.config/oh-my-opencode/
```

---

### Issue: "Invalid JSON in config file"

**Symptoms:**
```
SyntaxError: Unexpected token in JSON
```

**Solutions:**

1. **Validate JSON:**
```bash
cat ~/.config/oh-my-opencode/config.json | python3 -m json.tool
```

2. **Fix or restore:**
```bash
# Re-clone configs
rm -rf /tmp/omo-configs
gh repo clone Fatih0234/omo-configs /tmp/omo-configs
cp /tmp/omo-configs/* ~/.config/oh-my-opencode/
```

---

## Network and Connectivity Issues

### Issue: "Connection timed out" during clone

**Solutions:**

1. **Check internet connection:**
```bash
ping github.com
```

2. **Try HTTPS instead of SSH:**
```bash
gh repo clone Fatih0234/repo-name -- --https
```

3. **Increase git buffer size:**
```bash
git config --global http.postBuffer 524288000
```

4. **Retry with shallow clone:**
```bash
gh repo clone Fatih0234/repo-name -- --depth 1
```

---

### Issue: "Rate limit exceeded"

**Symptoms:**
```
API rate limit exceeded
```

**Solutions:**

1. **Wait and retry:**
   - Unauthenticated: 60 requests/hour
   - Authenticated: 5000 requests/hour

2. **Verify authentication:**
```bash
gh auth status
```

3. **Use token with higher limits:**
   - Create a token at https://github.com/settings/tokens
   - Use `gh auth login --with-token`

---

## Dependency Installation Issues

### Issue: "bun install" fails

**Solutions:**

1. **Try npm instead:**
```bash
npm install
```

2. **Clear cache:**
```bash
bun pm cache rm
bun install
```

3. **Check package.json:**
```bash
cat package.json | python3 -m json.tool
```

4. **Install with verbose output:**
```bash
bun install --verbose
```

---

### Issue: "node_modules permission denied"

**Solution:**
```bash
# Remove and reinstall
rm -rf node_modules
rm package-lock.json
bun install
```

---

## Still Having Issues?

If none of these solutions work:

1. **Check the [Prerequisites Guide](./PREREQUISITES.md)**
2. **Run verification steps in [VERIFICATION.md](./VERIFICATION.md)**
3. **Review the [Step-by-Step Guide](./STEP-BY-STEP.md)**
4. **Check GitHub status:** https://www.githubstatus.com/

---

## Debug Information

When reporting issues, include:

```bash
# System info
uname -a

# Tool versions
bun --version
npm --version
git --version
gh --version

# GitHub auth status
gh auth status

# Environment
env | grep -E '(PATH|HOME|USER)'
```
