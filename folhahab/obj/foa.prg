// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foa.prg
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
// :        FOA.PRG: Menu de Entrada de Dados
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  jcassiano  S/C Ltda.
// :  Atualizado em: 17/07/98
// :
// :*****************************************************************************
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foa()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foa

   PARA OPER

   IF OPER = 2
      FOAA()
      RETU
   ENDIF
   WHILE .T.
      CABEX( "Menu de Entrada de Dados" )
      hb_DispBox( 05, 00, 23, 24, B_DOUBLE + " " )
      OPCAO( 07, 01, "  &1 - Folha           ", 49 )
      OPCAO( 08, 01, "  &2 - Ferias          ", 50 )
      OPCAO( 09, 01, "  &3 - Rescisao        ", 51 )
      OPCAO( 10, 01, "  &4 - 13o. Salario    ", 52 )
      OPCAO( 11, 01, "  &5 - Complementar    ", 53 )
      OPCAO( 12, 01, "  &6 - Vale Transporte ", 54 )
      OPCAO( 13, 01, "  &7 - Semanal         ", 56 )
      OPCAO( 14, 01, "  &8 - RPA             ", 57 )
      OPCAO( 15, 01, "  &9 - Ocorrˆncias     ", 55 )
      OPCAO( 16, 01, "  &A - SEFIP           ", 65 )
      ARQ := MENU(, 0 )
      IF ARQ = 0
         RETU
      ENDIF
      TELA := SaveScreen( 05, 00, 23, 24 )
      IF OPER = 0
         DO CASE
         CASE ARQ < 6
            FOAA1()
         CASE ARQ = 6    // VT
            FOAA2()
         CASE ARQ = 7    // Semanal
            FOAA8( 1 )
         CASE ARQ = 8    // Rpa
            FOAA11()
         CASE ARQ = 9    // Ocorrencias
            FOAA4()
         CASE ARQ = 10   // SEFIP
            FOAA10()
         ENDCASE
      ELSE
         IF ARQ = 9
            FOAL()
         ELSE
            FOAA3()
         ENDIF
      ENDIF
   ENDDO

// !*****************************************************************************
// !
// !       FOAA1
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOAA1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FOAA1

   WHILE .T.
      CABEX( "Menu de Entrada de Dados" )
      RestScreen( 05, 00, 23, 24, TELA )
      hb_DispBox( 07, 32, 21, 68, B_DOUBLE + " " )
      OPCAO( 09, 33, "  &A - Individualizado.             ", 65 )
      OPCAO( 10, 33, "  &B - Uma Conta Grupo de Funcion.  ", 66 )
      OPCAO( 11, 33, "  &C - SequEncia Pre Selecionada.   ", 67 )
      OPCAO( 12, 33, "  &D - Planilha Grupo Funcion rios. ", 68 )
      OPCAO( 13, 33, "  &E - EdiCAo dos Dados.            ", 69 )
      OPCAO( 14, 33, "  &F - LanCamento pre programado    ", 70 )
      OPCAO( 15, 33, "  &G - Dependentes*Valor=Assistencia", 71 )
      OPCAO( 16, 33, "  &H - Insalubridade Indicada       ", 72 )
      TIP := MENU(, 0 )
      DO CASE
      CASE TIP = 1
         FOA1( ARQ )
      CASE TIP = 2
         FOA2( ARQ, 0 )
      CASE TIP = 3
         FOA3( ARQ )
      CASE TIP = 4
         FOA2( ARQ, 1 )
      CASE TIP = 5
         FOA4( ARQ )
      CASE TIP = 6
         FOAB( ARQ )
      CASE TIP = 7
         FOA7( ARQ )
      CASE TIP = 8
         FOA6( ARQ )
      OTHERWISE
         EXIT
      ENDCASE
   ENDDO


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOAA10()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FOAA10

   WHILE .T.
      CABEX( "Menu de Entrada de Dados Sefip" )
      RestScreen( 05, 00, 23, 24, TELA )
      hb_DispBox( 07, 32, 21, 68, B_DOUBLE + " " )
      OPCAO( 09, 33, "  &A - Complemento Empresa          ", 65 )
      OPCAO( 10, 33, "  &B - Complemento Tomadores        ", 66 )
      TIP := MENU(, 0 )
      DO CASE
      CASE TIP = 1
      CASE TIP = 2
      OTHERWISE
         EXIT
      ENDCASE
   ENDDO


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOAA11()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FOAA11

   WHILE .T.
      CABEX( "Menu de Entrada de Dados RPA" )
      RestScreen( 05, 00, 23, 24, TELA )
      hb_DispBox( 07, 32, 21, 68, B_DOUBLE + " " )
      OPCAO( 09, 33, "  &A - Individualizado             ", 65 )
      OPCAO( 10, 33, "  &B - Lan‡amentos                 ", 66 )
      OPCAO( 11, 33, "  &C - Calcular Lan‡amentos        ", 67 )
      TIP := MENU(, 0 )
      DO CASE
      CASE TIP = 1
         FOAA8( 2 )
      CASE TIP = 2
         PADRAO( "RL" + ARQMES, "RL" + ARQMES, "' '+STR(mLCTO,8)+' '+STR(mNUMERO,5)+' '+STR(mCONTA,3)+' '+STR(mSEMANA,1)+' '+STR(mHORAS,7,2)+' '+STR(mVALOR,12,2)+' '+DTOC(mDATA)", "mLCTO", "Lan‡amentos RPA", "Lcto     No.   Cta S Horas   Valor      Data", ;
            {|| PEGCHAVE( "mLCTO", ULTIMOREG( "RL" + ARQMES, "LCTO", .T. ), "Lancamento:" ) }, "RPL001", "RPL001", {|| FO_FOR( "GRUPO='RPL'" ) } )
      CASE TIP = 3
         FOARPLS()
      OTHERWISE
         EXIT
      ENDCASE
   ENDDO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOARPLS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FOARPLS

   IF !netuse( RPA )
      dbCloseAll()
      RETU .F.
   ENDIF

   IF !NETUSE( "RL" + ARQMES )
      dbCloseAll()
      RETU .F.
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "NUMERO*10000+SEMANA*1000+CONTA" )
   ordSetFocus( "temp" )


   cSELE2 := Alias()
   dbSelectAr( cSELE2 )
   dbGoTop()
   WHILE !Eof()
      mNUMERO := NUMERO
      mSEMANA := SEMANA
      mCONTA  := CONTA
      mVALOR  := 0
      mHORAS  := 0
      WHILE mNUMERO = NUMERO .AND. mSEMANA = SEMANA .AND. mCONTA = CONTA .AND. !Eof()
         mVALOR += VALOR
         mHORAS += HORAS
         dbSelectAr( cSELE2 )
         dbSkip()
      ENDDO
      dbSelectAr( RPA )
      dbGoTop()
      IF !dbSeek( mNUMERO * 10000 + mSEMANA * 1000 + mCONTA )
         netrecapp()
         FIELD->NUMERO := mNUMERO
         FIELD->CONTA  := mCONTA
         FIELD->SEMANA := mSEMANA
      ELSE
         netreclock()
      ENDIF
      FIELD->VALOR := mVALOR
      FIELD->HORAS := mHORAS
      dbUnlock()
      dbSelectAr( cSELE2 )
   ENDDO
   dbCloseAll()
   RETU .T.

