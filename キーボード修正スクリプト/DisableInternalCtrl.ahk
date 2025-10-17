#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

#include Lib\AutoHotInterception.ahk

global AHI := AutoHotInterception()

; ノートPCのキーボードID「1」を直接指定
targetKeyboardId := 1

if (targetKeyboardId)
{
    ; キーボード「1」からの【すべての】キー入力を監視する
    AHI.SubscribeKeyboard(targetKeyboardId, true, Func("KeyProcessor"))
}
else
{
    MsgBox("指定されたIDのキーボードが見つかりませんでした。")
}

return

; すべてのキー入力が、一度この関数を通る
KeyProcessor(scanCode, state) {
    ; もし、押されたキーのスキャンコードが左Ctrl（0x1D）だったら…
    if (scanCode = 0x1D) {
        ; このキー入力だけをブロックする（信号をここで止める）
        return true
    }

    ; それ以外のキーは、ブロックせずに通常通り通す
    return false
}