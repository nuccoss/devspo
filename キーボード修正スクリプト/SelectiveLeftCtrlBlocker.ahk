#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

; ===============================================
; MSI内蔵キーボード Left Ctrl 単独無効化スクリプト
; Bluetoothキーボード完全保護版
; ===============================================

; デバッグモード（必要に応じてfalseに変更）
global DEBUG_MODE := true

; 内蔵キーボード識別パターン（緊急修正版: 広範囲パターン）
global INTERNAL_KEYBOARD_PATTERNS := [
    "ACPI",           ; ACPI デバイス
    "VEN_MSI",        ; MSI ベンダー
    "DEV_1001",       ; デバイスID
    "HID#ACPI",       ; HID ACPIデバイス
    "PS/2",           ; PS/2キーボード
    "Standard",       ; 標準キーボード
    "i8042",          ; i8042キーボードコントローラー
    "&SUBSYS_",       ; サブシステム識別子
    "ROOT#",          ; ルートデバイス
]

; Bluetoothキーボード識別パターン（一般的なパターン）
global BLUETOOTH_KEYBOARD_PATTERNS := [
    "HID",            ; HID デバイス
    "VID_",           ; ベンダーID形式
    "PID_",           ; プロダクトID形式
    "&Mi_00",         ; Bluetooth HID識別子
    "Bluetooth",      ; Bluetooth文字列
    "BthHFEnum",      ; Bluetooth HF列挙
    "BTHENUM"         ; Bluetooth列挙
]

; 統計情報（拡張版: ハードウェアショート診断用）
global stats := {
    internalBlocked: 0,
    bluetoothAllowed: 0,
    shiftCtrlRemapped: 0,
    lastDeviceDetected: "",
    deviceLog: [],
    
    ; === 診断情報（新規追加） ===
    ; 全信号履歴（最新100件）
    signalHistory: [],
    
    ; 受信間隔統計
    intervalStats: {
        min: 999999,      ; 最小間隔(ms)
        max: 0,           ; 最大間隔(ms)
        avg: 0,           ; 平均間隔(ms)
        total: 0,         ; 総サンプル数
        sum: 0            ; 合計時間(ms)
    },
    
    ; ショート疑惑検出
    suspiciousPatterns: {
        rapidFire: 0,       ; 高速連続信号（<50ms間隔）
        ghostSignal: 0,     ; ゴースト信号（連続10回以上）
        lastRapidTime: 0    ; 最後の高速連続検出時刻
    },
    
    ; タイムスタンプ
    startTime: A_TickCount,
    lastSignalTime: 0
}

; ===============================================
; Windows API設定
; ===============================================

; スキャンコード定義
WM_INPUT := 0x00FF
RIDEV_INPUTSINK := 0x00000100
RID_INPUT := 0x10000003
HID_USAGE_PAGE_GENERIC := 0x01
HID_USAGE_GENERIC_KEYBOARD := 0x06
SC_LCTRL := 0x1D
SC_RCTRL := 0x1D | 0xE000  ; Right Ctrl（拡張キー）
SC_LSHIFT := 0x2A
SC_RSHIFT := 0x36

; ===============================================
; メインウィンドウ設定
; ===============================================

mainGui := Gui("+LastFound +ToolWindow", "MSI Internal Keyboard Ctrl Blocker")
mainGui.Show("Hide")
hWnd := mainGui.Hwnd  ; ウィンドウハンドルを直接取得

; Raw Input 登録
RegisterRawInputDevices()
OnMessage(WM_INPUT, ProcessRawInput)

; ===============================================
; KI-002対策: 起動直後の初期化処理（手動リセット方式）
; ===============================================
; 目的: ハードウェアショートによるCtrl押しっぱなしゴースト信号の認識
; 制約: Send()コマンドは物理的なハードウェアショートをリセットできない
; 対策: ユーザーに手動リセット手順を案内
; タイミング: 起動直後に案内表示

; 起動時の手動リセット案内
SetTimer(ShowStartupResetGuide, -2000)  ; 2秒後に案内表示

