*:*****************************************************************************
*:
*:     FO_FOR.PRG: Imprimir Formul rios
*:      Linguagem: HARBOUR
*:        Sistema: FOLHA DE PAGAMENTO
*:
*:  Procs & Fncts: FO_FOR()
*:
*:          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
*:               : FO_RELL()          (fun‡„o    em FO_RELL.PRG)
*:
*:     Arq. Dados: DISKRELA
*:
*:         Indice:  DISKRELA   Codigo do Relatorio
*:                             CODIGO
*:
*:     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
*:*****************************************************************************


function fo_for()
CABEX('Imprimir Formul rios')
PARA FGRUPO
ZDATA=DXDIA
GRAPP=1
MAT1={}
MAT2={}
IF ! netuse("DISKRELA") 
   RETU
ENDIF
GRAPT('Carregando Listas Disponiveis')
GRAPT=LASTREC()
SET FILTER TO &FGRUPO
DBGOTOP()
WHILE ! EOF()
   AADD(MAT1,' '+CODIGO+' -  '+DESCRICAO+' ')
   AADD(MAT2,CODIGO)
   GRAPS()
   DBSKIP()
ENDDO
DBCLOSEAREA()
WHILE .T.
   CABEX('Imprimir Formul rios')
   MDS('Tecle enter para listar o formul rio Desejado')
   ACHEI=ACHOICE(7,02,23,78,MAT1)
   IF ACHEI=0
      EXIT
   ENDIF
   FO_RELL(MAT2[ACHEI])
ENDDO
RETURN .T.
*: FIM: FO_FOR.PRG
