@echo off
rem
rem chamar bat variaveis se necessario
rem SET HB_ARCHITECTURE=win
rem set HB_COMPILER=mingw
rem set HB_PATH=c:\devprg\hb32mgw12
rem SET HB_MINGW=c:\devprg\hb32mgw12\comp\mingw
rem SET HB_WITH_ADS=c:\devprg\hb3rd\acesdk\
rem SET INCLUDE_DIR=%HB_PATH%\include;%HB_MINGW%\include\
rem SET LIB_DIR=%HB_PATH%\lib\win\mingw\;%HB_MINGW%\lib\
rem set PATH=%HB_PATH%\bin\;%HB_MINGW%\bin\
rem
rem SET HB_WITH_ADS=c:\devprg\hb3rd\acesdk\
rem SET HB_WITH_CURL=c:\devprg\hb3rd\curl\
cd contrib
hbmk2 gtalleg\gtalleg
hbmk2 gtqtc\gtqtc
hbmk2 gtwvg\gtwvg
hbmk2 gtwvw\gtwvw
hbmk2 hbamf\hbamf
hbmk2 hbblat\hbblat
hbmk2 hbblink\hbblink
hbmk2 hbbz2\hbbz2
hbmk2 hbbz2io\hbbz2io
hbmk2 hbcairo\hbcairo
hbmk2 hbcomio\hbcomio
hbmk2 hbcomm\hbcomm
hbmk2 hbct\hbct
hbmk2 hbcups\hbcups
hbmk2 hbcurl\hbcurl
hbmk2 hbdoc\hbdoc
hbmk2 hbexpat\hbexpat
hbmk2 hbfbird\hbfbird
hbmk2 hbfimage\hbfimage
hbmk2 hbformat\hbformat
hbmk2 hbformat/utils/hbformat.hbp
hbmk2 hbfoxpro\hbfoxpro
hbmk2 hbfship\hbfship
hbmk2 hbgd\hbgd
hbmk2 hbgs\hbgs
hbmk2 hbgt\hbgt
hbmk2 hbgzio\hbgzio
hbmk2 hbhpdf\hbhpdf
hbmk2 hbhttpd\hbhttpd
hbmk2 hblzf\hblzf
hbmk2 hbmagic\hbmagic
hbmk2 hbmemio\hbmemio
hbmk2 hbmisc\hbmisc
hbmk2 hbmlzo\hbmlzo
hbmk2 hbmxml\hbmxml
hbmk2 hbmysql\hbmysql
hbmk2 hbmzip\hbmzip
hbmk2 hbnetio\hbnetio
hbmk2 hbnf\hbnf
hbmk2 hbodbc\hbodbc
hbmk2 hboslib\hboslib
hbmk2 hbpgsql\hbpgsql
hbmk2 hbpipeio\hbpipeio
hbmk2 hbtest\hbtest
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
hbmk2 sddfb\sddfb
hbmk2 sddmy\sddmy
hbmk2 sddoci\sddoci
hbmk2 sddodbc\sddodbc
hbmk2 sddpg\sddpg
hbmk2 sddsqlt3\sddsqlt3
hbmk2 xhb\xhb
rem vszakats
hbmk2 hbamqp\hbamqp
hbmk2 hbcrypto\hbcrypto
hbmk2 hbicu\hbicu
hbmk2 hbmac\hbmac
hbmk2 hbyaml\hbyaml
cd ..
cd extras
hbmk2 rddado\rddado
hbmk2 hbxlsxml\hbxlsxml