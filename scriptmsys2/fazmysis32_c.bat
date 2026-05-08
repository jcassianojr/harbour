rem HB_COMPILER=mingw o make ja pega o compilador
SET HB_INSTALL_PREFIX=c:\hbcomp\hb32\

REM mingw-w64-i686-allegro
REM mingw-w64-i686-icu
REM mingw-w64-i686-libgd
rem install do ads
SET HB_WITH_ADS=c:\harbour\hb3rd\acesdk\
rem pack mysys mingw-w64-i686-curl
rem SET HB_WITH_CURL=c:\harbour\hb3rd\curl\include\
rem erro parando compilacao
set HB_WITH_FIREBIRD=c:\harbour\hb3rd\firebird\include\
rem mingw-w64-i686-freeimage
REM SET HB_WITH_FREEIMAGE=c:\harbour\hb3rd\FreeImage\include\
rem pack mysys mingw-w64-i686-ghostscript
rem set HB_WITH_GS=c:\harbour\hb3rd\gscript\include\ghostscript\
rem junto com srddpp
set HB_WITH_MYSQL=c:\harbour\hb3rd\mysql\include\
rem implantar oci oracle posteriromente
set hB_WITH_OCIlib=c:\harbour\hb3rd\oci\include\
rem pack mysys mingw-w64-i686-openssl
rem set HB_WITH_OPENSSL=c:\harbour\hb3rd\openssl\include\
rem
set HB_WITH_PGSQL=c:\harbour\hb3rd\pgsql\include\
rem pack mysys mingw-w64-i686-libssh2
rem SET HB_WITH_SSH2=c:\harbour\hb3rd\ssh2\include\
rem mingw-w64-i686-rabbitmq-c
REM SET HB_WITH_RABBITMQ=c:\harbour\hb3rd\RABBITMQ\include\
rem pack mysys mingw-w64-i686-cairo
rem set HB_WITH_CAIRO=c:\harbour\hb3rd\cairo\include\cairo\
rem pack mysys mingw-w64-i686-libharu
rem SET HB_WITH_LIBHARU=c:\harbour\hb3rd\libharu\include\
rem
rem SET HB_WITH_BLAT=c:\harbour\hb3rd\blat\

SET HB_STATIC_CURL=yes
SET HB_STATIC_OPENSSL=yes
set HB_BUILD_CONTRIB_DYN=no
set HB_BUILD_DYN=no
set HB_BUILD_SHARED=no
SET HB_BUILD_STRIP=all
rem HB_LANG=EN 

rem HB_WITH_BZIP2   hbbz2/hbbz2.hbp                  # uses: bz2 (locally hosted)
rem HB_WITH_EXPAT   hbexpat/hbexpat.hbp              # uses: expat (locally hosted)
rem HB_WITH_LZF     hblzf/hblzf.hbp                  # uses: liblzf (locally hosted)
rem HB_WITH_MINILZO hbmlzo/hbmlzo.hbp                # uses: libmlzo (locally hosted)
rem HB_WITH_MXML    hbmxml/hbmxml.hbp                # uses: minixml (locally hosted)
rem HB_WITH_MINIZIP hbmzip/hbmzip.hbp                # uses: minizip (locally hosted)
rem HB_WITH_XDIFF   hbxdiff/hbxdiff.hbp              # uses: libxdiff (locally hosted)
rem hbbz2io/hbbz2io.hbp              # uses: bz2 (locally hosted)
rem hbhpdf/hbhpdf.hbp                # uses: libhpdf (locally hosted)
rem hbsqlit3/hbsqlit3.hbp            # uses: sqlite3 (locally hosted)
rem sddsqlt3/sddsqlt3.hbp            # uses: sqlite3 (locally hosted
rem HB_WITH_QT
rem HB_WITH_CUPS
rem HB_WITH_GD
rem HB_WITH_GS
rem HB_WITH_ZLIB
rem HB_WITH_PNG
rem HB_WITH_ICU
rem HB_WITH_LIBMAGIC
rem HB_WITH_ODBC
rem HB_WITH_TINYMT
rem HB_WITH_XDIFF
rem HB_WITH_LIBYAML

rem set PATH=c:\harbour\comp\mingw\bin\;c:\harbour\BIN\;%PATH% call abaixo set os caminhos
call hb32mysis_c
win-make install -k
REM deixando aqui como referencia win-make install e migw32-make sao equivalentes 
REM mingw32-make install

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


