# MSI Left Ctrl Blocker - 永続化サービス作成スクリプト
# 管理者権限で実行してください

$serviceName = "MSILeftCtrlBlocker"
$serviceDisplayName = "MSI Left Ctrl Blocker Service"
$serviceDescription = "MSI内蔵キーボードLeft Ctrl無効化サービス（スリープ復帰対応）"
$scriptPath = "C:\devspo\キーボード修正スクリプト\SelectiveLeftCtrlBlocker.ahk"
$autoHotkeyPath = "C:\Users\mov54\AppData\Local\Programs\AutoHotkey\v2\AutoHotkey64.exe"

# サービス作成
$serviceBinary = "`"$autoHotkeyPath`" `"$scriptPath`""

Write-Host "🔧 MSI Left Ctrl Blocker サービス作成中..." -ForegroundColor Yellow

# 既存サービス削除（存在する場合）
try {
    $existingService = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($existingService) {
        Write-Host "⚠️ 既存サービスを停止・削除中..." -ForegroundColor Orange
        Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
        sc.exe delete $serviceName
        Start-Sleep -Seconds 2
    }
} catch {
    # 既存サービスなし
}

# 新しいサービス作成
$createResult = sc.exe create $serviceName binPath= $serviceBinary start= auto DisplayName= $serviceDisplayName

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ サービス作成成功" -ForegroundColor Green
    
    # サービス説明設定
    sc.exe description $serviceName $serviceDescription
    
    # 失敗時自動再起動設定
    sc.exe failure $serviceName reset=86400 actions=restart/5000/restart/10000/restart/30000
    
    Write-Host "🔄 サービス回復オプション設定完了" -ForegroundColor Green
    
    # サービス開始
    Start-Service -Name $serviceName
    Write-Host "🚀 サービス開始完了" -ForegroundColor Green
    
} else {
    Write-Host "❌ サービス作成失敗: $createResult" -ForegroundColor Red
}

# 結果確認
Get-Service -Name $serviceName | Select-Object Name, Status, StartType