// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foib.prg
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
// :       FOIB.PRG: CADASTRO DE TITULOS
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/08/94     11:05
// :
// :  Procs & Fncts: FOIB()
// :               : CADTIT()
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :               : CADTIT()           (fun‡„o    em FOIB.PRG, chamado  no Dbedit())
// :
// :     Arq. Dados: TIRES
// :               : TILRESG
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************

// ** FOIB - Cadastro de TITULOS
CABEX( 'Cadastro de T¡tulos' )
PARA CC
IF CC = 1
IF !NETUSE( "TILRES",,,,, .F., )  // BREDE("TILRES",0)
RETU
ENDIF
ELSE
IF !NETUSE( "TILRESG",,,,, .F., )   // BREDE("TILRESG",0)
RETU
ENDIF
ENDIF
dbGoTop()
DECLARE CAMPOS[ 1 ]
CAMPOS[ 1 ] = "' '+NOME+' '+TITULO+' '"
SET COLOR TO
@ 08, 00 CLEAR
@  8, 00 TO 23, 79 DOUB
@  9, 03 SAY "TITULO  No."
@  9, 16 SAY "DESCRICAO"
@ 10, 00 SAY "Ý" + REPL( '-', 78 ) + "Ý"
// CLEAR TYPEAHEAD
hb_keyClear()
KEYBOARD " "
dbEdit( 11, 2, 22, 28, CAMPOS, "CADTIT", .T., "", "", "", "", "" )
dbCloseAll()
RETU

// !*****************************************************************************
// !
// !         Fun‡„o: CADTIT()
// !
// !    Chamado por: FOIB.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CADTIT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC CADTIT

   PARAMETERS MODO

   KEY := LastKey()
   DO CASE
   CASE KEY = 27
      RETU ( 0 )
   CASE KEY = 13

      @ Row(), 16 GET TITULO
      READCUR()

      RETU ( 1 )
   OTHERWISE
      RETU ( 1 )
   ENDCASE
   RETU ( 1 )
// : FIM: FOIB.PRG

// + EOF: foib.prg
// +
