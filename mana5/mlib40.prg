// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib40.prg
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
#include "INKEY.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PADRAX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION PADRAX

// Recebendo Parametro de Trabalho
   PARA wPAX, wpPAX, wcPAX, aWARQ, PAXCAB, PAXDIZ, bPAXTEL, bPAXGET, bPAXEN2, bDELSEC, ;
      bPOSREP, bPAXINS, PAXCOR, bPOSIGU, bPAXTEC, bANTREP, bPOSINS, bPOSEDI, eFILTRO

   IF ValType( wcPAX ) # "N"
      wcPAX := 0
   ENDIF

// Modo de Trabalho no Video
   MDI( " � ",,, aWARQ[ 1 ] )

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
   IF !CONFARQ( aWARQ[ 1 ], PAXCAB, PAXDIZ )
      RETU .F.
   ENDIF
   IF !CONFIND( aWARQ[ 1 ] )
      RETU .F.
   ENDIF

// Chaves de Trabalho
   PRIV wMFOR := aIND[ 1, 4 ]
   PRIV wMVAR := aIND[ 1, 1, 3 ]
   PRIV wMCHA := if( Empty( wMFOR ), wMVAR, wMFOR )
   PRIV wCHA  := StrTran( wMCHA, "m", "" )
   PRIV nROW  := 24

// Pegando Cores de Trabalho
   CORPAX := CORARR( if( ValType( PAXCOR ) = "C", PAXCOR, "PAX" ) )

// Verificando Tela
   PRIV aPAXTEL := {}
   IF ValType( bPAXTEL ) = "C"
      aPAXTEL := TELAPEG( bPAXTEL )
      bPAXTEL := {|| TELASAY( aPAXTEL ) }
   ENDIF

// Verificando a Edi�ao
   PRIV aPAXGET := {}
   IF ValType( bPAXGET ) = "C"
      aPAXGET := EDITPEG( bPAXGET )
      bPAXGET := {|| EDITSAY( aPAXGET ) }
   ENDIF

// Variaveis de Trabalho
   PRIV PCK    := .F.
   PRIV mCHAVE
   PRIV xCHAVE

   IF wPAX = 0
      FOR X := 1 TO Len( aWARQ )
         xmCBAR  := mCBAR
         xmCBARM := mCBARM
         CRIARVARS( aWARQ[ X ] )
         mCBAR  := xmCBAR
         mCBARM := xmCBARM
      NEXT X
   ENDIF

// CRIANDO MATRIZES
   IF wcPAX = 0
      PRIV aPAX1
      PRIV aPAX2
      aPAX1 := {}  // Matriz com os dizeres do Achoice
      aPAX2 := {}  // Numero de Cadastramento
   ENDIF

// Incializando a ajuda on Line
   PRIV HELPDBF := aWARQ[ 1 ]


   IF ValType( eFILTRO ) = "U"
      eFILTRO := .F.
   ENDIF
   IF ValType( eFILTRO ) = "L"
      IF eFILTRO
         eFILTRO := ''
         eFILTRO := RFILORD( aWARQ[ 1 ], .F. )
      ENDIF
   ENDIF



// Carregando Matriz
   IF cVIDE = "S" .AND. wcPAX # 2
      nIND := if( lPIND, NUMIND( aWARQ[ 1 ] ), nIEXI )
      IF !USEREDE( aWARQ[ 1 ], 1, nIND )
         RETU
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
         IF ValType( eFILTRO ) = "C" .AND. !Empty( eFILTRO )
            SET FILTER TO &eFILTRO
         ENDIF
         dbGoTop()
         WHILE !Eof()
            AAdd( aPAX1, &mCBAR. )
            AAdd( aPAX2, &wCHA. )
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
            IF !fPAX( 1, 0 )
               RETU .F.
            ENDIF
         ENDIF
      ENDIF
   ENDIF

// Posi��o Inicial do Ponteiro
   IF PCount() = 1
      pPAX := 1
   ELSE
      pPAX := AScan( aPAX2, wpPAX )
      pPAX := if( pPAX = 0, 1, pPAX )
   ENDIF

