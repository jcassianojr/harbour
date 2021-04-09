*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_dw.prg
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

MDI(" Recriar configuracao Tabelas CEPS")
MDS("Apagando configuracao Tabelas")
IF !USEREDE("MD01",0,99)
   RETU .F.
ENDIF
DBGOTOP()
WHILE !EOF()
   @ 24,00 SAY RECNO()         
   IF LEFT(NOME,4) = "CEP:"
      netrecdel()
   ENDIF
   DBSKIP()
ENDDO
PACK
DBCLOSEAREA()
IF !USEREDE("MD10",1,99)
   RETU .F.
ENDIF
if !useCHK(ZDIRC+"MANARQ",ZDIRC+"MANARQ",.T.)
   dbcloseall()
   retu .F.
endif
if !useCHK(ZDIRC+"MANARQ1",ZDIRC+"MANARQ1",.T.)
   dbcloseall()
   retu .F.
endif
MDS("Apagando Configuracao Indexacao")
dbselectar("MANARQ")
DBGOTOP()
WHILE !EOF()
   @ 24,00 SAY RECNO()         
   IF LEFT(DESCRICAO,4) = "CEP:"
      cARQUIVO := ARQUIVO
      netrecdel()
      DBSELECTAR("MANARQ1")
      DBGOTOP()
      DBSEEK(cARQUIVO)
      WHILE ARQUIVO = cARQUIVO .AND. !EOF()
         netrecdel()
         DBSKIP()
      ENDDO
   ENDIF
   DBSELECTAR("MANARQ")
   DBSKIP()
ENDDO

mds("recriando")
DBSELECTAR("MD10")
DBGOTOP()
WHILE !EOF()
   IF val(cCODIBGE) > 0   //CEP Localidade =ibge
      mARQUIVO := "C" + cCODIBGE
      mDESCR   := ALLTRIM("CEP:"+UF+":"+NOME)
      DBSELECTAR("MANARQ")
      netrecapp()
      FIELD->ARQUIVO   := mARQUIVO
      FIELD->DESCRICAO := mDESCR
      FIELD->FIXAR     := "S"
      FIELD->LACHI     := 999999  //4096 harbour sem limite array
      FIELD->PADRAO    := "A"   //Ceps
      FIELD->VIDEO     := "T"
      FIELD->PBUS      := "S"
      FIELD->PIND      := "N"
      FIELD->TIPG      := "1"
      FIELD->IBUS      := 1
      FIELD->IEXI      := 1
      FIELD->CAMINHO   := "CEPS\"
      FIELD->DRIVER    := "DBFCDX"
      DBSELECTAR("MANARQ1")
      netrecapp()
      FIELD->ARQUIVO := mARQUIVO
      FIELD->ITEM    := 1
      FIELD->INDICE  := mARQUIVO+"1"
      FIELD->INDEXP  := "RUA"
      FIELD->DESC    := mDESCR+":Rua"
      FIELD->VAR1    := "mRUA"
      FIELD->DES1    := "Digite o Nome da Rua"
      netrecapp()
      FIELD->ARQUIVO := mARQUIVO
      FIELD->ITEM    := 2
      FIELD->INDICE  := mARQUIVO+"2"
      FIELD->INDEXP  := "CEP"
      FIELD->DESC    := mDESCR+":CEP"
      FIELD->VAR1    := "mCEP"
      FIELD->DES1    := "Digite o Numero do CEP"
   ENDIF
   DBSELECTAR("MD10")
   DBSKIP()
ENDDO

DBCLOSEALL()







