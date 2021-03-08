*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_aor.prg
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
*+    Function m_aor()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_aor

PARA ARQWORK

PADRAX(0,,0,{ARQWORK},"Produto"+spac(18)+"OS"+spac(7)+"T Quantidde  Requisicao",;
 "' '+mCODIGO+' '+STR(mOS,  8, 2)+' '+mTIPO+' '+STR(mQTDDE, 10, 3)+' '+STR(mREQUISI,  8)","MAOR01","MAOR01",,;
 ,{|| MAOR01()},,"MAOR",,,,,,)
RETU .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOR01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAOR01

IF (ARQWORK == "OR01" .OR. ARQWORK == "OR02" .OR. ARQWORK == "OR03") .AND. mQTDEBAI > 0 .AND. !EMPTY(mNRNOTA) .AND. !EMPTY(mBAIXA)
   xOLDQTDDE := mQTDDE
   mQTDDE    := mQTDEBAI
   IF NOVOREG(ARQWORK+"BX",mCODIGO+STR(mOS,8,2)+STR(mNRNOTA,5)+STR(mSEQ,3))
      mQTDDE   := xOLDQTDDE - mQTDEBAI
      mNRNOTA  := 0
      mSEQ     := 0
      mBAIXA   := CTOD(SPACE(8))
      mQTDEBAI := 0
      IF mQTDDE > 0
         REPORVARS(ARQWORK,mCODIGO+STR(mOS,8,2)+STR(mREQUISI,8))
         aPAX1[ POSPAX ] := ' '+mCODIGO+' '+STR(mOS,8,2)+' '+mTIPO+' '+STR(mQTDDE,10,3)+' '+STR(mREQUISI,8)
      ELSE
         APAGAREG(ARQWORK,mCODIGO+STR(mOS,8,2)+STR(mREQUISI,8),.F.,.F.)
         aPAX1[ POSPAX ] := "Baixado Integralmente"
         aPAX2[ POSPAX ] := ""
      ENDIF
   ENDIF
ENDIF


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function TIPORR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC TIPORR(cTIP,nUSO)

LOCAL cRET := "XXXX"
DO CASE
   CASE cTIP = "P" 
      cRET := IF(nUSO = 1,"OR01","OR12")
   CASE cTIP = "M" 
      cRET := IF(nUSO = 1,"OR02","OR04")
   CASE cTIP = "C" 
      cRET := IF(nUSO = 1,"OR03","OR05")
   CASE cTIP = "E" 
      cRET := IF(nUSO = 1,"OR06","OR09")
   CASE cTIP = "H" 
      cRET := IF(nUSO = 1,"OR07","OR10")
   CASE cTIP = "T" 
      cRET := IF(nUSO = 1,"OR08","OR11")
   CASE cTIP = "O" 
      cRET := IF(nUSO = 1,"OR15","OR16")
   CASE cTIP = "S" 
      cRET := IF(nUSO = 1,"OR17","OR18")
ENDCASE
RETU cRET