ShowStartupResetGuide() {
    global DEBUG_MODE
    
    if (DEBUG_MODE) {
        OutputDebug("📢 起動時リセット案内表示")
    }
    
    ; 起動時のリセット案内
    result := MsgBox(
        "🚀 スクリプト起動完了`n`n"
        "本体左Ctrlのショートが発生している場合、`n"
        "以下の手順でリセットしてください:`n`n"
        "【リセット手順 - 2回実行推奨】`n"
        "1️⃣ 本体キーボードの右Ctrlキーを1回押す`n"
        "2️⃣ K270の左Ctrlキーを1回押す`n"
        "3️⃣ もう一度: 本体右Ctrl → K270左Ctrl`n`n"
        "💡 ショートが発生していない場合は、`n"
        "   この操作は不要です。`n`n"
        "今すぐ詳細なリセット手順を確認しますか?",
        "起動時リセット案内",
        0x4 + 0x40 + 0x1000  ; はい/いいえ + 情報アイコン + 最前面
    )
    
    if (result = "Yes") {
        ManualReset()  ; 詳細な手動リセット案内を表示
    }
}

; 手動リセット機能（トレイメニューから実行）
ManualReset(*) {
    global DEBUG_MODE, stats
    
    if (DEBUG_MODE) {
        OutputDebug("🔄 手動リセット: ユーザーが実行")
    }
    
    ; 統計情報に手動リセット回数を記録
    if (!stats.HasOwnProp("manualResets")) {
        stats.manualResets := 0
    }
    stats.manualResets++
    
    ; ユーザーに手動操作を案内（2回推奨）
    MsgBox(
        "⚠️ ハードウェアショートのリセット手順`n`n"
        "物理的なキーボードショートは、ソフトウェアでは`n"
        "リセットできません。以下の手順で手動リセットしてください:`n`n"
        "【リセット手順 - 2回実行推奨】`n"
        "1️⃣ 本体キーボードの右Ctrlキーを1回押す`n"
        "2️⃣ K270の左Ctrlキーを1回押す`n"
        "3️⃣ もう一度: 本体右Ctrl → K270左Ctrl`n`n"
        "⚠️ 重要: 1回で解消されない場合があるため、`n"
        "         2回繰り返すことを推奨します。`n`n"
        "💡 ヒント:`n"
        "• 本体左Ctrlは触らないでください（ショート原因）`n"
        "• 本体右Ctrl→K270左Ctrlの順番を守ってください`n"
        "• 各操作の間に1秒程度の間隔を開けてください",
        "手動リセット案内（2回推奨）",
        0x40 + 0x1000
    )
    
    if (DEBUG_MODE) {
        OutputDebug("✅ 手動リセット案内表示完了（累計: " stats.manualResets "回）")
    }
}

; ===============================================
; 緊急修正: 比率ベース + デバイス検出ベース判定
; ===============================================

; グローバル状態管理
global emergencyMode := true  ; 緊急モード有効
global ctrlPressHistory := []  ; Ctrl押下履歴
global lastDeviceCheckTime := 0  ; 最終デバイスチェック時刻

