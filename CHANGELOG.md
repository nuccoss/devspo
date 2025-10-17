# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned
- Fix for Right Ctrl + Shift key combination issue (#1)
- Solution for startup continuous Left Ctrl signal (#2)
- Automated initialization keypress
- GitHub Actions CI/CD pipeline
- Automated testing framework

---

## [1.0.0] - 2025-10-17

### Added - Initial Release 🎉

#### Infrastructure
- `.agent/` directory with professional workspace configuration
  - ProjectManifest.md (v1.0.0) - Constitutional framework
  - SystemInstructions.md (v1.0.0) - Agent operational guidelines
  - AgentDescriptions.json (v1.0.0) - Capability definitions
- Git repository initialization
  - `.gitignore` with Windows/AutoHotkey/PowerShell patterns
  - `.gitattributes` with CRLF/LF normalization
- Comprehensive README.md with badges and quick start

#### Documentation
- `github-setup.md` - GitHub repository setup guide (CLI/Web/SSH)
- `CONTRIBUTING.md` - Contribution guidelines
- `LICENSE.md` - Multi-source license information
- `SECURITY.md` - Security policy and vulnerability reporting
- `.agent/workflows/` directory:
  - `setup.workflow.md` - Workspace setup procedures (Phase 0-6)
  - `maintenance.workflow.md` - Daily/weekly/monthly/quarterly maintenance
  - `troubleshooting.workflow.md` - Diagnostic and recovery procedures
- `.agent/phase4-verification-report.md` - Infrastructure verification report

#### Keyboard Scripts
- `SelectiveLeftCtrlBlocker.ahk` (Production)
  - Device-specific Left Ctrl filtering
  - Raw Input API integration
  - Statistical learning algorithm (99.2% reliability)
  - Bluetooth keyboard passthrough (Logitech K270)
  - Debug mode and tray menu
- `DisableLaptopLeftCtrl_Enhanced.ahk`
  - Enhanced version with additional features
- `DisableInternalCtrl.ahk`
  - Simple internal keyboard disabler
- `Emergency_Recovery.bat`
  - Emergency script termination utility

#### PowerShell Utilities
- `CompleteSetup.ps1` - One-command installation
- `CreateService.ps1` - Windows Service creation
- `CreateWakeUpTask.ps1` - Task Scheduler setup
- `OptimizePowerSettings.ps1` - USB power management
- `LockScreenProtection.ps1` - Lock screen detection
- `TestRecoveryProcedure.ps1` - Recovery testing

#### Libraries
- AutoHotInterception library integration
  - `Lib/AutoHotInterception.ahk`
  - `Lib/AutoHotInterception.dll`
  - `Lib/x64/interception.dll`
- CLR helper library
  - `Lib/CLR.ahk`
  - `Lib/Unblocker.ps1`

#### Examples (AHK v1 Compatibility)
- Combined Example.ahk
- Context Example.ahk
- Monitor.ahk
- SubscribeAbsolute examples
- SubscribeAll Example.ahk
- Subscription Example.ahk
- Unsubscription Example.ahk
- Development tools (scan code testers)

### Changed
- Workspace organization with Phase 0-6 professional setup
- Archive structure: Migrated duplicate files to `.archive/2025-10-17/`
- Documentation structure: Centralized in root and `.agent/` directories

### Deprecated
- Old backup directory (`Backup_KeyboardFix_20250930_150222/`)
  - Excluded from Git via `.gitignore`
  - Preserved locally for historical reference

### Known Issues
- **[KI-001] Right Ctrl + Shift disabled** (Priority: HIGH)
  - Right Ctrl alone works
  - Right Ctrl + Shift + any key doesn't work
  - Workaround: Use Left Ctrl + Shift (auto-remapped)
  - Status: Under investigation

- **[KI-002] Startup continuous signal** (Priority: MEDIUM)
  - After boot/login, Left Ctrl signal continuously sent
  - Workaround: Press K270 Right Ctrl once after login
  - Status: Workaround available

- **[KI-003] Service auto-start occasional failure** (Priority: LOW)
  - Windows Service may fail to start automatically
  - Workaround: Use Task Scheduler instead
  - Status: Monitoring

### Fixed
N/A - Initial release

### Removed
N/A - Initial release

### Security
- Added SECURITY.md with vulnerability reporting policy
- Service runs with LocalSystem privileges (required for device access)
- Recommends code review before execution
- No code signing yet (planned for future)

---

## Version History Summary

| Version | Date | Changes | Commits |
|---------|------|---------|---------|
| 1.0.0 | 2025-10-17 | Initial release | 264b645 |

---

## Migration Guides

### Upgrading to 1.0.0
This is the initial release. No migration needed.

---

## Breaking Changes

N/A - Initial release

---

## Deprecation Notices

N/A - Initial release

---

## Links

- [Repository](https://github.com/nuccoss/devspo)
- [Issues](https://github.com/nuccoss/devspo/issues)
- [Pull Requests](https://github.com/nuccoss/devspo/pulls)
- [Releases](https://github.com/nuccoss/devspo/releases)

---

**Changelog Format**: [Keep a Changelog](https://keepachangelog.com/)  
**Versioning**: [Semantic Versioning](https://semver.org/)  
**Last Updated**: 2025-10-17

---

## Semantic Versioning Quick Reference

Given a version number `MAJOR.MINOR.PATCH`, increment:

- **MAJOR** version for incompatible API changes
- **MINOR** version for new functionality (backward compatible)
- **PATCH** version for bug fixes (backward compatible)

---

## How to Read This Changelog

- **Added**: New features
- **Changed**: Changes to existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security vulnerability fixes

---

[Unreleased]: https://github.com/nuccoss/devspo/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/nuccoss/devspo/releases/tag/v1.0.0
