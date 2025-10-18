# ===============================================
# 自動初期化スクリプトのスタートアップ登録
# KI-002対策: SendInitialKeypress.ps1の自動実行設定
# ===============================================

#Requires -RunAsAdministrator

param(
    [switch]$Uninstall,
    [switch]$Debug
)

$ErrorActionPreference = "Stop"

# ログ関数
function Write-ColorLog {
    param([string]$Message, [string]$Color = "Cyan")
    Write-Host $Message -ForegroundColor $Color
}

# ===============================================
# 設定
# ===============================================

$scriptName = "SendInitialKeypress"
$scriptPath = Join-Path $PSScriptRoot "SendInitialKeypress.ps1"
$taskName = "MSI_KeyboardFix_AutoInitialization"
$taskDescription = "SelectiveLeftCtrlBlocker.ahk自動初期化（KI-002対策）"

# ===============================================
# アンインストール処理
# ===============================================

if ($Uninstall) {
    Write-ColorLog "`n🗑️ 自動初期化スクリプトをアンインストールします..." "Yellow"
    
    try {
        # タスクスケジューラから削除
        $task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
        if ($task) {
            Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
            Write-ColorLog "✅ タスクスケジューラから削除しました" "Green"
        } else {
            Write-ColorLog "⚠️ タスクが見つかりません（既に削除済み？）" "Yellow"
        }
        
        Write-ColorLog "`n✅ アンインストール完了" "Green"
        exit 0
        
    } catch {
        Write-ColorLog "❌ アンインストール失敗: $_" "Red"
        exit 1
    }
}

# ===============================================
# インストール処理
# ===============================================

Write-ColorLog "`n╔══════════════════════════════════════════════════════════════════╗" "Magenta"
Write-ColorLog "║  🚀 KI-002対策: 自動初期化スクリプト インストール               ║" "Magenta"
Write-ColorLog "╚══════════════════════════════════════════════════════════════════╝" "Magenta"

# 1. スクリプト存在確認
Write-ColorLog "`n📝 Step 1: スクリプトファイル確認" "Cyan"
if (-not (Test-Path $scriptPath)) {
    Write-ColorLog "❌ SendInitialKeypress.ps1が見つかりません: $scriptPath" "Red"
    exit 1
}
Write-ColorLog "✅ スクリプトファイル確認完了" "Green"

# 2. 既存タスクの削除
Write-ColorLog "`n🔄 Step 2: 既存タスクの確認と削除" "Cyan"
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-ColorLog "⚠️ 既存のタスクを削除します..." "Yellow"
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-ColorLog "✅ 既存タスク削除完了" "Green"
} else {
    Write-ColorLog "✅ 既存タスクなし" "Green"
}

# 3. タスクスケジューラにタスクを作成
Write-ColorLog "`n⚙️ Step 3: タスクスケジューラへの登録" "Cyan"

try {
    # タスクアクション定義
    $action = New-ScheduledTaskAction `
        -Execute "powershell.exe" `
        -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`""
    
    # トリガー定義（ログイン時、15秒遅延）
    # SelectiveLeftCtrlBlockerが起動してから実行されるように遅延を設定
    $trigger = New-ScheduledTaskTrigger `
        -AtLogOn `
        -User $env:USERNAME
    
    # 遅延設定（15秒待機してからスクリプト実行 - SelectiveLeftCtrlBlocker起動を確実に待つ）
    $trigger.Delay = "PT15S"  # ISO 8601形式: 15秒
    
    # タスク設定
    $settings = New-ScheduledTaskSettingsSet `
        -AllowStartIfOnBatteries `
        -DontStopIfGoingOnBatteries `
        -StartWhenAvailable `
        -RunOnlyIfNetworkAvailable:$false `
        -ExecutionTimeLimit (New-TimeSpan -Minutes 2)
    
    # プリンシパル設定（最高権限で実行）
    $principal = New-ScheduledTaskPrincipal `
        -UserId $env:USERNAME `
        -LogonType Interactive `
        -RunLevel Highest
    
    # タスク登録
    Register-ScheduledTask `
        -TaskName $taskName `
        -Description $taskDescription `
        -Action $action `
        -Trigger $trigger `
        -Settings $settings `
        -Principal $principal `
        -Force | Out-Null
    
    Write-ColorLog "✅ タスクスケジューラ登録完了" "Green"
    
} catch {
    Write-ColorLog "❌ タスク登録失敗: $_" "Red"
    exit 1
}

