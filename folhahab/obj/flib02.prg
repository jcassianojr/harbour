// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : flib02.prg
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
// +    Documentado em 27-Dez-2024 as  9:44 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// **
// ** PADRAO .PRG  :
// ** Gerado em    : Janeiro 17, 1996
// ** Programador  : Disk Softwares
// ** Linguagem    : Clipper 5.x
// **


// Teclas Operacionais
// #INCLUDE "TECLAS.CH"
#include "INKEY.CH"
// //#INCLUDE "COMANDO.CH"
#include "DBINFO.CH"
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PADRAO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC PADRAO

// Recebendo Parametro de Trabalho
   PARA cARQ, cIND, eBARM, eCHAVEM, cCABX, cCAB, bCHA, bTEL, bGET, bLIS, cFIL, nLIN, cHELP, bAUX, cMOD

// cMOD T-Total E-So Edicao V-Visualizar(nao inc/del/alt) X-Inclui e Edicao

   IF ValType( cMOD ) # "C"
      cMOD := "T"  // total
   ENDIF

   IF ValType( nLIN ) # "N"
      nLIN := 3
   ENDIF

   IF ValType( cHELP ) # "C"
      HELPDBF := cARQ
   ELSE
      HELPDBF := cHELP
   ENDIF

// Ajusta Variaveis
   eBAR   := StrTran( eBARM, "m", "" )
   eCHAVE := StrTran( eCHAVEM, "m", "" )
   PRIV mCHAVE

// Modo de Trabalho no Video
   CABEX( cCABX )
   VIDEO := "S"
   MDS( 'Visualizar como Video (S)im (N)ao ou (B)rowse ' )
   @ 24, 78 GET VIDEO PICT "!" VALID VIDEO $ "SNB"
   READCUR()
   MD()

// Variaveis de Trabalho
   nROW := 24
   PRIV PCK := .F.
   GRAPP := 1
   CRIARVARS( cARQ )
   PRIV aPAD1, aPAD2
   aPAD1 := {}   // Matriz com os dizeres do Achoice
   aPAD2 := {}   //



   PRIV aPADTEL := {}
   IF ValType( bTEL ) = "C"
      aPADTEL := TELAPEG( bTEL )
      bTEL    := {|| TELASAY( aPADTEL ) }
   ENDIF

   PRIV aPADGET := {}
   IF ValType( bGET ) = "C"
      aPADGET := EDITPEG( bGET )
      bGET    := {|| EDITSAY( aPADGET ) }
   ENDIF


// Incializando a ajuda on Line
   PRIV HELPDBF := cARQ


// Carregando Matriz
   IF VIDEO = "S" .OR. VIDEO = "B"
      IF !netuse( cARQ )
         RETU
      ENDIF

      // IF VIDEO="S"
      // IF LASTREC()>4096
      // MDT("Mais que 4096 registro Visualizacao Mudada para (B)rowse")
      // VIDEO:="B"
      // ENDIF
      // ENDIF
      // harbour sem limite array

      GRAF  := LastRec()
      xGRAF := 0
      xPOS  := 1
      GRAPT := LastRec()
      GRAPT( 'Carregando  - Aguarde...' )
      IF ValType( cFIL ) = "C" .AND. !Empty( cFIL )  // Filtro Passado com complemento cFIL
         FILTRO := FILTRO( AllTrim( cFIL ) )
         SET FILTER TO &FILTRO
      ENDIF
      IF ValType( cFIL ) = "A"   // Filtro Passado Porem pede Complemto ou nao {.T.,cFIL,.T.} OU {.F.,cFIL,.T.}
         // terceiro parametro limpavars
         IF cFIL[ 1 ]
            FILTRO := FILTRO( cFIL[ 2 ] )
         ELSE
            FILTRO := cFIL[ 2 ]
         ENDIF
         SET FILTER TO &FILTRO
      ENDIF
      IF ValType( cFIL ) = "L"   // Filtro Nao Passao Porem Pergunta .T.
         IF cFIL
            FILTRO := FILTRO( "" )
            SET FILTER TO &FILTRO
         ENDIF
      ENDIF
   ENDIF
   IF VIDEO = "S"
      nIndexes  := dbOrderInfo( DBOI_ORDERCOUNT )
      aNtxNames := {}
      FOR i := 1 TO nIndexes
         AAdd( aNtxNames, dbOrderInfo( DBOI_NAME,, i ) + " - " + dbOrderInfo( DBOI_EXPRESSION,, i ) )
      NEXT
      IF nIndexes > 1
         nRESP := AChoice( 6, 6, 16, 74, aNTXNAMES )
         IF LastKey() = 13
            dbSetOrder( nRESP )
         ENDIF
      ENDIF
      dbGoTop()
      WHILE !Eof()
         AAdd( aPAD1, &eBAR. )
         AAdd( aPAD2, &eCHAVE. )
         xPOS++
         GRAPS()
         dbSkip()
      ENDDO
      dbCloseAll()
      IF xPOS = 1
         IF !MDG( 'Nenhum Lancamento Neste Arquivo Deseja Incluir' )
            RETU
         ENDIF
         IF !fPAD( 1, 0 )
            RETU
         ENDIF
      ENDIF
   ENDIF

