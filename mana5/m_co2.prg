// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_co2.prg
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
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


// :*****************************************************************************
// :
// :   M_CO2  .PRG : Arquivo de Ajuda ONline
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :      Copyright (c) 1999,  jcassiano  S/C Ltda.
// :
// :*****************************************************************************

#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_co2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_co2

// Recebendo Parametro de Trabalho
   PARA wMCO2, wpMCO2, wcMCO2

/* 3o. Paramentro
0 - Cria e Carrega as Matrizes
1 - N�o Cria e Carrega as Matrizes
2 - N�o Cria e N�o Carrega as Matrizes
*/
   IF PCount() < 3
      wcMCO2 := 0
   ENDIF


// Teclas Operacionais
// #INCLUDE "TECLAS.CH"
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
// #INCLUDE "MEMOGET.CH"



// Modo de Trabalho no Video
   MDI( " � Arquivo de Ajuda ONline" )

// Configura��o de Trabalho
   PRIV lFIXA, nACHO, cVIDE, lPBUS, lPIND, mCBAR, mCBARM, cTIPG, aGETS, cCBAS, nIBUS
   PRIV nIEXI, aIND, nREG
   IF !CONFARQ( HELPARQ, "Seq Vari�vel   Arquivo" + spac( 7 ) + "Descri��o" )
      RETU .F.
   ENDIF
   IF !CONFIND( HELPARQ )
      RETU .F.
   ENDIF


// Pegando Cores de Trabalho
   CORMCO2  := CORARR( "MCO2" )
   aTELMCO2 := TELAPEG( "MCO201" )


// Variaveis de Trabalho
   PRIV PCK    := .F.
   PRIV mCHAVE
   IF wMCO2 = 0
      CRIARVARS( HELPARQ )
   ENDIF
// CRIANDO MATRIZES
   IF wcMCO2 = 0
      aMCO21 := {}   // Matriz com os dizeres do Achoice
      aMCO22 := {}   // Pela refer�ncia do Arquivo e Campo
      aMCO23 := {}   // Arquivo e Sequ�ncia de Edi��o
   ENDIF

// Incializando a ajuda on Line
   PRIV HELPDBF := HELPARQ

// Carregando Matriz
   IF cVIDE = "S" .AND. wcMCO2 # 2
      IF !USEREDE( HELPARQ, 1, 2 )
         RETU
      ENDIF
      GRAF  := LastRec()
      xGRAF := 0
      xPOS  := 1
      MARCAR()
      dbGoTop()
      dbSeek( PadR( mDBF, 8 ) )
      WHILE PadR( mDBF, 8 ) = DBF .AND. !Eof()
         IF !Empty( mCBAR )
            AAdd( aMCO21, &mCBAR. )
         ELSE
            AAdd( aMCO21, ' ' + Str( SEQ, 3 ) + ' ' + CAMPO + ' ' + ARQUIVO + ' ' + DADO )
         ENDIF
         AAdd( aMCO22, DBF + CAMPO )
         AAdd( aMCO23, DBF + Str( SEQ, 3 ) )
         xPOS++
         MARCAR1()
         dbSkip()
      ENDDO
      dbCloseArea()
      IF xPOS = 1
         IF !mdg( 'Nenhum Lan�amento Neste Arquivo Deseja Incluir' )
            RETU .F.
         ENDIF
         nSBAR := 0
         IF !fMCO2( 1, 0 )
            RETU .F.
         ENDIF
      ENDIF
   ENDIF

// Posi��o Inicial do Ponteiro
   IF PCount() = 1
      pMCO2 := 1
   ELSE
      pMCO2 := AScan( aMCO22, wpMCO2 )
      pMCO2 := IF( pMCO2 = 0, 1, pMCO2 )
   ENDIF

