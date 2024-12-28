// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib16.prg
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

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    MLIB16.PRG
// +
// +    Functions: Function ESCARR()       exibe array
// +               Function MEMOVIEW()     exibe variavel de texto geralmente hb_memoread
// +               Function DBFVIEW()      exibe dbf
// +               Function FILEVIEWF()    exibe arquivo de texto carrega texto em array
// +               Function FILEVIEWG()    exibe arquivo de texto readln
// +               Function BASBRO()       usado por escarra,memoview,dbfview,fileviewf,fileviewg
// +
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#include "INKEY.CH"
#include "BOX.CH"

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function ESCARR()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ESCARR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ESCARR( aUSO, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, cROD )

   RETURN BASBRO( aUSO, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, "A", cROD )

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MEMOVIEW()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MEMOVIEW()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MEMOVIEW( cTEXTO, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, cROD )

   RETURN BASBRO( cTEXTO, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, "M", cROD )


// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function DBFVIEW()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DBFVIEW()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION DBFVIEW( aUSO, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, cROD )

   RETURN BASBRO( aUSO, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, "D", cROD )


// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function FILEVIEWF()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FILEVIEWF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FILEVIEWF( cARQ, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, cROD )

   RETURN BASBRO( cARQ, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, "F", cROD )

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function FILEVIEWG()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FILEVIEWG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FILEVIEWG( cARQ, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, cROD )

   RETURN BASBRO( cARQ, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, "G", cROD )


// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function BASBRO()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function BASBRO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION BASBRO( aUSO, nLIN1, nCOL1, nLIN2, nCOL2, nPOS, cCab, cCOR, cTIP, cROD )

   LOCAL nPOSRET := 1
   LOCAL xPOS
   LOCAL cSTRBUS := Space( nCOL2 - nCOL1 - 1 )
   LOCAL GETLIST := {}
   LOCAL aAMB
   PRIV xCOL

   aAMB := SALVAA()
   PRIV cLINHA
   PRIV cARQTMP
   xCOL := 1


   IF cTIP = "A"   // Matriz
      nLEN := Len( aUSO )
   ENDIF
   IF cTIP = "M"   // Memo
      nLEN := MLCount( aUSO )
   ENDIF
   IF cTIP = "D"   // DBF
      nLEN := LastRec()
   ENDIF
   IF cTIP = "F"
      cARQTMP := aUSO
      aUSO    := {}
      IF hb_fuse( cARQTMP, 0 ) < 1
         RETURN
      ENDIF
      nLEN := hb_flastrec()
      zei_fort( nLEN,,, 0 )
      hb_fgotop()
      WHILE !hb_FEof()
         AAdd( aUSO, HB_FREADLN() )
         zei_fort( nLEN,,, 1 )
         hb_fskip( 1 )
      ENDDO
      HB_FUSE()
      cTIP := "A"
   ENDIF
   IF cTIP = "G"
      cARQTMP := aUSO
      IF hb_fuse( cARQTMP, 0 ) < 1
         RETURN
      ENDIF
      nLEN := hb_flastrec()
   ENDIF

   IF nLEN = 0   // Checa a Matriz
      ALERTX( "Elementos Vazios" )
      RETU 0
   ENDIF
   IF ValType( nPOS ) # "N"  // Checa a Posi??o Inicial
      nPOS := 1
   ELSE
      IF nPOS > nLEN .OR. nPOS < 1   // Checa a Posi??o Inicial Passada
         nPOS := 1
      ENDIF
   ENDIF
   IF ValType( cCAB ) # "C"  // Checa o Cabe?ario
      cCAB := "Escolha Sua Opcao"
   ENDIF
   IF ValType( cROD ) # "C"
      cROD := ""
   ENDIF
   IF ValType( cCOR ) # "C"
      cCOR := "W/N,N/W,N,N,N/W"
   ENDIF
   I := nPOS   // Contador Interno para Salto
   IF cTIP = "D"   // .or. cTIP = "F"
      oAB := TBrowseDB( nLIN1 + 3, nCOL1 + 1, nLIN2 - 1, nCOL2 - 1 )
   ELSE
      oAB := TBrowseNew( nLIN1 + 3, nCOL1 + 1, nLIN2 - 1, nCOL2 - 1 )
   ENDIF
   IF cTIP = "D"
      oAC := TBColumnNew( "", {|| &aUSO. } )
   ENDIF
   IF cTIP = "A"
      oAC := TBColumnNew( "", {|| aUSO[ I ] } )
   ENDIF
   IF cTIP = "M"
      oAC := TBColumnNew( "", {|| MemoLine( aUSO,, I ) } )
   ENDIF
   IF cTIP = "G"
      oAC := TBColumnNew( "", {|| fmemoline( I ) } )
   ENDIF


   oAC:WIDTH := nCOL2 - nCOL1 - 1
   oAB:ADDCOLUMN( oAC )
   IF cTIP <> "D"
      oAB:GoTopBlock    := {|| i := 1 }
      oAB:GoBottomBlock := {|| i := nLen }
      oAB:SkipBlock     := {| n, nSavei | nSavei := i, i := if( n > 0, Min( nLEN, i + n ), Max( 1, i + n ) ), i - nsavei }
   ENDIF

