rem HB_COMPILER=mingw
SET HB_INSTALL_PREFIX=d:\harbour\
SET HB_WITH_ADS=d:\harbour\hb3rd\acesdk\
SET HB_WITH_CURL=d:\harbour\hb3rd\curl\include\
SET HB_WITH_FREEIMAGE=d:\harbour\hb3rd\FreeImage\
set HB_WITH_OPENSSL=d:\harbour\hb3rd\openssl\
rem set PATH=d:\harbour\comp\mingw\bin\;d:\harbour\BIN\;%PATH%
call hb32mgw12
win-make install
mingw32-make install
