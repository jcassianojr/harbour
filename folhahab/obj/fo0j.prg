// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo0j.prg
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
// +    Documentado em 27-Dez-2024 as  9:44 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


// :*****************************************************************************
// :
// :       FO0J.PRG: Alterar Tabela de Imposto de Renda
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/94     11:04
// :
// :   & Fncts: FO0J()
// :               : FOKT
// :               : FOKS
// :               : FOKG
// :
// :          Chama: FOKT               ( em FO0J.PRG)
// :               : FOKS               (  em FO0J.PRG)
// :               : FOKG               ( em FO0J.PRG)
// :
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************

IF !netuse( "TABIRRF" )   // BREDE("TABIRRF",0)
RETU
ENDIF
dbGoto( MESTRAB )
WHILE .T.
FOKT()
FOKS()
MD()
@ 23, 02 PROM 'P>r¢ximo'
@ 23, 11 PROM 'R>etorna'
@ 23, 20 PROM 'A>ltera '
MENU TO OPCAO
DO CASE
CASE OPCAO = 1
NEXTREC()
CASE OPCAO = 2
PREVREC()
CASE OPCAO = 3
FOKG()
netreclock()
FIELD->DESAL2 := ( ATESAL1 + 0.01 )
FIELD->DESAL3 := ( ATESAL2 + 0.01 )
FIELD->DESAL4 := ( ATESAL3 + 0.01 )
FIELD->DESAL5 := ( ATESAL4 + 0.01 )
FIELD->DESAL6 := ( ATESAL5 + 0.01 )
FIELD->DESAL7 := ( ATESAL6 + 0.01 )
dbUnlock()
OTHERWISE
dbCloseAll()
RETU
ENDCASE
ENDDO

// !*****************************************************************************
// !
// !      FOKT
// !
// !    Chamado por: FO0J.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOKT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FOKT

   @ 05, 00 CLEA
   @ 05, 00 SAY "+" + REPL( '-', 78 ) + "+"
   @ 06, 00 SAY "Ý Alterando dados Tabela do IRRF do mˆs     -" + SPAC( 34 ) + "Ý"
   @ 07, 00 SAY "Ý" + REPL( '-', 6 ) + "-" + REPL( '-', 20 ) + "-" + REPL( '-', 20 ) + "-" + REPL( '-', 8 ) + "-" + REPL( '-', 20 ) + "Ý"
   @ 08, 00 SAY "ÝCLASSEÝ DO SALARIO" + SPAC( 9 ) + "Ý ATE SALARIO" + SPAC( 8 ) + "Ý % DESC Ý PARCELA" + SPAC( 12 ) + "Ý"
   @ 09, 00 SAY "Ý" + REPL( '-', 6 ) + "+" + REPL( '-', 20 ) + "+" + REPL( '-', 20 ) + "+" + REPL( '-', 8 ) + "+" + REPL( '-', 20 ) + "Ý"
   @ 10, 00 SAY "Ý  1   Ý" + SPAC( 20 ) + "Ý" + SPAC( 20 ) + "Ý" + SPAC( 8 ) + "Ý" + SPAC( 20 ) + "Ý"
   @ 11, 00 SAY "Ý  2   Ý" + SPAC( 20 ) + "Ý" + SPAC( 20 ) + "Ý" + SPAC( 8 ) + "Ý" + SPAC( 20 ) + "Ý"
   @ 12, 00 SAY "Ý  3   Ý" + SPAC( 20 ) + "Ý" + SPAC( 20 ) + "Ý" + SPAC( 8 ) + "Ý" + SPAC( 20 ) + "Ý"
   @ 13, 00 SAY "Ý  4   Ý" + SPAC( 20 ) + "Ý" + SPAC( 20 ) + "Ý" + SPAC( 8 ) + "Ý" + SPAC( 20 ) + "Ý"
   @ 14, 00 SAY "Ý  5   Ý" + SPAC( 20 ) + "Ý" + SPAC( 20 ) + "Ý" + SPAC( 8 ) + "Ý" + SPAC( 20 ) + "Ý"
   @ 15, 00 SAY "Ý  6   Ý" + SPAC( 20 ) + "Ý" + SPAC( 20 ) + "Ý" + SPAC( 8 ) + "Ý" + SPAC( 20 ) + "Ý"
   @ 16, 00 SAY "Ý  7   Ý" + SPAC( 20 ) + "Ý" + SPAC( 20 ) + "Ý" + SPAC( 8 ) + "Ý" + SPAC( 20 ) + "Ý"
   @ 17, 00 SAY "Ý" + REPL( '-', 6 ) + "-" + REPL( '-', 20 ) + "-" + REPL( '-', 4 ) + "Ñ" + REPL( '-', 15 ) + "-" + REPL( '-', 8 ) + "-" + REPL( '-', 20 ) + "Ý"
   @ 18, 00 SAY "Ý Arredonda Desconto :   (S/N)   Ý  Qtde Maxima de Dependentes =>" + SPAC( 14 ) + "Ý"
   @ 19, 00 SAY "Ý Despreza Centavos  :   (S/N)   Ý  Valor por Dependente =>" + SPAC( 20 ) + "Ý"
   @ 20, 00 SAY "Ý Fator :                        Ý  Minimo de Desconto   =>" + SPAC( 20 ) + "Ý"
   @ 21, 00 SAY "Ý Fator2:                        Ý                         " + SPAC( 20 ) + "Ý"
   @ 22, 00 SAY "+" + REPL( '-', 32 ) + "Ï" + REPL( '-', 45 ) + "+"
   RETU

