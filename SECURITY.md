# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0   | :x:                |

---

## Reporting a Vulnerability

We take security issues seriously. If you discover a security vulnerability, please follow these steps:

### 1. **Do NOT** Publicly Disclose

- Do not create a public GitHub issue
- Do not discuss on public forums
- Do not post on social media

### 2. Report Privately

**Preferred Method**: GitHub Security Advisories
1. Visit https://github.com/nuccoss/devspo/security/advisories
2. Click "Report a vulnerability"
3. Provide detailed information (see template below)

**Alternative Method**: Email
- Email: security@yourproject.com (replace with actual contact)
- Subject: `[SECURITY] Brief description`
- Use encryption if possible (PGP key available on request)

### 3. Vulnerability Report Template

```markdown
## Vulnerability Type
- [ ] Remote Code Execution
- [ ] Privilege Escalation
- [ ] Information Disclosure
- [ ] Denial of Service
- [ ] Other: [specify]

## Affected Component
- Script: [e.g., SelectiveLeftCtrlBlocker.ahk]
- Version: [e.g., 1.2.3]
- Platform: [e.g., Windows 11 23H2]

## Description
[Detailed description of the vulnerability]

## Steps to Reproduce
1. Step one
2. Step two
3. ...

## Impact
[What can an attacker do? What data is at risk?]

## Proof of Concept
[Code or screenshots demonstrating the issue]

## Suggested Fix
[If you have ideas for how to fix it]

## Your Environment
- OS: [e.g., Windows 11 Pro 23H2]
- AutoHotkey: [e.g., v2.0.11]
- Other relevant software versions
```

---

## Response Timeline

| Phase | Timeframe | Description |
|-------|-----------|-------------|
| **Acknowledgment** | 24 hours | We confirm receipt of your report |
| **Initial Assessment** | 3 days | We assess severity and impact |
| **Status Update** | 7 days | We provide investigation status |
| **Fix Development** | Variable | Depends on complexity |
| **Disclosure** | After fix | Coordinated public disclosure |

---

## Security Considerations

### Script Execution Context

**Elevated Privileges**:
- Some scripts require administrator privileges
- Review scripts before running with elevated permissions
- Use Windows Security features (SmartScreen, Windows Defender)

**Code Signing**: 
- Currently not code-signed
- Verify file hashes before execution (see README.md)

### Safe Execution Practices

```powershell
# 1. Verify file hash (example)
Get-FileHash "SelectiveLeftCtrlBlocker.ahk" -Algorithm SHA256

# Expected: [hash value from README.md]

# 2. Review script source code
code "SelectiveLeftCtrlBlocker.ahk"

# 3. Run in test environment first
# Create isolated VM or test machine

# 4. Monitor behavior
Get-Process -Name "AutoHotkey*"
```

---

## Known Security Features

### Device-Level Input Filtering

**Protection**:
- Uses Raw Input API for device identification
- Blocks inputs at device level (not application level)
- Cannot be bypassed by normal application input

**Limitations**:
- Kernel-level keyloggers can still intercept
- Physical hardware keyloggers cannot be detected
- Administrator privileges required for Interception driver

### Service Security

**MSILeftCtrlBlocker Service**:
- Runs with LocalSystem privileges (required for device access)
- Service binary path validation enforced
- Service can be stopped by administrators

**Recommendations**:
- Regularly review service configuration
- Use Task Scheduler instead if possible (lower privileges)
- Monitor service status: `Get-Service MSILeftCtrlBlocker`

---

## Security Best Practices

### For Users

1. **Source Verification**
   - Only download from official repository
   - Verify Git commit signatures (if available)
   - Check file hashes

2. **Environment Isolation**
   - Test on non-production machines first
   - Use VM for initial testing
   - Keep backups before installation

3. **Regular Updates**
   - Watch repository for security updates
   - Subscribe to GitHub release notifications
   - Review CHANGELOG.md for security fixes

4. **Access Control**
   - Limit who has admin access to your machine
   - Use strong passwords for Windows accounts
   - Enable BitLocker for disk encryption

### For Contributors

1. **Code Review**
   - All PRs require review before merge
   - Focus on security implications
   - Test with malicious inputs

2. **Dependency Management**
   - Keep AutoHotInterception library updated
   - Monitor for security advisories
   - Audit third-party code

3. **Secrets Management**
   - Never commit passwords or keys
   - Use environment variables for sensitive config
   - Use `.gitignore` to exclude sensitive files

4. **Input Validation**
   - Validate all external inputs
   - Sanitize file paths
   - Check registry values before use

---

## Security Updates

### Notification Channels

- **GitHub Security Advisories**: https://github.com/nuccoss/devspo/security/advisories
- **GitHub Releases**: https://github.com/nuccoss/devspo/releases
- **CHANGELOG.md**: Check for `[SECURITY]` tags

### Update Process

```powershell
# 1. Check for updates
cd C:\devspo
git fetch origin

# 2. Review changes
git log master..origin/master --oneline

# 3. Pull updates
git pull origin master

# 4. Restart scripts
Get-Process -Name "AutoHotkey*" | Stop-Process -Force
Start-Process "キーボード修正スクリプト\SelectiveLeftCtrlBlocker.ahk"
```

---

## Vulnerability Disclosure Policy

### Coordinated Disclosure

We follow **responsible disclosure** principles:

1. **Private Reporting**: Vulnerabilities reported privately first
2. **Investigation**: We investigate and develop fixes
3. **Fix Release**: Security update released
4. **Public Disclosure**: Details disclosed after users have time to update (typically 30 days)
5. **Credit**: Reporter credited (if desired)

### Public Disclosure Timeline

- **Critical vulnerabilities**: Disclosed after fix released + 7 days
- **High vulnerabilities**: Disclosed after fix released + 14 days
- **Medium/Low vulnerabilities**: Disclosed after fix released + 30 days

---

## Security Hall of Fame

We recognize security researchers who responsibly disclose vulnerabilities:

| Researcher | Vulnerability | Severity | Date |
|------------|--------------|----------|------|
| - | - | - | - |

*Want to be listed here? Report a valid security issue!*

---

## Out of Scope

The following are **not** considered security vulnerabilities:

- Attacks requiring physical access to the machine
- Issues in outdated/unsupported versions
- Social engineering attacks
- Denial of service against local hardware (unplugging keyboard)
- Issues in third-party dependencies (report to those projects)
- AutoHotkey runtime vulnerabilities (report to AutoHotkey project)

---

## Additional Resources

- [OWASP Desktop Security](https://owasp.org/www-project-desktop-app-security-top-10/)
- [Microsoft Security Response Center](https://www.microsoft.com/en-us/msrc)
- [AutoHotkey Security Considerations](https://www.autohotkey.com/docs/v2/misc/Security.htm)

---

## Questions?

For general security questions (not vulnerabilities), you can:
- Open a public GitHub discussion
- Reference this policy in your question

For vulnerability reports, follow the "Reporting a Vulnerability" section above.

---

**Version**: 1.0.0  
**Last Updated**: 2025-10-17  
**Policy Maintainer**: devspo Project Security Team
