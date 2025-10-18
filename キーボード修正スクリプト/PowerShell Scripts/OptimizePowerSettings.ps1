# 電源管理設定最適化スクリプト
# 管理者権限で実行してください

Write-Host "⚡ 電源管理設定最適化中..." -ForegroundColor Yellow

# 現在の設定確認
Write-Host "`n📊 現在の電源設定:" -ForegroundColor Cyan
powercfg /query SCHEME_CURRENT SUB_BUTTONS LIDACTION

# 蓋を閉じたときの動作を「何もしない」に設定
Write-Host "`n🔧 蓋閉じ動作設定変更中..." -ForegroundColor Yellow

# ACアダプター接続時
powercfg /setacvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0
# バッテリー動作時
powercfg /setdcvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0

# 設定適用
powercfg /setactive SCHEME_CURRENT

Write-Host "✅ 蓋閉じ時動作: 何もしない（スリープ無効）" -ForegroundColor Green

# USB機器のスリープ時電源維持設定
Write-Host "`n🔌 USB機器電源設定最適化中..." -ForegroundColor Yellow

# USB選択的サスペンド無効化
powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
powercfg /setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0

powercfg /setactive SCHEME_CURRENT

Write-Host "✅ USB選択的サスペンド無効化完了" -ForegroundColor Green

# 設定確認
Write-Host "`n📋 変更後の設定確認:" -ForegroundColor Cyan
powercfg /query SCHEME_CURRENT SUB_BUTTONS LIDACTION

Write-Host "`n💡 推奨: これでスリープによる問題発生を大幅に削減できます" -ForegroundColor Magenta