// !*****************************************************************************
// !
// !       FOAA2 //Sub Menu VT
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOAA2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FOAA2

   WHILE .T.
      CABEX( "Menu de Entrada de Vale Transporte" )
      RestScreen( 05, 00, 23, 24, TELA )
      hb_DispBox( 8, 32, 20, 79, B_DOUBLE + " " )
      OPCAO( 09, 34, " &A - Programa‡„o Individualizada Diaria     ", 65 )
      OPCAO( 10, 34, " &B - Marcar Quantidade Dias dos Mˆs         ", 66 )
      OPCAO( 11, 34, " &C - Checar Qtdde Dias Individual           ", 67 )
      OPCAO( 12, 34, " &D - Transferencia Diario => Mensal         ", 68 )
      OPCAO( 13, 34, " &E - Transferencia Vale Transporte => Folha ", 69 )
      OPCAO( 14, 34, " &G - Composi‡„o de Passagens                ", 70 )
      OPCAO( 15, 34, " &H - Alterar Folha Mensal                   ", 71 )
      OPCAO( 16, 34, " &I - Alterar Folha Mensal Avulsa            ", 72 )
      KEY := MENU(, 0 )
      DO CASE
      CASE KEY = 1
         FOA5()
      CASE KEY = 2
         FOA8A()
      CASE KEY = 3
         FOA8B()
      CASE KEY = 4
         FOA8()
      CASE KEY = 5
         FOA9()
      CASE KEY = 6
         FO0M()
      CASE KEY = 7
         FOA8C( "VTFOLHA", "VTFOLHA" )
      CASE KEY = 8
         FOA8C( "VTAVUL", "VTAVUL" )
      OTHERWISE
         RETU
      ENDCASE
   ENDDO
   RETU

// !*****************************************************************************
// !
// !       FOAA3
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOAA3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FOAA3

   WHILE .T.
      CABEX( "Exclusao de Entrada de Dados" )
      RestScreen( 05, 00, 23, 24, TELA )
      SET COLOR TO + GR / BG
      hb_DispBox( 8, 32, 16, 71, B_DOUBLE + " " )
      OPCAO( 10, 34, " &A - Lan‡amento de um Funcion rio   ", 65 )
      OPCAO( 12, 34, " &B - Lan‡amento de uma Conta" + SPAC( 8 ), 66 )
      OPCAO( 14, 34, " &C - Todos os Lan‡amentos Efetuados ", 67 )
      KEY := MENU(, 0 )
      SET COLO TO
      DO CASE
      CASE KEY = 1
         FOAX( ARQ, 0 )
      CASE KEY = 2
         FOAX( ARQ, 1 )
      CASE KEY = 3
         FOAX( ARQ, 2 )
      OTHERWISE
         RETU
      ENDCASE
   ENDDO
   RETU

// !*****************************************************************************
// !
// !       FOAA4
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOAA4()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FOAA4

   WHILE .T.
      CABEX( "Menu de Entrada de Dados" )
      RestScreen( 05, 00, 23, 24, TELA )
      hb_DispBox( 07, 32, 17, 68, B_DOUBLE + " " )
      OPCAO( 09, 33, " &A - Ocorrˆncia Individualizada    ", 65 )
      OPCAO( 11, 33, " &B - Ocorrˆncia Coletiva           ", 66 )
      OPCAO( 13, 33, " &C - Transferir Ocorrˆncia =>FOLHA ", 67 )
      TIP := MENU(, 0 )
      DO CASE
      CASE TIP = 1
         FOAL()
      CASE TIP = 2
         FOAM()
      CASE TIP = 3
         FOAO()
      OTHERWISE
         RETU
      ENDCASE
   ENDDO
   RETU


// : FIM: FOA.PRG

// + EOF: foa.prg
// +
