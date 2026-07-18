// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foc.prg
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
// :        FOC.PRG: Menu De Impress„o de Dados
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  jcassiano  S/C Ltda.
// :  Atualizado em: 30/06/98
// :
// :*****************************************************************************

#include "BOX.CH"
IMPHP()



DECLARE XTI[ 11 ]
AFill( XTI, " A - Apuracao Geral por Conta " )
XTI[ 9 ] = " A - Relacao de Adiantamento  "
XTI[ 10 ] = " A - Relacao de Premio        "
XTI[ 11 ] = " A - Relacao de Ocorrencias   "


WHILE .T.
CABEX( "Menu De Impress„o de Dados" )
hb_DispBox( 7, 0, 19, 79, B_DOUBLE + " " )
oPCAO( 8, 01, " &1 - Pagamento       ", 49 )
oPCAO( 9, 01, " &2 - Ferias          ", 50 )
oPCAO( 10, 01, " &3 - Rescis„o        ", 51 )
oPCAO( 11, 01, " &4 - 13o.Salario     ", 52 )
oPCAO( 12, 01, " &5 - Complemento     ", 53 )
oPCAO( 13, 01, " &6 - Vale Transporte ", 54 )
oPCAO( 14, 01, " &7 - Folha Semanal   ", 55 )
oPCAO( 15, 01, " &8 - Folha RPA       ", 56 )
oPCAO( 16, 01, " &A - Adiantamento    ", 65 )
oPCAO( 17, 01, " &B - Premio          ", 66 )
oPCAO( 18, 01, " &C - Ocorrencias     ", 67 )
ARQ  := menu(, 0 )
TELA := SaveScreen( 07, 00, 19, 22 )
IF ARQ = 0
RETU
ENDIF
DO CASE
CASE ARQ = 11
FOCH()
OTHER
FOC1()
ENDCASE
ENDDO

// !*****************************************************************************
// !
// !       FOC1
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOC1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FOC1

   WHILE .T.
      HELPDBF := "FOC"
      CABEX( "Menu De Impress„o de Dados" )
      RestScreen( 07, 00, 19, 22, TELA )
      hb_DispBox( 8, 23, 22, 54, B_DOUBLE + " " )
      @ 10, 24 PROM XTI[ ARQ ]
      @ 11, 24 PROM " B - Rela‡„o Banc ria         "
      @ 12, 24 PROM " C - Rela‡„o de L¡quidos      "
      @ 13, 24 PROM " D - Pagto Executado Completo "
      @ 14, 24 PROM " E - Lan‡amentos de Horas     "
      @ 15, 24 PROM " F - Lan‡amentos de Valores   "
      @ 16, 24 PROM " G - Emitir Cheques Liquidos  "
      @ 17, 24 PROM " H - Notas Para Troco         "
      @ 18, 24 PROM " I - Arquivo  Cr‚dito Banespa "
      @ 19, 24 PROM " J - Checagem de Tributos     "
      DO CASE
      CASE ARQ = 8
         @ 20, 24 PROM " K - Recibo de Pagto Aut. RPA "
      CASE ARQ = 6
         @ 20, 24 PROM " K - Resumo Para Compra    "
      OTHERWISE
         @ 20, 24 PROM " K -                       "
      ENDCASE
      @ 21, 24 PROM " L - Arquivo  Cr‚dito Itau    "
      MENU TO TIP
      TELA2 := SaveScreen( 08, 23, 22, 54 )
      IF TIP = 0
         RETU
      ENDIF
      DO CASE
      CASE TIP = 8 .AND. ARQ = 6
         FOCG()
      CASE TIP = 8 .AND. ARQ = 8
         HELPDBF := "FO07"
         FOC2()
      CASE TIP = 1 .AND. ARQ # 9 .AND. ARQ # 10
         FOCA2( ARQ )
      CASE TIP = 10
         FOCB( ARQ )
      CASE TIP = 11
         FOCK( ARQ )
      OTHERWISE
         FOC2()
      ENDCASE
   ENDDO
   RETU


// !*****************************************************************************
// !
// !      FOC2
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOC2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FOC2

   WHILE .T.
      CABEX( "Menu De Impress„o de Dados" )
      RestScreen( 07, 00, 19, 22, TELA )
      RestScreen( 08, 23, 22, 54, TELA2 )
      hb_DispBox( 8, 55, 18, 75, B_DOUBLE + " " )
      @ 10, 56 PROM " X - Global        "
      @ 12, 56 PROM " Y - Departamentos "
      @ 14, 56 PROM " Z - Setores       "
      @ 16, 56 PROM " W - Se‡”es        "
      MENU TO KEY
      IF KEY = 0
         RETU
      ENDIF
      DO CASE
      CASE TIP = 1 .AND. ARQ = 10
         FOCA1( 445, 527, 409, 'PREMIO TRIBUTADO', KEY )
      CASE TIP = 1 .AND. ARQ = 9
         FOCA1( 41, 501, 403, 'ADIANTAMENTO SALARIAL', KEY )
      CASE TIP = 2
         FOCC( ARQ, KEY, 2 )
      CASE TIP = 3
         FOCC( ARQ, KEY, 1 )
      CASE TIP = 4
         FOCD( ARQ, KEY )
      CASE TIP = 5
         FOCF( ARQ, 1, KEY )
      CASE TIP = 6
         FOCF( ARQ, 0, KEY )
      CASE TIP = 7
         FOCC( ARQ, KEY, 3 )
      CASE TIP = 8
         FOCJ( ARQ, KEY )
      CASE TIP = 9
         FOCC( ARQ, KEY, 4 )
      CASE TIP = 12
         FOCC( ARQ, KEY, 5 )
      OTHERWISE
         RETU
      ENDCASE
   ENDDO
// : FIM: FOC.PRG

// + EOF: foc.prg
// +
