SET HB_INSTALL_PREFIX=d:\hbcomp\hb64\
SET HB_WITH_ADS=d:\harbour\hb3rd\acesdk-x64\
rem mingw-w64-x86_64-allegro
rem mingw-w64-x86_64-icu
rem mingw-w64-x86_64-libgd 
rem mingw-w64-x86_64-libmariadbclient
rem mingw-w64-x86_64-libxlsxwriter
rem pack mysys mingw-w64-x86_64-curl
rem SET HB_WITH_CURL=d:\harbour\hb3rd\curl-x64\include\
rem pack mysys mingw-w64-x86_64-freeimage
rem SET HB_WITH_FREEIMAGE=d:\harbour\hb3rd\FreeImage-x64\include\
rem pack mysys mingw-w64-x86_64-libssh2
rem SET HB_WITH_SSH2=d:\harbour\hb3rd\ssh2-x64\include\
rem pack msys mingw-w64-x86_64-ghostscript
rem set HB_WITH_GS=d:\harbour\hb3rd\gscript-x64\include\ghostscript\
rem pack mysys mingw-w64-x86_64-rabbitmq-c
rem SET HB_WITH_RABBITMQ=d:\harbour\hb3rd\RABBITMQ-x64\include\
rem pack mysys mingw-w64-x86_64-openssl
rem set HB_WITH_OPENSSL=d:\harbour\hb3rd\openssl-x64\include\
rem pack mysys mingw-w64-x86_64-cairo
rem set HB_WITH_CAIRO=d:\harbour\hb3rd\cairo-x64\include\cairo\
rem pack mysys mingw-w64-x86_64-imagemagick
rem set HB_WITH_LIBMAGIC=d:\harbour\hb3rd\magic-x64\include\
rem pack mysys mingw-w64-x86_64-firebird
set HB_WITH_FIREBIRD=d:\harbour\hb3rd\firebird-x64\include\
rem pack mysys mingw-w64-x86_64-postgresql
rem set HB_WITH_PGSQL=d:\harbour\hb3rd\pgsql-x64\include\
rem pack mysys mingw-w64-x86_64-libharu
rem SET HB_WITH_LIBHARU=d:\harbour\hb3rd\libharu-x64\include\
rem 
set HB_WITH_MYSQL=d:\harbour\hb3rd\mysql-x64\include\
rem
rem SET HB_WITH_BLAT=d:\harbour\hb3rd\blat-X64\
rem
set hB_WITH_OCIlib=d:\harbour\hb3rd\oci-x64\include\


SET HB_STATIC_CURL=yes
SET HB_STATIC_OPENSSL=yes
set HB_BUILD_CONTRIB_DYN=no
set HB_BUILD_DYN=no
set HB_BUILD_SHARED=no
SET HB_BUILD_STRIP=all

rem set PATH=d:\harbour\comp\mingw64\bin\;d:\harbour\BIN\;%PATH% abaixo com o call
call hb64mysis.bat
win-make install -k
rem 
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


