// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_22.prg
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
// +    Documentado em 27-Dez-2024 as  9:32 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


// //#INCLUDE "COMANDO.CH"
#include "INKEY.CH"

PEGPTOHOR( "XX", .T., .F. )   // Verifica indices

CABE2( 'FOPTO_22 - Alterar o Ponto Diario' )

aCODCTA := PEGCX()

cPN := "PN" + ANOMESW
cPT := "PT" + ANOMESW
cPD := "PD" + ANOMESW
cPP := "PP" + ANOMESW
cPA := "PA" + ANOMESW
cPS := "PS" + ANOMESW

// testa criacao portaria evitar erros
CHECKCRI( cPP, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
// testa criacao refeitorio evitar erros
CHECKCRI( cPA, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )


IF !NETUSE( cPN )
RETU
ENDIF
FILTRO := ''
FI     := Trim( FILTRO )
FILTRO := FILTRO( FI )
SET FILTER TO &FILTRO

IF !NETUSE( cPD )
dbCloseAll()
RETU
ENDIF

IF !NETUSE( cPT )
dbCloseAll()
RETU
ENDIF

IF !NETUSE( cPS )
dbCloseAll()
RETU
ENDIF

IF !NETUSE( cPP )
dbCloseAll()
RETU
ENDIF

IF !NETUSE( cPA )
dbCloseAll()
RETU
ENDIF
IF !netuse( "fo_ptt" )
dbCloseAll()
ENDIF

// clear typeahead
hb_keyClear()
KEYBOARD " "
// sele 1
dbSelectAr( cPN )
dbGoTop()
@  3, 0 SAY "   Num   Dia    Cod SOD  Ent  Almoco    Saida Turno Ent  Almoco     Saida V F BC"
DECLARE CAMPOS[ 1 ]
CAMPOS[ 1 ] = 'STR(NUMERO,6)+" "+LEFT(CDIA(DATA),3)+","+LEFT(DTOC(DATA),5)+" "+COD+" "+SOD+" "+STR(ENT,5,2)+" "+STR(ALS,5,2)+" "+STR(ALE,5,2)+" "+STR(SAI,5,2)+" "+CODREV+" "+STR(ENTREV,  5, 2)+" "+STR(ALIREV,5, 2)+" "+STR(ALSREV,5,2)+" "+STR(SAIREV,5,2)+" "+VIRADA+" "+FOLSN+" "+BCOSN'
dbEdit( 4, 0, 24, 79, CAMPOS, "DIMP22", .T., "", "", "", "", "" )
dbCloseAll()
// clear typeahead
hb_keyClear()
KEYBOARD " "
RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DIMP22()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION DIMP22

   PARAMETERS MODO

   KEY := LastKey()
   DO CASE
   CASE KEY = K_DEL
      IF MDG( "Deseja realmente Apagar" )
         netrecdel()
         dbUnlock()
      ENDIF
      dbSkip()
      hb_keyPut( K_PGUP )
      hb_keyPut( K_PGDN )
   CASE KEY = 13
      cTELA := SaveScreen( 03, 0, 24, 79 )
      SetCursor( 1 )
      mNUMERO  := NUMERO
      mDIA     := Day( DATA )
      mDATA    := DATA
      mHORARIO := HORARIO
      COL      := 3
      CLSBOX( 03, 0, 24, 79 )
      @  3, 2  SAY "Num       Cod SOD  Ent  Almoco    Saida Ý Turno Ent    Almoco     Saida  V FO"
      @  4, 1  SAY mNUMERO                                                                                                 PICT '99999999'
      @  4, 47 SAY ENTREV                                                                                                  PICT '999.99'
      @  4, 54 SAY ALIREV                                                                                                  PICT '999.99'
      @  4, 61 SAY ALSREV                                                                                                  PICT '999.99'
      @  4, 68 SAY SAIREV                                                                                                  PICT '999.99'
      @  4, 76 SAY virada
      @  4, 78 SAY folsn
      @ 05, 1  SAY "Extra SNVT"
      @ 05, 12 SAY "Almoco"
      @ 05, 20 SAY "Red.Jorn."
      @ 05, 30 SAY "Bco Horas"
      @ 06, 02 SAY "01-" + spac( 7 ) + "02-" + spac( 7 ) + "03-" + spac( 7 ) + "04-" + spac( 7 ) + "05-" + spac( 7 ) + "06-" + spac( 7 ) + "07-" + spac( 7 ) + "08-"
      FOR X := 1 TO 8
         @ 06, ( X * 10 ) - 4 SAY aCODCTA[ X ] PICT "999"
      NEXT X
      @ 07, 02 SAY "09-" + spac( 7 ) + "10-" + spac( 7 ) + "11-" + spac( 7 ) + "12-" + spac( 7 ) + "13-" + spac( 7 ) + "14-" + spac( 7 ) + "15-" + spac( 7 ) + "16-"
      FOR X := 1 TO 8
         @ 07, ( X * 10 ) - 4 SAY aCODCTA[ X + 8 ] PICT "999"
      NEXT X
      @ 08, 00 SAY " Ý Totais do dia" + " Ý " + DToC( mDATA ) + " " + CDIA( mDATA ) + " Horario:" + Str( mHORARIO, 8 )
      FOR X := 1 TO 8
         cVAR := "CTA" + StrZero( X, 2 )
         @ 09, ( X * 10 ) - 7 SAY &cVAR.
      NEXT X
      FOR X := 1 TO 8
         cVAR := "CTA" + StrZero( X + 8, 2 )
         @ 10, ( X * 10 ) - 7 SAY &cVAR.
      NEXT X
      @ 11, 00 SAY " Ý Totais das Contas"
      // Totais
      dbSelectAr( cPT )
      dbGoTop()
      IF !dbSeek( mNUMERO )
         @ 11, 16 SAY 'Nao encontrado os Totais'
      ELSE
         FOR X := 1 TO 8
            cVAR := "CTA" + StrZero( X, 2 )
            @ 12, ( X * 10 ) - 8 SAY &cVAR.
         NEXT X
         FOR X := 1 TO 8
            cVAR := "CTA" + StrZero( X + 8, 2 )
            @ 13, ( X * 10 ) - 8 SAY &cVAR.
         NEXT X
      ENDIF
      // anual
      @ 14, 00 SAY " Ý Totais Anuais"
      aTOTANO := PEGTOTANO( mNUMERO, .F. )
      FOR X := 1 TO 8
         @ 15, ( X * 10 ) - 8 SAY aTOTANO[ X ] PICT '9999.99'
      NEXT X
      FOR X := 1 TO 8
         @ 16, ( X * 10 ) - 8 SAY aTOTANO[ X + 8 ] PICT '9999.99'
      NEXT X
      // Semana
      IF DoW( mDATA ) = 1
         @ 17, 00 SAY " Ý Totais da Semana"
         dbSelectAr( cPS )
         dbGoTop()
         IF dbSeek( Str( mNUMERO, 8 ) + DToS( mDATA ) )
            FOR X := 1 TO 8
               cVAR := "CTA" + StrZero( X, 2 )
               @ 18, ( X * 10 ) - 8 SAY &cVAR.
            NEXT X
            FOR X := 1 TO 8
               cVAR := "CTA" + StrZero( X + 8, 2 )
               @ 19, ( X * 10 ) - 8 SAY &cVAR.
            NEXT X
         ENDIF
      ENDIF


      nSALDO := pegsaldobco( mNUMERO, nANOANT, nMESANT, .T. )
      @  5, 49 SAY StrZero( nMESANT, 2 ) + "/" + StrZero( nANOANT, 4 )
      @  5, 57 SAY nSALDO                                    PICT "9999.99"



      verpassagens( mNUMERO, mDATA, .F., .T. )
      dbSelectAr( cPN )
      netreclock()
      @  4, 13 SAY COD
      @  4, 16 SAY sod
      @  4, 19 SAY ENT
      @  4, 25 SAY ALS
      @  4, 31 SAY ALE
      @  4, 37 SAY SAI
      @  4, 45 SAY CODREV
      IF ZFECHADO = "S"
         @  4, 76 SAY virada
         @  4, 78 SAY FOLSN
         @  5, 06 SAY EXTSN
         @  5, 18 SAY ALMOCO
         @  5, 28 SAY REDSN
         @  5, 39 SAY BCOSN
         @  5, 41 SAY BCOHRS PICT '9999.99'
         Inkey( 0 )
      ELSE
         @  4, 76 GET virada PICT "!"       VALID virada $ "SNV "
         @  4, 78 GET FOLSN  PICT "!"       VALID FOLSN $ "SNVM "
         @  5, 06 GET EXTSN  PICT "!"       VALID EXTSN $ "SNVTZA5 "
         @  5, 18 GET ALMOCO PICT "!"       VALID ALMOCO $ "ABCDESN "
         @  5, 28 GET REDSN  PICT "!"       VALID REDSN $ "SN "
         @  5, 39 GET BCOSN  PICT "!"       VALID BCOSN $ "SNF "
         @  5, 41 GET BCOHRS PICT '9999.99'
         READCUR()
      ENDIF
      RestScreen( 3, 0, 24, 79, cTELA )
      SetCursor( 0 )
      dbUnlock()
   CASE KEY = 27
      RETURN 0
   CASE KEY = 2  // BUSCA DADOS
      NUM    := NUMERO
      DIX    := DATA
      aSALVA := SALVAA()
      @  3, 16 SAY "Digite o N£mero do Funcionario :"
      @  5, 16 SAY "Digite a Data" + spac( 18 ) + ":"
      @ 03, 50 GET NUM                                PICT '######'
      @ 05, 50 GET DIX
      READCUR()
      BUSCA := Str( NUM, 8 ) + DToS( DIX )
      REG   := RecNo()
      dbGoTop()
      IF !dbSeek( BUSCA )
         @ 02, 01 CLEA TO 06, 78
         @ 04, 16 SAY 'Nao encontrado'
         Inkey( 2 )
         dbGoto( REG )
      ENDIF
      RESTAA( aSALVA )
      RETURN 2
   ENDCASE

   RETURN 1


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO22()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FOPTO22

   IF Empty( CODREV )
      field->ENTREV := 0
      field->ALIREV := 0
      field->ALSREV := 0
      field->SAIREV := 0
   ELSE
      aRETU := PEGPTOHOR( CODREV, .T., .T. )
      dbSelectAr( cPN )
      IF aRETU[ 6 ]
         field->ENTREV  := aRETU[ 1 ]
         field->ALIREV  := aRETU[ 2 ]
         field->ALSREV  := aRETU[ 3 ]
         field->SAIREV  := aRETU[ 4 ]
         field->VIRADA  := aRETU[ 5 ]
         field->FOLSN   := aRETU[ 7 ]
         field->HORARIO := Aretu[ 8 ]
      ENDIF
   ENDIF
   @  4, 47 SAY ENTREV PICT '999.99'
   @  4, 54 SAY ALIREV PICT '999.99'
   @  4, 61 SAY ALSREV PICT '999.99'
   @  4, 68 SAY SAIREV PICT '999.99'
   @  4, 76 SAY virada
   @  4, 78 SAY folsn

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PegTotAno()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC PegTotAno( nNUMUSO, lOpen )

   aTOTANO := Array( 24 )
   AFill( aTOTANO, 0 )
   IF lOPEN
      IF !NETUSE( "FO_PTT" )
         RETU aTOTANO
      ENDIF
   ENDIF
   dbSelectAr( "FO_PTT" )
   dbGoTop()
   dbSeek( Str( nNUMUSO, 8 ) + Str( ANOUSO, 4 ) )
   WHILE nNUMUSO = NUMERO .AND. MES < MESTRAB .AND. !Eof()
      FOR X := 1 TO 24
         cVAR := "CTA" + StrZero( X, 2 )
         aTOTANO[ X ] += &cVAR.
      NEXT X
      dbSkip()
   ENDDO
   IF lOPEN
      dbCloseArea()
   ENDIF

   RETURN aTOTANO


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function VerPassagens()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION VerPassagens( nNUMERO, dDATA, lOPEN, lMES, mPIS )

   LOCAL X, LIN, COL, nPASSAGENS := 0

   IF ValType( mPIS ) <> 'C'
      OBTER( PES,, mNUMERO, "PIS" )
   ENDIF
   IF lOPEN
      cPD := "PD" + ANOMESW
      cPP := "PP" + ANOMESW
      cPA := "PA" + ANOMESW
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
   ENDIF
   LIN := 20
   FOR x := 1 TO 3
      COL := 12
      DO CASE
      CASE x = 1
         @ LIN, 01 SAY "Passagens :"
         dbSelectAr( cPD )
      CASE X = 2
         @ LIN, 01 SAY "Portaria  :"
         dbSelectAr( cPp )
      CASE X = 3
         @ LIN, 01 SAY "Refeitorio:"
         dbSelectAr( cPa )
      ENDCASE
      dbGoTop()
      dbSeek( Str( nNUMERO, 8 ) + DToS( dDATA ) )
      IF NUMERO <> nNUMERO
         @ LIN, 12 SAY 'Sem Passagens'
      ELSE
         WHILE DATA = dDATA .AND. NUMERO = nNUMERO .AND. !Eof()
            @ LIN, COL     SAY HORA
            @ lin, Col() + 1 SAY TIPOM + TIPOR + IF( X = 1, RELOGIO, "" )
            IF X <> 1 .OR. Empty( mPIS ) .OR. PIS = mPIS
               IF X = 1 .AND. TIPOM <> 'D'
                  nPASSAGENS++
               ENDIF
               col += IF( X = 1, 13, 9 )
               IF COL > 75
                  LIN++
                  COL := 1
               ENDIF
            ENDIF
            dbSkip()
         ENDDO
      ENDIF
      LIN++
   NEXT x
   IF lOPEN
      dbSelectAr( cPD )
      dbCloseArea()
      dbSelectAr( cPp )
      dbCloseArea()
      dbSelectAr( cPA )
      dbCloseArea()
   ENDIF
   IF ValType( lMES ) = "L" .AND. lMES
      IF nPASSAGENS > 1 .AND. Int( nPASSAGENS / 2 ) <> nPASSAGENS / 2
         ALERTX( "Passagens impares descartar desnecessarias" )
      ENDIF
   ENDIF

   RETURN nPASSAGENS



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function temalmoco()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION temalmoco( nNUMERO, dDATA, lOPEN, aRELFXREF )

   LOCAL nALMOCO, cALIAS, nFX, nFXFIM

   cALIAS  := Alias()
   nALMOCO := 0
   nFXFIM  := Len( aRELFXREF )
   IF lOPEN
      cPA := "PA" + ANOMESW
      IF !NETUSE( cPA )
         dbCloseAll()
         RETURN 0
      ENDIF
   ENDIF
   dbSelectAr( cPa )
   dbGoTop()
   dbSeek( Str( nNUMERO, 8 ) + DToS( dDATA ) )
   WHILE DATA = dDATA .AND. NUMERO = nNUMERO .AND. !Eof()
      FOR nFX := 1 TO nFXFIM
         IF TIPOM <> 'S' .AND. AllTrim( RELOGIO ) = AllTrim( aRELFXREF[ nFX, 1 ] ) .AND. HORA >= aRELFXREF[ nFX, 2 ] .AND. HORA <= aRELFXREF[ nFX, 3 ]
            nALMOCO++
         ENDIF
      NEXT X
      dbSkip()
   ENDDO
   IF lOPEN
      dbSelectAr( cPA )
      dbCloseArea()
   ENDIF
   IF !Empty( cALIAS )
      dbSelectAr( cALIAS )
   ENDIF

   RETURN nALMOCO



// + EOF: fopto_22.prg
// +
