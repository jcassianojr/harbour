@echo off
SET HB_ARCHITECTURE=win
set HB_COMPILER=mingw
set HB_PATH=c:\devprg\hb32mgw11
SET HB_MINGW=c:\devprg\hb32mgw11\comp\mingw
SET HB_WITH_ADS=c:\devprg\hb3rd\acesdk\
SET INCLUDE_DIR=%HB_PATH%\include;%HB_MINGW%\include\
SET LIB_DIR=%HB_PATH%\lib\win\mingw\;%HB_MINGW%\lib\
set PATH=%HB_PATH%\bin\;%HB_MINGW%\bin\
rem SET HB_WITH_CAIRO=%HB_PATH%\cairo\
