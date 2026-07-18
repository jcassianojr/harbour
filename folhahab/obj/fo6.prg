// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo6.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :        FO6.PRG: Cadastro de Vencimentos e Descontos
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/07/94     15:15
// :
// :*****************************************************************************



// Teclas Operacionais
// #INCLUDE "TECLAS.CH"
#include "INKEY.CH"
// //#INCLUDE "COMANDO.CH"
#include "BOX.CH"



PRIV HELPDBF
HELPDBF := "CONTAS"


aT01 := TELAPEG( "FO6T01" )
aG01 := EDITPEG( "FO6T01" )


CABEX( "Cadastro de Vencimentos e Descontos" )
VIDEO := "S"
MDS( 'Deseja Ver os Registros No V¡deo (S/N) [S=Ver | N=Nao Ver]=> ' )
@ 24, 78 GET VIDEO PICT "!" VALID VIDEO $ "SN"
READCUR()

GRAPP := 1
PCK   := .F.
GRUPO := .F.
CRIARVARS( "CONTAS" )
MAT1 := {}  // Matriz Achoice
MAT2 := {}  // Matriz Numero
NAT1 := {}  // Matriz Para Grupo Achoice
NAT2 := {}  // Matriz Para Grupo Numero

// Carregando Matriz
IF VIDEO = "S"
IF !netuse( "CONTAS" )
RETU
ENDIF
GRAPT := LastRec()
GRAPT( 'Carregando Aguarde Plano de Contas' )
WHILE !Eof()
AAdd( MAT1, ' ' + Str( CODIGO ) + ' ' + DESCR )
AAdd( MAT2, CODIGO )
GRAPS()
dbSkip()
ENDDO
dbCloseAll()

IF GRAPP = 1
IF !MDG( 'Nenhum Lancamento Neste Arquivo Deseja Incluir' )
RETU
ENDIF
FO61( 1, 0 )
ENDIF
ENDIF