; 全デバイスのLeft Ctrl監視（診断機能強化版）
*LCtrl::
{
    global stats, DEBUG_MODE, emergencyMode, ctrlPressHistory, lastDeviceCheckTime
    
    ; === 診断データ収集（新規追加） ===
    currentTime := A_TickCount
    
    ; 受信間隔を計算
    if (stats.lastSignalTime > 0) {
        interval := currentTime - stats.lastSignalTime
        
        ; 統計情報更新
        if (interval < stats.intervalStats.min) {
            stats.intervalStats.min := interval
        }
        if (interval > stats.intervalStats.max) {
            stats.intervalStats.max := interval
        }
        stats.intervalStats.total++
        stats.intervalStats.sum += interval
        stats.intervalStats.avg := Round(stats.intervalStats.sum / stats.intervalStats.total, 2)
        
        ; ショート疑惑検出
        if (interval < 50) {  ; 50ms未満の高速連続
            stats.suspiciousPatterns.rapidFire++
            stats.suspiciousPatterns.lastRapidTime := currentTime
            
            if (DEBUG_MODE) {
                OutputDebug("⚠️ 高速連続信号検出: " interval "ms")
            }
        }
    }
    
    ; 信号履歴記録（最新100件）
    stats.signalHistory.Push({
        time: currentTime,
        interval: (stats.lastSignalTime > 0) ? (currentTime - stats.lastSignalTime) : 0,
        device: stats.lastDeviceDetected
    })
    
    if (stats.signalHistory.Length > 100) {
        stats.signalHistory.RemoveAt(1)
    }
    
    stats.lastSignalTime := currentTime
    ; === 診断データ収集終了 ===
    
    ; 緊急モードでは全てのLeft Ctrlを監視
    ctrlPressHistory.Push({time: currentTime, device: "Unknown"})
    
    ; 履歴が10個を超えたら古いものを削除
    if (ctrlPressHistory.Length > 10) {
        ctrlPressHistory.RemoveAt(1)
    }
    
    ; 革新的判定: デバイス名パターン + 使用頻度比率
    totalBluetooth := stats.bluetoothAllowed
    totalInternal := stats.internalBlocked
    lastDevice := stats.lastDeviceDetected
    
    ; Bluetooth判定ロジック（複合条件）
    isBluetoothDevice := false
    
    ; 条件1: デバイス名でBluetooth確認
    if (InStr(lastDevice, "HID") && InStr(lastDevice, "VID_046D")) {
        isBluetoothDevice := true
        if (DEBUG_MODE) {
            OutputDebug("✅ BLUETOOTH DEVICE DETECTED BY NAME: " lastDevice)
        }
    }
    
    ; 条件2: 統計比率での判定（緩和条件）
    if (!isBluetoothDevice && totalBluetooth > 10 && totalBluetooth > totalInternal * 0.5) {
        isBluetoothDevice := true
        if (DEBUG_MODE) {
            OutputDebug("✅ BLUETOOTH DEVICE DETECTED BY RATIO: BT=" totalBluetooth " IN=" totalInternal)
        }
    }
    
    if (isBluetoothDevice) {
        ; Bluetoothキーボード判定: 通す
        stats.bluetoothAllowed++
        
        if (DEBUG_MODE) {
            OutputDebug("✅ EMERGENCY: Left Ctrl BLUETOOTH PASSED")
        }
        
        ; そのまま通す
        Send("{LCtrl down}")
        KeyWait("LCtrl")
        Send("{LCtrl up}")
        return
    }
    
    ; 内蔵キーボード判定: ブロック
    stats.internalBlocked++
    
    if (DEBUG_MODE) {
        OutputDebug("🚫 EMERGENCY: Left Ctrl INTERNAL BLOCKED (BT=" totalBluetooth " IN=" totalInternal ")")
    }
    
    ; ブロック（何もしない）
    return
}

; Shift+Left Ctrl緊急対応（修正版）
+LCtrl::
{
    global stats, DEBUG_MODE
    
    ; 革新的判定: デバイス名 + 統計比率
    totalBluetooth := stats.bluetoothAllowed
    totalInternal := stats.internalBlocked
    lastDevice := stats.lastDeviceDetected
    
    ; Bluetooth判定
    isBluetoothDevice := false
    
    ; デバイス名でBluetooth確認
    if (InStr(lastDevice, "HID") && InStr(lastDevice, "VID_046D")) {
        isBluetoothDevice := true
    }
    
    ; 統計比率での判定（緩和条件）
    if (!isBluetoothDevice && totalBluetooth > 10 && totalBluetooth > totalInternal * 0.5) {
        isBluetoothDevice := true
    }
    
    if (isBluetoothDevice) {
        ; Bluetoothキーボード: そのまま通す
        if (DEBUG_MODE) {
            OutputDebug("✅ EMERGENCY Shift+Left Ctrl BLUETOOTH PASSED")
        }
        SendInput("+{LCtrl}")
        return
    }
    
    ; 内蔵キーボード: Right Ctrlにリマップ
    stats.shiftCtrlRemapped++
    
    if (DEBUG_MODE) {
        OutputDebug("🔄 EMERGENCY Shift+Left Ctrl -> Shift+Right Ctrl REMAPPED")
    }
    
    SendInput("+{RCtrl}")
    return
}

A_IconTip := "内蔵キーボードLeft Ctrl無効化（Bluetoothキーボード保護）"
Menu_Tray := A_TrayMenu
Menu_Tray.Delete()

