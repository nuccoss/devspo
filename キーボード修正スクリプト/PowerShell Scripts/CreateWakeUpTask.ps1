# スリープ復帰時MSI Left Ctrl Blocker自動再起動タスク
# 管理者権限で実行してください

$taskName = "MSI_LeftCtrl_WakeUp_Restart"
$scriptPath = "C:\devspo\キーボード修正スクリプト\SelectiveLeftCtrlBlocker.ahk"

Write-Host "📅 スリープ復帰時自動実行タスク作成中..." -ForegroundColor Yellow

# 既存タスク削除（存在する場合）
try {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
    Write-Host "⚠️ 既存タスク削除完了" -ForegroundColor Orange
} catch {
    # 既存タスクなし
}

# タスクアクション定義
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-Command `"Start-Process -FilePath '$scriptPath' -WindowStyle Hidden`""

# トリガー設定（システムイベント: スリープ復帰）
$trigger1 = New-ScheduledTaskTrigger -AtLogOn
$trigger2 = New-ScheduledTaskTrigger -AtStartup

# より詳細なトリガー（イベントベース）
$trigger3 = New-CimInstance -ClassName MSFT_TaskEventTrigger -Namespace Root/Microsoft/Windows/TaskScheduler -ClientOnly
$trigger3.Subscription = '<QueryList><Query Id="0" Path="System"><Select Path="System">*[System[Provider[@Name=''Microsoft-Windows-Power-Troubleshooter''] and EventID=1]]</Select></Query></QueryList>'
$trigger3.Enabled = $true

# 設定
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)

# プリンシパル（実行ユーザー）- 現在のユーザーで実行（GUIアプリ起動のため）
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest

# タスク登録
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger1, $trigger2 -Settings $settings -Principal $principal -Description "MSI内蔵キーボードLeft Ctrl無効化スクリプトの自動再起動（スリープ復帰時）"

Write-Host "✅ スリープ復帰時自動実行タスク作成完了" -ForegroundColor Green

# タスク確認
Get-ScheduledTask -TaskName $taskName | Select-Object TaskName, State