// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_drc.prg
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
// :   M_DRC  .PRG : Configuracao do Mala Direta
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :  Procs & Fncts: fMDRC()
// :
// :    Chamado por:
// :
// :          Chama: fMDRC  (fun‡„o em M_DRC.PRG )
// :
// :  Arq. Dados   : MALACONF   - Configuracao do Mala Direta
// :
// :  Indices      : MALACONF   - Codigo da Mala
// :                 CODIGO
// :
// :
// :  Documentado em:  24, 1995 as 11:42:05                DISK!  vers„o 5.01
// :*****************************************************************************

#include "BOX.CH"


// Recebendo Parametro de Trabalho


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_drc()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_drc

   PARA wMDRC, wpMDRC, wcMDRC

   aLOG1 := {}   // Logradouro Descricao
   aLOG2 := {}   // Logradouro p/ Campo
// Montando os Logradouros
   MONTATAB( "ABRVTIPO", "aLOG1", "aLOG2" )



/* 3o. Paramentro
   0 - Cria e Carrega as Matrizes
   1 - N„o Cria e Carrega as Matrizes
   2 - N„o Cria e N„o Carrega as Matrizes
*/
   IF PCount() < 3
      wcMDRC := 0
   ENDIF


// Teclas Operacionais
// #INCLUDE "TECLAS.CH"
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

// Modo de Trabalho no Video
   MDI( " Ý ",,, "MALACONF" )

// Configura‡„o de Trabalho
   PRIV lFIXA, nACHO, cVIDE, lPBUS, lPIND, mCBAR, mCBARM, cTIPG, aGETS, cCBAS, nIBUS
   PRIV nIEXI, aIND, nREG
   IF !CONFARQ( "MALACONF", "Codigo   Descri‡„o" + spac( 52 ) + "Arquivo" )
      RETU .F.
   ENDIF
   IF !CONFIND( "MALACONF" )
      RETU .F.
   ENDIF


// Pegando Cores de Trabalho
   CORMDRC := CORARR( "MDRC" )

// Variaveis de Trabalho
   PRIV PCK    := .F.
   PRIV mCHAVE
   IF wMDRC = 0
      CRIARVARS( "MALACONF" )
      CRIARVARS( HELPARQ )
   ENDIF
// CRIANDO MATRIZES
   IF wcMDRC = 0
      aMDRC1 := {}   // Matriz com os dizeres do Achoice
      aMDRC2 := {}   // Codigo da Mala
   ENDIF

   PRIV wCHA  := "CODIGO"
   PRIV wMCHA := "mCODIGO"

// Telas de Trabalho
   aMANTEL := TELAPEG( "MDRC01" )
   aMANGET := EDITPEG( "MDRC01" )


// Incializando a ajuda on Line
   PRIV HELPDBF := "MALACONF"

// Carregando Matriz
   IF cVIDE = "S" .AND. wcMDRC # 2
      nIND := IF( lPIND, NUMIND( "MALACONF" ), nIEXI )
      IF !USEREDE( "MALACONF", 1, nIND )
         RETU
      ENDIF
      GRAF := LastRec()
      IF GRAF > nACHO
         dbCloseArea()
         ALERTX( "Muitos Arquivos para o Modo Video" )
         cVIDE := "N"
      ELSE
         xGRAF := 0
         xPOS  := 1
         MARCAR()
         dbGoTop()
         WHILE !Eof()
            IF !Empty( mCBAR )
               AAdd( aMDRC1, &mCBAR. )
            ELSE
               AAdd( aMDRC1, ' ' + Str( CODIGO, 8 ) + ' ' + DESCRICAO + ' ' + DBF )
            ENDIF
            AAdd( aMDRC2, CODIGO )
            xPOS++
            MARCAR1()
            dbSkip()
         ENDDO
         dbCloseArea()
         IF xPOS = 1
            IF !mdg( 'Nenhum Lan‡amento Neste Arquivo Deseja Incluir' )
               RETU .F.
            ENDIF
            nSBAR := 0
            IF !fMDRC( 1, 0 )
               RETU .F.
            ENDIF
         ENDIF
      ENDIF
   ENDIF

