*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fo42c.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 27-Dez-2024 as  9:44 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :      FO42A.PRG: Cadastro de Projecao Salarial Modulo Consulta Registros
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/07/94     14:53
// :
// :  Procs & Fncts: FO42C()
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :               : NADA()             (fun‡„o    em ?, chamado  no Dbedit())
// :
// :        Indices: &MTEMP
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************



CABEX('Modulo consulta registros do cadastro de funcionarios')
MDS('Tecle [esc] para retornar ao menu principal')
IF !NETUSE("FO_PSL")
   RETU
ENDIF
FILTRO := ''
INX    := ""
FILORD(.T.)
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
if valtype(INX) = "N"
   dbsetorder(INX)
ELSE
   ordDestroy("temp")
   ordcreate(,"temp",inx)
   ordSetFocus("temp")
ENDIF
set filter to &FILTRO

DBGOTOP()
DECLARE CAMPOS[9],TITULO[9],MASCAR[9]
NADA := ''
CAMPOS[1] = 'NUMERO'
CAMPOS[2] = 'NOME'
CAMPOS[3] = 'ADMITIDO'
CAMPOS[4] = 'FUNCAO'
CAMPOS[5] = 'SALANT'
CAMPOS[6] = 'SALATU'
CAMPOS[7] = 'SALPRO'
CAMPOS[8] = 'TAXA1'
CAMPOS[9] = 'TAXA2'

TITULO[1] = 'CODIGO'
TITULO[2] = 'NOME DO FUNCIONARIO'
TITULO[3] = 'DATA ADMISSAO'
TITULO[4] = 'FUNCAO'
TITULO[5] = 'SALARIO ANT.'
TITULO[6] = 'SALARIO PROJ1.'
TITULO[7] = 'SALARIO PROJ2.'
TITULO[8] = 'TAXA PROJ1.'
TITULO[9] = 'TAXA PROJ2.'

MASCAR[1] = '99999'
MASCAR[5] = '999,999,999.99'
MASCAR[6] = '999,999,999.99'
MASCAR[7] = '999,999,999.99'
MASCAR[8] = '999.99%'
MASCAR[9] = '999.99%'

DBEDIT(7,4,21,75,CAMPOS,NADA,MASCAR,TITULO)
DBCLOSEALL()
RETU
// : FIM: FO42C.PRG

*+ EOF: fo42c.prg
*+
