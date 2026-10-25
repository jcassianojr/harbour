REM copy c:\devgit\hb32\include\harbour.hbx
REM localizar e copiar todas hbx
REM copy c:\wutil\cudatext\data\autocomplete\Harbour.acp
REM unix2dos harbour.hbx
REM unix2dos harbour.def
REM unix2dos Harbour.acp
call d:\DEVPRG\hb64\hb64msys.bat
call c:\DEVPRG\hb64\hb64msys_c.bat
hbmk2 hbx.prg hbmisc.hbc hbct.hbc xhb.hbc \develop\harbour\csvrdd\f_freadl.prg hbtip.hbc c:\develop\harbour\diversos\objmgw\xhberr_mode.prg
