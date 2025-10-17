# GitHub Repository Setup Guide
**Purpose**: Connect local repository to GitHub remote  
**Version**: 1.0.0  
**Last Updated**: 2025-10-17

---

## Prerequisites

- [x] Local Git repository initialized (`git init`)
- [x] Initial commit created (`264b645`)
- [ ] GitHub account created
- [ ] GitHub CLI installed (optional but recommended)

---

## Option 1: GitHub CLI (Recommended)

### 1.1 Install GitHub CLI

**Windows (PowerShell)**:
```powershell
winget install --id GitHub.cli
```

**Verify Installation**:
```powershell
gh --version
```

### 1.2 Authenticate with GitHub

```powershell
gh auth login
```

Follow prompts:
1. Select: `GitHub.com`
2. Select: `HTTPS`
3. Authenticate: `Login with a web browser`
4. Copy one-time code
5. Press Enter, browser opens
6. Paste code, authorize

### 1.3 Create Repository and Push

```powershell
cd C:\devspo

# Create public repository
gh repo create devspo --public --source=. --remote=origin --push

# Or create private repository
gh repo create devspo --private --source=. --remote=origin --push
```

**What this does**:
- Creates `devspo` repository on your GitHub account
- Sets up `origin` remote
- Pushes `master` branch
- Sets upstream tracking

### 1.4 Verify Setup

```powershell
# Check remote configuration
git remote -v

# Should show:
# origin  https://github.com/yourusername/devspo.git (fetch)
# origin  https://github.com/yourusername/devspo.git (push)

# Check branch tracking
git branch -vv

# Should show:
# * master 264b645 [origin/master] chore: Initial professional workspace setup
```

---

## Option 2: Manual Setup (Web Interface)

### 2.1 Create Repository on GitHub

1. Visit https://github.com/new
2. Repository name: `devspo`
3. Description: "Professional workspace for keyboard fix scripts and development projects"
4. Visibility: 
   - **Public**: Anyone can see this repository
   - **Private**: Only you (and collaborators) can see
5. **Do NOT** initialize with README, .gitignore, or license (we already have these)
6. Click **Create repository**

### 2.2 Add Remote and Push

```powershell
cd C:\devspo

# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/devspo.git

# Verify remote
git remote -v

# Push to GitHub
git push -u origin master
```

**Expected Output**:
```
Enumerating objects: 78, done.
Counting objects: 100% (78/78), done.
Delta compression using up to 8 threads
Compressing objects: 100% (71/71), done.
Writing objects: 100% (78/78), 1.23 MiB | 2.50 MiB/s, done.
Total 78 (delta 5), reused 0 (delta 0), pack-reused 0
To https://github.com/YOUR_USERNAME/devspo.git
 * [new branch]      master -> master
Branch 'master' set up to track remote branch 'master' from 'origin'.
```

### 2.3 Verify on GitHub

Visit: `https://github.com/YOUR_USERNAME/devspo`

You should see:
- ✅ README.md rendered with badges
- ✅ 60 files
- ✅ Commit: "chore: Initial professional workspace setup"
- ✅ Directory structure visible

---

## Option 3: SSH Authentication (Advanced)

### 3.1 Generate SSH Key (if not exists)

```powershell
# Check for existing keys
Test-Path ~/.ssh/id_ed25519.pub

# If false, generate new key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Press Enter for default location
# Set passphrase (optional but recommended)
```

### 3.2 Add SSH Key to GitHub

```powershell
# Copy public key to clipboard
Get-Content ~/.ssh/id_ed25519.pub | Set-Clipboard
```

1. Visit https://github.com/settings/keys
2. Click **New SSH key**
3. Title: "Windows Dev Machine - devspo"
4. Key type: **Authentication Key**
5. Paste key from clipboard
6. Click **Add SSH key**

### 3.3 Test SSH Connection

```powershell
ssh -T git@github.com
```

Expected output:
```
Hi YOUR_USERNAME! You've successfully authenticated, but GitHub does not provide shell access.
```

### 3.4 Create Repository and Push

```powershell
cd C:\devspo

# Create repository via GitHub CLI or web interface first
# Then add SSH remote
git remote add origin git@github.com:YOUR_USERNAME/devspo.git

# Push
git push -u origin master
```

---

## Repository Settings Recommendations

