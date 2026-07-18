// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foge.prg
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
// :       FOGE.PRG: Cadastro de Hor rio Padr”es
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/25/94     12:06
// :
// :   & Fncts: FOGE()
// :               : HORPADT
// :               : HORPADS
// :               : HORPADG
// :               : HORPADL
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :               : HORPADT            (  em FOGE.PRG)
// :               : HORPADS            (  em FOGE.PRG)
// :               : HORPADG            ( em FOGE.PRG)
// :               : HORPADL            (  em FOGE.PRG)
// :
// :     Arq. Dados: HORPAD
// :
// :         Indice:  HORPAD     NOME DO HORARIO
// :                             NOME
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************

#include "BOX.CH"

CABEX( 'Cadastro de Horario Padroes' )
@ 08, 00 CLEAR
PCK := .F.
NOM := SPAC( 6 )
IF !netuse( "HORPAD" )
RETU
ENDIF
dbGoTop()
WHILE .T.
HORPADT()
HORPADS()
MD()
@ 23, 02 PROM 'P>roximo'
@ 23, 11 PROM 'R>etorna'
@ 23, 20 PROM 'A>ltera '
@ 23, 29 PROM 'E>xclui '
@ 23, 38 PROM 'B>usca  '
@ 23, 47 PROM 'I>nclui '
@ 23, 56 PROM 'L>ista  '
@ 23, 71 PROM 'S>aida'
MENU TO OPCAO
DO CASE
CASE OPCAO = 1
NEXTREC()
CASE OPCAO = 2
PREVREC()
CASE OPCAO = 3
HORPADG()
CASE OPCAO = 4
DELEREC()
CASE OPCAO = 5
@ 23, 01 CLEAR TO 23, 78
@ 24, 03 SAY 'Digite o nome : ' GET NOM
READCUR()
dbGoTop()
IF !dbSeek( NOM )
@ 23, 00 CLEAR TO 23, 78
@ 23, 03 SAY 'Hor rio n„o encontrado'
Inkey( 3 )
ENDIF
CASE OPCAO = 6
@ 23, 01 CLEAR TO 23, 78
@ 24, 03 SAY 'Digite o nome : ' GET NOM
READCUR()
dbGoTop()
IF !dbSeek( NOM )
netrecapp()
field->NOME := NOM
ENDIF
HORPADG()
CASE OPCAO = 7
HORPADL()
OTHERWISE
dbCloseAll()
netpack( 'horpad', pck )
RETU
ENDCASE
ENDDO

// !*****************************************************************************
// !
// !       HORPADS
// !
// !    Chamado por: FOGE.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function HORPADS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION HORPADS

   @ 10, 22 SAY NOME
   @ 13, 16 SAY D1
   @ 14, 16 SAY D2
   @ 15, 16 SAY D3
   @ 16, 16 SAY D4
   @ 17, 16 SAY D5
   @ 18, 16 SAY D6
   @ 19, 16 SAY D7
   RETU

// !*****************************************************************************
// !
// !       HORPADG
// !
// !    Chamado por: FOGE.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function HORPADG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION HORPADG

   netreclock()
   @ 10, 22 SAY NOME
   @ 13, 16 GET D1
   @ 14, 16 GET D2
   @ 15, 16 GET D3
   @ 16, 16 GET D4
   @ 17, 16 GET D5
   @ 18, 16 GET D6
   @ 19, 16 GET D7
   READCUR()
   dbUnlock()
   RETU

// !*****************************************************************************
// !
// !       HORPADT
// !
// !    Chamado por: FOGE.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function HORPADT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION HORPADT

   hb_DispBox( 8, 0, 22, 79, B_DOUBLE + " " )
   @ 10, 02 SAY "Horario Padr…o " + REPL( '-', 2 ) + Chr( 16 )
   @ 13, 02 SAY "Segunda    " + Chr( 26 )
   @ 14, 02 SAY "Ter‡a" + SPAC( 6 ) + Chr( 26 )
   @ 15, 02 SAY "Quarta     " + Chr( 26 )
   @ 16, 02 SAY "Quinta     " + Chr( 26 )
   @ 17, 02 SAY "Sexta" + SPAC( 6 ) + Chr( 26 )
   @ 18, 02 SAY "Sabado     " + Chr( 26 )
   @ 19, 02 SAY "Domingo    " + Chr( 26 )
   RETU

// !*****************************************************************************
// !
// !      HORPADL
// !
// !    Chamado por: FOGE.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function HORPADL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION HORPADL

   MDT( 'M¢dulo em Implanta‡„o' )
   RETU
// : FIM: FOGE.PRG

// + EOF: foge.prg
// +
