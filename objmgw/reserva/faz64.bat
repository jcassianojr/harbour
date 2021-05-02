SET HB_INSTALL_PREFIX=c:\hb64\
rem set HB_INSTALL_LIB=c:\hb64\lib\
set PATH=c:\hb64\comp\mingw64\bin\;c:\hb64\BIN\;%PATH%
SET HB_WITH_ADS=c:\devprg\hb3rd\acesdk-x64\
rem SET HB_WITH_CAIRO=c:\hb64\cairo\
rem SET HB_WITH_CURL=c:\hb64\curl\
rem set HB_WITH_OCILIB=c:\hb64\ocilib\
rem SET HB_WITH_OPENSSL=c:\hb64\openssl\
win-make install
mingw32-make install


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