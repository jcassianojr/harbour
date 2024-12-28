*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fores_a3.prg
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
*+    Documentado em 27-Dez-2024 as  9:41 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :  FORES_A4.PRG : Revisar Remanejamento de F‚rias.
// :     Linguagem : Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/26/94      8:57
// :
// :  Procs & Fncts: FORES_A3()
// :
// :          Chama: CABE2()            (fun‡„o    em FORESP.PRG)
// :               : PETELA()           (fun‡„o    em FORESP.PRG)
// :               : FORESRT()          (fun‡„o    em FORESRT.PRG)
// :               : FORESRS()          (fun‡„o    em FORESRS.PRG)
// :               : FORESRG()          (fun‡„o    em FORESRG.PRG)
// :               : SALHM()            (fun‡„o    em FORESP.PRG)
// :               : FORES_CY()         (fun‡„o    em FORESP.PRG)
// :
// :    Arq. Dados : FO_FER - Remanejamento de Ferias
// :                 CONTAS - Cadastro de Vencimentos e Descontos
// :                 FO_VAR - Acumulativo de Vari veis
// :
// :       Indices : FER     Codigo do Funcionario
// :                         CONTROLE
// :                 CONTA   Por ordem de c¢digo
// :                         CODIGO
// :
// :     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
// :*****************************************************************************


CABE2('Revisar Remanejamento de F‚rias.')
CTR     := PAGO := PAGO2 := PAGO3 := 0
DADATAX := DATE()

IF !NETUSE("FO_FER")  //AREDE("FO_FER","FO_FER",0)
   RETU
ENDIF
FI     := IF(MDG('Deseja Revisar Periodos ja baixados'),'','BAIXADO="N"')
FILTRO := FILTRO(FI)
SET FILTER TO &FILTRO
DBGOTOP()
WHILE !EOF()
   PETELA(8)
   FORESRT()
   FORESRS()
   MD()
   @ 24,02 PROM 'P>r¢ximo '
   @ 24,12 PROM 'R>etorna '
   @ 24,22 PROM 'A>ltera  '
   @ 24,32 PROM 'B>usca   '
   @ 24,42 PROM 'V>ariavel'
   @ 24,60 PROM 'D>eletar'
   @ 24,71 PROM 'S>a¡da'
   MENU TO OPCAO
   DO CASE
   CASE OPCAO = 1 
      NEXTREC()
   CASE OPCAO = 2 
      PREVREC()
   CASE OPCAO = 3 
      FORESRG()
   CASE OPCAO = 4
      REC := RECNO()
      MDS('Digite o n£mero do funcion rio')
      @ 24,40 GET CTR PICT '######'        
      READCUR()
      MDS('Digite o p‚riodo aquisitivo')
      @ 24,40 GET DADATAX         
      READCUR()
      CTRA := (((((CTR * 10000)+YEAR(DADATAX)) * 100)+MONTH(DADATAX)) * 100)+DAY(DADATAX)
      DBGOTOP()
      IF !DBSEEK(CTRA)
         MDT('Per¡odo n„o encontrado')
         DBGOTO(REC)
      ENDIF
   CASE OPCAO = 5
      DATAI := DATFERIAS
      DATAF := DATFERIASF
      CTR   := NUMERO
      IF !NETUSE(PES)   //AREDE(PES,PES,0)
         RETU
      ENDIF
      DBGOTOP()
      IF !DBSEEK(CTR)
         DBCLOSEAREA()
         MDT("Nao Encontrei o Cadastro do funcionario")
         LOOP
      ENDIF
      VAR1 := SALH := SALM := 0
      SALHM(MES)
      IF !NETUSE("CONTAS")  //AREDE("CONTAS","CONTAS",0)
         RETU
      ENDIF
      IF !netuse("FO_VAR")  //AREDE("FO_VAR","FO_VAR",0)
         RETU
      ENDIF
      MDS('Confirme Periodo de Acumula‡„o')
      @ 24,40 GET DATAI         
      @ 24,50 GET DATAF         
      READCUR()
      VAR := FORES_CY(DATAI,DATAF,'FERIAS=0','Ferias')
      DBSELECTAR(PES)
      DBCLOSEAREA()
      DBSELECTAR("CONTAS")
      DBCLOSEAREA()
      DBSELECTAR("FO_VAR")
      DBCLOSEAREA()
      DBSELECTAR("FO_FER")
      NETRECLOCK()
      FO_FER->SALVAR := VAR
      DBUNLOCK()
   CASE OPCAO = 6
      IF MDG("Voce tem certeza")
         netrecdel()
         DBSKIP()
      ENDIF
   OTHERWISE
      DBCLOSEALL()
      RETU
   ENDCASE
ENDDO
RETU
// : FIM: FORES_A3.PRG

*+ EOF: fores_a3.prg
*+
