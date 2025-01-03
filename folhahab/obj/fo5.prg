// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo5.prg Menu Cadastro de Departamentos
// +
// +
// +
// +     Sistema: FOLHA DE PAGAMENTO
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


#include "inkey.ch"
#include "box.ch"


function fo5()
PRIV HELPDBF
HELPDBF := "FO5"

Set( _SET_MESSAGE, 22, .T. )
WHILE .T.
CABEX( "Menu do Cadastro Departamento Unidades" )
@ 11, 04 PROM "1 - Depto          " MESS 'Inclui Depto Setor Secao'
@ 12, 04 PROM "3 - Unidade Funcio " MESS 'Unidades Funcionais'
@ 13, 04 PROM "2 - Organizar Depto" MESS 'Reorganiza o arquivo'
MENU TO OPCAO
DO CASE
CASE OPCAO = 1
PADRAO( "DEPTO", "DEPTO", "STR(mDEPTO,4)+' '+STR(mSETOR,4)+' '+STR(mSECAO,4)+' '+mNOME", "mDEPTO*1000000+mSETOR*1000+mSECAO", "DEPTO - Cadastro de Depto/Setor/secao", "Depto Setor Secao Nome", ;
            {|| iDEPTO() }, {|| tDEPTO() }, {|| gDEPTO() }, {|| FO_FOR( "GRUPO='DEPTO'" ) },, 2 )
CASE OPCAO = 2
FO_UNID()
CASE OPCAO = 3
NETPACK( "DEPTO" )
IF netuse( "DEPTO",, .F. )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netgrvcam( "CONTROLE", DEPTO * 1000000 + SETOR * 1000 + SECAO ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netgrvcam( "CONTROL2", SETOR * 10000000 + DEPTO * 1000 + SECAO ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netgrvcam( "CONTROL3", SECAO * 10000000 + DEPTO * 1000 + SETOR ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
dbCloseAll()
ENDIF
OTHERWISE
RETU
ENDCASE
ENDDO
return


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tDEPTO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION tDEPTO()

   SetColor( '+W/N' )
   hb_DispBox( 8, 0, 22, 15, B_SINGLE + " " )
   @  8, 2  SAY "Digite dados para :"
   @ 10, 2  SAY "Nome :" + spac( 42 ) + "Cognome:"
   @ 12, 2  SAY "Nome Reduzido:"
   @ 14, 2  SAY "COdigo FPAS:     Codigo Acidente Trabalho"
   @ 15, 2  SAY "Valor Pro Labore do Mes"
   @ 16, 2  SAY "Valor Autonomos  do Mes"
   @ 17, 2  SAY "Valor Adcional Acidente"
   @ 18, 2  SAY "Taxa Acidente"
   @ 19, 2  SAY "Taxa Empresa"
   @ 20, 2  SAY "Taxa Terceiros"
   @ 21, 40 SAY "UnidFunc:"
   @ 21, 60 SAY "CCusto:"

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gDEPTO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION gDEPTO()

   xREFPAS := mFPAS
// Get nas Menvars
   @ 10, 9  GET mNOME
   @ 10, 59 GET mNOMEC
   @ 12, 17 GET mNOMER
   @ 14, 15 GET mFPAS     WHEN xFO5G()                                                     VALID VERSEHA( "CONFINSS",, Val( mFPAS ), "DESCRICAO", "'Codigo FPAS inconsistente '" ) .AND. xFO5G()
   @ 14, 44 GET mCODSAT
   @ 15, 26 GET mTOTLAB
   @ 16, 26 GET mTOTAUT
   @ 17, 26 GET mTOTADI
   @ 18, 19 GET mTXSEG
   @ 19, 19 GET mTXEMP
   @ 20, 19 GET mTXTER
   @ 21, 49 GET mUNIFUN   VALID VERSEHA( "UNID",, mUNIFUN, "NOME", '"Unidade nao cadastrado"' )
   @ 21, 68 GET mCCUSTO
   @ 21, 76 GET mMODIRETA VALID mMODIRETA $ "SNACDI "
   READCUR()
   RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function xFO5G()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION xFO5G()

   IF mFPAS # xREFPAS .OR. Empty( mTXSEG ) .OR. Empty( mTXEMP ) .OR. Empty( mTXTER )
      VERSEHA( "CONFINSS",, mFPAS,,, .F., { { "ACIDENTE", "mTXSEG" }, { "EMPRESA", "mTXEMP" }, { "TOTAL", "mTXTER" } } )
   ENDIF
   xREFPAS := mFPAS
   IF Empty( mFPAS )
      mFPAS := OBTER( "FIRMA",, NREMP, "FPAS" )
   ENDIF
   IF Empty( mCODSAT )
      mCODSAT := OBTER( "FIRMA",, NREMP, "ACID" )
   ENDIF
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iDEPTO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION iDEPTO()

   LOCAL X

   SetColor( "N/W" )
   hb_Scroll( 07, 00, 24, 79 )
   hb_DispBox( 08, 03, 10, 74, B_SINGLE + " " )
   @ 09, 05 SAY "Departamento : "
   hb_DispBox( 13, 03, 15, 74, B_SINGLE + " " )
   @ 14, 05 SAY "Departamento : "
   hb_DispBox( 13, 03, 15, 74, B_SINGLE + " " )
   @ 14, 05 SAY "Setor        : "
   hb_DispBox( 18, 03, 20, 74, B_SINGLE + " " )
   @ 19, 05 SAY "Secao        : "
   SetColor( "W/N" )
   hb_Scroll( 09, 75, 10, 75 )
   @ 11, 05 SAY "" + SPAC( 71 ) + ""
   hb_Scroll( 19, 75, 20, 75 )
   @ 21, 05 SAY "" + SPAC( 71 ) + ""
   hb_Scroll( 14, 75, 15, 75 )
   @ 16, 05 SAY "" + SPAC( 71 ) + ""
   SetColor( "N/W" )
   @ 14, 20 GET mDEPTO PICT '####'
   @ 19, 20 GET mSETOR PICT '####'
   @ 19, 33 GET mSECAO PICT '####'
   READCUR()
   IF NETUSE( "DEPTO" )
      FOR X := 1 TO 3
         DO CASE
         CASE X = 1
            mCHAVE := mDEPTO * 1000000
         CASE X = 2
            mCHAVE := mDEPTO * 1000000 + mSETOR * 1000
         CASE X = 3
            mCHAVE := mDEPTO * 1000000 + mSETOR * 1000 + mSECAO
         ENDCASE
         dbGoTop()
         IF !dbSeek( mCHAVE )
            netrecapp()
            FIELD->DEPTO := mDEPTO
            IF X > 1
               FIELD->SETOR := mSETOR
            ENDIF
            IF X = 3
               FIELD->SECAO := mSECAO
            ENDIF
            FIELD->CONTROLE := DEPTO * 1000000 + SETOR * 1000 + SECAO
            FIELD->CONTROL2 := SETOR * 10000000 + DEPTO * 1000 + SECAO
            FIELD->CONTROL3 := SECAO * 10000000 + DEPTO * 1000 + SETOR
         ENDIF
      NEXT X
      dbCloseArea()
   ENDIF
   mCHAVE := mDEPTO * 1000000 + mSETOR * 1000 + mSECAO

   RETURN .T.




// : FIM: FO5.PRG



// + EOF: fo5.prg
// +