// Processando o M�todo Escolhido
   IF cVIDE = 'S'
      NOBREAK()
      PRIV nSBAR, aSBAR
      nSBAR := Len( aMCO21 )
      aSBAR := ScrollBarNew( 04, 79, 23, SubStr( CORMCO2[ 1 ], RAt( ",", CORMCO2[ 1 ] ) + 1 ), pMCO2 )
      ScrollBarDisplay( aSBAR )
      ScrollBarUpdate( aSBAR, pMCO2, nSBAR, .T. )
      WHILE .T.
         SetColor( CORMCO2[ 1 ] )
         hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
         @  3, 1 SAY cCBAS
         @  4, 0 SAY '+' + Replicate( '-', 78 ) + '�'
         MDS( 'Busca: ' )
         ScrollBarUpdate( aSBAR, pMCO2, nSBAR, .T. )
         ScrollBarDisplay( aSBAR )
         SetColor( CORMCO2[ 1 ] )
         pMCO22 := AChoice( 05, 01, 22, 78, aMCO21,, "ACHRETB", pMCO2 )
         pMCO2  := IF( pMCO22 # 0, pMCO22, pMCO2 )
         pMCO22 := pMCO2
         DO CASE
         CASE LastKey() = K_ESC
            IF mdg( 'Encerrar Consulta' )
               EXIT
            ENDIF
            LOOP
         CASE LastKey() = K_ALT_F10
            MDS( 'Imprimindo' )
            MANLISTA()
         CASE LastKey() = K_INS
            MDS( 'Incluindo ' )
            fMCO2( 1, pMCO2 )
         CASE LastKey() = K_ENTER .AND. wMCO2 # 3
            MDS( 'Alterando ' )
            fMCO2( 2, pMCO2 )
         CASE LastKey() = K_ENTER .AND. wMCO2 = 3
            MDS( 'Escolhendo' )
            fMCO2( 6, pMCO2 )
            RETU
         CASE LastKey() = K_DEL
            MDS( 'Excluindo ' )
            fMCO2( 3, pMCO2 )
         CASE LastKey() = K_CTRL_ENTER
            nIBUS   := IF( lPBUS, NUMIND( HELPARQ ), nIBUS )
            mCHABUS := PEGBUS( HELPARQ, nIBUS )
            IF nIBUS # 1
               nREG := REGBUS( HELPARQ, nIBUS, mCHABUS )
            ENDIF
            pMCO2 := AScan( aMCO22, mCHAVE )
            IF pMCO2 = 0
               ALERTX( 'Nao localizei o Registro Correspondente ....' )
               pMCO2 := pMCO22
               LOOP
            ENDIF
         OTHERWISE
            LOOP
         ENDCASE
      ENDDO
   ENDIF
   IF cVIDE = 'N'
      METNVI( HELPARQ, {|| fMCO2( 1, 0 ) }, {|| fMCO2( 3, 0 ) }, {|| fMCO2( 2, 0 ) }, ;
         {|| fMCO2( 6, 0 ) }, {|| fMCO2( 2, - 1 ) }, CORMCO2[ 1 ], wMCO2 )
   ENDIF
   IF cVIDE = 'P'
      METPAG( HELPARQ, CORMCO2, "mDBF+mCAMPO", wMCO2, ;
         {|| TELASAY( aTELMCO2 ) }, {|| fMCO2( 1, 0 ) }, {|| fMCO2( 3, 0 ) }, {|| fMCO2( 2, 0 ) }, ;
         {|| fMCO2( 6, 0 ) } )
   ENDIF
   IF cVIDE = 'I'
      METINT( HELPARQ,, {|| fMCO2( 2, - 1 ) } )
   ENDIF

   IF wMCO2 = 0
      // LIBERA VARIAVEIS
      RELEASE ALL LIKE m *   // LIMPAVARS(HELPARQ)
   ENDIF

// EFETUA O PACK SE NECESSARIO
   IF PCK .AND. lFIXA
      FIXAR( HELPARQ )
   ENDIF
   RETU .T.

// ******************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fMCO2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC fMCO2( OPRMCO2, POSMCO2 )   // INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

// ******************
// Pegar a Chave de Busca
   IF OPRMCO2 # 1
      IF cVIDE = 'S'
         mCHAVE := aMCO22[ POSMCO2 ]   // mDBF+CAMPO=aMCO22[POSMCO2]
      ENDIF
      IF cVIDE = 'N' .AND. POSMCO2 # -1
         PEGBUS( HELPARQ, 1 )
      ENDIF
   ENDIF

// Opera��o de Exclus�o
   IF OPRMCO2 = 3
      IF APAGAREG( HELPARQ, mCHAVE )
         IF cVIDE = "S"
            aMCO21[ POSMCO2 ] = ' ' + mDBF + ' ' + mCAMPO + ' - Registro Excluido / Apagado / Deletado'
         ENDIF
         PCK := .T.
      ENDIF
      RETU .T.
   ENDIF

// Opera��o de Inclus�o
   IF OPRMCO2 = 1
      PEGBUS( HELPARQ, 1 )
      IF !NOVOREG( HELPARQ, mCHAVE )
         RETU .F.
      ENDIF
   ENDIF



// IGUALAR mVARS
   IF !IGUALVARS( HELPARQ, mCHAVE )   // IF ! IGUALVARS(HELPARQ,mDBF+CAMPO)
      RETU .F.
   ENDIF

// Metodo de Edi��o
   IF cTIPG = "1"
      // Desenha a Tela
      TELASAY( aTELMCO2 )
      // Get nas Menvars
      gMCO2()
   ELSE
      EDITGET( .T., CORMCO2 )
   ENDIF



// Atualiza as Matrizes se nao for inclusao
   IF cVIDE = 'S' .AND. OPRMCO2 # 1
      IF !Empty( mCBARM )
         aMCO21[ POSMCO2 ] = &mCBARM.
      ELSE
         aMCO21[ POSMCO2 ] = ' ' + Str( mSEQ, 3 ) + ' ' + mCAMPO + ' ' + mARQUIVO + ' ' + mDADO
      ENDIF
      aMCO22[ POSMCO2 ] = mDBF + mCAMPO
      aMCO23[ POSMCO2 ] = mDBF + Str( mSEQ, 3 )
   ENDIF

// Posiciona o Novo Elemento na Matriz
   IF cVIDE = 'S' .AND. OPRMCO2 = 1
      nSBAR++
      AAdd( aMCO21, NIL )
      AAdd( aMCO22, NIL )
      AAdd( aMCO23, NIL )
      POSMCO2 := Len( aMCO21 )
      POSW    := 1
      IF POSMCO2 > 1
         FOR X := 1 TO POSMCO2 - 1
            mDARE := aMCO22[ X ]
            IF mCHAVE <= mDARE   // IF mDBF+CAMPO<=mDARE
               EXIT
            ENDIF
         NEXT
         POSW := X
      ENDIF
      AIns( aMCO21, POSW )
      AIns( aMCO22, POSW )
      AIns( aMCO23, POSW )
      IF !Empty( mCBARM )
         aMCO21[ POSW ] = &mCBARM.
      ELSE
         aMCO21[ POSW ] = ' ' + Str( mSEQ, 3 ) + ' ' + mCAMPO + ' ' + mARQUIVO + ' ' + mDADO
      ENDIF
      aMCO22[ POSW ] = mDBF + mCAMPO
      aMCO23[ POSW ] = mDBF + Str( mSEQ, 3 )
      pMCO2 := POSW
   ENDIF

   REPORVARS( HELPARQ, mCHAVE )

   RETU .T.



// Get Nas Mvars


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMCO2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gMCO2

   SetColor( CORMCO2[ 2 ] )
   @  6, 30 GET mSEQ   PICTURE '999'
   @  8, 30 GET mCAMPO
// @ 10,30 GET mDESCRICAO MEMO coord {12,00,24,79} boxcolor MCF003
   @ 12, 30 GET mARQUIVO
   @ 15, 2  GET mDADO
   @ 17, 2  GET mPRELAN
   @ 19, 2  GET mCONDICAO PICT "@S70"
   @ 21, 2  GET mPRECOND  PICT "@S70"
   READCUR()
   RETU .T.





// + EOF: m_co2.prg
// +
