// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_a71.prg
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
// +    Documentado em 28-Dez-2024 as 10:46 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :****************************************************************************
// :
// :      M_A71.PRG: Faturar Pedidos em Carteira ** Faturamento Conforme OS
// :      Linguagem: Clipper 5.x
// :        Sistema: ITAESBRA (Mana5)
// :      Copyright (C) 1997 by Disk Softwares S/C Ltda.
// :     Atualizado: 20/10/1997
// :
// :*****************************************************************************
// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
#include "BOX.CH"


MDI( " Ý Faturando Pedidos Em Carteira" )
cTRABALHO := "NFPEDIDO"
xPISEMP   := OBTER( "MANEMP", ZNUMERO, "PERPIS" )
xFINEMP   := OBTER( "MANEMP", ZNUMERO, "PERFIN" )


CRIARVARS( "MG01" )
CRIARVARS( "MN01" )
CRIARVARS( "MM01" )
CRIARVARS( "MM02" )
CRIARVARS( "MM04" )
CRIARVARS( "MA01" )
CRIARVARS( "MO01" )
CRIARVARS( "MO02" )

aMDETEL := TELAPEG( "MMDE01" )
aMDEGET := EDITPEG( "MMDE01" )

aMA711  := {}
aMA712  := {}
aMA7125 := {}   // Valor Total da Mercadoria
aMA7126 := {}   // Valor Total do IPI
aMA7127 := {}   // Valor Total da Nota Fiscal
aMA7128 := {}   // Valor Total do ICMS
aMA7129 := {}   // Valor Total da Base de Calculo do IPI
aMA7130 := {}   // Valor Total da Base de Calculo do ICM
aMA7131 := {}   // Peso Total das Mercadorias
aMA7132 := {}   // Quantidade

nREF := 2

MA7COR     := CORARR( "MA71" )
pMA711     := 1
xGRAF      := 0
xPOS       := 1
xFORNECEDO := 0
xTIPOSERV  := " "
xNUMERO    := 0
ZESTADO    := OBTER( "MANEMP", ZNUMERO, "ESTADO" )
mDIAFAT    := ZDATA
lTEMREM    := .F.

MDS( "Digite o Codigo do Cliente e Tipo Servico" )
@ 24, 50 GET xFORNECEDO PICT "9999999"
@ 24, 60 GET xTIPOSERV  VALID CHECKTAB( "TIPSERV", "xTIPOSERV", "TIPSER",, "LEFT(CODIGO1,1)" )
IF !READCUR()
RETU .F.
ENDIF


IF !IGUALVARS( "MA01", xFORNECEDO )
ALERTX( "N„o Encontrei o Cliente" )
RETU .F.
ENDIF
xCLIIPI  := mTEMIPI
xCLIICM  := mTEMICMS
mTIPOCLI := "C"
lSERVICO := .F.
IF xTIPOSERV = "3" .OR. xTIPOSERV = "4"
lSERVICO := .T.
ENDIF
cINICFO := IF( ZESTADO = mESTADO, "5", "6" )
IF xTIPOSERV = "1" .OR. xTIPOSERV = "2"
mCFONEW := cINICFO + '101'
ELSE
mCFONEW := cINICFO + '124'
ENDIF
IF mESTADO = "XX"
mCFONEW := "7101"
ENDIF
IF mESTADO = "AM" .AND. mCIDADE = "MANAUS"
mCFONEW := "6109"  // Zona franca Manuaus
ENDIF
mDESCFO := OBTER( "MD04", mCFONEW, "NOMENOTA", 2 )
IF lSERVICO
mCFONEWB := cINICFO + '902'
ENDIF

MDS( "Confirme CFO" )
@ 24, 30 GET mCFONEW   PICT "@R 9.999"                                                                                                          VALID CHECKCFO( mCFONEW, 2, mESTADO, zESTADO, 24, 00,,,, "mOPERACAO",, 2 )
@ 24, 40 GET mCFONEWB  PICT "@R 9.999"                                                                                                          VALID Empty( mCFONEWB ) .OR. CHECKCFO( mCFONEWB, 2, mESTADO, zESTADO, 24, 00,,,, "mOPERACAO",, 2 )
@ 24, 50 GET mOPERACAO WHEN !ALLTRUE( mOPERACAO := OBTER( "MD04", mCFONEW, "CFO", 2 ) + IF( Empty( mCFONEWB ), "    ", + "/" + OBTER( "MD04", mCFONEWB, "CFO", 2 ) ) )
@ 24, 60 GET mSUBOPER
IF !READCUR()
RETU .F.
ENDIF

yCFONEW  := mCFONEW
yCFONEWB := mCFONEWB


WHILE .T.
SetColor( MA7COR[ 2 ] )
MDS( "Digite o N£mero do Pedido" )
@ 24, 40 GET mPEDIDO VALID MA7101()
READCUR()
IF mPEDIDO = 0
EXIT
ELSE
IF mPEDIDO = 0
RETU .F.
ENDIF
ENDIF
ENDDO
IF Len( aMA711 ) = 0
ALERTX( "Sem Itens no Faturamento" )
RETU .F.
ENDIF
WHILE .T.
NOBREAK()
mTOTMER   := 0.00
mTOTIPI   := 0.00
mTOTNF    := 0.00
mTOTICM   := 0.00
mTOTBIPI  := 0.00
mTOTBICM  := 0.00
mTOTALPES := 0.00
mQUANTEMB := 0.00

FOR X := 1 TO Len( aMA7127 )
mTOTMER   += aMA7125[ X ]
mTOTIPI   += aMA7126[ X ]
mTOTNF    += aMA7127[ X ]
mTOTICM   += aMA7128[ X ]
mTOTBIPI  += aMA7129[ X ]
mTOTBICM  += aMA7130[ X ]
mTOTALPES += aMA7131[ X ]
mQUANTEMB += aMA7132[ X ]
NEXT X

