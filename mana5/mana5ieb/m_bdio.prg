// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bdio.prg
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
// +    Documentado em 28-Dez-2024 as 10:47 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Source Module => J:\ITAESBRA\M_BDIO.PRG
// +
// +    Functions: Function M_BDIO01()
// +
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

// #INCLUDE "COMANDO.CH"
MDI( "Resumo Por Estados" )

IF !CHECKIMP( 0 )
RETU .F.
ENDIF

cTIPOCAN := "T"
cEMP     := IMP( "ZEMP" )
aCHA     := {}
aTOT     := {}
CTLIN    := 80
ZFOL     := 0
aUF      := { "AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", ;
      "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", ;
      "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO" }
aUFGIA := { "01", "02", "03", "04", "05", "06", "07", "08", "10", ;
      "12", "13", "28", "14", "15", "16", "17", "18", "19", ;
      "22", "20", "21", "23", "24", "25", "26", "27", "29" }
cAPUNEW := "S"

@ 22, 00 SAY "Grupo (T)odos (C)anceladas (N)Цo Canceladas"
@ 23, 00 SAY "Apurar CFO Novo"
@ 22, 50 GET cTIPOCAN                                      PICT "!" VALID cTIPOCAN $ "TCN"
@ 23, 20 GET cAPUNEW                                       PICT "!" VALID cAPUNEW $ "SN"
IF !READCUR()
RETU .F.
ENDIF

aRETU   := PERFEC( { "MM06", "MK06" }, { "M6", "K6" }, { "MM96", "MK96" } )
nMESUSO := aRETU[ 1 ]
nANOUSO := aRETU[ 2 ]
cARQSAI := aRETU[ 5, 1 ]
cARQENT := aRETU[ 5, 2 ]
CAB     := aRETU[ 7 ]

IF MDG( "Apurar Entradas" )
FILTRO := ""
IF !M_BDIO01( cARQENT )
RETU .F.
ENDIF
ENDIF
IF MDG( "Apurar Saidas" )
FILTRO := ""
IF !M_BDIO01( cARQSAI )
RETU .F.
ENDIF
ENDIF


IF !useMULT( { { "APUCFOUF", 0, 99 }, { "MD04", 1, IF( cAPUNEW = "S", 2, 3 ) } } )
dbCloseArea()
ENDIF
dbSelectAr( "APUCFOUF" )
ZAP
cCFO := IF( cAPUNEW = "N", "CFO", "CFONEW" )
aCAM := { "CONTABIL", "BASE", "VALOR", "ISENTA", ;
      "OUTRA", "OBS", "UF", cCFO, "DESCRICAO", "UFGIA" }
nPOS := Len( aCHA )
IMPRESSORA()
FOR X := 1 TO nPOS
IF CTLIN > 55
IF CTLIN <> 80
@ CTLIN, 0 SAY repl( '-', 230 )
ENDIF
ZFOL++
@  1, 0   SAY "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
@  1, 83  SAY CAB
@  1, 97  SAY ZDATA
@  1, 113 SAY Left( Time(), 5 )
@  1, 128 SAY Str( ZFOL, 4 )
@  2, 0   SAY repl( "-", 132 )
@  3, 2   SAY impchr( cIMPTIT ) + cEMP + impchr( cIMPEXP )
@  4, 00  SAY impchr( cIMPCOM ) + repl( '-', 230 )
@  5, 00  SAY 'CFO/UF.'
@  5, 32  SAY 'Total da NF'
@  5, 47  SAY 'Base ICM'
@  5, 62  SAY 'Valor3 ICM'
@  5, 77  SAY 'Isentas ICM'
@  5, 92  SAY 'Outras ICM'
@  5, 107 SAY 'OBS ICM'
@  5, 122 SAY 'Base IPI'
@  5, 137 SAY 'Valor IPI'
@  5, 152 SAY 'Isentas IPI'
@  5, 167 SAY 'Outras IPI'
@  5, 182 SAY 'Obs IPI'
CTLIN := 6
ENDIF
@ CTLIN, 02 SAY aCHA[ X ]
FOR Y := 1 TO 11
@ CTLIN, 17 + ( Y * 15 ) SAY aTOT[ X, Y ] PICT '@E 99,999,999.99'
NEXT Y
CTLIN++
cDESC := ""
dbSelectAr( "MD04" )
dbGoTop()
IF dbSeek( aTOT[ X, 13 ] )
cDESC := Left( DESCRICAO, 45 )
ENDIF
cUFGIA := "00"
nPOSUF := AScan( aUF, aTOT[ X, 12 ] )
IF nPOSUF > 0
cUFGIA := aUFGIA[ NPOSUF ]
ENDIF
aVAL := { aTOT[ X, 1 ], aTOT[ X, 2 ], aTOT[ X, 3 ], aTOT[ X, 4 ], ;
         aTOT[ X, 5 ], aTOT[ X, 6 ], aTOT[ X, 12 ], aTOT[ X, 13 ], cDESC, cUFGIA }
