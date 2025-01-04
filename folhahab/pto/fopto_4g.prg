// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4g.prg Escala Revezamento
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



#include "INKEY.CH"
#include "BOX.CH"

FUNCTION fopto_4g()

// Pegando Eventos
   aEVED := {}
   aEVEC := {}
   aEVEB := {}
   PegFeriados()


   PEGPTOHOR( "XX", .T., .F. )   // Verifica indices

   cPE := "PE" + ANOMESW
   CHECKCRI( cPE, "FOPTOREV", "GRUPO+DTOS(DATA)" )

   cANT := "PE" + Right( StrZero( nANOANT, 4 ), 2 ) + StrZero( NMESANT, 2 )
   CHECKCRI( cANT, "FOPTOREV", "GRUPO+DTOS(DATA)" )


   PADRAO( cPE, cPE, "' '+mGRUPO+' '+STR(mHORARIO,8)+' '+DTOC(mDATA)+' '+PADR(CDIA(mDATA),8)+' '+mCODREV+' '+STR(mENTREV,  6, 2)+' '+STR(mALIREV,  6, 2)+' '+STR(mALSREV,  6, 2)+' '+STR(mSAIREV,  6, 2)", "mGRUPO+DTOS(mDATA)", ;
      "FOPTO_4G - Escala Revezamento", ;
      "Gr Data     Horario", ;
      {|| iFOPTO4G() }, {|| tFOPTO4G() }, {|| gFOPTO4G() }, {|| ALLTRUE() },, 2,,, zTIPVID )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iFOPTO4G()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC iFOPTO4G

   dINI   := zdataini
   dFIM   := zdatafim
   mGRUPO := "  "
// mCODREV:="  "
   @ 23, 00 clea
   @ 24, 00 clea
   @ 23, 00 SAY 'Digite o Codigo da Escala'
   @ 24, 00 SAY 'Digite o Periodo '
   @ 23, 40 GET mGRUPO
// @ 23, 60 get mCODREV WHEN EMPTY(mGRUPO)
   @ 24, 40 GET dINI
   @ 24, 50 GET dFIM
   IF !READCUR()
      RETU .F.
   ENDIF

// if ! empty( mCODREV )
// xFOPTO4G()
// endif

   nSEQ := 1
   mMAX := 0
   IF !NETUSE( cANT )
      RETU aRETU
   ENDIF
   dbGoTop()
   IF dbSeek( mGRUPO + DToS( dINI - 1 ) )
      nSEQ := SEQ
      nSEQ := nSEQ + 1
   ENDIF
   dbCloseArea()

   mds( "Confirme Sequencia Incial" )
   @ 24, 40 GET nSEQ
   READCUR()


   IF !netuse( "escalpad" )
      RETU .F.
   ENDIF
   dbGoTop()
   dbSeek( mGRUPO )
   WHILE mGRUPO = GRUPO .AND. !Eof()
      mMAX := mMAX + 1
      dbSkip()
   ENDDO
   dbCloseArea()


