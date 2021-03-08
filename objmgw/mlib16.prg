*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    MLIB16.PRG
*+
*+    Functions: Function ESCARR()       exibe array
*+               Function MEMOVIEW()     exibe variavel de texto geralmente hb_memoread
*+               Function DBFVIEW()      exibe dbf
*+               Function FILEVIEWF()    exibe arquivo de texto carrega texto em array
*+               Function FILEVIEWG()    exibe arquivo de texto readln
*+               Function BASBRO()       usado por escarra,memoview,dbfview,fileviewf,fileviewg
*+
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "INKEY.CH"
#INCLUDE "BOX.CH"

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function ESCARR()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function ESCARR( aUSO, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, cROD )
return BASBRO( aUSO, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, "A", cROD )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MEMOVIEW()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function MEMOVIEW( cTEXTO, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, cROD )
return BASBRO( cTEXTO, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, "M", cROD )


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function DBFVIEW()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function DBFVIEW( aUSO, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, cROD )
return BASBRO( aUSO, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, "D", cROD )


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function FILEVIEWF()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function FILEVIEWF( cARQ, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, cROD )
return BASBRO( cARQ, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, "F", cROD )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function FILEVIEWG()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function FILEVIEWG( cARQ, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, cROD )
return BASBRO( cARQ, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, "G", cROD )


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function BASBRO()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function BASBRO( aUSO, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, cTIP, cROD )
local nPOSRET := 1
local xPOS
local cSTRBUS := space( nCOL2 - nCOL1 - 1 )
local GETLIST := {}
local aAMB
PRIV xCOL

aAMB:=SALVAA()
PRIV cLINHA
priv cARQTMP
xCOL:=1


if cTIP = "A"       //Matriz
   nLEN := len( aUSO )
endif
if cTIP = "M"       //Memo
   nLEN := mlcount( aUSO )
endif
if cTIP = "D"       //DBF
   nLEN := lastrec()
endif
IF cTIP = "F"
   cARQTMP:=aUSO
   aUSO:={}
   IF hb_fuse( cARQTMP, 0 )<1
      RETURN
   ENDIF
   nLEN := hb_flastrec()
   zei_fort( nLEN,,,0)
   hb_fgotop()
   while ! hb_feof()
       AADD(aUSO,HB_FREADLN())
       zei_fort(nLEN,,,1)
       hb_fskip(1)
   enddo
   HB_FUSE()
   cTIP ="A"
ENDIF
IF cTIP = "G"
   cARQTMP:=aUSO
   IF hb_fuse( cARQTMP, 0 )<1
      RETURN
   ENDIF
   nLEN := hb_flastrec()
ENDIF

if nLEN = 0         //Checa a Matriz
   ALERTX( "Elementos Vazios" )
   retu 0
endif
if valtype( nPOS ) # "N"                //Checa a Posi??o Inicial
   nPOS := 1
else
   if nPOS > nLEN .or. nPOS < 1         //Checa a Posi??o Inicial Passada
      nPOS := 1
   endif
endif
if valtype( cCAB ) # "C"                //Checa o Cabe?ario
   cCAB := "Escolha Sua Opcao"
endif
if valtype( cROD ) # "C"
   cROD := ""
endif
if valtype( cCOR ) # "C"
   cCOR := "W/N,N/W,N,N,N/W"
endif
I   := nPOS         //Contador Interno para Salto
IF cTIP="D" //.or. cTIP = "F"
  oAB := tbrowsedb(  nLIN1 + 3, nCOL1 + 1, nLIN2 - 1, nCOL2 - 1 )
ELSE
  oAB := tbrowsenew( nLIN1 + 3, nCOL1 + 1, nLIN2 - 1, nCOL2 - 1 )
ENDIF
IF cTIP="D"
   oAC := tbcolumnnew( "", { || &aUSO. })
ENDIF
if cTIP = "A"
   oAC := tbcolumnnew( "", { || aUSO[ I ] } )
endif
if cTIP = "M"
   oAC := tbcolumnnew( "", { || memoline( aUSO,, I ) } )
endif
if cTIP = "G"
   oAC := tbcolumnnew( "", { || fmemoline( I ) } )
endif


oAC:WIDTH := nCOL2 - nCOL1 - 1
oAB:ADDCOLUMN( oAC )
if cTIP <> "D"
   oAB:GoTopBlock    := { || i := 1 }
   oAB:GoBottomBlock := { || i := nLen }
   oAB:SkipBlock     := { | n, nSavei | nSavei := i, i := if( n > 0, min( nLEN, i + n ), max( 1, i + n ) ), i - nsavei }
