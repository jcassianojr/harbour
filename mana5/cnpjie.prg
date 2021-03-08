*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : cnpjie.prg
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

REQUEST DBFCDX
rddsetdefault("DBFCDX")

USE MANARQ NEW SHARED
ORDLISTADD("MANARQ")

USE MANARQ1 NEW SHARED
ORDLISTADD("MANARQ1")

aUF := {"AC","AL","AM","AP","BA","CE","DF","ES","GO","EX",;
 "MA","MG","MS","MT","PA","PB","PE","PI","PR","XX",;
 "RJ","RN","RO","RR","RS","SC","SE","SP","TO","","BAIXAGO","BAIXARS"}

FOR X := 1 TO 32
   IF lEN(aUF[X]) = 2
      mARQUIVO := "CNPJIE"+aUF[X]
      mINDEX   := "CNPIE"+aUF[X]
   ELSE
      mARQUIVO := aUF[X]
      mINDEX   := aUF[X]
   ENDIF
   DBSELECTAR("MANARQ")
   DBAPPEND()
   FIELD->ARQUIVO   := mARQUIVO
   FIELD->DESCRICAO := mARQUIVO
   FIELD->FIXAR     := "S"
   FIELD->LACHI     := 9999999  //4096 harbour sem limite array
   FIELD->PADRAO    := "X"  //Ceps
   FIELD->VIDEO     := "T"
   FIELD->PBUS      := "S"
   FIELD->PIND      := "N"
   FIELD->TIPG      := "1"
   FIELD->IBUS      := 1
   FIELD->IEXI      := 1
   FIELD->CAMINHO   := "CNPJIEUF\"
   FIELD->DRIVER    := "DBFCDX"
   DBSELECTAR("MANARQ1")
   DBAPPEND()
   FIELD->ARQUIVO := mARQUIVO
   FIELD->ITEM    := 1
   FIELD->INDICE  := mINDEX+"1"
   FIELD->INDEXP  := "CNPJ"
   FIELD->DESC    := mARQUIVO+" - CNPJ"
   FIELD->VAR1    := "mCNPJ"
   FIELD->DES1    := "Digite o CNPJ"
   FIELD->FORMULA := "mCNPJ"
   DBAPPEND()
   FIELD->ARQUIVO := mARQUIVO
   FIELD->ITEM    := 2
   FIELD->INDICE  := mINDEX+"2"
   FIELD->INDEXP  := "IE"
   FIELD->DESC    := mARQUIVO+" - IE"
   FIELD->VAR1    := "mIE"
   FIELD->DES1    := "Digite a IE"
   FIELD->FORMULA := "mIE"
NEXT X
DBCLOSEALL()