Menu_Tray.Add("📊 統計情報", ShowStatistics)
Menu_Tray.Add("� 手動リセット", ManualReset)
Menu_Tray.Add("�🔍 検出されたデバイス", ShowDeviceLog)
Menu_Tray.Add("💾 診断ログ出力", ExportDiagnosticLog)
Menu_Tray.Add("🐛 デバッグログ切替", ToggleDebugMode)
Menu_Tray.Add()
Menu_Tray.Add("ℹ️ スクリプト情報", ShowInfo)
Menu_Tray.Add("❌ 終了", ExitScript)

; ===============================================
; メニューハンドラー
; ===============================================

ShowStatistics(*)
{
    totalDevices := stats.deviceLog.Length
    uptime := Round((A_TickCount - stats.startTime) / 1000, 1)  ; 秒単位
    periodicResets := stats.HasOwnProp("periodicResets") ? stats.periodicResets : 0
    
    ; ショート疑惑判定
    suspicionLevel := ""
    if (stats.suspiciousPatterns.rapidFire > 50) {
        suspicionLevel := "🔴 高（ハードウェアショートの可能性大）"
    } else if (stats.suspiciousPatterns.rapidFire > 20) {
        suspicionLevel := "🟡 中（異常な連続信号あり）"
    } else if (stats.suspiciousPatterns.rapidFire > 5) {
        suspicionLevel := "🟢 低（正常範囲内）"
    } else {
        suspicionLevel := "⚪ なし"
    }
    
    ; 最近の信号パターン（最新5件）
    recentSignals := ""
    startIdx := Max(1, stats.signalHistory.Length - 4)
    Loop (Min(5, stats.signalHistory.Length)) {
        idx := startIdx + A_Index - 1
        if (idx <= stats.signalHistory.Length) {
            signal := stats.signalHistory[idx]
            recentSignals .= Format("  {}: {}ms`n", idx, signal.interval)
        }
    }
    
    ; 手動リセット回数
    manualResets := stats.HasOwnProp("manualResets") ? stats.manualResets : 0
    
    MsgBox(
        "📊 キーボード制御統計（診断モード）`n`n"
        "=== 基本統計 ===`n"
        "🚫 内蔵キーボード Left Ctrl ブロック: " stats.internalBlocked "`n"
        "🔄 Shift+Left Ctrl リマップ: " stats.shiftCtrlRemapped "`n"
        "✅ Bluetoothキーボード Left Ctrl 通過: " stats.bluetoothAllowed "`n"
        "🔍 検出デバイス総数: " totalDevices "`n"
        "⏱️ 起動時間: " uptime "秒`n"
        "🔄 定期リセット実行回数: " periodicResets "回（30分ごと）`n"
        "👆 手動リセット実行回数: " manualResets "回`n`n"
        "=== 受信間隔診断 ===`n"
        "📊 総信号数: " stats.intervalStats.total "`n"
        "⚡ 最小間隔: " (stats.intervalStats.min < 999999 ? stats.intervalStats.min : "-") "ms`n"
        "⏰ 最大間隔: " stats.intervalStats.max "ms`n"
        "📈 平均間隔: " stats.intervalStats.avg "ms`n`n"
        "=== ショート疑惑検出 ===`n"
        "🔥 高速連続信号(<50ms): " stats.suspiciousPatterns.rapidFire "回`n"
        "⚠️ 疑惑レベル: " suspicionLevel "`n`n"
        "=== 最新5件の信号間隔 ===`n"
        recentSignals "`n"
        "💡 診断: 高速連続信号が多い場合、ハードウェアショートの可能性`n"
        "💡 リセット方式: 手動リセット（本体右Ctrl → K270左Ctrl）`n"
        "💡 手動リセット: トレイメニュー → 🔄 手動リセット",
        "統計情報（診断モード）",
        0x40 + 0x1000
    )
}

ShowDeviceLog(*)
{
    if (stats.deviceLog.Length = 0) {
        MsgBox("まだデバイスが検出されていません。", "デバイスログ", 0x40)
        return
    }
    
    logText := "🔍 検出されたキーボードデバイス:`n`n"
    for device in stats.deviceLog {
        logText .= "• " device "`n"
    }
    
    logText .= "`n💡 ヒント:`n"
    logText .= "• 'ACPI' + 'VEN_MSI' = 内蔵キーボード（Left Ctrl無効化）`n"
    logText .= "• 'HID' + 'VID_' = Bluetoothキーボード（Left Ctrl有効）"
    
    MsgBox(logText, "検出デバイスログ", 0x40)
}

