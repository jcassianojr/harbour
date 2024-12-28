// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ao.prg
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
// +    Documentado em 28-Dez-2024 as  9:56 am
// +
// +
// +
// +--------------------------------------------------------------------
// +



#include "BOX.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function M_ao()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION M_ao

// Recebendo Parametro de Trabalho
   PARA wMAO, wpMAO, wcMAO

/* 3o. Paramentro
0 - Cria e Carrega as Matrizes
1 - N„o Cria e Carrega as Matrizes
2 - N„o Cria e N„o Carrega as Matrizes
*/
   IF PCount() < 3
      wcMAO := 0
   ENDIF


// Teclas Operacionais
// #INCLUDE "TECLAS.CH"
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

// Modo de Trabalho no Video
   MDI( " Ý ",,, "MO01" )

// Configura‡„o de Trabalho
   PRIV lFIXA, nACHO, cVIDE, lPBUS, lPIND, mCBAR, mCBARM, cTIPG, aGETS, cCBAS, nIBUS
   PRIV nIEXI, aIND, nREG
   IF !CONFARQ( "MO01", "Pedido   Data     N£meroOS Cliente" + spac( 12 ) + "Total Pedido" )
      RETU .F.
   ENDIF
   IF !CONFIND( "MO01" )
      RETU .F.
   ENDIF

// Pegando Cores de Trabalho
   MAO001 := COR( "MAO001" )
   MAO002 := COR( "MAO002" )
   MAO005 := COR( "MAO005" )
   MAO006 := COR( "MAO006" )
   MAO007 := COR( "MAO007" )

// Telas de Trabalho
   aMAOTEL := TELAPEG( "MAO001" )
   aMAOGET := EDITPEG( "MAO001" )


// Variaveis de Trabalho
   PRIV PCK    := .F.
   PRIV mCHAVE
   IF wMAO = 0
      CRIARVARS( "MO01" )
      CRIARVARS( "MO02" )
   ENDIF
// CRIANDO MATRIZES
   IF wcMAO = 0
      aMAO1 := {}  // Matriz com os dizeres do Achoice
      aMAO2 := {}  // N£mero do Pedido
   ENDIF

// Incializando a ajuda on Line
   PRIV HELPDBF := "MO01"

// Carregando Matriz
   IF cVIDE = "S" .AND. wcMAO # 2
      nIND := IF( lPIND, NUMIND( "MO01" ), nIEXI )
      IF !USEREDE( "MO01", 1, nIND )
         RETU
      ENDIF
      GRAF := LastRec()
      IF GRAF > nACHO
         dbCloseArea()
         ALERTX( "Muitos Arquivos para o Modo V¡deo" )
         cVIDE := "N"
      ELSE
         xGRAF := 0
         xPOS  := 1
         MARCAR()
         dbGoTop()
         WHILE !Eof()
            IF !Empty( mCBAR )
               AAdd( aMAO1, &mCBAR. )
            ELSE
               AAdd( aMAO1, ' ' + Str( PEDIDO, 8 ) + ' ' + DToC( DATA ) + ' ' + Str( OS, 8, 2 ) + ' ' + Str( FORNECEDO, 5 ) + ' ' + COGNOME + ' ' + Str( TOTNF, 18, 2 ) )
            ENDIF
            AAdd( aMAO2, PEDIDO )
            xPOS++
            MARCAR1()
            dbSkip()
         ENDDO
         dbCloseArea()
         IF xPOS = 1
            IF !MDG( 'Nenhum Lan‡amento Neste Arquivo. Deseja Incluir ?' )
               RETU .F.
            ENDIF
            nSBAR := 0
            IF !fMAO( 1, 0 )
               RETU .F.
            ENDIF
         ENDIF
      ENDIF
   ENDIF

// Posi‡„o Inicial do Ponteiro
   IF PCount() = 1
      pMAO := 1
   ELSE
      pMAO := AScan( aMAO2, wpMAO )
      pMAO := IF( pMAO = 0, 1, pMAO )
   ENDIF

