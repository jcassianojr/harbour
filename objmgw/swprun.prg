*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function swpruncmd()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
//hbblink.hbc tem afuncao nativa fazer migracao depois

FUNCTION SwpRunCmd( cCommand, nuMem, cRunPath, cTempPath )

LOCAL nAt, cArgs, cPresetDisk, cPresetDir, nRet


DIR_SEPARATOR:='\'

IF Empty( cRunPath )
nAt := At( ' ', cCommand )

IF nAt > 0
cArgs := SubStr( cCommand, nAt )
cCommand := Left( cCommand, nAt - 1 )
ENDIF

nAt := RAt( DIR_SEPARATOR, cCommand )

IF nAt > 0
cRunPath := Left( cCommand, nAt )
cCommand := SubStr( cCommand, nAt + 1 ) + cArgs
ENDIF
ENDIF

IF cRunPath[2] == ':'
cPresetDisk := DiskName()

IF ! DiskChange( cRunPath[1] )
    ALERTX("Swprund: Erro ao mudar para o drive "+ cRunPath[1])
    retu .f.
ENDIF

cRunPath := SubStr( cRunPath, 3 )
ENDIF

IF ! Empty( cRunPath )
   cPresetDir := HB_CWD() //DIR_SEPARATOR + CurDir()
   HB_CWD(cRUNPATH) 
   //IF DirChange( cRunPath ) != 0
   IF cPRESETDIR=HB_CWD()
      ALERTX("Swprund: Erro ao mudar para a pasta "+CRunPath )
      retu .f.
    ENDIF
ENDIF

__Run( cCommand, @nRet )
SwpErrLev( nRet )

IF ! Empty( cPresetDisk )
    IF ! DiskChange( cPresetDisk )
       ALERTX("Swprund: Erro ao retornar para o drive"+ cPresetDisk )
       retu .f.
    ENDIF
ENDIF

IF ! Empty( cPresetDir )
   IF DirChange( cPresetDisk ) != 0
      ALERTX("Swprund: Erro ao retornar para o diretorio"+ cPresetDir )
      retu .f.
   ENDIF
eNDIF

RETURN nRet == 0

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function SwpErrLev( nLev )
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION SwpErrLev( nLev )
 STATIC s_nLastLev := 0
IF ValType( nLev ) == 'N'
   s_nLastLev := nLev
ENDIF
RETURN s_nLastLev

