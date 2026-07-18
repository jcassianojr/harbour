// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fod1.prg
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
// :       FOD1.PRG: Calcular Adiantamento salarial
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/25/94     11:45
// :
// :  Procs & Fncts: FOD1()
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :               : FOD7()             (fun‡„o    em FOD7.PRG)
// :               : FOD1B()            (fun‡„o    em FOD1B.PRG)
// :
// :     Arq. Dados: CONTAS - Cadastro de Vencimentos e Descontos
// :
// :        Indices: CONTA      Por ordem de c¢digo
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************

#include "BOX.CH"
CABEX( 'Calcular Adiantamento salarial' )
SET COLOR TO R / GR
hb_DispBox( 8, 0, 21, 79, B_DOUBLE + " " )
@ 10, 3 SAY 'Vocˆ s¢ poder  calcular o ADIANTAMENTO ap¢s    ter   iniciado'
@ 12, 3 SAY 'o mˆs, caso vocˆ j  tenha iniciado o mˆs   digite  S  para  o'
@ 14, 3 SAY 'para o cumputador iniciar os c lculos,  caso vocˆ  n„o  tenha'
@ 16, 3 SAY 'iniciado o mˆs digite N, e inicie o mˆs'
SET COLO TO
IF !MDG( 'Deseja continuar' )
IF MDG( 'Deseja Inciar Agora o Mˆs' )
FOD7()
ELSE
RETU
ENDIF
ENDIF


MDS( 'Carregando dados da Conta do Vale.' )
IF !netuse( "contas" )  // AREDE("CONTAS","CONTAS",0)
RETU
ENDIF
dbGoTop()
IF !dbSeek( 41 )
ALERTX( 'N„o localizei a conta do vale 41' )
dbCloseAll()
RETU
ELSE
VAR0 := FATOR
ENDIF
dbCloseAll()

MDS( "Confirme o Fator" )
@ 24, 40 GET VAR0
IF !READCUR()
RETU .F.
ENDIF

IF VAR0 = 0
ALERTX( 'Seu fator ‚ zero !!! Descontinuando o Calculo' )
RETU .F.
ENDIF


IF VAR0 > .5
IF ZUSER <> "SUPERVISOR"   // So troca Senha
ALERTX( "Adiantamento com mais 50% so permitido para o SUPERVISOR" )
RETU .F.
ENDIF
ENDIF

ARREDONDA := 0.00
IF MDG( 'Deseja arredondar' )
MDS( 'Digite arredondamento' )
@ 24, 57 GET ARREDONDA PICT '##,###.##'
READCUR()
ENDIF

XA := XB := XC := XD := XE := XF := 1
FOD1B()
dbCloseAll()
RETU

// : FIM: FOD1.PRG

// + EOF: fod1.prg
// +
