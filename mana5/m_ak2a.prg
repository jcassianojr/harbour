*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ak2a.prg
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

MDI(" Ý Checar Classifica‡Æo Nota Fiscal")
PARA cTIPO,cARQ,cARQ2
IF VALTYPE(cTIPO) # "C"
   cTIPO := "E"
ENDIF
IF VALTYPE(cARQ) # "C"
   IF cTIPO = "E"
      aRETU := PEGMES({"K2","K6"},.T.,{"MK02","MK06"})
   ELSE
      aRETU := PEGMES({"M2","M6"},.T.,{"MM02","MK06"})
   ENDIF
   cARQ  := aRETU[5,1]
   cARQ2 := aRETU[5,2]
ENDIF
IF !USEMULT({{cARQ,1,0},{cARQ2,1,0}})
   RETU .F.
ENDIF
DBSELECTAR(cARQ)
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
IF cTIPO = "E"
   ordDestroy("temp")
   ordcreate(,"temp","str(NRNOTA,8)+str(FORNECEDO,5)+str(ITEM,5)")
   ordSetFocus("temp")
ELSE
   ordDestroy("temp")
   ordcreate(,"temp","str(NUMERO,8)+str(FORNECEDO,5)+str(SEQ,5)")
   ordSetFocus("temp")
ENDIF
DBSELECTAR(cARQ)
DBGOTOP()
WHILE !EOF()
   @ 24,00 SAY RECNO()         
   IF TIPOENT $ "MCORBS" .AND. (EMPTY(CLASSIPI) .OR. IF(cTIPO = "S",.F.,EMPTY(CODDEP)))
      mCODIGO   := ALLTRIM(CODIGO)
      mTIPOENT  := TIPOENT
      mIPI      := 0
      mCODIPI   := ""
      mCLASSIPI := ""
      mCODDEP   := ""
      @ 24,10 SAY mCODIGO         
      PEGACAMPO(ESTQARQ(mTIPOENT,1),"mCODIGO",{"CODIPI","IPI","CLASSIPI","CTACONTB"},{"mCODIPI","mIPI","mCLASSIPI","mCODDEP"})
      IF !EMPTY(mCODIPI)
         CHECKCIPI(mCODIPI,"mIPI","mCLASSIPI")
      ENDIF
      IF !EMPTY(mCLASSIPI) .AND. EMPTY(CLASSIPI)
         netgrvcam("CLASSIPI",mCLASSIPI)
      ENDIF
      IF !EMPTY(mCODDEP) .AND. IF(cTIPO = "S",.F.,EMPTY(CODDEP))
         netgrvcam("CODDEP",mCODDEP)
      ENDIF
   ENDIF
   DBSELECTAR(cARQ)
   DBSKIP()
ENDDO
DBSELECTAR(cARQ2)
DBGOTOP()
WHILE !EOF()
   @ 24,00 SAY RECNO()         
   mDCLASSIPI := ""
   IF EMPTY(DCLASSIPI)
      mCHAVE    := str(NUMERO,8)+str(FORNECEDO,5)+str(ITEM,5)
      nDVALORNF := DVALORNF
      DBSELECTAR(cARQ)
      DBGOTOP()
      IF DBSEEK(mCHAVE)
         IF nDVALORNF = VALORTOT  //Checa Troca de Itens pelo valor
            mDCLASSIPI := CLASSIPI
         ENDIF
      ENDIF
   ENDIF
   DBSELECTAR(cARQ2)
   IF !EMPTY(mDCLASSIPI)
      NETGRVCAM("DCLASSIPI",mDCLASSIPI)
   ENDIF
   DBSKIP()
ENDDO
DBSELECTAR(cARQ)
DBCLOSEAREA()
DBSELECTAR(cARQ2)
DBCLOSEAREA()

