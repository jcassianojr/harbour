// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4q.prg Requisicao de Horas
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

FUNCTION fopto_4q()

   cBH := if( lSECBCO, "BK", "BH" ) + ANOMESW

   CHECKCRI( cBH, "BCOREQ", "REQUISI" )

   PADRAO( cBH, cBH, "' '+STR(mREQUISI,8)+' '+STR(mNUMERO,8)+' '+DTOC(mDATA)+' '+STR(mHORAS,6,2)+' '+mTIPO+' '+IF(EMPTY(mIMP),' ','*')", "mREQUISI", ;
      "FOPTO_4Q - Requisicao de Horas", ;
      "Requisi  Numero   Data     Horas T", ;
      {|| PEGCHAVE( "mREQUISI", ULTIMOREG( cBH, "REQUISI", .T. ), "Requisao:" ) }, {|| tFOPTO4Q() }, {|| gFOPTO4Q() }, {|| ALLTRUE() },, 2,,, zTIPVID )

   FOPTO4Q01()

   RETURN


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO4Q01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FOPTO4Q01

   IF MDG( "Zerar Saldo da Competencia - Recomendado" )
      FOPTO4Q02( MES, ANOUSO )
   ENDIF
   aRES  := {}
   aFUN  := {}
   nrMES := MES
   nbMES := MES
   nbANO := ANOUSO
   nbMES--
   IF nbMES = 0
      nbMES := 12
      nbANO--
   ENDIF

   MDS( "Calculando Creditos Debitos" )
   WHILE !NETUSE( cBH )
   ENDDO
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "numero" )
   ordSetFocus( "temp" )
// zei_fort(nLASTREC,,,1)

   dbGoTop()
   WHILE !Eof()
      @ 24, 60 SAY NUMERO
      mNUMERO := NUMERO
      nCRE    := 0
      nDEB    := 0
      nDIACRE := 0
      nDIADEB := 0
      WHILE mNUMERO = NUMERO .AND. !Eof()
         IF TIPO = "D"
            nDEB    += HORAS
            nDIADEB += DIAS
         ELSE
            nCRE    += HORAS
            nDIACRE += DIAS
         ENDIF
         dbSkip()
      ENDDO
      AAdd( aFUN, mNUMERO )
      AAdd( aRES, { mNUMERO, nCRE, nDEB, 0, .T., nDIACRE, nDIADEB, 0 } )
   ENDDO
   dbCloseArea()

   MDS( "Aguarde Lancando Saldo" )   // Nao Teve requisicao mas tem saldo
   WHILE !NETUSE( if( lSECBCO, "BCOBAK", "BCOHRS" ) )
   ENDDO
   dbGoTop()
   WHILE !Eof()
      @ 24, 60 SAY NUMERO
      nPOS := AScan( aFUN, NUMERO )
      IF nPOS = 0
         AAdd( aFUN, NUMERO )
         AAdd( aRES, { NUMERO, 0, 0, 0, .F., 0, 0, 0 } )
      ENDIF
      dbSkip()
   ENDDO
   FOR W := 1 TO Len( aRES )
      @ 24, 40 SAY aRES[ W, 1 ]
      eCHAVE := Str( aRES[ W, 1 ], 8 ) + Str( nbANO, 4 ) + Str( nBMES, 2 )
      dbGoTop()
      IF dbSeek( eCHAVE )  // Saldo Anterior
         aRES[ W, 4 ] := SALDO
         aRES[ W, 8 ] := DIASAL
      ENDIF
      eCHAVE := Str( aRES[ W, 1 ], 8 ) + Str( ANOUSO, 4 ) + Str( nrMES, 2 )
      dbGoTop()
      IF !dbSeek( eCHAVE )
         netrecapp()
         field->NUMERO := aRES[ W, 1 ]
         field->ANO    := ANOUSO
         field->MES    := nrMES
      ELSE
         netreclock()
      ENDIF
      field->CREDITO := aRES[ W, 2 ]
      field->DEBITO  := aRES[ W, 3 ]
      field->SALANT  := aRES[ W, 4 ]
      field->SALDO   := SALANT + CREDITO - DEBITO
      field->DIACRE  := aRES[ W, 6 ]
      field->DIADEB  := aRES[ W, 7 ]
      field->DIAANT  := aRES[ W, 8 ]
      field->DIASAL  := DIAANT + DIACRE - DIADEB
      dbUnlock()
   NEXT W
   dbCloseArea()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO4Q02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOPTO4Q02( nMES, nANO )   // Apagar Periodo Bco Horas

   IF ValType( nMES ) # "N" .OR. ValType( nANO ) # "N"
      nMES := MES
      nANO := ANOUSO
      MDS( 'Confirme a Competecia' )
      @ 24, 40 GET nMES
      @ 24, 50 GET nANO
      IF !READCUR()
         RETU .F.
      ENDIF
   ENDIF
   WHILE !netuse( if( lSECBCO, "BCOBAK", "BCOHRS" ) )
   ENDDO
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netrecdel() }, {|| ANO = nANO .AND. MES = nMES }, {|| zei_fort( nLASTREC,,, 1 ) } )
   dbCloseArea()
   NETPACK( if( lSECBCO, "BCOBAK", "BCOHRS" ) )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO4Q()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gFOPTO4Q

   @  6, 2  SAY mREQUISI PICTURE '99999999'
   @  6, 11 GET mNUMERO  PICTURE '99999999'
   @  6, 20 GET mDATA
   @  6, 29 GET mHORAS   PICTURE '999.99'
   @  6, 36 GET mDIAS    PICTURE '999.99'
   @  6, 45 GET mTIPO    VALID mTIPO $ "CD "
   @  8, 2  GET mOBS
   READCUR()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO4Q()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC tFOPTO4Q

   hb_DispBox( 4, 0, 23, 79, B_DOUBLE + " " )
   @  5, 2  SAY "Requisi  Numero   Data     Horas  Dias  T  C-Credito"
   @  6, 50 SAY "D-Debito"
   @  7, 2  SAY "Obs:"
   RETU .T.


// + EOF: fopto_4q.prg
// +