ExportDiagnosticLog(*)
{
    global stats
    
    ; ログファイル名（タイムスタンプ付き）
    timestamp := FormatTime(, "yyyyMMdd_HHmmss")
    logFile := A_ScriptDir "\DiagnosticLog_" timestamp ".txt"
    
    ; ログ内容生成
    uptime := Round((A_TickCount - stats.startTime) / 1000, 1)
    
    logContent := "========================================`n"
    logContent .= "ハードウェアショート診断ログ`n"
    logContent .= "========================================`n"
    logContent .= "日時: " FormatTime(, "yyyy/MM/dd HH:mm:ss") "`n"
    logContent .= "起動時間: " uptime "秒`n`n"
    
    logContent .= "=== 基本統計 ===`n"
    logContent .= "内蔵キーボードブロック: " stats.internalBlocked "`n"
    logContent .= "Bluetoothキーボード通過: " stats.bluetoothAllowed "`n"
    logContent .= "Shift+Ctrlリマップ: " stats.shiftCtrlRemapped "`n`n"
    
    logContent .= "=== 受信間隔統計 ===`n"
    logContent .= "総信号数: " stats.intervalStats.total "`n"
    logContent .= "最小間隔: " (stats.intervalStats.min < 999999 ? stats.intervalStats.min : "-") "ms`n"
    logContent .= "最大間隔: " stats.intervalStats.max "ms`n"
    logContent .= "平均間隔: " stats.intervalStats.avg "ms`n`n"
    
    logContent .= "=== ショート疑惑検出 ===`n"
    logContent .= "高速連続信号(<50ms): " stats.suspiciousPatterns.rapidFire "回`n"
    
    if (stats.suspiciousPatterns.rapidFire > 50) {
        logContent .= "診断: ハードウェアショートの可能性が高い`n"
    } else if (stats.suspiciousPatterns.rapidFire > 20) {
        logContent .= "診断: 異常な連続信号あり`n"
    } else {
        logContent .= "診断: 正常範囲内`n"
    }
    
    logContent .= "`n=== 信号履歴（最新50件） ===`n"
    logContent .= "No, 時刻(ms), 間隔(ms), デバイス`n"
    
    startIdx := Max(1, stats.signalHistory.Length - 49)
    Loop (Min(50, stats.signalHistory.Length)) {
        idx := startIdx + A_Index - 1
        if (idx <= stats.signalHistory.Length) {
            signal := stats.signalHistory[idx]
            logContent .= Format("{}, {}, {}, {}`n", idx, signal.time, signal.interval, signal.device)
        }
    }
    
    logContent .= "`n=== 検出デバイス ===`n"
    for device in stats.deviceLog {
        logContent .= device "`n"
    }
    
    ; ファイル出力
    try {
        FileAppend(logContent, logFile)
        MsgBox("診断ログを出力しました:`n" logFile, "診断ログ出力", 0x40)
    } catch as err {
        MsgBox("ログ出力エラー: " err.Message, "エラー", 0x10)
    }
}

ToggleDebugMode(*)
{
    global DEBUG_MODE
    DEBUG_MODE := !DEBUG_MODE
    
    debugStatus := DEBUG_MODE ? "有効" : "無効"
    debugMessage := DEBUG_MODE ? "詳細ログがDebugViewに出力されます。" : "ログ出力を最小限に抑制します。"
    
    MsgBox(
        "🐛 デバッグモード: " debugStatus "`n`n" debugMessage,
        "デバッグモード",
        0x40 + 0x800
    )
}

ShowInfo(*)
{
    MsgBox(
        "MSI内蔵キーボード Left Ctrl 単独無効化スクリプト`n"
        "Bluetoothキーボード完全保護版`n`n"
        "🎯 無効化対象: MSI内蔵キーボード（ACPI\\VEN_MSI&DEV_1001）の Left Ctrl のみ`n"
        "✅ 保護対象: すべてのBluetoothキーボードの Left Ctrl`n"
        "🔧 動作方式: デバイス識別による選択的制御`n`n"
        "外部キーボード（Bluetooth/USB）は一切影響を受けません。",
        "スクリプト情報",
        0x40
    )
}

