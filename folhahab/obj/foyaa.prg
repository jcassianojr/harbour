// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foyaa.prg
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
// +    Documentado em 27-Dez-2024 as  9:46 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :      FOYAA.PRG: Alterar Lay-out de Relatorio Dizeres
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/22/94     13:22
// :
// :  Procs & Fncts: FOYAA()
// :               : FOREDIT()
// :
// :          Chama: NSHOW1()           (fun‡„o    em FOLPROC.PRG)
// :               : FOREDIT()          (fun‡„o    em FOYAA.PRG, chamado  no Dbedit())
// :
// :     Arq. Dados: DISKREL1
// :
// :     Documentado 05/13/94 em 14:55                DISK!  vers„o 5.01
// :*****************************************************************************
#include "BOX.CH"

OPCAO := 'C'
MDS( 'Lay Out para T>opo C>onte£do R>odap‚' )
@ 24, 40 GET OPCAO VALID OPCAO $ "TCR"
READCUR()
DO CASE
CASE OPCAO = 'T'
LISTAS := mLISTAC
LTIPO  := 'Cabecalho'
CASE OPCAO = 'C'
LISTAS := mLISTA
LTIPO  := 'Conteudo'
CASE OPCAO = 'R'
LISTAS := mLISTAR
LTIPO  := 'Rodape'
ENDCASE
PCKL := .F.
IF !netuse( "DISKREL1" )
RETU
ENDIF
FILTRAR := 'NOME=LISTAS'
SET FILTER TO &FILTRAR
GO TOP
DECLARE CAMPOS[ 1 ]
CAMPOS[ 1 ] = "STR(SEQ)+'  '+STR(LIN)+'  '+STR(COL)+'  '+SUBSTR(DIZ,1,60)"
// CLEAR TYPEAHEAD
hb_keyClear()
IF !NSHOW1()
RETU
ELSE
IF Empty( NOME )
NETRECLOCK()
FIELD->NOME := LISTAS
dbUnlock()
// CLEAR TYPEAHEAD
hb_keyClear()
KEYBOARD Chr( 13 )
SetColor( "W/N" )
ENDIF
ENDIF
hb_DispBox( 8, 0, 23, 79, B_DOUBLE + " " )
@ 09, 02 SAY "Editando Relatorio  " + REPL( '-', 2 ) + Chr( 16 ) + SPAC( 9 ) + "Alterando: "
@ 10, 00 SAY 'Æ' + REPL( '-', 78 ) + 'µ'
@ 11, 02 SAY "Seq.   Lin Col  Conteudo da Sequencia"
@ 12, 00 SAY '+' + REPL( '-', 78 ) + 'Ý'
@ 09, 26 SAY LISTAS
@ 09, 50 SAY LTIPO
dbEdit( 13, 1, 22, 78, CAMPOS, "FOREDIT", .T., "", "", "", "", "" )
SET FILTER TO
dbCloseArea()
NETPACK( "DISKREL1", PCKL )

   RETURN

// !*****************************************************************************
// !
// !         Funcao: FOREDIT()
// !
// !    Chamado por: FOYAA.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOREDIT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FOREDIT

   PARAMETERS MODO

   KEY := LastKey()
   DO CASE
   CASE KEY = 27
      RETU ( 0 )
   CASE KEY = 13
      NETRECLOCK()
      @ Row(), 02 GET SEQ
      @ Row(), 09 GET LIN
      @ Row(), 13 GET COL
      @ Row(), 17 GET DIZ PICT "@S60"
      READCUR()
      dbUnlock()
   CASE KEY = 22 .OR. MODO = 3
      MD()
      NETRECAPP()
      FIELD->NOME := LISTAS
      @ 24, 02 GET SEQ
      @ 24, 09 GET LIN
      @ 24, 13 GET COL
      @ 24, 17 GET DIZ PICT "@S60"
      READCUR()
      @ 22, 00 CLEAR
   CASE KEY = 7
      SET CURSOR ON
      IF MDG( 'Confirmacao exclusao ?' )
         NETRECDEL()
         dbSkip()
         PCKL := .T.
      ENDIF
      MD()
      SET CURSOR OFF
   OTHERWISE
      RETU ( 1 )
   ENDCASE
   RETU ( 1 )

// : FIM: FOYAA.PRG

// + EOF: foyaa.prg
// +
