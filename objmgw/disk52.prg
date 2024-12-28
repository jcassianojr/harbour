// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disk52.prg
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
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Source Module => DISK52.PRG
// +
// +    Functions: Function HELP()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#include "INKEY.CH"

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function HELP()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function HELP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC HELP( programa, linha, variavel )  // F1- AJUDA AO USUARIO

   LOCAL aAMBIENTE

   IF Empty( HELPARQ )
      ALERTX( "HELP: Variavel HelpARQ Em Branco" )
      RETU .T.
   ENDIF

   IF programa = "MEMOEDIT" .OR. programa = "HELP"
      RETU .T.
   ENDIF
   IF Type( "HELPDBF" ) = "C" .AND. programa # "ERRO" .AND. PROGRAMA # "ERRODOS"
      helppos := helpdbf
   ELSE
      helppos := programa
   ENDIF
   helppos  := PadR( helppos, 8 )
   variavel := PadR( variavel, 10 )

   aAMBIENTE := SALVAA()

   IF !netuse( HELPARQ )
      restaa( aAMBIENTE )
      RETU .T.
   ENDIF
   dbGoTop()
   IF !dbSeek( helppos + variavel )
      netrecapp()
      field->dbf   := helppos
      field->campo := variavel
      field->dado  := variavel
   ENDIF
   IF Empty( ARQUIVO )
      HLP_DESC := DESCRICAO
   ELSE
      HLP_DESC := hb_MemoRead( hb_cwd() + "MAN\" + ARQUIVO )
   ENDIF
   HLP_DADO := DADO
   IF Empty( HLP_DADO )
      HLP_DADO := "Nao Cadastrado"
   ENDIF
   IF Empty( HLP_DESC )
      HLP_DESC := HLP_DADO
   ENDIF
   dbCloseArea()
   MEMOVIEW( HLP_DESC, 02, 00, MaxRow() - 2, MaxCol(),, HLP_DADO, "W/N,N/W,N,N,N/W" )
   restaa( aAMBIENTE )
   RETU .T.




// + EOF: DISK52.PRG

// + EOF: disk52.prg
// +
