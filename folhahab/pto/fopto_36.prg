// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_36.prg
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
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


// //#INCLUDE "COMANDO.CH"

CABE3( 'FOPTO_3 - Relatórios - Pontos e Totais', 23 )

cMESANO := ANOMESW
cPN     := "PN" + ANOMESW
cPT     := "PT" + ANOMESW
cPD     := "PD" + ANOMESW
cPP     := "PP" + ANOMESW
cPA     := "PA" + ANOMESW
FO21CRI( "PD", "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
FO21CRI( "PA", "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
FO21CRI( "PP", "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
FO21CRI( "PN", "FO_PON", "STR(NUMERO,8)+DTOS(DATA)" )
FO21CRI( "PT", "FO_POT", "NUMERO" )




cIMPORI := "R"
cDEC    := "N"
cBCO    := "N"
cDEM    := "N"
CENT    := "N"
@ 15, 01 SAY "Resumo Final em minutos sexadecimal"
@ 16, 01 SAY "Resumo Banco de Horas"
@ 17, 01 SAY "Listar Demitidos"
@ 18, 01 SAY "Espacar Entrelinha"
@ 15, 40 GET cDEC                                  PICT "!" VALID cDEC $ "SN"
@ 16, 40 GET cBCO                                  PICT "!" VALID cBCO $ "SN"
@ 17, 40 GET cDEM                                  PICT "!" VALID cDEM $ "SN"
@ 18, 40 GET CENT                                  PICT "!" VALID CENT $ "SN"
IF !READCUR()
RETU .F.
ENDIF

aEVED := {}
aEVEC := {}
aEVEB := {}
PegFeriados()



lMIN := cDEC = "S"
lBCO := cBCO = "S"
lDEM := cDEM = "S"
lENT := CENT = "S"

CODCTA := PEGCX()

DESCTA := Array( 24 )

IF !NETUSE( "FIRMA" )
RETU
ENDIF
dbGoTop()
dbSeek( NREMP )
mRAZ := RAZAO
mCGC := CGC
mEND := ENDERECO
mBAI := BAIRRO
mCID := CIDADE
mEST := ESTADO
dbCloseAll()

IF !NETUSE( "CONTAS" )
RETURN
ENDIF


IF !NETUSE( pes )
dbCloseAll()
RETURN
ENDIF
IF lDEM
FILTRO := ""
ELSE
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
ENDIF
INX := ""
FILORD( .T. )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
IF ValType( INX ) = "N"
dbSetOrder( INX )
ELSE
ordDestroy( "temp" )
ordCreate(, "temp", inx )
ordSetFocus( "temp" )
ENDIF
SET FILTER TO &FILTRO


IF !NETUSE( cPN )
dbCloseAll()
RETU
ENDIF

IF !NETUSE( cPT )
dbCloseAll()
RETU
ENDIF

IF !NETUSE( "TABTURNO" )
dbCloseAll()
RETU
ENDIF

IF !NETUSE( if( lSECBCO, "BCOBAK", "BCOHRS" ) )
dbCloseAll()
RETU
ENDIF
cSELE6 := Alias()

IF !NETUSE( "FO_PTT" )
dbCloseAll()
RETU
ENDIF




IF !NETUSE( cPD )
dbCloseAll()
RETURN 0
ENDIF
IF !NETUSE( cPP )
dbCloseAll()
RETURN 0
ENDIF
IF !NETUSE( cPA )
dbCloseAll()
RETURN 0
ENDIF



IF !MDL( 'FOPTO_36 - Listagem Apontamento e Totais' )
RETU
ENDIF
IF lENT
IMPRESSORA()
QQOut( Chr( 27 ) + "3" + "72" )
VIDEO()
ENDIF

LISTARUE( {| X | FOPTO36( X ) } )

RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO36()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FOPTO36

   PARA COMPARE

   dbSelectAr( PES )
   dbGoTop()
   WHILE !Eof()
      IF &COMPARE
         dbSelectAr( "CONTAS" )
         @ PRow() + 1, 0 SAY IMPSTR( cIMPEXP ) + repl( '=', 80 )
         @ PRow() + 1, 0 SAY "FOLHA DE PONTO - " + AllTrim( mRAZ )
         @ PRow(), 56   SAY "CGC:" + mCGC
         @ PRow() + 1, 0 SAY "End: " + mEND + " - " + mBAI + " - " + mCID + " - " + mEST
         IF !Empty( NOMSETOR )
            @ PRow() + 1, 0 SAY NOMSETOR
         ENDIF

         dbSelectAr( PES )
         TSA        := TIPO
         NUM        := NUMERO
         ANO        := Str( Year( DXDIA ), 4 )
         mDEMITIDO  := DEMITIDO
         DIAINI     := CToD( "  /  /  " )
         DIAFIM     := CToD( "  /  /  " )
         nTOTBCOHRS := 0
         cPIS       := PIS
         cEVINC     := FIELD->EVINC

         VIDEO()
         petela( 8 )
         IMPRESSORA()



         dbSelectAr( cPN )
         dbGoTop()
         dbSeek( Str( NUM, 8 ) )
         WHILE NUM = NUMERO .AND. !Eof()
            IF Empty( DIAINI )
               DIAINI := DATA
            ENDIF
            DIAFIM := DATA
            dbSkip()
         ENDDO

         dbSelectAr( PES )
         @ PRow() + 1, 0 SAY "Funcionario:" + Str( NUM, 8 ) + "-" + NOME + " PIS: " + cPIS
         @ PRow() + 1, 0 SAY "Depto: " + STRVAL( DEPTO, 4 ) + "/" + STRVAL( SETOR, 3 ) + "/" + STRVAL( SECAO, 3 ) + " Horario: "
         cHT  := HT
         cHTT := HTT
         dADM := ADMITIDO
         dbSelectAr( "TABTURNO" )
         dbGoTop()
         IF dbSeek( cHTT )
            @ PRow(), 30   SAY NOME
            @ PRow() + 1, 0 SAY "Admitido: " + DToC( dADM )
            IF !Empty( NOM2 )
               @ PRow(), 30 SAY NOM2
            ENDIF
         ELSE
            @ PRow(), 30   SAY "Descritivo de Horario nao Cadastrado"
            @ PRow() + 1, 0 SAY "Admitido: " + DToC( dADM )
         ENDIF
         @ PRow() + 1, 0     SAY "Periodo:" + DToC( DIAINI ) + "-" + DToC( DIAFIM )
         @ PRow(), PCol() + 1 SAY IMPSTR( cIMPCOM ) + " Legenda: #Alteracao de Horario Trabalho *Lancamento Manual"
         @ PRow() + 1, 0     SAY IMPSTR( cIMPCOM ) + repl( '-', 132 )
         @ PRow() + 1, 0     SAY IMPSTR( cIMPCOM ) + "DIA "
         FOR X := 1 TO 16
            @ PRow(), 21 + ( X * 6 ) SAY StrZero( X, 2 ) + '/' + StrZero( X + 16, 2 )
         NEXT X
         @ PRow() + 1, 0 SAY repl( '-', 132 )

         IF !VALPIS( cPIS, .F., .F., cEVINC )
            @ PRow() + 1, 0 SAY ZERRO
            IMPFOL()
            dbSelectAr( PES )
            dbSkip()
            LOOP
         ENDIF

         dbSelectAr( cPN )
         dbGoTop()
         dbSeek( Str( NUM, 8 ) )
         WHILE NUM = NUMERO .AND. !Eof()
            // X := day( DATA )
            @ PRow() + 1, 0   SAY IMPSTR( cIMPCOM ) + DToC( data )
            @ PRow(), PCol() SAY MUDHOR
            @ PRow(), 09     SAY COD
            IF !Empty( ENT ) .OR. !Empty( SAI )
               @ PRow(), 12     SAY ENT    PICT '##.##'
               @ PRow(), PCol() SAY MUDENT
               @ PRow(), 18     SAY SAI    PICT '##.##'
               @ PRow(), PCol() SAY MUDSAI
            ENDIF
            aCTA := { CTA01, CTA02, CTA03, CTA04, CTA05, CTA06, CTA07, CTA08, ;
               CTA09, CTA10, CTA11, CTA12, CTA13, CTA14, CTA15, CTA16, ;
               CTA17, CTA18, CTA19, CTA20, CTA21, CTA22, CTA23, CTA24 }
            FOR X := 1 TO 16
               IF !Empty( aCTA[ X ] )
                  @ PRow(), 18 + ( X * 6 ) SAY aCTA[ X ] PICT '###.##'
               ENDIF
            NEXT X
            IF CTA17 + CTA18 + CTA19 + CTA20 + CTA21 + CTA22 + CTA23 + CTA24 > 0
               @ PRow() + 1, 0 SAY "cta 17 a 24"
               FOR X := 1 TO 8
                  IF !Empty( aCTA[ X + 16 ] )
                     @ PRow(), 18 + ( X * 6 ) SAY aCTA[ X + 16 ] PICT '###.##'
                  ENDIF
               NEXT X
            ENDIF
            IF ( COD = "SA" .OR. SOD = "SA" ) .AND. DoW( DATA ) <> 7
               @ PRow() + 1, 0 SAY DToC( data ) + " Codigo SA sem ser sabado"
            ENDIF
            IF ( COD = "DO" .OR. SOD = "DO" ) .AND. DoW( DATA ) <> 1
               @ PRow() + 1, 0 SAY DToC( data ) + " Codigo DO sem ser domingo"
            ENDIF
            IF ( COD = "FE" .OR. SOD = "FE" ) .AND. AScan( aEVED, Str( Day( DATA ), 2 ) + Str( Month( DATA ), 2 ) ) = 0
               @ PRow() + 1, 0 SAY DToC( data ) + " Codigo FE sem feriado cadastrado "
            ENDIF

            VIDEO()
            nPASSAGENS := VERPASSAGENS( NUM, DATA, .F., .F., cPIS )
            IMPRESSORA()
            IF nPASSAGENS > 1 .AND. Int( nPASSAGENS / 2 ) <> nPASSAGENS / 2
               @ PRow() + 1, 0 SAY "Passagens impares Favor descartar desnecessarias"
            ENDIF

            dbSelectAr( cPN )
            dbSkip()
         ENDDO
         // totais
         dbSelectAr( cPT )
         dbGoTop()
         IF dbSeek( NUM )
            nTOTBCOHRS := BCOHRS
            @ PRow() + 1, 0 SAY IMPSTR( cIMPCOM ) + repl( '=', 132 ) + IMPSTR( cIMPCOM )
            aTOTAL := { CTA01, CTA02, CTA03, CTA04, CTA05, CTA06, CTA07, CTA08, ;
               CTA09, CTA10, CTA11, CTA12, CTA13, CTA14, CTA15, CTA16, ;
               CTA17, CTA18, CTA19, CTA20, CTA21, CTA22, CTA23, CTA24 }
            @ PRow() + 1, 0 SAY "Totais"
            FOR X := 1 TO 16
               IF !Empty( aTOTAL[ X ] )
                  @ PRow(), 18 + ( X * 6 ) SAY aTOTAL[ X ] PICT '###.##'
               ENDIF
            NEXT X
            @ PRow() + 1, 0 SAY IMPSTR( cIMPCOM ) + repl( '=', 132 )

            // Monta temporaria com os totais
            aTOTX := Array( 24 )
            aDESX := Array( 24 )
            aCTAX := Array( 24 )
            nPOSX := 1
            FOR x := 1 TO 24
               IF !Empty( aTOTAL[ X ] )
                  BUSCA := CODCTA[ X ]   // Contas 1 A 24
                  BUSCA := if( Empty( BUSCA ), 0, &BUSCA )
                  dbSelectAr( "CONTAS" )
                  dbGoTop()
                  dbSeek( BUSCA )
                  aDESX[ nPOSX ] := if( Found(), DESCR, "" )
                  aTOTX[ NPOSX ] := aTOTAL[ X ]
                  aCTAX[ NPOSX ] := X
                  nPOSX++
               ENDIF
            NEXT X

            // imprime a temporaria
            FOR X := 1 TO 24 STEP 2
               IF !Empty( aTOTX[ X ] )
                  @ PRow() + 1, 0 SAY StrZero( aCTAX[ X ], 3 ) + " - " + aDESX[ X ]
                  @ PRow(), 50   SAY if( lMIN, BHOR( aTOTX[ X ] ), aTOTX[ X ] )   PICT "9999.99"
               ENDIF
               IF !Empty( aTOTX[ X + 1 ] )
                  @ PRow(), 60  SAY StrZero( aCTAX[ X + 1 ], 3 ) + " - " + aDESX[ X + 1 ]
                  @ PRow(), 110 SAY if( lMIN, BHOR( aTOTX[ X + 1 ] ), aTOTX[ X + 1 ] )   PICT "9999.99"
               ENDIF
            NEXT X
         ENDIF

         IF !Empty( mDEMITIDO ) .OR. lBCO
            dbSelectAr( cSELE6 )
            nSALDO := pegsaldobco( NUM, nANOANT, nMESANT )
            IF nSALDO <> 0.00 .OR. nTOTBCOHRS <> 0.00
               @ PRow() + 1, 0     SAY "Saldo Banco Horas=" + Str( MES ) + "/" + Str( ANO )
               @ PRow(), 30       SAY if( lMIN, BHOR( nSALDO ), nSALDO )                       PICT "9999.99"
               @ PRow(), PCol() + 1 SAY "Atual="
               @ PRow(), PCol() + 1 SAY if( lMIN, BHOR( nTOTBCOHRS ), nTOTBCOHRS )               PICT "9999.99"
               @ PRow(), PCol() + 1 SAY "="
               @ PRow(), PCol() + 1 SAY if( lMIN, BHOR( nSALDO + nTOTBCOHRS ), nSALDO + nTOTBCOHRS ) PICT "9999.99"
               @ PRow() + 1, 0     SAY IMPSTR( cIMPCOM ) + repl( '=', 132 )
            ENDIF
         ENDIF
         @ PRow() + 1, 0 SAY IMPSTR( cIMPCOM ) + repl( '=', 132 )

         // Totais Anuais
         aTOTANO := PEGTOTANO( NUM, .F. )
         @ PRow() + 1, 0 SAY "Totais Anual"
         FOR X := 1 TO 12
            IF !Empty( aTOTANO[ X ] )
               @ PRow(), 17 + ( X * 8 ) SAY StrZero( X, 3 )
            ENDIF
         NEXT X
         @ PRow() + 1, 0 SAY ""
         FOR X := 1 TO 12
            IF !Empty( aTOTANO[ X ] )
               @ PRow(), 14 + ( X * 8 ) SAY aTOTANO[ X ] PICT '####.##'
            ENDIF
         NEXT X
         @ PRow() + 1, 0 SAY ""
         FOR X := 13 TO 24
            IF !Empty( aTOTANO[ X ] )
               @ PRow(), 17 + ( ( X - 12 ) * 8 ) SAY StrZero( X, 3 )
            ENDIF
         NEXT X
         @ PRow() + 1, 0 SAY ""
         FOR X := 13 TO 24
            IF !Empty( aTOTANO[ X ] )
               @ PRow(), 14 + ( ( X - 12 ) * 8 ) SAY aTOTANO[ X ] PICT '####.##'
            ENDIF
         NEXT X
         @ PRow() + 1, 0 SAY IMPSTR( cIMPEXP ) + repl( '=', 80 )
         @ PRow() + 3, 0 SAY repl( '-', 35 ) + spac( 10 ) + repl( '-', 35 )
         @ PRow() + 1, 6 SAY "Assinatura do RH" + spac( 28 ) + "Assinatura do Funcionario"
         @ PRow() + 1, 0 SAY repl( '=', 80 )
         IMPFOL()
      ENDIF
      dbSelectAr( PES )
      dbSkip()
   ENDDO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PegSaldoBco()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION PegSaldoBco( nNUMBUS, nANOBUS, nMESBUS, lOPEN )   // dbselectar() antes de chamar

   LOCAL nSALDO

   IF ValType( lOPEN ) # "L"
      lOPEN := .F.
   ENDIF
   IF lOPEN
      IF !NETUSE( if( lSECBCO, "BCOBAK", "BCOHRS" ) )
         RETU 0
      ENDIF
   ENDIF
   nSALDO := 0
   dbGoTop()
   IF dbSeek( Str( nNUMBUS, 8 ) + Str( nANOBUS, 4 ) + Str( nMESBUS, 2 ) )   // pega a competencia
      nSALDO := SALDO
   ENDIF
   IF lOPEN
      dbCloseArea()
   ENDIF
   RETU nSALDO


// + EOF: fopto_36.prg
// +
