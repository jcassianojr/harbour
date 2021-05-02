@echo off
SET HB_ARCHITECTURE=win
set HB_COMPILER=mingw64
set HB_PATH=c:\devprg\hb64mgw11
SET HB_MINGW=c:\devprg\hb64mgw11\comp\mingw64
SET HB_WITH_ADS=c:\devprg\hb3rd\acesdk-x64\
SET INCLUDE_DIR=%HB_PATH%\include;%HB_MINGW%\include\
SET LIB_DIR=%HB_PATH%\lib\win\mingw\;%HB_MINGW%\lib\
set PATH=%HB_PATH%\bin\;%HB_MINGW%\bin\

