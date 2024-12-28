// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib11.prg
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
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +
// +
// +--------------------------------------------------------------------
// +



// cARQ-> Arquivo de Trbalho
// aREP-> Matriz Multidimensional de troca Chave Ou Blocco
// aCOR-> Matriz Com as Cores
// bVID-> Bloco com String Para a Barra de Rolagem
// bTEL-> Bloco Para Exibi‡„o da Tela
// bGET-> Bloco Para Edi‡„o da mVARS
// bCHA-> Bloco Para Chaves especias
// bAUX-> Bloco para Processor Teclas N„o Padr„o Opcional
// wVAR-> Variavel de Controle Tecla Enter
// cCAB-> String de Cabe‡ario Opcional
// cROD-> Stirng de Rodap‚ Opcional
// bAU2-> Bloco Para Tecla enter Alternativa
// eINI-> Express„o Inicial do Seek
// bINS-> Bloco Apos Insert
// bpos-> Bloco Apos troca vars
// bequ-> Bloco Apos igual vars
// bdel-> Blobo Apos Delete


#include "INKEY.CH"
#include "BOX.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function METBRO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC METBRO( cARQ, aREP, aCOR, bVID, bTEL, bGET, bCHA, bAUX, wVAR, cCAB, cROD, bAU2, eINI, bINS, bPOS, bEQU, bDEL, eFILTRO )

   LOCAL cTELA

   IF ValType( cROD ) # "C"
      cROD := "INS=Novo DEL=Apaga Enter=Altera Ctrl+ENTER=Busca Alt+F10=Listar" + spac( 16 ) + "Ý"
   ENDIF
   nIND := if( lPIND, NUMIND( cARQ ), nIEXI )
   SetCursor( 0 )
   IF !USEREDE( cARQ, 1, 99 )
      RETU .F.
   ENDIF
   IF ValType( eFILTRO ) = "C" .AND. !Empty( eFILTRO )
      SET FILTER TO &eFILTRO.
   ENDIF

// Tela Basica
   SetColor( aCOR[ 1 ] )
   hb_DispBox( 2, 0, 24 - 1, 79, B_DOUBLE )
   IF ValType( cCAB ) = "C"
      @ 03, 1 SAY cCAB
   ELSE
      @ 03, 1 SAY cCBAS
   ENDIF
   @  4, 0 SAY '+' + Replicate( '-', 77 ) + 'TÝ'
   SetColor( aCOR[ 1 ] )

// Inicia o TBROWSE
   oTB        := TBrowseDB( 05, 01, 24 - 2, 78 )
   ocTB       := TBColumnNew( "", bVID )
   ocTB:WIDTH := 78
   oTB:ADDCOLUMN( ocTB )

// Coloca a Barra de Trabalho
   PRIV nSBAR
   PRIV aSBAR
   nSBAR := LastRec()
   aSBAR := ScrollBarNew( 04, 79, 24 - 1, SubStr( aCOR[ 1 ], RAt( ",", aCOR[ 1 ] ) + 1 ) )
   ScrollBarDisplay( aSBAR )

