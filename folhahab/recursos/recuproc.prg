// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : recuproc.prg
// +
// +
// +--------------------------------------------------------------------
// +

#include "INKEY.CH"

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABE2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CABE2( TITULO )  // CABECARIO PARA OS MENUS

   SetColor( "N/W" )
   @ 06, 04 CLEA TO 06, 74
   @ 06, 06 SAY TITULO
   SetColor( "W/N,N/W" )
   RETU ( .T. )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABE3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CABE3( TITULO, QT )   // CABECARIO PARA OS MENUS

   SetColor( "W/N" )
   @ 04, 01 CLEA TO 04, 78
   @ 06, 01 CLEA TO 06, 78
   @ 08, 00 CLEA
   SetColor( "N/W" )
   @ 04, 04 CLEA TO 04, 74
   @ 04, 04 SAY TITULO
   SetColor( "+GR/BG" )
   @ 08, 21 CLEA TO QT, 58
   @ 08, 21 TO QT, 58 DOUB
   RETU ( .T. )


// !*****************************************************************************
// !
// !       NSHOW
// !
// !    Chamado por: NSHOW1()           (fun‡„o    em RECUPROC.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NSHOW()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION NSHOW  // AVISA QUE O ARQUIVO ESTA VAZIO

   SetColor( "W/N" )
   @  8, 0 CLEAR
   SetColor( "+W/BR" )
   @  9, 0 TO 11, 79 DOUB
   SetColor( "N/W" )
   @ 10, 1 SAY SPAC( 33 ) + 'Arquivo vazio' + SPAC( 32 )
   SetColor( "+W/BR" )
   Inkey( 0 )

   RETURN .T.


// !*****************************************************************************
// !
// !         Funcao: ARQ()
// !
// !    Chamado por: CA()               (funcao    em RECUETI2.PRG, chamado  no Dbedit())
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ARQ()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ARQ( NOMEARQ )   // VERIFICA A EXISTENCIA DE UM ARQUIVO

   IF NOMEARQ = SPAC( 25 )
      MDT( "NOME DO ARQUIVO NAO PODE SER VAZIO" )
      RETU ( .F. )
   ENDIF
   memvar->NOMEARX := AllTrim( NOMEARQ ) + '.DBF'
   IF !File( memvar->NOMEARX )
      MDT( "ESTE ARQUIVO NAO EXISTE - VERIFIQUE !" )
      RETU ( .F. )
   ENDIF
   RETU ( .T. )



// !*****************************************************************************
// !
// !         Funcao: NSHOW1()
// !
// !    Chamado por: EDITA2             (  em RECUETI1.PRG)
// !               : EDITA              (  em RECUETI2.PRG)
// !               : RECUSER3.PRG
// !
// !          Chama: NSHOW              ( em RECUPROC.PRG)
// !
// !*****************************************************************************

FUNCTION NSHOW1   // VERIFICA SE O ARQUIVO ESTA VAZIO ANTES DO DBEDIT

   IF Eof()
      // CLEAR TYPEAHEAD
      hb_keyClear()
      NSHOW()
      IF LastKey() = 13
         NETRECAPP()
         KEYBOARD Chr( 22 )
      ELSE
         RETU ( .F. )
      ENDIF
   ENDIF
   RETU ( .T. )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MDI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION MDI( cVAR )

   CABE2( cVAR )
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function COR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION COR

   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABEX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CABEX( cVAR )

   CABE2( cVAR )

   RETURN .T.



// + FIM : recuproc.prg
// +
