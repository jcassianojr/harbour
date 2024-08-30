rem HB_COMPILER=mingw
SET HB_INSTALL_PREFIX=d:\harbour\
SET HB_WITH_ADS=d:\harbour\hb3rd\acesdk\
SET HB_WITH_CURL=d:\harbour\hb3rd\curl\include\
set HB_WITH_FIREBIRD=d:\harbour\hb3rd\firebird\include\
SET HB_WITH_FREEIMAGE=d:\harbour\hb3rd\FreeImage\
set HB_WITH_GS_BIN=d:\harbour\hb3rd\gscript\bin\
set HB_WITH_MYSQL=d:\harbour\hb3rd\mysql\include\
set HB_WITH_OCI=d:\harbour\hb3rd\oci\include\
set HB_WITH_OPENSSL=d:\harbour\hb3rd\openssl\include\
set HB_WITH_PGSQL=d:\harbour\hb3rd\pgsql\include\
SET HB_WITH_SSH2=d:\harbour\hb3rd\ssh2\include\
SET HB_STATIC_CURL=yes
SET HB_STATIC_OPENSSL=yes
rem HB_WITH_QT
rem HB_WITH_RABBITMQ
rem HB_WITH_BLAT
rem HB_WITH_BZIP2
rem HB_WITH_CAIRO
rem HB_WITH_CUPS
rem HB_WITH_EXPAT
rem HB_WITH_GD
rem HB_WITH_GS
rem HB_WITH_ZLIB
rem HB_WITH_PNG
rem HB_WITH_LIBHARU
rem HB_WITH_ICU
rem HB_WITH_LZF
rem HB_WITH_LIBMAGIC
rem HB_WITH_MINILZO
rem HB_WITH_MXML
rem HB_WITH_MINIZIP
rem HB_WITH_ODBC
rem HB_WITH_OPENSSL
rem HB_WITH_TINYMT
rem HB_WITH_XDIFF
rem HB_WITH_LIBYAML
rem set PATH=d:\harbour\comp\mingw\bin\;d:\harbour\BIN\;%PATH%
call hb32mgw12
win-make install
REM deixando aqui como referencia win-make install e migw32-make sao equivalentes 
REM mingw32-make install

rem -o${hb_lib}/${hb_plat}/${hb_comp}/${hb_name}
rem copiando ate checar os makes gravar local correto
rem nao usar move para utilizar a criacao dinamica quando necessario
rem copy d:\harbour\contrib\sqlrddpp\lib\win\mingw\libsqlrddpp.a d:\harbour\lib\win\mingw\
rem copy d:\harbour\contrib\hbsvg\lib\win\mingw\libhbsvg.a       d:\harbour\lib\win\mingw\
rem copy d:\harbour\contrib\hbxlsxml\lib\win\mingw\libhbxlsxml.a d:\harbour\lib\win\mingw\
rem copy d:\harbour\contrib\rddado\lib\win\mingw\librddado.a     d:\harbour\lib\win\mingw\
rem copy d:\harbour\contrib\hbcab\lib\win\mingw\libhbcab.a          d:\harbour\lib\win\mingw\
rem copy d:\harbour\contrib\hbcrypto\lib\win\mingw\libhbcrypto.a     d:\harbour\lib\win\mingw\
rem copy d:\harbour\contrib\hbyaml\lib\win\mingw\libhbyaml.a     d:\harbour\lib\win\mingw\
rem copy d:\harbour\contrib\sevenzip\lib\win\mingw\libsevenzip.a     d:\harbour\lib\win\mingw\


