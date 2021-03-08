*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ai4.prg
*+
*+
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2010, Jorge Cassiano
*+
*+
*+
*+    Documentado em 30-Ago-2011 as 10:55 am
*+
*+
*+
*+--------------------------------------------------------------------
*+


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_ai4()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_ai4

PARA nREG

DO CASE
   CASE nREG = 1
      aRETU := PEGMES({"K3"},.T.,{"MK03"})
   CASE nREG = 2
      aRETU := PEGMES({"K4"},.T.,{"MK04"})
   CASE nREG = 3
      aRETU := PEGMES({"K5"},.T.,{"MK05"})
   otherwise 
      RETU
ENDCASE

nMES  := aRETU[1]
nANO  := aRETU[2]
cARQ1 := aRETU[5,1]


DO CASE
   CASE nREG = 1
      xMES := "SAL"+STRZERO(nMES,2)
   CASE nREG = 2
      xMES := "SAS"+STRZERO(nMES,2)
   CASE nREG = 3
      xMES := "SAO"+STRZERO(nMES,2)
ENDCASE

IF !USEMULT({{cARQ1,1,2},{"MI01",1,1}})
   RETU .F.
ENDIF
DBSELECTAR(cARQ1)
DBGOTOP()
DBSEEK(STR(nANO,4)+STR(nMES,2))
WHILE nMES = MES .AND. nANO = ANO .AND. !EOF()
   xCONTA  := CONTA
   mTOTCTA := 0
   WHILE xCONTA = CONTA .AND. !EOF()
      mTOTCTA += VALORMES
      DBSKIP()
   ENDDO
   DBSELECTAR("MI01")
   DBGOTOP()
   IF DBSEEK(xCONTA)
      netgrvcam(xMES,mTOTCTA)
   ENDIF
   DBSELECTAR(cARQ1)
ENDDO

DBSELECTAR("MI01")
DBGOTOP()
WHILE !EOF()
   IF IDENTIFICA = 'S'
      xCONTA := ALLTRIM(CONTA)
      xVALOR := 0
      xREC   := RECNO()
      WHILE ALLTRIM(CONTA) = xCONTA .AND. !EOF()
         IF xCONTA != CONTA
            xVALOR += &xMES
         ENDIF
         DBSKIP()
      ENDDO
      DBGOTO(xREC)
      netgrvcam(xMES,xVALOR)
   ENDIF
   DBSKIP()
ENDDO
RETU