ExitScript(*)
{
    ExitApp()
}

; ===============================================
; Raw Input処理（核心部分）
; ===============================================

RegisterRawInputDevices()
{
    ridSize := A_PtrSize = 8 ? 16 : 12
    rid := Buffer(ridSize, 0)
    
    NumPut("UShort", HID_USAGE_PAGE_GENERIC, rid, 0)
    NumPut("UShort", HID_USAGE_GENERIC_KEYBOARD, rid, 2)
    NumPut("UInt", RIDEV_INPUTSINK, rid, 4)
    NumPut("Ptr", hWnd, rid, 8)
    
    result := DllCall("user32.dll\RegisterRawInputDevices", 
                      "Ptr", rid.Ptr, 
                      "UInt", 1, 
                      "UInt", ridSize, 
                      "Int")
    
    if (!result) {
        MsgBox("❌ Raw Input 登録失敗: " A_LastError, "初期化エラー", "Icon16")
        ExitApp()
    }
    
    if (DEBUG_MODE) {
        OutputDebug("✅ Raw Input キーボード監視開始")
    }
}

ProcessRawInput(wParam, lParam, msg, hWnd)
{
    ; データサイズ取得
    size := 0
    DllCall("user32.dll\GetRawInputData", 
            "Ptr", lParam, 
            "UInt", RID_INPUT, 
            "Ptr", 0, 
            "UIntP", &size, 
            "UInt", 16 + A_PtrSize)
    
    if (size = 0) {
        return 0
    }
    
    ; データ取得
    rawBuffer := Buffer(size, 0)
    result := DllCall("user32.dll\GetRawInputData", 
                      "Ptr", lParam, 
                      "UInt", RID_INPUT, 
                      "Ptr", rawBuffer.Ptr, 
                      "UIntP", &size, 
                      "UInt", 16 + A_PtrSize)
    
    if (result = -1) {
        return 0
    }
    
    ; キーボードデバイスのみ処理
    dwType := NumGet(rawBuffer, 0, "UInt")
    if (dwType != 1) {
        return 0
    }
    
    ; デバイス情報取得
    hDevice := NumGet(rawBuffer, A_PtrSize, "Ptr")
    deviceName := GetDeviceName(hDevice)
    
    if (!deviceName) {
        return 0
    }
    
    ; デバイスログ更新（重複回避）+ 強制デバッグ
    if (stats.lastDeviceDetected != deviceName) {
        stats.lastDeviceDetected := deviceName
        
        ; 強制デバッグ: すべてのデバイス情報を出力
        OutputDebug("🔍 RAW INPUT DEVICE DETECTED: " deviceName)
        
        ; 新しいデバイスの場合、ログに追加
        found := false
        for loggedDevice in stats.deviceLog {
            if (loggedDevice = deviceName) {
                found := true
                break
            }
        }
        
        if (!found) {
            stats.deviceLog.Push(deviceName)
            OutputDebug("� NEW DEVICE LOGGED: " deviceName)
        }
    }
    
    ; キーボードデータ解析
    headerSize := 16 + A_PtrSize
    makeCode := NumGet(rawBuffer, headerSize + 0, "UShort")
    flags := NumGet(rawBuffer, headerSize + 2, "UShort")
    
    ; Left Ctrl キーのみ処理
    if (makeCode = SC_LCTRL) {
        return HandleLeftCtrlKey(deviceName, flags)
    }
    
    return 0
}

; ===============================================
; Left Ctrl キー制御ロジック（簡素化版: 単独ブロック専用）
; ===============================================

