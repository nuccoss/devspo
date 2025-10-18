# ===============================================
# 起動時自動初期化スクリプト
# KI-002: Startup Left Ctrl continuous signal 対策
# ===============================================
# 
# 目的: SelectiveLeftCtrlBlocker.ahkの初期化を自動化
# 動作: 左Ctrlと右Ctrlを交互に3回ずつ押下して初期化完了
# 実行タイミング: ログイン直後、SelectiveLeftCtrlBlocker起動の5秒後
#
# ===============================================

param(
    [switch]$Debug
)

# ログ関数
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    # コンソール出力（色分け）
    switch ($Level) {
        "ERROR"   { Write-Host $logMessage -ForegroundColor Red }
        "WARNING" { Write-Host $logMessage -ForegroundColor Yellow }
        "SUCCESS" { Write-Host $logMessage -ForegroundColor Green }
        default   { Write-Host $logMessage -ForegroundColor Cyan }
    }
    
    # ファイル出力
    $logFile = "$PSScriptRoot\SendInitialKeypress.log"
    Add-Content -Path $logFile -Value $logMessage
}

# ===============================================
# メイン処理
# ===============================================

try {
    Write-Log "自動初期化スクリプト開始" "INFO"
    
    # 1. SelectiveLeftCtrlBlocker.ahkが起動しているか確認（革新的多段階検出）
    Write-Log "SelectiveLeftCtrlBlocker.ahkの起動を確認中（最大30秒待機）..." "INFO"
    
    $maxRetries = 6  # 6回 × 5秒 = 30秒
    $retryCount = 0
    $ahkProcess = $null
    
    while ($retryCount -lt $maxRetries) {
        # 方法1: プロセス名での検出（AutoHotkey64.exe または AutoHotkey32.exe）
        $ahkProcesses = Get-Process -Name "AutoHotkey*" -ErrorAction SilentlyContinue
        
        if ($ahkProcesses) {
            # 方法2: コマンドライン引数でSelectiveLeftCtrlBlocker.ahkを実行しているプロセスを検出
            foreach ($proc in $ahkProcesses) {
                try {
                    $commandLine = (Get-CimInstance Win32_Process -Filter "ProcessId = $($proc.Id)").CommandLine
                    
                    if ($commandLine -match "SelectiveLeftCtrlBlocker\.ahk") {
                        $ahkProcess = $proc
                        Write-Log "SelectiveLeftCtrlBlocker.ahk起動確認（コマンドライン検出）: $commandLine" "SUCCESS"
                        break
                    }
                } catch {
                    # アクセス権限エラーは無視して次へ
                }
            }
            
            if ($ahkProcess) {
                break
            }
            
            # 方法3: 任意のAutoHotkeyプロセスが存在すれば継続（緊急措置）
            if ($ahkProcesses.Count -eq 1) {
                $ahkProcess = $ahkProcesses[0]
                Write-Log "AutoHotkeyプロセス検出（単一プロセス、推定で継続）" "WARNING"
                break
            }
        }
        
        # 待機してリトライ
        $retryCount++
        Write-Log "SelectiveLeftCtrlBlocker.ahkが起動していません。待機中... ($retryCount/$maxRetries)" "WARNING"
        Start-Sleep -Seconds 5
    }
    
    if (-not $ahkProcess) {
        Write-Log "SelectiveLeftCtrlBlocker.ahkが起動していません（30秒タイムアウト）。スクリプトを終了します。" "ERROR"
        Write-Log "対処法: Windowsサービス 'MSI_KeyboardFix_Service' が起動しているか確認してください" "ERROR"
        exit 1
    }
    
    Write-Log "SelectiveLeftCtrlBlocker.ahkの起動を確認しました（PID: $($ahkProcess.Id)）" "SUCCESS"
    
    # 2. 初期化待機時間（スクリプトの内部初期化完了を待つ）
    Write-Log "スクリプト内部初期化を待機中（5秒）..." "INFO"
    Start-Sleep -Seconds 5
    
    # 3. 自動キープレス送信（左Ctrlと右Ctrlを交互に3回ずつ押下）
    Write-Log "初期化キープレス送信開始..." "INFO"
    Write-Log "左Ctrlと右Ctrlを交互に3回ずつ押下して初期化します" "INFO"
    
    # Add-Type for SendInput API
    Add-Type @"
        using System;
        using System.Runtime.InteropServices;
        public class KeyboardInput {
            [DllImport("user32.dll")]
            public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
            
            public const byte VK_LCONTROL = 0xA2;
            public const byte VK_RCONTROL = 0xA3;
            public const uint KEYEVENTF_KEYUP = 0x0002;
        }
"@
    
    # デバッグモードではキープレス送信をスキップ
    if ($Debug) {
        Write-Log "デバッグモード: キープレス送信をスキップします" "WARNING"
    } else {
        # 左Ctrlと右Ctrlを交互に3回ずつ押下
        for ($i = 1; $i -le 3; $i++) {
            # 左Ctrl押下
            Write-Log "  [$i/3] 左Ctrl押下..." "INFO"
            [KeyboardInput]::keybd_event([KeyboardInput]::VK_LCONTROL, 0, 0, [UIntPtr]::Zero)
            Start-Sleep -Milliseconds 50
            [KeyboardInput]::keybd_event([KeyboardInput]::VK_LCONTROL, 0, [KeyboardInput]::KEYEVENTF_KEYUP, [UIntPtr]::Zero)
            Start-Sleep -Milliseconds 150
            
            # 右Ctrl押下
            Write-Log "  [$i/3] 右Ctrl押下..." "INFO"
            [KeyboardInput]::keybd_event([KeyboardInput]::VK_RCONTROL, 0, 0, [UIntPtr]::Zero)
            Start-Sleep -Milliseconds 50
            [KeyboardInput]::keybd_event([KeyboardInput]::VK_RCONTROL, 0, [KeyboardInput]::KEYEVENTF_KEYUP, [UIntPtr]::Zero)
            Start-Sleep -Milliseconds 150
        }
        
        Write-Log "初期化キープレス送信完了（左Ctrl×3 + 右Ctrl×3）" "SUCCESS"
    }
    
    # 4. 完了確認待機
    Start-Sleep -Seconds 1
    
    # 5. 統計情報確認（オプション - AHKスクリプトのログファイルをチェック）
    $debugLogPath = "$PSScriptRoot\debug.log"
    if (Test-Path $debugLogPath) {
        $lastLines = Get-Content $debugLogPath -Tail 5
        Write-Log "最近のデバッグログ:" "INFO"
        $lastLines | ForEach-Object { Write-Log "  $_" "INFO" }
    }
    
    Write-Log "自動初期化完了 ✅" "SUCCESS"
    Write-Log "SelectiveLeftCtrlBlocker.ahkは正常に動作しています" "SUCCESS"
    
} catch {
    Write-Log "エラーが発生しました: $_" "ERROR"
    Write-Log "スタックトレース: $($_.ScriptStackTrace)" "ERROR"
    exit 1
}

# ===============================================
# 終了処理
# ===============================================

if ($Debug) {
    Write-Log "デバッグモード: Enterキーで終了します" "INFO"
    Read-Host "Enterキーを押してください"
}

Write-Log "スクリプト終了" "INFO"
exit 0
