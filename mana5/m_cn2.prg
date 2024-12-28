// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_cn2.prg
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
// :   M_CN2  .PRG :
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :  Procs & Fncts: fMCN2()
// :
// :    Chamado por:
// :
// :          Chama: fMCN2  (fun‡„o em M_CN2.PRG )
// :
// :  Arq. Dados   : ARQREL     -
// :
// :  Indices      : ARQREL-1   - Codigo do Relatorio
// :                 MENU+CODIGO
// :
// :
// :  Documentado em:  16, 1994 as 14:08:10                DISK!  vers„o 5.01
// :*****************************************************************************




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_cn2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_cn2

// Recebendo Parametro de Trabalho
   PARA wMCN2, wpMCN2, wcMCN2

/* 3o. Paramentro
   0 - Cria e Carrega as Matrizes
   1 - N„o Cria e Carrega as Matrizes
   2 - N„o Cria e N„o Carrega as Matrizes
*/
   IF PCount() < 3
      wcMCN2 := 0
   ENDIF


// Teclas Operacionais
// #INCLUDE "TECLASM.CH"
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

// Modo de Trabalho no Video
   MDI( " Ý ",,, ARQREL )

// Configura‡„o de Trabalho
   PRIV lFIXA, nACHO, cVIDE, lPBUS, lPIND, mCBAR, mCBARM, cTIPG, aGETS, cCBAS, nIBUS
   PRIV nIEXI, aIND, nREG
   IF !CONFARQ( ARQREL, "C¢digo   Relat¢rio", ;
         "' '+mCODIGO+' '+mNOME" )
      RETU .F.
   ENDIF
   IF !CONFIND( ARQREL )
      RETU .F.
   ENDIF

// Pegando Cores de Trabalho
   CORMCN2 := CORARR( "MCN2" )


   aTELMCN2 := TELAPEG( "MCN201" )

// Variaveis de Trabalho
   PRIV PCK    := .F.
   PRIV mCHAVE
   IF wMCN2 = 0
      CRIARVARS( ARQREL )
   ENDIF
// CRIANDO MATRIZES
   IF wcMCN2 = 0
      aMCN21 := {}   // Matriz com os dizeres do Achoice
      aMCN22 := {}   // Codigo do Relatorio
   ENDIF

// Incializando a ajuda on Line
   PRIV HELPDBF := ARQREL

// Carregando Matriz
   IF cVIDE = "S" .AND. wcMCN2 # 2
      nIND := IF( lPIND, NUMIND( ARQREL ), nIEXI )
      IF !USEREDE( ARQREL, 1, nIND )
         RETU
      ENDIF
      GRAF  := LastRec()
      xGRAF := 0
      xPOS  := 1
      MARCAR()
      dbGoTop()
      dbSeek( mMENU )
      WHILE MENU = mMENU .AND. !Eof()
         IF !Empty( mCBAR )
            AAdd( aMCN21, &mCBAR. )
         ELSE
            AAdd( aMCN21, ' ' + CODIGO + ' ' + NOME )
         ENDIF
         AAdd( aMCN22, MENU + CODIGO )
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
         IF !fMCN2( 1, 0 )
            RETU .F.
         ENDIF
      ENDIF
   ENDIF

// Posi‡„o Inicial do Ponteiro
   IF PCount() = 1
      pMCN2 := 1
   ELSE
      pMCN2 := AScan( aMCN22, wpMCN2 )
      pMCN2 := IF( pMCN2 = 0, 1, pMCN2 )
   ENDIF

