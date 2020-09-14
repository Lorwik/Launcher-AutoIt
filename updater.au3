#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=AODrag.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#RequireAdmin
ProcessClose(@ScriptDir & "\WinterLauncher.exe")
FileDelete(@ScriptDir & "\WinterLauncher.exe")
InetGet("https://winterao.com.ar/update/launcher/WinterLauncher.exe", @ScriptDir & "\WinterLauncher.exe", 0)
Run(@ScriptDir & "\WinterLauncher.exe")