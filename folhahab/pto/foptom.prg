*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foptom.prg
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
*+    Documentado em 27-Dez-2024 as  9:34 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :    FOPTOM.PRG: Menu Principal
// :     Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
// :
// :*****************************************************************************

////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

COMPETE := MMES+"/"+STR(YEAR(DXDIA),4)

imphp()

WHILE .T.
   HELPDBF := "FOPTO"
   ZDATA   := DXDIA
   SETCOLOR("+W/BR,N/W")
   CLSROW(0)
   @ 00,01 SAY COMPETE+" - "+str(NREMP,4)+" - "+ALLTRIM(ZEMPRESA)         
   CLSCOR()
   CLSROW(1)
   @ 09,27 SAY "M E N U   P R I N C I P A L"         
   HB_DISPBOX(12,1,20,78,B_DOUBLE+" ")
   @ 13,06 SAY "ннннннн   ннннн   нннн     нн  нн     нн"                                   
   @ 14,06 SAY " нн   н  нн   нн   нн      нн  нн    нннн     нюн нюн н_ н юню нюн"         
   @ 15,06 SAY " нн   н  нн   нн   нн      нн  нн   нн  нн    нюю н н н юн  н  н н"         
   @ 16,06 SAY "нннн     нн   нн   нн      нннннн   нн  нн    ю   ююю ю  ю  ю  ююю"         
   @ 17,06 SAY " нн н    нн   нн   нн  н   нн  нн   нннннн"                                 
   @ 18,06 SAY " нн      нн   нн   нн  нн  нн  нн   нн  нн"                                 
   @ 19,06 SAY "нннн      ннннн   ннннннн  нн  нн   нн  нн"                                 
   SETCOLOR("+W/BR, N/W")
   OPCAO(01,00," &RelЂgio ",82,"  Dados do RelЂgio   ")
   OPCAO(01,10," &Ponto ",80,"  Dados do Pontor  ")
   OPCAO(01,18," re&LatЂrio ",76,"  Listas os RelatЂrios  ")
   OPCAO(01,30," &Cadastro ",67,"  Cadastros do Sistema")
   OPCAO(01,41," &Horario ",72,"  Horarios ")
   OPCAO(01,51," &BancoHoras ",66," Banco de Horas ")
   OPCAO(01,64," &Manual ",77,"  Ajuda do Sistema ")
   OPCAO(01,73," &Sair ",83,"  Sai deste Menu  ")
   OPCAO := MENU(2,2)
   SETCOLOR("+W/BR")
   DO CASE
   CASE OPCAO = 1 
      FOPTO_1()
   CASE OPCAO = 2 
      FOPTO_2()
   CASE OPCAO = 3 
      FOPTO_3()
   CASE OPCAO = 4 
      FOPTO_4()
   CASE OPCAO = 5 
      FOPTO_5()
   CASE OPCAO = 6 
      FOPTO_6()
   CASE OPCAO = 7 
      FOX()
   OTHERWISE 
      RETU
   ENDCASE
ENDDO

// : FIM: FOPTOM.PRG

*+ EOF: foptom.prg
*+
