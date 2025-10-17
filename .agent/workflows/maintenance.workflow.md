# Workspace Maintenance Workflow
**Purpose**: Ongoing workspace health and optimization  
**Version**: 1.0.0  
**Last Updated**: 2025-10-17

---

## Prerequisites
- [ ] Agent infrastructure operational
- [ ] ProjectManifest.md accessible
- [ ] SystemInstructions.md loaded
- [ ] Git repository initialized

---

## Daily Maintenance

### Morning Check (Optional)
**Duration**: 2-3 minutes  
**Frequency**: Daily (if active development)

```yaml
1. Process Verification:
   Command: Get-Process -Name "AutoHotkey*"
   Expected: SelectiveLeftCtrlBlocker running
   Action: Restart if stopped

2. Git Status Check:
   Command: git status
   Expected: Clean or expected modifications
   Action: Review uncommitted changes

3. Quick Disk Space:
   Command: Get-PSDrive C
   Expected: >10% free space
   Action: Clean if below threshold
```

**PowerShell Script**:
```powershell
# Daily health check
Write-Host "🌅 Daily Workspace Health Check" -ForegroundColor Cyan

# 1. AutoHotkey processes
$ahkProcesses = Get-Process -Name "AutoHotkey*" -ErrorAction SilentlyContinue
if ($ahkProcesses) {
    Write-Host "✅ AutoHotkey: Running ($($ahkProcesses.Count) processes)" -ForegroundColor Green
} else {
    Write-Host "⚠️ AutoHotkey: Not running" -ForegroundColor Yellow
}

# 2. Git status
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Host "⚠️ Git: Uncommitted changes detected" -ForegroundColor Yellow
} else {
    Write-Host "✅ Git: Clean working directory" -ForegroundColor Green
}

# 3. Disk space
$drive = Get-PSDrive C
$freePercent = [math]::Round(($drive.Free / $drive.Used) * 100, 2)
if ($freePercent -lt 10) {
    Write-Host "⚠️ Disk: Low space ($freePercent% free)" -ForegroundColor Yellow
} else {
    Write-Host "✅ Disk: Adequate space ($freePercent% free)" -ForegroundColor Green
}
```

---

## Weekly Maintenance

### Weekly Review
**Duration**: 15-20 minutes  
**Frequency**: Every Monday (or weekly)  
**Checklist**:

#### 1. Git Repository Health
```yaml
Tasks:
  - Review commit history
  - Check branch status
  - Verify .gitignore effectiveness
  - Update .gitattributes if needed

Commands:
  git log --oneline -10
  git branch -vv
  git status --ignored
  git ls-files --others --ignored --exclude-standard
```

#### 2. Dependency Check
```yaml
Tasks:
  - Verify AutoHotkey version
  - Check PowerShell version
  - Review library dependencies
  - Update if security patches available

Commands:
  # AutoHotkey version
  Get-ItemProperty "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" | Select-Object VersionInfo
  
  # PowerShell version
  $PSVersionTable
  
  # Library versions
  Get-ChildItem "C:\devspo\キーボード修正スクリプト\Lib" -File | Select-Object Name, Length, LastWriteTime
```

#### 3. Archive Review
```yaml
Tasks:
  - Review .archive/ contents
  - Confirm no accidental deletions
  - Verify rollback capability
  - Clean old archives (>90 days)

Commands:
  Get-ChildItem "C:\devspo\.archive" -Recurse | Measure-Object -Property Length -Sum
  Get-ChildItem "C:\devspo\.archive" -Directory | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-90) }
```

#### 4. Documentation Update
```yaml
Tasks:
  - Review README.md accuracy
  - Update CHANGELOG.md
  - Check for broken links
  - Verify code examples

Files:
  - README.md
  - CHANGELOG.md (create if missing)
  - TROUBLESHOOTING.md
  - .agent/ProjectManifest.md
```

#### 5. Performance Review
```yaml
Tasks:
  - Check AutoHotkey CPU usage
  - Review memory consumption
  - Monitor script reliability
  - Analyze error logs

Commands:
  Get-Process -Name "AutoHotkey*" | Select-Object ProcessName, CPU, WorkingSet
  
  # Check for crash dumps
  Get-ChildItem "$env:LOCALAPPDATA\Temp" -Filter "*.dmp" -ErrorAction SilentlyContinue
```

---

## Monthly Maintenance

### Monthly Audit
**Duration**: 30-45 minutes  
**Frequency**: First Monday of each month  
**Comprehensive Review**:

