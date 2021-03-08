*:*****************************************************************************
*:
*:       FOG6.PRG: DADOS HORARIO TRABALHO
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     12:02
*:
*:  Procs & Fncts: FOG6()
*:
*:          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
*:
*:     Arq. Dados: FO_HOR
*:               : HORPAD
*:
*:         Indice: HORPAD     NOME DO HORARIO
*:                            NOME
*:
*:     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
*:*****************************************************************************



CABEX('Alterando Hor rio de Trabalho')
IF ! netuse(pes) //AREDE(PES,PES,0)
   RETU
ENDIF
FILTRO='DAY(DEMITIDO)=0'
SET FILTER TO &FILTRO

IF ! netuse("fo_hor") //AREDE("FO_HOR","FO_HOR",0)
   RETU
ENDIF
DBGOTOP()

IF ! netuse("HORPAD") //AREDE("HORPAD","HORPAD",0)
   RETU
ENDIF

NUME=0
WHILE .T.
   @ 08,00 SAY "+------------------------------------------------------------------------------+"
   @ 09,00 SAY "Ý"+SPAC(78)+"Ý"
   @ 10,00 SAY "Ý N£mero:         Nome :"+SPAC(55)+"Ý"
   @ 11,00 SAY "Ý ---------------------------------------------------------------------------- Ý"
   @ 12,00 SAY "Ý"+SPAC(78)+"Ý"
   @ 13,00 SAY "Ý Segunda :"+SPAC(68)+"Ý"
   @ 14,00 SAY "Ý Ter‡a   :"+SPAC(68)+"Ý"
   @ 15,00 SAY "Ý Quarta  :"+SPAC(68)+"Ý"
   @ 16,00 SAY "Ý Quinta  :"+SPAC(68)+"Ý"
   @ 17,00 SAY "Ý Sexta   :"+SPAC(68)+"Ý"
   @ 18,00 SAY "Ý S bado  :"+SPAC(68)+"Ý"
   @ 19,00 SAY "Ý Domingo :"+SPAC(68)+"Ý"
   @ 20,00 SAY "Ý"+SPAC(78)+"Ý"
   @ 21,00 SAY "+------------------------------------------------------------------------------+"
   MDS('DIGITE O NUMERO DO FUNCIONARIO')
   @ 24,40 GET NUME PICT '######'
   READCUR()
   DBSELECTAR("FO_HOR")
   DBGOTOP()
   if ! dbSEEK(NUME)
      DBSELECTAR(PES)
      DBGOTOP()
      if dbSEEK(NUME)
         NUM=NUMERO
         NOM=NOME
         DBSELECTAR("FO_HOR")
         NETRECAPP()
         FIELD->NUMERO:=NUM
         FIELD->NOME  :=NOM
      ELSE
         MDT('FUNCIONARIO NAO ENCONTRADO')
         EXIT
      ENDIF
   ENDIF
   IF MDG('Alterar por hor rio Padr„o')
      BUSCA=SPAC(6)
      MDS('Qual Hor rio Padr„o')
      @ 24,30 GET BUSCA
      READCUR()
      DBSELECTAR("HORPAD")
      DBGOTOP()
      if dbSEEK(BUSCA)
         DR1=D1
         DR2=D2
         DR3=D3
         DR4=D4
         DR5=D5
         DR6=D6
         DR7=D7
         DBSELECTAR("FO_HOR")
         NETRECLOCK()
         FIELD->D1:=DR1
         FIELD->D2:=DR2
         FIELD->D3:=DR3
         FIELD->D4:=DR4
         FIELD->D5:=DR5
         FIELD->D6:=DR6
         FIELD->D7:=DR7
         DBUNLOCK()
      ENDIF
   ENDIF
   DBSELECTAR("FO_HOR")
   NETRECLOCK()
   @ 10,10 SAY NUMERO
   @ 10,25 SAY NOME
   @ 13,12 GET D1
   @ 14,12 GET D2
   @ 15,12 GET D3
   @ 16,12 GET D4
   @ 17,12 GET D5
   @ 18,12 GET D6
   @ 19,12 GET D7
   READCUR()
   DBUNLOCK()
   IF ! MDG ('Deseja Continuar')
      EXIT
   ENDIF
ENDDO
DBCLOSEALL()
RETU
*: FIM: FOG6.PRG