// N„o Grava o ultimo por que a funcao padrao fara
   FOR W := dINI TO dFIM
      mDATA  := W
      mCHAVE := mGRUPO + DToS( mDATA )
      IF mMAX > 0
         IF nSEQ > mMAX
            nSEQ := 1
         ENDIF
         igualvars( "ESCALPAD", "ESCALPAD", mGRUPO + Str( nSEQ, 2 ) )
         xFOPTO4G()
         mSEQ := nSEQ  // gravo seq atual
         nSEQ := nSEQ + 1  // pego mais 1 para a proxima
      ENDIF
      mDATA := W
      EscPadCor()
      IF W <> dfim   // dfim na funcao padrao
         IF NOVOREG( cPE, cPE, mCHAVE )
            IF VIDEO = 'S'
               AAdd( aPAD1, NIL )
               AAdd( aPAD2, NIL )
               POS  := Len( aPAD1 )
               POSW := 1
               IF POS > 1
                  FOR X := 1 TO POS - 1
                     mDARE := aPAD2[ X ]
                     IF mCHAVE <= mDARE  // IF mGRUPO+DTOS(DATA)<=mDARE
                        EXIT
                     ENDIF
                  NEXT
                  POSW := X
               ENDIF
               AIns( aPAD1, POSW )
               AIns( aPAD2, POSW )
               aPAD1[ POSW ] = ' ' + mGRUPO + ' ' + DToC( mDATA ) + ' ' + PadR( CDIA( mDATA ), 8 ) + ' ' + mCODREV + ' ' + Str( mENTREV, 6, 2 ) + ' ' + Str( mALIREV, 6, 2 ) + ' ' + Str( mALSREV, 6, 2 ) + ' ' + Str( mSAIREV, 6, 2 )
               aPAD2[ POSW ] = mGRUPO + DToS( mDATA )
               pPAD := POSW
            ENDIF
         ENDIF
      ENDIF
   NEXT X
   mDATA  := dFIM
   mCHAVE := mGRUPO + DToS( dFIM )
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO4G()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION gFOPTO4G

   @  5, 9  SAY mGRUPO
   @  5, 19 SAY mDATA
   IF !Empty( mDATA )
      @  5, 28 SAY CDIA( mDATA )
   ENDIF
   @  6, 9  GET mSEQ
   @  8, 12 GET mCODREV  VALID xFOPTO4G( .T. ) .AND. EscPadCor()
   @  8, 15 SAY mHORARIO
   @  8, 25 SAY mENTREV  PICT '999.99'
   @  8, 32 SAY mALIREV  PICT '999.99'
   @  8, 39 SAY mALSREV  PICT '999.99'
   @  8, 46 SAY mSAIREV  PICT '999.99'
   @  8, 53 GET mVIRADA  PICT "!"                              VALID mVIRADA $ " SN"
   @  8, 60 GET mFOLGASN PICT "!"                              VALID mFOLGASN $ " SN"
   @  8, 65 GET mCODADC
   @  8, 72 GET MBCOSN   PICT "!"                              VALID mBCOSN $ " SNF"
   READCUR()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO4G()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC tFOPTO4G

// Desenha a Tela
   hb_DispBox( 4, 0, 23, 79, B_DOUBLE + " " )
   @  5, 2  SAY "Grupo:     Data:"
   @  6, 2  SAY "Seq"
   @  7, 15 SAY "Horario   Entrada   Almo‡o     Saida Virada Folga CodAdc BcoHrs"
   @  8, 2  SAY "Hor rio :"
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function xFOPTO4G()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION xFOPTO4G( lEXIBE )

   LOCAL cDBFUSO := Alias()

   IF ValType( lEXIBE ) # "L"
      lEXIBE := .F.
   ENDIF
   IF Empty( mCODREV )
      RETU .T.
   ENDIF
   aRETU := PEGPTOHOR( mCODREV )
   IF aRETU[ 6 ]
      mENTREV  := aRETU[ 1 ]
      mALIREV  := aRETU[ 2 ]
      mALSREV  := aRETU[ 3 ]
      mSAIREV  := aRETU[ 4 ]
      mVIRADA  := aRETU[ 5 ]
      mFOLGASN := aRETU[ 7 ]
      mHORARIO := aRETU[ 8 ]
      IF lEXIBE
         @  8, 15 SAY mHORARIO
         @  8, 25 SAY mENTREV  PICT '999.99'
         @  8, 32 SAY mALIREV  PICT '999.99'
         @  8, 39 SAY mALSREV  PICT '999.99'
         @  8, 46 SAY mSAIREV  PICT '999.99'
         @  8, 53 SAY mVIRADA
         @  8, 60 SAY mFOLGASN
      ENDIF
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function EscPadCor()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION EscPadCor()

   DO CASE
   CASE mCODREV = "SA" .AND. DoW( mDATA ) <> 7
      ALERTX( "Codigo SA sem ser sabado " + DToC( mdata ) )
      mCODREV := ""
   CASE mCODREV = "DO" .AND. DoW( mDATA ) <> 1
      ALERTX( " Codigo DO sem ser domingo " + DToC( mdata ) )
      mCODREV := ""
   CASE mCODREV = "FE" .AND. AScan( aEVED, Str( Day( mDATA ), 2 ) + Str( Month( mDATA ), 2 ) ) = 0
      ALERTX( " Codigo FE sem feriado cadastrado " + DToC( mdata ) )
      mCODREV := ""
   ENDCASE

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGPTOHOR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC PEGPTOHOR( cCOD, lOPEN, lMES )

   LOCAL aRETU := { 0, 0, 0, 0, " ", .F., " ", 0, "" }
   LOCAL cDBF  := Alias()

