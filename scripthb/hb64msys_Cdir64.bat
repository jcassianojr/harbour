@echo off
SET HB_ARCHITECTURE=win
set HB_COMPILER=mingw64
set HB_PATH=c:\devprg\hb64\
SET HB_MINGW=c:\msys64\mingw64\
SET INCLUDE_DIR=%HB_PATH%\include;%HB_MINGW%\include\
SET LIB_DIR=%HB_PATH%\lib\win\mingw64\;%HB_MINGW%\lib\
set PATH=%HB_PATH%\bin\mingw64\;%HB_MINGW%\bin\

