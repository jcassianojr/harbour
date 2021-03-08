*:*****************************************************************************
*:
*:   FORES_EX.PRG: Dados B sicos para Formul rios de F‚rias
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/08/94     13:11
*:
*:*****************************************************************************

////#INCLUDE "COMANDO.CH"

function fores_ex
PARA OPX
DO CASE
    CASE OPX=1 ;   TITULO='Imprimir Aviso de Ferias'
    CASE OPX=2 ;   TITULO='Imprimir Solicitacao de Abono'
    CASE OPX=3 ;   TITULO='Imprimir Recibo de Ferias'
    CASE OPX=4 ;   TITULO='Imprimir Recibo de Abono de Ferias'
    CASE OPX=5 ;   TITULO='Imprimir Recibo de Complemento de Ferias'
    CASE OPX=6 ;   TITULO='Imprimir Recibo de Complemento de Abono'
ENDCASE
IF ! MDL(TITULO,0)
   RETU
ENDIF
MDS('Carregando dados da Empresa')
IF ! NETUSE("FIRMA") 
   RETU
ENDIF
DBGOTOP()
IF DBSEEK(NREMP)
   ENDER1=ENDERECO
   BAI1=BAIRRO
   CID1=CIDADE
   EST1=ESTADO
ELSE
   ENDER1:=BAI1:=CID1:=EST1:=''
ENDIF
DBCLOSEAREA()

CTR:=0
COP:=1
DADATAX=DATE()

MDS('Quantas C¢pias')
@ 24,30 GET COP PICT '####'
IF ! READCUR()
   RETU .F.
ENDIF


MDS('Digite o n£mero do Funcion rio')
@ 24,40 GET CTR PICT '######'
IF ! READCUR()
   RETU .F.
ENDIF

MDS('Digite o P‚riodo Aquisitivo')
@ 24,40 GET DADATAX
IF ! READCUR()
   RETU .F.
ENDIF

IF MDG("Imprimir Quatro Digitos para o Ano")
   set century on
ENDIF


IF ! NETUSE(PES) //AREDE(PES,PES,1)
   RETU
ENDIF
DBGOTOP()
IF ! DBSEEK(CTR)
   MDT('Funcionario ao encontrado')
   DBCLOSEALL()
   RETU
ENDIF
PETELA(8)


CTRA=(((((CTR*10000)+YEAR(DADATAX))*100)+MONTH(DADATAX))*100)+DAY(DADATAX)
IF ! NETUSE("FO_FER") //AREDE("FO_FER","FO_FER",1)
   RETU
ENDIF
DBGOTOP()
IF ! DBSEEK(CTRA)
   MDT('Per¡odo Aquisitivo n„o encontrado')
   DBCLOSEALL()
   RETU
ENDIF
FORESRT()
FORESRS()

DO CASE
    CASE OPX<5 ;   MEF=MONTH(GOZOU1DE)
    CASE OPX=5 ;   MEF=MONTH(COMPDATAI)
    CASE OPX=6 ;   MEF=MONTH(COMPABOI)
ENDCASE
IF OPX=1
   FORES_EA()
   DBCLOSEALL()
   RETU
ENDIF
IF OPX=2
   FORES_EB()
   DBCLOSEALL()
   RETU
ENDIF

IF ! NETUSE("FO_PFE") //AREDE("FO_PFE","FO_PFE",1)
   RETU
ENDIF
FILTRA='NUMERO=CTR'
SET FILTER TO &FILTRA

IF ! NETUSE("CONTAS") //AREDE("CONTAS","CONTAS",1)
   RETU
ENDIF
IF OPX=3
   FILTRO='PRFER=0'
   SET FILTER TO &FILTRO
ENDIF
IF OPX=5
   FILTRO='PRFCO=0'
   SET FILTER TO &FILTRO
ENDIF
DBSELECTAR("FO_FER")
DO CASE
    CASE OPX=3.OR.OPX=5 ;   FORES_EC()
    CASE OPX=4          ;   FORES_ED(0)
    CASE OPX=6          ;   FORES_ED(1)
ENDCASE
DBCLOSEALL()
RETU

*: FIM: FORES_EX.PRG
