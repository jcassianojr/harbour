// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo1l.prg
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
// :       FO1L.PRG: Zerando dados de uma Empresa
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/25/94     11:09
// :
// :  Procs & Fncts: FO1L()
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :               : CLSCOR()           (fun‡„o    em ?)
// :               : FO1T()             (fun‡„o    em FO1T.PRG)
// :               : FO1S()             (fun‡„o    em FO1S.PRG)
// :               : FOY2()             (fun‡„o    em FOY2.PRG)
// :
// :     Arq. Dados: FIRMA -  Cadastro de Empresas
// :
// :         Indice: FIRNR      N£mero de Cadastramento
// :                            NRCLIEN
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************

#include "BOX.CH"
// //#INCLUDE "COMANDO.CH"

CABEX( 'Zerando dados de uma Empresa' )
SetColor( "B/W" )
hb_DispBox( 8, 0, 21, 79, B_DOUBLE + " " )
@ 10, 5 SAY "Vocˆ ir  Apagar todos os dados referentes a ESTA EMPRESA."
@ 12, 5 SAY "Ap¢s a confirma‡„o deste procedimento os dados desta empresa, estar„o"
@ 14, 6 SAY "em branco e n„o poder„o mais ser recuperados."
@ 16, 5 SAY "Mesmo ciente deste procedimento aconselhamos inicialmente a fazer duas"
@ 18, 6 SAY "copia dos arquivos da Empresa em quest„o (BACKUP)."
CLSCOR()
IF !MDG( 'Vocˆ deseja continuar' )
RETU
ENDIF
IF !MDG( 'Confirma exclus„o dos dados da empresa atual' )
RETU
ENDIF
IF !MDG( 'Vocˆ realmente tem certeza' )
RETU
ENDIF
IF !MDG( 'Vocˆ est  absolutamente certo' )
RETU
ENDIF
hb_cwd( '..' )
// DIRCHANGE('..')                                 &&ZAP NOS ARQUIVOS
aUSO := FILENAMES( '*.DBF' )
FOR X := 1 TO Len( aUSO )
ARQUIVO := aUSO[ X ]
MDS( 'Preparando: ' + ARQUIVO )
USO := TIRAEXT( arquivo )
netzap( uso )
NEXT X
hb_cwd( '..' )
// DIRCHANGE('..')
FOY2( 0, "FOLHANTX" )
dbCloseAll()
RETU
// : FIM: FO1L.PRG

// + EOF: fo1l.prg
// +
