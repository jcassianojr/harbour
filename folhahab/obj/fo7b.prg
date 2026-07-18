// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo7b.prg
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
// :       FO7B.PRG: Excluir Funcionarios
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/07/94     15:17
// :
// :    Chamado por: FO7.PRG
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :               : PETELA()           (fun‡„o    em FOLPROC.PRG)
// :
// :     Documentado 05/13/94 em 14:53                DISK!  vers„o 5.01
// :*****************************************************************************



PCK := .F.
CTR := 0
CABEX( 'EXCLUI UM FUNCIONARIO' )
MDS( 'REGISTRO FUNCIONARIO ->' )
@ 24, 35 GET CTR PICT '#######'
READCUR()
IF !netuse( pes )   // AREDE(PES,PES,0)
RETU
ENDIF
dbGoTop()
IF dbSeek( CTR )
PETELA( 7 )
DELEREC()
ELSE
MDT( 'Funcionario n„o Encontrado' )
ENDIF
dbCloseAll()
netpack( pes, pck )
RETU

// : FIM: FO7B.PRG

// + EOF: fo7b.prg
// +
