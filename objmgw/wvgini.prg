#INCLUDE "HBGTINFO.CH"
#INCLUDE "INKEY.CH"

Function MVINFOConfTela(cAPPName)  // ajusta tamanho da tela
 Local nWidth := Hb_GtInfo(HB_GTI_DESKTOPWIDTH)

 Local nHeight := Hb_GtInfo(HB_GTI_DESKTOPHEIGHT)
 
if valtype(cAPPName) ="C"
   hb_gtInfo( HB_GTI_WINTITLE,cAPPName )
endif   
HB_GtInfo( HB_GTI_FONTNAME, "Lucida Console" ) // fonte
Hb_GtInfo( HB_GTI_SELECTCOPY,.T.)
Hb_GtInfo( HB_GTI_RESIZABLE, .T. )
HB_GtInfo( HB_GTI_ISFULLSCREEN, .f. )  //.t. nao aparece _x barra de titulo
HB_GTINFO( HB_GTI_CLOSABLE, .T. )
HB_GtInfo( HB_GTI_MAXIMIZED, .T. ) //starts in Maximized Window
hb_gtInfo( HB_GTI_ALTENTER, .T. )   // allow <Alt-Enter> for full screen  //hb_keyput(K_ALT_ENTER) apos o clean abaixo
hb_gtInfo( HB_GTI_CLOSEMODE, 1 )    // 1 - sends HB_K_CLOSE on Window x-Close
 
SetKey( K_CTRL_V     , {|| __Keyboard( hb_gtInfo( HB_GTI_CLIPBOARDDATA ) ) } ) 
 
 If nWidth = 1024 .And. nHeight = 768

 Wvt_SetFont( "Lucida Console", 28, 12, 0 )

 ElseIf nWidth = 1152 .And. nHeight = 864

  Wvt_SetFont( "Lucida Console", 31, 13, 0 )

 ElseIf nWidth = 1280 .And. nHeight = 600

  Wvt_SetFont( "Lucida Console", 21, 15, 0 )

 ElseIf nWidth = 1280 .And. nHeight = 720

 Wvt_SetFont( "Lucida Console", 26, 15, 0 )

 ElseIf nWidth = 1280 .And. nHeight = 768

  Wvt_SetFont( "Lucida Console", 28, 15, 0 )

 ElseIf nWidth = 1280 .And. nHeight = 960

  Wvt_SetFont( "Lucida Console", 35, 15, 0 )

 ElseIf nWidth = 1280 .And. nHeight = 1024

  Wvt_SetFont( "Lucida Console", 38, 15, 0 )

 ElseIf nWidth = 1400 .And. nHeight = 1050

  Wvt_SetFont( "Lucida Console", 39, 16, 0 )

 Else  // se nenhuma anterior, seta padrao

  Wvt_SetFont( "Lucida Console", 28, 12, 0 )

 EndIf
 Wvt_Maximize()

Return Nil
