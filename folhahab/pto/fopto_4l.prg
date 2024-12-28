// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4l.prg
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

PEGPTOHOR( "XX", .T., .F. )   // Verifica indices

cPH := "PH" + ANOMESW


CHECKCRI( cPH, "FO_PHOR", "STR(NUMERO,8)+DTOS(OCOINI)" )

PADRAO( cPH, cPH, "' '+STR(mNUMERO,  8)+' '+DTOC(mOCOINI)+' '+DTOC(mOCOFIM)+' '+mOCOCOD", "STR(mNUMERO,8)+DTOS(mOCOINI)", ;
      "FOPTO_4L - Correcao de Horarios", ;
      "Numero Horario", ;
      {|| iFOPTO4L() }, {|| tFOPTO4L() }, {|| gFOPTO4L() }, {|| ALLTRUE() },, 2,,, zTIPVID )


// FOPTO_2J()
RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iFOPTO4L()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC iFOPTO4L

   MDS( "Digite o Numero e a data Inicio" )
   @ 24, 40 GET mNUMERO
   @ 24, 50 GET mOCOINI
   READCUR()
   mCHAVE := Str( mNUMERO, 8 ) + DToS( mOCOINI )
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO4L()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gFOPTO4L

   verpassagens( mNUMERO, mOCOINI, .T., .T. )
   @  6, 1  SAY mNUMERO
   @  6, 10 SAY mOCOINI
   @  6, 19 GET mOCOFIM
   @  6, 28 GET mOCOCOD VALID !Empty( mOCOCOD ) .AND. verseha( "FOPTOHOR", 2, mOCOCOD, "NOME", "'Codigo nao Cadastrado'", .T. )
   @  7, 10 GET mMOTIVO VALID ALLTRUE( IF( Empty( mOCOMOT ), mOCOMOT := OBTER( "FOPTOMOT",, mMOTIVO, "NOME" ), "" ) )
   @  8, 1  GET mOCOMOT VALID !Empty( mOCOMOT )
   READCUR()
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO4L()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC tFOPTO4L

// Desenha a Tela
   hb_DispBox( 4, 0, 23, 79, B_DOUBLE + " " )
   @  5, 1 SAY "Numero   Inicio   Fim     Codigo"
   @  7, 1 SAY "Motivo:"
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOPTO_4L2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOPTO_4L2

   CABE2( "FOPTO_4L2 - Lancamento Grupo Troca Horario" )


   cPH := "PH" + ANOMESW
   CHECKCRI( cPH, "FO_PHOR", "STR(NUMERO,8)+DTOS(OCOINI)" )


   CRIARVARS( cPH )
   tFOPTO4l()
   @  6, 10 GET mOCOINI
   @  6, 19 GET mOCOFIM
   @  6, 28 GET mOCOCOD VALID !Empty( mOCOCOD )
   @  8, 1  GET mOCOMOT
   IF !READCUR()
      RETU .F.
   ENDIF
// sele 1
   IF !NETUSE( PES )
      RETU
   ENDIF
   FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
   FILTRO := FILTRO( FILTRO )
   SET FILTER TO &FILTRO
// sele 2
   IF !NETUSE( cPH )
      dbCloseAll()
      RETU
   ENDIF
   SELE 1
   dbGoTop()
   WHILE !Eof()
      mNUMERO := NUMERO
      dbSelectAr( cPH )
      dbGoTop()
      IF !dbSeek( Str( mNUMERO, 8 ) + DToS( mOCOINI ) )
         netrecapp()
      ENDIF
      REPLVARS()
      dbCommit()
      dbSelectAr( pes )
      dbSkip()
   ENDDO
   dbCloseAll()



// + EOF: fopto_4l.prg
// +
