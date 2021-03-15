*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function swpruncmd()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
//hbblink.hbc tem afuncao nativa fazer migracao depois
//RunShell( cCommand, cProgram, lAsync, lBackground )
//SwpRunCmd( cCommand, nMem, cRunPath, cTempPath )
//aqui sai para o outro diretorio
// WAPI_SHELLEXECUTE ShellExecute( ( HWND ) hb_parptr( 1 ),
//                                            HB_PARSTR( 2, &hOperation, NULL ), /* edit, explore, open, print, play?, properties? */
                                            //HB_PARSTRDEF( 3, &hFile, NULL ),
                                            //HB_PARSTR( 4, &hParameters, NULL ),
                                            //HB_PARSTR( 5, &hDirectory, NULL ),
                                            //hb_parnidef( 6, SW_SHOWNORMAL ) /* nShowCmd *
// wapi_ShellExecuteWait([<hWnd>], [<cOperation>], [<cFile>], [<cParameters>],
//                            [<cWorkDirectory>], [<nShowCmd>]) ? nResult
//wapi_ShellExecute( 0, 0, cFILE,"", 0, 1 )											
//ShellExecute(oOWNER:Handle(),String2Psz("print"),String2Psz(cFileNm),String2Psz(""),String2Psz(""),SW_SHOWNORMAL)		xsharp	
           //wapi_shellExecute(0,"open",cARQIMP)
			//ShellExecute ( NIL, "Open", cDANFEVIEW+"danfeview.exe", cARQIMP, cDANFEVIEW, SW_SHOWNORMAL )
			//ShellExecute ( NIL, "Open", cDANFEVIEW+"unidanfe.exe", "arquivo="+cARQIMP+" visualizar=1", cDANFEVIEW, SW_SHOWNORMAL )
			//ShellExecute ( NIL, "Open", cDANFEVIEW+"unidanfe.exe", "arquivo="+cARQIMP+" visualizar=1", cDANFEVIEW, SW_SHOWNORMAL )
 //WAPI_ShellExecute( NIL, "open", cFile, "",, WIN_SW_SHOWNORMAL )
//	  WAPI_ShellExecute( NIL, "open", cFile, "",, )
//HB_RUN( <cCommand> ) -> <nErrorLevel> __RUN

			
											

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

//HB_RUN t_nErrorLevel := hb_run( cCommand ) 
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

