#Requires AutoHotkey v2.0
Persistent ; スクリプトを常駐させます

; ライブラリを読み込みます
#include Lib\AutoHotInterception.ahk

; AutoHotInterceptionを初期化します
global AHI := AutoHotInterception()

; --------------------------------------------------
; VID/PIDの代わりに、Monitorに表示されていた「Handle」を使います
; こちらの方が、ノートPCのキーボードをより確実に特定できます
handle := "ACPI\VEN_MSI&DEV_1001"
targetKeyboardId := AHI.GetKeyboardIdFromHandle(handle)
; --------------------------------------------------

; デバイスが見つかった場合のみ、以下の処理を実行します
if (targetKeyboardId)
{
; 特定したキーボードの「左Ctrlキー」の入力を監視し、ブロックします
AHI.SubscribeKey(targetKeyboardId, GetKeySC("LControl"), true, Func("BlockKey"))
}

; キー入力を握りつぶすための空の関数
BlockKey(state)
{
; 何もしない
}