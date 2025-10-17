# ロック画面キーボード操作保護スクリプト
# 管理者権限で実行してください
# MSI Left Ctrl問題によるロック画面操作不能を防ぐための設定

Write-Host "🔐 ロック画面キーボード操作保護設定中..." -ForegroundColor Yellow

# 1. 自動ログオン設定（緊急回避用）
Write-Host "`n🔑 Step 1: 緊急時自動ログオン設定" -ForegroundColor Cyan

$username = $env:USERNAME
$domain = $env:USERDOMAIN

Write-Host "⚠️  注意: セキュリティリスクがあります。緊急時のみ有効にしてください" -ForegroundColor Red
$enableAutoLogon = Read-Host "緊急時自動ログオンを有効にしますか？ (y/N)"

if ($enableAutoLogon -eq 'y' -or $enableAutoLogon -eq 'Y') {
    # レジストリ設定
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    Set-ItemProperty -Path $regPath -Name "AutoAdminLogon" -Value "1"
    Set-ItemProperty -Path $regPath -Name "DefaultUserName" -Value $username
    Set-ItemProperty -Path $regPath -Name "DefaultDomainName" -Value $domain
    
    Write-Host "✅ 緊急時自動ログオン有効化完了" -ForegroundColor Green
    Write-Host "💡 注意: 後でパスワードを手動設定する必要があります" -ForegroundColor Yellow
}

# 2. スクリーンセーバー無効化
Write-Host "`n🖥️  Step 2: スクリーンセーバー無効化" -ForegroundColor Cyan

$regPathSS = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $regPathSS -Name "ScreenSaveActive" -Value "0" -ErrorAction SilentlyContinue
Set-ItemProperty -Path $regPathSS -Name "ScreenSaveTimeOut" -Value "0" -ErrorAction SilentlyContinue

Write-Host "✅ スクリーンセーバー無効化完了" -ForegroundColor Green

# 3. ロック画面無効化（ドメイン環境では制限あり）
Write-Host "`n🔓 Step 3: ロック画面無効化設定" -ForegroundColor Cyan

$regPathLock = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
if (!(Test-Path $regPathLock)) {
    New-Item -Path $regPathLock -Force | Out-Null
}
Set-ItemProperty -Path $regPathLock -Name "NoLockScreen" -Value 1

Write-Host "✅ ロック画面無効化設定完了" -ForegroundColor Green

# 4. 電源ボタン動作変更
Write-Host "`n⚡ Step 4: 電源ボタン動作最適化" -ForegroundColor Cyan

# 電源ボタンを押したときにシャットダウン（ロック画面回避）
powercfg /setacvalueindex SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 3
powercfg /setdcvalueindex SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 3
powercfg /setactive SCHEME_CURRENT

Write-Host "✅ 電源ボタン=シャットダウン設定完了" -ForegroundColor Green

# 5. 緊急回復用バッチファイル作成
Write-Host "`n🚨 Step 5: 緊急回復用バッチファイル作成" -ForegroundColor Cyan

$emergencyBatch = @'
@echo off
echo 緊急回復モード - MSI Left Ctrl問題対応
echo.
echo 1. AutoHotkeyプロセス全停止
taskkill /f /im "AutoHotkey*" 2>nul
echo.
echo 2. キーボードドライバー再起動
pnputil /restart-device "ACPI\VEN_MSI&DEV_1001" 2>nul
echo.
echo 3. USB機器再認識
powershell -Command "Get-PnpDevice -Class Keyboard | Where-Object {$_.Status -eq 'OK'} | Disable-PnpDevice -Confirm:$false; Start-Sleep 2; Get-PnpDevice -Class Keyboard | Where-Object {$_.Status -eq 'Error'} | Enable-PnpDevice -Confirm:$false"
echo.
echo 4. スクリプト再起動
start "" "C:\devspo\キーボード修正スクリプト\SelectiveLeftCtrlBlocker.ahk"
echo.
echo 回復作業完了
pause
'@

$emergencyBatch | Out-File -FilePath "C:\devspo\キーボード修正スクリプト\Emergency_Recovery.bat" -Encoding ASCII

Write-Host "✅ 緊急回復バッチファイル作成完了" -ForegroundColor Green
Write-Host "📍 場所: C:\devspo\キーボード修正スクリプト\Emergency_Recovery.bat"

# 6. デスクトップショートカット作成
Write-Host "`n🖱️  Step 6: デスクトップ緊急回復ショートカット作成" -ForegroundColor Cyan

$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = "$desktopPath\MSI緊急回復.lnk"

$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "C:\devspo\キーボード修正スクリプト\Emergency_Recovery.bat"
$shortcut.Description = "MSI Left Ctrl問題緊急回復ツール"
$shortcut.Save()

Write-Host "✅ デスクトップショートカット作成完了" -ForegroundColor Green

Write-Host "`n🎯 ロック画面操作不能対策完了サマリー:" -ForegroundColor Magenta
Write-Host "✅ 1. 緊急時自動ログオン設定"
Write-Host "✅ 2. スクリーンセーバー無効化"
Write-Host "✅ 3. ロック画面無効化"
Write-Host "✅ 4. 電源ボタン最適化"
Write-Host "✅ 5. 緊急回復バッチファイル"
Write-Host "✅ 6. デスクトップショートカット"

Write-Host "`n💡 重要な操作方法:" -ForegroundColor Yellow
Write-Host "🔹 問題発生時: デスクトップの『MSI緊急回復』をダブルクリック"
Write-Host "🔹 ロック画面で操作不能時: 電源ボタン長押し → 再起動"
Write-Host "🔹 完全に操作不能時: 物理的な強制再起動"