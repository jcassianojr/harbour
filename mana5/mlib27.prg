// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib27.prg
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



// Teclas Operacionais
// #INCLUDE "TECLASM.CH"
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
// #INCLUDE "MEMOGET.CH"



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

// * wPAD   -> Cria Variaveis
// * wpPAD  -> Posi��o no Achoice
// * wcPAD  -> Cria Matriz
// * wARQ   -> Arquivo de Trabalho
// * wCAB   -> String de Cabe�ario do Achoice
// * wSRO   -> String de Rolagem
// * wACOR  -> Matriz de Referencia de Cor ou String Inicial
// * wBTEL  -> Bloco de Tela de Apreseta��o dos Dados
// * wBGET  -> Bloco de Tela de Edi��o dos Dados
// * wBINS  -> Bloco Auxiliar de Novo Registro
// * wBMON  -> Bloco Montagem Matriz
// * wBKEY  -> Bloco de Teclas Auxiliares
// * wBIGU  -> Bloco para Processar Ap�s Igualvars
// * wBSAY  -> Bloco de Exibi��o de Teclas
// * lPADCRI -> Criarvars na inclusao .T. OU .F. padrao e .t.
// * bPOSREP -> Bloco Executar Apos o Reporvars
// * ePAD3   -> Expressao de Controle da Matriz de Totais
// * bDEL ->Bloco apos dele�ao
// * ppad ->Posi�ao cursor
// * Lpins ->Se pergunta Campos da Chave


   PARA wPAD, wpPAD, wcPAD, wARQ, wCAB, wSRO, wACOR, wBTEL, wBGET, ;
      wBINS, wBMON, wBKEY, wBIGU, wBSAY, lPADCRI, bPOSREP, ;
      ePAD3, bDEL, pPAD, lpINS, eFILTRO

   IF ValType( lPADCRI ) # "L"
      lPADCRI := .T.
   ENDIF

   IF ValType( lPINS ) # "L"
      lPINS := .T.
   ENDIF

   IF ValType( eFILTRO ) = "U"
      eFILTRO := .F.
   ENDIF

// ALERTX(strval(efiltro))

   IF PCount() < 3
      wcPAD := 0
   ENDIF

// Modo de Trabalho no Video
   MDI( " � ",,, wARQ )

// Configura��o de Trabalho
   PRIV lFIXA
   PRIV nACHO
   PRIV cVIDE
   PRIV lPBUS
   PRIV lPIND
   PRIV mCBAR
   PRIV mCBARM
   PRIV cTIPG
   PRIV aGETS
   PRIV cCBAS
   PRIV nIBUS
   PRIV nIEXI
   PRIV aIND
   PRIV nREG
   PRIV nROW
   IF !CONFARQ( wARQ, wCAB, wSRO )
      RETU .F.
   ENDIF
   IF !CONFIND( wARQ )
      RETU .F.
   ENDIF

   PRIV wMFOR := aIND[ 1, 4 ]
   PRIV wMVAR := aIND[ 1, 1, 3 ]
   PRIV wMCHA := if( Empty( wMFOR ), wMVAR, wMFOR )
   PRIV wCHA  := StrTran( wMCHA, "m", "" )

// Pegando Cores de Trabalho
   PRIV CORPAD := CORARR( wACOR )
   PRIV PAD001 := CORPAD[ 1 ]
   PRIV PAD002 := CORPAD[ 2 ]
   PRIV PAD005 := CORPAD[ 3 ]
   PRIV PAD006 := CORPAD[ 4 ]
   PRIV PAD007 := CORPAD[ 5 ]

// Verificando Tela
   IF ValType( wBTEL ) = "U" .AND. ValType( wACOR ) = "C"
      wBTEL := Left( wACOR + StrZero( 1, 6 - Len( wACOR ) ), 6 )
   ENDIF
   PRIV aPADTEL := {}
   IF ValType( wBTEL ) = "C"
      aPADTEL := TELAPEG( wBTEL )
      wBTEL   := {|| TELASAY( aPADTEL ) }
   ENDIF

