@echo off
rem  busca tc *mingw\*.a
SET HB_INSTALL_PREFIX=d:\harbour\
rem set HB_INSTALL_LIB=d:\harbour\lib\ 
SET HB_WITH_ADS=d:\harbour\hb3rd\acesdk\
SET HB_WITH_CURL=d:\harbour\hb3rd\curl\include\
SET HB_WITH_FREEIMAGE=d:\harbour\hb3rd\FreeImage\
set HB_WITH_OPENSSL=d:\harbour\hb3rd\openssl\
set HB_WITH_FIREBIRD=d:\harbour\hb3rd\firebird\
set HB_WITH_MYSQL=d:\harbour\hb3rd\mysql\
set HB_WITH_OCI=d:\harbour\hb3rd\oci\
set HB_WITH_PGSQL=d:\harbour\hb3rd\pgsql\
set HB_WITH_GS_BIN=d:\harbour\hb3rd\gscript\
SET HB_STATIC_CURL=yes
SET HB_STATIC_OPENSSL=yes
call hb32mgw12
cd contrib
REM Faltando a dependência
REM hbmk2 gtalleg\gtalleg
hbmk2 gtqtc\gtqtc
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
hbmk2 hbcups\hbcups
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
REM Faltando a dependência
REM hbmk2 hbgs\hbgs
hbmk2 hbgt\hbgt
hbmk2 hbgzio\hbgzio
hbmk2 hbhpdf\hbhpdf
hbmk2 hbhttpd\hbhttpd
hbmk2 hblzf\hblzf
REM Faltando a dependência
REM hbmk2 hbmagic\hbmagic
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
hbmk2 hbtinymt\hbtinymt
hbmk2 hbtip\hbtip
hbmk2 hbtpathy\hbtpathy
hbmk2 hbunix\hbunix
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
rem hbmk2 hbamqp\hbamqp dependencia
hbmk2 hbcrypto\hbcrypto
rem hbmk2 hbicu\hbicu depenencia
hbmk2 hbmac\hbmac
hbmk2 hbyaml\hbyaml
rem minigui
hbmk2 hbcab\hbcab
hbmk2 sevenzip\sevenzip
hbmk2 libxlw\libxlw.hbp
rem outros
hbmk2 hbsvg\hbsvg.hbp
hbmk2 sqlrddpp\sqlrddpp.hbp

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


