@echo off
SET HB_ARCHITECTURE=win
set HB_COMPILER=mingw
set HB_PATH=d:\devprg\hb32mgw12
SET HB_MINGW=c:\devprg\msys64\mingw32\
SET INCLUDE_DIR=%HB_PATH%\include;%HB_MINGW%\include\
SET LIB_DIR=%HB_PATH%\lib\win\mingw\;%HB_MINGW%\lib\
set PATH=%HB_PATH%\bin\;%HB_MINGW%\bin\
