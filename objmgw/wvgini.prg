// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : wvgini.prg
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
// +    Documentado em 28-Dez-2024 as 10:42 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

#include "HBGTINFO.CH"
#include "INKEY.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MVINFOConfTela()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MVINFOConfTela( cAPPName )   // ajusta tamanho da tela

   LOCAL nWidth := hb_gtInfo( HB_GTI_DESKTOPWIDTH )

   LOCAL nHeight := hb_gtInfo( HB_GTI_DESKTOPHEIGHT )

   IF ValType( cAPPName ) = "C"
      hb_gtInfo( HB_GTI_WINTITLE, cAPPName )
   ENDIF
   hb_gtInfo( HB_GTI_FONTNAME, "Lucida Console" )   // fonte
   hb_gtInfo( HB_GTI_SELECTCOPY, .T. )
   hb_gtInfo( HB_GTI_RESIZABLE, .T. )
   hb_gtInfo( HB_GTI_ISFULLSCREEN, .F. )  // .t. nao aparece _x barra de titulo
   hb_gtInfo( HB_GTI_CLOSABLE, .T. )
   hb_gtInfo( HB_GTI_MAXIMIZED, .T. )   // starts in Maximized Window
   hb_gtInfo( HB_GTI_ALTENTER, .T. )  // allow <Alt-Enter> for full screen  //hb_keyput(K_ALT_ENTER) apos o clean abaixo
   hb_gtInfo( HB_GTI_CLOSEMODE, 1 )   // 1 - sends HB_K_CLOSE on Window x-Close

   SetKey( K_CTRL_V, {|| __Keyboard( hb_gtInfo( HB_GTI_CLIPBOARDDATA ) ) } )

   IF nWidth = 1024 .AND. nHeight = 768

      Wvt_SetFont( "Lucida Console", 28, 12, 0 )

   ELSEIF nWidth = 1152 .AND. nHeight = 864

      Wvt_SetFont( "Lucida Console", 31, 13, 0 )

   ELSEIF nWidth = 1280 .AND. nHeight = 600

      Wvt_SetFont( "Lucida Console", 21, 15, 0 )

   ELSEIF nWidth = 1280 .AND. nHeight = 720

      Wvt_SetFont( "Lucida Console", 26, 15, 0 )

   ELSEIF nWidth = 1280 .AND. nHeight = 768

      Wvt_SetFont( "Lucida Console", 28, 15, 0 )

   ELSEIF nWidth = 1280 .AND. nHeight = 960

      Wvt_SetFont( "Lucida Console", 35, 15, 0 )

   ELSEIF nWidth = 1280 .AND. nHeight = 1024

      Wvt_SetFont( "Lucida Console", 38, 15, 0 )

   ELSEIF nWidth = 1400 .AND. nHeight = 1050

      Wvt_SetFont( "Lucida Console", 39, 16, 0 )

   ELSE  // se nenhuma anterior, seta padrao

      Wvt_SetFont( "Lucida Console", 28, 12, 0 )

   ENDIF
   Wvt_Maximize()

   RETURN NIL

// + EOF: wvgini.prg
// +
