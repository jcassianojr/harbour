set HB_WITH_MYSQL=c:\harbour\hb3rd\mysql\include\
set HB_WITH_PGSQL=c:\harbour\hb3rd\pgsql\include\
call \devprg\hb\hb32msys.bat
call \devprg\hb\hb32msys_c.bat
hbmk2.exe Tdbclasslib32.hbp
