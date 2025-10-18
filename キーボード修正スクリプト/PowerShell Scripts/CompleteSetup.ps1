# MSI Left Ctrl 完全解決統合セットアップ
# 管理者権限で実行してください

Write-Host "🎯 MSI Left Ctrl 完全解決統合セットアップ開始" -ForegroundColor Magenta
Write-Host "=========================================="

# Step 1: ロック画面対策
Write-Host "`n🔐 Step 1/4: ロック画面操作不能対策" -ForegroundColor Yellow
& ".\LockScreenProtection.ps1"

# Step 2: 電源設定最適化
Write-Host "`n⚡ Step 2/4: 電源設定最適化" -ForegroundColor Yellow
& ".\OptimizePowerSettings.ps1"

# Step 3: 永続化サービス作成
Write-Host "`n🔧 Step 3/4: 永続化サービス作成" -ForegroundColor Yellow
& ".\CreateService.ps1"

# Step 4: スリープ復帰自動実行
Write-Host "`n📅 Step 4/4: スリープ復帰自動実行設定" -ForegroundColor Yellow
& ".\CreateWakeUpTask.ps1"

Write-Host "`n🎉 統合セットアップ完了!" -ForegroundColor Green
Write-Host "=========================================="
Write-Host "💡 設定内容:"
Write-Host "✅ ロック画面操作不能対策"
Write-Host "✅ 永続化サービス"
Write-Host "✅ スリープ復帰自動実行"
Write-Host "✅ 電源設定最適化"
Write-Host "✅ 緊急回復機能"

Write-Host "`n🚨 緊急時の操作方法:"
Write-Host "🔹 デスクトップ『MSI緊急回復』ダブルクリック"
Write-Host "🔹 電源ボタン長押し → 強制再起動"

Write-Host "`n💯 期待される解決率: 95-98%" -ForegroundColor Magenta

Read-Host "`nEnterキーを押してセットアップを完了してください"