// Processando o M�todo Escolhido
   IF cVIDE = 'S'
      NOBREAK()
      PRIV nSBAR
      PRIV aSBAR
      nSBAR := Len( aPAX1 )
      aSBAR := ScrollBarNew( 04, 79, 24 - 1, SubStr( CORPAX[ 1 ], RAt( ",", CORPAX[ 1 ] ) + 1 ), pPAX )
      ScrollBarDisplay( aSBAR )
      ScrollBarUpdate( aSBAR, pPAX, nSBAR, .T. )
      WHILE .T.
         CABVID( CORPAX[ 1 ], pPAX )
         nKEY := 0
         KEYBOARD Chr( 255 )
         bELE  := {| X | aPAX1[ X ] }
         cCOR  := CORPAX[ 1 ]
         pPAX2 := AChoice( 05, 01, 24 - 2, 78, aPAX1,, "ACHMOU", pPAX )
         pPAX  := if( pPAX2 # 0, pPAX2, pPAX )
         pPAX2 := pPAX
         nROW  := Row()
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
            fPAX( 1, pPAX )
         CASE LastKey() = K_ENTER .AND. wPAX # 3
            MDS( 'Alterando ' )
            fPAX( 2, pPAX )
         CASE LastKey() = K_ENTER .AND. wPAX = 3
            MDS( 'Escolhendo' )
            fPAX( 6, pPAX )
            RETU
         CASE LastKey() = K_DEL
            MDS( 'Excluindo ' )
            fPAX( 3, pPAX )
         CASE LastKey() = K_CTRL_ENTER
            nIBUS   := if( lPBUS, NUMIND( aWARQ[ 1 ] ), nIBUS )
            mCHABUS := PEGBUS( aWARQ[ 1 ], nIBUS )
            IF nIBUS # 1
               nREG := REGBUS( aWARQ[ 1 ], nIBUS, mCHABUS )
            ELSE
               pPAD := AScan( aPAX2, mCHAVE )
               IF pPAD = 0 .AND. ValType( mCHABUS ) = "N"  // Simular jcassiano Seek
                  nREG := REGBUS( aWARQ[ 1 ], nIBUS, mCHABUS )
               ENDIF
            ENDIF
            pPAX := AScan( aPAX2, mCHAVE )
            IF pPAX = 0
               ALERTX( 'Nao localizei o Registro Correspondente ....' )
               pPAX := pPAX2
               LOOP
            ENDIF
         CASE ValType( BPAXTEC ) = "B"
            Eval( bPAXTEC, nKEY, pPAX )
         OTHERWISE
            LOOP
         ENDCASE
      ENDDO
   ENDIF
   IF cVIDE = 'N'
      METNVI( aWARQ[ 1 ], {|| fPAX( 1, 0 ) }, {|| fPAX( 3, 0 ) }, {|| fPAX( 2, 0 ) }, ;
         {|| fPAX( 6, 0 ) }, {|| fPAX( 2, - 1 ) }, CORPAX[ 1 ], wPAX )
   ENDIF
   IF cVIDE = 'P'
      METPAG( aWARQ[ 1 ], CORPAX, wMCHA, wPAX, ;
         bPAXTEL, {|| fPAX( 1, 0 ) }, {|| fPAX( 3, 0 ) }, {|| fPAX( 2, 0 ) }, ;
         {|| fPAX( 6, 0 ) } )
   ENDIF
   IF cVIDE = 'T'
      IF ValType( bPOSINS ) = "B"
         aREP := bPOSINS
      ELSE
         aREP := {}
         FOR X := 1 TO 3
            IF !Empty( aIND[ 1, X, 3 ] )
               cVARGET := aIND[ 1, X, 3 ]
               AAdd( aREP, { StrTran( cVARGET, "m", "" ), cVARGET } )
            ENDIF
         NEXT X
      ENDIF
      METBRO( aWARQ[ 1 ], aREP, CORPAX, {|| &mCBAR. }, bPAXTEL, bPAXGET,,, wPAX,,,,, bPAXINS, bPOSREP, bPOSIGU, bDELSEC, eFILTRO )
   ENDIF

   IF cVIDE = 'I'
      METINT( aWARQ[ 1 ],, {|| fPAX( 2, - 1 ) } )
   ENDIF

   IF wPAX = 0
      RELEASE ALL LIKE m *
   ENDIF

// EFETUA O PACK SE NECESSARIO
   IF PCK .AND. lFIXA
      FOR X := 1 TO Len( aWARQ )
         FIXAR( aWARQ[ X ] )
      NEXT X
   ENDIF

   RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fPAX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC fPAX

// *********
   PARA OPRPAX, POSPAX
// Fixa Inclus�o Como Falsa
   INCLUI := .F.

// Pegar a Chave de Busca
   IF OPRPAX # 1
      IF cVIDE = 'S'
         mCHAVE := aPAX2[ POSPAX ]
      ENDIF
      IF cVIDE = 'N' .AND. POSPAX # -1
         PEGBUS( aWARQ[ 1 ], 1 )
      ENDIF
   ENDIF

   IF OPRPAX = 6 .AND. ValType( bPAXEN2 ) = "B"
      Eval( bPAXEN2 )
      RETU .T.
   ENDIF

// Opera��o de Inclus�o
   IF OPRPAX = 1
      IF !padraolib( "I", "Inclusao nao Liberado", aWARQ[ 1 ] )
         RETU .F.
      ENDIF
      CRIARVARS( aWARQ[ 1 ] )
      IF ValType( bPAXINS ) = "B"
         lTMPRETU := Eval( bPAXINS )
         IF ValType( lTMPRETU ) = "L"
            IF !lTMPRETU
               RETURN .F.
            ENDIF
         ENDIF
      ENDIF
      AltD()
      PEGBUS()
      IF ValType( bPOSINS ) = "B"
         Eval( bPOSINS )
      ENDIF
      IF !NOVOREG( aWARQ[ 1 ], mCHAVE )
         RETU .F.
      ENDIF
      INCLUI := .T.
      nROW   := 24
   ENDIF

// IGUALAR mVARS
   IF !IGUALVARS( aWARQ[ 1 ], mCHAVE )
      RETU .F.
   ENDIF
   xCHAVE := mCHAVE

// Opera��o de Exclus�o
   IF OPRPAX = 3
      IF !padraolib( "E", "Exclusao n�o Liberado", aWARQ[ 1 ] )
         RETU .F.
      ENDIF
      IF MDG( "Apagar Registro" )
         IF APAGAREG( aWARQ[ 1 ], mCHAVE, .F. )
            IF ValType( bDELSEC ) = "B"
               eRETU := Eval( bDELSEC )
               IF ValType( eRETU ) = "L"
                  IF !eRETU
                     RETU .F.
                  ENDIF
               ENDIF
            ENDIF
            IF cVIDE = "S"
               aPAX1[ POSPAX ] = ' Registro Excluido / Apagado / Deletado '
            ENDIF
            PCK := .T.
         ENDIF
      ENDIF
      RETU .T.
   ENDIF

// Blocao Apos o Igualvars
   IF ValType( bPOSIGU ) = "B"
      Eval( bPOSIGU )
   ENDIF

   SET KEY K_F11 TO TECLAF11
// Metodo de Edi��o
   IF cTIPG = "1"
      // Desenha a Tela
      Eval( bPAXTEL )
      // Get nas Menvars
      Eval( bPAXGET )
   ELSE
      EDITGET( .T., CORPAX[ 5 ] )
   ENDIF
   SET KEY K_F11

   IF ValType( bPOSEDI ) = "B"
      Eval( bPOSEDI )
   ENDIF

// abaixo
// Atualiza as Matrizes se nao for inclusao
// if cVIDE = 'S' .and. OPRPAX # 1
// aPAX1[ POSPAX ] = &mCBARM.
// aPAX2[ POSPAX ] = &wMCHA.
// endif

// Posiciona o Novo Elemento na Matriz
   IF cVIDE = 'S' .AND. OPRPAX = 1
      nSBAR++
      AAdd( aPAX1, NIL )
      AAdd( aPAX2, NIL )
      POSPAX := Len( aPAX1 )
      POSW   := 1
      IF POSPAX > 1
         FOR X := 1 TO POSPAX - 1
            mDARE := aPAX2[ X ]
            IF mCHAVE <= mDARE   // IF mNUMERO<=mDARE
               EXIT
            ENDIF
         NEXT
         POSW := X
      ENDIF
      AIns( aPAX1, POSW )
      AIns( aPAX2, POSW )
      aPAX1[ POSW ] = &mCBARM.
      aPAX2[ POSW ] = &wMCHA.
      pPAX := POSW
   ENDIF

   IF ValType( bANTREP ) = "B"
      Eval( bANTREP )
   ENDIF

   REPORVARS( aWARQ[ 1 ], mCHAVE )

   IF ValType( bPOSREP ) = "B"
      Eval( bPOSREP )
   ENDIF

// Atualiza as Matrizes se nao for inclusao
   IF cVIDE = 'S' .AND. OPRPAX # 1
      aPAX1[ POSPAX ] = &mCBARM.
      aPAX2[ POSPAX ] = &wMCHA.
   ENDIF


   RETU .T.


// + EOF: mlib40.prg
// +
