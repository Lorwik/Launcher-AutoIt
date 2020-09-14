#include <File.au3>
#include <Crypt.au3>
#include <Process.au3>

Global $BufferSize = 0x20000
FileDelete("archivos.dat")


Lista("")
Lista("Fotos\")
Lista("Recursos\")
Lista("Recursos\Lenguajes\")
Lista("Recursos\MouseIcons\")
Lista("Recursos\Skins")
Lista("Init\")
Lista("Logs\")


Func Lista($dir)

   Local $search = FileFindFirstFile("C:\WinterAO\"&$dir&"*")


   While 1
	Local $file = FileFindNextFile($search)
	If @error Then ExitLoop

	Local $time = FileGetTime("C:\WinterAO\"&$dir&$file)



	If StringInStr($file, "Launcher.exe") == 0 Then
		If StringInStr($file, "lwkdef.dat") == 0 Then
			FileWrite("archivos.dat", $dir&$file&"="&$time[0]&$time[1]&$time[2]&$time[3]&$time[4]&$time[5]&@CRLF)
		EndIf
	EndIf

   WEnd


;~

   ; Close the search handle
   FileClose($search)
EndFunc

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