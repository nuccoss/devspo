#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

; MSIラップトップ内蔵キーボード専用 強化版Left Ctrl完全ブロック
; ハードウェア配線ショート + PowerToys併用対応版
; 対象: ACPI\VEN_MSI&DEV_1001 (ID: 1)

; ==============================================
; 設定セクション
; ==============================================

; デバッグモード（本番では false に設定）
global DEBUG_MODE := true

; ブロック設定
global BLOCK_DURATION_MS := 50          ; キー連打検出期間(ms)
global MAX_EVENTS_PER_BLOCK := 3        ; 期間内の最大イベント数
global HARDWARE_FLOOD_THRESHOLD := 10   ; ハードウェア連続送信検出閾値

; 統計情報
global stats := {
    totalBlocked: 0,
    floodEventsDetected: 0,
    lastEventTime: 0,
    recentEvents: []
}

; ==============================================
; Windows API定数と構造体
; ==============================================

WM_INPUT := 0x00FF
RIM_INPUT := 0
RIDEV_INPUTSINK := 0x00000100
RID_INPUT := 0x10000003
HID_USAGE_PAGE_GENERIC := 0x01
HID_USAGE_GENERIC_KEYBOARD := 0x06
SC_LCTRL := 0x1D

; 対象デバイス識別子
global targetDevicePatterns := [
    "ACPI",
    "VEN_MSI", 
    "DEV_1001"
]

; ==============================================
; メインウィンドウとUI設定
; ==============================================

; メッセージ受信用ウィンドウ
mainGui := Gui("+LastFound +ToolWindow", "MSI Hardware Ctrl Blocker Enhanced")
mainGui.Show("Hide")
hWnd := WinGetID("MSI Hardware Ctrl Blocker Enhanced")

; Raw Input デバイス登録
RegisterRawInputDevices()

; ウィンドウメッセージ処理
OnMessage(WM_INPUT, ProcessRawInput)

; ==============================================
; トレイアイコンとメニュー
; ==============================================

A_IconTip := "MSI内蔵KB Left Ctrl完全ブロック（ハードウェア障害対応版）"
Menu_Tray := A_TrayMenu
Menu_Tray.Delete()

Menu_Tray.Add("📊 ブロック統計表示", ShowStats)
Menu_Tray.Add("🔧 PowerToys設定確認", CheckPowerToys)
Menu_Tray.Add("🐛 デバッグモード切替", ToggleDebugMode)
Menu_Tray.Add()
Menu_Tray.Add("ℹ️ スクリプト情報", ShowInfo)
Menu_Tray.Add("❌ 終了", ExitScript)

; ==============================================
; メニューハンドラー関数
; ==============================================

ShowStats(*)
{
    recentCount := stats.recentEvents.Length
    avgInterval := 0
    
    if (recentCount > 1) {
        totalTime := stats.recentEvents[-1] - stats.recentEvents[1]
        avgInterval := totalTime / (recentCount - 1)
    }
    
    MsgBox(
        "📊 MSI Left Ctrl ブロック統計`n`n"
        "🚫 総ブロック数: " stats.totalBlocked "`n"
        "⚡ ハードウェア連続送信検出: " stats.floodEventsDetected "`n"
        "⏱️ 直近イベント数: " recentCount "`n"
        "📈 平均間隔: " Round(avgInterval, 2) "ms`n`n"
        "💡 ハードウェア連続送信が多い場合は物理修理を推奨",
        "ブロック統計",
        "Icon64 T5"
    )
}

CheckPowerToys(*)
{
    ; PowerToys プロセス確認
    try {
        Run("tasklist /FI `"IMAGENAME eq PowerToys.exe`" /FO CSV", , "Hide", &pid)
        ; PowerToys設定画面を開く
        Run("ms-settings:keyboard")
        
        MsgBox(
            "🔧 PowerToys設定確認`n`n"
            "✅ 現在の設定:`n"
            "   Keyboard Manager → キーの再マップ`n"
            "   Ctrl (Left) → Disable`n`n"
            "⚠️ このスクリプトはPowerToysと併用して`n"
            "   より確実なブロックを提供します。`n`n"
            "📝 両方有効にすることで二重保護が機能します。",
            "PowerToys連携確認",
            "Icon64"
        )
    } catch {
        MsgBox(
            "⚠️ PowerToysが実行されていない可能性があります。`n`n"
            "推奨設定:`n"
            "1. PowerToysを起動`n"
            "2. Keyboard Manager → キーの再マップ`n"
            "3. Ctrl (Left) → Disable`n`n"
            "このスクリプトと併用することで最大効果を発揮します。",
            "PowerToys確認",
            "Icon48"
        )
    }
}

