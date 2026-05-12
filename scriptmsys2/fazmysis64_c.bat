SET HB_INSTALL_PREFIX=c:\hbcomp\hb64\
SET HB_WITH_ADS=c:\harbour\hb3rd\acesdk-x64\
rem SET HB_WITH_CURL=c:\harbour\hb3rd\curl-x64\include\
rem SET HB_WITH_FREEIMAGE=c:\harbour\hb3rd\FreeImage-x64\include\
rem SET HB_WITH_SSH2=c:\harbour\hb3rd\ssh2-x64\include\
rem set HB_WITH_GS=c:\harbour\hb3rd\gscript-x64\include\ghostscript\
rem SET HB_WITH_RABBITMQ=c:\harbour\hb3rd\RABBITMQ-x64\include\
rem set HB_WITH_OPENSSL=c:\harbour\hb3rd\openssl-x64\include\
rem set HB_WITH_CAIRO=c:\harbour\hb3rd\cairo-x64\include\cairo\
rem set HB_WITH_LIBMAGIC=c:\harbour\hb3rd\magic-x64\include\
rem SET HB_WITH_LIBHARU=c:\harbour\hb3rd\libharu-x64\include\
rem SET HB_WITH_BLAT=c:\harbour\hb3rd\blat-X64\

set HB_WITH_FIREBIRD=c:\harbour\hb3rd\firebird-x64\include\
set HB_WITH_MYSQL=c:\harbour\hb3rd\mysql-x64\include\
set HB_WITH_PGSQL=c:\harbour\hb3rd\pgsql-x64\include\
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


