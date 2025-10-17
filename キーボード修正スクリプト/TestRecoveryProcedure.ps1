# MSI Left Ctrl 症状再現・回復手順検証スクリプト
# 検証用途のため、慎重に実行してください

Write-Host "🧪 MSI Left Ctrl 症状再現・回復手順検証" -ForegroundColor Yellow
Write-Host "⚠️  これは検証目的のスクリプトです。症状を意図的に再現します。" -ForegroundColor Red

$continue = Read-Host "`n実行を続行しますか？ (y/N)"
if ($continue -ne 'y' -and $continue -ne 'Y') {
    Write-Host "❌ 検証を中止しました" -ForegroundColor Red
    exit
}

Write-Host "`n📋 検証手順:" -ForegroundColor Cyan
Write-Host "1. 現在のスクリプト停止"
Write-Host "2. 症状発生確認"
Write-Host "3. 回復手順テスト"
Write-Host "4. 結果記録"

# Step 1: 現在のスクリプト停止
Write-Host "`n🛑 Step 1: 現在のスクリプト停止" -ForegroundColor Yellow
Get-Process -Name "AutoHotkey*" -ErrorAction SilentlyContinue | Stop-Process -Force
Write-Host "✅ AutoHotkeyプロセス停止完了"

# Step 2: 症状確認待機
Write-Host "`n⏳ Step 2: 症状発生待機中..." -ForegroundColor Yellow
Write-Host "💡 以下の操作で症状が発生する可能性があります："
Write-Host "   - ノートPC画面を閉じて開く"
Write-Host "   - スリープ後の復帰"
Write-Host "   - 数分間の待機"

Read-Host "`n症状が発生したらEnterキーを押してください"

# Step 3: 回復手順ガイド
Write-Host "`n🔧 Step 3: 回復手順テスト" -ForegroundColor Yellow
Write-Host "以下の手順を順番に試してください："

Write-Host "`n📱 手順A: K270物理操作"
Write-Host "1. K270左側のShiftキーを数回押す"
Write-Host "2. K270左側のCtrlキーを数回押す"
Write-Host "3. K270の左側付近を軽く叩く"
Read-Host "手順A完了後、Enterキーを押してください"

$recoveredA = Read-Host "手順Aで回復しましたか？ (y/N)"

if ($recoveredA -ne 'y' -and $recoveredA -ne 'Y') {
    Write-Host "`n🔄 手順B: スクリプト再起動"
    Start-Process -FilePath "C:\devspo\キーボード修正スクリプト\SelectiveLeftCtrlBlocker.ahk"
    Write-Host "✅ スクリプト再起動完了"
    Read-Host "手順B完了後、Enterキーを押してください"
    
    $recoveredB = Read-Host "手順Bで回復しましたか？ (y/N)"
    
    if ($recoveredB -ne 'y' -and $recoveredB -ne 'Y') {
        Write-Host "`n⚡ 手順C: システム再起動"
        Write-Host "最終手段としてシステム再起動が必要な場合があります"
        $restart = Read-Host "今すぐ再起動しますか？ (y/N)"
        if ($restart -eq 'y' -or $restart -eq 'Y') {
            Restart-Computer -Force
        }
    }
}

# 結果記録
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logEntry = @"
[$timestamp] MSI Left Ctrl 症状検証結果
- 手順A（K270物理操作）: $recoveredA
- 手順B（スクリプト再起動）: $recoveredB
- 備考: 
"@

$logEntry | Out-File -FilePath "C:\devspo\キーボード修正スクリプト\recovery_log.txt" -Append -Encoding UTF8

Write-Host "`n📝 検証結果をログに記録しました" -ForegroundColor Green
Write-Host "ログファイル: C:\devspo\キーボード修正スクリプト\recovery_log.txt"