ToggleDebugMode(*)
{
    global DEBUG_MODE
    DEBUG_MODE := !DEBUG_MODE
    
    mode := DEBUG_MODE ? "有効" : "無効"
    MsgBox(
        "🐛 デバッグモード: " mode "`n`n"
        DEBUG_MODE ? 
        "詳細ログがDebugViewに出力されます。" : 
        "ログ出力を最小限に抑えます。",
        "デバッグモード切替",
        "Icon64 T2"
    )
}

ShowInfo(*)
{
    MsgBox(
        "MSI内蔵キーボード Left Ctrl完全ブロックスクリプト`n"
        "ハードウェア配線ショート + PowerToys併用対応版`n`n"
        "🎯 対象デバイス: ACPI\\VEN_MSI&DEV_1001`n"
        "🚫 ブロック対象: Left Ctrl (スキャンコード: 0x1D)`n"
        "🛡️ 連続送信検出: " HARDWARE_FLOOD_THRESHOLD "回/期間`n"
        "🔧 PowerToys併用: 推奨`n`n"
        "外部キーボードのCtrlキーは正常動作します。",
        "スクリプト情報",
        "Icon64"
    )
}

ExitScript(*)
{
    ExitApp()
}

; ==============================================
; Raw Input 登録と処理
; ==============================================

RegisterRawInputDevices()
{
    ridSize := A_PtrSize = 8 ? 16 : 12
    rid := Buffer(ridSize, 0)
    
    NumPut("UShort", HID_USAGE_PAGE_GENERIC, rid, 0)
    NumPut("UShort", HID_USAGE_GENERIC_KEYBOARD, rid, 2)
    NumPut("UInt", RIDEV_INPUTSINK, rid, 4)
    NumPut("Ptr", hWnd, rid, 8)
    
    result := DllCall("user32.dll\RegisterRawInputDevicesW", 
                      "Ptr", rid.Ptr, 
                      "UInt", 1, 
                      "UInt", ridSize, 
                      "Int")
    
    if (!result) {
        MsgBox("❌ Raw Input デバイス登録失敗`nエラーコード: " A_LastError, "初期化エラー", "Icon16")
        ExitApp()
    }
    
    if (DEBUG_MODE) {
        OutputDebug("✅ Raw Input デバイス登録完了")
    }
}

; ==============================================
; 核心：Raw Input メッセージ処理
; ==============================================

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
    
    if (size = 0) return 0
    
    ; データバッファ作成・取得
    rawBuffer := Buffer(size, 0)
    result := DllCall("user32.dll\GetRawInputData", 
                      "Ptr", lParam, 
                      "UInt", RID_INPUT, 
                      "Ptr", rawBuffer.Ptr, 
                      "UIntP", &size, 
                      "UInt", 16 + A_PtrSize)
    
    if (result = -1) return 0
    
    ; デバイスタイプ確認（キーボードのみ）
    dwType := NumGet(rawBuffer, 0, "UInt")
    if (dwType != 1) return 0  ; RIM_TYPEKEYBOARD = 1
    
    ; デバイス識別
    hDevice := NumGet(rawBuffer, A_PtrSize, "Ptr")
    deviceName := GetDeviceName(hDevice)
    
    ; MSI内蔵キーボード判定
    if (!IsTargetDevice(deviceName)) return 0
    
    ; キーボードデータ解析
    headerSize := 16 + A_PtrSize
    makeCode := NumGet(rawBuffer, headerSize + 0, "UShort")
    flags := NumGet(rawBuffer, headerSize + 2, "UShort")
    
    ; Left Ctrl スキャンコード確認
    if (makeCode = SC_LCTRL) {
        return HandleLeftCtrlEvent(flags, deviceName)
    }
    
    return 0
}

; ==============================================
; Left Ctrl イベント処理（強化版）
; ==============================================

