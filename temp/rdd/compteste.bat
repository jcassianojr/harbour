rem call c:\devprg\hb64\hb64msys_C.bat
call c:\devprg\hb\hb32msys_C.bat

:: Limpeza preventiva de objetos que podem estar em 32 bits
hbmk2.exe teste.hbp 

call D:\devprg\hb\hb32msys.bat

:: Limpeza preventiva de objetos que podem estar em 32 bits
hbmk2.exe teste.hbp 
