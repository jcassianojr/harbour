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
*+    Documentado em 15-Out-2026 as 10:22 am
*+
*+
*+
*+--------------------------------------------------------------------
*+

#include "BOX.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function foptom()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION foptom()


COMPETE := MMES+"/"+Str(Year(DXDIA),4)

imphp()

WHILE .T.
   HELPDBF := "FOPTO"
   ZDATA   := DXDIA
   SetColor("+W/BR,N/W")
   CLSROW(0)
   @ 00,01 SAY COMPETE+" - "+Str(NREMP,4)+" - "+AllTrim(ZEMPRESA)         
   CLSCOR()
   CLSROW(1)
   @ 09,27 SAY "M E N U   P R I N C I P A L"         
   hb_DispBox(12,1,20,78,B_DOUBLE+" ")
   @ 13,06 SAY "ннннннн   ннннн   нннн     нн  нн     нн"                                   
   @ 14,06 SAY " нн   н  нн   нн   нн      нн  нн    нннн     нюн нюн н_ н юню нюн"         
   @ 15,06 SAY " нн   н  нн   нн   нн      нн  нн   нн  нн    нюю н н н юн  н  н н"         
   @ 16,06 SAY "нннн     нн   нн   нн      нннннн   нн  нн    ю   ююю ю  ю  ю  ююю"         
   @ 17,06 SAY " нн н    нн   нн   нн  н   нн  нн   нннннн"                                 
   @ 18,06 SAY " нн      нн   нн   нн  нн  нн  нн   нн  нн"                                 
   @ 19,06 SAY "нннн      ннннн   ннннннн  нн  нн   нн  нн"                                 
   SetColor("+W/BR, N/W")
   OPCAO(01,00," &RelЂgio ",82,"  Dados do RelЂgio   ")
   OPCAO(01,10," &Ponto ",80,"  Dados do Pontor  ")
   OPCAO(01,18," re&LatЂrio ",76,"  Listas os RelatЂrios  ")
   OPCAO(01,30," &Cadastro ",67,"  Cadastros do Sistema")
   OPCAO(01,41," &Horario ",72,"  Horarios ")
   OPCAO(01,51," &BancoHoras ",66," Banco de Horas ")
   OPCAO(01,64," &Manual ",77,"  Ajuda do Sistema ")
   OPCAO(01,73," &Sair ",83,"  Sai deste Menu  ")
   OPCAO := MENU(2,2)
   SetColor("+W/BR")
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

RETURN



*+ EOF: foptom.prg
*+