PRIV nSBAR, aSBAR
nSBAR := Len( aMA711 )
aSBAR := ScrollBarNew( 03, 79, 23,, pMA711 )
ScrollBarDisplay( aSBAR )
ScrollBarUpdate( aSBAR, pMA711, nSBAR, .T. )
SetColor( MA7COR[ 1 ] )
hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
@ 03, 2 SAY "Pedido   Un       Qtde   Peso Un. C¢digo                  IPI    Pre‡o Unit."
@  4, 0 SAY '+' + Replicate( '-', 78 ) + 'Ý'
MDS( 'Busca: ' )
@ 24, 00 SAY 'Tot.Merc:'
@ 24, 09 SAY mTOTMER     PICT '@E 999,999,999.99'
@ 24, 24 SAY 'Ipi:'
@ 24, 28 SAY mTOTIPI     PICT '@E 9,999,999.99'
@ 24, 41 SAY 'Total:'
@ 24, 47 SAY mTOTNF      PICT '@E 999,999,999.99'
@ 24, 62 SAY 'Icm:'
@ 24, 66 SAY mTOTICM     PICT '@E 999,999,999.99'
ScrollBarUpdate( aSBAR, pMA711, nSBAR, .T. )
ScrollBarDisplay( aSBAR )
pMA712 := AChoice( 05, 01, 22, 78, aMA711,, "ACHRETB", pMA711 )
pMA711 := IF( pMA712 # 0, pMA712, pMA711 )
pMA712 := pMA711
DO CASE
CASE pESC
IF MDG( 'Encerrar Escolha' )
EXIT
ENDIF
LOOP
CASE pMUD
fMA711( 2, pMA711 )
CASE pINC
fMA711( 1, pMA711 )
CASE pEXC
fMA711( 3, pMA711 )
OTHERWISE
LOOP
ENDCASE
ENDDO

// Armazenado Vari veis Basicas
mTRANS     := "RODOVIARIO" + Space( 40 )
mEMBALAGEM := "GRANEL"
mESPECIE   := "NF   "
mSERIE     := "UN   "
mMODELO    := "01"
mAPURA     := "S"



xNUMERO := ULTIMOREG( "MM01", "NUMERO" )   // ULTIMA NOTA FATURADA
xNUMERO++


// xOPERACAO:=mOPERACAO               //Variavel de Referencia
mNUMMENS := 0
CRIAMAM4 := 1
CRIAMAG  := 1
aMAG1    := {}  // Matriz com os dizeres do Achoice
aMAG2    := {}  // Numero de Cadastramento
aMAM41   := {}  // Matriz com os dizeres do Achoice
aMAM42   := {}  // N£mero das Mensagens


TELA := 0
SIM  := ' '
WHILE .T.
TELA += IF( LastKey() = K_PGUP, - 1, 1 )
TELA := IF( LastKey() = K_ESC, 0, TELA )
TELA := IF( LastKey() = K_CTRL_W, 0, TELA )
DO CASE
CASE TELA = 1    // Pega a Mensagem
ARQWORK := "MM04"
M_AM4( 3, mNUMMENS, CRIAMAM4 )
CRIAMAM4 := 2
CASE TELA = 2
PADRAX( 3, mTRANSPORT, 0, { "MG01", "MG02" }, "N£mero  Nome" + spac( 38 ) + "Cognome" + spac( 6 ) + "DDD  Telefone", ;
            "' '+mNUMERO+' '+mNOME+' '+mCOGNOME+' '+mDDD+' '+mTELEFONE", "MAG001", "MAG001", ;
            {|| MAGEN2() },, {|| MAGREP() } )
mNUMERO := XNUMERO
CASE TELA = 3
MA71T01()
CASE TELA = 4
MA71T02()
CASE TELA = 5
MA71T03()
OTHERWISE
EXIT
ENDCASE
ENDDO

// IMPRIMIR A NOTA FISCAL
IF !MDG( "Deseja Gravar Nota Fiscal" )
RETU .F.
ENDIF


// TRANSFERIR DO PEDIDO PARA O CADASTRO DE NOTA FISCAL DE VENDAS
xPEDIDO := mPEDIDO
mPEDIDO := mPEDIDOCLI
mDATA   := mDIAFAT
IF lSERVICO
IF SIM = 'N'   // --> NF DE MAO DE OBRA NAO GRAVA O ICM
mICM     := 0
mTOTICM  := 0
mTOTBICM := 0
ENDIF
ENDIF
mPESO    := mPESOUNI
mHORAEMI := Left( Time(), 5 )
mTIPONF  := "S"
NOVOREG( "MM01", xNUMERO )


// Transferir Itens do Pedido a Fatura Para a Nota Fiscal de Venda


WHILE !USEREDE( "MO02", 1, 99 )   // Pedidos
ENDDO
WHILE !USEREDE( "MO02X", 1, 99 )  // Pedidos Especiais
ENDDO
WHILE !USEREDE( "MM02", 1, 99 )   //
ENDDO   // ABRINDO ITENS
WHILE !USEREDE( "MO01", 1, 99 )
ENDDO
WHILE !USEREDE( "MS01", 1, 2 )
ENDDO

FOR X := 1 TO Len( aMA7127 )
IF !Empty( aMA712[ X ] )
mCHAVE := aMA712[ X ]
nSUBCH := Val( SubStr( mCHAVE, 1, 5 ) )
// ALERTX(STR(nSUBCH))
IF nSUBCH < 9000
dbSelectAr( "MO02" )
ELSE
dbSelectAr( "MO02X" )
ENDIF
dbGoTop()
IF dbSeek( mCHAVE )
EQUVARS()
wQTDEFAT := mQTDEFAT
wQTDEENT := mQTDEENT + mQTDEFAT
IF lSERVICO
wTOTSDEV := mDEV
ENDIF
// Dados para Nota Fiscal
mQTDE      := mQTDEFAT
mOS        := mPEDIDO
mPRECO     := mVALOR
mPEDIDO    := mPEDIDOCLI
mPEDCLIITE := mPEDCLIITE
IF mQTDEFAT > 0
mDATA    := mDIAFAT
mPESO    := mPESOUNI
mPED     := mPEDIDO
mSEQ     := X
mESPECIE := "NF"
mSOMANF  := "S"
mTIPOENT := "P"
IF nSUBCH = 9000
mTIPOENT := "X"
ENDIF
NOVOOPA( "MM02", .F., .T. )
wOS        := OS  // Grava Numero Pedido Cliente
xPEDIDOCLI := ""
xPEDCLIITE := 0
IF nSUBCH < 9000
dbSelectAr( "MO01" )
dbGoTop()
IF dbSeek( wOS )
xPEDIDOCLI := PEDIDOCLI
xPEDCLIITE := PEDCLIITE
ENDIF
ENDIF
dbSelectAr( "MM02" )
netreclock()
IF !Empty( xPEDIDOCLI )
FIELD->PEDIDOCLI := xPEDIDOCLI
FIELD->PEDCLIITE := xPEDCLIITE
ENDIF
mPEDIDO := mPED
// Ajustando Pedido
IF nSUBCH < 9000
dbSelectAr( "MO02" )
netreclock()
FIELD->QTDEENT := QTDEENT + wQTDEFAT
FIELD->QTDESAL := QTDEPED - QTDEENT
FIELD->QTDEFAT := 0
// Destrava OS
FIELD->FATURA  := "N"
FIELD->QTDEPRE := 0
IF SIM = 'N'   // --> NF DE MAO DE OBRA NAO GRAVA O ICM
FIELD->ICM      := 0
FIELD->VALORICM := 0
FIELD->BASEICM  := 0
ENDIF
IF lSERVICO
FIELD->TOTSDEV := TOTSDEV + wTOTSDEV
ENDIF
dbUnlock()
ENDIF
dbSelectAr( "MS01" )
dbGoTop()
IF dbSeek( AllTrim( mCODIGO ) )
IF BAIXAFAT = "S"
dbSelectAr( "MM02" )
FIELD->FATBX := "S"
wNOTA        := NUMERO
wSEQ         := SEQ
wOS          := OS
EQUVARS()
mQTDE     := CONVUN( mQTDE, mUNID )
mTIPO1    := "S"  // Saida
mTIPO2    := "P"  // Produto
yCODIGO   := mCODIGO
mOLDQTDDE := 0
mNUMERO   := ( xNUMERO * 100 ) + SEQ
wREQUISI  := ( xNUMERO * 100 ) + SEQ
MAM2K05( "I" )
MAYG02( mQTDE, "OR01", "OR01BX" )
mNUMERO := xNUMERO
ENDIF
netreclock()
FIELD->ULTIMOFA := mDIAFAT
FIELD->ULTIMONF := xNUMERO
dbUnlock()
ENDIF
ENDIF
ENDIF
ENDIF
NEXT X
dbCloseAll()
IF USEMULT( { { "MM01", 1, 1 }, { "MM02", 1, 1 } } )
nCHECAR := 0
aVAL    := { 0, 0, 0, 0, 0, 0 }
aVAX    := { 0, 0, 0, 0, 0, 0 }
dbSelectAr( "MM02" )
dbGoTop()
dbSeek( Str( xNUMERO, 8 ) )
WHILE xNUMERO = NUMERO .AND. !Eof()
aVAL[ 1 ] += VALORMER
aVAL[ 2 ] += VALORIPI
aVAL[ 3 ] += VALORTOT
aVAL[ 4 ] += VALORICM
aVAL[ 5 ] += BASEICM
aVAL[ 6 ] += BASEIPI
dbSkip()
ENDDO
dbSelectAr( "MM01" )
dbGoTop()
IF dbSeek( xNUMERO )
aVAX := { TOTMER, TOTIPI, TOTNF, TOTICM, TOTBICM, TOTBIPI }
ENDIF
dbCloseAll()
FOR X := 1 TO 6
IF aVAL[ X ] > 0 .OR. aVAX[ X ] > 0
IF Round( aVAL[ X ], 2 ) <> Round( aVAX[ X ], 2 )
nCHECAR += 1
ENDIF
ENDIF
NEXT X
IF nCHECAR > 0
// ALERTX("Somas NÆo Conferem")
// M_A70(xNUMERO,.T.,{"MM01","MM02","MM06","MN01","MO02"})
// RETU .F.
ENDIF
dbCloseAll()
ENDIF


// Impress„o das Notas Fiscais
ARQWORK1 := "MM01"
ARQWORK2 := "MM02"
mDATA    := mDIAFAT
M_A7I( xNUMERO, .F., .T. )  // LAYOUT DA NOTA FISCAL DE VENDAS ITAESBRA


// Gravar Contas
xyDATA    := mDATA
xDATA     := mDIAFAT
xSITUACAO := mSITUACAO
mDATA     := mDIAFAT
mSITUACAO := 0
mPEDIDO   := xPEDIDO
aDATAS    := { mDAT01, mDAT02, mDAT03, mDAT04, mDAT05, mDAT06, mDAT07, mDAT08, mDAT09, mDAT10 }
aVALOR    := { mVAL01, mVAL02, mVAL03, mVAL04, mVAL05, mVAL06, mVAL07, mVAL08, mVAL09, mVAL10 }
mGERACOB  := "S"
mIMPDUP   := "N"
mBANCO    := mBCOCOB

FOR W := 1 TO 10
// mTIPFAT   :=CHR(64+W)                       //Tipo do Faturamento (A,B,C...)
mTIPFAT    := Space( 1 )   // Tipofat vazio (n„o colocar a letrinha)
mVENCIMENT := aDATAS[ W ]
mVALOR     := aVALOR[ W ]
// >>>       yDAT      :=aDATOLD[W]         // NAO EXISTE DATA ANTIGA NUM NOVO FATURAMENTO
yDAT := aDATAS[ W ]
IF mVALOR > 0  //
IF !VERSEHA( "MN01", DToS( mVENCIMENT ) + Str( xNUMERO, 8 ) + mTIPFAT )
// Cadastra novo lan‡amento
NOVOREG( "MN01", DToS( mVENCIMENT ) + Str( xNUMERO, 8 ) + mTIPFAT )
ELSE
// Altera lan‡amentos
REPORVARS( "MN01", DToS( mVENCIMENT ) + Str( xNUMERO, 8 ) + mTIPFAT )
ENDIF
ENDIF
NEXT

// Gravar Remessas
IF lTEMREM
MAMGRVREM( xNUMERO, mFORNECEDO, mTIPOCLI )
ENDIF
RETU

// ***************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fMA711()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC fMA711( OPRMA71, POSMA71 )  // &&INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

// ***************************
// Pegar a Chave de Busca
   mCHAVE := aMA712[ POSMA71 ]   // mPEDIDO=aMA712[POSMA71]
   cVIDE  := 'S'
   IF OPRMA71 # 1
      mCHAVE := aMA712[ POSMA71 ]  // mPEDIDO+mITEM=aMA712[POSMA71]
   ENDIF

// Opera‡„o de Exclus„o
   IF OPRMA71 = 3
      aMA711[ POSMA71 ] = ' ' + Str( mPEDIDO, 8, 2 ) + ' - Registro Excluido / Apagado / Deletado'
      aMA712[ POSMA71 ] = 0  // Zera o Numero do Pedido Para Ignorar
      aMA7125[ POSMA71 ] = 0
      aMA7126[ POSMA71 ] = 0
      aMA7127[ POSMA71 ] = 0
      aMA7128[ POSMA71 ] = 0
      aMA7129[ POSMA71 ] = 0
      aMA7130[ POSMA71 ] = 0
      aMA7131[ POSMA71 ] = 0
      aMA7132[ POSMA71 ] = 0
      RETU .T.
   ENDIF

// Opera‡„o de Inclus„o
   IF OPRMA71 = 1
      MDS( 'Digite N£mero do Pedido: ' )
      @ 24, 40 GET mPEDIDO // VALID MA7101() abaixo
      IF !READCUR()
         RETU .F.
      ENDIF
      IF mPEDIDO = 0
         RETU .F.
      ENDIF
      mITEM := 1   // Padrao um item pedido
      IF AScan( aMA712, Str( mPEDIDO, 8, 2 ) + Str( mITEM, 2 ) ) > 0
         MDE( "FATU02", "", "" )
         // ALERTX("Vocˆ j  selecionou este Pedido")
         RETU .F.
      ENDIF
      IF MA7101()
         mCHAVE := Str( mPEDIDO, 8, 2 ) + Str( mITEM, 2 )
      ELSE
         RETU .F.
      ENDIF
   ENDIF

// IGUALAR mVARS
   nSUBCH := Val( SubStr( mCHAVE, 1, 5 ) )   // necessario com mPEDIDO nao funciona
   IF nSUBCH < 9000  // na alteracao
      IF !IGUALVARS( "MO02", mCHAVE )
         RETU .F.
      ENDIF
   ENDIF
   IF nSUBCH = 9000
      mCHAVE := Str( 9000, 8, 2 ) + Str( 1, 2 )
      IF !IGUALVARS( "MO02X", mCHAVE )
         RETU .F.
      ENDIF
   ENDIF
   IF Empty( mQTDEFAT )
      mQTDEFAT := mQTDESAL
   ENDIF
   MA71K02()

// Opera‡„o de Escolha Itens
   IF OPRMA71 = 2
      // Desenha a Tela
      tMA71()
      // Get nas Menvars
      gMA71()
   ENDIF

// Posiciona o Novo Elemento na Matriz
   IF cVIDE = 'S' .AND. OPRMA71 = 1
      nSBAR++
      POSMA71 := Len( aMA711 )
      POSW    := Len( aMA711 )
      // Inclusao na funcao ma7101
   ENDIF

// Atualiza as Matrizes
   IF cVIDE = 'S'
      aMA711[ POSMA71 ] = " " + Str( mPEDIDO, 8, 2 ) + ' ' + mUNID + ' ' + Str( mQTDEFAT, 10, 3 ) + ' ' + Str( mPESOUNI, 9, 3 ) + ' ' + mCODIGO + ' ' + mCODIPI + " " + Str( mVALOR, 16, 4 )
      aMA712[ POSMA71 ] = Str( mPEDIDO, 8, 2 ) + Str( mITEM, 2 )
      aMA7125[ POSMA71 ] = mVALORMER
      aMA7126[ POSMA71 ] = mVALORIPI
      aMA7127[ POSMA71 ] = mVALORTOT
      aMA7128[ POSMA71 ] = mVALORICM
      aMA7129[ POSMA71 ] = mBASEIPI
      aMA7130[ POSMA71 ] = mBASEICM
      aMA7131[ POSMA71 ] = mPESOUNI * CONVUN( mQTDEFAT, mUNID )
      aMA7132[ POSMA71 ] = CONVUN( mQTDEFAT, mUNID )
   ENDIF

   IF OPRMA71 # 3
      IF mPEDIDO < 9000
         REPORVARS( "MO02", mCHAVE )
      ENDIF
      IF nSUBCH = 9000
         mCHAVE := Str( 9000, 8, 2 ) + Str( 1, 2 )
         REPORVARS( "MO02X", mCHAVE )
      ENDIF
   ENDIF

   RETU .T.


// Checa Validade do Pedido
// *************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA7101()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA7101

   LOCAL lRET := .F.

   IF mPEDIDO = 0
      RETU .T.
   ENDIF
   IF mPEDIDO < 9000
      IF !VERSEHA( "MO01", mPEDIDO, "PEDIDO", "'Pedido n„o Cadastrado'", .T. )
         RETU .F.
      ENDIF
      mFORNECEDO := OBTER( "MO01", mPEDIDO, "FORNECEDO" )
      IF xFORNECEDO # mFORNECEDO
         mPEDIDO := 0
         ALERTX( "Pedido de Cliente Diferente" )
         RETU .F.
      ENDIF
      IF !USEREDE( "MO02", 1, 99 )
         dbCloseAll()
         RETU .F.
      ENDIF
      dbGoTop()
      dbSeek( Str( mPEDIDO, 8, 2 ) )
      WHILE mPEDIDO = PEDIDO .AND. !Eof()
         IF xTIPOSERV # TIPOSERV
            dbCloseAll()
            ALERTX( "Tipo de Servi‡os Diferente" )
            RETU .F.
         ENDIF
         IF VALOR = 0 .AND. VALIND = 0
            dbCloseAll()
            ALERTX( "Pedido Sem Pre‡o" )
            RETU .F.
         ENDIF
         IF QTDESAL <= 0
            dbCloseAll()
            ALERTX( "Pedido Ja Zerado" )
            RETU .F.
         ENDIF
         IF FATURA = "S"
            dbCloseAll()
            ALERTX( "Pedido Bloqueado Faturamento Atual ou Anterior" )
            RETU .F.
         ENDIF
         IF FATURA = "P"
            ALERTX( "Pedido Marcado com Pendente" )
            IF !MDG( "Incluir Assim Mesmo" )
               dbCloseAll()
               EMAILINT( "FAT00001", "PMP:" + Str( mPEDIDO, 8, 2 ) )
               RETU .F.
            ENDIF
         ENDIF
         IF FATURA <> "L"
            ALERTX( "Pedido NÆo Liberado" )
            IF !MDG( "Incluir Assim Mesmo" )
               dbCloseAll()
               EMAILINT( "FAT00001", "PNL:" + Str( mPEDIDO, 8, 2 ) )
               RETU .F.
            ENDIF
         ENDIF
         mCODIPI  := CODIPI
         mPESOUNI := PESOUNI
         IF Empty( mCODIPI )
            IF Empty( mCODIPI )
               mCODIPI := OBTER( "MS02", mCODIGO + Str( mLISTA, 5 ) + DToS( mDATABASE ), "COIDE", 5 )
            ELSE
               mCODIPI := OBTER( "MS01", mCODIGO, "CODIPI", 2 )
            ENDIF
         ENDIF
         IF Empty( mPESOUNI )
            PEGACAMPO( "MS01", "CODIGO", { "PESOUNI" }, { "mPESOUNI" }, 2 )
         ENDIF
         mIPI      := IPI
         mCLASSIPI := CLASSIPI
         mTIPI     := " "
         mTEMPVAL  := 0
         CHECKCIPI( mCODIPI, "mIPI", "mCLASSIPI", "mICM", mCFONEW, 2 )
         dbSelectAr( "MO02" )
         netreclock()
         IF !Empty( INDICE )
            PREIND( INDICE, mDIAFAT, "mTEMPVAL" )
            FIELD->VALOR := Round( mTEMPVAL * VALIND, 4 )
         ENDIF
         FIELD->IPI      := mIPI
         FIELD->CLASSIPI := mCLASSIPI
         FIELD->TIPI     := mTIPI
         IF QTDEPRE > 0
            FIELD->QTDEFAT := QTDEPRE
         ELSE
            FIELD->QTDEFAT := QTDESAL
         ENDIF
         IF xCLIIPI = "O" .OR. xCLIIPI = "I"
            mIPI          := 0
            mDIPIPI       := xCLIIPI
            FIELD->DIPIPI := xCLIIPI
            FIELD->IPI    := 0
         ENDIF
         IF xCLIICM = "O" .OR. xCLIICM = "I"
            mICM          := 0
            mDIPICM       := xCLIICM
            FIELD->DIPICM := xCLIICM
            FIELD->ICM    := 0
         ENDIF
         IF xCLIICM = "O" .AND. xCLIIPI = "O"
            FIELD->CODICM := "050"
         ENDIF
         FIELD->VALORMER := Round( QTDEFAT * VALOR, 2 )
         FIELD->BASEIPI  := VALORMER
         FIELD->VALORIPI := Round( VALORMER * ( IPI / 100 ), 2 )
         FIELD->VALORTOT := VALORMER + VALORIPI
         FIELD->BASEICM  := IF( CONSUMO = "S", VALORTOT, VALORMER )
         FIELD->VALORICM := Round( BASEICM * ( ICM / 100 ), 2 )
         IF Empty( CODICM )
            FIELD->CODICM := "000"
         ENDIF
         field->PESOUNI := mPESOUNI
         field->FATURA  := "S"
         field->AVEMBQ  := 0
         field->AVEMBC  := ""
         dbUnlock()
         AAdd( aMA711, " " + Str( PEDIDO, 8, 2 ) + ' ' + UNID + ' ' + Str( QTDEFAT, 10, 3 ) + ' ' + Str( PESOUNI, 9, 3 ) + ' ' + CODIGO + ' ' + CODIPI + " " + Str( VALOR, 16, 4 ) )
         AAdd( aMA712, Str( PEDIDO, 8, 2 ) + Str( ITEM, 2 ) )
         AAdd( aMA7125, VALORMER )
         AAdd( aMA7126, VALORIPI )
         AAdd( aMA7127, VALORTOT )
         AAdd( aMA7128, VALORICM )
         AAdd( aMA7129, BASEIPI )
         AAdd( aMA7130, BASEICM )
         AAdd( aMA7131, PESOUNI * CONVUN( QTDEFAT, UNID ) )
         AAdd( aMA7132, CONVUN( QTDEFAT, UNID ) )
         xPOS++
         lRET := .T.
         dbSkip()
      ENDDO
      dbCloseAll()
   ENDIF
   IF mPEDIDO = 9000   // DescontoICM Yamaha
      mITEM   := 1
      mTMPICM := OBTER( "MD05", mESTADO, "ALIQUOTA" )
      IF !USEREDE( "MO02X", 1, 99 )
         dbCloseAll()
         RETU .F.
      ENDIF
      dbGoTop()
      IF dbSeek( Str( mPEDIDO, 8, 2 ) + Str( 1, 2 ) )
         netreclock()
         FIELD->NOME      := "Desconto " + Str( mTMPICM, 2 ) + "% DE ICMS"
         FIELD->VALOR     := Round( mTOTMER * -1 * mTMPICM / 100, 2 )
         FIELD->VALORMER  := VALOR
         FIELD->VALORTOT  := VALOR
         FIELD->DATA      := mDIAFAT
         FIELD->ENTREGA   := mDIAFAT
         FIELD->FORNECEDO := XFORNECEDO
         FIELD->COGNOME   := mCOGNOME
         FIELD->TIPOSERV  := XTIPOSERV
         FIELD->CONSUMO   := "N"
         FIELD->BASEIPI   := 0
         FIELD->VALORIPI  := 0
         FIELD->BASEICM   := 0
         FIELD->VALORICM  := 0
         dbUnlock()
         AAdd( aMA711, " " + Str( PEDIDO, 8, 2 ) + ' ' + UNID + ' ' + Str( QTDEFAT, 10, 3 ) + ' ' + Str( PESOUNI, 9, 3 ) + ' ' + CODIGO + ' ' + CODIPI + " " + Str( VALOR, 16, 4 ) )
         AAdd( aMA712, Str( PEDIDO, 8, 2 ) + Str( ITEM, 2 ) )
         AAdd( aMA7125, VALORMER )
         AAdd( aMA7126, VALORIPI )
         AAdd( aMA7127, VALORTOT )
         AAdd( aMA7128, VALORICM )
         AAdd( aMA7129, BASEIPI )
         AAdd( aMA7130, BASEICM )
         AAdd( aMA7131, PESOUNI * CONVUN( QTDEFAT, UNID ) )
         AAdd( aMA7132, CONVUN( QTDEFAT, UNID ) )
         xPOS++
         lRET := .T.
      ENDIF
      dbCloseArea()
   ENDIF
   RETU lRET


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA71T01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA71T01

// lIbera as Variaveis
   hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
   mVIATRANS := PadR( mTRANS, 60 )
   mDESCFO   := PadR( mDESCFO, 60 )

   mTOTALBRU := mTOTALPES
   SET KEY K_F11 TO TECLAF11
   @ 24, 00
   @ 03, 25      SAY 'DADOS RELATIVOS A NOTA FISCAL'
   @ 04, 03      SAY 'N£mero Nota Fiscal: '             GET xNUMERO   PICT '99999999'                                                          VALID !VERSEHA( "MM01", xNUMERO )
   @ 05, 03      SAY 'Data da Emiss„o   : '             GET mDIAFAT
   @ 06, 03      SAY 'Natureza Opera‡„o : '
   @ 06, Col() + 1 GET mCFONEW
   @ 06, Col() + 1 GET mCFONEWB
   @ 06, Col() + 1 GET mOPERACAO
   @ 06, Col() + 1 GET mSUBOPER
   @ 06, Col() + 1 GET mDESCFO                            PICT '@S40'
   @ 07, 03      SAY 'Via de Transporte : '             GET mVIATRANS PICT '@S40'
   @ 07, 58      SAY 'Frete Por Conta:'                 GET mTIPOFR   VALID mTIPOFR $ "12 "
   @ 08, 03      SAY 'Taxa de Juros ao Dia Por Atraso ' GET mTAXA
   @ 08, 43      SAY 'Condi‡„o de Pagamento '           GET mCONDPAG  VALID CHECKEXI( "MJ01", "mCONDPAG", "Numero+' '+Nome", "NUMERO", "CONDP", .F. )
   READCUR()
   mNUMERO := xNUMERO
   SET KEY K_F11 TO
   IF mCFONEW = "7101" .AND. Empty( mOBS3 )
      mOBS3 := PadR( "Fatura Comercial no.    /" + StrZero( Year( Date() ), 4 ), 70 )
   ENDIF
   IF mCFONEW = "6109" .AND. mFORNECEDO = 195
      mOBS1 := PadR( "Portaria SUFRAMA No.162/05", 70 )
      mOBS2 := PadR( "Valor PIS    1.65% R$ ", 70 )
      mOBS3 := PadR( "Valor COFINS 7,60% R$ ", 70 )
   ENDIF
   @ 09, 03 SAY 'Tipo da Embalagem : '
   @ 10, 03 SAY 'Marca -> '                                 GET mMARCAEMB
   @ 10, 43 SAY 'N£mero-> '                                 GET mNUMEROEMB
   @ 11, 03 SAY 'Qtde --> '                                 GET mQUANTEMB
   @ 11, 43 SAY 'Esp‚cie: '                                 GET mEMBALAGEM
   @ 12, 03 SAY 'Peso Liq:'                                 GET mTOTALPES  PICT '99,999.99'
   @ 12, 43 SAY 'Peso Bru:'                                 GET mTOTALBRU  PICT '99,999.99'
   @ 13, 03 SAY 'Obs :'
   @ 13, 20 GET mOBS1                                       PICT "@S40"
   @ 14, 20 GET mOBS2                                       PICT "@S40"
   @ 15, 20 GET mOBS3                                       PICT "@S40"
   @ 16, 03 SAY 'Observa‡”es para o Corpo da Nota Fiscal: '
   @ 17, 03 GET mLIN01
   @ 18, 03 GET mLIN02
   @ 19, 03 GET mLIN03
   @ 20, 03 GET mLIN04
   @ 21, 03 GET mLIN05
   @ 22, 03 GET mLIN06
   READCUR()

   IF lSERVICO
      IF SubStr( mOPERACAO, 1, 1 ) = "5"
         @ 24, 00
         @ 24, 00 SAY 'Calculo ICM sobre esta M„o de Obra - (S/N) ' GET SIM
         READCUR()
         @ 24, 00
         IF SIM = 'N'
            mICM      := 0
            mVALORICM := 0
            mBASEICM  := 0
            mTOTICM   := 0
            mTOTBICM  := 0
         ENDIF
      ENDIF
   ENDIF

// Fixa as Variaveis
   mVIATRANS := Trim( mTRANS )
   mDESCFO   := Trim( mDESCFO )

   RETU .T.


// *****************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA71T02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA71T02

// Calculando Vencimentos
   SET CENTURY ON
   MPAGAR( mCONDPAG, mTOTNF, mDIAFAT, .T. )
   SET CENTURY OFF
// Checando Parcelas
   IF OBTER( "MA01", xFORNECEDO, "TEMPISFIN" ) = "S"
      mVALPIS := Round( mTOTNF * XPISEMP / 100, 2 )
      mVALFIN := Round( mTOTNF * XFINEMP / 100, 2 )
   ENDIF
   CHECKPAR( .T., "2", "xNUMERO" )
   RETU .T.

// *******************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA71T03()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA71T03

   hb_DispBox( 3, 0, 23, 79, B_DOUBLE )
   @  4, 2  SAY "Nf.N£mero :" + SPAC( 10 ) + "de" + SPAC( 10 ) + "…" + SPAC( 8 ) + "-"
   @  5, 0  SAY 'Ç' + Replicate( '-', 78 ) + '¶'
   @  7, 2  SAY "Dados de Entrega:"
   @  8, 2  SAY "Endere‡o" + SPAC( 37 ) + "Bairro"
   @  9, 44 SAY "-"
   @ 10, 2  SAY "Cep:" + SPAC( 11 ) + "Cidade:" + SPAC( 32 ) + "UF:"
   @ 12, 0  SAY 'Ç' + Replicate( '-', 78 ) + '¶'
   @ 14, 2  SAY "Dados da Transportadora/Transporte" + SPAC( 16 ) + "Placa/Veiculo"
   @ 15, 8  SAY "-"
   @ 16, 2  SAY "Endere‡o:" + SPAC( 36 ) + "Bairro:"
   @ 17, 44 SAY "-"
   @ 18, 2  SAY "Cep:" + SPAC( 11 ) + "Cidade:" + SPAC( 32 ) + "UF:"
   @  4, 14 SAY xNUMERO
   @  4, 26 SAY mDIAFAT
   @  4, 37 SAY mFORNECEDO
   @  4, 46 SAY mCOGNOME
// Get nas Menvars
   @  9, 2  GET mENDERECO3
   @  9, 47 GET mBAIRRO3
   @ 10, 6  GET mCEP3      PICTURE "99999-999"
   @ 10, 25 GET mCIDADE3
   @ 10, 60 GET mESTADO3   VALID VERSEHA( "MD05", mESTADO3 ) .AND. CHKUFCEP( mCEP3, mESTADO3 )
   @ 15, 2  GET mTRANSP
   @ 15, 11 GET mNOMETRANS
   @ 15, 54 GET mCHAPA     VALID                                                                 validaPlaca( mCHAPA )
   @ 17, 2  GET mENDETRANS
   @ 17, 47 GET mBAIRTRANS
   @ 18, 7  GET mCEPTRANS
   @ 18, 25 GET mCIDATRANS
   @ 18, 60 GET mESTATRANS VALID VERSEHA( "MD05", mESTATRANS ) .AND. CHKUFCEP( mCEPTRANS, mESTATRANS )
   READCUR()
   RETU .T.

// ******************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tMA71()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC tMA71  // POSICAO DE TELA SAY

   SetColor( MA7COR[ 4 ] )
   hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
   @  3, 2 SAY "Pedido   Un       Qtde   Peso Un. Codigo                      Preco "
   @  5, 2 SAY "Qtde Saldo"
   @  7, 2 SAY 'Nome -> '
   @  8, 2 SAY 'Rastr ->'
   @  9, 2 SAY 'Tipo Servico'
   @ 10, 2 SAY 'Embalagem Complementar'
   @ 12, 0 SAY "ÝICM IORTB:    IPI IORTB:" + spac( 10 ) + "Ý" + spac( 43 ) + "Ý"
   @ 14, 1 SAY "Total Mercad:" + spac( 21 ) + "Ý"
   @ 15, 1 SAY "IPI:" + spac( 8 ) + "%" + spac( 21 ) + "Ý"
   @ 16, 1 SAY spac( 34 ) + "Ý"
   @ 17, 1 SAY "Total Nota F:" + spac( 21 ) + "Ý"
   @ 18, 1 SAY "Base do ICMS:" + spac( 21 ) + "Ý"
   @ 19, 1 SAY "ICM" + spac( 9 ) + "%" + spac( 21 ) + "Ý"
   @ 20, 1 SAY spac( 34 ) + "Ý"
   @ 21, 1 SAY "Base do IPI :" + spac( 21 ) + "Ý"
   @ 22, 1 SAY spac( 34 ) + "Ý"
   RETU .T.

// ******************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMA71()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gMA71  // POSICAO DE TELA GET

   xICM      := mICM
   xVALORMER := mVALORMER
   xBASEICM  := mBASEICM
   xBASEIPI  := mBASEIPI
   xIPI      := mIPI
   MA71K02()
   SetColor( MA7COR[ 2 ] )
   @ 04, 02 SAY mPEDIDO   PICT '99999.99'
   @ 05, 14 SAY mQTDESAL  PICT '999999.999'
   @ 04, 35 SAY mCODIGO
   @ 04, 11 GET mUNID     VALID CHECKEXI( "MD07", "mUNID", "UNIDADE+' '+UNIDDES", "UNIDADE", "UNIDADE" )
   @ 04, 14 GET mQTDEFAT  PICT '999999.999'                                                                                           VALID MA71K02() .AND. mQTDEFAT <= mQTDESAL
   @ 04, 25 GET mPESOUNI  PICT '99999.999'                                                                                            VALID MA71K02()
   @ 04, 63 GET mVALOR    PICT '999,999,999.9999'                                                                                     VALID MA71K02() .AND. IF( mVALOR > 0 .OR. mPEDIDO = 9000, .T., !ALLTRUE( ALERTX( "Preco em Branco" ) ) )
   @ 07, 10 GET mNOME
   @  8, 08 GET mRASTRO   WHEN alltrue( mRASTRO := checkrastro( mRASTRO ) )                                                               PICT "@S15"
   @  8, 35 GET mRASTR2   WHEN alltrue( mRASTR2 := checkrastro( mRASTR2 ) )                                                               PICT "@S15"
   @  9, 15 GET mTIPOSERV VALID CHECKTAB( "TIPSERV", "mTIPOSERV", "TIPSER",, "LEFT(CODIGO1,1)" ) .AND. MMDEV()
   @ 10, 30 GET mAVEMBQ
   @ 10, 50 GET mAVEMBC
   @ 12, 12 GET mDIPICM   VALID mDIPICM $ 'IORTB '
   @ 12, 26 GET mDIPIPI   VALID mDIPIPI $ 'IORTB '
   @ 15, 5  GET mCODIPI   VALID MA71K02() .AND. ( Empty( mCODIPI ) .OR. ALLTRUE( CHECKCIPI( mCODIPI, "mIPI", "mCLASSIPI", "mICM", mCFONEW, 2 ) ) )
   @ 15, 8  GET mIPI      PICT "99.99"                                                                                                VALID MA71K02() // WHEN EMPTY(mCODIPI)
   @ 15, 15 GET mVALORIPI PICT "999,999,999,999.99"                                                                                   WHEN Empty( mCODIPI )                                                                              VALID MA71K02()
   @ 16, 5  GET mCLASSIPI WHEN Empty( mCODIPI )                                                                                         VALID CHECKIPI( mCLASSIPI )
   @ 18, 15 GET mBASEICM  PICT "999,999,999,999.99"                                                                                   VALID MA71K02() .AND. NFBICM()
   @ 19, 4  GET mCODICM   VALID CHECKTAB( "CODICM", "mCODICM", "CODICM",, "LEFT(CODIGO1,3)" )
   @ 19, 8  GET mICM      PICT "99.99"                                                                                                VALID MA71K02()
   @ 19, 15 GET mVALORICM PICT "999,999,999,999.99"
   READCUR()
   MA71K02()
   IF mAVEMBQ > 0
      lTEMREM := .T.
   ENDIF
   RETU .T.

// ***********************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MA71K02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MA71K02

   mVALORMER := Round( mQTDEFAT * mVALOR, 2 )
   mBASEIPI  := mVALORMER
   mVALORIPI := Round( mVALORMER * ( mIPI / 100 ), 2 )
   IF mDIPIPI = "I"
      mIPI      := 0
      mBASEIPI  := 0
      mVALORIPI := 0
   ENDIF
   mVALORTOT := mVALORMER + mVALORIPI
   IF mDIPICM # "R"
      IF mCONSUMO = "S"
         mBASEICM := mVALORTOT
      ELSE
         mBASEICM := mVALORMER
      ENDIF
   ENDIF
   mVALORICM := Round( mBASEICM * ( mICM / 100 ), 2 )
   IF mDIPICM = "I"
      mICM      := 0
      mBASEICM  := 0
      mVALORICM := 0
   ENDIF
   @ 14, 15 SAY mVALORMER PICT "@E 999,999,999,999.99"
   @ 15, 15 SAY mVALORIPI PICT "@E 999,999,999,999.99"
   @ 17, 15 SAY mVALORTOT PICT "@E 999,999,999,999.99"
   @ 18, 15 SAY mBASEICM  PICT "@E 999,999,999,999.99"
   @ 19, 15 SAY mVALORICM PICT "@E 999,999,999,999.99"
   @ 21, 15 SAY mBASEIPI  PICT "@E 999,999,999,999.99"
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PREIND()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PREIND( cINDICE, dDATA, mVARGRA, bCALCU )   // Tabela //Data //Variavel

   LOCAL nVALIND := 0, cDBF := Alias()

   IF !USEREDE( "MD02", 1, 4 )
      RETU .T.
   ENDIF
   dbGoTop()
   dbSeek( PadR( cINDICE, 12 ) )
   IF PadR( CODIGO, 12 ) = PadR( cINDICE, 12 )
      nVALIND := VALOR
   ENDIF
   dbCloseArea()
   IF !Empty( nVALIND )
      IF ValType( mVARGRA ) = "C"
         &mVARGRA. := nVALIND
      ENDIF
      IF ValType( bCALCU ) = "B"
         Eval( bCALCU, nVALIND )
      ENDIF
   ENDIF
   IF !Empty( cDBF )
      SELE &cDBF.
   ENDIF
   RETU .T.

// + EOF: m_a71.prg
// +
