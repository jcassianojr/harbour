@echo off
SET HB_ARCHITECTURE=win
set HB_COMPILER=mingw
set HB_PATH=c:\devprg\hb\
SET HB_MINGW=c:\msys64\mingw32\
SET INCLUDE_DIR=%HB_PATH%\include;%HB_MINGW%\include\
SET LIB_DIR=%HB_PATH%\lib\win\mingw\;%HB_MINGW%\lib\
set PATH=%HB_PATH%\bin\mingw\;%HB_MINGW%\bin\
