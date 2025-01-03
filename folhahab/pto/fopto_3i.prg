// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_3i.prg
// +
// +
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
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


function fopto_3i()
dINI := dFIM := ZDATA
MDS( 'Qual Periodo' )
@ 24, 20 GET dINI
@ 24, 30 GET dFIM
IF !READCUR()
RETU .F.
ENDIF

IF !CHECKIMP( 0 )
RETU .F.
ENDIF

ARQ     := {}
nINIANO := Year( dINI )
nFIMANO := Year( dFIM )
FOR J := nINIANO TO nFIMANO
PATH1 := '\FOLHA\EMP' + ANOSTR( J ) + StrZero( NREMP, 3 ) + '\' + spac( 20 )
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
cARQ := PATH1 + "PN" + ANOSTR( J ) + StrZero( W, 2 )
IF !INFOR( cARQ, "STR(NUMERO,8)+DTOS(DATA)", cARQ, .T. )
RETU .F.
ENDIF
AAdd( ARQ, { cARQ, J, W } )
NEXT W
NEXT J

IF !netuse( "tabfalta" )
dbCloseAll()
RETU .F.
ENDIF

IF !NETUSE( pes )
dbCloseAll()
RETU
ENDIF
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
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

LISTARUE( {| X | FOPTO3I( X ) } )

RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO3I()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FOPTO3I

   LOCAL cARQUSO
   PARA COMPARE

   dbSelectAr( PES )
   dbGoTop()
   WHILE !Eof()
      IF &COMPARE
         mNUMERO := NUMERO
         mNOME   := NOME
         CTLIN   := 80
         FOR W := 1 TO Len( ARQ )
            VIDEO()
            cARQUSO := ARQ[ W, 1 ]
            IF !netuse( cARQUSO )
               VIDEO()
               dbCloseAll()
               RETU .F.
            ENDIF
            IMPRESSORA()
            dbGoTop()
            dbSeek( Str( mNUMERO, 8 ) )
            WHILE mNUMERO = NUMERO .AND. !Eof()
               IF !Empty( COD )
                  IF CTLIN > 50
                     @  0, 0  SAY "Ficha Frequencia"
                     @  1, 0  SAY mNUMERO
                     @  1, 10 SAY mNOME
                     IF !Empty( NOMSETOR )
                        @  2, 00 SAY NOMSETOR
                        CTLIN := 3
                     ELSE
                        CTLIN := 2
                     ENDIF
                  ENDIF
                  CTLIN++
                  @ CTLIN, 0  SAY DATA
                  @ CTLIN, 10 SAY COD
                  mCOD := COD
                  IF !Empty( mCOD )
                     dbSelectAr( "TABFALTA" )
                     dbGoTop()
                     IF dbSeek( mCOD )
                        @ CTLIN, 13 SAY NOME
                     ENDIF
                     dbSelectAr( Carquso )
                  ENDIF
               ENDIF
               dbSelectAr( Carquso )
               dbSkip()
            ENDDO
         NEXT W
         dbSelectAr( Carquso )
         dbCloseArea()
      ENDIF
      dbSelectAr( PES )
      dbSkip()
   ENDDO


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


// + EOF: fopto_3i.prg
// +
