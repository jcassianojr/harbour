// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4t.prg Cadastro de Ocorrencias
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



// Teclas Operacionais
#include "INKEY.CH"
// //#INCLUDE "COMANDO.CH"
#include "BOX.CH"


FUNCTION fopto_4t()

   cPO := "PO" + ANOMESW

   CHECKCRI( cPO, "FO_POCO", "STR(NUMERO,8)+DTOS(OCOINI)" )

   PADRAO( cPO, cPO, "' '+STR(mNUMERO,  8)+' '+DTOC(mOCOINI)+' '+DTOC(mOCOFIM)+' '+mOCOCOD+' '+mOCOSUB+' '+mOCOBCO+' '+mOCOFOL+' '+mOCOEXT+' '+mABONA+' '+mCESTA", ;
      "STR(mNUMERO,8)+DTOS(mOCOINI)", ;
      "FOPTO_4T - Cadastro de Ocorrencias", ;
      "Numero     Periodo          CodSubBHFOEXABCB", ;
      {|| iFOPTO4t() }, {|| tFOPTO4t() }, {|| gFOPTO4t() }, {|| ALLTRUE() },, 2,,, Ztipvid )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iFOPTO4t()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION iFOPTO4t

   MDS( "Digite o Numero e a data Inicio" )
   @ 24, 40 GET mNUMERO
   @ 24, 50 GET mOCOINI
   READCUR()
   mCHAVE := Str( mNUMERO, 8 ) + DToS( mOCOINI )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO4t()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION gFOPTO4t

   verpassagens( mNUMERO, mOCOINI, .T., .T. )
   @  6, 1  SAY mNUMERO
   @  6, 10 SAY mOCOINI
   @  6, 19 GET mOCOFIM
   @  6, 28 GET mOCOCOD
   @  6, 31 GET mOCOSUB
   @  7, 25 GET mOCORED PICT "!"                                                                          VALID mOCORED $ "SN "
   @  8, 25 GET mOCOBCO PICT "!"                                                                          VALID mOCOBCO $ "SN "
   @  9, 25 GET mOCOFOL PICT "!"                                                                          VALID mOCOFOL $ "SNVM "
   @ 10, 25 GET mOCOEXT PICT "!"                                                                          VALID mOCOEXT $ "SNVTZA5 "
   @ 11, 25 GET mOCOALM PICT "!"                                                                          VALID mOCOALM $ "ABCDESN "
   @ 12, 25 GET mABONA  PICT "!"                                                                          VALID mABONA $ "PSNC "
   @ 12, 27 GET mHRABO  PICT '999.99'
   @ 13, 25 GET mCESTA  PICT "!"                                                                          VALID mCESTA $ "PAMFTVCJ "
   @ 13, 27 GET mHRREL  PICT '999.99'
   @ 15, 10 GET mMOTIVO VALID ALLTRUE( IF( Empty( mOCOMOT ), mOCOMOT := OBTER( "FOPTOMOT",, mMOTIVO, "NOME" ), "" ) )
   @ 16, 1  GET mOCOMOT VALID !Empty( mOCOMOT )
   @ 17, 5  GET mCID    VALID ALLTRUE( VERSEHA( "CID",, mCID, "NOME", "'Codigo CID nao Cadastrado'" ) )
   @ 17, 20 GET mESITU  VALID ALLTRUE( CHECKTAB( "SITU" + mESITU, 24, 0, "Situação não Cadastrado" ) )
   READCUR()

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO4t()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION tFOPTO4t

   hb_Scroll( 2, 0, 23, 79 )
   hb_DispBox( 2, 0, 23, 79, B_DOUBLE + " " )
   @  5, 1  SAY "Numero   Inicio   Fim     Cod Sub"
   @  7, 1  SAY 'Reducao de Horario  SN'
   @  8, 1  SAY 'Banco de Horas      SN'
   @  9, 1  SAY 'Folga Indicada    SNVM'
   @ 10, 1  SAY 'Hora Extra        SNVT'
   @ 11, 1  SAY 'Almoco         ABCDESN'
   @ 12, 1  SAY 'Abonada(C)omp(P)ularSN'
   @ 13, 1  SAY 'Cesta Basica          '
   @ 14, 1  SAY '(P)ular(A)traso(M)edico(F)alta Acid(T)rab Ad(V)ertencia(C)racha Falta(J)us'
   @ 15, 1  SAY "Motivo:"
   @ 17, 1  SAY "CID:"
   @ 17, 10 SAY "esocial:"

   RETURN .T.



// + EOF: fopto_4t.prg
// +
