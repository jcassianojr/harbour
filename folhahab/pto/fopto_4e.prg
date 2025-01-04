// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4e.prg Cadastro de Funcionários
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


FUNCTION fopto_4e()

   MESTADO  := ""
   MCIDADE  := ""
   MNESTADO := ""
   MNCIDADE := ""
   cGRUPO   := "T"
   cFILTRO  := ""
   mRAISITU := ""
   MCBONEW  := ""
   MFAIXA   := ""
   mREQCNH  := ""
   mREQOC   := ""
   mOCEMIS  := ""


   MDS( '(A)tivos (D)emitidos (M)Ativos+Demitidos Mes (T)odos ' )
   @ 24, 78 GET cGRUPO PICT "!" VALID cGRUPO $ "ADTM"
   READCUR()
   DO CASE
   CASE cGRUPO = "D"
      cFILTRO := "! EMPTY(DEMITIDO)"
   CASE cGRUPO = "A"
      cFILTRO := "EMPTY(DEMITIDO)"
   CASE cGRUPO = "M"
      cFILTRO := "((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES.AND.YEAR(DEMITIDO)>=ANOUSO))"
   ENDCASE

   PADRAO( PES, PESIND, "STR(mNUMERO)+' '+mNOME+' '+STR(mCCUSTO,4)+' '+mUNIFUN+' '+mMODIRETA+' '+mHTT+' '+dtoc(mADMITIDO)+' '+dtoc(mDEMITIDO)", ;
      "mNUMERO", "FOPTO_4E - Cadastro de Funcionários", "Numero Nome", ;
      {|| iFOPTO4E( .T. ) }, {|| tFOPTO4E() }, {|| gFOPTO4E() }, {|| FO_RELL( "PONTOCAD07" ) }, { .F., cFILTRO, .T. }, 2 )

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO4E()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION gFOPTO4E

   @  6, 3  GET mDEPTO
   @  6, 9  GET mSETOR
   @  6, 16 GET mSECAO
   @  6, 22 GET mCHAPA
   @  6, 34 SAY mNUMERO
   @  6, 40 GET mNOME
   @  8, 09 GET mFUNCAO    VALID vERSEHA( "FUNCAO",, mFUNCAO, "STR(CODIGO)+' '+NOME", "'Cargo/Funcao Invalida'", .T., { { "CBONEW", "mCBONEW" }, { "FAIXA", "mFAIXA" }, { "REQCNH", "mREQCNH" }, { "REQOC", "mREQOC" }, { "OCEMIS", "mOCEMIS" } } )
   @  8, 25 GET mSITUACAO  VALID VALSITU( "mSITUACAO", "mEXCVALE", "mRAISSITU" )
   @  8, 33 GET mTIPO      VALID CHECKTAB( "TSA2" + mTIPO, 24, 0, "Tipo nao Cadastrado" )
   @  8, 49 GET mUNIFUN    VALID VERSEHA( "UNID",, mUNIFUN, "NOME", '"Unidade nao cadastrado"' )
   @  8, 68 GET MCCUSTO
   @  8, 76 GET mMODIRETA  VALID mMODIRETA $ "SNACDI "
   @ 10, 02 GET mADMITIDO
   @ 10, 11 GET mDEMITIDO
   @ 10, 20 GET mMOTIVO    VALID Empty( mMOTIVO ) .OR. VERSEHA( "FO_RCAU",, mMOTIVO, "NOME", '"Codigo Nao Cadastrado"' )
   @ 10, 23 GET mFONE
   @ 10, 38 GET mDATTRANSF
   @ 10, 47 GET mNUMEMPANT WHEN !Empty( mDATTRANSF )                                                                                                                                                                      PICT "999"
   @ 10, 51 GET mNUMREGANT WHEN !Empty( mDATTRANSF )                                                                                                                                                                      PICT "99999999"
   @ 11, 50 GET mCESTA     VALID mCESTA $ "SNV "
   @ 11, 72 GET mVT        VALID mVT $ "SN "
   @ 12, 06 GET mCPF       PICTURE "999.999.999-99"                                                                                                                                                                     VALID VALCPF( mCPF )
   @ 12, 25 GET mRGTIP     VALID mRGTIP = "RG" .OR. mRGTIP = "RGE" .OR. mRGTIP = "RIC" .OR. mRGTIP = "CPF"
   @ 12, 29 GET mRGUF      PICT "!!"                                                                                                                                                                                    VALID mRGTIP = "CPF" .OR. CHECKTAB( PadR( "UF", 4 ) + PadR( mRGUF, 5 ), 24, 0, "Estado Nao Cadastrado" )
   @ 12, 32 GET mRG        VALID ALLTRUE( CHECKRG( FORMATARG( mRG, mRGTIP ), .T., mRGTIP, mNASC, mRGUF ) )
   @ 12, 47 GET mRGEMIS    VALID mRGTIP = "CPF" .OR. VERSEHA( "ORGEMISS",, mRGEMIS, "NOME", '"Orgao emissor nao cadastrado"' )
   @ 13, 43 GET mPIS       VALID VALPIS( mPIS, .T., .T., mEVINC )
   @ 13, 60 GET mCNS       VALID ALLTRUE( VALCNS( mCNS ) )
   @ 14, 06 GET mPAI       PICT "@S30"
   @ 14, 42 GET mMAE       PICT "@S30"
   @ 15, 12 GET mENDTIP    PICT "!!"                                                                                                                                                                                    VALID VERSEHA( "ESOCIAL_TAB20",, mENDTIP, "NOME", '"Tipos de Logradouros - eSocial"' ) // VALID alltrue(CHECKTAB(PADR("ELOG",4)+PADR(mENDTIP,5),24,0,"Tipo Nao Cadastrado"))
   @ 15, 15 GET mENDER     WHEN ALLTRUE( CorrigeEndereco( "mENDER", "mENDNUM", "mENDCOMPL", "mENDTIP" ) )
   @ 15, 56 GET mENDNUM
   @ 16, 15 GET mENDCOMPL
   @ 17, 12 GET mBAIRRO
   @ 18, 12 GET mIBGE      VALID CHECKCID(,, .T., mIBGE, { { "UF", "mESTADO" }, { "NOME", "mCIDADE" } } )
   @ 18, 20 GET mESTADO    WHEN Empty( mIBGE )                                                                                                                                                                            PICT "!!"                                                                                                                                                               VALID CHECKTAB( PadR( "UF", 4 ) + PadR( mESTADO, 5 ), 24, 0, "Estado Nao Cadastrado" )
   @ 18, 23 GET mCIDADE    WHEN Empty( mIBGE )                                                                                                                                                                            VALID CHECKCID( mESTADO, mCIDADE, .T.,, { { "CODIBGE", "mIBGE" } } )
   @ 18, 65 GET mCEP       PICT "#####-###"                                                                                                                                                                             VALID CHKUFCEP( mCEP, mESTADO )
   @ 20, 13 GET mCNH       VALID IF( mREQCNH = "S", !Empty( mCNH ), .T. )
   @ 20, 29 GET mCATCNH    WHEN !Empty( mCNH )
   @ 20, 40 GET mVALCNH    WHEN !Empty( mCNH )
   @ 20, 59 GET mEXPCNH    WHEN !Empty( mCNH )
   @ 21, 13 GET mOC        VALID IF( mREQOC = "S", !Empty( mOC ), .T. )
   @ 21, 40 GET mOCVAL     WHEN !Empty( mOC )
   @ 21, 59 GET mOCEXP     WHEN !Empty( mOC )
   @ 21, 68 GET mOCEMI     WHEN !Empty( mOC )                                                                                                                                                                             VALID VERSEHA( "ORGEMISS",, mOCEMI, "NOME", '"Orgao emissor nao cadastrado"' )
   READCUR()
   mCNUMERO   := StrZero( mNUMERO, 8 )
   mDEPSETSEC := mDEPTO * 1000000 + mSETOR * 1000 + mSECAO
   mRG        := FORMATARG( mRG )
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO4E()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION tFOPTO4E

   hb_DispBox( 4, 0, 23, 79, B_DOUBLE + " " )
   @  5, 2  SAY "Depto Setor  Secao Chapa        No.   Nome"
   @  8, 2  SAY "Funcao:"
   @  8, 15 SAY "Situacao:    TSal:"
   @  8, 40 SAY "UnidFunc:"
   @  8, 60 SAY "CCusto:"
   @  9, 2  SAY "Admitido Demitido C.Dem Fone        Transferencia"
   @ 11, 38 SAY "Cesta Basica (S/N/V)"
   @ 11, 60 SAY "V.Transporte (S/N)"
   @ 12, 02 SAY "CPF:"
   @ 12, 22 SAY "RG:"
   @ 13, 38 SAY "PIS:"
   @ 13, 55 SAY "CNS:"
   @ 14, 2  SAY "Pai" + spac( 33 ) + "Mae" + spac( 38 )
   @ 15, 2  SAY "ENDERECO:"
   @ 16, 2  SAY "Complemento:"
   @ 17, 2  SAY "BAIRRO  :"
   @ 18, 2  SAY "CIDADE:" + spac( 46 ) + "      " + "CEP:"
   @ 19, 2  SAY 'Horario:'
   @ 19, 12 SAY mHTT
   @ 19, 15 SAY mHT
   @ 20, 1  SAY "HabilitaCAo:" + spac( 12 ) + "Catg   Validade" + spac( 10 ) + "Expedicao"
   @ 21, 1  SAY "OrgaoClasse:" + spac( 12 ) + "Catg   Validade" + spac( 10 ) + "Expedicao"

   RETURN .T.




// + EOF: fopto_4e.prg
// +
