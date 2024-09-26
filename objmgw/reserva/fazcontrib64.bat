@echo off
rem *mingw64\*.a
SET HB_INSTALL_PREFIX=d:\harbour\
rem set HB_INSTALL_LIB=d:\harbour\lib\
SET HB_WITH_ADS=d:\harbour\hb3rd\acesdk-x64\
SET HB_WITH_CURL=d:\harbour\hb3rd\curl-x64\include\
SET HB_WITH_FREEIMAGE=d:\harbour\hb3rd\FreeImage-x64\include\
set HB_WITH_GS=d:\harbour\hb3rd\gscript-x64\include\ghostscript\
set HB_WITH_GS_BIN=d:\harbour\hb3rd\gscript-x64\bin\
SET HB_WITH_OPENSSL=d:\harbour\hb3rd\openssl-x64\include
SET HB_WITH_SSH2=d:\harbour\hb3rd\ssh2-x64\include
set HB_WITH_CAIRO=d:\harbour\hb3rd\cairo-x64\include\cairo\
set HB_WITH_LIBMAGIC=d:\harbour\hb3rd\magic-x64\include\
SET HB_WITH_RABBITMQ=d:\harbour\hb3rd\RABBITMQ-x64\include\
set HB_WITH_FIREBIRD=d:\harbour\hb3rd\firebird-x64\include\
set HB_WITH_PGSQL=d:\harbour\hb3rd\pgsql-x64\include\
SET HB_WITH_LIBHARU=d:\harbour\hb3rd\libharu-x64\include\
SET HB_STATIC_CURL=yes
SET HB_STATIC_OPENSSL=yes
call hb64mgw12.bat
cd contrib
REM Faltando a dependência
REM hbmk2 gtalleg\gtalleg
REM Faltando a dependência
rem hbmk2 gtqtc\gtqtc
hbmk2 gtwvg\gtwvg
hbmk2 gtwvw\gtwvw
hbmk2 hbamf\hbamf
hbmk2 hbblat\hbblat
hbmk2 hbblink\hbblink
hbmk2 hbbz2\hbbz2
hbmk2 hbbz2io\hbbz2io
REM Faltando a dependência
REM hbmk2 hbcairo\hbcairo
hbmk2 hbcomio\hbcomio
hbmk2 hbcomm\hbcomm
hbmk2 hbct\hbct
rem linux
rem hbmk2 hbcups\hbcups
hbmk2 hbcurl\hbcurl
hbmk2 hbdoc\hbdoc
hbmk2 hbexpat\hbexpat
REM Faltou a dependência
REM hbmk2 hbfbird\hbfbird
hbmk2 hbfimage\hbfimage
hbmk2 hbformat\hbformat
hbmk2 hbformat/utils/hbformat.hbp
hbmk2 hbfoxpro\hbfoxpro
hbmk2 hbfship\hbfship
REM Faltando a dependência
REM hbmk2 hbgd\hbgd
hbmk2 hbgs\hbgs
hbmk2 hbgt\hbgt
hbmk2 hbgzio\hbgzio
hbmk2 hbhpdf\hbhpdf
hbmk2 hbhttpd\hbhttpd
hbmk2 hblzf\hblzf
REM Faltando a dependência
hbmk2 hbmagic\hbmagic
hbmk2 hbmemio\hbmemio
hbmk2 hbmisc\hbmisc
hbmk2 hbmlzo\hbmlzo
hbmk2 hbmxml\hbmxml
REM Faltou a dependência
REM hbmk2 hbmysql\hbmysql
hbmk2 hbmzip\hbmzip
hbmk2 hbnetio\hbnetio
hbmk2 hbnf\hbnf
hbmk2 hbodbc\hbodbc
hbmk2 hboslib\hboslib
REM Faltou a dependência
REM hbmk2 hbpgsql\hbpgsql
hbmk2 hbpipeio\hbpipeio
REM hbmk2 hbtest\hbtest
hbmk2 hbssl\hbssl
hbmk2 hbtinymt\hbtinymt
hbmk2 hbtip\hbtip
hbmk2 hbtpathy\hbtpathy
rem hbmk2 hbunix\hbunix
hbmk2 hbwin\hbwin
hbmk2 hbxdiff\hbxdiff
hbmk2 hbxpp\hbxpp
hbmk2 hbyaml\hbyaml
hbmk2 hbzebra\hbzebra
hbmk2 hbziparc\hbziparc
hbmk2 rddads\rddads
hbmk2 rddbm\rddbm
hbmk2 rddmisc\rddmisc
hbmk2 rddsql\rddsql
REM Faltou a dependência
REM hbmk2 sddfb\sddfb
REM Faltou a dependência
REM hbmk2 sddmy\sddmy
REM Faltando a dependência
REM hbmk2 sddoci\sddoci
hbmk2 sddodbc\sddodbc
REM Faltou a dependência
REM hbmk2 sddpg\sddpg
hbmk2 sddsqlt3\sddsqlt3
hbmk2 xhb\xhb
rem extras
hbmk2 rddado\rddado
hbmk2 hbxlsxml\hbxlsxml
rem vszakats
hbmk2 hbamqp\hbamqp
hbmk2 hbcrypto\hbcrypto
rem hbmk2 hbicu\hbicu dependencia
rem lib para mac
rem hbmk2 hbmac\hbmac
hbmk2 hbyaml\hbyaml

rem minigui
hbmk2 hbcab\hbcab
hbmk2 sevenzip\sevenzip
hbmk2 libxlw\libxlw.hbp
hbmk2 hbsms\hbsms
hbmk2 hbxml\hbxml

rem outros
hbmk2 hbsvg\hbsvg.hbp
hbmk2 sqlrddpp\sqlrddpp.hbp

rem copiando ate checar os makes gravar local correto
rem nao usar move para utilizar a criacao dinamica quando necessario
rem copy d:\harbour\contrib\sqlrddpp\lib\win\mingw64\libsqlrddpp.a d:\harbour\lib\win\mingw64\
rem copy d:\harbour\contrib\hbsvg\lib\win\mingw64\libhbsvg.a       d:\harbour\lib\win\mingw64\
rem copy d:\harbour\contrib\hbxlsxml\lib\win\mingw64\libhbxlsxml.a d:\harbour\lib\win\mingw64\
rem copy d:\harbour\contrib\rddado\lib\win\mingw64\librddado.a     d:\harbour\lib\win\mingw64\
rem copy d:\harbour\contrib\hbcab\lib\win\mingw64\libhbcab.a       d:\harbour\lib\win\mingw64\
rem copy d:\harbour\contrib\hbcrypto\lib\win\mingw64\libhbcrypto.a d:\harbour\lib\win\mingw64\
rem copy d:\harbour\contrib\hbyaml\lib\win\mingw64\libhbyaml.a     d:\harbour\lib\win\mingw64\
rem copy d:\harbour\contrib\sevenzip\lib\win\mingw64\libsevenzip.a     d:\harbour\lib\win\mingw64\