// !*****************************************************************************
// !
// !      FOKS
// !
// !    Chamado por: FO0J.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOKS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FOKS

   @ 06, 40 SAY NMES
   @ 06, 46 SAY EMES
   @ 10, 09 SAY DESAL1
   @ 10, 30 SAY ATESAL1
   @ 10, 51 SAY TAXA1
   @ 10, 60 SAY PARCELA1
   @ 11, 09 SAY DESAL2
   @ 11, 30 SAY ATESAL2
   @ 11, 51 SAY TAXA2
   @ 11, 60 SAY PARCELA2
   @ 12, 09 SAY DESAL3
   @ 12, 30 SAY ATESAL3
   @ 12, 51 SAY TAXA3
   @ 12, 60 SAY PARCELA3
   @ 13, 09 SAY DESAL4
   @ 13, 30 SAY ATESAL4
   @ 13, 51 SAY TAXA4
   @ 13, 60 SAY PARCELA4
   @ 14, 09 SAY DESAL5
   @ 14, 30 SAY ATESAL5
   @ 14, 51 SAY TAXA5
   @ 14, 60 SAY PARCELA5
   @ 15, 09 SAY DESAL6
   @ 15, 30 SAY ATESAL6
   @ 15, 51 SAY TAXA6
   @ 15, 60 SAY PARCELA6
   @ 16, 09 SAY DESAL7
   @ 16, 30 SAY ATESAL7
   @ 16, 51 SAY TAXA7
   @ 16, 60 SAY PARCELA7
   @ 18, 23 SAY ARREDONDA
   @ 19, 23 SAY DESPRESA
   @ 18, 66 SAY QTDEDEP
   @ 19, 60 SAY VALDEPENDE
   @ 20, 60 SAY MINIMO
   @ 20, 10 SAY FATORIRRF
   @ 21, 10 SAY FATORIRR2
   RETU

// !*****************************************************************************
// !
// !       FOKG
// !
// !    Chamado por: FO0J.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOKG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FOKG

   NETRECLOCK()
   @ 06, 40 SAY NMES
   @ 06, 46 SAY EMES
   @ 11, 09 SAY DESAL2
   @ 12, 09 SAY DESAL3
   @ 13, 09 SAY DESAL4
   @ 14, 09 SAY DESAL5
   @ 15, 09 SAY DESAL6
   @ 16, 09 SAY DESAL7
   @ 10, 09 GET DESAL1
   @ 10, 30 GET ATESAL1
   @ 10, 51 GET TAXA1
   @ 10, 60 GET PARCELA1
   @ 11, 30 GET ATESAL2
   @ 11, 51 GET TAXA2
   @ 11, 60 GET PARCELA2
   @ 12, 30 GET ATESAL3
   @ 12, 51 GET TAXA3
   @ 12, 60 GET PARCELA3
   @ 13, 30 GET ATESAL4
   @ 13, 51 GET TAXA4
   @ 13, 60 GET PARCELA4
   @ 14, 30 GET ATESAL5
   @ 14, 51 GET TAXA5
   @ 14, 60 GET PARCELA5
   @ 15, 30 GET ATESAL6
   @ 15, 51 GET TAXA6
   @ 15, 60 GET PARCELA6
   @ 16, 30 GET ATESAL7
   @ 16, 51 GET TAXA7
   @ 16, 60 GET PARCELA7
   READCUR()
   @ 18, 23 GET ARREDONDA VALID ARREDONDA $ 'SN'
   @ 19, 23 GET DESPRESA  VALID DESPRESA $ 'SN'
   @ 20, 10 GET FATORIRRF
   @ 21, 10 GET FATORIRR2
   READCUR()
   @ 18, 66 GET QTDEDEP    VALID !Empty( QTDEDEP )
   @ 19, 60 GET VALDEPENDE VALID !Empty( VALDEPENDE )
   @ 20, 60 GET MINIMO
   READCUR()
   dbUnlock()
   RETU
// : FIM: FO0J.PRG

// + EOF: fo0j.prg
// +