### 1. Branch Protection (Post-Setup)

1. Visit: `https://github.com/YOUR_USERNAME/devspo/settings/branches`
2. Add rule for `master` branch:
   - ✅ Require pull request reviews before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require conversation resolution before merging

### 2. Repository Topics

Add topics for discoverability:
```
autohotkey
keyboard
windows
powershell
device-management
automation
system-utilities
```

### 3. About Section

**Description**:
```
Professional workspace for keyboard fix scripts, device management, and Windows automation
```

**Website**: (Your documentation site, if any)

**Topics**: See list above

### 4. Default Branch

Keep as `master` or rename to `main`:
```powershell
# Rename master to main (optional)
git branch -m master main
git push -u origin main
git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main

# Update default branch on GitHub:
# Settings > Branches > Default branch > Switch to main
```

---

## Workflow: Daily Git Operations

### Pull Latest Changes

```powershell
cd C:\devspo
git pull origin master
```

### Create Feature Branch

```powershell
# Create and switch to new branch
git checkout -b feature/fix-right-ctrl-shift

# Make changes...

# Stage and commit
git add .
git commit -m "fix: Resolve Right Ctrl + Shift key combination issue

- Investigated Raw Input API conflicts
- Implemented hybrid architecture
- Added device-specific filtering

Fixes #1"

# Push feature branch
git push -u origin feature/fix-right-ctrl-shift
```

### Create Pull Request

**Via GitHub CLI**:
```powershell
gh pr create --title "Fix: Right Ctrl + Shift issue" --body "Resolves #1"
```

**Via Web**:
1. Visit repository on GitHub
2. Click **Pull requests** > **New pull request**
3. Select `feature/fix-right-ctrl-shift` branch
4. Add title, description
5. Click **Create pull request**

### Merge Pull Request

```powershell
# Via GitHub CLI
gh pr merge 1 --squash

# Or merge via web interface
```

### Sync Local After Merge

```powershell
git checkout master
git pull origin master
git branch -d feature/fix-right-ctrl-shift  # Delete local branch
git push origin --delete feature/fix-right-ctrl-shift  # Delete remote branch
```

---

## Troubleshooting

### Issue: Authentication Failed

**Symptom**:
```
remote: Support for password authentication was removed on August 13, 2021.
fatal: Authentication failed
```

**Solution**: Use Personal Access Token (PAT) or SSH

**PAT Setup**:
1. Visit https://github.com/settings/tokens
2. Generate new token (classic)
3. Select scopes: `repo`, `workflow`
4. Copy token
5. Use token as password when pushing

**Store Credential**:
```powershell
git config --global credential.helper wincred
```

---

### Issue: Remote Already Exists

**Symptom**:
```
fatal: remote origin already exists.
```

**Solution**:
```powershell
# Remove existing remote
git remote remove origin

# Add correct remote
git remote add origin https://github.com/YOUR_USERNAME/devspo.git
```

---

### Issue: Push Rejected (Non-Fast-Forward)

**Symptom**:
```
error: failed to push some refs
hint: Updates were rejected because the remote contains work that you do not have locally
```

**Solution**:
```powershell
# Pull with rebase
git pull --rebase origin master

# Or force push (DANGEROUS - only if you're sure)
git push --force-with-lease origin master
```

---

## Next Steps After Setup

1. ✅ **Add GitHub Actions**: Create `.github/workflows/ci.yml` for automated testing
2. ✅ **Add Issue Templates**: `.github/ISSUE_TEMPLATE/bug_report.md`
3. ✅ **Add PR Template**: `.github/pull_request_template.md`
4. ✅ **Configure Dependabot**: `.github/dependabot.yml` (if using npm/pip)
5. ✅ **Add CONTRIBUTING.md**: Contribution guidelines
6. ✅ **Add SECURITY.md**: Security policy and vulnerability reporting

---

## Repository URL Examples

Replace `YOUR_USERNAME` with your actual GitHub username:

- **HTTPS**: `https://github.com/YOUR_USERNAME/devspo.git`
- **SSH**: `git@github.com:YOUR_USERNAME/devspo.git`
- **Web**: `https://github.com/YOUR_USERNAME/devspo`

---

**Setup Guide Version**: 1.0.0  
**Last Updated**: 2025-10-17  
**Reference**: ProjectManifest.md Phase 5
