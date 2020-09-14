#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Winter.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Fileversion=1.2
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#RequireAdmin
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <Misc.au3>
#include <IE.au3>
#include <File.au3>
#include <Process.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>


#include "timestamp.au3"

$launcherversion = "1"

Local $descarga[500000]
Local $size
Local $downloaded

$Form1 = GUICreate("WinterAO Resurrection Launcher (v"& $launcherversion & ")", 833, 572, 563, 277)
$Button1 = GUICtrlCreateButton("Jugar", 672, 456, 147, 105)
GUICtrlSetFont(-1, 25, 400, 0, "MS Sans Serif")
$Label1 = GUICtrlCreateLabel("", 16, 530, 648, 57)
GUISetState(@SW_SHOW)
GUICtrlSetState ($Button1, $GUI_DISABLE)



Local $oIE = _IECreateEmbedded()
GUICtrlCreateObj($oIE, 16, 16, 796, 436)
_IENavigate($oIE, "https://winterao.com.ar/update/index.html")


Switch IsAdmin()
;~     No es admin
	Case 0
		MsgBox(0, "", "Necesitas ejecutar el Launcher con privilegios de administrador para poder actualizar los archivos.");
		Exit

	Case Else

		$hora = ""&@YEAR&"."&@MON&"."&@MDAY&" "&@HOUR&"."&@MIN&"."&@SEC&""

;~ 		Comprobar carpeta logs
		$logsFolder = DirCreate(@ScriptDir & "\logs")
		If $logsFolder == 0 Then
			MsgBox(16, "", "Error creando carpeta logs")
			Exit
		EndIf

;~ 		Comprobar carpeta tmp
		Local $tmpFolder = DirCreate("tmp")
		If $tmpFolder == 0 Then
			MsgBox(16, "", "Error creando carpeta tmp")
			Exit
		EndIf

;~ 		Comprobar archivo de configuracion
		If FileExists(@ScriptDir & "\config.ini") Then
			$versioninstalada = IniRead(@ScriptDir & "\config.ini", "general", "version", "0")
		Else
			IniWrite(@ScriptDir & "\config.ini", "general", "version", "0")
			$versioninstalada = 0
		EndIf


		FileWrite("logs/"& $hora &".txt", "==============================================="&@CRLF)
		FileWrite("logs/"& $hora &".txt", "==========  COMENZANDO ACTUALIZACION =========="&@CRLF)
		FileWrite("logs/"& $hora &".txt", "============= "& $hora &" ============="&@CRLF)
		FileWrite("logs/"& $hora &".txt", "==============================================="&@CRLF)

		FileWrite("logs/"& $hora &".txt", "Sistema operativo: "& @OSVersion &" "& @OSType &" "& @OSArch &" "& @OSBuild&@CRLF)
		FileWrite("logs/"& $hora &".txt", "Versión instalada del juego: "& $versioninstalada &@CRLF)

;~ 		Descargar versiones desde el servidor
		FileDelete(@ScriptDir & "\tmp\version.dat")
		FileWrite("logs/"&$hora&".txt", "Descargando información de versiones desde el servidor..."&@CRLF)
		$tmp = InetGet("https://winterao.com.ar/update/version.dat", @ScriptDir &"\tmp\version.dat", 1)

		If ($tmp > 0) Then
			$versionactual = FileReadLine(@ScriptDir &"\tmp\version.dat", 1)
			$launcheractual = FileReadLine(@ScriptDir &"\tmp\version.dat", 2)
			FileWrite("logs/"&$hora&".txt", "     Última versión del cliente: "&$versionactual&@CRLF)
			FileWrite("logs/"&$hora&".txt", "     Última versión del launcher: "&$launcheractual&@CRLF)
			FileWrite("logs/"&$hora&".txt",@CRLF)
		Else
			FileWrite("logs/"&$hora&".txt", "Error al descargar el archivo de versiones."&@CRLF)
			MsgBox(16, "", "Error al descargar el archivo de versiones.")
			DirRemove(@ScriptDir & "/tmp", 1)
			Exit
		EndIf
		IniWrite(@ScriptDir & "\config.ini", "general", "version", $versionactual)

