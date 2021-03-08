
*:*****************************************************************************
*:       FOGB.PRG:  RECRIA PLANILHA DE FALTAS OU HT
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1998,  SOFTEC  S/C Ltda.
*:  Atualizado em: 01/07/98
*:
*:*****************************************************************************


CABEX('Criar Planilha')
MDS('AGUARDE CRIANDO NOVA PLANILHA')

netzap("FO_HOR")

IF ! NETUSE(PES) //AREDE(PES,PES,1)
   RETU
ENDIF
FILTRO="EMPTY(DEMITIDO)"
SET FILTER TO &FILTRO

IF ! netuse("FO_HOR") //AREDE("FO_HOR","FO_HOR",0)
   DBCLOSEALL()
   RETU
ENDIF

DBSELECTAR(PES)
DBGOTOP()
WHILE ! EOF()
   NUM=NUMERO
   NOM=NOME
   DBSELEcTAR("FO_HOR")
   NETRECAPP()
   FIELD->NUMERO:=NUM
   FIELD->NOME:=NOM
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
RETU
*: FIM: FOGB.PRG