#### 1. Security Audit
```yaml
Tasks:
  - Review .gitignore for sensitive data
  - Check for exposed credentials
  - Verify no secrets in commits
  - Update security practices

Tools:
  git log -S "password" --all
  git log -S "secret" --all
  git log -S "key" --all
```

#### 2. Code Quality Review
```yaml
Tasks:
  - Review recent code changes
  - Check for code duplication
  - Identify refactoring opportunities
  - Update coding standards

Metrics:
  - Lines of code per file
  - Function complexity
  - Comment density
  - Dead code detection
```

#### 3. Backup Verification
```yaml
Tasks:
  - Verify backup archives exist
  - Test restore procedure
  - Update backup strategy
  - Document recovery time

Backup Locations:
  - .archive/ (local)
  - Backup_KeyboardFix_*/ (historical)
  - Git remote (when configured)
```

#### 4. Dependency Updates
```yaml
Tasks:
  - Check for AutoHotkey updates
  - Review PowerShell module updates
  - Update third-party libraries
  - Test compatibility

Update Strategy:
  1. Create branch: git checkout -b update-dependencies
  2. Update dependencies
  3. Run comprehensive tests
  4. Merge if successful
```

#### 5. Documentation Audit
```yaml
Tasks:
  - Review all documentation
  - Update outdated information
  - Add missing sections
  - Improve clarity

Files to Review:
  - README.md
  - CHANGELOG.md
  - TROUBLESHOOTING.md
  - .agent/ProjectManifest.md
  - .agent/SystemInstructions.md
  - .agent/workflows/*.md
```

---

## Quarterly Maintenance

### Quarterly Strategic Review
**Duration**: 1-2 hours  
**Frequency**: Every 3 months

#### 1. Architecture Review
```yaml
Evaluate:
  - Current architecture effectiveness
  - Scalability concerns
  - Performance bottlenecks
  - Technical debt

Output:
  - Architecture decision records
  - Refactoring roadmap
  - Technology upgrade plan
```

#### 2. Roadmap Update
```yaml
Review:
  - Completed milestones
  - Pending features
  - Known issues
  - User feedback

Update:
  - README.md roadmap section
  - Project backlog
  - Priority adjustments
```

#### 3. Agent Infrastructure Review
```yaml
Audit:
  - ProjectManifest.md relevance
  - SystemInstructions.md effectiveness
  - Workflow efficiency
  - Tool usage patterns

Actions:
  - Update manifest if needed
  - Refine instructions
  - Optimize workflows
  - Document learnings
```

---

## Emergency Maintenance

### Immediate Response Procedures

#### 1. Critical Failure
```yaml
Severity: CRITICAL
Response Time: Immediate

Procedure:
  1. Stop all processes:
     Get-Process -Name "AutoHotkey*" | Stop-Process -Force
  
  2. Assess damage:
     - Check system logs
     - Review error messages
     - Identify root cause
  
  3. Execute rollback:
     # Restore from archive
     Copy-Item ".archive\2025-10-17\*" -Destination "." -Recurse -Force
  
  4. Verify restoration:
     # Test basic functionality
     Start-Process "キーボード修正スクリプト\SelectiveLeftCtrlBlocker.ahk"
  
  5. Document incident:
     # Create incident report
```

#### 2. Data Corruption
```yaml
Severity: HIGH
Response Time: <1 hour

Procedure:
  1. Stop modifications:
     # Prevent further corruption
  
  2. Backup current state:
     Copy-Item "C:\devspo" -Destination "C:\devspo_corrupted_$(Get-Date -Format 'yyyyMMdd_HHmmss')" -Recurse
  
  3. Identify corruption:
     # Check git status
     git status
     git diff
  
  4. Restore from Git:
     git reset --hard HEAD
     # Or specific commit
     git reset --hard <commit-hash>
  
  5. Validate restoration:
     # Run tests
```

#### 3. Performance Degradation
```yaml
Severity: MEDIUM
Response Time: <4 hours

Procedure:
  1. Identify bottleneck:
     Get-Process -Name "AutoHotkey*" | Select-Object CPU, WorkingSet
  
  2. Collect diagnostics:
     # Enable debug logging
     # Monitor resource usage
  
  3. Apply mitigation:
     # Restart processes
     # Adjust configuration
  
  4. Monitor recovery:
     # Track metrics
```

---

## Maintenance Automation

### Automated Health Check Script
**Location**: `.agent/scripts/health-check.ps1`

