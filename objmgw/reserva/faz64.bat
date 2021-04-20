SET HB_INSTALL_PREFIX=c:\hb64\
rem set HB_INSTALL_LIB=c:\hb64\lib\
set PATH=c:\hb64\comp\mingw64\bin\;c:\hb64\BIN\;%PATH%
win-make install
mingw32-make install