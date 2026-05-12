@echo off
rem *mingw64\*.a
SET HB_INSTALL_PREFIX=c:\hbcomp\hb64\

REM rem set HB_INSTALL_LIB=c:\harbour\lib\
SET HB_WITH_ADS=c:\harbour\hb3rd\acesdk-x64\
SET HB_WITH_ALLEGRO=c:\harbour\hb3rd\allegro-X64\include\
SET HB_WITH_BLAT=c:\harbour\hb3rd\blat-X64\
set HB_WITH_CAIRO=c:\harbour\hb3rd\cairo-x64\include\cairo\
SET HB_WITH_CURL=c:\harbour\hb3rd\curl-x64\include\
set HB_WITH_FIREBIRD=c:\harbour\hb3rd\firebird-x64\include\
SET HB_WITH_FREEIMAGE=c:\harbour\hb3rd\FreeImage-x64\include\
set HB_WITH_GS_BIN=c:\harbour\hb3rd\gscript-x64\bin\
set HB_WITH_GS=c:\harbour\hb3rd\gscript-x64\include\ghostscript\
SET HB_WITH_LIBHARU=c:\harbour\hb3rd\libharu-x64\include\
set HB_WITH_LIBMAGIC=c:\harbour\hb3rd\magic-x64\include\
SET HB_WITH_OPENSSL=c:\harbour\hb3rd\openssl-x64\include

SET HB_WITH_RABBITMQ=c:\harbour\hb3rd\RABBITMQ-x64\include\
SET HB_WITH_SSH2=c:\harbour\hb3rd\ssh2-x64\include
set HB_WITH_OCIlib=c:\harbour\hb3rd\oci-x64\include\
SET HB_WITH_GD=c:\harbour\hb3rd\gd-X64\include\

rem vszakats
SET HB_WITH_ICU=c:\harbour\hb3rd\icu-x64\include\
SET HB_WITH_AMQP=c:\harbour\hb3rd\amqp-x64\include\
SET HB_WITH_CRYPTO=c:\harbour\hb3rd\crypto-x64\include\

SET HB_WITH_EXPAT=c:\harbour\hb3rd\expat-x64\include\
SET HB_WITH_ZLIB=c:\harbour\hb3rd\zlib-x64\include\
SET HB_WITH_BZ2=c:\harbour\hb3rd\bzip2-x64\include\
SET HB_WITH_LIBXLSXWRITER=c:\harbour\hb3rd\libxlsxwriter-x64\include\
SET HB_WITH_YAML=c:\harbour\hb3rd\yaml-x64\include\
SET HB_WITH_SQLITE3=c:\harbour\hb3rd\sqlite-x64\include\

SET HB_STATIC_CURL=yes
SET HB_STATIC_OPENSSL=yes
set HB_BUILD_CONTRIB_DYN=no
set HB_BUILD_DYN=no
set HB_BUILD_SHARED=no


call hb64mysis_c.bat
cd contrib
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  gtalleg\gtalleg @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  gtqtc\gtqtc @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  gtwvg\gtwvg @hbpost
rem hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  gtwvw\gtwvw @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbamf\hbamf @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbblat\hbblat @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbblink\hbblink @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbbz2\hbbz2 @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbbz2io\hbbz2io @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbcairo\hbcairo @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbcomio\hbcomio @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbct\hbct @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbcurl\hbcurl @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbdoc\hbdoc @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbexpat\hbexpat @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbfbird\hbfbird @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbfimage\hbfimage @hbpost
rem hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbformat\hbformat @hbpost
rem hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbformat/utils/hbformat @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbfoxpro\hbfoxpro @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbfship\hbfship @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbgd\hbgd  @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbgs\hbgs @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbgt\hbgt @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbgzio\hbgzio @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbhpdf\hbhpdf @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbhttpd\hbhttpd @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbmagic\hbmagic @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbmemio\hbmemio @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbmisc\hbmisc @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbmlzo\hbmlzo @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbmxml\hbmxml @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbmzip\hbmzip @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbnetio\hbnetio @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbnf\hbnf @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbodbc\hbodbc @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hboslib\hboslib @hbpost

hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbpipeio\hbpipeio @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbssl\hbssl @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbtinymt\hbtinymt @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbtip\hbtip @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbwin\hbwin @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbxpp\hbxpp @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbyaml\hbyaml @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbzebra\hbzebra @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbziparc\hbziparc @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  rddads\rddads @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  rddbm\rddbm @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  rddmisc\rddmisc @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  rddsql\rddsql @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  sddfb\sddfb @hbpost
rem hbmk2  -inc  sddfb\sddfb
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  sddoci\sddoci @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  sddodbc\sddodbc @hbpost

hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  sddsqlt3\sddsqlt3 @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  xhb\xhb @hbpost

rem extras
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  rddado\rddado @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbxlsxml\hbxlsxml @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbvpdf\hbvpdf @hbpost

rem vszakats
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbamqp\hbamqp @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbcrypto\hbcrypto @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbicu\hbicu  @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbyaml\hbyaml @hbpost

rem minigui
rem hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbcab\hbcab @hbpost
rem hbmk2 -inc  hbcab\hbcab 
rem hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  sevenzip\sevenzip @hbpost
rem hbmk2 -inc  sevenzip\sevenzip
rem hbmk2 -quiet -width=0 -autohbm- @hbpre -inc  hblibxlsxwriter\hblibxlsxwriter @hbpost
hbmk2 -inc  hbxml\hbxml

rem xharbour
rem hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbbtree\hbbtree

rem outros
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  sefazclass\sefazclass @hbpost
rem hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbsvg\hbsvg @hbpost
rem hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  sqlrddpp\sqlrddpp @hbpost
hbmk2 -inc sqlrddpp\sqlrddpp
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  superlib\superlib
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  gas4harbour\gas4harbour 
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  wvwclip\wvwclip
rem hbmk2 -inc hbxlsxwriter\hbxlsxwriter


Set HB_STATIC_MYSQL=yes
set HB_USER_LDFLAGS=-static -static-libgcc -static-libstdc++

set HB_WITH_MYSQL=c:\harbour\hb3rd\mysql-x64\include\
rem set HB_WITH_MYSQL=c:\harbour\hb3rd\mariadb-x64\include\
rem set HB_WITH_MYSQL=c:\harbour\hb3rd\mysql-x64Mariadb\include\
rem set HB_WITH_MYSQL=c:\harbour\hb3rd\mariadb-x64\

hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  sddmy\sddmy @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbmysql\hbmysql @hbpost




rem --- CONFIGURAÇÃO DE LINKAGEM ---
set HB_STATIC_PGSQL=no
set HB_WITH_PGSQL=c:\harbour\hb3rd\pgsql-x64\include\
set HB_USER_LDFLAGS=-static -static-libgcc
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  hbpgsql\hbpgsql @hbpost
hbmk2 -quiet  -width=0 -autohbm- @hbpre -inc  sddpg\sddpg @hbpost