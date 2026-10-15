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
*+    Documentado em 15-Out-2026 as 10:57 am
*+
*+
*+
*+--------------------------------------------------------------------
*+


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fores_a3()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION fores_a3()


CABE2('Revisar Remanejamento de F‚rias.')
CTR     := PAGO := PAGO2 := PAGO3 := 0
DADATAX := Date()

IF !NETUSE("FO_FER")  // AREDE("FO_FER","FO_FER",0)
   RETU
ENDIF
FI     := IF(MDG('Deseja Revisar Periodos ja baixados'),'','BAIXADO="N"')
FILTRO := FILTRO(FI)
SET FILTER TO &FILTRO
dbGoTop()
WHILE !Eof()
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
      REC := RecNo()
      MDS('Digite o n£mero do funcion rio')
      @ 24,40 GET CTR PICT '######'        
      READCUR()
      MDS('Digite o p‚riodo aquisitivo')
      @ 24,40 GET DADATAX         
      READCUR()
      CTRA := (((((CTR * 10000)+Year(DADATAX)) * 100)+Month(DADATAX)) * 100)+Day(DADATAX)
      dbGoTop()
      IF !dbSeek(CTRA)
         MDT('Per¡odo n„o encontrado')
         dbGoto(REC)
      ENDIF
   CASE OPCAO = 5
      DATAI := DATFERIAS
      DATAF := DATFERIASF
      CTR   := NUMERO
      IF !NETUSE(PES)   // AREDE(PES,PES,0)
         RETU
      ENDIF
      dbGoTop()
      IF !dbSeek(CTR)
         dbCloseArea()
         MDT("Nao Encontrei o Cadastro do funcionario")
         LOOP
      ENDIF
      VAR1 := SALH := SALM := 0
      SALHM(MES)
      IF !NETUSE("CONTAS")  // AREDE("CONTAS","CONTAS",0)
         RETU
      ENDIF
      IF !netuse("FO_VAR")  // AREDE("FO_VAR","FO_VAR",0)
         RETU
      ENDIF
      MDS('Confirme Periodo de Acumula‡„o')
      @ 24,40 GET DATAI         
      @ 24,50 GET DATAF         
      READCUR()
      VAR := FORES_CY(DATAI,DATAF,'FERIAS=0','Ferias')
      dbSelectAr(PES)
      dbCloseArea()
      dbSelectAr("CONTAS")
      dbCloseArea()
      dbSelectAr("FO_VAR")
      dbCloseArea()
      dbSelectAr("FO_FER")
      NETRECLOCK()
      FO_FER->SALVAR := VAR
      dbUnlock()
   CASE OPCAO = 6
      IF MDG("Voce tem certeza")
         netrecdel()
         dbSkip()
      ENDIF
   OTHERWISE
      dbCloseAll()
      RETU
   ENDCASE
ENDDO

RETURN


*+ EOF: fores_a3.prg
*+
