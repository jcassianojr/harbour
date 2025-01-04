// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4m.prg  Correcoes de Marcacoes
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

FUNCTION fopto_4m()

   cPM := "PM" + ANOMESW


   CHECKCRI( cPM, "FO_PMAN", "STR(NUMERO,8)+DTOS(DATOCO)+TIPOCO" )


   PADRAO( cPM, cPM, "' '+STR(mNUMERO,  8)+' '+DTOC(mDATOCO)+' '+STR(mHOROCO,5,2)+' '+STR(mHOROC2,5,2)+' '+STR(mHOROC3,5,2)+' '+STR(mHOROC4,5,2)+' '+mTIPOCO", ;
      "STR(mNUMERO,8)+DTOS(mDATOCO)+mTIPOCO", ;
      "FOPTO_4M - Correcoes de Marcacoes", ;
      "Numero     Data    Cod ENT    ALM        SAI  T ", ;
      {|| iFOPTO4m() }, {|| tFOPTO4m() }, {|| gFOPTO4m() }, {|| ALLTRUE() },, 2,,, zTIPVID )

   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iFOPTO4m()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC iFOPTO4m

   MDS( "Digite o Numero e a data Tipo" )
   @ 24, 40 GET mNUMERO
   @ 24, 50 GET mDATOCO
   @ 24, 60 GET mTIPOCO VALID !Empty( mTIPOCO ) .AND. mTIPOCO $ "ES12TN"
   READCUR()
   mCHAVE := Str( mNUMERO, 8 ) + DToS( mDATOCO ) + mTIPOCO
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO4m()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gFOPTO4m

   verpassagens( mNUMERO, mDATOCO, .T., .T. )
   @  6, 1  SAY mNUMERO PICTURE '99999999'
   @  6, 10 SAY mDATOCO
   @  6, 28 SAY mTIPOCO
   @  7, 16 GET mHOROCO PICTURE '99.99'    WHEN mTIPOCO = "T" .OR. mTIPOCO = "E"
   @  7, 22 GET mHOROC2 PICTURE '99.99'    WHEN mTIPOCO = "T" .OR. mTIPOCO = "1"
   @  7, 30 GET mHOROC3 PICTURE '99.99'    WHEN mTIPOCO = "T" .OR. mTIPOCO = "2"
   @  7, 36 GET mHOROC4 PICTURE '99.99'    WHEN mTIPOCO = "T" .OR. mTIPOCO = "S" .OR. mTIPOCO = "N"
// @  7, 55 get mZERHOR when empty( mHOROCO ) valid mZERHOR $ "SN "
   @ 12, 10 GET mMOTIVO VALID ALLTRUE( IF( Empty( mMOTOCO ), mMOTOCO := OBTER( "FOPTOMOT",, mMOTIVO, "NOME" ), "" ) )
   @ 13, 6  GET mMOTOCO VALID !Empty( mMOTOCO )
   READCUR()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO4m()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC tFOPTO4m

// Desenha a Tela
   hb_Scroll( 2, 0, 23, 79 )
   hb_DispBox( 2, 0, 23, 79, B_DOUBLE + " " )
   @  5, 1  SAY "Numero   Data    Cod Hora  T E-Entrada   1-Saida Refeicao    T-Todos"
   @  6, 30 SAY "S-Saida     2-Retorno Refeicao    (S/N)"
// @  7, 42 SAY "Zerar Horario  S/N"
   @ 12, 1 SAY "Motivo:"
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO_4M2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOPTO_4M2

   CABE2( "Lancamento Grupo Ajuste Horario" )
   cPM := "PM" + ANOWORK + StrZero( mestrab, 2 )

   CHECKCRI( cPM, "FO_PMAN", "STR(NUMERO,8)+DTOS(DATOCO)+TIPOCO" )
   CRIARVARS( cPM )
   MDS( "Data" )
   @ 24, 10 GET mDATOCO
   IF !READCUR()
      RETU .F.
   ENDIF
   tFOPTO4m()
   gFOPTO4m()

   IF !NETUSE( PES )
      RETU
   ENDIF
   FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
   FILTRO := FILTRO( FILTRO )
   SET FILTER TO &FILTRO

   IF !NETUSE( cPM )
      dbCloseAll()
      RETU
   ENDIF
   dbSelectAr( pes )
   dbGoTop()
   WHILE !Eof()
      mNUMERO := NUMERO
      dbSelectAr( cPM )
      dbGoTop()
      IF !dbSeek( Str( mNUMERO, 8 ) + DToS( mDATOCO ) + mTIPOCO )
         netrecapp()
      ENDIF
      REPLVARS()
      dbCommit()
      dbSelectAr( pes )
      dbSkip()
   ENDDO
   dbCloseAll()
// FOPTO_2I()

// + EOF: fopto_4m.prg
// +
