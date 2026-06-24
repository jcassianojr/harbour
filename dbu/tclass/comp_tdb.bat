SET HB_ARCHITECTURE=win
set HB_COMPILER=mingw
set HB_PATH=c:\devprg\hb\
SET HB_MINGW=c:\msys64\mingw32\
SET INCLUDE_DIR=%HB_PATH%\include;%HB_MINGW%\include\;c:\harbour\hb3rd\mysql\include;c:\harbour\hb3rd\pgsql\include
SET LIB_DIR=%HB_PATH%\lib\win\mingw\;%HB_MINGW%\lib\;c:\harbour\hb3rd\mysql\lib;c:\harbour\hb3rd\pgsql\lib
set PATH=%HB_PATH%bin\mingw\;%HB_MINGW%bin\
set C_INCLUDE_PATH=c:\harbour\hb3rd\mysql\include;c:\harbour\hb3rd\pgsql\include
set LIBRARY_PATH=c:\harbour\hb3rd\mysql\lib;c:\harbour\hb3rd\pgsql\lib
hbmk2.exe Tdbclass.hbp
rem hbmk2.exe Tdbclass32.hbp