dbSelectAr( "APUCFOUF" )
netrecapp()
GRAVACAMPO( aCAM, aVAL,, .F., .F., .F. )
NEXT X
VIDEO()
IMPEND()


// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function M_BDIO01()
// +
// +    Called from ( m_bdio.prg   )   2 -
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_BDIO01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC M_BDIO01( cARQ )

   FILTRO := RFILORD( cARQ, .F. )
   IF !USEMULT( { { cARQ, 1, 0 }, { "MA01", 1, 1 }, { "MB01", 1, 1 } } )
      RETU .F.
   ENDIF
   dbSelectAr( cARQ )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   IF cAPUNEW = "N"
      ordDestroy( "temp" )
      ordCreate(, "temp", "tipofor + str( fornecedo, 8 ) + dcfone" )
      ordSetFocus( "temp" )
   ELSE
      ordDestroy( "temp" )
      ordCreate(, "temp", "tipofor + str( fornecedo, 8 ) + doper" )
      ordSetFocus( "temp" )
   ENDIF
   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO
   ENDIF
   dbGoTop()
   WHILE !Eof()
      @ 24, 00 SAY NUMERO
      @ 24, 10 SAY RecNo()
      nFORNECEDO := FORNECEDO
      nTIPO      := TIPOFOR
      cESTADO    := "ZZ"
      IF nTIPO = "C"
         dbSelectAr( "MA01" )
         dbGoTop()
         IF dbSeek( Nfornecedo )
            cESTADO := ESTADO
         ENDIF
      ENDIF
      IF nTIPO = "F"
         dbSelectAr( "MB01" )
         dbGoTop()
         IF dbSeek( NFornecedo )
            cESTADO := ESTADO
         ENDIF
      ENDIF
      dbSelectAr( cARQ )
      IF cESTADO = "ZZ"
         IF Empty( nTIPO )
            ALERTX( "Tipo Nao Preenchido" + Str( nFORNECEDO ) )
         ELSE
            ALERTX( "Cheque " + IF( nTIPO = "C", "Cliente", "Fornecedor" ) + Str( nFORNECEDO ) )
         ENDIF
         ALERTX( "Cadastro Estado-Ou Tipo Cliente Fornecedor na NF" )
         ALERTX( "NFЇ " + Str( NUMERO ) )
         IF !MDG( "Continuar Mesmo Assim" )
            dbCloseAll()
            RETU .F.
         ENDIF
      ENDIF
      dbSelectAr( cARQ )
      WHILE nTIPO = TIPOFOR .AND. nFORNECEDO = FORNECEDO .AND. !Eof()
         cDOPER := IF( cAPUNEW = "N", DOPER, DCFONEW )
         aVAL   := { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "", "" }
         // 12 Estado 13 CFO
         aCAM := { "DVALORNF", "DBASEICM", "DVALICM", "ISENTAICM", ;
            "OUTRAICM", "OBSICM", "DBASEIPI", "DVALIPI", ;
            "ISENTAIPI", "OUTRAIPI", "OBSIPI" }
         WHILE nTIPO = TIPOFOR .AND. nFORNECEDO = FORNECEDO .AND. cDOPER = IF( cAPUNEW = "N", DOPER, DCFONEW ) .AND. !Eof()
            IF SOMACANCEL()
               FOR X := 1 TO 11
                  cCAMPO := aCAM[ X ]
                  aVAL[ X ] += &cCAMPO.
               NEXT X
            ENDIF
            dbSelectAr( Carq )
            dbSkip()
         ENDDO
         nPOS := AScan( aCHA, cDOPER + cESTADO )
         IF nPOS > 0
            FOR X := 1 TO 11
               aTOT[ nPOS, X ] += aVAL[ X ]
            NEXT X
         ELSE
            aVAL[ 12 ] = cESTADO
            aVAL[ 13 ] = cDOPER
            AAdd( aCHA, cDOPER + cESTADO )
            AAdd( aTOT, aVAL )
         ENDIF
         dbSelectAr( cARQ )
      ENDDO
      dbSelectAr( cARQ )
   ENDDO
   dbCloseAll()
   RETU .T.

// + EOF: M_BDIO.PRG

// + EOF: m_bdio.prg
// +