// Coloca a Barra de Trabalho
   PRIV nSBAR
   PRIV aSBAR
   aSBAR := ScrollBarNew( nLIN1 + 3, nCOL2, nLIN2 - 1, SubStr( cCOR, RAt( ",", cCOR ) + 1 ) )
   hb_DispBox( nLIN1, nCOL1, nLIN2, nCOL2, B_DOUBLE + " " )
   @ nLIN1 + 1, nCOL1 + 2 SAY cCAB
   @ nLIN1 + 1, nCOL2   SAY "|"
   @ nLIN1 + 2, nCOL1   SAY '|' + Replicate( '-', nCOL2 - nCOL1 - 1 ) + '|'
   @ nLIN1 + 2, nCOL1   SAY "|"
   @ nLIN1 + 2, nCOL2   SAY "|"
   @ nLIN2, nCOL2     SAY "|"
   ScrollBarDisplay( aSBAR )
   NOBREAK()
   SetCursor( 0 )
   WHILE .T.
      // Enquanto n?o estabiliza, aguarda uma tecla.
      WHILE ( !oAB:STABILIZE() )
         nKEY := HOTINKEY()
         IF nKEY != 0
            EXIT
         ENDIF
      ENDDO

      nMOVE := 0
      IF oAB:STABLE  // Se objeto j  est vel...
         nROW := Row()   // Salva a columa pois ScrollUpadate muda
         ScrollBarUpdate( aSBAR, I, nLEN, .T. )
         nKEY := 0
         WHILE nKEY = 0
            nKEY := HOTINKEY()
            nKEY := LERMOUSE( nKEY )
            IF MOUSE_B = 1 .AND. MOUSE_Y > nLIN1 + 3 .AND. MOUSE_Y < nLIN2 - 1 .AND. MOUSE_X # nCOL2 .AND. nROW # MOUSE_Y
               IF MOUSE_Y < nROW
                  nKEY  := 255   // Apenas Para Sair do Loop e marcar subir
                  nMOVE := nROW - MOUSE_Y
               ELSE
                  nKEY  := 254   // Apenas Para Sair do Loop e marcar descer
                  nMOVE := MOUSE_Y - nROW
               ENDIF
            ENDIF
            IF MOUSE_B = 1
               DO CASE
               CASE MOUSE_Y = nROW .AND. MOUSE_X # nCOL2
                  nKEY := K_ENTER
               CASE MOUSE_Y = nLIN1 + 1 .AND. MOUSE_X = nCOL2
                  nKEY := K_CTRL_ENTER
               CASE MOUSE_Y = nLIN1 + 2 .AND. MOUSE_X = nCOL1
                  nKEY := K_ENTER
               CASE MOUSE_Y = nLIN1 + 2 .AND. MOUSE_X = nCOL2
                  nKEY := K_HOME
               CASE MOUSE_Y = nLIN2 .AND. MOUSE_X = nCOL2
                  nKEY := K_END
               CASE MOUSE_Y = nLIN1 + 3 .AND. MOUSE_X = nCOL2
                  nKEY := K_UP
               CASE MOUSE_Y = nLIN2 - 1 .AND. MOUSE_X = nCOL2
                  nKEY := K_DOWN
               OTHERWISE
                  FOR x := nLIN1 + 4 TO nLIN2 - 2
                     IF MOUSE_X = nCOL2 .AND. MOUSE_Y = X
                        IF MOUSE_Y < Int( ( nLIN2 - 2 - nLIN1 - 4 ) / 2 ) + nLIN1 + 4
                           nkey := K_PGUP
                        ELSE
                           nkey := K_PGDN
                        ENDIF
                     ENDIF
                  NEXT x
               ENDCASE
            ENDIF
         ENDDO
      ENDIF

      // Saltar
      IF nMOVE > 0
         IF nKEY = 255
            FOR X := 1 TO nMOVE
               oAB:UP()  // Cursor para cima.
            NEXT X
         ELSE
            FOR X := 1 TO nMOVE
               oAB:DOWN()  // Cursor para baixo.
            NEXT X
         ENDIF
         nKEY := 0   // Zera o Inkey Evitar Conflito
      ENDIF

      // Teclas Deslocamento do Objeto TBrowse.
      DO CASE
      CASE nKEY == K_UP  // Cursor para cima.
         oAB:UP()
      CASE nKEY == K_DOWN  // Cursor para baixo.
         oAB:DOWN()
      CASE nKEY == K_HOME  // Cursor para posi??o inicial da tela. oAB:home()
         oAB:GOTOP()
      CASE nKEY == K_END   // Cursor para posi??o final da tela. oAB:end()
         oAB:GOBOTTOM()
      CASE nKEY == K_PGUP  // Move cursor uma p gina de tela para cima.
         oAB:PAGEUP()
      CASE nKEY == K_PGDN  // Move cursor uma p gina de tela para baixo.
         oAB:PAGEDOWN()
      CASE nKEY == K_CTRL_PGUP   // Move cursor para o primeiro registro.
         oAB:GOTOP()
      CASE nKEY == K_CTRL_PGDN   // Move cursor para o њltimo registro.
         oAB:GOBOTTOM()
      CASE nKey == K_RIGHT
         oAB:Right()
         xCOL++
         oAB:REFRESHALL()
      CASE nKey == K_LEFT
         oAB:Left()
         IF xCOL > 1
            xCOL--
         ENDIF
         oAB:REFRESHALL()
      CASE nKey == K_ALT_RIGHT
         oAB:Right()
         xCOL := XCOL + 20
         oAB:REFRESHALL()
      CASE nKey == K_ALT_LEFT
         oAB:Left()
         xCOL := XCOL - 20
         IF xCOL < 1
            xcol := 1
         ENDIF
         oAB:REFRESHALL()
      CASE nKey == K_CTRL_LEFT
         oAB:panLeft()
         xCOL := 1
         oAB:REFRESHALL()
      CASE nKey == K_CTRL_RIGHT
         oAB:panRight()
      CASE nKey == K_CTRL_HOME
         oAB:panHome()
      CASE nKey == K_CTRL_END
         oAB:panEnd()
      ENDCASE






      // Informa o in­cio ou o fim do arquivo (ou fonte de dados).
      DO CASE
      CASE oAB:HITTOP
         @ MaxRow(), 00 SAY " Voce ja esta no primeiro item !"
      CASE oAB:HITBOTTOM
         @ MaxRow(), 00 SAY " Voce ja esta no ultimo item !"
      OTHERWISE
         @ MaxRow(), 00 SAY cROD
      ENDCASE

      IF oAB:STABLE
         DO CASE
         CASE nKEY = K_ENTER
            nPOSRET := I
            EXIT
         CASE nKEY = K_ALT_ENTER
            nPOSRET := I
            EXIT
         CASE nKEY = K_ESC
            nPOSRET := 0
            EXIT
         CASE nKEY = K_ALT_F10
            nPOSRET := I
            EXIT
         ENDCASE
      ENDIF

      IF cTIP = "D"
         // Letra Minuscula Vira Maiscula
         IF nKEY > 96 .AND. nKEY < 123
            nKEY := Asc( Upper( Chr( nKEY ) ) )
         ENDIF
         IF nKEY > 64 .AND. nKEY < 91
            nREG := RecNo()
            OAB:GOTOP()
            IF !dbSeek( Chr( nKEY ) )
               dbskipex( - 1 )   // O Mais Proximo e o anterior
            ENDIF
            nREG := RecNo()
            dbGoto( nREG )
            oAB:REFRESHALL()
         ENDIF
      ENDIF

      IF cTIP = "A"  // Pesquisa Array
         xPOS := 0   // Zera Variavel de Referencia

         // Letra Minuscula Vira Maiscula
         IF nKEY > 96 .AND. nKEY < 123
            nKEY := Asc( Upper( Chr( nKEY ) ) )
         ENDIF

         // Pesquisa Letra Digitada
         IF nKEY > 64 .AND. nKEY < 91
            xPOS := AScan( aUSO, {| x | Upper( x ) = Chr( nKEY ) } )
         ENDIF

         // Pesquisa Solicitada CTRL+ENTER
         IF nKEY = K_CTRL_ENTER
            SetCursor( 1 )
            cSTRBUS := PadR( cSTRBUS, nCOL2 - nCOL1 - 1 )
            @ MaxRow(), 00 SAY "Buscar Por"
            @ MaxRow(), 20 GET cSTRBUS
            READ
            cSTRBUS := Upper( AllTrim( cSTRBUS ) )
            SetCursor( 0 )
            @ MaxRow(), 00
            IF !Empty( cSTRBUS )
               xPOS := AScan( aUSO, {| x | Upper( x ) = cSTRBUS } )
            ENDIF
         ENDIF

         IF xPOS > 0
            I := xPOS
            oAB:REFRESHALL()
         ENDIF

      ENDIF

   ENDDO
   RESTAA( aAMB )
   IF cTIP = "G"
      HB_FUse()
   ENDIF

   RETURN nPOSRET


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fmemoline()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fmemoline( nPOS )

   hb_fgoto( nPOS )
   cLINHA := HB_FREADLN()
   cLINHA := SubStr( cLINHA, xCOL )

   RETURN cLINHA



// + EOF: MLIB16.PRG

// + EOF: mlib16.prg
// +
