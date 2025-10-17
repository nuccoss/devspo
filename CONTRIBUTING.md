# Contributing to devspo

First off, thank you for considering contributing to this project! 🎉

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)

---

## Code of Conduct

This project adheres to a code of conduct that all contributors are expected to uphold:

- **Be respectful**: Treat all contributors with respect and consideration
- **Be collaborative**: Work together to solve problems
- **Be professional**: Focus on constructive feedback
- **Be inclusive**: Welcome diverse perspectives and experiences

---

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates.

**Good Bug Reports Include**:
- Clear, descriptive title
- Steps to reproduce
- Expected vs actual behavior
- Environment details (Windows version, AutoHotkey version, etc.)
- Screenshots or error logs if applicable

**Template**:
```markdown
## Bug Description
[Clear description of the bug]

## Steps to Reproduce
1. Step one
2. Step two
3. ...

## Expected Behavior
[What you expected to happen]

## Actual Behavior
[What actually happened]

## Environment
- OS: Windows 11 Pro 23H2
- AutoHotkey: v2.0.x
- Script: SelectiveLeftCtrlBlocker.ahk v1.2.3

## Additional Context
[Screenshots, logs, etc.]
```

---

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues.

**Good Enhancement Suggestions Include**:
- Clear use case
- Benefits to users
- Potential implementation approach
- Any concerns or trade-offs

---

### Contributing Code

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/your-feature-name`
3. **Make your changes**
4. **Test thoroughly**
5. **Commit with conventional commits**
6. **Push and create pull request**

---

## Development Setup

### Prerequisites

- Windows 10/11
- [AutoHotkey v2.0+](https://www.autohotkey.com/)
- PowerShell 5.1+ or PowerShell Core 7+
- Git 2.30+
- Visual Studio Code (recommended)

### Clone and Setup

```powershell
# Clone repository
git clone https://github.com/YOUR_USERNAME/devspo.git
cd devspo

# Review project structure
Get-ChildItem -Recurse -Depth 2

# Read documentation
code README.md
code .agent/ProjectManifest.md
```

### Running Scripts

```powershell
# Test SelectiveLeftCtrlBlocker
cd "キーボード修正スクリプト"
.\SelectiveLeftCtrlBlocker.ahk

# Check process
Get-Process -Name "AutoHotkey*"

# View statistics (right-click tray icon → "📊 統計情報")
```

---

## Coding Standards

### AutoHotkey v2

**Naming Conventions**:
```ahk
; Global variables: SCREAMING_SNAKE_CASE
global DEBUG_MODE := false
global INTERNAL_KEYBOARD_PATTERNS := ["ACPI", "VEN_MSI"]

; Local variables: camelCase
deviceName := "Logitech K270"
isBluetoothDevice := true

; Functions: PascalCase
IsInternalKeyboard(deviceName) {
    ; ...
}

; Hotkeys: Use Send notation
LCtrl::HandleLeftCtrl()
```

**Comments**:
```ahk
; Single-line comments for brief explanations

; Multi-line comment blocks for complex logic
; Line 1 explanation
; Line 2 explanation
```

**Error Handling**:
```ahk
try {
    ; Risky operation
    result := DllCall("SomeFunction")
} catch Error as err {
    OutputDebug("Error: " err.Message)
    return false
}
```

---

### PowerShell

**Naming Conventions**:
```powershell
# Functions: Verb-Noun PascalCase
function Get-KeyboardDevice {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DeviceName
    )
    # ...
}

# Variables: camelCase
$deviceList = @()
$isRunning = $true
```

**Error Handling**:
```powershell
try {
    # Risky operation
    $result = Get-Process -Name "AutoHotkey*" -ErrorAction Stop
} catch {
    Write-Error "Failed to get process: $_"
    return
}
```

**Script Headers**:
```powershell
<#
.SYNOPSIS
    Brief description

.DESCRIPTION
    Detailed description

.PARAMETER ParameterName
    Parameter description

.EXAMPLE
    Example usage
