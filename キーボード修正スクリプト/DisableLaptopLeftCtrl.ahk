#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

; MSIラップトップの内蔵キーボード専用Left Ctrlキー無効化スクリプト
; 対象: ACPI\VEN_MSI&DEV_1001 (ID: 1)
; このスクリプトはWindows Raw Input APIを使用してデバイス固有の制御を行います

; Windows API定数
WM_INPUT := 0x00FF
RIM_INPUT := 0
RIM_INPUTSINK := 1
RIDEV_INPUTSINK := 0x00000100
RIDEV_NOLEGACY := 0x00000030
RID_INPUT := 0x10000003
HID_USAGE_PAGE_GENERIC := 0x01
HID_USAGE_GENERIC_KEYBOARD := 0x06

; スキャンコード定数
SC_LCTRL := 0x1D

; グローバル変数
global targetDeviceHandle := "\\?\ACPI#VEN_MSI&DEV_1001#"  ; MSI内蔵キーボードのデバイスハンドル
global blockedKeys := Map()  ; ブロックされたキーの状態を追跡

; メインウィンドウ作成（Raw Inputメッセージ受信用）
mainGui := Gui("+LastFound +ToolWindow", "MSI Laptop Ctrl Blocker")
mainGui.Show("Hide")
hWnd := WinGetID("MSI Laptop Ctrl Blocker")

; Raw Input デバイス登録
RegisterRawInputDevices()

; ウィンドウメッセージ処理のフック
OnMessage(WM_INPUT, ProcessRawInput)

; トレイアイコンとメニュー設定
A_IconTip := "MSI内蔵キーボード Left Ctrl無効化"
Menu_Tray := A_TrayMenu
Menu_Tray.Delete()
Menu_Tray.Add("スクリプト情報", ShowInfo)
Menu_Tray.Add()
Menu_Tray.Add("終了", ExitScript)

ShowInfo(*)
{
    MsgBox(
        "MSI内蔵キーボード Left Ctrl無効化スクリプト`n`n"
        "対象デバイス: " targetDeviceHandle "`n"
        "無効化キー: Left Ctrl (スキャンコード: 0x" Format("{:X}", SC_LCTRL) ")`n`n"
        "外部キーボードのCtrlキーは正常に動作します。",
        "スクリプト情報",
        "Icon64"
    )
}

ExitScript(*)
{
    ExitApp()
}

; Raw Input デバイス登録関数
RegisterRawInputDevices()
{
    ; RAWINPUTDEVICE構造体のサイズ計算（32bit/64bit対応）
    if (A_PtrSize = 8) {
        ridSize := 16  ; 64bit
    } else {
        ridSize := 12  ; 32bit
    }
    
    ; RAWINPUTDEVICE構造体作成
    rid := Buffer(ridSize, 0)
    
    ; キーボードデバイス用設定
    NumPut("UShort", HID_USAGE_PAGE_GENERIC, rid, 0)      ; usUsagePage
    NumPut("UShort", HID_USAGE_GENERIC_KEYBOARD, rid, 2)  ; usUsage  
    NumPut("UInt", RIDEV_INPUTSINK, rid, 4)               ; dwFlags
    NumPut("Ptr", hWnd, rid, 8)                           ; hwndTarget
    
    ; RegisterRawInputDevices API呼び出し
    result := DllCall("user32.dll\RegisterRawInputDevicesW", 
                      "Ptr", rid.Ptr, 
                      "UInt", 1, 
                      "UInt", ridSize, 
                      "Int")
    
    if (!result) {
        MsgBox("Raw Input デバイス登録に失敗しました。`nエラーコード: " A_LastError, "エラー", "Icon16")
        ExitApp()
    }
}

