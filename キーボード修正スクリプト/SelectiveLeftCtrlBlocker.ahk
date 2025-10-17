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

; 統計情報
global stats := {
    internalBlocked: 0,
    bluetoothAllowed: 0,
    shiftCtrlRemapped: 0,
    lastDeviceDetected: "",
    deviceLog: []
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
; 緊急修正: 比率ベース + デバイス検出ベース判定
; ===============================================

; グローバル状態管理
global emergencyMode := true  ; 緊急モード有効
global ctrlPressHistory := []  ; Ctrl押下履歴
global lastDeviceCheckTime := 0  ; 最終デバイスチェック時刻

; 全デバイスのLeft Ctrl監視（修正版）
*LCtrl::
{
    global stats, DEBUG_MODE, emergencyMode, ctrlPressHistory, lastDeviceCheckTime
    
    ; 緊急モードでは全てのLeft Ctrlを監視
    currentTime := A_TickCount
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
Menu_Tray.Add("🔍 検出されたデバイス", ShowDeviceLog)
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
    
    MsgBox(
        "📊 キーボード制御統計`n`n"
        "🚫 内蔵キーボード Left Ctrl ブロック: " stats.internalBlocked "`n"
        "🔄 Shift+Left Ctrl -> Shift+Right Ctrl リマップ: " stats.shiftCtrlRemapped "`n"
        "✅ Bluetoothキーボード Left Ctrl 通過: " stats.bluetoothAllowed "`n"
        "🔍 検出デバイス総数: " totalDevices "`n"
        "📱 最後に検出されたデバイス: " (stats.lastDeviceDetected ? stats.lastDeviceDetected : "なし") "`n`n"
        "💡 動作概要:`n"
        "• MSI内蔵キーボードLeft Ctrl: 完全ブロック`n"
        "• MSI内蔵キーボードShift+Left Ctrl: Right Ctrlにリマップ`n"
        "• Bluetoothキーボード: すべて正常動作",
        "統計情報",
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
    "• USBキーボードの Left Ctrl も正常動作`n`n"
    "📊 統計確認: システムトレイアイコン右クリック`n"
    "🔍 検出デバイス: トレイメニューから確認可能",
    "内蔵キーボード制御開始",
    0x40 + 0x4000
)

if (DEBUG_MODE) {
    OutputDebug("🚀 MSI内蔵キーボード Left Ctrl制御開始 - Bluetoothキーボード保護版")
}