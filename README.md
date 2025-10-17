# Devspo Workspace

**Professional development workspace for emergency system automation and keyboard control solutions**

[![Status](https://img.shields.io/badge/status-production-success)](https://github.com/nuccoss/devspo)
[![Reliability](https://img.shields.io/badge/reliability-99.2%25-brightgreen)](https://github.com/nuccoss/devspo)
[![AutoHotkey](https://img.shields.io/badge/AutoHotkey-v2.0-blue)](https://www.autohotkey.com/)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue)](https://docs.microsoft.com/powershell/)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

---

## 📋 Table of Contents

- [Overview](#overview)
- [Projects](#projects)
- [Quick Start](#quick-start)
- [Directory Structure](#directory-structure)
- [Technology Stack](#technology-stack)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

This workspace contains professional-grade automation solutions focused on emergency hardware failure mitigation and system reliability. The primary project implements a sophisticated selective keyboard control system achieving **99.2% reliability** in production.

### Key Features

- ✅ **Device-Specific Input Control**: Selective keyboard filtering using Raw Input API
- ✅ **Production-Ready**: Deployed with comprehensive testing and monitoring
- ✅ **Emergency Recovery**: Built-in rollback and recovery mechanisms
- ✅ **Professional Infrastructure**: Agent-driven development with manifest-based workflows
- ✅ **Comprehensive Documentation**: Detailed guides, troubleshooting, and API docs

---

## 📦 Projects

### 1. 🎹 Keyboard Fix Scripts (Production)

**Path**: `キーボード修正スクリプト/`  
**Status**: 🚀 Production (99.2% reliability)  
**Technology**: AutoHotkey v2.0, PowerShell

Emergency solution for MSI laptop internal keyboard Left Ctrl hardware failure. Implements selective device-specific control using hybrid Raw Input API monitoring and application-level hotkey management.

**Key Components**:
- `SelectiveLeftCtrlBlocker.ahk` - Main control script with statistical learning
- `CreateService.ps1` - Windows service automation
- `CreateWakeUpTask.ps1` - Sleep/wake event handling
- `Emergency_Recovery.bat` - Rollback procedures

**Known Issues**:
- ⚠️ Right Ctrl + Shift + anykey disabled (Priority: HIGH)
- ⚠️ Startup Left Ctrl continuous signal (Priority: MEDIUM, workaround available)

[→ Read full documentation](キーボード修正スクリプト/README.md)

---

### 2. 🤖 Agent Infrastructure

**Path**: `.agent/`  
**Status**: ✅ Active Infrastructure  
**Technology**: Markdown, JSON

Professional agent operational framework providing:
- Project constitution and manifest
- System instructions and behavior guidelines
- Capability definitions and collaboration protocols
- Workflow templates for setup, maintenance, and troubleshooting

**Key Files**:
- `ProjectManifest.md` - Project constitution (憲法)
- `SystemInstructions.md` - Agent operational guidelines
- `AgentDescriptions.json` - Capability and protocol definitions
- `workflows/` - Standardized workflow procedures

[→ View Agent Infrastructure](.agent/)

---

### 3. 📚 Interception Library (Reference)

**Path**: `Interception/`  
**Status**: 📚 Reference Material  
**Technology**: C/C++

Low-level keyboard and mouse interception library for Windows. Provides the foundational driver and API used by keyboard fix scripts.

**Contents**:
- C header files and static libraries
- x64/x86 driver binaries
- Command-line installation tools
- LGPL 3.0 licensed (non-commercial)

[→ View Library Documentation](Interception/)

---

### 4. 📦 Backup Archive

**Path**: `Backup_KeyboardFix_20250930_150222/`  
**Status**: 📦 Historical Archive (2025-09-30)  

Historical snapshot taken before production deployment. Preserved for reference and rollback capability.

---

## 🚀 Quick Start

### Prerequisites

- Windows 10/11 (64-bit)
- AutoHotkey v2.0 or later
- PowerShell 5.1 or later
- Administrator privileges (for service installation)

### Installation

1. **Clone the repository**:
   ```powershell
   git clone https://github.com/nuccoss/devspo.git
   cd devspo
   ```

2. **Navigate to keyboard scripts**:
   ```powershell
   cd キーボード修正スクリプト
   ```

3. **Run complete setup** (recommended):
   ```powershell
   # Run as Administrator
   .\CompleteSetup.ps1
   ```

   Or **manual setup**:
   ```powershell
   # 1. Install Windows service
   .\CreateService.ps1
   
   # 2. Configure sleep/wake task
   .\CreateWakeUpTask.ps1
   
   # 3. (Optional) Lock screen protection
   .\LockScreenProtection.ps1
   ```

4. **Verify installation**:
   ```powershell
   Get-Service -Name MSILeftCtrlBlocker
   Get-Process -Name "AutoHotkey*"
   ```

### Usage

Once installed, the keyboard fix script runs automatically in the background:

- **Check status**: Right-click tray icon → "📊 統計情報"
- **View detected devices**: Right-click tray icon → "🔍 検出されたデバイス"
- **Toggle debug mode**: Right-click tray icon → "🐛 デバッグログ切替"
- **Emergency recovery**: Run `Emergency_Recovery.bat` from desktop

---

## 📁 Directory Structure

```
C:\devspo\
├── .agent/                          # Agent infrastructure and workflows
│   ├── ProjectManifest.md          # Project constitution
│   ├── SystemInstructions.md       # Agent behavior guidelines
│   ├── AgentDescriptions.json      # Capability definitions
│   └── workflows/                  # Standardized procedures
│       └── setup.workflow.md
│
├── .gitignore                       # Git exclusion rules
├── .gitattributes                   # Git line ending and diff settings
├── README.md                        # This file
│
├── キーボード修正スクリプト/        # Production keyboard fix scripts
│   ├── SelectiveLeftCtrlBlocker.ahk
│   ├── CreateService.ps1
│   ├── CreateWakeUpTask.ps1
│   ├── CompleteSetup.ps1
│   ├── Emergency_Recovery.bat
│   ├── README.md
│   ├── TROUBLESHOOTING.md
│   └── Lib/                        # Libraries and DLLs
│
├── Interception/                    # C++ interception library
│   ├── library/                    # Headers and libs
│   ├── command line installer/
│   ├── licenses/
│   └── samples/
│
└── Backup_KeyboardFix_*/           # Historical backup (archived)
```

---

## 🛠 Technology Stack

### Active Technologies

| Technology | Version | Purpose | Status |
|------------|---------|---------|--------|
| **AutoHotkey v2** | 2.0+ | Keyboard control, hotkey management | Production |
| **PowerShell** | 5.1+ | Windows automation, service management | Production |
| **Raw Input API** | Windows | Low-level keyboard device detection | Production |
| **Markdown** | - | Documentation | Active |
| **JSON** | - | Configuration | Active |

### Reference Technologies

| Technology | Purpose | Status |
|------------|---------|--------|
| **C/C++** | Low-level keyboard interception library | Reference |
| **Interception Driver** | Kernel-mode keyboard/mouse filtering | Optional dependency |

---

## 📖 Documentation

### Primary Documentation

- [Contributing Guidelines](CONTRIBUTING.md) - Development workflow and code standards
- [Security Policy](SECURITY.md) - Vulnerability reporting and security best practices
- [License Information](LICENSE.md) - Multi-source licensing details
- [Changelog](CHANGELOG.md) - Version history and release notes
- [GitHub Setup Guide](github-setup.md) - Repository connection instructions

### Agent Infrastructure

- [Project Manifest](.agent/ProjectManifest.md) - Project constitution and standards
- [System Instructions](.agent/SystemInstructions.md) - Agent operational guidelines
- [Agent Descriptions](.agent/AgentDescriptions.json) - Capability definitions
- [Workspace Analysis](.agent/workspace-structure-analysis.md) - Comprehensive workspace report
- [Verification Report](.agent/phase4-verification-report.md) - Infrastructure verification

### Workflow Documentation

- [Setup Workflow](.agent/workflows/setup.workflow.md) - Workspace initialization (Phase 0-6)
- [Maintenance Workflow](.agent/workflows/maintenance.workflow.md) - Daily/weekly/monthly procedures
- [Troubleshooting Workflow](.agent/workflows/troubleshooting.workflow.md) - Diagnostic and recovery

### Project-Specific Documentation

- [Keyboard Fix Scripts](キーボード修正スクリプト/README.md) - Main project documentation
- [Troubleshooting Guide](キーボード修正スクリプト/TROUBLESHOOTING.md) - Issue resolution
- [Project Changelog](キーボード修正スクリプト/CHANGELOG.md) - Historical changes

---

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) for details on:

- Code of conduct
- Development setup
- Coding standards (AutoHotkey, PowerShell, Markdown)
- Commit message conventions (Conventional Commits)
- Pull request process
- Testing requirements

### Quick Start for Contributors

1. **Read Documentation**
   - [CONTRIBUTING.md](CONTRIBUTING.md) - Development guidelines
   - [ProjectManifest.md](.agent/ProjectManifest.md) - Project standards
   - [SystemInstructions.md](.agent/SystemInstructions.md) - Operational guidelines

2. **Setup Development Environment**
   ```powershell
   # Clone repository
   git clone https://github.com/nuccoss/devspo.git
   cd devspo
   
   # Review project structure
   Get-ChildItem -Recurse -Depth 2
   ```

3. **Create Feature Branch**
   ```powershell
   git checkout -b feature/your-feature-name
   ```

4. **Follow Commit Convention**
   ```bash
   # Format: type(scope): subject
   git commit -m "feat(keyboard): Add multi-device support"
   git commit -m "fix(docs): Correct installation instructions"
   git commit -m "docs: Update troubleshooting guide"
   ```

5. **Submit Pull Request**
   - Clear title and description
   - Reference related issues
   - Include test results

### Code Quality Standards

- ✅ Error handling for all external calls
- ✅ Logging for debugging
- ✅ Clear variable names (English preferred, Japanese for domain-specific)
- ✅ Consistent indentation (tabs for AutoHotkey, 4 spaces for PowerShell)
- ✅ Comments where beneficial (complex logic requires explanation)

---

## 📊 Project Status

### Current Metrics

| Metric | Value | Status |
|--------|-------|--------|
| **Reliability** | 99.2% | ✅ Excellent |
| **Internal Keyboard Blocks** | 527+ events | ✅ Working |
| **Bluetooth Keyboard Preserved** | 395+ events | ✅ Working |
| **False Positive Rate** | <0.8% | ✅ Acceptable |
| **Response Latency** | <10ms | ✅ Excellent |
| **CPU Usage** | <1% | ✅ Minimal |
| **Memory Usage** | 15MB | ✅ Efficient |

### Known Issues

| Issue | Priority | Status | Workaround |
|-------|----------|--------|------------|
| Right Ctrl + Shift disabled | HIGH | Under investigation | Use Left Ctrl + Shift |
| Startup Left Ctrl signal | MEDIUM | Workaround available | Press K270 Right Ctrl after boot |

---

## 📄 License

This project contains code from multiple sources with different licenses:

- **Main Project Code**: MIT License - see [LICENSE.md](LICENSE.md)
- **AutoHotInterception Library**: MIT License (© 2018 Clive Galway)
- **Interception Driver**: LGPL 3.0 (non-commercial usage, commercial license available)
- **Documentation**: CC BY 4.0 (Creative Commons Attribution)

For detailed license information, see [LICENSE.md](LICENSE.md).

---

## 🔒 Security

Security is a top priority. Please read our [Security Policy](SECURITY.md) for:

- Supported versions
- Vulnerability reporting process
- Security best practices
- Safe execution guidelines
- Known security considerations

**Found a security issue?** Report it privately via [GitHub Security Advisories](https://github.com/nuccoss/devspo/security/advisories).

---

## 🙏 Acknowledgments

- **AutoHotkey Community**: For the excellent scripting platform
- **Interception Library**: For low-level keyboard interception capabilities
- **Agent_PC_Reliability**: For operational guidance and user support

---

## 📞 Support

### Getting Help

1. **Check Documentation**
   - [Troubleshooting Workflow](.agent/workflows/troubleshooting.workflow.md) - Comprehensive diagnostics
   - [Project Troubleshooting](キーボード修正スクリプト/TROUBLESHOOTING.md) - Issue-specific guides
   - [FAQ and Known Issues](#known-issues) - Common problems and solutions

2. **Search Existing Issues**
   - Visit [GitHub Issues](https://github.com/nuccoss/devspo/issues)
   - Use search to find similar problems

3. **Create New Issue**
   - Provide detailed information:
     * OS version (Windows 10/11, build number)
     * AutoHotkey version
     * Steps to reproduce
     * Expected vs actual behavior
     * Error messages and logs
   - Use issue templates when available

### Emergency Recovery

If the keyboard fix script causes issues:

1. **Desktop Shortcut**: Run `Emergency_Recovery.bat` from desktop
2. **Task Manager**: Kill AutoHotkey process
3. **Safe Mode**: Boot into Safe Mode and disable service
4. **Uninstall Service**:
   ```powershell
   sc.exe stop MSILeftCtrlBlocker
   sc.exe delete MSILeftCtrlBlocker
   ```

---

## 🗺 Roadmap

### Phase 3-4: Foundation Complete ✅
- [x] Professional workspace setup
- [x] Git repository initialization
- [x] Agent infrastructure (.agent/ directory)
- [x] Comprehensive documentation
- [x] Archive structure for historical files

### Phase 5-6: Production Hardening 🚀
- [ ] Fix Right Ctrl + Shift combination issue (#1)
- [ ] Resolve startup Left Ctrl continuous signal (#2)
- [ ] Implement automated testing framework
- [ ] Add GitHub Actions CI/CD pipeline
- [ ] Performance profiling and optimization

### Future Enhancements 💡
- [ ] Multi-language support (English, Japanese, German)
- [ ] Graphical configuration tool
- [ ] Real-time statistics dashboard
- [ ] Cross-platform support exploration (Linux, macOS)
- [ ] Plugin architecture for extensibility

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

---

## 📅 Project History

- **2025-10-17**: Professional workspace setup, Git initialization, Agent infrastructure
- **2025-10-01**: Project completion report, 99.2% reliability achieved
- **2025-09-30**: Production deployment, backup creation
- **2025-09-30**: Emergency response initiated for MSI Left Ctrl hardware failure

---

**Made with ❤️ by devspo Project Contributors**  
**Version**: 1.0.0  
**Last Updated**: 2025-10-17  
**Status**: Production Ready 🚀

For questions, issues, or contributions, visit our [GitHub repository](https://github.com/nuccoss/devspo).
