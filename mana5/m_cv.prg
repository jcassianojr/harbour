*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_cv.prg
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


MDI("Manutencao Especial de Arquivos")
FILMCV  := ""
FILMCV  := RFILORD(zARQ1,.F.)
aARQX   := {}
lFIXAR  := MDG("Fixar Arquivo")
lAPAGA  := MDG("Excluir Arquivos Fechados Inexistentes")
lFECMES := MDG("Fechamento Mensal")


IF lFECMES
   IF USEREDE("MANFEC",1,99)
      DBGOTOp()
      WHILE !EOF()
         IF FECHAAUTO = "S"
            IF EMPTY(OPER04)
               ALERTX(ARQORI)
            ELSE
               AADD(aARQX,ALLTRIM(OPER04))
            ENDIF
         ENDIF
         DBSKIP()
      ENDDO
      DBCLOSEAREA()
      nARQ := LEN(aARQX)
      FOR N := 1 TO nARQ
         cVAR := aARQX[N]
         cVAR := &("{||"+cVAR+"}")
         eval(cVAR)
      NEXT N
   ENDIF
ENDIF

if lFIXAR .or. lAPAGA
   if !USECHK(ZDIRC+"MANARQ",ZDIRC+"MANARQ",.T.)
      dbcloseall()
      retu .F.
   endif
   set filter to &FILMCV.
   if !USECHK(ZDIRC+"MANARQ1",ZDIRC+"MANARQ",.T.)
      dbcloseall()
      retu .F.
   endif

   dbselectar("MANARQ")
   nLASTREC := lastrec()
   nPOSREC  := 1
   dbgotop()
   while !eof()
      if at("CEP",CAMINHO) > 0 .or. ARQANO > 0 .or. PULAFIX = "S"   //Nao Inclui os CEPS Fechados
      else
         @ 24,00 say padr(ARQUIVO,80)         
         aadd(aARQX,alltrim(ARQUIVO))
      endif
      if ARQANO > 0
         cARQ := alltrim(caminho)+alltrim(ARQUIVO)+".DBF"
         if ! file(cARQ)
            @ 23,00 say cARQ         
            netrecdel()
            dbselectar("MANARQ1")
            dbgotop()
            while cARQ = alltrim(ARQUIVO) .and. !eof()
               netrecdel()
               dbskip()
            enddo
         endif
      endif
      dbselectar("MANARQ")
      dbskip()
      ZEI_FORT(nLASTREC,.T.,nPOSREC)
      nPOSREC ++
   enddo
   dbcloseall()

   if !lFIXAR
      retu
   endif

   nLASTREC := len(aARQX)
   for X := 1 to nLASTREC
      mARQUIVO := aARQX[X]
      @ 24,00 say padr(mARQUIVO,80)         
      if mARQUIVO # "MANARQ" .and. mARQUIVO # "MANARQ1"
         if USEREDE(mARQUIVO,0,99,,,300)
            pack
            dbclosearea()
         endif
      endif
      ZEI_FORT(nLASTREC,.F.,X)
   next
endif

if mdg("Apagar Duplicidades Configuracao Indexa‡Æo")
   if !USECHK(ZDIRC+"MANARQ1",ZDIRC+"MANARQ",.T.)
      dbcloseall()
      retu .F.
   endif
   dbgotop()
   while !eof()
      cARQUIVO := ARQUIVO
      nITEM    := ITEM
      dbskip()
      if !eof()
         if cARQUIVO = ARQUIVO .AND. nITEM = ITEM
            netrecdel()
         endif
      endif
   enddo
   dbcloseall()
endif

if mdg("Apagar Indices sem Arquivo")
   if !USECHK(ZDIRC+"MANARQ",ZDIRC+"MANARQ",.T.)
      dbcloseall()
      retu .F.
   endif
   if !USECHK(ZDIRC+"MANARQ1",ZDIRC+"MANARQ",.T.)
      dbcloseall()
      retu .F.
   endif
   DBSELECTAR("MANARQ1")
   DBGOTOP()
   WHILE !EOF()
      cARQUIVO := ARQUIVO
      DBSELECTAR("MANARQ")
      DBGOTOP()
      lTEM := DBSEEK(cARQUIVO)
      DBSELECTAR("MANARQ1")
      IF !lTEM
         netrecdel()
      ENDIF
      DBSKIP()
   ENDDO
   dbcloseall()
endif