;~ 		Comprobar version del Launcher
		If ($launcheractual <> $launcherversion) Then
			DirRemove(@ScriptDir & "/tmp", 1)
			Run(@ScriptDir & "\updater.exe")
			FileWrite("logs/"& $hora &".txt", "Actualizando el Launcher a la versión"& $launcheractual &@CRLF)
			Exit
		EndIf

;~ 		Descargar updater.exe si no existe
		If Not FileExists(@ScriptDir & "\tmp\carpetas.dat") Then
			InetGet("https://winterao.com.ar/update/updater.exe", @ScriptDir &"\updater.exe", 1)
		EndIf

;~ 		Descargar lista de archivos y carpetas
		FileWrite("logs/"&$hora&".txt", "Descargando lista de archivos y carpetas desde el servidor..."&@CRLF)
		FileDelete(@ScriptDir & "\tmp\archivos.dat")
		InetGet("https://winterao.com.ar/update/launcher/"&$versionactual&"/archivos.dat", @ScriptDir &"\tmp\archivos.dat", 1)
		If ($tmp > 0) Then
			FileWrite("logs/"&$hora&".txt", "     Lista de archivos descargada."&@CRLF)
		Else
			FileWrite("logs/"&$hora&".txt", "     Error al descargar la lista de archivos."&@CRLF)
			MsgBox(0, "", "Error al descargar la lista de archivos.")
			DirRemove(@ScriptDir & "/tmp", 1)
			Exit
		EndIf

		FileDelete(@ScriptDir & "\tmp\carpetas.dat")
		$tmp = InetGet("https://winterao.com.ar/update/launcher/"&$versionactual&"/carpetas.dat", @ScriptDir &"\tmp\carpetas.dat", 1)
		If ($tmp > 0) Then
			FileWrite("logs/"&$hora&".txt", "     Lista de carpetas descargada."&@CRLF)
		Else
			FileWrite("logs/"&$hora&".txt", "     Error al descargar la lista de carpetas."&@CRLF)
			MsgBox(0, "", "Error al descargar la lista de carpetas")
			DirRemove(@ScriptDir & "/tmp", 1)
			Exit
		EndIf
		FileWrite("logs/"&$hora&".txt", @CRLF)



;~ 		Comprobar carpetas
		FileWrite("logs/"&$hora&".txt", "Comprobando carpetas..."&@CRLF)
		GUICtrlSetData ($Label1, "Comprobando carpetas.")
		If FileExists(@ScriptDir & "\tmp\carpetas.dat") Then
			$lineas = _FileCountLines(@ScriptDir & "\tmp\carpetas.dat")
			For $i = 1 To $lineas Step 1
				$ruta = @ScriptDir & FileReadLine(@ScriptDir & "\tmp\carpetas.dat", $i)
				If Not FileExists($ruta) Then
					$success = DirCreate($ruta)
					If $success == 1 Then
						FileWrite("logs/"&$hora&".txt", "     Carpeta '"&$ruta&"' creada."&@CRLF)
					Else
						FileWrite("logs/"&$hora&".txt", "     Error al crear la carpeta: "&$ruta&@CRLF)
					EndIf
				Else
					FileWrite("logs/"&$hora&".txt", "     Carpeta '"&$ruta&"' ya existe."&@CRLF)
				EndIf
			Next
		EndIf
		FileWrite("logs/"&$hora&".txt",@CRLF)


