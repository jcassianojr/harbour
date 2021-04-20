SET HB_INSTALL_PREFIX=c:\hb34\
rem set HB_BIN_INSTALL=c:\hb34\harbour\bin\ rem nao estava compilando contrib deixando o make criar em \hb34\bin\win\mingw 
rem set HB_LIB_INSTALL=c:\hb34\harbour\lib\ rem nao estava compilando contrib deixando o make criar em \hb34\lib\win\mingw
set PATH=c:\devprg\hb32mgw93\comp\mingw\bin\;c:\hb34\BIN\;%PATH%
rem win-make clean install agora mingw32-make. win-make tem no hb32
rem HB_ARCHITECTURE=linux rem autodectec pega o  sistema
rem HB_COMPILER=gcc rem autodectec pega o compilador peo path
rem HB_GPM_MOUSE=no
rem HB_GT_LIB=gtstd
rem HB_BIN_INSTALL=bin/
rem HB_LIB_INSTALL=lib/
rem HB_INC_INSTALL=include/
rem mingw32-make.exe clean install
rem set HB_BUILD_CONTRIBS=yes
REM set HB_BUILD_PARTS=all
rem set HB_DIR_7Z=c:\wutil\totalcmd\packer\7-zip\
rem set HB_BUILD_PKG=yes
rem mingw32-make.exe install
win-make install