// entrada almoco retorno saida virada
   IF Empty( cCOD )
      RETU aRETU
   ENDIF
   IF ValType( lOPEN ) # "L"
      lOPEN := .T.
   ENDIF
   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF
   IF lOPEN
      IF !netuse( "foptohor" )
         RETU aRETU
      ENDIF
   ELSE
      dbSelectAr( "FOPTOHOR" )
   ENDIF
   IF ordCount() < 2
      dbCloseArea()
      FErase( "FOPTOHOR.CDX" )   // Temporariarmente recriando
      INFOR( "FOPTOHOR", { "NUMERO", "CODIGO" }, { "FOPTOHOR", "FOPTOHOR" }, .F., { "FOPTOHOR", "FOPTOHOR2" }, .T. )
      IF !netuse( "foptohor" )
         RETU aRETU
      ENDIF
   ENDIF
   IF ValType( cCOD ) = "N"
      dbSetOrder( 1 )  // Busca codigo numerico
   ELSE
      dbSetOrder( 2 )  // Busca codigo reduzido caracter
   ENDIF
   dbGoTop()
   IF dbSeek( cCOD )
      aRETU[ 1 ] := ENT
      aRETU[ 2 ] := ALMI
      aRETU[ 3 ] := ALMF
      aRETU[ 4 ] := SAI
      aRETU[ 5 ] := VIRADA
      aRETU[ 6 ] := .T.
      aRETU[ 7 ] := FOLGASN
      aRETU[ 8 ] := NUMERO
      aRETU[ 9 ] := CODIGO
   ENDIF
   IF lOPEN
      dbCloseArea()
   ENDIF
   IF !aRETU[ 6 ] .AND. lMES
      ALERTX( "Ajuste de Horario: " + cCOD + " Nao Cadastrado" )
   ENDIF
   IF !Empty( cDBF )
      dbSelectAr( cDBF )
   ENDIF
   RETU aRETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fopto4gpad()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC fopto4gpad

   PADRAO( "escalpad", "escalpad", "mGRUPO+' '+STR(mHORARIO,8)+' '+str(mSEQ,2)+' '+mCODREV+' '+STR(mENTREV,  6, 2)+' '+STR(mALIREV,  6, 2)+' '+STR(mALSREV,  6, 2)+' '+STR(mSAIREV,  6, 2)+' '+mFOLGASN", "mGRUPO+STR(mSEQ,2)", ;
      "FOPTO_4G - Cadastro de Escala Revezamento", ;
      "Gr Seq Horario", ;
      {|| iPTO4GPAD() }, {|| tFOPTO4G() }, {|| gFOPTO4G() }, {|| ALLTRUE() },, 2 )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fopto4gapa()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC fopto4gapa()

   mESCALA := Space( 2 )
   @ 24, 00 SAY "Codigo da Escala"
   @ 24, 40 GET mESCALA
   IF !READCUR()
      RETU
   ENDIF
   cPE := "PE" + ANOMESW
   CHECKCRI( cPE, "FOPTOREV", "GRUPO+DTOS(DATA)" )
   IF !netuse( cPE )
      RETU .F.
   ENDIF
   dbGoTop()
   dbSeek( mESCALA )
   WHILE GRUPO = mESCALA .AND. !Eof()
      netrecdel()
      dbSkip()
   ENDDO
   dbCloseAll()


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iPTO4GPAD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION iPTO4GPAD

   MDS( 'Digite o Codigo da Escala/Seq' )
   @ 24, 40 GET mGRUPO
   @ 24, 44 GET mSEQ
   READCUR()
   mCHAVE := mGRUPO + Str( mSEQ, 2 )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function horpadtoesc()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION horpadtoesc

   CABE2( 'Horario Padrao Para Escala' )
   mHORPAD := "  "
   mESCDES := "  "
   mds( "Horario Padrao:          Escala:" )
   @ 24, 18 GET mHORPAD
   @ 24, 34 GET mESCDES
   IF !READCUR()
      RETU .F.
   ENDIF

   IF !NETUSE( "FO_RELHR" )
      dbCloseAll()
      RETU .F.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      IF HORREF = mHORPAD
         netreclock()
         FIELD->HORREF := ""
         FIELD->HFOL00 := "S"
         FIELD->GRUPO  := mESCDES
         dbUnlock()
      ENDIF
      dbSkip()
   ENDDO
   dbCloseAll()

   RETURN .T.







// + EOF: fopto_4g.prg
// +
