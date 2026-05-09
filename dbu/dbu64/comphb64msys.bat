call \devprg\hb\hb64msys.bat
hbmk2.exe dbu64.hbp -rebuild -v
rem -rebuild -v > log_detalhado.txt 2>&1
rem mt.exe -manifest dbu.exe.manifest -outputresource:dbu.exe;#1
rem windres --preprocessor=cat dbu.rc -o dbu_res.o
rem windres --preprocessor=cat d:\develop\harbour\dbu\dbu64\dbu.rc
rem c:\devprg\msys64\mingw64\bin\windres.exe --no-cpp dbu.rc -o dbu_res.o
rem c:\devprg\msys64\mingw64\bin\windres.exe dbu.rc dbu_res.o
