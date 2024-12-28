// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo2.prg
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
// +    Documentado em 27-Dez-2024 as  9:44 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

#include "BOX.CH"
PADRAO( "SINDICAT", "SINDICAT", "' '+STR(mCODIGO,5)+' '+mNOME+' '+mTELEFONE", "mCODIGO", "Cadastro de Sindicatos", "Codigo Nome" + spac( 37 ) + "Telefone", ;
      {|| PEGCHAVE( "mCODIGO", ULTIMOREG( "SINDICATO", "CODIGO", .T. ), "Codigo" ) }, {|| tFO2() }, {|| gFO2() }, {|| FO_FOR( "GRUPO='SINDIC'" ) } )
RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFO2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC gFO2()

   v_pic := "@S18"
   @  5, 12 GET mCOGNOME
   @  5, 36 GET mNOME
   @  6, 11 GET mENDERECO
   @  6, 49 GET mBAIRRO

   @ 11, 9  GET mESTADO PICTURE "!!"                        VALID CHECKTAB( PadR( "UF", 4 ) + PadR( mESTADO, 5 ), 24, 0, "Estado Nao Cadastrado" ) .AND. CHKUFCEP( mCEP, mESTADO )
   @ 11, 12 GET mCIDADE VALID CHECKCID( mESTADO, mCIDADE, .T. )
   @ 11, 42 GET mCEP    PICTURE "99999-999"                 VALID CHKUFCEP( mCEP, mESTADO )


   @ 08, 10 GET mCGC PICT( v_pic ) WHEN {| oGet | CNPJCPFPICT( oGet, 'J', 08, 10 ) } VALID CNPJCPFVAL( mCGC, 'J' ) .AND. ALLTRUE( VERSEHA( "SINDCNPJ",, mCGC, "CNPJ", '"CNPJ Nao Cadastrado Na Rais"' ) )
   @ 08, 50 GET mIE  VALID       VALIE( mIE, mESTADO, "J" )


   @ 11, 64 GET mTELEFONE // PICTURE "(9999)999-9999"
   @ 14, 2  GET mENTIDADE
   @ 17, 11 GET mCTAASSI                             PICTURE '999'
   @ 18, 11 GET mDATASS1
   @ 18, 23 GET mDATASS2
   @ 19, 10 GET mTAXAASS                             PICTURE "999.99"       WHEN !Empty( mDATASS1 ) .OR. !Empty( mDATASS2 )
   @ 19, 22 GET mTETOASS                             PICTURE "9999,999.99"  WHEN !Empty( mDATASS1 ) .OR. !Empty( mDATASS2 )
   @ 13, 67 GET mDESSIND                             PICTURE "!"            VALID mDESSIND $ 'SNP'
   @ 13, 75 GET mCTASIND                             PICTURE '999'          WHEN mDESSIND = "S"
   @ 14, 45 GET mPERSIND                             PICTURE "99.99"        WHEN mDESSIND = "P"
   @ 14, 57 GET mTETSIND                             PICTURE "9999999.99"   WHEN mDESSIND = "P"
   @ 16, 38 GET mSALJAN                              PICTURE "9999999.99"   WHEN mDESSIND = "S"
   @ 17, 38 GET mSALFEV                              PICTURE "9999999.99"   WHEN mDESSIND = "S"
   @ 18, 38 GET mSALMAR                              PICTURE "9999999.99"   WHEN mDESSIND = "S"
   @ 19, 38 GET mSALABR                              PICTURE "9999999.99"   WHEN mDESSIND = "S"
   @ 16, 53 GET mSALMAI                              PICTURE "9999999.99"   WHEN mDESSIND = "S"
   @ 17, 53 GET mSALJUN                              PICTURE "9999999.99"   WHEN mDESSIND = "S"
   @ 18, 53 GET mSALJUL                              PICTURE "9999999.99"   WHEN mDESSIND = "S"
   @ 19, 53 GET mSALAGO                              PICTURE "9999999.99"   WHEN mDESSIND = "S"
   @ 16, 68 GET mSALSET                              PICTURE "9999999.99"   WHEN mDESSIND = "S"
   @ 17, 68 GET mSALOUT                              PICTURE "9999999.99"   WHEN mDESSIND = "S"
   @ 18, 68 GET mSALNOV                              PICTURE "9999999.99"   WHEN mDESSIND = "S"
   @ 19, 68 GET mSALDEZ                              PICTURE "9999999.99"   WHEN mDESSIND = "S"
   @ 21, 29 GET mDESCONF                             PICTURE "!"            VALID mDESCONF $ 'SN'
   @ 21, 37 GET mCTACONF                             PICTURE '999'          WHEN mDESCONF = "S"
   @ 22, 13 GET mPERCONF                             PICTURE "99.99"        WHEN mDESCONF = "S"
   @ 22, 28 GET mTETCONF                             PICTURE "999999999.99" WHEN mDESCONF = "S"
   @ 21, 70 GET mDATDISSI
   @ 22, 70 GET mDATSIND
   READCUR()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFO2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC tFO2()

   hb_DispBox( 3, 0, 23, 79, B_DOUBLE + " " )
   @  4, 2  SAY "C¢digo ++ Cognome " + Replicate( '-', 13 ) + "++ Nome " + Replicate( '-', 38 )
   @  6, 2  SAY "Endere‡o:" + spac( 31 ) + "Bairro:"
   @  8, 2  SAY "CGC"
   @  8, 42 SAY "IE"
   @ 11, 2  SAY "Cidade:" + spac( 21 ) + "          " + spac( 19 ) + "FONE:"
   @ 12, 1  SAY Replicate( '-', 31 ) + "-" + Replicate( '-', 46 )
   @ 13, 2  SAY "C¢digo da Entidade Sindical:  Ý MENSALIDADE DO SINDICATO:(S/N/P)   Conta:"
   @ 14, 32 SAY "Ý Percentual" + spac( 8 ) + "Teto"
   @ 15, 1  SAY Replicate( '-', 31 ) + "Ý Valores Mensais Quando Fixo"
   @ 16, 2  SAY "CONTRIBUICAO ASSISTENCIAL     Ý Jan" + spac( 12 ) + "Mai" + spac( 12 ) + "Set"
   @ 17, 2  SAY "Conta:" + spac( 24 ) + "Ý Fev" + spac( 12 ) + "Jun" + spac( 12 ) + "Out"
   @ 18, 2  SAY "Datas 1§" + spac( 10 ) + "2§" + spac( 10 ) + "Ý Mar" + spac( 12 ) + "Jul" + spac( 12 ) + "Nov"
   @ 19, 2  SAY "Percen.:" + spac( 7 ) + "Teto" + spac( 11 ) + "Ý Abr" + spac( 12 ) + "Ago" + spac( 12 ) + "Dez"
   @ 20, 1  SAY Replicate( '-', 31 ) + "-" + Replicate( '-', 10 ) + "-" + Replicate( '-', 35 )
   @ 21, 2  SAY "Contr. Confederativa (S/N)   Conta:" + spac( 6 ) + "Ý Data do Dissidio" + spac( 7 ) + ":"
   @ 22, 2  SAY "Percentual" + spac( 7 ) + "%   Teto" + spac( 16 ) + "Ý Data Contrib. Sindical :"
   @ 12, 30 SAY "Inc.Est."
   RETU .T.


// + EOF: fo2.prg
// +
