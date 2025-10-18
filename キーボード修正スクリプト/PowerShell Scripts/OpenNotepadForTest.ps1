# ========================================
# OpenNotepadForTest.ps1
# ========================================
# 目的: ログイン直後にメモ帳を起動して入力テストを即座に実行可能にする
# 実行タイミング: ログイン後3秒（スクリプト起動を待つ）
# ========================================

# ログ出力先
$logFile = Join-Path $PSScriptRoot "OpenNotepadForTest.log"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -FilePath $logFile -Append -Encoding UTF8
}

try {
    Write-Log "メモ帳起動スクリプト開始"
    
    # 一時ファイルを作成（テスト用テキスト）
    $tempFile = Join-Path $env:TEMP "KeyboardTest_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    
    $testContent = @"
========================================
キーボード入力テスト
========================================
起動時刻: $(Get-Date -Format 'yyyy/MM/dd HH:mm:ss')

【テスト手順】
1. この下の行にすぐに文字を入力してください
2. 入力できたら成功、できなければ失敗を記録

【入力テスト】→ 


【結果記録】
□ 成功: 起動後すぐに入力可能
□ 失敗: K270左Ctrl押下が必要だった（押下回数:    回）
□ 失敗: その他（詳細:                           ）

========================================
"@
    
    # ファイル作成
    $testContent | Out-File -FilePath $tempFile -Encoding UTF8
    Write-Log "テストファイル作成: $tempFile"
    
    # メモ帳起動
    Start-Process notepad.exe -ArgumentList $tempFile
    Write-Log "メモ帳起動完了"
    
} catch {
    Write-Log "エラー発生: $($_.Exception.Message)"
    Write-Log "スタックトレース: $($_.ScriptStackTrace)"
}