#>
```

---

### Markdown Documentation

**Conventions**:
- Use `#` for title (H1), `##` for sections (H2), `###` for subsections (H3)
- Use `**bold**` for emphasis, `*italic*` for subtle emphasis
- Use `` `code` `` for inline code, ` ```language ` for code blocks
- Use `---` for horizontal rules
- Use `- [ ]` for task lists

**File Naming**:
- kebab-case for documentation: `troubleshooting-guide.md`
- UPPERCASE for special files: `README.md`, `LICENSE`, `CONTRIBUTING.md`

---

## Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/).

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic changes)
- `refactor`: Code refactoring (no feature/bug changes)
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (dependencies, build, etc.)
- `ci`: CI/CD changes

### Scope (Optional)

- `keyboard`: Keyboard scripts
- `docs`: Documentation
- `ci`: CI/CD
- `agent`: Agent infrastructure

### Examples

```bash
# Feature
git commit -m "feat(keyboard): Add support for multiple Bluetooth keyboards"

# Bug fix
git commit -m "fix(keyboard): Resolve Right Ctrl + Shift combination issue

- Investigated Raw Input API conflicts
- Implemented hybrid architecture pattern
- Added device-specific filtering

Fixes #1"

# Documentation
git commit -m "docs: Update troubleshooting guide with new diagnostics"

# Refactoring
git commit -m "refactor(keyboard): Extract device detection into separate function"

# Chore
git commit -m "chore: Update .gitignore with new patterns"
```

---

## Pull Request Process

### Before Submitting

1. **Test your changes thoroughly**
   - Run all relevant scripts
   - Check for regressions
   - Test edge cases

2. **Update documentation**
   - Update README.md if needed
   - Update CHANGELOG.md
   - Add inline comments for complex logic

3. **Run code formatting**
   - AutoHotkey: Follow style guide
   - PowerShell: Use `Invoke-Formatter` if available

4. **Self-review your code**
   - Remove debug code
   - Check for hardcoded values
   - Ensure error handling

### PR Title

Follow conventional commit format:
```
feat(keyboard): Add multi-device support
fix(docs): Correct installation instructions
```

### PR Description Template

```markdown
## Description
[Clear description of what this PR does]

## Motivation and Context
[Why is this change needed? What problem does it solve?]

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## How Has This Been Tested?
- [ ] Manual testing
- [ ] Automated tests
- [ ] Tested on Windows 10
- [ ] Tested on Windows 11

## Checklist
- [ ] My code follows the style guidelines
- [ ] I have performed a self-review
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have updated the documentation
- [ ] My changes generate no new warnings
- [ ] I have tested my changes

## Related Issues
Fixes #1
Closes #2
Related to #3
```

### Review Process

1. **Automated Checks**: CI/CD will run automated checks
2. **Code Review**: Maintainers will review your code
3. **Feedback**: Address any feedback or requested changes
4. **Approval**: Once approved, maintainers will merge

### After Merge

1. **Pull latest changes**: `git pull origin master`
2. **Delete feature branch**: `git branch -d feature/your-feature`
3. **Celebrate!** 🎉

---

## Development Workflow

### Creating a Feature

```powershell
# 1. Update master
git checkout master
git pull origin master

# 2. Create feature branch
git checkout -b feature/my-awesome-feature

# 3. Make changes
# ... edit files ...

# 4. Test changes
.\SelectiveLeftCtrlBlocker.ahk
# ... verify functionality ...

# 5. Commit changes
git add .
git commit -m "feat(keyboard): Add my awesome feature"

# 6. Push branch
git push -u origin feature/my-awesome-feature

# 7. Create pull request on GitHub
```

### Fixing a Bug

```powershell
# 1. Create bugfix branch from master
git checkout master
git pull origin master
git checkout -b fix/issue-123-bug-description

# 2. Reproduce bug
# ... follow reproduction steps ...

# 3. Fix bug
# ... edit files ...

# 4. Verify fix
# ... test thoroughly ...

# 5. Commit with issue reference
git commit -m "fix(keyboard): Resolve issue #123

- Root cause analysis
- Solution implementation
- Added safeguards

Fixes #123"

# 6. Push and create PR
git push -u origin fix/issue-123-bug-description
```

---

## Questions or Need Help?

- 📖 Read the [README.md](README.md)
- 📚 Check [ProjectManifest.md](.agent/ProjectManifest.md)
- 🐛 Search [existing issues](https://github.com/YOUR_USERNAME/devspo/issues)
- 💬 Create a [new issue](https://github.com/YOUR_USERNAME/devspo/issues/new)

---

**Thank you for contributing!** 🙏

Your efforts help make this project better for everyone.

---

**Version**: 1.0.0  
**Last Updated**: 2025-10-17  
**Reference**: ProjectManifest.md Article IV (Quality Standards)
