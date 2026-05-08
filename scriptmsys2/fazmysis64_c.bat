SET HB_INSTALL_PREFIX=c:\hbcomp\hb64\
SET HB_WITH_ADS=c:\harbour\hb3rd\acesdk-x64\
rem mingw-w64-x86_64-allegro
rem mingw-w64-x86_64-icu
rem mingw-w64-x86_64-libgd 
rem mingw-w64-x86_64-libmariadbclient
rem mingw-w64-x86_64-libxlsxwriter
rem pack mysys mingw-w64-x86_64-curl
rem SET HB_WITH_CURL=c:\harbour\hb3rd\curl-x64\include\
rem pack mysys mingw-w64-x86_64-freeimage
rem SET HB_WITH_FREEIMAGE=c:\harbour\hb3rd\FreeImage-x64\include\
rem pack mysys mingw-w64-x86_64-libssh2
rem SET HB_WITH_SSH2=c:\harbour\hb3rd\ssh2-x64\include\
rem pack msys mingw-w64-x86_64-ghostscript
rem set HB_WITH_GS=c:\harbour\hb3rd\gscript-x64\include\ghostscript\
rem pack mysys mingw-w64-x86_64-rabbitmq-c
rem SET HB_WITH_RABBITMQ=c:\harbour\hb3rd\RABBITMQ-x64\include\
rem pack mysys mingw-w64-x86_64-openssl
rem set HB_WITH_OPENSSL=c:\harbour\hb3rd\openssl-x64\include\
rem pack mysys mingw-w64-x86_64-cairo
rem set HB_WITH_CAIRO=c:\harbour\hb3rd\cairo-x64\include\cairo\
rem pack mysys mingw-w64-x86_64-imagemagick
rem set HB_WITH_LIBMAGIC=c:\harbour\hb3rd\magic-x64\include\
rem pack mysys mingw-w64-x86_64-firebird
set HB_WITH_FIREBIRD=c:\harbour\hb3rd\firebird-x64\include\
rem pack mysys mingw-w64-x86_64-postgresql
rem set HB_WITH_PGSQL=c:\harbour\hb3rd\pgsql-x64\include\
rem pack mysys mingw-w64-x86_64-libharu
rem SET HB_WITH_LIBHARU=c:\harbour\hb3rd\libharu-x64\include\
rem 
set HB_WITH_MYSQL=c:\harbour\hb3rd\mysql-x64\include\
rem
rem SET HB_WITH_BLAT=c:\harbour\hb3rd\blat-X64\
rem
set hB_WITH_OCIlib=c:\harbour\hb3rd\oci-x64\include\


SET HB_STATIC_CURL=yes
SET HB_STATIC_OPENSSL=yes
set HB_BUILD_CONTRIB_DYN=no
set HB_BUILD_DYN=no
set HB_BUILD_SHARED=no
SET HB_BUILD_STRIP=all

rem set PATH=c:\harbour\comp\mingw64\bin\;c:\harbour\BIN\;%PATH% abaixo com o call
call hb64mysis_c.bat
win-make install -k
rem 
REM deixando aqui como referencia win-make install e migw32-make sao equivalentes 
rem mingw32-make install

rem -o${hb_lib}/${hb_plat}/${hb_comp}/${hb_name}
rem copiando ate checar os makes gravar local correto
rem nao usar move para utilizar a criacao dinamica quando necessario
rem copy c:\harbour\contrib\sqlrddpp\lib\win\mingw\libsqlrddpp.a c:\harbour\lib\win\mingw\
rem copy c:\harbour\contrib\hbsvg\lib\win\mingw\libhbsvg.a       c:\harbour\lib\win\mingw\
rem copy c:\harbour\contrib\hbxlsxml\lib\win\mingw\libhbxlsxml.a c:\harbour\lib\win\mingw\
rem copy c:\harbour\contrib\rddado\lib\win\mingw\librddado.a     c:\harbour\lib\win\mingw\
rem copy c:\harbour\contrib\hbcab\lib\win\mingw\libhbcab.a          c:\harbour\lib\win\mingw\
rem copy c:\harbour\contrib\hbcrypto\lib\win\mingw\libhbcrypto.a     c:\harbour\lib\win\mingw\
rem copy c:\harbour\contrib\hbyaml\lib\win\mingw\libhbyaml.a     c:\harbour\lib\win\mingw\
rem copy c:\harbour\contrib\sevenzip\lib\win\mingw\libsevenzip.a     c:\harbour\lib\win\mingw\


