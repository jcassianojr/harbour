// +--------------------------------------------------------------------
// +
// +    Programa  : folis_c4.prg  LanCamento de uma Conta
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +--------------------------------------------------------------------
// +


function folis_c4()
IF !MDL( 'Listar Lan‡amento de uma Conta', 0 )
RETU
ENDIF

// Variaveis de Trabalho
FL        := CTA := 0
cPLANILHA := Space( 8 )
aCON      := {}
CTLIN     := 80
dINI      := dFIM := ZDATA
@ 23, 00 CLEA
@ 23, 00 SAY "Digite o Periodo"
@ 24, 00 SAY "Digite o Nome da Planilha ou a conta"
@ 23, 20 GET dINI
@ 23, 30 GET dFIM
@ 24, 40 GET cPLANILHA
@ 24, 50 GET CTA
IF !READCUR()
RETU .F.
ENDIF



aXCON := { CTA }

IF !Empty( cPLANILHA )
aXCON := PEGRELCTA( cPLANILHA )
ENDIF


IF !NETUSE( "CONTAS" )
dbCloseAll()
RETU .F.
ENDIF
FOR W := 1 TO Len( aXCON )
CTA := aXCON[ W ]
IF !Empty( CTA )
dbGoTop()
dbSeek( CTA )
IF !Found()
dbCloseAll()
ALERTX( 'Conta n„o Cadastrada: ' + Str( CTA ) )
RETU
ELSE
AAdd( aCON, { CTA, DESCR, TIPO } )
ENDIF
ENDIF
NEXT W
dbCloseAll()

IF Len( aCON ) = 0
ALERTX( 'Nenhuma conta Selecionada' )
RETU .F.
ENDIF




ARQ     := {}
nINIANO := Year( dINI )
nFIMANO := Year( dFIM )
FOR J := nINIANO TO nFIMANO
PATH1 := '\FOLHA\EMP' + ANOSTR( J ) + StrZero( NREMP, 3 ) + '\' + SPAC( 20 )
MDS( 'Confirme localiza‡„o Arquivos de:' + Str( J, 4 ) )
@ 24, 45 GET PATH1
IF !READCUR()
RETU .F.
ENDIF
PATH1 := AllTrim( PATH1 )
DO CASE
CASE nINIANO = nFIMANO
nMESINI := Month( dINI )
nMESFIM := Month( dFIM )
CASE nINIANO = J
nMESINI := Month( dINI )
nMESFIM := 12
CASE nFIMANO = J
nMESINI := 1
nMESFIM := Month( dFIM )
ENDCASE
FOR W := nMESINI TO nMESFIM
cARQ := PATH1 + if( NRSEN = "DiReT", "SO", "FP" ) + EMP + StrZero( W, 2 )
INFOR( cARQ, "CONTROLE", cARQ, .T. )
AAdd( ARQ, { cARQ, J, W } )
NEXT W
NEXT J

lTABULAR := MDG( "Deseja Tabular" )

IF !NETUSE( pes )
dbCloseAll()
RETU
ENDIF
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES.AND.YEAR(DEMITIDO)>=ANO))'
INX    := ""
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


IMPRESSORA()
IF lTABULAR
FOLISC41()
RETU
ENDIF

dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
NUM   := NUMERO
NOM   := NOME
CTLIN := 80  // Salta Cada Funcionario
FOR W := 1 TO Len( aCON )
aVAL  := { 0, 0 }
lCON  := .T.
lLIS  := .F.
nCOL  := 0
BUSCA := ( NUM * 10000 ) + aCON[ W, 1 ]
FOR X := 1 TO Len( ARQ )
ARQUIVO := ARQ[ X, 1 ]
VIDEO()
IF !NETUSE( ARQUIVO )  // AREDE(ARQUIVO,ARQUIVO,1)
dbCloseAll()
RETU .F.
ENDIF
IMPRESSORA()
dbGoTop()
IF dbSeek( BUSCA )
aVAL[ 1 ] += HORAS
aVAL[ 2 ] += VALOR
lLIS := .T.
IF CTLIN > 50 .AND. nCOL = 0
IF CTLIN # 80
IMPFOL()
ENDIF
FL++
@  0, 00 SAY IMPCHR( cIMPTIT ) + MSG2
@  1, 50 SAY Time()
@  1, 60 SAY Date()
@  1, 70 SAY 'FL. ' + StrZero( FL, 4 )
@  2, 00 SAY REPL( '-', 80 )
@  3, 00 SAY IMPCHR( cIMPTIT )
@  3, 00 SAY NUM
@  3, 07 SAY ACENTO( NOM )
@  4, 01 SAY "Horas"
@  4, 17 SAY "Valor"
@  4, 26 SAY "Competencia"
@  4, 41 SAY "Horas"
@  4, 57 SAY "Valor"
@  4, 66 SAY "Competencia"
@  5, 00 SAY REPL( '-', 80 )
CTLIN := 5
lCON  := .T.
ENDIF
IF lCON
CTLIN++
@ CTLIN, 00 SAY ACENTO( IMPSTR( cIMPCOM ) + IMPCHR( cIMPTIT ) + 'Lan‡amentos da Conta: ' + Str( aCON[ W, 1 ], 3 ) + ' - ' + aCON[ W, 2 ] + IMPSTR( cIMPEXP ) )
CTLIN++
@ CTLIN, 00 SAY "Periodo: " + DToC( dINI ) + " a " + DToC( dFIM )
CTLIN++
@ CTLIN, 00 SAY REPL( '-', 80 )
lCON := .F.
ENDIF
IF nCOL = 0
CTLIN++
IF HORAS > 0
@ CTLIN, 0 SAY HORAS PICT "###.##"
ENDIF
@ CTLIN, 8  SAY VALOR                  PICT "###,###,###.##"
@ CTLIN, 23 SAY ACENTO( MMES( ARQ[ X, 3 ] ) )
@ CTLIN, 33 SAY Str( ARQ[ X, 2 ], 4 )
nCOL := 40
ELSE
IF HORAS > 0
@ CTLIN, 40 SAY HORAS PICT "###.##"
ENDIF
@ CTLIN, 48 SAY VALOR                  PICT "###,###,###.##"
@ CTLIN, 63 SAY ACENTO( MMES( ARQ[ X, 3 ] ) )
@ CTLIN, 73 SAY Str( ARQ[ X, 2 ], 4 )
nCOL := 0
ENDIF
ENDIF
dbCloseArea()
NEXT X
IF lLIS
CTLIN++
@ CTLIN, 00 SAY "Totais"
IF aVAL[ 1 ] > 0
@ CTLIN, 10 SAY "Hora"
@ CTLIN, 20 SAY aVAL[ 1 ] PICT "@E 99,999,999.99"
ENDIF
@ CTLIN, 40 SAY "Valor"
@ CTLIN, 50 SAY aVAL[ 2 ] PICT "@E 99,999,999.99"
CTLIN++
@ CTLIN, 00 SAY REPL( '=', 80 )
ENDIF
NEXT W
dbSelectAr( PES )
dbSkip()
ENDDO
dbCloseAll()

IMPFOL()
VIDEO()
IMPEND()

RETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ANOSTR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC ANOSTR( XANO )

   RETU SubStr( StrZero( XANO, 4 ), 3, 2 )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOLISC41()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOLISC41

   nLIM := IF( Len( aCON ) > 5, 5, Len( aCON ) )
   dbSelectAr( PES )
   dbGoTop()
   WHILE !Eof()
      NUM  := NUMERO
      NOM  := NOME
      lLIS := .F.
      lFUN := .T.
      // CTLIN:=80 //Salta Cada Funcionario
      aVAL := Array( nLIM )
      AFill( aVAL, 0 )
      FOR X := 1 TO Len( ARQ )
         ARQUIVO := ARQ[ X, 1 ]
         VIDEO()
         // SELE 2
         IF !NETUSE( ARQUIVO )   // AREDE(ARQUIVO,ARQUIVO,1)
            dbCloseAll()
            RETU .F.
         ENDIF
         IMPRESSORA()
         IF CTLIN > 50
            IF CTLIN # 80
               IMPFOL()
            ENDIF
            FL++
            @  0, 00 SAY IMPCHR( cIMPTIT ) + MSG2
            @  1, 50 SAY Time()
            @  1, 60 SAY Date()
            @  1, 70 SAY 'FL. ' + StrZero( FL, 4 )
            @  2, 01 SAY "Comp."
            FOR W := 1 TO nLIM
               @  2, W * 12 + 5 SAY aCON[ W, 1 ] PICT "999"
            NEXT W
            @  3, 00 SAY REPL( '-', 80 )
            CTLIN := 4
         ENDIF
         aVALX := Array( nLIM )
         AFill( aVALX, 0 )
         aHORX := Array( nLIM )
         AFill( aHORX, 0 )
         lTEM := .F.
         FOR W := 1 TO nLIM
            dbGoTop()
            dbSeek( ( NUM * 10000 ) + aCON[ W,  1 ] )
            IF Found()
               lLIS       := .T.
               lTEM       := .T.
               aVALX[ W ] := VALOR
               aHORX[ W ] := HORAS
            ENDIF
         NEXT W
         IF lTEM
            IF lFUN
               @ CTLIN, 00 SAY IMPCHR( cIMPTIT )
               @ CTLIN, 00 SAY NUM
               @ CTLIN, 07 SAY ACENTO( NOM )
               CTLIN++
               @ CTLIN, 00 SAY REPL( '-', 80 )
               CTLIN++
               lFUN := .F.
            ENDIF
            @ CTLIN, 0 SAY Left( ACENTO( MMES( ARQ[ X, 3 ] ) ), 3 ) + "/" + Str( ARQ[ X, 2 ], 4 )
            FOR W := 1 TO nLIM
               IF aCON[ W,  3 ] = 0 .OR. aCON[ W,  3 ] = 2
                  @ CTLIN, W * 12 - 4 SAY aVALX[ W ] PICT "@E 99999,999.99"
                  aVAL[ W ] += aVALX[ W ]
               ELSE
                  @ CTLIN, W * 12 - 3 SAY aHORX[ W ] PICT "@E 99999,999.99"
                  aVAL[ W ] += aHORX[ W ]
               ENDIF
            NEXT W
            CTLIN++
         ENDIF
         dbCloseArea()
      NEXT X
      IF lLIS
         @ CTLIN, 00 SAY REPL( '=', 80 )
         CTLIN++
         @ CTLIN, 0 SAY "Totais"
         CTLIN++
         FOR W := 1 TO nLIM
            @ CTLIN, 0  SAY aCON[ W, 1 ] PICT "999"
            @ CTLIN, 5  SAY aCON[ W, 2 ]
            @ CTLIN, 50 SAY aVAL[ W ]   PICT "@E 99999,999.99"
            IF aCON[ W,  3 ] = 0 .OR. aCON[ W,  3 ] = 2
               @ CTLIN, 70 SAY "Valor"
            ELSE
               @ CTLIN, 70 SAY "Hora"
            ENDIF
            CTLIN++
         NEXT W
         CTLIN++
         @ CTLIN, 00 SAY REPL( '=', 80 )
         CTLIN++
      ENDIF
      dbSelectAr( PES )
      dbSkip()
   ENDDO
   IMPFOL()
   VIDEO()
   dbCloseAll()
   IMPEND()
   RETU .T.

// : FIM: FOLIS_C4.PRG

// + EOF: folis_c4.prg
// +
