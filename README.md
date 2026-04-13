# Oh My OpenAgent - AI Agent Setup Guide

> **This guide is for AI agents (Claude, GPT, etc.) helping users set up Oh My OpenAgent harness on a new VPS.**

This repository contains everything needed to configure a fresh VPS with Oh My OpenAgent, including all 8 project repositories, configurations, and dependencies.

---

## Quick Start (One-Liner)

```bash
curl -fsSL https://raw.githubusercontent.com/Fatih0234/omo-agent-setup-guide/main/setup.sh | bash
```

Or if you prefer to review first:

```bash
curl -fsSL https://raw.githubusercontent.com/Fih0234/omo-agent-setup-guide/main/setup.sh -o setup.sh && chmod +x setup.sh && ./setup.sh
```

---

## Prerequisites Checklist

Before running the setup, verify these are installed:

- [ ] **bun** - JavaScript runtime and package manager
- [ ] **npm** - Node package manager (backup for bun)
- [ ] **gh** - GitHub CLI (authenticated)
- [ ] **git** - Version control

**Quick check:**
```bash
bun --version && npm --version && gh auth status && git --version
```

📖 [Full Prerequisites Guide →](./docs/PREREQUISITES.md)

---

## What Gets Installed

The setup script will:

1. **Install Oh My OpenAgent** via `bunx oh-my-opencode`
2. **Download configurations** from `Fatih0234/omo-configs`
3. **Clone all 8 project repositories**:
   - Project repositories under `Fatih0234/`
   - Including submodules for `pi-pomodoro`
4. **Install dependencies** for all projects
5. **Verify installation** with diagnostic checks

---

## Step-by-Step Manual Setup

If you prefer manual control or need to troubleshoot:

1. [Prerequisites](./docs/PREREQUISITES.md) - Check and install requirements
2. [Step-by-Step Guide](./docs/STEP-BY-STEP.md) - Detailed walkthrough
3. [Troubleshooting](./docs/TROUBLESHOOTING.md) - Common issues and fixes
4. [Verification](./docs/VERIFICATION.md) - Confirm everything works

---

## Repository Structure

```
omo-agent-setup-guide/
├── README.md                 # This file - start here
├── setup.sh                  # Automated setup script
├── docs/
│   ├── PREREQUISITES.md      # Required tools and installation
│   ├── STEP-BY-STEP.md       # Detailed instructions
│   ├── TROUBLESHOOTING.md    # Problem solving
│   └── VERIFICATION.md       # Testing the setup
└── examples/
    └── sample-session.md     # Real AI agent session example
```

---

## For AI Agents

When helping a user set up Oh My OpenAgent:

1. **Check prerequisites** first - run the quick check command above
2. **Use the automated script** if all prerequisites are met
3. **Follow the step-by-step guide** if manual intervention is needed
4. **Verify with the user** that they can access their projects

📖 [See Example Session →](./examples/sample-session.md)

---

## Important Notes

- **GitHub Authentication**: The `gh` CLI must be authenticated as `Fatih0234` to access private repos
- **API Keys**: This guide does NOT include API keys - those must be configured separately
- **Fireworks AI**: Uses Kimi K2.5 Turbo model
- **OpenAI**: Uses GPT 5.4 model
- **Submodules**: `pi-pomodoro` requires submodule initialization

---

## Support

If you encounter issues:

1. Check [TROUBLESHOOTING.md](./docs/TROUBLESHOOTING.md)
2. Verify prerequisites with [PREREQUISITES.md](./docs/PREREQUISITES.md)
3. Run verification steps in [VERIFICATION.md](./docs/VERIFICATION.md)

---

**Ready to start?** Run the quick start command above or read the [Step-by-Step Guide](./docs/STEP-BY-STEP.md).