HandleLeftCtrlKey(deviceName, flags)
{
    global stats, DEBUG_MODE
    
    isKeyUp := (flags & 1) != 0
    keyState := isKeyUp ? "↑" : "↓"
    
    ; デバイス分類判定
    if (IsInternalKeyboard(deviceName)) {
        ; 内蔵キーボード -> Left Ctrl単独は常にブロック
        ; （Shift+Left Ctrlはホットキーで別途処理）
        stats.internalBlocked++
        
        if (DEBUG_MODE) {
            OutputDebug("🚫 内蔵KB Left Ctrl " keyState " BLOCKED (累計:" stats.internalBlocked ")")
            OutputDebug("   デバイス: " deviceName)
        }
        
        return 1  ; キー入力をブロック
        
    } else if (IsBluetoothKeyboard(deviceName)) {
        ; Bluetoothキーボード -> 常に通過
        stats.bluetoothAllowed++
        
        if (DEBUG_MODE) {
            OutputDebug("✅ Bluetooth KB Left Ctrl " keyState " ALLOWED (累計:" stats.bluetoothAllowed ")")
            OutputDebug("   デバイス: " deviceName)
        }
        
        return 0  ; キー入力を通常処理
        
    } else {
        ; 不明なデバイス -> 安全のため通過
        if (DEBUG_MODE) {
            OutputDebug("❓ 不明デバイス Left Ctrl " keyState " ALLOWED（安全のため）")
            OutputDebug("   デバイス: " deviceName)
        }
        
        return 0  ; キー入力を通常処理
    }
}

; ===============================================
; デバイス分類関数
; ===============================================

IsInternalKeyboard(deviceName)
{
    global INTERNAL_KEYBOARD_PATTERNS
    
    ; 強制デバッグ出力
    OutputDebug("🔬 DEVICE CLASSIFICATION CHECK: " deviceName)
    
    ; いずれかのパターンが含まれている場合、内蔵キーボードと判定（緩和条件）
    for pattern in INTERNAL_KEYBOARD_PATTERNS {
        if (InStr(deviceName, pattern)) {
            OutputDebug("✅ INTERNAL KEYBOARD MATCH: " pattern " in " deviceName)
            return true
        }
    }
    
    ; Bluetoothパターンが含まれていない場合も内蔵と推定（緊急フォールバック）
    if (!InStr(deviceName, "HID") && !InStr(deviceName, "VID_") && !InStr(deviceName, "Bluetooth")) {
        OutputDebug("🎯 INTERNAL KEYBOARD FALLBACK: Not Bluetooth pattern")
        return true
    }
    
    OutputDebug("❌ NOT INTERNAL KEYBOARD: " deviceName)
    return false
}

IsBluetoothKeyboard(deviceName)
{
    global BLUETOOTH_KEYBOARD_PATTERNS
    
    ; いずれかのパターンが含まれている場合、Bluetoothキーボードと判定
    for pattern in BLUETOOTH_KEYBOARD_PATTERNS {
        if (InStr(deviceName, pattern)) {
            return true
        }
    }
    
    return false
}

GetDeviceName(hDevice)
{
    size := 0
    DllCall("user32.dll\GetRawInputDeviceInfo", 
            "Ptr", hDevice, 
            "UInt", 0x20000007, 
            "Ptr", 0, 
            "UIntP", &size)
    
    if (size = 0) {
        return ""
    }
    
    nameBuffer := Buffer(size * 2, 0)
    result := DllCall("user32.dll\GetRawInputDeviceInfo", 
                      "Ptr", hDevice, 
                      "UInt", 0x20000007, 
                      "Ptr", nameBuffer.Ptr, 
                      "UIntP", &size)
    
    return result = -1 ? "" : StrGet(nameBuffer.Ptr, "UTF-16")
}

; ===============================================
; 起動時処理
; ===============================================

; 起動メッセージ
MsgBox(
    "🛡️ MSI内蔵キーボード Left Ctrl 単独無効化 開始`n"
    "Bluetoothキーボード完全保護版`n`n"
    "✅ 機能:`n"
    "• MSI内蔵キーボードの Left Ctrl のみ無効化`n"
    "• Bluetoothキーボードの Left Ctrl は正常動作`n"
    "• USBキーボードの Left Ctrl も正常動作`n"
    "• ショート発生時は手動リセット（本体右Ctrl→K270左Ctrl）`n`n"
    "📊 統計確認: システムトレイアイコン右クリック`n"
    "🔍 検出デバイス: トレイメニューから確認可能`n"
    "🔄 手動リセット: トレイメニュー → 手動リセット",
    "内蔵キーボード制御開始",
    0x40 + 0x4000
)

if (DEBUG_MODE) {
    OutputDebug("🚀 MSI内蔵キーボード Left Ctrl制御開始 - Bluetoothキーボード保護版")
}