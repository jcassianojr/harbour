*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_17.prg
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
*+    Documentado em 15-Out-2026 as 10:21 am
*+
*+
*+
*+--------------------------------------------------------------------
*+


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fopto_17()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION fopto_17()


CABE2('FOPTO_17 - Criando Arquivo de Reserva')

ntipo := PEGRELOGIO()

ARQREL := TARQREL(nTIPO,.F.,"D")
cDD    := TARQREL(nTIPO,.F.)
DCORTE := ZDATAINI
DCORTF := ZDATAFIM
MDS('Informe o Periodo')
@ 24,40 GET DCORTE         
@ 24,50 GET DCORTF         
IF !READCUR()
   RETU .F.
ENDIF

FO21CRI(cDD,"FO_DIO","STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)")

IF !NETUSE(ARQrel,,,,,.F.,)
   RETU
ENDIF
IF !netuse(Cdd)
   dbCloseAll()
   RETU .F.
ENDIF

dbSelectAr(ARQREL)
initvars()
GRAPP := 1
GRAPT := LastRec()
GRAPT('AGUARDE ATUALIZANDO DADOS ')
dbGoTop()
WHILE !Eof()
   equvars()
   @ 24,00 SAY NUMERO         
   @ 24,10 SAY DATA           
   @ 24,20 SAY HORA           
   dbSelectAr(cDD)
   dbGoTop()
   IF !dbSeek(Str(mNUMERO,8)+DToS(mDATA)+Str(mHORA,7,2))
      netrecapp()
      REPLVARS()
   ENDIF
   dbSelectAr(ARQREL)
   GRAPS()
   dbSkip()
ENDDO
dbCloseAll()
RETU .T.



*+ EOF: fopto_17.prg
*+
