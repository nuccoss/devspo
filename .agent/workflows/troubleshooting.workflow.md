# Troubleshooting Workflow
**Purpose**: Systematic problem diagnosis and resolution  
**Version**: 1.0.0  
**Last Updated**: 2025-10-17

---

## Quick Reference

### Common Issues

| Issue | Severity | Quick Fix | Section |
|-------|----------|-----------|---------|
| AutoHotkey not running | HIGH | Restart script | [1.1](#11-autohotkey-not-running) |
| Left Ctrl still active | HIGH | Check device detection | [1.2](#12-left-ctrl-still-active) |
| Bluetooth keyboard blocked | CRITICAL | Review statistics | [1.3](#13-bluetooth-keyboard-blocked) |
| Right Ctrl + Shift disabled | MEDIUM | Under investigation | [1.4](#14-right-ctrl--shift-disabled) |
| Startup continuous signal | MEDIUM | Press K270 Right Ctrl | [1.5](#15-startup-continuous-signal) |
| Service won't start | HIGH | Check permissions | [2.1](#21-windows-service-issues) |
| Git merge conflicts | MEDIUM | Manual resolution | [3.1](#31-git-issues) |

---

## 1. Keyboard Script Issues

### 1.1 AutoHotkey Not Running

**Symptoms**:
- No tray icon visible
- Keyboard behaves normally (no filtering)
- Left Ctrl key works on internal keyboard

**Diagnosis**:
```powershell
# Check if AutoHotkey is running
Get-Process -Name "AutoHotkey*" -ErrorAction SilentlyContinue

# Check for crash dumps
Get-ChildItem "$env:LOCALAPPDATA\Temp" -Filter "*AutoHotkey*.dmp"

# Check event logs
Get-EventLog -LogName Application -Source "AutoHotkey*" -Newest 10
```

**Solutions**:

**Solution 1: Simple Restart**
```powershell
# Navigate to script directory
cd "C:\devspo\キーボード修正スクリプト"

# Start script
Start-Process .\SelectiveLeftCtrlBlocker.ahk -WindowStyle Hidden
```

**Solution 2: Check for Script Errors**
```powershell
# Run in visible mode to see errors
Start-Process .\SelectiveLeftCtrlBlocker.ahk

# Check for syntax errors
# AutoHotkey will show error dialog if present
```

**Solution 3: Reinstall Service**
```powershell
# Stop and remove existing service
sc.exe stop MSILeftCtrlBlocker
sc.exe delete MSILeftCtrlBlocker

# Run service creation script as admin
.\CreateService.ps1
```

---

### 1.2 Left Ctrl Still Active

**Symptoms**:
- Internal keyboard Left Ctrl responds to key presses
- Script is running but not filtering

**Diagnosis**:
```powershell
# Check script statistics
# Right-click tray icon → "📊 統計情報"

# Enable debug mode
# Right-click tray icon → "🐛 デバッグログ切替"

# Check detected devices
# Right-click tray icon → "🔍 検出されたデバイス"

# View debug output (requires DebugView or similar)
# Download: https://learn.microsoft.com/sysinternals/downloads/debugview
```

**Solutions**:

**Solution 1: Restart Script**
```powershell
# Kill existing processes
Get-Process -Name "AutoHotkey*" | Stop-Process -Force

# Wait 2 seconds
Start-Sleep -Seconds 2

# Restart
cd "C:\devspo\キーボード修正スクリプト"
Start-Process .\SelectiveLeftCtrlBlocker.ahk -WindowStyle Hidden
```

**Solution 2: Check Device Detection**
```ahk
; Expected device patterns in debug log:
; Internal: "ACPI", "VEN_MSI", "PS/2"
; Bluetooth: "HID", "VID_046D" (Logitech K270)

; If device names don't match patterns,
; update INTERNAL_KEYBOARD_PATTERNS or
; BLUETOOTH_KEYBOARD_PATTERNS in script
```

**Solution 3: Manual Device Name Update**
```powershell
# Find actual device names
Get-PnpDevice -Class "Keyboard" | Select-Object FriendlyName, InstanceId

# Edit SelectiveLeftCtrlBlocker.ahk
# Update patterns to match your devices
```

---

### 1.3 Bluetooth Keyboard Blocked

**Symptoms**:
- K270 Left Ctrl doesn't work
- Internal keyboard Left Ctrl correctly blocked
- Statistics show bluetooth blocking

**Diagnosis**:
```powershell
# Check statistics
# Right-click tray icon → "📊 統計情報"

# Look for:
# - bluetoothAllowed count (should increase)
# - internalBlocked count
# - Ratio should favor Bluetooth
```

**Solutions**:

**Solution 1: Trigger Learning Algorithm**
```
1. Press K270 Left Ctrl multiple times (10+)
2. Wait for statistical threshold to adjust
3. Check statistics again
```

**Solution 2: Restart Script**
```powershell
# Reset statistics
Get-Process -Name "AutoHotkey*" | Stop-Process -Force
Start-Sleep -Seconds 2
cd "C:\devspo\キーボード修正スクリプト"
Start-Process .\SelectiveLeftCtrlBlocker.ahk -WindowStyle Hidden
```

**Solution 3: Adjust Threshold** (Advanced)
```ahk
; Edit SelectiveLeftCtrlBlocker.ahk
; Find line: if (!isBluetoothDevice && totalBluetooth > 10 && totalBluetooth > totalInternal * 0.5)

; Adjust 0.5 to lower value (e.g., 0.3) for more aggressive Bluetooth allowance
; Lower = more likely to allow Bluetooth
; Higher = more strict filtering
```

---

### 1.4 Right Ctrl + Shift Disabled

**Symptoms**:
- Right Ctrl alone works
- Right Ctrl + Shift + any key doesn't work
- Left Ctrl + Shift works (remapped to Right Ctrl)

**Diagnosis**:
```powershell
# This is a known issue under investigation

# Check if hardware or software issue:
# 1. Boot into Safe Mode
# 2. Disable SelectiveLeftCtrlBlocker
# 3. Test Right Ctrl + Shift

# If works in Safe Mode without script:
#   → Script interference (fixable)
# If doesn't work in Safe Mode:
#   → Hardware issue (needs repair/replacement)
```

**Temporary Workaround**:
```
Use Left Ctrl + Shift instead
(Script automatically remaps to Right Ctrl)

Example:
  Left Ctrl + Shift + T → Opens new browser tab
  (Internally sent as Right Ctrl + Shift + T)
```

**Status**: Under active investigation (Priority: HIGH)

---

### 1.5 Startup Continuous Signal

**Symptoms**:
- After boot/login, Left Ctrl signal continuously sent
- System behaves as if Left Ctrl is stuck
- Pressing K270 Right Ctrl (or random keys) resolves it

**Diagnosis**:
```
This is a script initialization timing issue.
The script needs keyboard input to initialize
device detection properly.
```

**Solutions**:

**Solution 1: Quick Fix**
```
Press K270 Right Ctrl once after login
(or any combination of Ctrl/Shift keys)
```

**Solution 2: Automated Fix Script**
```powershell
# Add to startup (after SelectiveLeftCtrlBlocker)
# File: SendInitialKeypress.ps1

Start-Sleep -Seconds 5

# Load Windows Forms for SendKeys
Add-Type -AssemblyName System.Windows.Forms

# Send Right Ctrl keypress
[System.Windows.Forms.SendKeys]::SendWait("^")

Write-Host "✅ Initialization keypress sent"
```

**Solution 3: Script Modification** (Planned)
```ahk
; Add to SelectiveLeftCtrlBlocker.ahk OnInit:
; Send synthetic keypress to trigger device detection
; Status: Planned for future update
```

---

## 2. Windows Service Issues

### 2.1 Service Won't Start

**Symptoms**:
- `sc.exe start MSILeftCtrlBlocker` fails
- Event log shows service errors
- AutoHotkey doesn't run as service

**Diagnosis**:
```powershell
# Check service status
Get-Service -Name MSILeftCtrlBlocker

# Check service configuration
sc.exe qc MSILeftCtrlBlocker

# Check event logs
Get-EventLog -LogName System -Source "Service Control Manager" -Newest 10 | 
  Where-Object { $_.Message -like "*MSILeftCtrlBlocker*" }
```

**Solutions**:

**Solution 1: Permissions Check**
```powershell
# Verify script path exists
Test-Path "C:\devspo\キーボード修正スクリプト\SelectiveLeftCtrlBlocker.ahk"

# Check file permissions
Get-Acl "C:\devspo\キーボード修正スクリプト\SelectiveLeftCtrlBlocker.ahk" | 
  Select-Object -ExpandProperty Access
```

**Solution 2: Recreate Service**
```powershell
# Run as Administrator

# Remove existing
sc.exe stop MSILeftCtrlBlocker
sc.exe delete MSILeftCtrlBlocker

# Recreate
cd "C:\devspo\キーボード修正スクリプト"
.\CreateService.ps1
```

**Solution 3: Manual Service Configuration**
```powershell
# If automated script fails, create manually:

$serviceName = "MSILeftCtrlBlocker"
$scriptPath = "C:\devspo\キーボード修正スクリプト\SelectiveLeftCtrlBlocker.ahk"
$ahkPath = "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"

$params = @{
    Name = $serviceName
    BinaryPathName = "`"$ahkPath`" `"$scriptPath`""
    DisplayName = "MSI Left Ctrl Blocker Service"
    Description = "Blocks internal keyboard Left Ctrl while preserving Bluetooth keyboard"
    StartupType = "Automatic"
}

New-Service @params
```

---

### 2.2 Service Stops Randomly

**Diagnosis**:
```powershell
# Check crash dumps
Get-ChildItem "$env:LOCALAPPDATA\Temp" -Filter "*.dmp"

# Check service restart count
Get-EventLog -LogName System -Source "Service Control Manager" |
  Where-Object { $_.Message -like "*MSILeftCtrlBlocker*" -and $_.EntryType -eq "Warning" }
```

**Solutions**:

**Solution 1: Configure Auto-Restart**
```powershell
# Set failure actions
sc.exe failure MSILeftCtrlBlocker reset= 86400 actions= restart/60000/restart/60000/restart/60000

# Verify
sc.exe qfailure MSILeftCtrlBlocker
```

**Solution 2: Use Task Scheduler Instead**
```powershell
cd "C:\devspo\キーボード修正スクリプト"
.\CreateWakeUpTask.ps1
```

---

## 3. Git Issues

### 3.1 Merge Conflicts

**Diagnosis**:
```powershell
git status
git diff
```

**Solutions**:

**Solution 1: Accept Theirs**
```powershell
git checkout --theirs <file>
git add <file>
git commit
```

**Solution 2: Accept Ours**
```powershell
git checkout --ours <file>
git add <file>
git commit
```

**Solution 3: Manual Resolution**
```powershell
# Open file in editor
code <file>

# Look for conflict markers:
# <<<<<<< HEAD
# ======= 
# >>>>>>> branch-name

# Edit to desired state
# Remove markers
# Save file

git add <file>
git commit
```

---

### 3.2 Accidental Commit

**Solutions**:

**Solution 1: Undo Last Commit (Keep Changes)**
```powershell
git reset --soft HEAD~1
```

**Solution 2: Undo Last Commit (Discard Changes)**
```powershell
git reset --hard HEAD~1
```

**Solution 3: Amend Last Commit**
```powershell
# Make additional changes
git add .
git commit --amend
```

---

## 4. Performance Issues

### 4.1 High CPU Usage

**Diagnosis**:
```powershell
Get-Process -Name "AutoHotkey*" | Select-Object ProcessName, CPU, WorkingSet

# Monitor over time
while ($true) {
    Get-Process -Name "AutoHotkey*" | Select-Object ProcessName, CPU, WorkingSet
    Start-Sleep -Seconds 5
}
```

**Solutions**:

**Solution 1: Disable Debug Mode**
```
Right-click tray icon → "🐛 デバッグログ切替" → Disable
```

**Solution 2: Restart Script**
```powershell
Get-Process -Name "AutoHotkey*" | Stop-Process -Force
Start-Sleep -Seconds 2
Start-Process "C:\devspo\キーボード修正スクリプト\SelectiveLeftCtrlBlocker.ahk" -WindowStyle Hidden
```

---

### 4.2 High Memory Usage

**Normal Range**: 10-20 MB

**Diagnosis**:
```powershell
Get-Process -Name "AutoHotkey*" | Select-Object ProcessName, @{Name="MemoryMB";Expression={$_.WorkingSet / 1MB}}
```

**Solutions**:

**Solution 1: Check for Memory Leaks**
```powershell
# Monitor memory growth over time
$start = (Get-Process -Name "AutoHotkey64").WorkingSet
Start-Sleep -Seconds 3600  # Wait 1 hour
$end = (Get-Process -Name "AutoHotkey64").WorkingSet
$growth = ($end - $start) / 1MB
Write-Host "Memory growth: ${growth}MB/hour"

# If >5MB/hour growth, potential memory leak
```

**Solution 2: Restart Periodically**
```powershell
# Add scheduled task to restart daily
# See maintenance.workflow.md
```

---

## 5. Emergency Recovery

### 5.1 System Unusable

**Immediate Actions**:

```powershell
# 1. Kill AutoHotkey processes
Get-Process -Name "AutoHotkey*" | Stop-Process -Force

# 2. If can't access PowerShell, use Task Manager:
#    Ctrl + Shift + Esc
#    Find AutoHotkey processes
#    End Task

# 3. If Task Manager inaccessible:
#    Boot into Safe Mode (F8 or Shift+Restart)
#    Navigate to startup folder
#    Remove AutoHotkey startup entry
```

**Desktop Emergency Recovery**:
```
1. Use Emergency_Recovery.bat on desktop
2. Double-click to stop all AutoHotkey processes
3. System will return to normal keyboard behavior
```

---

### 5.2 Rollback to Previous Version

**From Archive**:
```powershell
# 1. Stop current processes
Get-Process -Name "AutoHotkey*" | Stop-Process -Force

# 2. Backup current state
Copy-Item "C:\devspo\キーボード修正スクリプト" -Destination "C:\devspo\キーボード修正スクリプト_backup_$(Get-Date -Format 'yyyyMMddHHmmss')" -Recurse

# 3. Restore from archive
Copy-Item "C:\devspo\.archive\2025-10-17\keyboard-scripts\*" -Destination "C:\devspo\キーボード修正スクリプト\" -Force

# 4. Restart
Start-Process "C:\devspo\キーボード修正スクリプト\SelectiveLeftCtrlBlocker.ahk"
```

**From Git**:
```powershell
# 1. Stop processes
Get-Process -Name "AutoHotkey*" | Stop-Process -Force

# 2. Reset to last commit
cd "C:\devspo"
git reset --hard HEAD

# 3. Or specific commit
git log --oneline  # Find commit hash
git reset --hard <commit-hash>

# 4. Restart
Start-Process "キーボード修正スクリプト\SelectiveLeftCtrlBlocker.ahk"
```

---

## 6. Diagnostic Tools

### 6.1 Enable Verbose Logging

**Temporary (Current Session)**:
```
Right-click tray icon → "🐛 デバッグログ切替" → Enable
```

**Permanent**:
```ahk
; Edit SelectiveLeftCtrlBlocker.ahk
; Find: global DEBUG_MODE := true
; Change to: global DEBUG_MODE := true  (ensure it's true)
```

---

### 6.2 View Debug Output

**Option 1: DebugView** (Recommended)
```
1. Download: https://learn.microsoft.com/sysinternals/downloads/debugview
2. Run as Administrator
3. Enable: Capture > Capture Global Win32
4. Watch real-time output
```

**Option 2: Windows Event Viewer**
```powershell
# Some debug info goes to event log
eventvwr.msc
# Navigate to: Windows Logs > Application
# Filter by Source: AutoHotkey
```

---

### 6.3 Collect Diagnostic Package

**Automated Collection**:
```powershell
$diagPath = "C:\devspo\diagnostics_$(Get-Date -Format 'yyyyMMddHHmmss')"
New-Item -ItemType Directory -Path $diagPath

# 1. Process information
Get-Process -Name "AutoHotkey*" | Out-File "$diagPath\processes.txt"

# 2. Service status
Get-Service -Name "*AutoHotkey*", "MSILeftCtrlBlocker" | Out-File "$diagPath\services.txt"

# 3. Event logs
Get-EventLog -LogName Application -Source "AutoHotkey*" -Newest 50 | Out-File "$diagPath\events.txt"

# 4. Git status
cd "C:\devspo"
git status > "$diagPath\git-status.txt"
git log --oneline -20 > "$diagPath\git-log.txt"

# 5. System info
Get-ComputerInfo | Out-File "$diagPath\system-info.txt"

# 6. Keyboard devices
Get-PnpDevice -Class "Keyboard" | Out-File "$diagPath\keyboard-devices.txt"

Write-Host "✅ Diagnostics collected in: $diagPath"
```

---

## 7. Escalation

### When to Escalate

**Immediate Escalation** (Critical):
- System completely unusable
- Data loss occurred
- Security breach suspected
- Unable to recover after all troubleshooting steps

**24-Hour Escalation** (High):
- Issue persists after all solutions attempted
- Performance severely degraded
- Recurring crashes (>3 per day)
- Unknown error patterns

**Weekly Escalation** (Medium):
- Non-critical bugs
- Feature requests
- Documentation improvements
- Performance optimizations

### Escalation Contacts

1. **Agent_PC_Reliability** (First line)
   - User guidance
   - Operational support

2. **GitHub Issues** (Community support)
   - https://github.com/nuccoss/devspo/issues

3. **CEO Thread** (Strategic issues)
   - 10[Orch]10-12_MNTG-CEO-TE_VASt-g2.5p_agb2.6.8

---

## 8. Known Issues Registry

| Issue ID | Description | Severity | Status | Workaround |
|----------|-------------|----------|--------|------------|
| KI-001 | Right Ctrl + Shift disabled | HIGH | Investigating | Use Left Ctrl + Shift |
| KI-002 | Startup continuous signal | MEDIUM | Workaround available | Press K270 Right Ctrl |
| KI-003 | Service auto-start fails occasionally | LOW | Monitoring | Use Task Scheduler |

---

**Troubleshooting Workflow Version**: 1.0.0  
**Last Updated**: 2025-10-17  
**Maintained by**: VS_CodingAgent (Claude Sonnet 4.0)  
**Reference**: SystemInstructions.md Workflow Templates
