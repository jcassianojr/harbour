*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_dk.prg
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
*+    Function m_dk()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_dk

para aARQ
if valtype(aARQ) = "U"
   aARQ := ESCOLHEXI("MANFEC","","' '+ARQORI+' '+STRDES+' '+OBTER('MANARQ',ARQORI,'DESCRICAO')","ARQORI")
endif
if valtype(aARQ) = "C"
   aARQ := {aARQ}
endif
CRIARVARS("MANFEC")
for X := 1 to len(aARQ)
   if !IGUALVARS("MANFEC",aARQ[X])
      retu .F.
   endif
   //ALERTX(mSTRANO)
   //ALERTX(mSTRDES)
   //ALERTX(mSTRATU)
   //ALERTX(mSTRBAI)
   if empty(mCAMDAT)
      mCAMDAT := "PADRAO"
   endif
   if empty(mCAMDA2)
      mCAMDA2 := "PADRAO"
   endif
   SOMAANO(mSTRANO,mSTRDES,,,mSTRATU,mCAMDAT,mSTRBAI,mCAMDA2,,)
next X
release all like m *  //LIMPAVARS(wARQ)

//SOMAANO( cARQSOM, cSTRREF, cVARSOM, bSOMA, cATU, eDAT, cBAI, eDA2, aPER ,bUSE)


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FECRETBAI()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC FECRETBAI(cORI,cBAI)

MDI("Retorno de Baixa")
PRIV aIND,eCHAVE,nTIPO
nTIPO := 0
IF cORI = "MR03" .OR. cORI = "MS04" .OR. cORI = "MS07"
   nTIPO := 1
ENDIF
IF cORI = "MU03" .OR. cORI = "MQ03" .OR. cORI = "MT03"
   nTIPO := 1
ENDIF
IF !CONFIND(cORI)
   RETU .F.
ENDIF
CRIARVARS(cORI)
WHILE .T.
   eCHAVE := PEGBUS(cORI,1)
   ALERTX(eCHAVE)
   IF IGUALVARS(cBAI,eCHAVE)
      IF nTIPO = 1
         mDATASAI   := CTOD(SPAC(8))
         mNRNOTASAI := 0
         mTOTKGSAI  := 0
         mTOTKGEST  := mTOTKGANT
      ENDIF
      IF NOVOREG(cORI,eCHAVE)
         APAGAREG(cBAI,eCHAVE,.F.)
      ENDIF
   ENDIF
   IF !MDG("Continuar")
      EXIT
   ENDIF
ENDDO

