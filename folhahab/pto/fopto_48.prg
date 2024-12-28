// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_48.prg
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


mHORA2 := 0

cPX := "PX" + ANOMESW


CHECKCRI( cPX, "FO_PDES", "STR(NUMERO,8)+DTOS(DATA)+STR(CONTA,2)" )

PADRAO( cPX, cPX, "' '+STR(mNUMERO,8)+' '+DTOC(mDATA)+' '+STR(mCONTA,2)+' '+STR(mHORAS,6,2)+' '+mOBS", "STR(mNUMERO,8)+DTOS(mDATA)+STR(mCONTA,2)", ;
      "FOPTO_48 - Creditos Avulsos", ;
      "Numero   Data     CT Horas  Obs", ;
      {|| iFOPTO48() }, {|| tFOPTO48() }, {|| gFOPTO48() }, {|| ALLTRUE() },, 2,,, zTIPVID )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iFOPTO48()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION iFOPTO48

   MDS( "Digite o Numero e a data e Conta" )
   @ 24, 40 GET mNUMERO VALID !Empty( mNUMERO )
   @ 24, 50 GET mDATA   VALID !Empty( mDATA )
   @ 24, 60 GET mCONTA  PICT "99"             VALID !Empty( mCONTA )
   READCUR()
   mCHAVE := Str( mNUMERO, 8 ) + DToS( mDATA ) + Str( mCONTA, 2 )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO48()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION gFOPTO48

   @  5, 1  SAY mNUMERO PICTURE '99999999'
   @  5, 10 SAY mDATA
   @  5, 19 GET mCONTA  PICTURE '99'       VALID !Empty( mCONTA )
   @  5, 22 GET mHORAS  PICTURE '999.99'   VALID g48A()
   @  5, 29 GET mHORA2  PICTURE '999.99'   VALID g48B()
   @  5, 36 GET mOBS    VALID !Empty( mOBS )
   READCUR()

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function g48A()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION g48A()

   IF mHORA2 = 0
      mHORA2 := bhor( mHORAS )
      @  5, 29 SAY mHORA2 PICTURE '999.99'
   ENDIF

   RETURN .T.

// *+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function g48B()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION g48B()

   IF mHORAS = 0
      mHORAS := Chor( mHORA2 )
      @  5, 22 SAY mHORAS PICTURE '999.99'
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO48()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION tFOPTO48

   hb_DispBox( 3, 0, 23, 79, B_DOUBLE + " " )
   @  4, 1 SAY "Numero   Data     CT Horas Cnv     Obs"

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO_482()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FOPTO_482

   CABE2( "Lancamento Grupo Creditos Avulso" )
   cPX := "PX" + ANOMESW

   CHECKCRI( cPX, "FO_PDES", "STR(NUMERO,8)+DTOS(DATA)+STR(CONTA,2)" )
   CRIARVARS( cPX )
   @ 23, 00
   @ 24, 00
   @ 24, 10 SAY "Data     CT Horas  Obs"
   @ 24, 10 GET mDATA
   @ 24, 19 GET mCONTA                   PICTURE '99'       VALID !Empty( mCONTA )
   @ 24, 22 GET mHORAS                   PICTURE '999.99'   VALID !Empty( mHORAS )
   @ 24, 29 GET mOBS                     VALID !Empty( mOBS )
   IF !READCUR()
      RETURN .F.
   ENDIF


   IF !NETUSE( PES )
      RETURN
   ENDIF
   FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
   FILTRO := FILTRO( FILTRO )
   SET FILTER TO &FILTRO

   IF !NETUSE( cPX )
      dbCloseAll()
      RETU
   ENDIF
   dbSelectAr( pes )
   dbGoTop()
   WHILE !Eof()
      mNUMERO := NUMERO
      dbSelectAr( cPX )
      dbGoTop()
      IF !dbSeek( Str( mNUMERO, 8 ) + DToS( mDATA ) + Str( mCONTA, 2 ) )
         netrecapp()
      ENDIF
      REPLVARS()
      dbSelectAr( pes )
      dbSkip()
   ENDDO
   dbCloseAll()

   RETURN .T.


// + EOF: fopto_48.prg
// +