IF VIDEO = 'S'
NOBREAK()
ACHEI := 1
GRAF  := Len( MAT1 )
aSBAR := ScrollBarNew( 06, 79, 22,, 1 )
WHILE .T.
FO6T()
ScrollBarDisplay( aSBAR )
SCROLLBARUPDATE( aSBAR, ACHEI, Graf, .T. )
ACHEI2 := AChoice( 07, 01, 21, 78, MAT1,, "ACHRET", ACHEI )
ACHEI  := IF( ACHEI2 # 0, ACHEI2, ACHEI )
ACHEI2 := ACHEI
MD()
DO CASE
CASE LastKey() = K_ESC
MDS( 'Retornando' )
EXIT
CASE LastKey() = K_ALT_F10
MDS( 'Imprimindo' )
FO6L()
CASE LastKey() = K_INS
MDS( 'Incluindo ' )
FO61( 1, ACHEI )
CASE LastKey() = K_ENTER
MDS( 'Alterando ' )
FO61( 2, ACHEI )
CASE LastKey() = K_DEL
MDS( 'Excluindo ' )
FO61( 3, ACHEI )
CASE LastKey() = K_ALT_F1
MDS( 'Alterando ' )
FO61( 4, ACHEI )
CASE LastKey() = K_ALT_F2
MDS( 'Alterando ' )
FO61( 5, ACHEI )
CASE LastKey() = K_ALT_F3
MDS( 'Alterando ' )
FO61( 6, ACHEI )
CASE LastKey() = K_ALT_F4
MDS( 'Alterando ' )
FO61( 7, ACHEI )
CASE LastKey() = K_ALT_F5
MDS( 'Alterando ' )
FO61( 8, ACHEI )
CASE LastKey() = K_ALT_F9
GRUPO := .T.
MDS( 'Grupo     ' )
FO6GR()
NAT1  := {}  // Limpa Matriz Para Grupo Achoice
NAT2  := {}  // Limpa Matriz Para Grupo Numero
GRUPO := .F.
GRAF  := Len( MAT1 )
aSBAR := ScrollBarNew( 06, 79, 22,, 1 )
CASE pBUS
MDS( 'Digite o Codigo da Conta : ' )
@ 24, 40 GET mCODIGO
READCUR()
MD()
ACHEI := AScan( MAT2, mCODIGO )
IF ACHEI = 0
MDT( 'Nao localizei o Registro Correspondente ....' )
ACHEI := ACHEI2
LOOP
ENDIF
OTHERWISE
LOOP
ENDCASE
ENDDO
ELSE
// * ENTRADA SEM VER O BROWSE DOS REGISTROS
WHILE .T.
CABEX( "Cadastro de Vencimentos e Descontos" )
@ 24, 01 PROMPT ' 1 - INCLUIR '
@ 24, 16 PROMPT ' 2 - ALTERAR '
@ 24, 31 PROMPT ' 3 - EXCLUIR '
@ 24, 46 PROMPT ' 4 - LISTAR  '
@ 24, 61 PROMPT ' 5 - EXIBIR  '
MENU TO OPT
DO CASE
CASE OPT = 1
FO61( 1, 0 )
CASE OPT = 2
FO61( 2, 0 )
CASE OPT = 3
FO61( 3, 0 )
CASE OPT = 4
FO6L()
CASE OPT = 5
GRUPO := .T.
VIDEO := "S"
MDS( 'Grupo     ' )
FO6GR()
NAT1  := {}  // Limpa Matriz Para Grupo Achoice
NAT2  := {}  // Limpa Matriz Para Grupo Numero
GRUPO := .F.
VIDEO := "N"
OTHERWISE
EXIT
ENDCASE
ENDDO
ENDIF

// LIBERA AS VARIAVEIS DE TRABALHO
LIMPAVARS( "CONTAS" )

// EFETUA O PACK SE NECESSARIO
netpack( "CONTAS", pck )

RETU

// !*****************************************************************************
// !
// !         Funcao: FO61()
// !
// !    Chamado por: FO6.PRG
// !               : FO6GR()             (funcao    em FO6.PRG)
// !
// !          Chama: APAGAREG()         (funcao    em FOLPROC.PRG)
// !               : VERSEHA()          (funcao    em FOLPROC.PRG)
// !               : IGUALVARS()        (funcao    em FOLPROC.PRG)
// !               : FO6T1()            (funcao    em FO6.PRG)
// !               : FO6T2()            (funcao    em FO6.PRG)
// !               : FO6T3()            (funcao    em FO6.PRG)
// !               : FO6T4()            (funcao    em FO6.PRG)
// !               : FO6T5()            (funcao    em FO6.PRG)
// !               : REPORVARS()        (funcao    em FOLPROC.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO61()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FO61( OPR, POS2 )   // INC=1//MUD=2//EXC=3 // POSICAO MATRIZ

   IF OPR # 1
      IF VIDEO = 'S'
         mCODIGO := IF( GRUPO, NAT2[ POS2 ], MAT2[ POS2 ] )
      ELSE
         MDS( 'Digite o Codigo Desejado ?' )
         @ 24, 30 GET mCODIGO
         READCUR()
      ENDIF
   ENDIF
   IF OPR = 3
      IF APAGAREG( "CONTAS", "CONTAS", mCODIGO )
         IF VIDEO = "S"
            MAT1[ POS2 ] = ' ' + Str( mCODIGO ) + ' - Registro Excluido / Apagado / Deletado'
         ENDIF
      ENDIF
      RETU .T.
   ENDIF
   IF OPR = 1
      MDS( 'Digito o novo Codigo a incluir: ' )
      @ 24, 40 GET mCODIGO
      READCUR()
      IF mCODIGO = 0
         MDT( "Codigo precisa ser diferente de zero" )
         RETU .T.
      ENDIF
      IF VERSEHA( "CONTAS",, mCODIGO, "'Registro j  Cadastrado Com Este Codigo'", "'Cadastrando'", .F. )
         RETU .T.
      ENDIF
      IF !NETUSE( "CONTAS" )
         RETU .T.
      ENDIF
      NETRECAPP()
      FIELD->CODIGO := mCODIGO
      dbCloseAll()
   ENDIF
// IGUALAR mVARS
   IF !IGUALVARS( "CONTAS", "CONTAS", mCODIGO, "Lendo Registro", "Nao Encontrei o dado" )
      RETU .F.
   ENDIF

// Guarda a tributacao da Conta
   xCODIGO    := mCODIGO
   xFATOR     := mFATOR
   xTIPO      := mTIPO
   xTRIBUTINP := mTRIBUTINPS
   xTRIBUTIRR := mTRIBUTIRR
   xTRIB_FGTS := mTRIB_FGTS
   xVALOR     := mVALOR

   IF OPR < 4
      TELA := 0
      WHILE .T.
         TELA += IF( LastKey() = K_PGUP, - 1, 1 )
         TELA := IF( LastKey() = K_ESC, 0, TELA )
         DO CASE
         CASE TELA = 1
            // aT01:=TELAPEG("FO6T01")
            // aG01:=EDITPEG("FO6T01")
            hb_DispBox( 4, 0, 22, 79, B_DOUBLE + " " )
            TELASAY( aT01 )
            EDITSAY( aG01 )
         CASE TELA = 2
            FO6T2()
         CASE TELA = 3
            FO6T3()
         CASE TELA = 4
            FO6T4()
         CASE TELA = 5
            FO6T5()
         OTHERWISE
            EXIT
         ENDCASE
      ENDDO
   ENDIF

   DO CASE
   CASE OPR = 4
      TELASAY( aT01 )
      EDITSAY( aG01 )
   CASE OPR = 5
      FO6T2()
   CASE OPR = 6
      FO6T3()
   CASE OPR = 7
      FO6T4()
   CASE OPR = 8
      FO6T5()
   ENDCASE

// Atualiza as Matrizes se nao for inclusao
   IF VIDEO = 'S' .AND. OPR # 1
      IF GRUPO
         NAT1[ POS2 ] = ' ' + Str( mCODIGO ) + ' ' + mDESCR
         NAT2[ POS2 ] = mCODIGO
      ELSE
         MAT1[ POS2 ] = ' ' + Str( mCODIGO ) + ' ' + mDESCR
         MAT2[ POS2 ] = mCODIGO
      ENDIF
   ENDIF

// Posiciona o Novo Elemento na Matriz
   IF VIDEO = 'S' .AND. OPR = 1
      AAdd( MAT1, NIL )
      AAdd( MAT2, NIL )
      POS2 := Len( MAT1 )
      POSW := 1
      IF POS2 > 1
         FOR X := 1 TO POS2 - 1
            mDARE := MAT2[ X ]
            IF mCODIGO <= mDARE
               EXIT
            ENDIF
         NEXT
         POSW := X
      ENDIF
      AIns( MAT1, POSW )
      AIns( MAT2, POSW )
      MAT1[ POSW ] = ' ' + Str( mCODIGO ) + ' ' + mDESCR
      MAT2[ POSW ] = mCODIGO
      ACHEI := POSW
   ENDIF

   REPORVARS( "CONTAS", "CONTAS", mCODIGO )

// Verifica tributacao
   IF xFATOR <> mFATOR .OR. xTIPO <> mTIPO .OR. ;
         xTRIBUTINP <> mTRIBUTINPS .OR. xTRIBUTIRR <> mTRIBUTIRR .OR. ;
         xTRIB_FGTS <> mTRIB_FGTS .OR. xVALOR <> mVALOR
      @7, 0 CLEAR
      @ 10, 20 SAY "VOCE ALTEROU UM DOS ITENS ABAIXO: "
      @ 11, 20 SAY "     INCIDENCIA DO I.R.R.F."
      @ 12, 20 SAY "     INCIDENCIA DO I.N.S.S."
      @ 13, 20 SAY "     INCIDENCIA DO F.G.T.S."
      @ 14, 20 SAY "     TIPO DA CONTA ........"
      @ 15, 20 SAY "     FATOR DA CONTA ......."
      @ 16, 20 SAY "     VALOR FIXO (MENSAL/HORA"
      @ 18, 17 SAY "Sendo assim o Sistema ira na sua entrada de"
      @ 19, 17 SAY "dados e consertar as entradas ja fornecidas"
      @ 20, 17 SAY "pois senao sua folha ira sair ERRADA !! ok "
      MDS( "A G U A R D E .......... A G U A R D E ...." )
      IF !NETUSE( FOL )  // AREDE(FOL,FOL,0)
         RETU
      ENDIF
      dbGoTop()
      WHILE !Eof()
         IF CONTA = mCODIGO
            netreclock()
            FIELD->FATOR      := mFATOR
            FIELD->TIPO       := mTIPO
            FIELD->TRIBUTINPS := mTRIBUTINPS
            FIELD->TRIBUTIRR  := mTRIBUTIRR
            FIELD->TRIB_FGTS  := mTRIB_FGTS
            FIELD->VALORBASE  := mVALOR
            dbUnlock()
         ENDIF
         dbSkip()
      ENDDO
      dbCloseAll()
   ENDIF
   RETU .T.


// !*****************************************************************************
// !
// !         Funcao: FO6T()   TELA DO ACHOICE
// !
// !    Chamado por: FO6.PRG
// !               : FO6GR()             (funcao    em FO6.PRG)
// !
// !          Chama: CLSROW()           (funcao    em ?)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO6T()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FO6T

   hb_DispBox( 4, 0, 22, 79, B_DOUBLE + " " )
   @  5, 2 SAY "Conta   Descricao"
   @  6, 0 SAY '|' + REPL( '-', 78 ) + '|'
   CLSROW( 23 )
   @ 23, 1 SAY "Ins=Inclui Del=Deleta Enter=Altera Ctrl+Enter=Busca ALT+F9=Grupo ALT+F10=Lista"
   @ 24, 1 SAY "ALT+=>F1=Basica F2=Ferias/Rescisao F3=RAIS/DIRF/13o F4=Outras F5=Contabil"
   RETU .T.



// !*****************************************************************************
// !
// !         Funcao: FO6T2()
// !
// !    Chamado por: FO61()             (funcao    em FO6.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO6T2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FO6T2

// Desenha a Tela
   @ 24, 1 SAY "ESC-RETORNA PGUP-TELA ANTERIOR PGDN-CONTINA"
   hb_DispBox( 4, 0, 23, 79, B_DOUBLE + " " )
   @  5, 2  SAY "Configuracao Rescisao F‚rias ->      -"
   @  6, 0  SAY '+' + REPL( '-', 29 ) + "-" + REPL( '-', 15 ) + "-" + REPL( '-', 15 ) + "-" + REPL( '-', 16 ) + '|'
   @  7, 2  SAY "Operacao" + SPAC( 20 ) + "|   Rescisao    |    F‚rias     |  Comp.F‚rias"
   @  8, 0  SAY '+' + REPL( '-', 29 ) + "+" + REPL( '-', 15 ) + "+" + REPL( '-', 15 ) + "+" + REPL( '-', 16 ) + '|'
   @  9, 30 SAY "|" + SPAC( 15 ) + "|" + SPAC( 15 ) + "|"
   @ 10, 2  SAY "Acumular Vari vel/Nivel     |" + SPAC( 8 ) + "-" + SPAC( 6 ) + "|" + SPAC( 8 ) + "-" + SPAC( 6 ) + "|"
   @ 11, 30 SAY "|" + SPAC( 15 ) + "|" + SPAC( 15 ) + "|"
   @ 12, 2  SAY "Imprimir no Recibo/Posicao  |" + SPAC( 15 ) + "|" + SPAC( 15 ) + "|"
   @ 13, 30 SAY "|" + SPAC( 15 ) + "|" + SPAC( 15 ) + "|"
   @ 14, 2  SAY "Transferir p/ Folha         |" + SPAC( 15 ) + "|" + SPAC( 15 ) + "|"
   @ 15, 30 SAY "|" + SPAC( 15 ) + "|" + SPAC( 15 ) + "|"
   @ 16, 0  SAY '+' + REPL( '-', 29 ) + "-" + REPL( '-', 15 ) + "-" + REPL( '-', 15 ) + "-" + REPL( '-', 16 ) + '|'
   @ 17, 2  SAY "Legenda:"
   @ 19, 2  SAY "0 - Efetua a Operacao  1- Nao Efetua a Operacao"
   @ 21, 2  SAY "Nivel de Acumulacao" + SPAC( 10 ) + "2 - 9"
   @  5, 34 SAY mCODIGO
   @  5, 41 SAY mDESCR
// Get nas Menvars
   @ 10, 36 GET mDEMISSAO
   @ 10, 42 GET mNIVEL_DEM
   @ 10, 52 GET mFERIAS
   @ 10, 58 GET mNIVEL_FERI
   @ 12, 36 GET mPRRES
   @ 12, 38 GET mPOSREC
   @ 12, 52 GET mPRFER
   @ 12, 70 GET mPRFCO
   @ 14, 36 GET mTRRES
   @ 14, 52 GET mTRFER
   @ 14, 70 GET mTRFCO
   READCUR()
   RETU .T.

// !*****************************************************************************
// !
// !         Funcao: FO6T3()
// !
// !    Chamado por: FO61()             (funcao    em FO6.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO6T3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FO6T3

// Desenha a Tela
   @ 24, 1 SAY "ESC-RETORNA PGUP-TELA ANTERIOR PGDN-CONTINA"
   hb_DispBox( 4, 0, 23, 79, B_DOUBLE + " " )
   @  5, 2  SAY "Configuracao Rais/DIRF/13§Salario ->"
   @  6, 0  SAY '+' + REPL( '-', 78 ) + '|'
   @  8, 2  SAY "Acumula RAIS =>    (0)Sim (1)Nao (2)Deduz (3)1¦Parc13§ (4)2¦Parc13§ (5)Aviso"
   @  9, 2  SAY "                   (6)FeriasInd (7)AcresDissidio (8)Gratificacoes (9)MultaFGTS"
   @ 10, 2  SAY "Acumula DIRF =>    (0)Sim (1)Nao     <= Posicao no Formul rio"
   @ 12, 0  SAY '+' + REPL( '-', 78 ) + '|'
   @ 13, 2  SAY "Configuracao 13o.Salario"
   @ 15, 25 SAY "(0-Sim 1-Nao)" + SPAC( 19 ) + "(0-Sim 1-Nao 2-Deduz)"
   @ 16, 2  SAY "Transfere 1a. Parcela" + SPAC( 20 ) + "Tributa IRRF"
   @ 17, 2  SAY "Transfere 2a. Parcela" + SPAC( 20 ) + "Tributa INSS"
   @ 18, 2  SAY "Transfere Complemento" + SPAC( 20 ) + "Tributa FGTS"
   @ 19, 2  SAY "Acumula  13o. Salario"
   @ 21, 2  SAY "Nivel de Acumulacao" + SPAC( 14 ) + "(2-9)"
   @  5, 39 SAY mCODIGO
   @  5, 44 SAY mDESCR
// Get nas Menvars
   @  8, 18 GET mRAIZ
   @ 10, 18 GET mIRENDIMEN
   @ 10, 35 GET mNRENDIMEN
   @ 16, 31 GET mTR13S1
   @ 16, 66 GET mIRRF13
   @ 17, 31 GET mTR13S2
   @ 17, 66 GET mINSS13
   @ 18, 31 GET mTR13SC
   @ 18, 66 GET mFGTS13
   @ 19, 31 GET mSAL_13
   @ 21, 31 GET mNIVEL_13
   READCUR()
   RETU .T.

// !*****************************************************************************
// !
// !         Funcao: FO6T4()
// !
// !    Chamado por: FO61()             (funcao    em FO6.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO6T4()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FO6T4

// Desenha a Tela
   @ 24, 1 SAY "ESC-RETORNA PGUP-TELA ANTERIOR PGDN-CONTINA"
   DispBox( 4, 0, 23, 79, "i-¸|¾-Ô| " )
   @  5, 2  SAY "Configuracao Outras     ->" + SPAC( 9 ) + "-"
   @  6, 0  SAY '+' + REPL( '-', 78 ) + '|'
   @  8, 2  SAY "Posicao Resumo Configurado :" + SPAC( 8 ) + "No. Lancamento Selecionado :"
   @ 10, 2  SAY "Posicao Resumo Depto II    :" + SPAC( 8 ) + "Acumula Produtividade :    (0-SIM 1-NŽO)"
   @ 11, 2  SAY "Selacao Ficha Financeira Empresa :"
   @ 12, 0  SAY '+' + REPL( '-', 78 ) + '|'
   @ 13, 2  SAY "FATORES DE ATUALIZA€ŽO:"
   @ 15, 2  SAY "JAN" + SPAC( 23 ) + "FEV" + SPAC( 24 ) + "MAR"
   @ 17, 2  SAY "ABR" + SPAC( 23 ) + "MAI" + SPAC( 24 ) + "JUN"
   @ 19, 2  SAY "JUL" + SPAC( 23 ) + "AGO" + SPAC( 24 ) + "SET"
   @ 21, 2  SAY "OUT" + SPAC( 23 ) + "NOV" + SPAC( 24 ) + "DEZ"
   @  5, 32 SAY mCODIGO
   @  5, 39 SAY mDESCR
// Get nas Menvars
   @  8, 31 GET mRES
   @  8, 67 GET mSELECAO
   @ 10, 31 GET mRESG
   @ 10, 62 GET mGRAT
   @ 11, 37 GET mSELFFE
   @ 15, 7  GET mFAT01
   @ 15, 33 GET mFAT02
   @ 15, 60 GET mFAT03
   @ 17, 7  GET mFAT04
   @ 17, 33 GET mFAT05
   @ 17, 60 GET mFAT06
   @ 19, 7  GET mFAT07
   @ 19, 33 GET mFAT08
   @ 19, 60 GET mFAT09
   @ 21, 7  GET mFAT10
   @ 21, 33 GET mFAT11
   @ 21, 60 GET mFAT12
   READCUR()
   RETU .T.

// !*****************************************************************************
// !
// !         Funcao: FO6T5()
// !
// !    Chamado por: FO61()             (funcao    em FO6.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO6T5()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FO6T5

// Desenha a Tela
   @ 24, 1 SAY "ESC-RETORNA PGUP-TELA ANTERIOR PGDN-CONTINA"
   hb_DispBox( 4, 0, 23, 79, B_DOUBLE + " " )
   @  5, 2  SAY "Configuracao Contabil   ->" + SPAC( 9 ) + "-"
   @  6, 0  SAY '+' + REPL( '-', 78 ) + '|'
   @  7, 2  SAY "Listar Resumos:"
   @  8, 30 SAY "Cr‚dito" + SPAC( 14 ) + "Debito"
   @ 10, 2  SAY "Codigo de Lancamento :"
   @ 12, 14 SAY "Reduzido :"
   @ 14, 2  SAY "Descricao" + SPAC( 12 ) + ":"
   @ 16, 0  SAY '+' + REPL( '-', 78 ) + '|'
   @ 18, 2  SAY "Historico   Codigo   :"
   @ 20, 2  SAY "Descricao:"
   @  5, 32 SAY mCODIGO
   @  5, 39 SAY mDESCR
// Get nas Menvars
   @  7, 18 GET mLISCON
   @ 10, 28 GET mCO_COD
   @ 10, 50 GET mCO_CODD
   @ 12, 28 GET mCO_CODR
   @ 12, 50 GET mCO_CODRD
   @ 14, 28 GET mCO_CODN
   @ 18, 26 GET mCO_HIS
   @ 21, 2  GET mCO_HISN
   READCUR()
   RETU .T.

// !*****************************************************************************
// !
// !         Funcao: FO6L()  LISTA CADASTRO
// !
// !    Chamado por: MENUCC             (processo  em FOLMENU.PRG)
// !               : FO6.PRG
// !               : FO6GR()             (funcao    em FO6.PRG)
// !
// !          Chama: MDL()              (funcao    em FOLPROC.PRG)
// !               : RFILORD()          (funcao    em FOLPROC.PRG)
// !
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO6L()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FO6L

   IMPHP()

   MDS( 'Listar Cadastro de Vencimentos e Descontos' )
   POS1 := SPAC( 40 )
   MDS( 'Digite Cabecario Complementar' )
   @ 24, 35 GET POS1
   IF !READCUR()
      RETU .F.
   ENDIF
   IF !CHECKIMP( 0 )
      RETU .F.
   ENDIF

   IF !NETUSE( "CONTAS" )
      dbCloseAll()
      RETU
   ENDIF
   FILTRO := ''
   INX    := ""
   FILORD( .T. )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   IF ValType( INX ) = "N"
      dbSetOrder( INX )
   ELSE
      ordDestroy( "temp" )
      ordCreate(, "temp", inx )
      ordSetFocus( "temp" )
   ENDIF
   SET FILTER TO &FILTRO

   IMPRESSORA()
   CTLIN := 80
   FL    := 0
   dbGoTop()
   WHILE !Eof()
      IF CTLIN > 60
         FL++
         @  1, 0   SAY IF( IM1 = 'A', IMpSTR( cIMPCOM ), IMPSTR( cIMPEXP ) )
         @  2, 20  SAY IMPCHR( cIMPTIT ) + MSG2
         @  3, 0   SAY IMPCHR( cIMPTIT ) + 'CADASTRO DE VENCIMENTOS E DESCONTOS'
         @  5, 0   SAY POS1
         @  5, 100 SAY Time()
         @  5, 110 SAY DXDIA
         @  5, 120 SAY 'FL. ' + StrZero( FL, 4 )
         @  6, 0   SAY REPL( '-', 132 )
         @  7, 0   SAY "Cod. Descricao" + SPAC( 27 ) + "Fator    Tipo     Valor" + SPAC( 6 ) + "S P C  G R"
         @  7, 81  SAY "Infor I I F G Demiss.  Ferias  Com  13o.Salario"
         @  8, 50  SAY "de" + SPAC( 7 ) + "Caso" + SPAC( 7 ) + "E R O  E A"
         @  8, 87  SAY "R N G . V N I T  V N I T I T  V N T T T I I F"
         @  9, 50  SAY "Conta    Fixa" + SPAC( 7 ) + "L O N  R I"
         @  9, 83  SAY "cod R S T I a i m r  a i m r m r  a i R R R R N G"
         @ 10, 70  SAY "E D F  C S"
         @ 10, 87  SAY "F S S N r v p a  r v p a p a  r v 1 2 C R S T"
         @ 11, 0   SAY REPL( '-', 132 )
         CTLIN := 12
      ENDIF
      @ CTLIN, 0  SAY CODIGO
      @ CTLIN, 5  SAY DESCR
      @ CTLIN, 41 SAY FATOR
      @ CTLIN, 50 SAY TIPO
      IF TIPO = 2 .OR. TIPO = 4
         @ CTLIN, 59 SAY VALOR
      ENDIF
      @ CTLIN, 70  SAY SELECAO
      @ CTLIN, 72  SAY GRAT
      @ CTLIN, 74  SAY RES
      @ CTLIN, 77  SAY RESG
      @ CTLIN, 79  SAY RAIZ
      @ CTLIN, 81  SAY IRENDIMEN
      @ CTLIN, 83  SAY NRENDIMEN
      @ CTLIN, 87  SAY TRIBUTIRR
      @ CTLIN, 89  SAY TRIBUTINPS
      @ CTLIN, 91  SAY TRIB_FGTS
      @ CTLIN, 93  SAY GUIA_IAPAS
      @ CTLIN, 95  SAY DEMISSAO
      @ CTLIN, 97  SAY NIVEL_DEM
      @ CTLIN, 99  SAY PRRES
      @ CTLIN, 101 SAY TRRES
      @ CTLIN, 104 SAY FERIAS
      @ CTLIN, 106 SAY NIVEL_FERI
      @ CTLIN, 108 SAY PRFER
      @ CTLIN, 110 SAY TRFER
      @ CTLIN, 112 SAY PRFCO
      @ CTLIN, 114 SAY TRFCO
      @ CTLIN, 117 SAY SAL_13
      @ CTLIN, 119 SAY NIVEL_13
      @ CTLIN, 121 SAY TR13S1
      @ CTLIN, 123 SAY TR13S2
      @ CTLIN, 125 SAY TR13SC
      @ CTLIN, 127 SAY IRRF13
      @ CTLIN, 129 SAY INSS13
      @ CTLIN, 131 SAY FGTS13
      CTLIN++
      dbSkip()
   ENDDO
   dbCloseAll()
   @ PRow() + 1, 0 SAY REPL( '-', 132 )
   IMPFOL()
   VIDEO()
   IMPEND()
   RETU .T.

// !*****************************************************************************
// !
// !         Funcao: FO6GR() Trabalhar com um grupo de Contas
// !
// !    Chamado por: FO6.PRG
// !
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO6GR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FO6GR

   CABEX( "Grupo Cadastro de Vencimentos e Descontos" )
   GRAPP  := 1
   mTEMP  := tmpfile( cRDDEXT )
   aRETU  := RFILORD( "CONTAS" )
   INX    := aRETU[ 1 ]
   FILTRO := aRETU[ 2 ]
   IF !NETUSE( "CONTAS" )
      RETU
   ENDIF
   GRAPT    := LastRec()
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", inx )
   ordSetFocus( "temp" )
   SET FILTER TO &FILTRO

   GRAPT( 'Carregando Grupo do Plano de Contas' )
   dbGoTop()
   WHILE !Eof()
      AAdd( NAT1, ' ' + Str( CODIGO ) + ' ' + DESCR )
      AAdd( NAT2, CODIGO )
      GRAPS()
      dbSkip()
   ENDDO
   dbCloseAll()
   IF GRAPP = 1
      MDT( 'Nenhum Lancamento para este grupo' )
      RETU .F.
   ENDIF
   NOBREAK()
   BCHEI := 1
   GRAF  := Len( NAT1 )
   aSBAR := ScrollBarNew( 06, 79, 22,, 1 )
   WHILE .T.
      FO6T()
      ScrollBarDisplay( aSBAR )
      SCROLLBARUPDATE( aSBAR, BCHEI, Graf, .T. )
      BCHEI2 := AChoice( 07, 01, 21, 78, NAT1,, "ACHRET", BCHEI )
      BCHEI  := IF( BCHEI2 # 0, BCHEI2, BCHEI )
      BCHEI2 := BCHEI
      MD()
      DO CASE
      CASE LastKey() = K_ESC
         MDS( 'Retornando' )
         EXIT
      CASE LastKey() = K_ALT_F10
         MDS( 'Imprimindo' )
         FO6L()
      CASE LastKey() = K_INS
         MDT( 'Saia do Grupo para Incluir ' )
         LOOP
      CASE LastKey() = K_ENTER
         MDS( 'Alterando ' )
         FO61( 2, BCHEI )
      CASE LastKey() = K_DEL
         MDT( 'Saia do Grupo para Excluir ' )
         LOOP
      CASE LastKey() = K_ALT_F1
         MDS( 'Alterando  ' )
         FO61( 4, BCHEI )
      CASE LastKey() = K_ALT_F2
         MDS( 'Alterando  ' )
         FO61( 5, BCHEI )
      CASE LastKey() = K_ALT_F3
         MDS( 'Alterando  ' )
         FO61( 6, BCHEI )
      CASE LastKey() = K_ALT_F4
         MDS( 'Alterando  ' )
         FO61( 7, BCHEI )
      CASE LastKey() = K_ALT_F5
         MDS( 'Alterando  ' )
         FO61( 8, BCHEI )
      CASE LastKey() = K_ALT_F9
         MDT( 'Ja em grupo' )
         LOOP
      CASE pBUS
         MDS( 'Digite o Codigo da Conta : ' )
         @ 24, 40 GET mCODIGO
         READCUR()
         MD()
         BCHEI := AScan( NAT2, mCODIGO )
         IF BCHEI = 0
            MDT( 'Nao localizei o Registro Correspondente ....' )
            BCHEI := BCHEI2
            LOOP
         ENDIF
      OTHERWISE
         LOOP
      ENDCASE
   ENDDO
// : FIM: FO6.PRG


// + EOF: fo6.prg
// +
