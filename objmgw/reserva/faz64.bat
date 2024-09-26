SET HB_INSTALL_PREFIX=d:\harbour\
SET HB_WITH_ADS=d:\harbour\hb3rd\acesdk-x64\
SET HB_WITH_CURL=d:\harbour\hb3rd\curl-x64\include\
SET HB_WITH_FREEIMAGE=d:\harbour\hb3rd\FreeImage-x64\include\
SET HB_WITH_SSH2=d:\harbour\hb3rd\ssh2-x64\include\
set HB_WITH_GS=d:\harbour\hb3rd\gscript-x64\include\ghostscript\
set HB_WITH_GS_BIN=d:\harbour\hb3rd\gscript-x64\bin\
SET HB_WITH_RABBITMQ=d:\harbour\hb3rd\RABBITMQ\include\
set HB_WITH_OPENSSL=d:\harbour\hb3rd\openssl-x64\include\
set HB_WITH_CAIRO=d:\harbour\hb3rd\cairo-x64\include\cairo\
set HB_WITH_LIBMAGIC=d:\harbour\hb3rd\magic-x64\include\
set HB_WITH_FIREBIRD=d:\harbour\hb3rd\firebird-x64\include\
set HB_WITH_PGSQL=d:\harbour\hb3rd\pgsql-x64\include\
SET HB_WITH_LIBHARU=d:\harbour\hb3rd\libharu-x64\include\
SET HB_STATIC_CURL=yes
SET HB_STATIC_OPENSSL=yes

rem set PATH=d:\harbour\comp\mingw64\bin\;d:\harbour\BIN\;%PATH% abaixo com o call
call hb64mgw12.bat
win-make install

REM deixando aqui como referencia win-make install e migw32-make sao equivalentes 
rem mingw32-make install

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


