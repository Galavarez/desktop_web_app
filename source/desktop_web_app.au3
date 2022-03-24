; MODE
;mode_app_off
;mode_kiosk_printing_on
;mode_debug_on
;mode_global_on

; Закрываем PHP если был раньше запущен
ProcessClose("php.exe")

; Global PARAMS
Global $SETTING_MODE_APP = 1
Global $SETTING_MODE_DEBUG = 0
Global $SETTING_MODE_GLOBAL = 0
Global $SETTING_MODE_KIOSK_PRINTING = 0
Global $PHP_PATH = ".\..\_php\php.exe"
Global $BROWSER_PATH = ".\..\_chromium\chrome.exe"
Global $IP_AND_PORT_PHP
Global $IP_AND_PORT_BROWSER
Global $BROWSER_SETTING

; Получаем парамметры из ярлыка
For $PARAMS In $CmdLine

	; mode_app_off выключает app режим, по умолчанию включен
	If $PARAMS == "mode_app_off" Then
		$SETTING_MODE_APP = 0
	EndIf

	; mode_kiosk_printing_on включает kiosk_printin режим, по умолчанию выключен
	If $PARAMS == "mode_kiosk_printing_on" Then
		$SETTING_MODE_KIOSK_PRINTING = 1
	EndIf

	; mode_debug_on включает debug режим, по умолчанию выключен
	if $PARAMS == "mode_debug_on" Then
		$SETTING_MODE_DEBUG = 1
	EndIf

	; mode_global_on включает global режим, по умолчанию выключен
	if $PARAMS == "mode_global_on" Then
		$SETTING_MODE_GLOBAL = 1
	EndIf

	; php.exe не найден
	If FileExists($PHP_PATH) == 0 Then
		MsgBox(16, "", "php.exe не найден!")
		Exit
	EndIf

	; chrome.exe не найден
	If FileExists($BROWSER_PATH) == 0 Then
		MsgBox(16, "", "chrome.exe не найден!")
		Exit
	EndIf

NEXT

; Директория
$DIR_PATH = StringSplit(@ScriptDir,"\",0)	; путь к текущей папке
$DIR_NAME = $DIR_PATH[$DIR_PATH[0]]			; имя папки без слешев
$DIR_NAME_SLASH = "/" & $DIR_NAME &	"/"		; имя папки cо слешем

; PHP
If $SETTING_MODE_GLOBAL == 1 Then
	$IP_AND_PORT_PHP = "0.0.0.0:80"
	$IP_AND_PORT_BROWSER = @IPAddress1 & ":80"
Else
	$IP_AND_PORT_PHP = "127.0.0.1:80"
	$IP_AND_PORT_BROWSER = "127.0.0.1:80"
EndIf

; PHP
$PHP_SETTING = $PHP_PATH & " -S " & $IP_AND_PORT_PHP & " -t ./../"

; PHP START ON/OFF DEBUG
If $SETTING_MODE_DEBUG == 1 Then
	Run($PHP_SETTING, "", @SW_SHOW)
Else
	Run($PHP_SETTING, "", @SW_HIDE)
EndIf

; BROWSER

; ON/OFF KIOSK_PRINTING
If $SETTING_MODE_KIOSK_PRINTING == 1 Then
	$BROWSER_SETTING &= " --kiosk-printing"
EndIf

; ON/OFF APP
If $SETTING_MODE_APP == 1 Then
	$BROWSER_SETTING &= " --app=http://" & $IP_AND_PORT_BROWSER & $DIR_NAME_SLASH
Else
	$BROWSER_SETTING &= " http://" & $IP_AND_PORT_BROWSER & $DIR_NAME_SLASH
EndIf

; BROWSER START
Run($BROWSER_PATH & $BROWSER_SETTING)

; Создает файл с ссылкой на папки
#include <Array.au3>
#include <File.au3>
;#include <MsgBoxConstants.au3>
_FileCreate(".\..\index.html")
$FO = FileOpen(".\..\index.html", 1)

$scan = _FileListToArray(".\..\", "*", 2)
For $i = 1 To $scan[0]
	FileWrite($FO, "<h3><a href='/" & $scan[$i] & "/'>" & $scan[$i] & "</a></h3>")
Next
;_ArrayDisplay($scan, "asd")