// Verificando a Edi�ao
   IF ValType( wBGET ) = "U" .AND. ValType( wACOR ) = "C"
      wBGET := Left( wACOR + StrZero( 1, 6 - Len( wACOR ) ), 6 )
   ENDIF
   PRIV aPADGET := {}
   IF ValType( wBGET ) = "C"
      aPADGET := EDITPEG( wBGET )
      wBGET   := {|| EDITSAY( aPADGET ) }
   ENDIF

// Variaveis de Trabalho
   PRIV PCK    := .F.
   PRIV mCHAVE
   IF wPAD = 0
      CRIARVARS( wARQ )
   ENDIF
// CRIANDO MATRIZES
   IF wcPAD = 0
      PRIV aPAD1 := {}  // Matriz com os dizeres do Achoice
      PRIV aPAD2 := {}  // Numero de Cadastramento
      PRIV aPAD3 := {}  // Matriz de Controle de Totais
   ENDIF

// Incializando a ajuda on Line
   PRIV HELPDBF := wARQ

   IF ValType( eFILTRO ) = "L"
      IF eFILTRO
         eFILTRO := ''
         eFILTRO := RFILORD( wARQ, .F. )
      ENDIF
   ENDIF

// Carregando Matriz
   IF ValType( wBMON ) # "B"
      IF cVIDE = "S" .AND. wcPAD # 2
         nIND := if( lPIND, NUMIND( wARQ ), nIEXI )
         IF !USEREDE( wARQ, 1, nIND )
            RETU
         ENDIF
         IF ValType( eFILTRO ) = "C" .AND. !Empty( eFILTRO )
            SET FILTER TO &eFILTRO.
         ENDIF
         GRAF := LastRec()
         IF GRAF > nACHO
            dbCloseArea()
            ALERTX( "Muitos Arquivos para o Modo Video" )
            cVIDE := "T"
         ELSE
            xGRAF := 0
            xPOS  := 1
            MARCAR()
            dbGoTop()
            WHILE !Eof()
               AAdd( aPAD1, &mCBAR. )
               AAdd( aPAD2, &wCHA. )
               AAdd( aPAD3, PAD3MONT( .T. ) )
               xPOS++
               MARCAR1()
               dbSkip()
            ENDDO
            dbCloseArea()
            IF xPOS = 1
               IF !mdg( 'Nenhum Lancamento Neste Arquivo Deseja Incluir' )
                  RETU .F.
               ENDIF
               nSBAR := 0
               IF !fPAD( 1, 0 )
                  RETU .F.
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ELSE
      eRETU := Eval( wBMON )
      IF ValType( eRETU ) = "L"
         IF !eRETU
            RETU .F.
         ENDIF
      ENDIF
   ENDIF

// Posi��o Inicial do Ponteiro
   IF ValType( wpPAD ) # "U"
      pPAD := AScan( aPAD2, wpPAD )
      pPAD := if( pPAD = 0, 1, pPAD )
   ELSE
      pPAD := 1
   ENDIF