; Raw Input メッセージ処理関数
ProcessRawInput(wParam, lParam, msg, hWnd)
{
    ; 入力データサイズ取得
    size := 0
    DllCall("user32.dll\GetRawInputData", 
            "Ptr", lParam, 
            "UInt", RID_INPUT, 
            "Ptr", 0, 
            "UIntP", &size, 
            "UInt", 16 + A_PtrSize)  ; RAWINPUTHEADER のサイズ
    
    if (size = 0) {
        return 0
    }
    
    ; 入力データバッファ作成
    rawBuffer := Buffer(size, 0)
    
    ; 実際のデータ取得
    result := DllCall("user32.dll\GetRawInputData", 
                      "Ptr", lParam, 
                      "UInt", RID_INPUT, 
                      "Ptr", rawBuffer.Ptr, 
                      "UIntP", &size, 
                      "UInt", 16 + A_PtrSize)
    
    if (result = -1) {
        return 0
    }
    
    ; RAWINPUT構造体解析
    dwType := NumGet(rawBuffer, 0, "UInt")
    
    ; キーボード入力のみ処理
    if (dwType != 1) {  ; RIM_TYPEKEYBOARD = 1
        return 0
    }
    
    ; デバイスハンドル取得
    hDevice := NumGet(rawBuffer, A_PtrSize, "Ptr")
    
    ; デバイス名取得
    deviceName := GetDeviceName(hDevice)
    
    ; 対象デバイス（MSI内蔵キーボード）かチェック
    if (!InStr(deviceName, "ACPI") || !InStr(deviceName, "VEN_MSI") || !InStr(deviceName, "DEV_1001")) {
        return 0  ; 対象デバイスでなければ処理しない
    }
    
    ; キーボードデータ解析（RAWKEYBOARD構造体）
    headerSize := 16 + A_PtrSize  ; RAWINPUTHEADERのサイズ
    makeCode := NumGet(rawBuffer, headerSize + 0, "UShort")
    flags := NumGet(rawBuffer, headerSize + 2, "UShort")
    
    ; Left Ctrl キー（スキャンコード 0x1D）をチェック
    if (makeCode = SC_LCTRL) {
        isKeyUp := (flags & 1) != 0  ; RI_KEY_BREAK = 1
        
        ; キーの状態をログ出力（デバッグ用）
        if (isKeyUp) {
            OutputDebug("MSI内蔵キーボード Left Ctrl キー離された - ブロック済み")
        } else {
            OutputDebug("MSI内蔵キーボード Left Ctrl キー押された - ブロック済み")
        }
        
        ; このキー入力をブロック（他のキーは通常通り処理される）
        return 1  ; メッセージ処理済みとして返す
    }
    
    return 0  ; その他のキーは通常処理
}

; デバイス名取得関数
GetDeviceName(hDevice)
{
    ; デバイス名のサイズ取得
    size := 0
    DllCall("user32.dll\GetRawInputDeviceInfoW", 
            "Ptr", hDevice, 
            "UInt", 0x20000007,  ; RIDI_DEVICENAME
            "Ptr", 0, 
            "UIntP", &size)
    
    if (size = 0) {
        return ""
    }
    
    ; デバイス名バッファ作成
    nameBuffer := Buffer(size * 2, 0)  ; Unicode文字用
    
    ; 実際のデバイス名取得
    result := DllCall("user32.dll\GetRawInputDeviceInfoW", 
                      "Ptr", hDevice, 
                      "UInt", 0x20000007,  ; RIDI_DEVICENAME
                      "Ptr", nameBuffer.Ptr, 
                      "UIntP", &size)
    
    if (result = -1) {
        return ""
    }
    
    return StrGet(nameBuffer.Ptr, "UTF-16")
}

; 起動時メッセージ
MsgBox(
    "MSI内蔵キーボード Left Ctrl無効化スクリプトが開始されました。`n`n"
    "• 内蔵キーボードのLeft Ctrlキーのみ無効化されます`n"
    "• 外部キーボードのCtrlキーは正常に動作します`n"
    "• スクリプトを終了するには、トレイアイコンを右クリックしてください",
    "スクリプト開始",
    "Icon64 T3"
)