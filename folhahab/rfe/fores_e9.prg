*:*****************************************************************************
*:
*:   FORES_E9.PRG: Imprimir Resumo de Rescis„o Contratual
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
*:          Autor: Equipe Disk
*:      Copyright (c) 1999,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/03/99
*:
*:*****************************************************************************

////#INCLUDE "COMANDO.CH"

function fores_e9
PARA CC
IF ! MDL('Imprimir Resumo de Rescis„o Contratual',0)
   RETU
ENDIF
CTR:=VEN:=DES:=salh:=salm:=var1:=0

MDS('Digite o n£mero do funcion rio')
@ 24,40 GET CTR PICT '######'
IF ! READCUR()
   RETU .F.
ENDIF


IF ! NETUSE(PES) 
   RETU
ENDIF
IF ! NETUSE("FIRMA") 
   DBCLOSEALL()
   RETU
ENDIF
IF ! NETUSE("BCOFGTS") 
   DBCLOSEALL()
   RETU
ENDIF
IF ! NETUSE("FO_RSS") 
   DBCLOSEALL()
   RETU
ENDIF
IF ! NETUSE("CONTAS") 
   DBCLOSEALL()
   RETU
ENDIF
DBSELECTAR(PES)
DBGOTOP()
IF ! DBSEEK(CTR)
   MDT('Funcionario nao Encontrado')
   DBCLOSEALL()
   RETU
ENDIF
MEF=MONTH(DEMITIDO)

xCAUSA:=OBTER("FO_RCAU","",MOTIVO,"NOME")
DBSELECTAR("FO_RSS")
xVAL1 =VALCTA(CTR,109)
xVAL1+=VALCTA(CTR,905)
IF xVAL1>0.AND.MDG("Experiencia Termino Contrato a Termo")
   xCAUSA='Termino de Contrato a Termo '
ENDIF
MDS("Confirme Motivo")
@ 24,20 GET xCAUSA
READCUR()


IMPRESSORA()
@ PROW()+1,0 SAY IMPSTR(cIMPEXP)+REPLIC ('-',80)
@ PROW()+1,20 SAY 'TERMO DE RESCISAO DO CONTRATO DE TRABALHO'
@ PROW()+2,0 SAY REPLIC ('-',80)
DBSELECTAR("FIRMA")
DBGOTOP()
IF DBSEEK(NREMP)
   @ PROW()+1,0 SAY 'Identificacao do Empregador:'
   @ PROW()+1,0 SAY RAZAO
   @ PROW()+1,0 SAY ENDERECO+' - '+BAIRRO+' - '+CIDADE+' - '+ESTADO+' - '+IMPSTR(cIMPCOM)+CEP+IMPSTR(cIMPEXP)
ENDIF
DBSELECTAR("BCOFGTS")
IF DBSEEK(NREMP)
   @ PROW()+1,0 SAY 'BCO:'+NOME+' AG:'+NOMEAGENC+' UF '+UF+' COD:'+AGENCIA
ENDIF
DBSELECTAR(PES)
@ PROW()+1,0 SAY REPLIC ('-',80)
@ PROW()+1,0 SAY 'Identificacao do Empregado:'
@ PROW()+1,0 SAY 'Nome: '+NOME+' CTPS: '+IF(left(TIRAOUT(CPF),7)=PROFIS,CPF,PROFIS+"-"+SERIE+"/"+CTPSUF)  //CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
@ PROW()+1,0 SAY 'Pis: '+PIS+' Num: '+STR(numero)+' Nascimento: '+DTOC(nasc)
@ PROW()+1,0 SAY 'Admissao: '+DTOC(admitido)+' FGTS: '+DTOC(FGTS)+' Aviso Previo: '+DTOC(avisoprev)+' Afastamento: '+DTOC(demitido)
SALHM(MEF)
@ PROW()+1,0 SAY 'Salario: '
@ PROW(),10 SAY VAR1 PICT  '###,###,###.##'
@ PROW(),25 SAY ' Causa de Afastamento: '+xCAUSA
@ PROW()+1,0 SAY REPLIC ('-',80)
@ PROW()+1,0 SAY 'Descriminacao das Verbas Pagas'
@ PROW()+1,0 SAY 'Conta Descriminacao'
@ PROW(),50 SAY 'Vencimentos'
@ PROW(),66 SAY 'Descontos'
DBSELECTAR("FO_RSS")
FILTRA='NUMERO=CTR.AND.(CONTA<400.OR.CONTA>501)'
SET FILTER TO &FILTRA
DBGOTOP()
WHILE ! EOF()
   CTA=CONTA
   DBSELECTAR("CONTAS")
   DBGOTOP()
   DBSEEK(CTA)
   IF FOUND()
      IF PRRES=0
         mCODIGO:=CODIGO
         mDESCR :=DESCR
         DBSELECTAR("FO_RSS")
         mVALOR=IF(CC=1,VALORMES1,VALORMES2)
         IF mVALOR>0
            @ PROW()+1,1 SAY mCODIGO
            @ PROW()  ,6 SAY mDESCR
            IF HORAS#0
               @ PROW(),42 SAY HORAS PICT '###.##'
            ENDIF
            IF CONTA>501.OR.(CONTA>40.AND.CONTA<50)
               @ PROW(),62 SAY mVALOR PICT '###,###,###.##'
               DES+=mVALOR
            ELSE
               @ PROW(),48 SAY mVALOR PICT '###,###,###.##'
               VEN+=mVALOR
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   DBSELECTAR("FO_RSS")
   DBSKIP()
ENDDO

@ PROW()+1, 0 SAY 'Conta Descriminacao'
@ PROW()  ,66 SAY 'Informativas'



DBSELECTAR("FO_RSS")
FILTRA='NUMERO=CTR'
SET FILTER TO &FILTRA
DBGOTOP()
WHILE ! EOF()
   CTA=CONTA
   IF CONTA>445.AND.CONTA<450
      DBSELECTAR("CONTAS")
      DBGOTOP()
      DBSEEK(CTA)
      IF FOUND()
         IF PRRES=0
            mCODIGO:=CODIGO
            mDESCR :=DESCR
            DBSELECTAR("FO_RSS")
            mVALOR=IF(CC=1,VALORMES1,VALORMES2)
            IF mVALOR>0
               @ PROW()+1,1 SAY mCODIGO
               @ PROW()  ,6 SAY mDESCR
               IF HORAS#0
                  @ PROW(),42 SAY HORAS PICT '###.##'
               ENDIF
               @ PROW(),62 SAY mVALOR PICT '###,###,###.##'
           ENDIF
         ENDIF
      ENDIF
   ENDIF
   DBSELECTAR("FO_RSS")
   DBSKIP()
ENDDO

@ PROW()+1,0 SAY REPLIC ('-',80)
@ PROW()+1,6 SAY 'Totais'
@ PROW(),48 SAY VEN PICT '###,###,###.##'
@ PROW(),62 SAY DES PICT '###,###,###.##'
@ PROW()+1,6 SAY 'Liquido a Receber'
@ PROW(),48 SAY VEN-DES PICT '###,###,###.##'
@ PROW()+1,0 SAY REPLIC ('-',80)
@ PROW()+1,0 SAY 'Data da Homologacao'
@ PROW(),40 SAY 'Empregador'
@ PROW()+1,0 SAY REPLIC ('-',80)
@ PROW()+1,0 SAY 'Empregado'
@ PROW(),40 SAY 'Responsavel'
@ PROW()+1,0 SAY REPLIC ('-',80)
IMPFOL()
VIDEO()
DBCLOSEALL()
IMPEND()
RETU

*: FIM: FORES_E9.PRG