// Processando o M�todo Escolhido
   IF cVIDE = 'S'
      NOBREAK()
      PRIV nSBAR
      PRIV aSBAR
      nSBAR := Len( aPAD1 )
      aSBAR := ScrollBarNew( 04, 79, 24 - 1, SubStr( PAD001, RAt( ",", PAD001 ) + 1 ), pPAD )
      ScrollBarDisplay( aSBAR )
      ScrollBarUpdate( aSBAR, pPAD, nSBAR, .T. )
      WHILE .T.
         CABVID( PAD001, pPAD )
         nKEY := 0
         KEYBOARD Chr( 255 )
         bELE := {| X | aPAD1[ X ] }
         cCOR := PAD001
         IF ValType( wBSAY ) = "B"
            Eval( wBSAY )
         ENDIF
         pPAD2 := AChoice( 05, 01, 24 - 2, 78, aPAD1,, "ACHMOU", pPAD )
         pPAD  := if( pPAD2 # 0, pPAD2, pPAD )
         pPAD2 := pPAD
         nROW  := Row()
         DO CASE
         CASE LastKey() = K_ESC
            IF mdg( 'Encerrar Consulta' )
               PAD3TOT()
               EXIT
            ENDIF
            LOOP
         CASE LastKey() = K_ALT_F10
            MANLISTA()
         CASE LastKey() = K_INS
            fPAD( 1, pPAD )
         CASE LastKey() = K_ENTER .AND. wPAD # 3
            fPAD( 2, pPAD )
         CASE LastKey() = K_ENTER .AND. wPAD = 3
            fPAD( 6, pPAD )
            RETU
         CASE LastKey() = K_DEL
            fPAD( 3, pPAD )
         CASE LastKey() = K_CTRL_ENTER
            nIBUS   := if( lPBUS, NUMIND( wARQ ), nIBUS )
            mCHABUS := PEGBUS( wARQ, nIBUS )
            IF nIBUS # 1
               nREG := REGBUS( wARQ, nIBUS, mCHABUS )
            ELSE
               pPAD := AScan( aPAD2, mCHAVE )
               IF pPAD = 0 .AND. ValType( mCHABUS ) = "N"  // Simular jcassiano Seek
                  nREG := REGBUS( wARQ, nIBUS, mCHABUS )
               ENDIF
            ENDIF
            pPAD := AScan( aPAD2, mCHAVE )
            IF pPAD = 0
               ALERTX( 'Nao localizei o Registro Correspondente ....' )
               pPAD := pPAD2
               LOOP
            ENDIF
         CASE ValType( wBKEY ) = "B"
            Eval( wBKEY, nKEY, pPAD )
         OTHERWISE
            LOOP
         ENDCASE
      ENDDO
   ENDIF
   IF cVIDE = "N"
      METNVI( wARQ, {|| fPAD( 1, 0 ) }, {|| fPAD( 3, 0 ) }, {|| fPAD( 2, 0 ) }, ;
         {|| fPAD( 6, 0 ) }, {|| fPAD( 2, - 1 ) }, PAD001, wPAD )
   ENDIF
   IF cVIDE = 'P'
      METPAG( wARQ, { PAD001, PAD002, PAD005, PAD006, PAD007 }, wMCHA, wPAD, ;
         wBTEL, {|| fPAD( 1, 0 ) }, {|| fPAD( 3, 0 ) }, {|| fPAD( 2, 0 ) }, ;
         {|| fPAD( 6, 0 ) } )
   ENDIF
   IF cVIDE = 'T'
      aREP := {}
      FOR X := 1 TO 3
         IF !Empty( aIND[ 1, X, 3 ] )
            cVARGET := aIND[ 1, X, 3 ]
            AAdd( aREP, { StrTran( cVARGET, "m", "" ), cVARGET } )
         ENDIF
      NEXT X
      METBRO( wARQ, aREP, { PAD001, PAD002, PAD005, PAD006, PAD007 }, ;
         {|| &mCBAR. }, wBTEL, wBGET,,, wPAD,,,,, wBINS, bPOSREP, wBIGU, Bdel, eFILTRO )
   ENDIF
   IF cVIDE = 'I'
      METINT( wARQ,, {|| fPAD( 2, - 1 ) } )
   ENDIF

   IF wPAD = 0
      // LIBERA VARIAVEIS
      RELEASE ALL LIKE m *   // LIMPAVARS(wARQ)
   ENDIF

// EFETUA O PACK SE NECESSARIO
   IF PCK .AND. lFIXA
      FIXAR( wARQ )
   ENDIF
   RETU .T.




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

FUNC fPAD( OPRPAD, POSPAD )  // INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

// Variavel Flag de Inclus�o
   INCLUI := .F.
// Pegar a Chave de Busca
   IF OPRPAD # 1
      IF cVIDE = 'S'
         mCHAVE := aPAD2[ POSPAD ]
      ENDIF
      IF cVIDE = "N" .AND. POSPAD # -1
         PEGBUS()
      ENDIF
   ENDIF

// Opera��o de Exclus�o
   IF OPRPAD = 3
      IF !padraolib( "E", " Exclus�o n�o Liberado", WARQ )
         RETU .F.
      ENDIF
      IF MDG( "Apagar Registro" )
         IF APAGAREG( wARQ, mCHAVE, .F. )
            IF ValType( bDEL ) = "B"
               eRETU := Eval( bDEL )
               IF ValType( eRETU ) = "L"
                  IF !eRETU
                     RETU .F.
                  ENDIF
               ENDIF
            ENDIF
            IF cVIDE = "S"
               aPAD1[ POSPAD ] = ' Registro Excluido / Apagado / Deletado '
            ENDIF
            PCK := .T.
         ENDIF
      ENDIF
      RETU .T.
   ENDIF

// Opera��o de Inclus�o
   IF OPRPAD = 1
      IF !padraolib( "I", " Inclus�o n�o Liberado", WARQ )
         RETU .F.
      ENDIF
      IF lPADCRI
         CRIARVARS( wARQ )
      ENDIF
      IF ValType( wBINS ) = "B"
         eRETU := Eval( wBINS )
         IF ValType( eRETU ) = "L"
            IF !eRETU
               RETU .F.
            ENDIF
         ENDIF
      ENDIF
      IF lPINS
         PEGBUS()
      ENDIF
      IF !NOVOREG( wARQ, mCHAVE )
         RETU .F.
      ENDIF
      INCLUI := .T.
      nROW   := 24
   ENDIF

// IGUALAR mVARS
   IF !IGUALVARS( wARQ, mCHAVE )
      RETU .F.
   ENDIF

   IF ValType( wBIGU ) = "B"
      IF Eval( wBIGU, OPRPAD )
         RETU .T.
      ENDIF
   ENDIF

// Metodo de Edi��o
   SET KEY K_F11 TO TECLAF11
   SetColor( PAD002 )
   IF cTIPG = "1"
      // Desenha a Tela
      Eval( wBTEL )
      // Get nas Menvars
      Eval( wBGET )
   ELSE
      EDITGET( .T., CORPAD )
   ENDIF
   SET KEY K_F11 TO

// Atualiza as Matrizes se nao for inclusao
   IF cVIDE = 'S' .AND. OPRPAD # 1
      aPAD1[ POSPAD ] = &mCBARM.
      aPAD2[ POSPAD ] = &wMCHA.
      aPAD3[ POSPAD ] = PAD3MONT()
   ENDIF

// Posiciona o Novo Elemento na Matriz
   IF cVIDE = 'S' .AND. OPRPAD = 1
      nSBAR++
      AAdd( aPAD1, NIL )
      AAdd( aPAD2, NIL )
      AAdd( aPAD3, NIL )
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
      AIns( aPAD3, POSW )
      aPAD1[ POSW ] = &mCBARM.
      aPAD2[ POSW ] = &wMCHA.
      aPAD3[ POSW ] = PAD3MONT()
      pPAD := POSW
   ENDIF

   REPORVARS( wARQ, mCHAVE )

   IF ValType( bPOSREP ) = "B"
      RETU Eval( bPOSREP )
   ENDIF

   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PADARR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PADARR( cARQ, eKEY, mCOMP1, mCOMP2, nIND )

   IF cVIDE = "S" .AND. wcPAD # 2
      IF ValType( nIND ) # "N"
         nIND := if( lPIND, NUMIND( cARQ ), nIEXI )
      ENDIF
      IF !USEREDE( cARQ, 1, nIND )
         RETU .F.
      ENDIF
      GRAF  := LastRec()
      xGRAF := 0
      xPOS  := 1
      MARCAR()
      dbGoTop()
      dbSeek( eKEY )
      WHILE &mCOMP1. == &mCOMP2. .AND. !Eof()
         AAdd( aPAD1, &mCBAR. )
         AAdd( aPAD2, &wCHA. )
         AAdd( aPAD3, PAD3MONT( .T. ) )
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
         IF !fPAD( 1, 0 )
            RETU .F.
         ENDIF
      ENDIF
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PAD3MONT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PAD3MONT( lTIP )

   LOCAL cVAR := 0

   IF ValType( lTIP ) # "L"
      lTIP := .F.
   ENDIF
   IF ValType( ePAD3 ) = "C"
      IF lTIP
         cVAR := StrTran( ePAD3, "m", "" )
         cVAR := &cVAR.
      ELSE
         cVAR := &ePAD3.
      ENDIF
   ENDIF
   RETU cVAR



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PAD3TOT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PAD3TOT

   LOCAL W

   IF ValType( ePAD3 ) = "C"
      mTOTAL := 0
      FOR W := 1 TO Len( aPAD3 )
         mTOTAL += aPAD3[ W ]
      NEXT W
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PADCGC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION PADCGC( cARQ, nIND, lULT )

   LOCAL lOPEN     := .F.
   PRIVATE v_pic   := "@S18"
   PRIVATE GETLIST

   MDS( "Pessoa (F)isica (J)uridica (C)EI_CNO (O)utras Numero: " )
   @ 24, 60 GET mPESSOA PICT "!"    VALID mPESSOA $ "FJCO "
   @ 24, 62 GET mCGC    PICT( v_pic ) WHEN {| oGet | CNPJCPFPICT( oGet, mPESSOA, 24, 52 ) } VALID CNPJCPFVAL( mCGC, mPESSOA )
   IF !READCUR()
      RETURN .F.
   ENDIF
   IF Type( "cVIDE" ) = "C"
      IF cVIDE = "T"
         lOPEN := .T.
      ENDIF
   ENDIF
   IF lOPEN
      dbSetOrder( nIND )
      IF dbSeek( mCGC )
         mNUMERO := NUMERO
         ALERTX( "CGC/CPF Ja cadastrado : " + STRVAL( mNUMERO ) )
         RETU .F.
      ENDIF
      dbSetOrder( 1 )
   ELSE
      IF PEGACAMPO( cARQ, "mCGC", "NUMERO", "mNUMERO", nIND )
         ALERTX( "CGC/CPF Ja cadastrado : " + STRVAL( mNUMERO ) )
         RETU .F.
      ENDIF
   ENDIF
   mNUMERO := ULTIMOREG( cARQ, "NUMERO", "mNUMERO" )
   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function padraolib()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC padraolib( cOPER, cTITULO, cARQ )

   IF Len( cARQ ) = 6
      IF Left( cARQ, 2 ) = "CD"   // Lancamento Contabil
         cARQ := "CD01"
      ENDIF
      IF Left( cARQ, 2 ) = "MY"
         cARQ := "MY01"
      ENDIF
      IF Left( cARQ, 2 ) = "MM"
         cARQ := "MM01"
      ENDIF
      IF Left( cARQ, 2 ) = "MK"
         cARQ := "MK01"
      ENDIF
      IF Left( cARQ, 2 ) = "K9"
         cARQ := "MK09"
      ENDIF
      IF Left( cARQ, 2 ) = "M9"
         cARQ := "MM09"
      ENDIF
      IF Left( cARQ, 2 ) = "YA"
         cARQ := "MY03A"
      ENDIF
      IF Left( cARQ, 2 ) = "Y3"
         cARQ := "MY03"
      ENDIF
   ENDIF
   RETU PEGACS( "O", cOPER + cARQ + ZUSER, .T., CARQ + " " + cTITULO )


// + EOF: mlib27.prg
// +