# 4. 登録内容確認
Write-ColorLog "`n✅ Step 4: 登録内容確認" "Cyan"
$registeredTask = Get-ScheduledTask -TaskName $taskName
Write-ColorLog "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "White"
Write-ColorLog "タスク名    : $($registeredTask.TaskName)" "White"
Write-ColorLog "説明        : $($registeredTask.Description)" "White"
Write-ColorLog "状態        : $($registeredTask.State)" "White"
Write-ColorLog "実行ユーザー: $env:USERNAME" "White"
Write-ColorLog "トリガー    : ログイン時（15秒遅延）" "White"
Write-ColorLog "スクリプト  : $scriptPath" "White"
Write-ColorLog "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "White"

# 5. テスト実行（オプション）
Write-ColorLog "`n🧪 Step 5: テスト実行（オプション）" "Cyan"
$testChoice = Read-Host "今すぐテスト実行しますか？ (Y/N)"

if ($testChoice -eq "Y" -or $testChoice -eq "y") {
    Write-ColorLog "`n🔬 テスト実行中..." "Yellow"
    
    if ($Debug) {
        & $scriptPath -Debug
    } else {
        Start-ScheduledTask -TaskName $taskName
        Start-Sleep -Seconds 3
        
        # ログファイル確認
        $logFile = Join-Path $PSScriptRoot "SendInitialKeypress.log"
        if (Test-Path $logFile) {
            Write-ColorLog "`n📋 最新ログ:" "Cyan"
            Get-Content $logFile -Tail 10 | ForEach-Object {
                Write-ColorLog "  $_" "White"
            }
        }
    }
    
    Write-ColorLog "`n✅ テスト実行完了" "Green"
}

# 6. 完了
Write-ColorLog "`n╔══════════════════════════════════════════════════════════════════╗" "Green"
Write-ColorLog "║  ✅ KI-002対策インストール完了                                   ║" "Green"
Write-ColorLog "╚══════════════════════════════════════════════════════════════════╝" "Green"

Write-ColorLog "`n📌 設定内容:" "Cyan"
Write-ColorLog "  ✅ ログイン時に自動実行" "White"
Write-ColorLog "  ✅ SelectiveLeftCtrlBlocker.ahk起動の15秒後に実行" "White"
Write-ColorLog "  ✅ 左Ctrlと右Ctrlを交互に3回ずつ自動押下" "White"
Write-ColorLog "  ✅ KI-002（起動時Left Ctrl連続信号）を自動解決" "White"

Write-ColorLog "`n🎯 期待される効果:" "Cyan"
Write-ColorLog "  • ログイン後の手動Right Ctrl押下が不要に" "White"
Write-ColorLog "  • 起動直後から正常動作" "White"
Write-ColorLog "  • ロック画面からの復帰も自動初期化" "White"

Write-ColorLog "`n💡 次回ログイン時から有効になります" "Yellow"
Write-ColorLog "💡 今すぐ有効にするには、ログアウト→ログインしてください" "Yellow"

Write-ColorLog "`n🗑️ アンインストール方法:" "Cyan"
Write-ColorLog "  .\RegisterAutoInitialization.ps1 -Uninstall" "White"

Write-ColorLog "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "White"

if (-not $Debug) {
    Read-Host "`nEnterキーを押して終了してください"
}

exit 0
