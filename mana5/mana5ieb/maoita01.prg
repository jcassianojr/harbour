// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : maoita01.prg
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

// Modo de Trabalho no V¡deo
MDI( " Ý Atualiza‡„o de Pedidos" )

IF !MDG( "Atualizar Pedidos" )
RETU .F.
ENDIF
IF MDG( "Apagar Pedidos Em Branco" )
MAOITA02( 1 )
MDI( " Ý Atualiza‡„o de Pedidos" )
ENDIF

lDATA := MDG( "Corre‡ao de Datas de Pre‡os" )
// lPEDCLI:=MDG("Atualizar Pedido de Cliente")

IF !USEMULT( { { "MO01", 1, 99 }, { "MD03", 1, 1 }, { "MO02", 1, 99 }, { "MA01", 1, 1 }, ;
         { "MD05", 1, 1 }, { "MS02", 1, 5 }, { "MS01", 1, 2 }, { "MRMS", 1, 1 }, { "OSCRT", 1, 99 } } )
RETU
ENDIF

dbSelectAr( "OSCRT" )
dbSetOrder( 2 )


dbSelectAr( "MO02" )
dbGoTop()
WHILE !Eof()
@ 04, 00 SAY PEDIDO
@ 04, 10 SAY CODIGO
@ 04, 35 SAY ENTREGA
@ 04, 45 SAY QTDESAL
// Ajustando Itens do Pedido pelo Codigo da Pe‡a
IF QTDESAL <> 0.00 .AND. TIPOSERV <> "2"
// Altera‡„o dos Dados.
mICMS      := 0.00
mFORNECEDO := FORNECEDO
mLISTA     := LISTA
mCODIGO    := CODIGO
mUF        := "  "
mDATABASE  := DATABASE
mINDICE    := INDICE
mPEDIDO    := PEDIDO
mCODMR01   := ""
mPCEMB     := 0


dbSelectAr( "MA01" )
dbGoTop()
IF dbSeek( mFORNECEDO )
mUF := ESTADO
IF Empty( mLISTA )
mLISTA := MO02LISTA
ENDIF
ENDIF

dbSelectAr( "MD05" )
dbGoTop()
IF dbSeek( mUF )
mICMS := ALIQUOTA
ENDIF

dbSelectAr( "MRMS" )
dbGoTop()
IF dbSeek( mCODIGO + Str( mFORNECEDO, 8 ) )
mCODMR01 := CODMR01
mPCEMB   := PCEMB
ELSE
dbGoTop()
IF dbSeek( mCODIGO + Str( 0, 8 ) )
mCODMR01 := CODMR01
mPCEMB   := PCEMB
ENDIF
ENDIF


Munid    := ""
mvalor   := 0
mpesouni := 0
mCODIPI  := ""
dbSelectAr( "MS01" )
dbGoTop()
IF dbSeek( mCODIGO )
mUNID    := UNID
mNOME    := NOME
mCODIPI  := CODIPI
mPESOUNI := PESOUNI
ENDIF

IF lDATA
aPRC := MS02PRC( mCODIGO, mLISTA, .F., "mUNID", "mCODIPI" )
IF Empty( mINDICE )
mVALOR := aPRC[ 1 ]
ELSE
mVALIND := aPRC[ 1 ]
ENDIF
mDATABASE := aPRC[ 3 ]
ELSE
dbSelectAr( "MS02" )
dbGoTop()
IF dbSeek( mCODIGO + Str( mLISTA, 5 ) + DToS( mDATABASE ) )
IF Empty( mINDICE )
mVALOR := VALOR
ELSE
mVALIND := VALOR
ENDIF
IF !Empty( UNIDE )
mUNID := UNIDE
ENDIF
ENDIF
ENDIF


dbSelectAr( "MO02" )
netreclock()
FIELD->UNID := mUNID
IF Empty( mINDICE )
FIELD->VALOR := mVALOR
ELSE
FIELD->VALIND := mVALIND
ENDIF
FIELD->DATABASE := mDATABASE
IF UNID = "HR"
mHORAPED        := HORAPED
mHORAENT        := HORAENT
xVALMER         := ( mHORAPED - mHORAENT ) * mVALOR
FIELD->VALORMER := xVALMER
ELSE
mQTDEPED        := QTDEPED
mQTDEENT        := QTDEENT
xVALMER         := ( mQTDEPED - mQTDEENT ) * mVALOR
FIELD->VALORMER := xVALMER
ENDIF

FIELD->PESOUNI := mPESOUNI
FIELD->CODIPI  := mCODIPI
mVALORMER      := VALORMER
mICMIPI        := mICMRED := 0.00

dbSelectAr( "MD03" )
dbGoTop()
IF dbSeek( mCODIPI )
mIPI      := ALIQUOTA
mCLASSIPI := CLASSIFIC
mICMRED   := ALIQUOTAR
mICMIPI   := ALIQUOTAI
ENDIF

