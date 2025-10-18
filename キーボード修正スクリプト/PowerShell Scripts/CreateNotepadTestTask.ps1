# ========================================
# CreateNotepadTestTask.ps1
# ========================================
# 目的: ログイン直後にメモ帳を自動起動するタスクを登録
# タスク名: MSI_KeyboardTest_OpenNotepad
# ========================================

# 管理者権限チェック
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ このスクリプトは管理者権限で実行してください。" -ForegroundColor Red
    Write-Host "PowerShellを右クリック → '管理者として実行' で起動してください。" -ForegroundColor Yellow
    pause
    exit 1
}

# スクリプトのパス
$scriptPath = Join-Path $PSScriptRoot "OpenNotepadForTest.ps1"

if (-not (Test-Path $scriptPath)) {
    Write-Host "❌ エラー: OpenNotepadForTest.ps1 が見つかりません。" -ForegroundColor Red
    Write-Host "パス: $scriptPath" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "メモ帳自動起動タスク登録" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$taskName = "MSI_KeyboardTest_OpenNotepad"

# 既存タスクの確認と削除
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Host "⚠️  既存のタスクを削除します..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Host "✅ 既存タスク削除完了`n" -ForegroundColor Green
}

# タスクアクション（PowerShell実行）
$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""

# トリガー（ログイン時、3秒遅延）
$trigger = New-ScheduledTaskTrigger `
    -AtLogOn `
    -User $env:USERNAME

$trigger.Delay = "PT3S"  # 3秒遅延（スクリプト起動を待つ）

# 設定
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 1)

# プリンシパル（現在のユーザー、Interactive）
$principal = New-ScheduledTaskPrincipal `
    -UserId $env:USERNAME `
    -LogonType Interactive `
    -RunLevel Highest

# タスク登録
try {
    Register-ScheduledTask `
        -TaskName $taskName `
        -Action $action `
        -Trigger $trigger `
        -Settings $settings `
        -Principal $principal `
        -Description "ログイン直後にメモ帳を起動してキーボード入力テストを実施" | Out-Null
    
    Write-Host "✅ タスク登録完了！" -ForegroundColor Green
    Write-Host "`nタスク名: $taskName" -ForegroundColor Cyan
    Write-Host "実行タイミング: ログイン3秒後" -ForegroundColor Cyan
    Write-Host "動作: テスト用メモ帳を自動起動" -ForegroundColor Cyan
    
    # 確認
    Write-Host "`n📋 登録されたタスク情報:" -ForegroundColor Yellow
    Get-ScheduledTask -TaskName $taskName | Select-Object TaskName, State, @{Name='NextRunTime';Expression={(Get-ScheduledTaskInfo -TaskName $_.TaskName).NextRunTime}} | Format-List
    
} catch {
    Write-Host "❌ タスク登録失敗: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`n💡 次回ログイン時、自動的にメモ帳が起動します。" -ForegroundColor Green
Write-Host "💡 すぐにテストしたい場合は、ログオフ→ログインしてください。" -ForegroundColor Green

Write-Host "`n========================================`n" -ForegroundColor Cyan
pause
