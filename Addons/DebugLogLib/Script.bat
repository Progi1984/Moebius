set pathlib=C:\ZPersoSpace\moebius-pb\trunk\Addons\DebugLogLib\
set pbpath=C:\ZPersoSpace\PureBasic\
"%pbpath%compilers\fasm.exe" "%pathlib%Windows\DebugLogLib.asm" "%pathlib%Windows\DebugLogLib.obj"
"%pbpath%compilers\fasm.exe" "%pathlib%Windows\DebugLogLib_DEBUG.asm" "%pathlib%Windows\DebugLogLib_DEBUG.obj"
"%pbpath%compilers\polib.exe" /out:"%pathlib%Windows\DebugLogLib.lib" @"%pathlib%Windows\ObjList.txt"
"%pbpath%SDK\LibraryMaker.exe" "%pathlib%DebugLogLib.Desc" /To "%pbpath%purelibraries\userlibraries\" /NOUNICODEWARNING
pause