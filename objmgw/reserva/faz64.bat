rem set HB_INSTALL_LIB=d:\harbour\lib\
rem SET HB_WITH_CAIRO=d:\harbour\cairo\
rem set HB_WITH_OCILIB=d:\harbour\ocilib\
rem  --with static      - link all binaries with static lib
rem     --with ads         - build components dependent on ads (rddads)
rem     --with allegro     - build components dependent on allegro (gtalleg)
rem     --with cups        - build components dependent on cups (hbcups)
rem     --with cairo       - build components dependent on cairo (hbcairo)
rem     --with curl        - build components dependent on libcurl (hbcurl)
rem     --with firebird    - build components dependent on firebird (hbfbird, sddfb)
rem     --with freeimage   - build components dependent on freeimage (hbfimage)
rem     --with gd          - build components dependent on gd (hbgd)
rem     --with mysql       - build components dependent on mysql (hbmysql, sddmy)
rem     --with odbc        - build components dependent on odbc (hbodbc, sddodbc)
rem     --with pgsql       - build components dependent on pgsql (hbpgsql, sddpg)
rem     --with localzlib   - build local copy of zlib library
rem    --with localpcre   - build local copy of pcre library
rem     --without x11      - do not build components dependent on x11 (gtxwc)
rem     --without curses   - do not build components dependent on curses (gtcrs)
rem     --without slang    - do not build components dependent on slang (gtsln)
rem     --without gpllib   - do not build components dependent on GPL 3rd party code
rem     --without gpm      - build components without gpm support (gttrm, gtsln, gtcrs)
rem HB_COMPILER=mingw
SET HB_INSTALL_PREFIX=d:\harbour\
rem set PATH=d:\harbour\comp\mingw64\bin\;d:\harbour\BIN\;%PATH%
SET HB_WITH_ADS=d:\harbour\hb3rd\acesdk-x64\
SET HB_WITH_CURL=d:\harbour\hb3rd\curl-x64\include\
SET HB_WITH_OPENSSL=d:\harbour\hb3rd\openssl-x64\
SET HB_WITH_SSH2=d:\harbour\hb3rd\ssh2-x64\
SET HB_WITH_FREEIMAGE=d:\harbour\hb3rd\FreeImage-x64\
call hb64mgw12.bat
win-make install
mingw32-make install

