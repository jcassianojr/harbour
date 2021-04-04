SET HB_INSTALL_PREFIX=c:\hb34\
rem set HB_BIN_INSTALL=c:\hb34\harbour\bin\ rem nao estava compilando contrib deixando o make criar em \hb34\bin\win\mingw 
rem set HB_LIB_INSTALL=c:\hb34\harbour\lib\ rem nao estava compilando contrib deixando o make criar em \hb34\lib\win\mingw
set PATH=c:\devprg\hb32mgw93\comp\mingw\bin\;%PATH%
rem win-make clean install agora mingw32-make.exe
rem HB_ARCHITECTURE=linux rem autodectec pega o  sistema
rem HB_COMPILER=gcc rem autodectec pega o compilador peo path
rem HB_GPM_MOUSE=no
rem HB_GT_LIB=gtstd
rem HB_BIN_INSTALL=bin/
rem HB_LIB_INSTALL=lib/
rem HB_INC_INSTALL=include/
rem mingw32-make.exe clean install
set HB_BUILD_CONTRIBS=yes
set HB_BUILD_PARTS=all
mingw32-make.exe install



