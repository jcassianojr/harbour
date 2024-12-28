*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_18.prg
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
*+    Documentado em 27-Dez-2024 as  9:32 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+


CABE2('FOPTO_18 - Criando Arquivo TXT Com Base Arquivo Reserva')

ntipo := PEGRELOGIO()

cDD := TARQREL(nTIPO,.F.)

if !REDEFILE(cDD,"DBF",.T.)
   retu .F.
endif

TIPC := pegarqcon(nTIPO,"PRO")

FO21CRI(cDD,"FO_DIO","STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)")

if !NETUSE(cDD)
   retu .F.
endif
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
cTXT += ".TXT"
if TIPC = "S"
   COPY to &cTXT. SDF while zei_fort(nLASTREC,,,1)
endif
if TIPC = "D"
   COPY to &cTXT. DELI while zei_fort(nLASTREC,,,1)
endif
dbcloseall()


*+ EOF: fopto_18.prg
*+
