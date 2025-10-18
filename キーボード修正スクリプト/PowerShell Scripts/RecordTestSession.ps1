# ========================================
# テストセッション記録ツール
# ========================================
# 使用方法:
#   .\RecordTestSession.ps1 -Phase "baseline"
#   .\RecordTestSession.ps1 -Phase "short_detected"
#   .\RecordTestSession.ps1 -Phase "reset_1st"
#   .\RecordTestSession.ps1 -Phase "reset_2nd"

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("baseline", "short_detected", "reset_1st", "reset_2nd", "final")]
    [string]$Phase
)

# タイムスタンプ生成
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$testSessionDir = Join-Path $PSScriptRoot "TestSessions"

# テストセッションディレクトリ作成
if (-not (Test-Path $testSessionDir)) {
    New-Item -ItemType Directory -Path $testSessionDir | Out-Null
}

# 今日のセッションディレクトリ
$todayDir = Join-Path $testSessionDir (Get-Date -Format "yyyyMMdd")
if (-not (Test-Path $todayDir)) {
    New-Item -ItemType Directory -Path $todayDir | Out-Null
}

# フェーズ名の日本語化
$phaseNames = @{
    "baseline" = "1_ベースライン"
    "short_detected" = "2_ショート発生"
    "reset_1st" = "3_リセット1回目"
    "reset_2nd" = "4_リセット2回目"
    "final" = "5_最終状態"
}

$phaseName = $phaseNames[$Phase]

Write-Host "`n📊 テストセッション記録: $phaseName" -ForegroundColor Cyan
Write-Host "=" * 60

# レポートファイル名
$reportFile = Join-Path $todayDir "TestReport_${timestamp}.md"

# レポート作成
$report = @"
# テストレポート: $phaseName

**記録日時**: $(Get-Date -Format "yyyy/MM/dd HH:mm:ss")
**フェーズ**: $phaseName

## 手順

1. **統計情報を開く**
   - トレイアイコン → 右クリック → 📊 統計情報
   - スクリーンショットを撮影 (Win + Shift + S)
   - 保存先: `$todayDir\${Phase}_${timestamp}.png`

2. **診断ログを出力** (baselineとfinalのみ)
   - トレイアイコン → 右クリック → 💾 診断ログ出力
   - 自動保存先: `$PSScriptRoot\DiagnosticLog_*.txt`

3. **記録項目**
   - [ ] 総信号数: ________
   - [ ] 高速連続信号(<50ms): ________
   - [ ] 疑惑レベル: ________
   - [ ] 手動リセット実行回数: ________
   - [ ] 最新5件の信号間隔: ________

4. **結果**
   - [ ] キーボード入力テスト実施
   - [ ] ショート解消: はい / いいえ

## メモ

(気づいた点や特記事項を記入)

---

**次のフェーズ**: $(
    switch ($Phase) {
        "baseline" { "short_detected (本体左Ctrlを触ってショート発生)" }
        "short_detected" { "reset_1st (本体右Ctrl→K270左Ctrl実行)" }
        "reset_1st" { "reset_2nd (解消されない場合、もう一度実行)" }
        "reset_2nd" { "final (最終状態記録)" }
        "final" { "テスト完了" }
    }
)

"@

# レポート保存
$report | Out-File -FilePath $reportFile -Encoding UTF8

Write-Host "`n✅ レポートファイル作成: $reportFile" -ForegroundColor Green
Write-Host "`n📋 次のステップ:" -ForegroundColor Yellow
Write-Host "1. 統計情報を開いてスクリーンショット撮影"
Write-Host "2. スクショを保存: $todayDir\${Phase}_${timestamp}.png"

if ($Phase -eq "baseline" -or $Phase -eq "final") {
    Write-Host "3. 診断ログを出力 (トレイメニュー → 💾 診断ログ出力)" -ForegroundColor Cyan
}

Write-Host "`n💡 次のフェーズ実行コマンド:" -ForegroundColor Magenta
$nextPhase = switch ($Phase) {
    "baseline" { "short_detected" }
    "short_detected" { "reset_1st" }
    "reset_1st" { "reset_2nd" }
    "reset_2nd" { "final" }
    "final" { "" }
}

if ($nextPhase) {
    Write-Host ".\RecordTestSession.ps1 -Phase $nextPhase" -ForegroundColor White
}

# レポートファイルを開く
Write-Host "`n📄 レポートファイルを開きますか? (Y/N): " -NoNewline -ForegroundColor Yellow
$response = Read-Host
if ($response -eq "Y" -or $response -eq "y") {
    Start-Process notepad $reportFile
}