;~ 		Comprobar archivos
		FileWrite("logs/"&$hora&".txt", "Comprobando archivos..."&@CRLF)
		GUICtrlSetData ($Label1, "Comprobando archivos")
		If FileExists(@ScriptDir & "\tmp\archivos.dat") Then
			$lineas = _FileCountLines(@ScriptDir & "\tmp\archivos.dat")
			For $i = 1 To $lineas Step 1
				$archivo = _GetTok(FileReadLine(@ScriptDir & "\tmp\archivos.dat", $i), 1, 61)
				$time = _GetTok(FileReadLine(@ScriptDir & "\tmp\archivos.dat", $i), 2, 61)
				If FileExists($archivo) Then
 				  $tmptime = FileGetTime($archivo)
				  If $tmptime[0]&$tmptime[1]&$tmptime[2]&$tmptime[3]&$tmptime[4]&$tmptime[5] < $time Then
					 FileDelete($archivo)
					 $descarga[$i] = InetGet("https://winterao.com.ar/update/launcher/"&$versionactual&"/"&$archivo, @ScriptDir &"/"&$archivo, 1, 1)
					 FileWrite("logs/"&$hora&".txt", "     Archivo '"&@ScriptDir&"\"&$archivo&"' desactualizado, añadido a la descarga."&@CRLF)
				  Else
					 FileWrite("logs/"&$hora&".txt", "     Archivo '"&@ScriptDir&"\"&$archivo&"' ya está actualizado."&@CRLF)
				  EndIf
			Else
				FileWrite("logs/"&$hora&".txt", "     Archivo '"&$archivo&"' no existe, añadido a la descarga."&@CRLF)
				$descarga[$i] = InetGet("https://winterao.com.ar/update/launcher/"&$versionactual&"/"&$archivo, @ScriptDir &"/"&$archivo, 1, 1)
			EndIf
		 Next
		EndIf


;~ 		Descargar archivos
		If InetGetInfo() <> 0 Then GUICtrlSetData ($Label1, "Preparando descarga")
		While InetGetInfo() <> 0
			Sleep(10)
			$size = 0
			$downloaded = 0;
			$descargas = InetGetInfo()
			For $i = 1 To 10000 Step 1
				$size = round($size + InetGetInfo($descarga[$i], 1) / 1000000)
				$downloaded = round($downloaded + InetGetInfo($descarga[$i], 0) / 1000000)
			Next
			$porciento = round(($downloaded/$size)*100)
			$restante = $size-$downloaded
			If $restante > 0 Then
				GUICtrlSetData ($Label1, "Descargando archivos "&$porciento&"%. Restante: "&$restante&" Mb")
			EndIf
		WEnd
		FileWrite("logs/"&$hora&".txt",@CRLF)


		;~ 		Registrar librerias
		FileWrite("logs/"& $hora &".txt", "Registrando librerías..."&@CRLF)
		GUICtrlSetData ($Label1, "Registrando librerias.")
		Local $hSearch = FileFindFirstFile(@ScriptDir & "\lib\*.*")
		Local $sFileName = "", $iResult = 0
		While 1
			$sFileName = FileFindNextFile($hSearch)
			If @error Then ExitLoop
			FileCopy(@ScriptDir&"\lib\"&$sFileName, "C:\Windows\System32\"&$sFileName)
			FileCopy(@ScriptDir&"\lib\"&$sFileName, "C:\Windows\SysWOW64\"&$sFileName)
			Run("regsvr32 /s "&$sFileName)
			FileWrite("logs/"& $hora &".txt", "     Registrado '"&$sFileName&"'"&@CRLF)
		WEnd
		FileClose($hSearch)
		FileWrite("logs/"&$hora&".txt", @CRLF)


;~ 		Limpiando
		FileDelete("carpetas.dat")
		FileDelete("archivos.dat")
		DirRemove(@ScriptDir & "\tmp\", 1)


		GUICtrlSetData ($Label1, "WinterAO está actualizado")
		GUICtrlSetState ($Button1, $GUI_ENABLE)
EndSwitch









While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Button1
			IniWrite(@ScriptDir & "\config.ini", "general", "launcher", "1")
			Run("WinterAO Resurrection.exe")
			Exit
	EndSwitch
WEnd


Func _GetTok($_TokList,$_TokNum,$_ChrMatch)
    Local $_ChrCheck = _Iif(IsNumber($_ChrMatch),Chr($_ChrMatch),$_ChrMatch)
    Dim $a = 0, $_List = StringSplit($_TokList,$_ChrCheck)
    Return $_List[$_TokNum]
 EndFunc

Func _Iif($fTest, $vTrueVal, $vFalseVal)
    If $fTest Then
        Return $vTrueVal
    Else
        Return $vFalseVal
    EndIf
EndFunc