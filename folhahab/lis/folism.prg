*:*****************************************************************************
*:
*:
*:     FOLISM.PRG: Listas anuais
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
*:      Copyright (c) 1999,  SOFTEC  S/C Ltda.
*:  Atualizado em: 19/01/1999
*:
*:*****************************************************************************
//////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

Set( _SET_MESSAGE, 24 , .T. )
WHILE .T.
   SETCOLOR("+W/BR,N/W")
   CLSROW(0)
   @ 00,00 SAY " <<FOLHA - LISTAS ANUAIS>> v.53b"
   CLSCOR()
   SETCOLOR("+W/BR,N/W")
   CLSROW(1)
   @ 01,01 SAY STR(NREMP)+" - "+MSG2
   IF VALTYPE(mMES)#"C"
      MMES=MMES(OP)
   ENDIF
   @ 01,60 SAY MMES+"/"+ANOWORK
   CLSCOR()
   CLSROW(2)
   HB_dispbox( 8,21, 10, 58,B_DOUBLE)
   SETCOLOR("W/N")
   @ 13,01 CLEA TO 19,77
   @ 09,27 SAY "M E N U   P R I N C I P A L"
   HB_dispbox(12,01, 20, 78,B_DOUBLE)   
   @ 13,06 SAY "≤≤≤≤≤≤≤   ≤≤≤≤≤   ≤≤≤≤     ≤≤  ≤≤     ≤≤"
   @ 14,06 SAY " ≤≤   ≤  ≤≤   ≤≤   ≤≤      ≤≤  ≤≤    ≤≤≤≤     €   € €ﬂﬂ ﬂ€ﬂ €ﬂ€ €ﬂﬂ"
   @ 15,06 SAY " ≤≤   ≤  ≤≤   ≤≤   ≤≤      ≤≤  ≤≤   ≤≤  ≤≤    €   € ﬂﬂ€  €  €ﬂ€ ﬂﬂ€"
   @ 16,06 SAY "≤≤≤≤     ≤≤   ≤≤   ≤≤      ≤≤≤≤≤≤   ≤≤  ≤≤    ﬂﬂﬂ ﬂ ﬂﬂﬂ  ﬂ  ﬂ ﬂ ﬂﬂﬂ "
   @ 17,06 SAY " ≤≤ ≤    ≤≤   ≤≤   ≤≤  ≤   ≤≤  ≤≤   ≤≤≤≤≤≤    €ﬂ€ €‹ € € € €ﬂ€ € €ﬂﬂ"
   @ 18,06 SAY " ≤≤      ≤≤   ≤≤   ≤≤  ≤≤  ≤≤  ≤≤   ≤≤  ≤≤    €ﬂ€ € ﬂ€ € € €ﬂ€ € ﬂﬂ€"
   @ 19,06 SAY "≤≤≤≤      ≤≤≤≤≤   ≤≤≤≤≤≤≤  ≤≤  ≤≤   ≤≤  ≤≤    ﬂ ﬂ ﬂ  ﬂ ﬂﬂﬂ ﬂ ﬂ ﬂ ﬂﬂﬂ"
   SETCOLOR("+W/BR, N/W")
   @ 02,02 PROM "  ACUMULAR  " MESS "  Acumula Folhas Anuais,Sal.Variavel 13ß,Rais,Infome e Dirf  "
   @ 02,16 PROM "  CALCULOS  " MESS "  C†lculos e Transferencias do 13o. Salario  "
   @ 02,30 PROM "  IMPRIMIR  " MESS "  Planilhas, F.Financeira, Rais, Dirf Informe "
   @ 02,54 PROM "  REVISAO DADOS " MESS "  Revisar Acumulo de Dados / Arquivos Trabalho "
   @ 02,72 PROM " SAIR " MESS "  Abandonar o sistema  "
   MENU TO CHOICE
   DO CASE
       CASE CHOICE =1 ; FOLIS_A()
       CASE CHOICE =2 ; FOLIS_B()
       CASE CHOICE =3 ; FOLIS_C()
       CASE CHOICE =4 ; FOLIS_D()
       OTHERWISE ; SETCOLOR("W/N,N/W") ; RETU
   ENDCASE
ENDDO
*: FIM: FOLISM.PRG
