// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_cv.prg
// +
// +
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +
// +
// +
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +



MDI( "Manutencao Especial de Arquivos" )
lFECMES := MDG( "Efetuar Fechamento Mensal" )


IF lFECMES
IF USEREDE( "MANFEC", 1, 99 )
dbGoTop()
WHILE !Eof()
IF FECHAAUTO = "S"
IF Empty( OPER04 )
ALERTX( ARQORI )
ELSE
AAdd( aARQX, AllTrim( OPER04 ) )
ENDIF
ENDIF
dbSkip()
ENDDO
dbCloseArea()
nARQ := Len( aARQX )
FOR N := 1 TO nARQ
cVAR := aARQX[ N ]
cVAR := &( "{||" + cVAR + "}" )
Eval( cVAR )
NEXT N
ENDIF
RETURN .T.
ENDIF

FILMCV := ""
FILMCV := RFILORD( zARQ1, .F. )
aARQX  := {}
lFIXAR := MDG( "Fixar Arquivo" )
lAPAGA := MDG( "Excluir Arquivos Fechados Inexistentes" )


IF lFIXAR .OR. lAPAGA
IF !USECHK( ZDIRC + "MANARQ", ZDIRC + "MANARQ", .T. )
dbCloseAll()
RETU .F.
ENDIF
SET FILTER TO &FILMCV.
IF !USECHK( ZDIRC + "MANARQ1", ZDIRC + "MANARQ", .T. )
dbCloseAll()
RETU .F.
ENDIF

dbSelectAr( "MANARQ" )
nLASTREC := LastRec()
nPOSREC  := 1
dbGoTop()
WHILE !Eof()
IF At( "CEP", CAMINHO ) > 0 .OR. ARQANO > 0 .OR. PULAFIX = "S"   // Nao Inclui os CEPS Fechados
ELSE
@ 24, 00 SAY PadR( ARQUIVO, 80 )
AAdd( aARQX, AllTrim( ARQUIVO ) )
ENDIF
IF ARQANO > 0
cARQ := AllTrim( caminho ) + AllTrim( ARQUIVO ) + ".DBF"
IF !File( cARQ )
@ 23, 00 SAY cARQ
netrecdel()
dbSelectAr( "MANARQ1" )
dbGoTop()
WHILE cARQ = AllTrim( ARQUIVO ) .AND. !Eof()
netrecdel()
dbSkip()
ENDDO
ENDIF
ENDIF
dbSelectAr( "MANARQ" )
dbSkip()
ZEI_FORT( nLASTREC, .T., nPOSREC )
nPOSREC++
ENDDO
IF lFIXAR
dbSelectAr( "MANARQ" )
PACK
dbSelectAr( "MANARQ1" )
PACK
ENDIF


dbCloseAll()

IF lFIXAR
nLASTREC := Len( aARQX )
FOR X := 1 TO nLASTREC
mARQUIVO := aARQX[ X ]
@ 24, 00 SAY PadR( mARQUIVO, 80 )
IF mARQUIVO # "MANARQ" .AND. mARQUIVO # "MANARQ1"
IF USEREDE( mARQUIVO, 0, 99,,, 300 )
PACK
dbCloseArea()
ENDIF
ENDIF
ZEI_FORT( nLASTREC, .F., X )
NEXT
ENDIF
ENDIF

IF mdg( "Apagar Duplicidades Configuracao Indexacao" )
IF !USECHK( ZDIRC + "MANARQ1", ZDIRC + "MANARQ", .T. )
dbCloseAll()
RETU .F.
ENDIF
dbGoTop()
WHILE !Eof()
cARQUIVO := ARQUIVO
nITEM    := ITEM
dbSkip()
IF !Eof()
IF cARQUIVO = ARQUIVO .AND. nITEM = ITEM
netrecdel()
ENDIF
ENDIF
ENDDO
IF lFIXAR
PACK
ENDIF
dbCloseAll()
ENDIF

IF mdg( "Apagar Indices sem Arquivo" )
IF !USECHK( ZDIRC + "MANARQ", ZDIRC + "MANARQ", .T. )
dbCloseAll()
RETU .F.
ENDIF
IF !USECHK( ZDIRC + "MANARQ1", ZDIRC + "MANARQ", .T. )
dbCloseAll()
RETU .F.
ENDIF
dbSelectAr( "MANARQ1" )
dbGoTop()
WHILE !Eof()
cARQUIVO := ARQUIVO
dbSelectAr( "MANARQ" )
dbGoTop()
lTEM := dbSeek( cARQUIVO )
dbSelectAr( "MANARQ1" )
IF !lTEM
netrecdel()
ENDIF
dbSkip()
ENDDO
IF lFIXAR
dbSelectAr( "MANARQ1" )
PACK
ENDIF
dbCloseAll()
ENDIF



// + EOF: m_cv.prg
// +