ENDIF

//Coloca a Barra de Trabalho
priv nSBAR
priv aSBAR
aSBAR := ScrollBarNew( nLIN1 + 3, nCOL2, nLIN2 - 1, substr( cCOR, rat( ",", cCOR ) + 1 ) )
HB_dispbox( nLIN1, nCOL1, nLIN2, nCOL2, B_DOUBLE +" ")
@ nLIN1 + 1, nCOL1 + 2 say cCAB
@ nLIN1 + 1, nCOL2     say "|"
@ nLIN1 + 2, nCOL1     say '|' + replicate( '-', nCOL2 - nCOL1 - 1 ) + '|'
@ nLIN1 + 2, nCOL1     say "|"
@ nLIN1 + 2, nCOL2     say "|"
@ nLIN2, nCOL2         say "|"
ScrollBarDisplay( aSBAR )
NOBREAK()
setcursor( 0 )
while .T.
   //Enquanto n?o estabiliza, aguarda uma tecla.
   while ( !oAB:STABILIZE() )
      nKEY := HOTINKEY()
      if nKEY != 0
         exit
      endif
   enddo

   nMOVE := 0
   if oAB:STABLE    //Se objeto j  est vel...
      nROW := row()                     //Salva a columa pois ScrollUpadate muda
      ScrollBarUpdate( aSBAR, I, nLEN, .T. )
      nKEY := 0
      while nKEY = 0
         nKEY := HOTINKEY()
         nKEY := LERMOUSE( nKEY )
         if MOUSE_B = 1 .and. MOUSE_Y > nLIN1 + 3 .and. MOUSE_Y < nLIN2 - 1 .and. MOUSE_X # nCOL2 .and. nROW # MOUSE_Y
            if MOUSE_Y < nROW
               nKEY  := 255             //Apenas Para Sair do Loop e marcar subir
               nMOVE := nROW - MOUSE_Y
            else
               nKEY  := 254             //Apenas Para Sair do Loop e marcar descer
               nMOVE := MOUSE_Y - nROW
            endif
         endif
         if MOUSE_B = 1
            do case
            case MOUSE_Y = nROW .and. MOUSE_X # nCOL2
               nKEY := K_ENTER
            case MOUSE_Y = nLIN1 + 1 .and. MOUSE_X = nCOL2
               nKEY := K_CTRL_ENTER
            case MOUSE_Y = nLIN1 + 2 .and. MOUSE_X = nCOL1
               nKEY := K_ENTER
            case MOUSE_Y = nLIN1 + 2 .and. MOUSE_X = nCOL2
               nKEY := K_HOME
            case MOUSE_Y = nLIN2 .and. MOUSE_X = nCOL2
               nKEY := K_END
            case MOUSE_Y = nLIN1 + 3 .and. MOUSE_X = nCOL2
               nKEY := K_UP
            case MOUSE_Y = nLIN2 - 1 .and. MOUSE_X = nCOL2
               nKEY := K_DOWN
            otherwise
               for x := nLIN1 + 4 to nLIN2 - 2
                  if MOUSE_X = nCOL2 .and. MOUSE_Y = X
                     if MOUSE_Y < int( ( nLIN2 - 2 - nLIN1 - 4 ) / 2 ) + nLIN1 + 4
                        nkey := K_PGUP
                     else
                        nkey := K_PGDN
                     endif
                  endif
               next x
            endcase
         endif
      enddo
   endif

   //Saltar
   if nMOVE > 0
      if nKEY = 255
         for X := 1 to nMOVE
            oAB:UP()                    //Cursor para cima.
         next X
      else
         for X := 1 to nMOVE
            oAB:DOWN()                  //Cursor para baixo.
         next X
      endif
      nKEY := 0     //Zera o Inkey Evitar Conflito
   endif

   //Teclas Deslocamento do Objeto TBrowse.
   do case
       case nKEY == K_UP                    //Cursor para cima.
          oAB:UP()
       case nKEY == K_DOWN                  //Cursor para baixo.
          oAB:DOWN()
       case nKEY == K_HOME                  //Cursor para posi??o inicial da tela. oAB:home()
          oAB:GOTOP()
       case nKEY == K_END                   //Cursor para posi??o final da tela. oAB:end()
          oAB:GOBOTTOM()
       case nKEY == K_PGUP                  //Move cursor uma p gina de tela para cima.
          oAB:PAGEUP()
       case nKEY == K_PGDN                  //Move cursor uma p gina de tela para baixo.
          oAB:PAGEDOWN()
       case nKEY == K_CTRL_PGUP             //Move cursor para o primeiro registro.
          oAB:GOTOP()
       case nKEY == K_CTRL_PGDN             //Move cursor para o њltimo registro.
          oAB:GOBOTTOM()
       CASE nKey == K_RIGHT
            oAB:right()
            xCOL++
            oAB:REFRESHALL()
       CASE nKey == K_LEFT
            oAB:left()
            IF xCOL>1
               xCOL--
            ENDIF   
            oAB:REFRESHALL()
       CASE nKey == K_ALT_RIGHT 
            oAB:right()
            xCOL:=XCOL+20
            oAB:REFRESHALL()
       CASE nKey == K_ALT_LEFT 
            oAB:left()
            xCOL:=XCOL-20
            IF xCOL<1
               xcol:=1
            ENDIF   
            oAB:REFRESHALL()             
       CASE nKey == K_CTRL_LEFT 
            oAB:panLeft() 
            xCOL:=1         
            oAB:REFRESHALL()  
       CASE nKey == K_CTRL_RIGHT 
            oAB:panRight()            
       CASE nKey == K_CTRL_HOME  
            oAB:panHome()
       CASE nKey == K_CTRL_END   
            oAB:panEnd()
   endcase






   //Informa o in­cio ou o fim do arquivo (ou fonte de dados).
   do case
   case oAB:HITTOP
      @ MAXROW(), 00 say " Voce ja esta no primeiro item !"
   case oAB:HITBOTTOM
      @ MAXROW(), 00 say " Voce ja esta no ultimo item !"
   otherwise
      @ MAXROW(), 00 say cROD
   endcase

   if oAB:STABLE
      do case
      case nKEY = K_ENTER
         nPOSRET := I
         exit
      case nKEY = K_ALT_ENTER
         nPOSRET := I
         exit
      case nKEY = K_ESC
         nPOSRET := 0
         exit
      case nKEY = K_ALT_F10
         nPOSRET := I
         exit
      endcase
   endif

   if cTIP="D"
      // Letra Minuscula Vira Maiscula
      if nKEY > 96 .and. nKEY < 123
         nKEY := asc( upper( chr( nKEY ) ) )
      endif
      if nKEY > 64 .and. nKEY < 91
         nREG    := recno()
         OAB:GOTOP()
         IF ! dbseek( CHR(nKEY) )
            dbskipex(-1) //O Mais Proximo e o anterior
         ENDIF
         nREG := recno()
         dbgoto( nREG )
         oAB:REFRESHALL()
      ENDIF
   ENDIF

   if cTIP = "A"    //Pesquisa Array
      xPOS := 0     //Zera Variavel de Referencia

      // Letra Minuscula Vira Maiscula
      if nKEY > 96 .and. nKEY < 123
         nKEY := asc( upper( chr( nKEY ) ) )
      endif

      // Pesquisa Letra Digitada
      if nKEY > 64 .and. nKEY < 91
         xPOS := ascan( aUSO, { | x | upper( x ) = chr( nKEY ) } )
      endif

      // Pesquisa Solicitada CTRL+ENTER
      if nKEY = K_CTRL_ENTER
         setcursor( 1 )
         cSTRBUS := padr( cSTRBUS, nCOL2 - nCOL1 - 1 )
         @ MAXROW(), 00 say "Buscar Por"
         @ MAXROW(), 20 get cSTRBUS
         read
         cSTRBUS := upper( alltrim( cSTRBUS ) )
         setcursor( 0 )
         @ MAXROW(), 00
         if !empty( cSTRBUS )
            xPOS := ascan( aUSO, { | x | upper( x ) = cSTRBUS } )
         endif
      endif

      if xPOS > 0
         I := xPOS
         oAB:REFRESHALL()
      endif

   endif

enddo
RESTAA(aAMB)
if cTIP = "G"
   HB_FUse()
ENDIF
return nPOSRET

function fmemoline(nPOS)
hb_fgoto(nPOS)
cLINHA:=HB_FREADLN()
cLINHA:=SUBSTR(cLINHA,xCOL)
return cLINHA



*+ EOF: MLIB16.PRG
