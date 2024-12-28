// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_3f.prg
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

IF !MDL( 'FOPTO_3F - Listagem Totais' )
RETU
ENDIF

PAG  := 1
DIAX := Date()
aTOT := Array( 24 )
AFill( aTOT, 0 )

cTIP := "C"
cSIN := "S"
cFUN := "S"
@ 15, 00 SAY "(C)ompetencia (A)anual (S)emanal"
@ 16, 00 SAY "Sintetico   (S/N)"
@ 17, 00 SAY "Funcionario (S/N)"
@ 15, 40 GET cTIP                               PICT "!" VALID c $ "CAS"
@ 15, 40 GET cSIN                               PICT "!" VALID c $ "SN"
@ 15, 40 GET cFUN                               PICT "!" VALID c $ "SN"
IF !READCUR()
RETU .F.
ENDIF

lSINT := cSIN = "S"
lFUNC := cFUN = "S"

cPT := "PT" + ANOMESW
IF cTIP = "A"
cPT := "FO_PTT"
ENDIF
IF cTIP = "S"
cPT := cPT := "PS" + ANOMESW
ENDIF

PRIV mMES
PRIV mANO
mMES := MESTRAB
mANO := ANOUSO

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


IF !NETUSE( cPT )
dbCloseAll()
RETU
ENDIF

LISTARUE( {| X | FOPTO3F( X ) } )

RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO3F()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FOPTO3F

   PARA COMPARE

   dbSelectAr( PES )
   dbGoTop()
   WHILE !Eof()
      IF &COMPARE
         VIDEO()
         PETELA( 6 )
         mNUMERO := NUMERO
         mNOME   := NOME
         dbSelectAr( cPT )
         dbGoTop()
         IF cTIP = "C"
            dbSeek( mNUMERO )
         ELSE
            dbSeek( Str( mNUMERO, 8 ) )
         ENDIF
         WHILE mNUMERO = NUMERO .AND. !Eof()
            aCTA := { CTA01, CTA02, CTA03, CTA04, CTA05, CTA06, CTA07, CTA08, ;
               CTA09, CTA10, CTA11, CTA12, CTA13, CTA14, CTA15, CTA16, ;
               CTA17, CTA18, CTA19, CTA20, CTA21, CTA22, CTA23, CTA24 }
            COL := 25
            IF lFUNC
               IMPRESSORA()
               IF PRow() > 50 .OR. PAG = 1
                  CABEC( 'Relacao Totais',,,, NOMSETOR )
                  @ PRow() + 1, 0 SAY IMPSTR( cIMPCOM )
                  FOR X := 1 TO 16
                     @ PRow(), 21 + X * 7 SAY StrZero( X, 3 )
                  NEXT X
               ENDIF
               IF cTIP = "C"
                  @ PRow() + 1, 0 SAY IMPSTR( cIMPCOM )
                  @ PRow(), 0   SAY Str( mNUMERO, 8 ) + '-' + Left( mNOME, 15 )
               ELSE
                  @ PRow() + 1, 0 SAY IMPSTR( cIMPCOM )
                  @ PRow(), 0   SAY Str( mNUMERO, 8 )
                  IF cTIP = "A"
                     @ PRow(), 9 SAY Str( MES )
                     @ PRow(), 12 SAY Str( ANO )
                  ELSE
                     @ PRow(), 9 SAY SEMINI
                     @ PRow(), 12 SAY SEMFIM
                  ENDIF
               ENDIF
               FOR X := 1 TO 16
                  IF !Empty( aCTA[ X ] )
                     @ PRow(), 18 + ( X * 7 ) SAY aCTA[ X ] PICT '###.##'
                  ENDIF
               NEXT X
            ENDIF
            FOR X := 1 TO 16
               IF !Empty( aCTA[ X ] )
                  aTOT[ X ] += aCTA[ X ]
               ENDIF
            NEXT X
            dbSelectAr( cpt )
            dbSkip()
         ENDDO
      ENDIF
      dbSelectAr( PES )
      dbSkip()
   ENDDO

   IF lSINT
      IMPRESSORA()
      IF PAG > 1
         @ PRow() + 2, 0 SAY repl( '=', 132 )
      ELSE
         CABEC( 'Relacao Totais',,, "", NOMSETOR )
         @ PRow() + 1, 0 SAY IMPSTR( cIMPCOM )
         @ PRow() + 1, 0 SAY repl( '-', 132 )
      ENDIF
      @ PRow() + 1, 0 SAY "Totais"
      FOR X := 1 TO 8
         @ PRow(), 16 + X * 12 SAY StrZero( X, 3 )
      NEXT X
      @ PRow() + 1, 0 SAY ""
      FOR X := 1 TO 8
         IF !Empty( aTOT[ X ] )
            @ PRow(), 08 + X * 12 SAY aTOT[ X ] PICT '@E 9999,999.99'
         ENDIF
      NEXT X
      @ PRow() + 1, 0 SAY repl( ".", 132 )
      @ PRow() + 1, 0 SAY ""
      FOR X := 9 TO 16
         @ PRow(), 16 + ( ( X - 8 ) * 12 ) SAY StrZero( X, 3 )
      NEXT X
      @ PRow() + 1, 0 SAY ""
      FOR X := 9 TO 16
         IF !Empty( aTOT[ X ] )
            @ PRow(), 08 + ( ( X - 8 ) * 12 ) SAY aTOT[ X ] PICT '@E 9999,999.99'
         ENDIF
      NEXT X
   ENDIF
   IF PAG > 1
      IMPFOL()
   ENDIF


// + EOF: fopto_3f.prg
// +
