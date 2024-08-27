rem HB_COMPILER=mingw
SET HB_INSTALL_PREFIX=d:\harbour\
SET HB_WITH_ADS=d:\harbour\hb3rd\acesdk\
SET HB_WITH_CURL=d:\harbour\hb3rd\curl\include\
SET HB_WITH_FREEIMAGE=d:\harbour\hb3rd\FreeImage\
set HB_WITH_OPENSSL=d:\harbour\hb3rd\openssl\
set HB_WITH_FIREBIRD=d:\harbour\hb3rd\firebird\
set HB_WITH_MYSQL=d:\harbour\hb3rd\mysql\
set HB_WITH_OCI=d:\harbour\hb3rd\oci\
set HB_WITH_PGSQL=d:\harbour\hb3rd\pgsql\
set HB_WITH_GS_BIN=d:\harbour\hb3rd\gscript\
SET HB_STATIC_CURL=yes
SET HB_STATIC_OPENSSL=yes
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