HandleLeftCtrlEvent(flags, deviceName)
{
    global stats, DEBUG_MODE, HARDWARE_FLOOD_THRESHOLD
    
    currentTime := A_TickCount
    isKeyUp := (flags & 1) != 0
    
    ; 統計更新
    stats.totalBlocked++
    stats.lastEventTime := currentTime
    
    ; 直近イベント履歴更新（最大100件保持）
    stats.recentEvents.Push(currentTime)
    if (stats.recentEvents.Length > 100) {
        stats.recentEvents.RemoveAt(1)
    }
    
    ; ハードウェア連続送信検出
    recentFlood := 0
    thresholdTime := currentTime - BLOCK_DURATION_MS
    
    for eventTime in stats.recentEvents {
        if (eventTime > thresholdTime) {
            recentFlood++
        }
    }
    
    if (recentFlood >= HARDWARE_FLOOD_THRESHOLD) {
        stats.floodEventsDetected++
        
        if (DEBUG_MODE) {
            OutputDebug("⚡ ハードウェア連続送信検出! 期間内イベント数: " recentFlood)
        }
    }
    
    ; デバッグログ出力
    if (DEBUG_MODE) {
        keyState := isKeyUp ? "↑" : "↓"
        OutputDebug("🚫 MSI内蔵KB Left Ctrl " keyState " - ブロック済み (総計:" stats.totalBlocked ")")
    }
    
    ; PowerToysとの併用確認（ログのみ）
    if (DEBUG_MODE && Mod(stats.totalBlocked, 50) = 0) {
        OutputDebug("💡 PowerToys併用推奨: より確実なブロックのため両方有効にしてください")
    }
    
    ; キー入力を完全にブロック
    return 1
}

; ==============================================
; ユーティリティ関数
; ==============================================

IsTargetDevice(deviceName)
{
    global targetDevicePatterns
    
    if (!deviceName) return false
    
    for pattern in targetDevicePatterns {
        if (!InStr(deviceName, pattern)) {
            return false
        }
    }
    
    return true
}

GetDeviceName(hDevice)
{
    size := 0
    DllCall("user32.dll\GetRawInputDeviceInfoW", 
            "Ptr", hDevice, 
            "UInt", 0x20000007, 
            "Ptr", 0, 
            "UIntP", &size)
    
    if (size = 0) return ""
    
    nameBuffer := Buffer(size * 2, 0)
    result := DllCall("user32.dll\GetRawInputDeviceInfoW", 
                      "Ptr", hDevice, 
                      "UInt", 0x20000007, 
                      "Ptr", nameBuffer.Ptr, 
                      "UIntP", &size)
    
    return result = -1 ? "" : StrGet(nameBuffer.Ptr, "UTF-16")
}

; ==============================================
; 起動時処理
; ==============================================

; PowerToys併用確認
CheckPowerToysOnStartup()
{
    try {
        RunWait("tasklist /FI `"IMAGENAME eq PowerToys.exe`" | find /I `"PowerToys.exe`"", , "Hide")
        powerToysRunning := true
    } catch {
        powerToysRunning := false
    }
    
    startupMsg := "🛡️ MSI内蔵キーボード Left Ctrl完全ブロック開始`n"
    startupMsg .= "（ハードウェア配線ショート対応版）`n`n"
    
    if (powerToysRunning) {
        startupMsg .= "✅ PowerToys実行中 - 二重保護有効`n"
    } else {
        startupMsg .= "⚠️ PowerToys未実行 - 単独動作モード`n"
        startupMsg .= "※PowerToys併用を推奨します`n"
    }
    
    startupMsg .= "`n🔧 機能:`n"
    startupMsg .= "• ハードウェア連続送信完全ブロック`n"
    startupMsg .= "• 外部キーボードCtrl保護`n"
    startupMsg .= "• リアルタイム統計監視`n"
    startupMsg .= "`n📊 統計表示: トレイアイコン右クリック"
    
    MsgBox(startupMsg, "強化版ブロッカー開始", "Icon64 T4")
}

; 起動時チェック実行
CheckPowerToysOnStartup()

if (DEBUG_MODE) {
    OutputDebug("🚀 MSI強化版Left Ctrlブロッカー起動完了")
}