// Processando o M‚todo Escolhido
   IF cVIDE = 'S'
      NOBREAK()
      PRIV nSBAR, aSBAR
      nSBAR := Len( aMCN21 )
      aSBAR := ScrollBarNew( 04, 79, 23, SubStr( CORMCN2[ 1 ], RAt( ",", CORMCN2[ 1 ] ) + 1 ), pMCN2 )
      ScrollBarDisplay( aSBAR )
      ScrollBarUpdate( aSBAR, pMCN2, nSBAR, .T. )
      WHILE .T.
         CABVID( CORMCN2[ 1 ], pMCN2 )
         nKEY := 0
         KEYBOARD Chr( 255 )
         bELE := {| X | aMCN21[ X ] }
         cCOR := CORMCN2[ 1 ]
         IF wMCN2 = 3
            @ 24, 65 SAY "ALT+ENTER=LISTAR"
         ENDIF
         pMCN22 := AChoice( 05, 01, 22, 78, aMCN21,, "ACHMOU", pMCN2 )
         pMCN2  := IF( pMCN22 # 0, pMCN22, pMCN2 )
         pMCN22 := pMCN2
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
            fMCN2( 1, pMCN2 )
         CASE LastKey() = K_ENTER .AND. wMCN2 # 3
            MDS( 'Alterando ' )
            fMCN2( 2, pMCN2 )
         CASE ( LastKey() = K_ENTER .AND. wMCN2 = 3 ) .OR. ( LastKey() = LK_ALT_ENT .AND. wMCN2 # 3 )
            fMCN2( 6, pMCN2 )
            cTELA := SaveScreen( 00, 00, 2, 79 )
            MANB2()
            IMPEND()
            RestScreen( 00, 00, 2, 79, cTELA )
         CASE LastKey() = K_DEL
            MDS( 'Excluindo ' )
            fMCN2( 3, pMCN2 )
         CASE LastKey() = K_CTRL_ENTER
            nIBUS   := IF( lPBUS, NUMIND( ARQREL ), nIBUS )
            mCHABUS := PEGBUS( ARQREL, nIBUS )
            IF nIBUS # 1
               nREG := REGBUS( ARQREL, nIBUS, mCHABUS )
            ENDIF
            pMCN2 := AScan( aMCN22, mCHAVE )
            IF pMCN2 = 0
               ALERTX( 'Nao localizei o Registro Correspondente ....' )
               pMCN2 := pMCN22
               LOOP
            ENDIF
         OTHERWISE
            LOOP
         ENDCASE
      ENDDO
   ENDIF

   IF wMCN2 = 0
      // LIBERA VARIAVEIS
      RELEASE ALL LIKE m *   // LIMPAVARS(ARQREL)
   ENDIF

// EFETUA O PACK SE NECESSARIO
   IF PCK .AND. lFIXA
      FIXAR( ARQREL )
   ENDIF
   RETU .T.

// ******************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fMCN2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC fMCN2( OPRMCN2, POSMCN2 )   // INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

// ******************//Pegar a Chave de Busca
   IF OPRMCN2 # 1
      IF cVIDE = 'S'
         mCHAVE := aMCN22[ POSMCN2 ]
      ENDIF
      IF cVIDE = 'N' .AND. POSMCN2 # -1
         PEGBUS()
      ENDIF
   ENDIF

// Opera‡„o de Exclus„o
   IF OPRMCN2 = 3
      IF !PEGACS( "O", "E" + ARQREL + ZUSER, .T., "Exclus„o n„o Liberado" )
         RETU .F.
      ENDIF
      IF APAGAREG( ARQREL, mCHAVE,, .F. )
         PADDEL( ARQRE1, mCHAVE, "CODIGO", "mCODIGO" )
         IF cVIDE = "S"
            aMCN21[ POSMCN2 ] = ' ' + mCODIGO + ' - Registro Excluido / Apagado / Deletado'
         ENDIF
         PCK := .T.
      ENDIF
      RETU .T.
   ENDIF

// Opera‡„o de Inclus„o
   IF OPRMCN2 = 1
      IF !PEGACS( "O", "I" + ARQREL + ZUSER, .T., "Inclus„o n„o Liberado" )
         RETU .F.
      ENDIF
      PEGBUS()
      IF !NOVOREG( ARQREL, mCHAVE )
         RETU .F.
      ENDIF
   ENDIF



// IGUALAR mVARS
   IF !IGUALVARS( ARQREL, mCHAVE )
      RETU .F.
   ENDIF

   IF OPRMCN2 = 6
      RETU .T.
   ENDIF

// Metodo de Edi‡„o
   IF cTIPG = "1"
      // Desenha a Tela
      TELASAY( aTELMCN2 )
      // Get nas Menvars
      gMCN2()
   ELSE
      EDITGET( .T., CORMCN2 )
   ENDIF



// Atualiza as Matrizes se nao for inclusao
   IF cVIDE = 'S' .AND. OPRMCN2 # 1
      IF !Empty( mCBARM )
         aMCN21[ POSMCN2 ] = &mCBARM.
      ELSE
         aMCN21[ POSMCN2 ] = ' ' + mCODIGO + ' ' + mNOME
      ENDIF
      aMCN22[ POSMCN2 ] = mMENU + mCODIGO
   ENDIF

// Posiciona o Novo Elemento na Matriz
   IF cVIDE = 'S' .AND. OPRMCN2 = 1
      nSBAR++
      AAdd( aMCN21, NIL )
      AAdd( aMCN22, NIL )
      POSMCN2 := Len( aMCN21 )
      POSW    := 1
      IF POSMCN2 > 1
         FOR X := 1 TO POSMCN2 - 1
            mDARE := aMCN22[ X ]
            IF mCHAVE <= mDARE
               EXIT
            ENDIF
         NEXT
         POSW := X
      ENDIF
      AIns( aMCN21, POSW )
      AIns( aMCN22, POSW )
      IF !Empty( mCBARM )
         aMCN21[ POSW ] = &mCBARM.
      ELSE
         aMCN21[ POSW ] = ' ' + mCODIGO + ' ' + mNOME
      ENDIF
      aMCN22[ POSW ] = mMENU + mCODIGO
      pMCN2 := POSW
   ENDIF

   REPORVARS( ARQREL, mCHAVE )

   RETU .T.



// Get Nas Mvars


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMCN2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gMCN2

   SetColor( CORMCN2[ 2 ] )
   @  4, 2  GET mCODIGO
   @  4, 11 GET mNOME
   @  4, 76 GET mFOLHA
   READCUR()
   @ 07, 02 SAY 'Nome que sera Impresso Como o Cabec rio desta Lista:'
   @ 08, 02 GET mNOME_LISTA                                                      PICT "@S76"
   @ 09, 02 SAY 'A que Menu de Cadastros pertence o Lay-out desta Lista ?(A-Z):' GET mMENU1
   @ 10, 02 SAY 'Qual ‚ o C¢digo do Lay-out que sera usado nesta Lista  ?     :' GET mCODIGO1
   READCUR()
   IF Empty( mMENU1 )
      mMENU1 := mMENU
   ENDIF
   IF Empty( mCODIGO1 )
      mCODIGO1 := mCODIGO
   ENDIF
   @ 11, 02 SAY 'Esta Lista Sera Tipo Etiqueta (S,N,%) ? :' GET mETIQ VALID mETIQ $ "SsNn%"
   READCUR()
   IF mdg( 'Deseja Configurar os Detalhes desta Lista ? ' )
      @ 24, 00
      IF mETIQ $ "Ss"
         @ 12, 02 SAY 'Quantas Colunas/Caracteres cabera em sua Etiqueta = ' GET mLARGURA
         @ 13, 02 SAY 'Quantas Linhas / Altura cabera em sua Etiqueta    = ' GET mALTURA
         @ 14, 02 SAY 'Quantas Etiquetas tem em 1 Linha / Carreiras por fl=' GET mCOLUNAS
         READCUR()
         @ 12, 02 CLEAR TO 14, 78
         @ 12, 02 SAY 'A Etiqueta cabera: Colunas =' + Str( mLARGURA, 3 ) + ' Linhas =' + Str( mALTURA, 3 ) + ' Carreiras =' + Str( mCOLUNAS )
      ELSE
         @ 13, 02 SAY 'Nro.Arquivo Tem Ligacao/Relacao com os seguintes Campos do 1o.Arquivo'
         @ 14, 04 GET mREL1ARQ                                                                VALID mREL1ARQ < 6
         @ 14, 07 GET mRELACAO1
         @ 15, 04 GET mREL2ARQ                                                                VALID mREL2ARQ < 6
         @ 15, 07 GET mRELACAO2
         @ 16, 04 GET mREL3ARQ                                                                VALID mREL3ARQ < 6
         @ 16, 07 GET mRELACAO3
         @ 17, 04 GET mREL4ARQ                                                                VALID mREL4ARQ < 6
         @ 17, 07 GET mRELACAO4
         READCUR()
         @ 13, 02 CLEAR TO 18, 78
         @ 13, 02 SAY 'A Lista tera as quebras em quais campos e quais Arquivos:'
         FOR I := 0 TO 4
            AREA := Str( I + 1, 1 )
            @ 14, 13 SAY 'Arquivo: ' + AREA
            @ 15, 15 SAY 'Quebras (1-5)'
            @ 16, 10 SAY '01'
            @ 17, 10 SAY '02'
            @ 18, 10 SAY '03'
            @ 19, 10 SAY '04'
            @ 20, 10 SAY '05'
            @ 16, 15 GET mQUEBRA&AREA.A
            @ 17, 15 GET mQUEBRA&AREA.B
            @ 18, 15 GET mQUEBRA&AREA.C
            @ 19, 15 GET mQUEBRA&AREA.D
            @ 20, 15 GET mQUEBRA&AREA.E
            READCUR()
         NEXT
      ENDIF
      @ 13, 01 CLEAR TO 23, 78
      @ 13, 4  SAY "Abrir os Arquivos e Indice Conforme Configura‡„o:"
      @ 14, 4  SAY "Arquivo  ? Ntx Nome dos Campos que dever„o ser impressos"
      @ 15, 1  SAY "01"
      @ 16, 1  SAY "02"
      @ 17, 1  SAY "03"
      @ 18, 1  SAY "04"
      @ 19, 1  SAY "05"
      @ 20, 1  SAY "06"
      @ 15, 4  GET mARQUIVO1
      @ 15, 13 GET mPIND1                                                     VALID MCN201( 1 ) .AND. mPIND1 $ 'SN' WHEN !Empty( mARQUIVO1 )
      @ 15, 18 GET mCAMPO1                                                    PICT "@S55"                         WHEN !Empty( mARQUIVO1 )
      @ 16, 4  GET mARQUIVO2
      @ 16, 13 GET mPIND2                                                     VALID MCN201( 2 ) .AND. mPIND2 $ 'SN' WHEN !Empty( mARQUIVO2 )
      @ 16, 18 GET mCAMPO2                                                    PICT "@S55"                         WHEN !Empty( mARQUIVO2 )
      @ 17, 4  GET mARQUIVO3
      @ 17, 13 GET mPIND3                                                     VALID MCN201( 3 ) .AND. mPIND3 $ 'SN' WHEN !Empty( mARQUIVO3 )
      @ 17, 18 GET mCAMPO3                                                    PICT "@S55"                         WHEN !Empty( mARQUIVO3 )
      @ 18, 4  GET mARQUIVO4
      @ 18, 13 GET mPIND4                                                     VALID MCN201( 4 ) .AND. mPIND4 $ 'SN' WHEN !Empty( mARQUIVO4 )
      @ 18, 18 GET mCAMPO4                                                    PICT "@S55"                         WHEN !Empty( mARQUIVO4 )
      @ 19, 4  GET mARQUIVO5
      @ 19, 13 GET mPIND5                                                     VALID MCN201( 5 ) .AND. mPIND5 $ 'SN' WHEN !Empty( mARQUIVO5 )
      @ 19, 18 GET mCAMPO5                                                    PICT "@S55"                         WHEN !Empty( mARQUIVO5 )
      @ 20, 4  GET mARQUIVO6
      @ 20, 13 GET mPIND6                                                     VALID MCN201( 6 ) .AND. mPIND6 $ 'SN' WHEN !Empty( mARQUIVO6 )
      @ 20, 18 GET mCAMPO6                                                    PICT "@S55"                         WHEN !Empty( mARQUIVO6 )
      @ 22, 02 SAY 'Filtrar Por o Arquivo 1 por :'                            GET mFILTRO                         PICT "@S46"
      @ 23, 02 SAY 'Configuracao/Set-up da Impre:'                            GET mSETUP                          PICT "@S46"
      READCUR()
      @ 11, 01 CLEAR TO 23, 78
      @ 11, 02 SAY 'O Arquivo Principal Desta Lista / Padrao : ' GET mSELECAO RANGE 1, 5
      READCUR()
      @ 12, 02 SAY 'Sub-Filtrar Por : De um Determinado Ponto Ate Outro :'
      @ 16, 18 SAY 'Ande com as Seta p/Cima ou Seta p/Baixo'
      @ 17, 18 SAY 'Posicione o Luminoso onde desejar para que na ocasiao'
      @ 18, 18 SAY 'de listar ele aparecera neste campo determinado por voce.'
      @ 20, 18 SAY 'Os nomes dentro da moldura sao nomes dos campos do arquivo'
      mARQPRI := "mARQUIVO" + StrTran( StrZero( mSELECAO, 2 ), "0", "" )
      ARQWORK := &mARQPRI
      // Pegando a Estrutura
      IF !USEREDE( ARQWORK, 1, 0 )
         RETU .F.
      ENDIF
      aESTRU := dbStruct()
      dbCloseAll()
      pESTRU := Len( aESTRU )
      dESTRU := Array( pESTRU )
      // Pegando os Coment rios
      USEREDE( HELPARQ, 1, 1 )
      FOR X := 1 TO pESTRU
         dbGoTop()
         dbSeek( PadR( ARQWORK, 8 ) + "M" + PadR( aESTRU[ X, 1 ], 9 ) )
         dESTRU[ X ] = PadR( aESTRU[ X, 1 ], 11 )
         IF Found()
            dESTRU[ X ] += AllTrim( DADO )
         ENDIF
      NEXT X
      mDEFAULT := RCAMPO( mDEFAULT )
      @ 11, 01 CLEAR TO 22, 78
      @ 11, 01 TO 20, 40
      @ 12, 3  SAY 'Variaveis para Auxilio em Relatorios'
      @ 13, 2  SAY 'N'
      @ 13, 6  SAY 'Descricao'
      @ 13, 34 SAY 'T'
      @ 13, 37 SAY 'Tam'
      @ 14, 01 TO 20, 40
      @ 15, 04 TO 19, 04
      @ 15, 32 TO 19, 32
      @ 15, 36 TO 19, 36
      @ 20, 01 TO 20, 40
      @ 15, 2  SAY '1'
      @ 15, 6  GET mDESCRICA1
      @ 15, 34 GET mFATOR1                                VALID CFATOR( '1' )
      @ 15, 38 GET mTAM1
      @ 16, 2  SAY '2'
      @ 16, 6  GET mDESCRICA2
      @ 16, 34 GET mFATOR2                                VALID CFATOR( '2' )
      @ 16, 38 GET mTAM2
      @ 17, 2  SAY '3'
      @ 17, 6  GET mDESCRICA3
      @ 17, 34 GET mFATOR3                                VALID CFATOR( '3' )
      @ 17, 38 GET mTAM3
      @ 18, 2  SAY '4'
      @ 18, 6  GET mDESCRICA4
      @ 18, 34 GET mFATOR4                                VALID CFATOR( '4' )
      @ 18, 38 GET mTAM4
      @ 19, 2  SAY '5'
      @ 19, 6  GET mDESCRICA5
      @ 19, 34 GET mFATOR5                                VALID CFATOR( '5' )
      @ 19, 38 GET mTAM5
      READCUR()
   ENDIF

   IF mdg( 'Deseja Incluir / Alterar / Excluir Dizeres do Lay-out  ?' )
      xMENU    := mMENU
      xMENU1   := mMENU1
      mMENU    := mMENU1
      xCODIGO1 := mCODIGO1
      M_CN3( 1 )
      mMENU  := xMENU
      mMENU1 := xMENU1
   ENDIF

   RETU .T.




// !*****************************************************************************
// !
// !         Fun‡„o: CFATOR()
// !
// !    Chamado por: M_CN2()             (fun‡„o    em M_CH1.PRG)
// !
// !*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CFATOR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CFATOR( P01 )

   LOCAL V01 := .F.
   PRIV V02  := 'mFATOR' + P01
   PRIV V03  := 'mTAM' + P01

   IF &V02 $ 'CDN '
      IF &V02 = 'N'
         &V03 := 15
         KEYBOARD Chr( 13 )
      ELSEIF &V02 = 'D'
         &V03 := 8
         KEYBOARD Chr( 13 )
      ENDIF
      V01 := .T.
   ELSE
      ALERTX( 'S„o Validos apenas os digitos C, D e N' )
   ENDIF

   RETURN V01



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MCN201()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MCN201( nIND )

   PRIV mARQ := "mARQUIVO" + Str( nIND, 1 )
   PRIV mIND := "mINDICE" + Str( nIND, 1 )

   &mIND. := NUMIND( &mARQ., &mIND. )
   @ 14 + nIND, 15 SAY &mIND. PICT "99"
   RETU .T.

// + EOF: m_cn2.prg
// +