// Processando o M‚todo Escolhido
   IF cVIDE = 'S'
      NOBREAK()
      PRIV nSBAR, aSBAR
      nSBAR := Len( aMAO1 )
      aSBAR := ScrollBarNew( 03, 79, 23,, pMAO )
      ScrollBarDisplay( aSBAR )
      ScrollBarUpdate( aSBAR, pMAO, nSBAR, .T. )
      WHILE .T.
         SetColor( MAO001 )
         hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
         @ 03, 2 SAY "Pedido   Data     N£meroOS Cliente" + spac( 12 ) + "Total Pedido"
         @  4, 0 SAY '+' + Replicate( '-', 78 ) + 'Ý'
         MDS( 'Busca: ' )
         ScrollBarUpdate( aSBAR, pMAO, nSBAR, .T. )
         ScrollBarDisplay( aSBAR )
         pMAO2 := AChoice( 05, 01, 22, 78, aMAO1,, "ACHRETB", pMAO )
         pMAO  := IF( pMAO2 # 0, pMAO2, pMAO )
         pMAO2 := pMAO
         DO CASE
         CASE LastKey() = K_ESC
            IF MDG( 'Encerrar Consulta' )
               EXIT
            ENDIF
            LOOP
         CASE LastKey() = K_ALT_F10
            MDS( 'Imprimindo' )
            MANLISTA()
         CASE LastKey() = K_INS
            MDS( 'Incluindo ' )
            fMAO( 1, pMAO )
         CASE LastKey() = K_ENTER .AND. wMAO # 3
            MDS( 'Alterando ' )
            fMAO( 2, pMAO )
         CASE LastKey() = K_ENTER .AND. wMAO = 3
            MDS( 'Escolhendo' )
            fMAO( 6, pMAO )
            RETU
         CASE LastKey() = K_DEL
            MDS( 'Excluindo ' )
            fMAO( 3, pMAO )
         CASE LastKey() = K_CTRL_ENTER
            nIBUS   := IF( lPBUS, NUMIND( "MO01" ), nIBUS )
            mCHABUS := PEGBUS( "MO01", nIBUS )
            IF nIBUS # 1
               nREG := REGBUS( "MO01", nIBUS, mCHABUS )
            ENDIF
            pMAO := AScan( aMAO2, mCHAVE )
            IF pMAO = 0
               ALERTX( 'N„o localizei o Registro Correspondente ....' )
               pMAO := pMAO2
               LOOP
            ENDIF
         OTHERWISE
            LOOP
         ENDCASE
      ENDDO
   ENDIF
   IF cVIDE = "N"
      METNVI( "MO01", {|| fMAO( 1, 0 ) }, {|| fMAO( 3, 0 ) }, {|| fMAO( 2, 0 ) }, ;
         {|| fMAO( 6, 0 ) }, {|| fMAO( 2, - 1 ) }, MAO001, wMAO )
   ENDIF
   IF cVIDE = 'P'
      METPAG( "MO01", { MAO001, MAO002, MAO005, MAO006, MAO007 }, "mPEDIDO", wMAO, ;
         {|| TELASAY( aMAOTEL ) }, {|| fMAO( 1, 0 ) }, {|| fMAO( 3, 0 ) }, {|| fMAO( 2, 0 ) }, ;
         {|| fMAO( 6, 0 ) } )
   ENDIF

   IF cVIDE = 'I'
      METINT( "MO01",, {|| fMAO( 2, - 1 ) } )
   ENDIF

   IF wMAO = 0
      // LIBERA VARIAVEIS
      RELEASE ALL LIKE m *   // LIMPAVARS("MO01")
   ENDIF

// EFETUA O PACK SE NECESSARIO
   IF PCK .AND. lFIXA
      FIXAR( "MO01" )
      FIXAR( "MO02" )
   ENDIF
   RETU .T.

// ******************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fMAO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC fMAO( OPRMAO, POSMAO )  // INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

// ******************
// Pegar a Chave de Busca
   INCLUI := .F.
   IF OPRMAO # 1
      IF cVIDE = 'S'
         mCHAVE := aMAO2[ POSMAO ]   // mPEDIDO=aMAO2[POSMAO]
      ENDIF
      IF cVIDE = "N"
         PEGBUS( "MO01", 1 )
      ENDIF
   ENDIF

// Opera‡„o de Exclus„o
   IF OPRMAO = 3
      mPEDIDO := mCHAVE
      IF APAGAREG( "MO01", mCHAVE )   // IF APAGAREG("MO01",mPEDIDO)
         IF cVIDE = "S"
            aMAO1[ POSMAO ] = ' ' + Str( mPEDIDO, 8 ) + ' - Registro Excluido / Apagado / Deletado'
         ENDIF
         PADDEL( "MO02", Str( mCHAVE, 8 ), "mCHAVE", "PEDIDO" )
         PCK := .T.
      ENDIF
      RETU .T.
   ENDIF

// Opera‡„o de Inclus„o
   IF OPRMAO = 1
      mPEDIDO := ULTIMOREG( "MO01", "PEDIDO" )
      mPEDIDO++
      PEGBUS( "MO01", 1 )
      mDATA := ZDATA
      mOS   := mPEDIDO
      IF !NOVOREG( "MO01", mCHAVE )
         RETU .F.
      ENDIF
      INCLUI := .T.
   ENDIF



// IGUALAR mVARS
   IF !IGUALVARS( "MO01", mCHAVE )  // IF ! IGUALVARS("MO01",mPEDIDO)
      RETU .F.
   ENDIF

// Variaveis de Checagem
   xCUSTOTAB := mCUSTOTAB
   xCUSTOIND := mCUSTOIND


   SET KEY K_F11 TO TECLAF11
// Metodo de Edi‡„o
   IF cTIPG = "1"
      // Desenha a Tela
      TELASAY( aMAOTEL )
      // Get nas Menvars
      EDITSAY( aMAOGET )
   ELSE
      EDITGET( .T., MAO107, MAO102, MAO105, MAO106 )
   ENDIF
   SET KEY K_F11 TO


// Posiciona o Novo Elemento na Matriz
   IF cVIDE = 'S' .AND. OPRMAO = 1
      nSBAR++
      AAdd( aMAO1, NIL )
      AAdd( aMAO2, NIL )
      POSMAO := Len( aMAO1 )
      POSW   := 1
      IF POSMAO > 1
         FOR X := 1 TO POSMAO - 1
            mDARE := aMAO2[ X ]
            IF mCHAVE <= mDARE   // IF mPEDIDO<=mDARE
               EXIT
            ENDIF
         NEXT
         POSW := X
      ENDIF
      AIns( aMAO1, POSW )
      AIns( aMAO2, POSW )
      aMAO1[ POSW ] = ' ' + Str( mPEDIDO, 8 ) + ' ' + DToC( mDATA ) + ' ' + Str( mOS, 8, 2 ) + ' ' + Str( mFORNECEDO, 5 ) + ' ' + mCOGNOME + ' ' + Str( mTOTNF, 18, 2 )
      aMAO2[ POSW ] = mPEDIDO
      pMAO   := POSW
      POSMAO := POSW
   ENDIF

   xICM    := mICM
   xPEDIDO := mPEDIDO
   M_AO2( 1 )


// Atualiza as Matrizes
   IF cVIDE = 'S'
      aMAO1[ POSMAO ] = ' ' + Str( mPEDIDO, 8 ) + ' ' + DToC( mDATA ) + ' ' + Str( mOS, 8, 2 ) + ' ' + Str( mFORNECEDO, 5 ) + ' ' + mCOGNOME + ' ' + Str( mTOTNF, 18, 2 )
      aMAO2[ POSMAO ] = mPEDIDO
   ENDIF

   REPORVARS( "MO01", mCHAVE )

   RETU .T.


// *********


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAXO01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAXO01()

   IF INCLUI
      PEGACAMPO( "MA01", "mFORNECEDO", { "COGNOME", "ESTADO", "CONDPAG", "VENDEDOR", "ZONA" }, { "mCOGNOME", "mESTADO", "mCONDPAG", "mVENDEDOR", "mZONA" } )
   ELSE
      PEGACAMPO( "MA01", "mFORNECEDO", { "COGNOME", "ESTADO" }, { "mCOGNOME", "mESTADO" } )
      IF Empty( mCONDPAG )
         mCONDPAG := OBTER( "MA01", mFORNECEDO, "CONDPAG" )
      ENDIF
      IF Empty( mVENDEDOR )
         mVENDEDOR := OBTER( "MA01", mFORNECEDO, "VENDEDOR" )
      ENDIF
      IF Empty( mZONA )
         mZONA := OBTER( "MA01", mFORNECEDO, "ZONA" )
      ENDIF
   ENDIF
   mICM := OBTER( "MD05", mESTADO, "ALIQUOTA" )
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAXO02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAXO02( nROW, nCOL )

   CHECKEXI( "MC01", "mVENDEDOR", "STRVAL(NUMERO)+' '+NOME", "NUMERO", "NUMERO", )
   IF Empty( mCOMISSAO ) .AND. !Empty( mVENDEDOR )
      mCOMISSAO := OBTER( "MC01", mVENDEDOR, "PORCOMIS" )
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAO03X()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAO03X

// Nada mudou retorna
   IF xCUSTOTAB = mCUSTOTAB .AND. xCUSTOIND = mCUSTOIND
      RETU .T.
   ENDIF
// Trocou o Indice Manual Zera a tabela
   IF xCUSTOIND # mCUSTOIND
      mCUSTOTAB := Space( 12 )
      @ 15, 21 SAY mCUSTOTAB
   ENDIF
// Mudou a Data Atualiza Indices
   IF xDATABASE # mDATABASE
      mCUSTOIND := Round( OBTER( "MD02", PadR( mCUSTOTAB, 24 ) + DToS( mDATABASE ), "VARIACAO" ), 2 )
      @ 15, 36 SAY mCUSTOIND PICTURE '99.99'
   ENDIF
// Mudou a tabela Despesas Financeiras
   IF !Empty( mCUSTOTAB ) .AND. xCUSTOTAB # mCUSTOTAB
      mCUSTOIND := Round( OBTER( "MD02", PadR( mCUSTOTAB, 24 ) + DToS( mDATABASE ), "VARIACAO" ), 2 )
      @ 15, 36 SAY mCUSTOIND PICTURE '99.99'
   ENDIF
// Guarda a Variavel de Referencia
   xCUSTOTAB := mCUSTOTAB
   xDATABASE := mDATABASE
   xCUSTOIND := mCUSTOIND
   RETU .T.



// + EOF: m_ao.prg
// +
