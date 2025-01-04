// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4h.prg
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

FUNCTION fopto_4h()

   v_pic := "@S18"
   PADRAO( "FIRMA", "FIRMA", "STR(mNRCLIEN)+' '+mRAZAO", "mNRCLIEN", "FOPTO_4H - Cadastro de Empresas", "Codigo Raz„o", ;
      {|| ALERTX( "nao disponivel neste modulo" ) }, {|| tFOPTO4H() }, {|| gFOPTO4H() }, {|| FO_RELL( "PONTOCAD09" ) },, 2,,, "E" )


   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO4H()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION gFOPTO4H

   @  5, 3  SAY mNRCLIEN
   @  5, 11 GET mCOGNOME
   @  5, 28 GET mRAZAO
   @  5, 77 GET mPESSOA    PICT "!"                            VALID mPESSOA $ 'FJCO '
   @  9, 13 GET mCGC       PICT( v_pic )                         WHEN {| oGet | CNPJCPFPICT( oGet, mPESSOA, 9, 13 ) }                            VALID CNPJCPFVAL( mCGC, mPESSOA )
   @  7, 11 GET mENDERECO
   @  7, 49 GET mBAIRRO
   @  8, 10 GET mESTADO    PICT "!!"                           VALID CHECKTAB( PadR( "UF", 4 ) + PadR( mESTADO, 5 ), 24, 0, "Estado N„o Cadastrado" )
   @  8, 13 GET mCIDADE    VALID CHECKCID( mESTADO, mCIDADE, .T. )
   @  8, 33 GET mCEP       PICT "99999-999"                    VALID CHKUFCEP( mCEP, mESTADO )
   @  8, 49 GET mTELEFONE
   @  8, 69 GET mFAX
   @  9, 43 GET mINSC      VALID                               VALIE( mINSC, mESTADO, mPESSOA )
   @  9, 70 GET mCRTPONTO  VALID mCRTPONTO $ "SN"
   @ 10, 13 GET mCTRALMOCO VALID mCTRALMOCO $ "SN"
   READCUR()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO4H()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION tFOPTO4H

// Desenha a Tela
   hb_DispBox( 2, 0, 23, 79, B_DOUBLE + " " )
   @  4, 2 SAY "Codigo + Cognome " + Replicate( '-', 7 ) + "+ Raz„o " + Replicate( '-', 35 ) + "+ Pessoa -+"
   @  5, 0 SAY "|" + spac( 8 ) + "|" + spac( 16 ) + "|" + spac( 42 ) + "| (F/J)   |"
   @  6, 0 SAY "|" + Replicate( '-', 8 ) + "-" + Replicate( '-', 16 ) + "-" + Replicate( '-', 42 ) + "-" + Replicate( '-', 9 ) + "|"
   @  7, 0 SAY "| Endere‡o:" + spac( 33 ) + "Bair:" + spac( 16 ) + "    " + spac( 10 ) + "|"
   @  8, 0 SAY "| Cidade:" + spac( 17 ) + "                 FONE:" + spac( 15 ) + "FAX :" + spac( 20 ) + "|"
   @  9, 0 SAY "| C.G.C.   :" + spac( 20 ) + "Ins.Est. :" + spac( 17 ) + "Tem Ponto" + Space( 13 ) + "|"
   @ 10, 0 SAY "Marca Almoco:"
   @ 11, 0 SAY "+" + Replicate( '-', 78 ) + "+"
   RETU .T.


// + EOF: fopto_4h.prg
// +
