rem set HB_INSTALL_LIB=d:\harbour\lib\
rem  --with static      - link all binaries with static lib

rem     HB_WITH_allegro     - build components dependent on allegro (gtalleg)
rem     HB_WITH_cups        - build components dependent on cups (hbcups)
rem     HB_WITH_firebird    - build components dependent on firebird (hbfbird, sddfb)
rem     HB_WITH_gd          - build components dependent on gd (hbgd)
rem     HB_WITH_mysql       - build components dependent on mysql (hbmysql, sddmy)
rem     HB_WITH_odbc        - build components dependent on odbc (hbodbc, sddodbc)
rem     HB_WITH_pgsql       - build components dependent on pgsql (hbpgsql, sddpg)
rem     HB_WITH_localzlib   - build local copy of zlib library
rem     HB_WITH_localpcre   - build local copy of pcre library
rem     --whit inclui --whitout nao inclui
rem     --without x11      - do not build components dependent on x11 (gtxwc)
rem     --without curses   - do not build components dependent on curses (gtcrs)
rem     --without slang    - do not build components dependent on slang (gtsln)
rem     --without gpllib   - do not build components dependent on GPL 3rd party code
rem     --without gpm      - build components without gpm support (gttrm, gtsln, gtcrs)
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
rem HB_WITH_RABBITMQ
rem HB_WITH_BLAT
rem HB_WITH_CAIRO
rem HB_WITH_CUPS
rem HB_WITH_GD
rem HB_WITH_GS
rem HB_WITH_ZLIB
rem HB_WITH_PNG
rem HB_WITH_LIBHARU
rem HB_WITH_ICU
rem HB_WITH_LIBMAGIC
rem HB_WITH_ODBC
rem HB_WITH_TINYMT
rem HB_WITH_XDIFF
rem HB_WITH_LIBYAML

rem HB_COMPILER=mingw detectado pelo make
SET HB_INSTALL_PREFIX=d:\harbour\
rem build components dependent on ads (rddads)
SET HB_WITH_ADS=d:\harbour\hb3rd\acesdk-x64\
rem build components dependent on libcurl (hbcurl)
SET HB_WITH_CURL=d:\harbour\hb3rd\curl-x64\include\
rem build components dependent on freeimage (hbfimage)
SET HB_WITH_FREEIMAGE=d:\harbour\hb3rd\FreeImage-x64\
rem set HB_WITH_GS_BIN=d:\harbour\hb3rd\gscript\
SET HB_WITH_OPENSSL=d:\harbour\hb3rd\openssl-x64\include
SET HB_WITH_SSH2=d:\harbour\hb3rd\ssh2-x64\include
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