// PosicAo Inicial do Ponteiro
   pPAD := 1

// Processando o Metodo Escolhido
   IF VIDEO = 'S'
      NOBREAK()
      PRIV nSBAR, aSBAR
      nSBAR := Len( aPAD1 )
      aSBAR := ScrollBarNew( 05, 79, 23,, pPAD )
      ScrollBarDisplay( aSBAR )
      ScrollBarUpdate( aSBAR, pPAD, nSBAR, .T. )
      WHILE .T.
         hb_Scroll( nLIN, 0, 23, 79 )
         hb_DispBox( nLIN, 0, 23, 79, B_DOUBLE + " " )
         @ nLIN + 1, 1 SAY cCAB
         @ nLIN + 2, 0 SAY '+' + Replicate( '-', 78 ) + 'í'
         @ 24, 0     SAY "INS=Novo DEL=Apaga Enter=Altera Ctrl+ENTER=Busca Alt+F10=Lista" + spac( 17 ) + "í"
         ScrollBarUpdate( aSBAR, pPAD, nSBAR, .T. )
         ScrollBarDisplay( aSBAR )
         pPAD2 := AChoice( nLIN + 3, 01, 22, 78, aPAD1,, "ACHRETB", pPAD )
         pPAD  := IF( pPAD2 # 0, pPAD2, pPAD )
         pPAD2 := pPAD
         DO CASE
         CASE LastKey() = K_ESC
            MDS( 'Retornando' )
            EXIT
         CASE LastKey() = K_ALT_F10    // EVAL(bLIS,pPAD)
            MDS( 'Imprimindo' )
            fPAD( 4, pPAD )
         CASE LastKey() = K_INS
            MDS( 'Incluindo ' )
            fPAD( 1, pPAD )
         CASE LastKey() = K_ENTER
            MDS( 'Alterando ' )
            fPAD( 2, pPAD )
         CASE LastKey() = K_DEL
            MDS( 'Excluindo ' )
            fPAD( 3, pPAD )
         CASE ( LK_ALT_ENT .OR. LK_TAB ) .AND. ValType( bAUX ) = "B"
            Eval( bAUX, pPAD )
         CASE pBUS   // CTRL+ENTER USO O aPAD1
            Eval( bCHA )
            pPAD := AScan( aPAD2, mCHAVE )
            IF pPAD = 0
               MDT( 'Nao localizei o Registro Correspondente ....' )
               pPAD := pPAD2
               LOOP
            ENDIF
         OTHERWISE
            LOOP
         ENDCASE
      ENDDO
   ENDIF
   IF VIDEO = "N"
      // * ENTRADA SEM VER O BROWSE DOS REGISTROS
      WHILE .T.
         OPCAO( 24, 01, ' &INCLUIR  ', 73 )
         OPCAO( 24, 16, ' &ALTERAR  ', 65 )
         OPCAO( 24, 31, ' &EXCLUIR  ', 69 )
         OPCAO( 24, 46, ' &LISTAR   ', 76 )
         OPCAO( 24, 61, ' &RETORNAR ', 82 )
         OPT := MENU(, 0 )
         DO CASE
         CASE OPT = 1
            fPAD( 1, 0 )
         CASE OPT = 2
            fPAD( 2, pPAD )
         CASE OPT = 3
            fPAD( 3, 0 )
         CASE OPT = 4    // EVAL(bLIS)
            fPAD( 4, pPAD )
         OTHERWISE
            EXIT
         ENDCASE
      ENDDO
   ENDIF

   IF VIDEO = "B"
      // Tela Basica
      hb_DispBox( 2, 0, 24 - 1, 79, B_DOUBLE + " " )
      @ 03, 1 SAY cCAB
      @  4, 0 SAY '+' + Replicate( '-', 77 ) + 'Tí'
      // Inicia o TBROWSE
      oTB        := TBrowseDB( 05, 01, 22, 78 )
      ocTB       := TBColumnNew( "", {|| &eBAR. } )
      ocTB:WIDTH := 78
      oTB:ADDCOLUMN( ocTB )
      oTB:REFRESHALL()

      // Coloca a Barra de Trabalho
      PRIV nSBAR
      PRIV aSBAR
      nSBAR := LastRec()
      aSBAR := ScrollBarNew( 04, 79, 23,, 1 )
      ScrollBarDisplay( aSBAR )
      WHILE .T.
         dbSelectAr( cARQ )
         @ 24, 0  SAY "INS=Novo DEL=Apaga Enter=Altera Ctrl+ENTER=Busca Alt+F10=Lista" + spac( 17 ) + "í"
         @  3, 79 SAY "í"
         WHILE !oTB:STABILIZE()
            nKEY := Inkey()
            IF nKEY != 0
               EXIT
            ENDIF
         ENDDO
         IF oTB:STABILIZE()
            nKEY := Inkey( 0 )
         ENDIF
         // nKEY:=INKEY(0)
         nMOVE := 0
         IF oTB:STABLE   // Se objeto j  est vel...
            ScrollBarUpdate( aSBAR, ( oTB:ROWPOS + 4 ), nSBAR, .T. )
            nKEY  := 0
            nMOVE := 0
            WHILE nKEY = 0
               nKEY := HOTINKEY()
               nKEY := LERMOUSE( nKEY )
               DO CASE
               CASE MOUSE_B = 1 .AND. MOUSE_Y = 4
                  nKEY := K_UP
               CASE MOUSE_B = 1 .AND. MOUSE_Y = MaxRow() - 1
                  nKEY := K_DOWN
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
                  CASE MOUSE_Y = MaxRow()
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
                     nKEY  := 255  // Apenas Para Sair do Loop e marcar subir
                     nMOVE := ( oTB:ROWPOS + 4 ) - MOUSE_Y
                  ELSE
                     nKEY  := 254  // Apenas Para Sair do Loop e marcar descer
                     nMOVE := MOUSE_Y - ( oTB:ROWPOS + 4 )
                  ENDIF
               ENDIF
            ENDDO
         ENDIF

         // Saltar
         IF nMOVE > 0
            IF nKEY = 255
               FOR X := 1 TO nMOVE
                  oTB:UP()   // Cursor para cima.
               NEXT X
            ELSE
               FOR X := 1 TO nMOVE
                  oTB:DOWN()   // Cursor para baixo.
               NEXT X
            ENDIF
            nKEY := 0  // Zera o Inkey Evitar Conflito
            // oTB:REFRESHALL() //Atualiza os Dados N?o Necessario
         ENDIF

         // Teclas Deslocamento do Objeto TBrowse.
         DO CASE
         CASE nKEY == K_UP   // Cursor para cima.
            oTB:UP()
         CASE nKEY == K_DOWN   // Cursor para baixo.
            oTB:DOWN()
         CASE nKEY == K_LEFT   // Cursor para esquerda.
            oTB:Left()
         CASE nKEY == K_RIGHT  // Cursos para direita.
            oTB:Right()
         CASE nKEY == K_HOME   // Cursor para posi??o inicial da tela.
            oTB:GOTOP()
         CASE nKEY == K_END  // Cursor para posi??o final da tela.
            oTB:GOBOTTOM()
         CASE nKEY == K_PGUP   // Move cursor uma p gina de tela para cima.
            oTB:PAGEUP()
         CASE nKEY == K_PGDN   // Move cursor uma p gina de tela para baixo.
            oTB:PAGEDOWN()
         CASE nKEY == K_CTRL_PGUP  // Move cursor para o primeiro registro.
            oTB:GOTOP()
         CASE nKEY == K_CTRL_PGDN  // Move cursor para o œltimo registro.
            oTB:GOBOTTOM()
         ENDCASE

         // Informa o in­cio ou o fim do arquivo (ou fonte de dados).
         IF oTB:HITTOP
            MDS( " Voce esta no primeiro registro !" )
         ENDIF
         IF oTB:HITBOTTOM
            MDS( " Voce esta  no œltimo registro !" )
         ENDIF

         IF oTB:STABLE
            IF nKEY = K_INS
               IF cMOD = "T" .OR. cMOD = "X"
                  CLRVARS()
                  Eval( bCHA )
                  nKEY := K_ENTER
               ELSE
                  ALERTX( "Modo de Exibicao" )
               ENDIF
            ENDIF
            DO CASE
            CASE nKEY = K_ENTER
               cTELA := SaveScreen( 02, 00, 23, 79 )
               EQUVARS()
               SetCursor( 1 )
               Eval( btel )
               SET KEY K_F11 TO TECLAF11
               Eval( bget )
               SET KEY K_F11
               RestScreen( 02, 00, 23, 79, cTELA )
               SetCursor( 0 )
               netreclock()
               REPLVARS()
               dbUnlock()
            CASE nKEY = K_DEL
               IF cMOD = "T"
                  IF MDG( "Excluir Registro" )
                     netrecdel()
                     dbskipex()
                     nSBAR--
                     oTB:REFRESHALL()
                  ENDIF
               ELSE
                  ALERTX( "Modo de Exibicao" )
               ENDIF
            CASE ( nKEY = K_ALT_ENTER .OR. nKey = K_TAB ) .AND. ValType( bAUX ) = "B"
               Eval( bAUX, 0 )
            CASE nKEY = K_ALT_F10
               EQUVARS()
               Eval( bLIS )
            ENDCASE
         ENDIF


         IF nKEY > 96 .AND. nKEY < 123
            nKEY := Asc( Upper( Chr( nKEY ) ) )
         ENDIF
         IF nKEY > 64 .AND. nKEY < 91
            OtB:GOTOP()
            IF !dbSeek( Chr( nKEY ) )
               dbskipEX( - 1 )   // O Mais Proximo e o anterior
            ENDIF
            nREG := RecNo()
            dbGoto( nREG )   // forcar o refresh
            oTB:REFRESHALL()
         ENDIF

         IF nKEY = K_ESC   // Encerra consulta.
            IF mdg( " Deseja encerrar a consulta ?" )
               SetCursor( 1 )  // Aciona novamente o cursor.
               dbCloseAll()
               EXIT
            ENDIF
         ENDIF
      ENDDO
   ENDIF



// LIBERA VARIAVEIS
   IF ValType( cFIL ) = "A"
      IF cFIL[ 3 ] = .T.
         LIMPAVARS( cARQ )
      ENDIF
   ELSE
      LIMPAVARS( cARQ )
   ENDIF

   netpack( cARQ, pck )


   RETU .T.

// ******************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fPAD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION fPAD( OPRPAD, POSPAD )  // INCLUIR=1//EDITAR=2//EXCLUIR=3//LISTAR=4 // POSICAO MATRIZ

// ******************
   INCLUI := .F.
// Pegar a Chave de Busca
   IF OPRPAD # 1
      IF VIDEO = 'S'
         mCHAVE := aPAD2[ POSPAD ]
      ELSE
         Eval( bCHA )
      ENDIF
   ENDIF



// Operacao de Exclusao
   IF OPRPAD = 3
      IF cMOD = "T"
         IF APAGAREG( cARQ, cIND, mCHAVE )
            IF VIDEO = "S"
               aPAD1[ POSPAD ] = ' Registro Excluido / Apagado / Deletado '
            ENDIF
            PCK := .T.
         ENDIF
         RETU .T.
      ELSE
         ALERTX( "Modo de Exibicao-Nao Exclui" )
         RETU .F.
      ENDIF
   ENDIF

// Operacao de Inclusao
   IF OPRPAD = 1
      IF cMOD = "T" .OR. cMOD = "X"
         ZERAVARS( cARQ )
         Eval( bCHA )
         IF !NOVOREG( cARQ, cIND, mCHAVE )
            RETU .F.
         ENDIF
         INCLUI := .T.
      ELSE
         ALERTX( "Modo de Exibicao-Nao Incluir" )
         RETU .F.
      ENDIF
   ENDIF


// IGUALAR mVARS
   IF !IGUALVARS( cARQ, cIND, mCHAVE )
      RETU .F.
   ENDIF

// Operacao de Listagem
   IF OPRPAD = 4
      Eval( bLIS )
      RETURN .T.
   ENDIF
// Desenha a Tela
   Eval( bTEL )


// Get nas Menvars
   SET KEY K_F11 TO TECLAF11
   Eval( bGET )
   SET KEY K_F11

   IF cMOD = "V"
      @ 24, 00 SAY "Continuar:"
      @ 24, 20 GET zCONTINUA
      READCUR()
   ENDIF


// Atualiza as Matrizes se nao for inclusao
   IF VIDEO = 'S' .AND. OPRPAD # 1
      aPAD1[ POSPAD ] = &eBARM.
      aPAD2[ POSPAD ] = &eCHAVEM.
   ENDIF

// Posiciona o Novo Elemento na Matriz
   IF VIDEO = 'S' .AND. OPRPAD = 1
      AAdd( aPAD1, NIL )
      AAdd( aPAD2, NIL )
      POSPAD := Len( aPAD1 )
      POSW   := 1
      IF POSPAD > 1
         FOR X := 1 TO POSPAD - 1
            mDARE := aPAD2[ X ]
            IF mCHAVE <= mDARE
               EXIT
            ENDIF
         NEXT
         POSW := X
      ENDIF
      AIns( aPAD1, POSW )
      AIns( aPAD2, POSW )
      aPAD1[ POSW ] = &eBARM.
      aPAD2[ POSW ] = &eCHAVEM.
      pPAD := POSW
   ENDIF

   IF cMOD = "T" .OR. cMOD = "E" .OR. cMOD = "X"
      REPORVARS( cARQ, cIND, mCHAVE )
   ELSE
      MDT( "Modo de Exibicao-Nao Grava alteracoes" )
   ENDIF


   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGCHAVE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PEGCHAVE( eVAR, eVAL, cTITULO )

   mCHAVE := eVAL
   MDS( cTITULO )
   @ 24, 30 GET mCHAVE
   READCUR()
   &eVAR. := mCHAVE




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TECLAF11()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC TECLAF11

   PARA cPRO, nLIN, cVAR
   LOCAL nPRO
   PRIV eEXECUTE

   nPRO := 1
   cPRO := AllTrim( Upper( cPRO ) )
   WHILE cPRO = "READCUR" .OR. cPRO = "(B)FPAD"
      cPRO := AllTrim( Upper( ProcName( nPRO ) ) )
      nPRO++
   ENDDO
   IF Type( cVAR ) = "D"
      // CALEND()
      IF ValType( READVAR ) = "D"
         IF MDG( "USAR " + STRVAL( READVAR ) )
            &cVAR. := READVAR
         ENDIF
      ENDIF
   ENDIF
   IF Type( cVAR ) = "N"
      DO CASE
      CASE cVAR = "MNINSTU" .OR. cVAR = "MNUMFUN" .OR. cVAR = "MORIGEM" .OR. CVAR = "MDESTINO"
         &cVAR. := ESCOLHEXI( PES, &cVAR., "STR(NUMERO,8)+' '+NOME", "NUMERO" )
      CASE cVAR = "MNUMERO" .OR. cVAR = "NUMERO" .OR. cVAR = "NUM" .OR. cVAR = "NNUMERO" .OR. cVAR = "MDESTINO"
         &cVAR. := ESCOLHEXI( PES, &cVAR., "STR(NUMERO,8)+' '+NOME", "NUMERO" )
      CASE cVAR = "CONTAREF"
         &cVAR. := ESCOLHEXI( "CONTAS", &cVAR., "STR(CODIGO,8)+' '+DESCR", "CODIGO" )
      CASE cVAR = "MCONTA" .AND. cPRO = "FOAA8"
         &cVAR. := ESCOLHEXI( CC2A, &cVAR., "STR(CODIGO,8)+' '+DESCR", "CODIGO" )
      CASE cVAR = "NREMP"
         &cVAR. := ESCOLHEXI( "FIRMA", &cVAR., "STR(NRCLIEN,8)+' '+RAZAO", "NRCLIEN" )
      CASE cVAR = "MFUNCAO"
         &cVAR. := ESCOLHEXI( "FUNCAO", &cVAR., "STR(CODIGO,8)+' '+DESCR", "CODIGO" )
      CASE cVAR = "MDEPTO"
         &cVAR. := ESCOLHEXI( "DEPTO", &cVAR., "STR(DEPTO,8)+' '+STR(SETOR,8)+' '+STR(SECAO,8)+' '+NOME", "DEPTO" )
      CASE cVAR = "MSETOR"
         &cVAR. := ESCOLHEXI( "DEPTO", &cVAR., "STR(DEPTO,8)+' '+STR(SETOR,8)+' '+STR(SECAO,8)+' '+NOME", "SETOR" )
      CASE cVAR = "MSECAO"
         &cVAR. := ESCOLHEXI( "DEPTO", &cVAR., "STR(DEPTO,8)+' '+STR(SETOR,8)+' '+STR(SECAO,8)+' '+NOME", "SECAO" )
      CASE cVAR = "MCCUSTO"
         &cVAR. := ESCOLHEXI( "UNID", &cVAR., "STR(NUMERO,8)+' '+CODIGO+' '+NOME+' '+MODIRETA", "NUMERO" )
      CASE cVAR = "MUNIFUN" .OR. cVAR = "UNIFUN"
         &cVAR. := ESCOLHEXI( "UNID", &cVAR., "CODIGO+' '+STR(NUMERO,8)+' '+NOME+' '+MODIRETA", "CODIGO" )
      CASE cVAR = "MMODELO"
         &cVAR. := ESCOLHEXI( "RELOGIOS", &cVAR., "STR(NUMERO,8)+' '+NOME", "NUMERO" )
      CASE cVAR = "MMOTIVO"
         &cVAR. := ESCOLHEXI( "FOPTOMOT", &cVAR., "STR(NUMERO,8)+' '+NOME", "NUMERO" )
      CASE cVAR = "MHORARIO"
         &cVAR. := ESCOLHEXI( "FOPTOHOR", &cVAR., "' '+mCODIGO+' '+STR(mENT,  6, 2)+' '+STR(mALMI,  6, 2)+' '+STR(mALMF,  6, 2)+' '+STR(mSAI,  6, 2)", "NUMERO" )
      OTHERWISE
         // CALC()
         IF ValType( READVAR ) = "N"
            IF MDG( "USAR " + STRVAL( READVAR ) )
               READVAR := READVAR
            ENDIF
            &cVAR. := READVAR
         ENDIF
      ENDCASE
   ENDIF
   IF ValType( cVAR ) = "C"
      cVAR := AllTrim( Upper( cVAR ) )
      DO CASE
      CASE cVAR = "MHTT" .OR. cVAR = "MANT"
         &cVAR. := ESCOLHEXI( "TABTURNO", &cVAR., "CODIGO+' '+NOME", "CODIGO" )
      CASE cVAR = "MHORREF" .OR. cVAR = "MHORPAD"
         &cVAR. := ESCOLHEXI( "FOPTOHRE", &cVAR., "CODIGO+' '+NOME", "CODIGO" )
      CASE cVAR = "MPAGGPS"
         &cVAR. := ESCOLHEXI( "TBCODPG", &cVAR., "CODIGO+' '+NOME", "CODIGO" )
      CASE cVAR = "FAIXA"
         &cVAR. := ESCOLHEXI( "FO_FAI", &cVAR., "FAIXA+' '+DESCRICAO", "FAIXA" )
      CASE cVAR = "TIPODEP"
         &cVAR. := ESCOLHEXI( "CODFGTS", &cVAR., "CODIGO+' '+NOME", "CODIGO" )
      CASE cVAR = "MOTIVO"
         &cVAR. := ESCOLHEXI( "FO_RCAU", &cVAR., "CODIGO+' '+NOME", "CODIGO" )
      CASE cVAR = "MOTIVODEM"
         &cVAR. := ESCOLHEXI( "CAGED", &cVAR., "CODIGO+' '+DESCRICAO", "CODIGO" )
      CASE cVAR = "MCBONEW" .OR. cVAR = "CBONEW"
         &cVAR. := ESCOLHEXI( "FO_CBON", &cVAR., "CODIGO+' '+STRZERO(CAGEDESCO,2)+' '+NOME", "CODIGO" )
      CASE cVAR = "MCBO" .OR. cVAR = "CBO"
         &cVAR. := ESCOLHEXI( "FO_CBO", &cVAR., "CODIGO+' '+NOME", "CODIGO" )
      CASE cVAR = "MUNIFUN" .OR. cVAR = "UNIFUN"
         &cVAR. := ESCOLHEXI( "UNID", &cVAR., "CODIGO+' '+NOME", "CODIGO" )
      CASE cVAR = "FPAS" .OR. cVAR = "MFPAS"
         &cVAR. := ESCOLHEXI( "CONFINSS", &cVAR., "FPAS+' '+DESCRICAO", "FPAS" )
      CASE cVAR = "CODRET"
         &cVAR. := ESCOLHEXI( "CODIRRF", &cVAR., "CODIGO+' '+NOME", "CODIGO" )
      CASE cVAR = "MNAT" .OR. cVAR = "NAT_ESTAB"
         &cVAR. := ESCOLHEXI( "RAISNATJ", &cVAR., "CODIGO+' '+NOME", "CODIGO" )
      CASE cVAR = "ATIVIDADE"
         &cVAR. := ESCOLHEXI( "FO_CNAE2", &cVAR., "CODIGO+' '+DESCRICAO", "CODIGO" )
      CASE cVAR = "MACID"
         &cVAR. := ESCOLHEXI( "FO_CSAT", &cVAR., "CODIGO+' '+DESCRICAO", "CODIGO" )
      CASE cVAR = "MCID"
         &cVAR. := ESCOLHEXI( "CID", &cVAR., "CODIGO+' '+NOME", "CODIGO" )
      CASE cVAR = "MCURSO"
         &cVAR. := ESCOLHEXI( CARQCUR, &cVAR., "CURSO+' '+DESCURSO", "CURSO" )
      CASE cVAR = "MAREA"
         &cVAR. := ESCOLHEXI( cARQMP05, &cVAR., "CODIGO+' '+DESCRI", "CODIGO" )
      CASE cVAR = "MCOD" .OR. cVAR = "MCODREV" .OR. Left( cVAR, 5 ) = "MCHOR"
         &cVAR. := ESCOLHEXI( "FOPTOHOR", &cVAR., "' '+mCODIGO+' '+STR(mENT,  6, 2)+' '+STR(mALMI,  6, 2)+' '+STR(mALMF,  6, 2)+' '+STR(mSAI,  6, 2)", "CODIGO",, 2 )
      CASE cVAR = "DOCO" .OR. cVAR = "MOCOCOD" .OR. cVAR = "MOCOSUB" .OR. cVAR = "MSOD" .OR. cVAR = "MCODOCO"
         &cVAR. := ESCOLHEXI( "TABFALTA", &cVAR., "CODIGO+' '+NOME", "CODIGO" )
         // CASE cVAR=""
         // &cVAR.=ESCOLHEXI( "", &cVAR., "", "")
         // CASE cVAR=""
         // &cVAR.=ESCOLHEXI( "", &cVAR., "", "")



      OTHERWISE
         ALERTX( cPRO + "/" + cVAR + "F11 ainda nao disponivel" )
      ENDCASE
   ENDIF
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ESCOLHEXI()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC ESCOLHEXI( cARQ, cNOME, cSTR1, cSTR2, lCOND, nIND )

   LOCAL aTABA := {}
   LOCAL aTABB := {}
   LOCAL nPOS

   IF ValType( nIND ) # "N"
      nIND := 1
   ENDIF
   aSALVA := SALVAA()
   MDS( "Aguarde Pesquisando Tabela" )
   IF !netuse( cARQ )
      RESTAA( aSALVA )
      RETURN ""
   ENDIF
   IF ValType( nIND ) = "N"
      dbSetOrder( nIND )
   ENDIF
   dbGoTop()
   WHILE !Eof()
      IF ValType( lCOND ) # "C"
         AAdd( aTABA, &cSTR1. )
         AAdd( aTABB, &cSTR2. )
      ELSE
         IF &lCOND.
            AAdd( aTABA, &cSTR1. )
            AAdd( aTABB, &cSTR2. )
         ENDIF
      ENDIF
      dbSkip()
   ENDDO
   dbCloseArea()
   IF !Empty( aTABA )
      nPOS := AScan( aTABB, cNOME )
      nPOS := if( nPOS > 1, nPOS, 1 )
      nPOS := ESCARR( aTABA, 4, 5, 24 - 3, 63, nPOS, "Escolha o Item" )
      nPOS := if( nPOS > 1, nPOS, 1 )
      IF LastKey() = K_ENTER
         cNOME := aTABB[ nPOS ]
      ENDIF
   ENDIF
   RESTAA( aSALVA )
   RETU cNOME


// + EOF: flib02.prg
// +
