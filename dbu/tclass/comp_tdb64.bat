set HB_WITH_MYSQL=c:\harbour\hb3rd\mysql-x64\include\
set HB_WITH_PGSQL=c:\harbour\hb3rd\pgsql-x64\include\
call d:\devprg\hb64\hb64msys.bat
call c:\devprg\hb64\hb64msys_C.bat
rem hbmk2.exe Tdbclass.hbp
hbmk2.exe Tdbclasslib64.hbp