```powershell
# Automated Weekly Health Check
param(
    [switch]$Email = $false,
    [string]$Recipient = "admin@devspo.local"
)

$report = @()
$issues = 0

# 1. Process check
$ahk = Get-Process -Name "AutoHotkey*" -ErrorAction SilentlyContinue
if (-not $ahk) {
    $report += "❌ AutoHotkey not running"
    $issues++
} else {
    $report += "✅ AutoHotkey running"
}

# 2. Git status
$gitDirty = git status --porcelain
if ($gitDirty) {
    $report += "⚠️ Uncommitted changes: $($gitDirty.Count) files"
} else {
    $report += "✅ Git working directory clean"
}

# 3. Disk space
$drive = Get-PSDrive C
$freeGB = [math]::Round($drive.Free / 1GB, 2)
if ($freeGB -lt 10) {
    $report += "❌ Low disk space: ${freeGB}GB free"
    $issues++
} else {
    $report += "✅ Disk space adequate: ${freeGB}GB free"
}

# 4. Archive size
$archiveSize = (Get-ChildItem ".archive" -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
$report += "📦 Archive size: $([math]::Round($archiveSize, 2))MB"

# 5. Recent errors
$errorLog = "キーボード修正スクリプト\errors.log"
if (Test-Path $errorLog) {
    $recentErrors = Get-Content $errorLog -Tail 10
    if ($recentErrors) {
        $report += "⚠️ Recent errors found in log"
        $issues++
    }
}

# Generate report
$reportText = $report -join "`n"
Write-Host $reportText

if ($Email -and $issues -gt 0) {
    # Send email (requires configuration)
    # Send-MailMessage -To $Recipient -Subject "Devspo Health Check: $issues issues" -Body $reportText
}

# Exit with issue count
exit $issues
```

---

## Maintenance Calendar

### Recommended Schedule

| Frequency | Day | Time | Duration | Tasks |
|-----------|-----|------|----------|-------|
| **Daily** | Any | 09:00 | 2-3 min | Process check, Git status |
| **Weekly** | Monday | 10:00 | 15-20 min | Repository health, Dependencies |
| **Monthly** | 1st Monday | 10:00 | 30-45 min | Security audit, Code quality |
| **Quarterly** | 1st of Q | 14:00 | 1-2 hours | Architecture, Roadmap, Infrastructure |

---

## Success Metrics

### Health Indicators

```yaml
Excellent:
  - AutoHotkey uptime: >99%
  - Git commits: Regular (>1/week)
  - No critical issues
  - Documentation current

Good:
  - AutoHotkey uptime: >95%
  - Git commits: Occasional
  - Minor issues only
  - Documentation mostly current

Needs Attention:
  - AutoHotkey uptime: <95%
  - Git commits: Rare
  - Multiple issues
  - Documentation outdated
```

---

## Maintenance Log

### Log Format
**Location**: `.agent/maintenance-log.md`

```markdown
## YYYY-MM-DD: [Type] Maintenance

**Performed by**: [Agent/User]  
**Duration**: [Minutes]  
**Status**: [✅/⚠️/❌]

### Tasks Completed
- [ ] Task 1
- [ ] Task 2

### Issues Found
1. Issue description
   - Severity: [LOW/MEDIUM/HIGH/CRITICAL]
   - Action taken: Description
   - Status: [Resolved/Pending/Escalated]

### Notes
- Additional observations
- Follow-up required
```

---

## Escalation Procedure

### When to Escalate

```yaml
Immediate Escalation:
  - Critical system failure
  - Data loss
  - Security breach
  - Unable to restore functionality

24-Hour Escalation:
  - Persistent performance issues
  - Recurring errors
  - Dependency conflicts
  - Unknown root cause

Weekly Escalation:
  - Technical debt accumulation
  - Documentation gaps
  - Architecture concerns
```

### Escalation Contacts

```yaml
Technical Issues:
  - Primary: Agent_PC_Reliability
  - Secondary: User direct contact

Strategic Decisions:
  - CEO Thread (10[Orch]10-12_MNTG-CEO-TE_VASt-g2.5p_agb2.6.8)

Emergency:
  - User direct intervention
```

---

## Continuous Improvement

### Feedback Loop

After each maintenance session:
1. Document what worked well
2. Identify areas for improvement
3. Update maintenance procedures
4. Share learnings with peer agents

---

**Maintenance Workflow Version**: 1.0.0  
**Next Review**: 2025-11-17  
**Maintained by**: VS_CodingAgent (Claude Sonnet 4.0)  
**Reference**: ProjectManifest.md Article VI