// Posi‡„o Inicial do Ponteiro
   IF PCount() = 1
      pMDRC := 1
   ELSE
      pMDRC := AScan( aMDRC2, wpMDRC )
      pMDRC := IF( pMDRC = 0, 1, pMDRC )
   ENDIF

// Processando o M‚todo Escolhido
   IF cVIDE = 'S'
      NOBREAK()
      PRIV nSBAR, aSBAR
      nSBAR := Len( aMDRC1 )
      aSBAR := ScrollBarNew( 04, 79, 23, SubStr( CORMDRC[ 1 ], RAt( ",", CORMDRC[ 1 ] ) + 1 ), pMDRC )
      ScrollBarDisplay( aSBAR )
      ScrollBarUpdate( aSBAR, pMDRC, nSBAR, .T. )
      WHILE .T.
         SetColor( CORMDRC[ 1 ] )
         hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
         @  3, 1 SAY cCBAS
         @  4, 0 SAY '+' + Replicate( '-', 78 ) + 'Ý'
         MDS( 'Busca=CTRL+ENTER ~ ALF+F2=Conf.Edit ALT+ENT=Referencia ALT+F10 Listar' )
         SetColor( CORMDRC[ 1 ] )
         ScrollBarUpdate( aSBAR, pMDRC, nSBAR, .T. )
         ScrollBarDisplay( aSBAR )
         pMDRC2 := AChoice( 05, 01, 22, 78, aMDRC1,, "ACHRETB", pMDRC )
         pMDRC  := IF( pMDRC2 # 0, pMDRC2, pMDRC )
         pMDRC2 := pMDRC
         DO CASE
         CASE LastKey() = K_ESC
            IF mdg( 'Encerrar Consulta' )
               EXIT
            ENDIF
            LOOP
         CASE LastKey() = K_ALT_F10
            fMDRC( 8, pMDRC )
         CASE LastKey() = K_INS
            fMDRC( 1, pMDRC )
         CASE LastKey() = LK_ALT_ENT
            fMDRC( 2, pMDRC )
         CASE LastKey() = K_ENTER
            fMDRC( 6, pMDRC )
         CASE LastKey() = K_DEL
            fMDRC( 3, pMDRC )
         CASE LastKey() = LK_ALT_F2
            fMDRC( 7, pMDRC )
         CASE LastKey() = K_CTRL_ENTER .OR. LastKey() = K_CTRL_F2  // CTRL+ENTER USO O aMAA1
            nIBUS   := IF( lPBUS, NUMIND( "MALACONF" ), nIBUS )
            mCHABUS := PEGBUS( "MALACONF", nIBUS )
            IF nIBUS # 1
               nREG := REGBUS( "MALACONF", nIBUS, mCHABUS )
            ENDIF
            pMDRC := AScan( aMDRC2, mCHAVE )
            IF pMDRC = 0
               ALERTX( 'Nao localizei o Registro Correspondente ....' )
               pMDRC := pMDRC2
               LOOP
            ENDIF
         OTHERWISE
            LOOP
         ENDCASE
      ENDDO
   ENDIF
   IF cVIDE = "N"
      METNVI( "MALACONF", {|| fMDRC( 1, 0 ) }, {|| fMDRC( 3, 0 ) }, {|| fMDRC( 2, 0 ) }, ;
         {|| fMDRC( 6, 0 ) }, {|| fMDRC( 2, - 1 ) }, CORMDRC[ 1 ], wMDRC )
   ENDIF
   IF cVIDE = 'P'
      METPAG( "MALACONF", CORMDRC, "mCODIGO", wMDRC, ;
         {|| tMDRC }, {|| fMDRC( 1, 0 ) }, ;
         {|| fMDRC( 3, 0 ) }, {|| fMDRC( 2, 0 ) }, ;
         {|| fMDRC( 6, 0 ) } )
   ENDIF
   IF cVIDE = 'T'
      METBRO( "MALACONF", { { "CODIGO", "mCODIGO" } }, CORMDRC, ;
         {|| ' ' + Str( CODIGO, 8 ) + ' ' + DESCRICAO + ' ' + DBF }, {|| TELASAY( aMANTEL ) }, ;
         {|| EDITSAY( aMANGET ) },,, wMDRC )
   ENDIF
   IF cVIDE = 'I'
      METINT( "MALACONF",, {|| fMDRC( 2, - 1 ) } )
   ENDIF

   IF wMDRC = 0
      // LIBERA VARIAVEIS
      RELEASE ALL LIKE m *   // LIMPAVARS("MALACONF")
   ENDIF

// EFETUA O PACK SE NECESSARIO
   IF PCK .AND. lFIXA
      FIXAR( "MALACONF" )
   ENDIF
   RETU .T.

// ******************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fMDRC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC fMDRC( OPRMDRC, POSMDRC )   // INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

// ******************
// Pegar a Chave de Busca
   IF OPRMDRC # 1
      IF cVIDE = 'S'
         mCHAVE := aMDRC2[ POSMDRC ]
      ENDIF
      IF cVIDE = 'N' .AND. POSMDRC # -1
         PEGBUS( "MALACONF", 1 )
      ENDIF
   ENDIF

// Opera‡„o de Exclus„o
   IF OPRMDRC = 3
      IF APAGAREG( "MALACONF", mCHAVE )
         IF cVIDE = "S"
            aMDRC1[ POSMDRC ] = ' ' + Str( mCODIGO ) + ' - Registro Excluido / Apagado / Deletado'
         ENDIF
         PCK := .T.
      ENDIF
      RETU .T.
   ENDIF

// Opera‡„o de Inclus„o
   IF OPRMDRC = 1
      mCODIGO := ULTIMOREG( "MALACONF", "CODIGO" )
      mCODIGO++
      PEGBUS( "MALACONF", 1 )
      IF !NOVOREG( "MALACONF", mCHAVE )
         RETU .F.
      ENDIF
   ENDIF



// IGUALAR mVARS
   IF !IGUALVARS( "MALACONF", mCHAVE )
      RETU .F.
   ENDIF

   IF OPRMDRC = 6
      ARQWORK := AllTrim( mDBF )
      M_DR( 0 )
      RETU .T.
   ENDIF

   IF OPRMDRC = 7
      M_CO2( 1 )
      RETU .T.
   ENDIF

   IF OPRMDRC = 8
      ARQWORK := AllTrim( mDBF )
      AUTOMENU( " Ý Clienete", "MBA", 24, "MANSUB" )
      RETU .T.
   ENDIF


// Metodo de Edi‡„o
   IF cTIPG = "1"
      // Desenha a Tela
      TELASAY( aMANTEL )
      // Get nas Menvars
      EDITSAY( aMANGET )
   ELSE
      EDITGET( .T., CORMDRC )
   ENDIF



// Atualiza as Matrizes se nao for inclusao
   IF cVIDE = 'S' .AND. OPRMDRC # 1
      IF !Empty( mCBARM )
         aMDRC1[ POSMDRC ] = &mCBARM.
      ELSE
         aMDRC1[ POSMDRC ] = ' ' + Str( mCODIGO, 8 ) + ' ' + mDESCRICAO + ' ' + mDBF
      ENDIF
      aMDRC2[ POSMDRC ] = mCODIGO
   ENDIF

// Posiciona o Novo Elemento na Matriz
   IF cVIDE = 'S' .AND. OPRMDRC = 1
      nSBAR++
      AAdd( aMDRC1, NIL )
      AAdd( aMDRC2, NIL )
      POSMDRC := Len( aMDRC1 )
      POSW    := 1
      IF POSMDRC > 1
         FOR X := 1 TO POSMDRC - 1
            mDARE := aMDRC2[ X ]
            IF mCHAVE <= mDARE
               EXIT
            ENDIF
         NEXT
         POSW := X
      ENDIF
      AIns( aMDRC1, POSW )
      AIns( aMDRC2, POSW )
      IF !Empty( mCBARM )
         aMDRC1[ POSW ] = &mCBARM.
      ELSE
         aMDRC1[ POSW ] = ' ' + Str( mCODIGO, 8 ) + ' ' + mDESCRICAO + ' ' + mDBF
      ENDIF
      aMDRC2[ POSW ] = mCODIGO
      pMDRC := POSW
   ENDIF

   REPORVARS( "MALACONF", mCHAVE )


   RETU .T.






// + EOF: m_drc.prg
// +