dbSelectAr( "MO02" )
FIELD->IPI      := mIPI
FIELD->CLASSIPI := mCLASSIPI
mVALORIPI       := Round( ( VALORMER * ( mIPI / 100 ) ), 2 )
mVALORTOT       := VALORMER + mVALORIPI
IF CONSUMO = "S"
mBASEICM := mVALORMER + mVALORIPI
ELSE
mBASEICM := mVALORMER
ENDIF
IF mICMIPI <> 0.00
mICM := mICMIPI
ELSE
mICM := mICMS
ENDIF
IF mICMRED <> 0.00
mBASEICM := ( mBASEICM * ( mICMRED / 100 ) )
ENDIF
mVALORICM       := ( mBASEICM * ( mICM / 100 ) )
FIELD->VALORIPI := mVALORIPI
FIELD->VALORTOT := mVALORTOT
FIELD->VALORICM := mVALORICM
FIELD->ICM      := mICM
FIELD->BASEICM  := mBASEICM

// Embalagem
IF !Empty( mCODMR01 )
FIELD->CODMR01 := mCODMR01
FIELD->PCEMB   := mPCEMB
IF mPCEMB > 0
IF !Empty( QTDEPRE )
FIELD->PCEMBQ := CEILING( QTDEPRE / PCEMB )
ELSE
FIELD->PCEMBQ := CEILING( QTDESAL / PCEMB )
ENDIF
ENDIF
ENDIF

mPEDCLINEW := ""
mPEDITENEW := 0
dbSelectAr( "OSCRT" )
dbGoTop()
IF dbSeek( Str( mFORNECEDO, 8 ) + mCODIGO )
mPEDCLINEW := AllTrim( PEDIDOCLI )
mPEDITENEW := PEDCLIITE
ENDIF

dbSelectAr( "MO01" )
dbGoTop()
IF dbSeek( mPEDIDO )
netreclock()
FIELD->ICM     := mICM
FIELD->TOTBICM := mBASEICM
FIELD->TOTICM  := mVALORICM
FIELD->TOTIPI  := mVALORIPI
FIELD->TOTMER  := mVALORMER
FIELD->TOTNF   := mVALORTOT
mPEDCLIOLD     := AllTrim( PEDIDOCLI )
IF mPEDCLINEW <> mPEDCLIOLD .AND. !Empty( mPEDCLINEW )
// IF lPEDCLI
IF MDG( "Pedido Cliente:" + mPEDCLIOLD + "->" + mPEDCLINEW )
FIELD->PEDIDOCLI := mPEDCLINEW
FIELD->PEDCLIITE := mPEDITENEW
ENDIF
// ENDIF
ENDIF
dbUnlock()
ENDIF
dbSelectAr( "MO02" )
dbUnlock()
ENDIF
dbSelectAr( "MO02" )
dbSkip()
ENDDO
dbSelectAr( "MO02" )
dbSetOrder( 5 )
dbGoTop()
WHILE !Eof()
Mfornecedo := fornecedo
mCODIGO    := codigo
mENTREGA   := entrega
mHORAPRG   := horaprg
mpedido    := pedido
dbSkip()
IF !Eof()
IF Mfornecedo = fornecedo .AND. mCODIGO = codigo .AND. ENTREGA = entrega .AND. mHORAPRG = horaprg .AND. mpedido = pedido
ALERTX( "Os Mesma Data Entrega" + Str( mpedido ) + "=" + Str( pedido ) )
ENDIF
ENDIF
ENDDO
dbCloseAll()
RETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MS02PRC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MS02PRC( cCODIGO, cLISTA, lOPEN, eUNID, eCOID, ePRECO, lMES )

   LOCAL aRETU := { 0, "  ", CToD( Space( 8 ) ), "  " }   // Valor,Unidade,DataBase,CODIPI
   LOCAL cDBF  := Alias()

   cCODIGO := PadR( cCODIGO, 24 )
   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF
   IF lOPEN
      WHILE !USEREDE( "MS02", 1, 5 )
      ENDDO
   ENDIF
   dbSelectAr( "MS02" )
   dbGoTop()
   dbSeek( cCODIGO + Str( cLISTA, 5 ) )
   WHILE cCODIGO = CODIGO .AND. cLISTA = FORNECEDO .AND. !Eof()
      IF ATUAL # "N"
         aRETU[ 1 ] := VALOR
         aRETU[ 3 ] := DATA
         IF ValType( ePRECO ) = "C"
            &ePRECO. := VALOR
         ENDIF
         IF !Empty( UNIDE )
            aRETU[ 2 ] := UNIDE
            IF ValType( eUNID ) = "C"
               &eUNID. := UNIDE
            ENDIF
         ENDIF
         IF !Empty( COIDE )
            aRETU[ 4 ] := COIDE
            IF ValType( eCOID ) = "C"
               &eCOID. := COIDE
            ENDIF
         ENDIF
      ENDIF
      dbSkip()
   ENDDO
   IF aRETU[ 1 ] = 0 .AND. lMES
      ALERTX( "Sem Lista de Preco " + strval( cCODIGO ) + ":" + STRVAL( cLISTA ) )
      EMAILINT( "MOC00004", "Sem Lista de Preco " + strval( cCODIGO ) + ":" + STRVAL( cLISTA ) )
   ENDIF
   IF lOPEN
      dbCloseArea()
   ENDIF
   IF !Empty( cDBF )
      SELE &cDBF.
   ENDIF
   RETU aRETU

// + EOF: maoita01.prg
// +
