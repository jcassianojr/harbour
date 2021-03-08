*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlibarq.prg
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
*+    Function CHECKARQ()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CHECKARQ


para cARQ1,cARQ2,cDES,lINDEX,cCAM,nANO,nMES   //recebe Variaveis como privadas sofrer  macro
if valtype(lINDEX) # "L"
   lINDEX := .T.
endif
if valtype(cCAM) # "C"
   cCAM := ZDIRE
endif
if ! file(cCAM+cARQ2+".DBF")   //Cria Arquivos
   MDS("Aguarde Preparando")
   CRIARVARS(zARQ)
   CRIARVARS(zARQ1)
   if USEREDE(cARQ1,1,0)
      aESTRU := dbstruct()
      dbclosearea()
      dbcreate(cCAM+cARQ2,aESTRU)
      IGUALVARS(zARQ,cARQ1)   //Grava Configura‡„o de Arquivo
      mARQUIVO := cARQ2
      if valtype(cDES) = "C"
         mDESCRICAO := cDES
      endif
      if valtype(cCAM) = "C"
         mCAMINHO := cCAM
         mPADRAO  := "X"
      endif
      if valtype(nMES) = "N"
         mARQMES := nMES
      endif
      if valtype(nANO) = "N"
         mARQANO := nANO
      endif
      mDRIVER  := "DBFCDX"
      mPULAFIX := "S"
      NOVOREG(zARQ,cARQ2)
      if USEREDE(zARQ1,1,99)  //Grava Configura‡„o de Indexa‡„o
         dbgotop()
         dbseek(padr(cARQ1,8))
         while ARQUIVO = padr(cARQ1,8) .and. !eof()
            REG := recno()
            EQUVARS()
            mARQUIVO := cARQ2
            if len(cARQ2) = 7
               mINDICE := cARQ2+strzero(ITEM,1)
            else
               mINDICE := cARQ2+strzero(ITEM,2)
            endif
            if valtype(cDES) = "C"
               mDESC := cDES
            endif
            NOVOOPA()
            dbgoto(REG)
            dbskip()
         enddo
         dbclosearea()
      endif
   endif
   release all like M *
   if lINDEX
      M_DB("ARQUIVO=cARQ2")   //Indexa
   endif
endif
retu .T.