// Inicia o LOOP
   dbSetOrder( nIND )
   dbGoTop()
   IF ValType( eINI ) # "U"
      dbSeek( eINI )
      IF Eof()
         dbGoTop()
      ENDIF
   ENDIF
   WHILE .T.
      dbSelectAr( cARQ )
      @  3, 79 SAY "Ý"
      MDS( cROD )
      // Enquanto n„o estabiliza, aguarda uma tecla.
      WHILE ( !oTB:STABILIZE() )
         nKEY := HOTINKEY()
         IF nKEY != 0
            EXIT
         ENDIF
      ENDDO
      nMOVE := 0
      IF oTB:STABLE  // Se objeto j  est vel...
         ScrollBarUpdate( aSBAR, ( oTB:ROWPOS + 4 ), nSBAR, .T. )
         nKEY  := 0
         nMOVE := 0
         WHILE nKEY = 0
            nKEY := HOTINKEY()
            nKEY := LERMOUSE( nKEY )
            DO CASE
            CASE MOUSE_B = 1 .AND. MOUSE_Y = 4
               nKEY := K_UP
            CASE MOUSE_B = 1 .AND. MOUSE_Y = 23
               nKEY := K_DOWN
            CASE MOUSE_B = 2
               nKEY := K_ESC
            CASE MOUSE_Y = 1 .AND. MOUSE_B = 1 .AND. MOUSE_X < 4
               nKEY := K_ESC
            CASE MOUSE_B = 1 .AND. ( oTB:ROWPOS + 4 ) = MOUSE_Y .AND. MOUSE_X # 79
               nKEY := K_ENTER
            ENDCASE
            IF MOUSE_X = MaxCol() - 1 .AND. MOUSE_B = 1
               DO CASE
               CASE MOUSE_Y = 03
                  nKEY := K_HOME
               CASE MOUSE_Y >= 5 .AND. MOUSE_Y <= 13
                  nKEY := K_PGUP
               CASE MOUSE_Y >= 14 .AND. MOUSE_Y <= 22
                  nKEY := K_PGDN
               CASE MOUSE_Y = 24
                  nKEY := K_END
               ENDCASE
            ENDIF
            IF MOUSE_Y = MaxRow() .AND. MOUSE_B = 1
               DO CASE
               CASE MOUSE_X > 00 .AND. MOUSE_X < 07
                  nKEY := K_INS
               CASE MOUSE_X > 09 .AND. MOUSE_X < 17
                  nKEY := K_DEL
               CASE MOUSE_X > 19 .AND. MOUSE_X < 30
                  nKEY := K_ENTER
               CASE MOUSE_X > 32 .AND. MOUSE_X < 47
                  nKEY := K_CTRL_RET
               CASE MOUSE_X > 49 .AND. MOUSE_X < 62
                  nKEY := K_ALT_F10
               ENDCASE
            ENDIF
            IF MOUSE_B = 1 .AND. MOUSE_Y > 4 .AND. MOUSE_Y < MaxRow() - 1 .AND. MOUSE_X # MaxCol() - 1 .AND. ( oTB:ROWPOS + 4 ) # MOUSE_Y
               IF MOUSE_Y < ( oTB:ROWPOS + 4 )
                  nKEY  := 255   // Apenas Para Sair do Loop e marcar subir
                  nMOVE := ( oTB:ROWPOS + 4 ) - MOUSE_Y
               ELSE
                  nKEY  := 254   // Apenas Para Sair do Loop e marcar descer
                  nMOVE := MOUSE_Y - ( oTB:ROWPOS + 4 )
               ENDIF
            ENDIF
         ENDDO
      ENDIF

      // Saltar
      IF nMOVE > 0
         IF nKEY = 255
            FOR X := 1 TO nMOVE
               oTB:UP()  // Cursor para cima.
            NEXT X
         ELSE
            FOR X := 1 TO nMOVE
               oTB:DOWN()  // Cursor para baixo.
            NEXT X
         ENDIF
         nKEY := 0   // Zera o Inkey Evitar Conflito
         // oTB:REFRESHALL() //Atualiza os Dados N„o Necessario
      ENDIF

      // Teclas Deslocamento do Objeto TBrowse.
      DO CASE
      CASE nKEY == K_UP  // Cursor para cima.
         oTB:UP()
      CASE nKEY == K_DOWN  // Cursor para baixo.
         oTB:DOWN()
      CASE nKEY == K_LEFT  // Cursor para esquerda.
         oTB:Left()
      CASE nKEY == K_RIGHT   // Cursos para direita.
         oTB:Right()
      CASE nKEY == K_HOME  // Cursor para posi‡„o inicial da tela.
         oTB:GOTOP()
      CASE nKEY == K_END   // Cursor para posi‡„o final da tela.
         oTB:GOBOTTOM()
      CASE nKEY == K_PGUP  // Move cursor uma p gina de tela para cima.
         oTB:PAGEUP()
      CASE nKEY == K_PGDN  // Move cursor uma p gina de tela para baixo.
         oTB:PAGEDOWN()
      CASE nKEY == K_CTRL_PGUP   // Move cursor para o primeiro registro.
         oTB:GOTOP()
      CASE nKEY == K_CTRL_PGDN   // Move cursor para o £ltimo registro.
         oTB:GOBOTTOM()
      ENDCASE

      // Informa o in¡cio ou o fim do arquivo (ou fonte de dados).
      IF oTB:HITTOP
         MDS( " Vocˆ est  no primeiro registro !" )
      ENDIF
      IF oTB:HITBOTTOM
         MDS( " Vocˆ est  no £ltimo registro !" )
      ENDIF

      IF oTB:STABLE
         inclui := .F.
         DO CASE
         CASE nKEY = K_ENTER .AND. wVAR = 3
            Eval( bAU2 )
            SetCursor( 1 )   // Aciona novamente o cursor.
            dbCloseAll()
            EXIT
         CASE nKEY = K_ENTER .AND. wVAR # 3
            nREG  := RecNo()
            cTELA := SaveScreen( 02, 00, 24 - 1, 79 )
            EQUVARS()
            IF ValType( bEQU ) = "B"
               Eval( bEQU )
            ENDIF
            SetCursor( 1 )
            // Metodo de Edi‡„o
            SetColor( aCOR[ 2 ] )
            IF cTIPG = "1"
               // Desenha a Tela
               Eval( bTEL )
               // Get nas Menvars
               Eval( bGET )
            ELSE
               EDITGET( .T., aCOR )
            ENDIF
            SetCursor( 0 )
            dbSelectAr( cARQ )
            netreclock()
            REPLVARS()
            dbUnlock()
            IF ValType( bPOS ) = "B"
               Eval( bPOS )
            ENDIF
            dbSelectAr( cARQ )
            GRAVALOG( &wCHA, "ALT", cARQ )
            RestScreen( 02, 00, 24 - 1, 79, cTELA )
            IF nIND # 1
               oTB:GOTOP()
               oTB:REFRESHALL()
               dbGoto( nREG )
               oTB:REFRESHALL()
            ELSE
               oTB:REFRESHCURRENT()
            ENDIF
         CASE nKEY = K_DEL
            IF mdg( "Deseja Apagar" )
               GRAVALOG( &wCHA, "DEL", cARQ )
               EQUVARS()   // Usado As Vezes Belo Block Del
               DELEREG(,, .F., .F., .F. )  // da o skip depois evitar erros bDEL
               // DELEREG( cARQ, eBUSCA, lSAL, lLOG, lTOP )
               IF ValType( bDEL ) = "B"
                  Eval( bDEL )
               ENDIF
               dbSelectAr( cARQ )
               dbSkip()
               IF Eof()
                  dbSkip( - 1 )
               ENDIF
               nSBAR--
               oTB:REFRESHALL()
            ENDIF
         CASE nKEY = K_INS
            cTELA := SaveScreen( 02, 00, 24 - 1, 79 )
            nREG  := RecNo()
            CLRVARS()
            IF ValType( bCHA ) = "B"
               Eval( bCHA )
            ELSE
               IF ValType( bINS ) = "B"
                  lTMPRETU := Eval( bINS )
                  IF ValType( lTMPRETU ) = "L"
                     IF !lTMPRETU
                        LOOP
                     ENDIF
                  ENDIF
               ENDIF
               PEGBUS( cARQ, 1 )
            ENDIF
            dbSelectAr( cARQ )
            dbSetOrder( 1 )
            dbGoTop()
            IF !dbSeek( mCHAVE )
               inclui := .T.
               netrecapp()
               nSBAR++
               IF ValType( aREP ) = "A"
                  FOR X := 1 TO Len( aREP )
                     cFIL         := aREP[ X, 1 ]
                     cVAR         := aREP[ X, 2 ]
                     field->&cFIL := &cVAR
                  NEXT X
               ENDIF
               IF ValType( aREP ) = "B"
                  Eval( aREP )
               ENDIF
               netreclock()
               REPLVARS()
               dbUnlock()
               dbCommitAll()
               nREG := RecNo()
               SetCursor( 1 )
               // Metodo de Edi‡„o
               SetColor( aCOR[ 2 ] )
               IF cTIPG = "1"
                  // Desenha a Tela
                  Eval( bTEL )
                  // Get nas Menvars
                  Eval( bGET )
               ELSE
                  EDITGET( .T., aCOR )
               ENDIF
               SetCursor( 0 )
               dbSelectAr( cARQ )
               netreclock()
               REPLVARS()
               dbUnlock()
               GRAVALOG( &wCHA, "INC", cARQ )
               IF ValType( bPOS ) = "B"
                  Eval( bPOS )
               ENDIF
            ELSE
               ALERTX( "J  Cadastrado Com esta Chave" )
               dbGoto( nREG )
            ENDIF
            dbSelectAr( cARQ )
            dbSetOrder( nIND )
            RestScreen( 02, 00, 24 - 1, 79, cTELA )
            oTB:GOTOP()
            oTB:REFRESHALL()
            dbGoto( nREG )
            oTB:REFRESHALL()
         CASE nKEY = K_CTRL_ENTER
            nREG    := RecNo()
            nIBUS   := if( lPBUS, NUMIND( cARQ ), nIBUS )
            mCHABUS := PEGBUS( cARQ, nIBUS )
            IF ValType( mCHABUS ) = "C"
               mCHABUS := AllTrim( mCHABUS )
            ENDIF
            dbSelectAr( cARQ )
            dbSetOrder( nIBUS )
            OTB:GOTOP()
            IF !dbSeek( mCHABUS )
               ALERTX( "Registro NÆo Encontrado" )
               dbSkip( - 1 )   // O Mais Proximo e o anterior
               IF Bof()
                  dbGoTop()
               ENDIF
            ENDIF
            nREG := RecNo()
            dbSetOrder( nIND )
            dbGoto( nREG )
            oTB:REFRESHALL()
         ENDCASE
      ENDIF
      IF ValType( bAUX ) = "B"
         Eval( bAUX )
      ENDIF
      IF nKEY = K_ESC  // Encerra consulta.
         IF mdg( " Deseja encerrar a consulta ?" )
            SetCursor( 1 )   // Aciona novamente o cursor.
            dbCloseAll()
            EXIT
         ENDIF
      ENDIF
   ENDDO

   RETU .T.


// + EOF: mlib11.prg
// +
