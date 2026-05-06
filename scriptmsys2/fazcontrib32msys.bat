@echo off
rem busca tc *mingw\*.a
SET HB_INSTALL_PREFIX=d:\hbcomp\hb32\
REM rem set HB_INSTALL_LIB=d:\harbour\lib\ 

SET HB_WITH_ADS=d:\harbour\hb3rd\acesdk\
SET HB_WITH_ALLEGRO=d:\harbour\hb3rd\allegro\include\
SET HB_WITH_BLAT=d:\harbour\hb3rd\blat\
set HB_WITH_CAIRO=d:\harbour\hb3rd\cairo\include\cairo\
SET HB_WITH_CURL=d:\harbour\hb3rd\curl\include\
set HB_WITH_FIREBIRD=d:\harbour\hb3rd\firebird\include\
SET HB_WITH_FREEIMAGE=d:\harbour\hb3rd\FreeImage\include\
set HB_WITH_GS_BIN=d:\harbour\hb3rd\gscript\\bin\
set HB_WITH_GS=d:\harbour\hb3rd\gscript\include\ghostscript\
SET HB_WITH_LIBHARU=d:\harbour\hb3rd\libharu\include\
set HB_WITH_MYSQL=d:\harbour\hb3rd\mariadb\include\
rem set HB_WITH_MYSQL=d:\harbour\hb3rd\mysql\include\
set HB_WITH_OCIlib=d:\harbour\hb3rd\oci\include\
set HB_WITH_OPENSSL=d:\harbour\hb3rd\openssl\include\
set HB_WITH_PGSQL=d:\harbour\hb3rd\pgsql\include\
SET HB_WITH_RABBITMQ=d:\harbour\hb3rd\RABBITMQ\include\
SET HB_WITH_SSH2=d:\harbour\hb3rd\ssh2\include\
rem vszakats
SET HB_WITH_ICU=d:\harbour\hb3rd\icu\include\
SET HB_WITH_amqp=d:\harbour\hb3rd\amqp\include\
SET HB_WITH_crypto=d:\harbour\hb3rd\crypto\include\
SET HB_WITH_yaml=d:\harbour\hb3rd\yaml\include\
SET HB_WITH_GD=d:\harbour\hb3rd\gd\include\
set HB_STATIC_MYSQL=yes
SET HB_STATIC_CURL=yes
SET HB_STATIC_OPENSSL=yes
set HB_BUILD_CONTRIB_DYN=no
set HB_BUILD_DYN=no
set HB_BUILD_SHARED=no
SET HB_BUILD_STRIP=all

call hb32mysis.bat
cd contrib
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc gtalleg\gtalleg @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc gtqtc\gtqtc @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc gtwvg\gtwvg @hbpost
rem hbmk2 -quiet -width=0 -autohbm- @hbpre -inc gtwvw\gtwvw @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbamf\hbamf @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbblat\hbblat @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbblink\hbblink @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbbz2\hbbz2 @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbbz2io\hbbz2io @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbcairo\hbcairo @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbcomio\hbcomio @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbct\hbct @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbcurl\hbcurl @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbdoc\hbdoc @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbexpat\hbexpat @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbfbird\hbfbird @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbfimage\hbfimage @hbpost
rem hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbformat\hbformat @hbpost
rem hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbformat/utils/hbformat @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbfoxpro\hbfoxpro @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbfship\hbfship @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbgd\hbgd  @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbgs\hbgs @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbgt\hbgt @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbgzio\hbgzio @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbhpdf\hbhpdf @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbhttpd\hbhttpd @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbmagic\hbmagic @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbmemio\hbmemio @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbmisc\hbmisc @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbmlzo\hbmlzo @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbmxml\hbmxml @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbmysql\hbmysql @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbmzip\hbmzip @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbnetio\hbnetio @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbnf\hbnf @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbodbc\hbodbc @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hboslib\hboslib @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbpgsql\hbpgsql @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbssl\hbssl @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbpipeio\hbpipeio @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbtinymt\hbtinymt @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbtip\hbtip @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbwin\hbwin @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbxpp\hbxpp @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbyaml\hbyaml @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbzebra\hbzebra @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbziparc\hbziparc @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc rddads\rddads @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc rddbm\rddbm @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc rddmisc\rddmisc @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc rddsql\rddsql @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc sddfb\sddfb @hbpost
rem hbmk2  -inc sddfb\sddfb 
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc sddmy\sddmy @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc sddoci\sddoci @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc sddodbc\sddodbc @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc sddpg\sddpg @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc sddsqlt3\sddsqlt3 @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc xhb\xhb  @hbpost

rem extras
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc rddado\rddado @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbxlsxml\hbxlsxml @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbvpdf\hbvpdf @hbpost

rem zslask
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbamqp\hbamqp  @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbcrypto\hbcrypto @hbpost
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbicu\hbicu @hbpost
rem hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbyaml\hbyaml @hbpost

rem minigui
rem hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbcab\hbcab @hbpost
rem hbmk2 -quiet -width=0 -autohbm- @hbpre -inc sevenzip\sevenzip @hbpost
rem hbmk2 -quiet -width=0 -autohbm- @hbpre -inc  hblibxlsxwriter\hblibxlsxwriter @hbpost
rem hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbxml\hbxml @hbpost

rem xharbour
rem hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbbtree\hbbtree

rem outros
hbmk2 -quiet -width=0 -autohbm- @hbpre -inc sefazclass\sefazclass @hbpost
rem hbmk2 -quiet -width=0 -autohbm- @hbpre -inc hbsvg\hbsvg @hbpost
rem hbmk2 -quiet -width=0 -autohbm- @hbpre -inc superlib\superlib @hbpost
rem hbmk2  -inc superlib\superlib 
rem hbmk2 -quiet -width=0 -autohbm- @hbpre -inc gas4harbour\gas4harbour
rem hbmk2  -inc gas4harbour\gas4harbour
rem hbmk2 -quiet -width=0 -autohbm- @hbpre -inc wvwclip\wvwclip @hbpost
rem hbmk2 -quiet -width=0 -autohbm- @hbpre -inc sqlrddpp\sqlrddpp  @hbpost
hbmk2  -inc sqlrddpp\sqlrddpp
hbmk2 -inc hbxlsxwriter\hbxlsxwriter
