@echo off
SET HB_ARCHITECTURE=win
set HB_COMPILER=mingw64
set HB_PATH=d:\devprg\hb64mgw12
SET HB_MINGW=c:\devprg\msys64\mingw64\
rem SET HB_WITH_ADS=d:\hb64\hb3rd\acesdk-x64\
SET INCLUDE_DIR=%HB_PATH%\include;%HB_MINGW%\include\
SET LIB_DIR=%HB_PATH%\lib\win\mingw64\;%HB_MINGW%\lib\
set PATH=%HB_PATH%\bin\;%HB_MINGW%\bin\

