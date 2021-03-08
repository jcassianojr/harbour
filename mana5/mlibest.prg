*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlibest.prg
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
*+    Function MAM2K05()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAM2K05(mOPER,cARQ,nIND)   //Gravando um Movimento no Estoque

if valtype(cARQ) # "C"
   cARQ := "MM02"
endif
GRVESTOQUE(mOPER,cARQ,nIND,mNUMERO,"S")



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAK2K05()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAK2K05(mOPER,cARQ,nIND)   //Gravando um Movimento no Estoque

if valtype(cARQ) # "C"
   cARQ := "MK02"
endif
GRVESTOQUE(mOPER,cARQ,nIND,mNRNOTA,"E")


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function GRVESTOQUE()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func GRVESTOQUE(mOPER,cARQ,nIND,nNRNOTA,cTIPO)

if empty(yCODIGO)
   retu .F.
endif
nESTQXXX := 0
nESTQYYY := 0
if valtype(nIND) # "N"
   nIND := 1
endif
ARQEST := ESTQARQ(mTIPOENT,0)
ARQMOV := ESTQARQ(mTIPOENT,1)
IF ARQEST = "XXXX"
   RETU .F.
ENDIF
WHILE !USEREDE(ARQEST,1,99)
ENDDO
netrecapp()
field->ARQUIVO   := padr(cARQ,8)
field->DOCUMENTO := str(nNRNOTA,8)+str(mFORNECEDO,5)+yCODIGO
field->OPERACAO  := mOPER
field->USUARIO   := ZUSER
GRAVACAMPO("QTDE","mQTDE")
netreclock()
field->OLDQTDE := if(mOPER = "I",0,mOLDQTDDE)
field->DATA    := if(empty(mDATA),date(),mdata)
field->NUMERO  := nNRNOTA
field->CODIGO  := yCODIGO
if type("mRASTRO") = "C"
   field->RASTRO := mRASTRO
endif
dbunlock()
//Gravando o Estoque
while !USEREDE(ARQMOV,1,nIND)
enddo
dbgotop()
if dbseek(yCODIGO)
   netreclock()
   IF cTIPO = "S"
      do case
         case mOPER = "I"
            field->ESTQSAI := ESTQSAI+mQTDE
         case mOPER = "E"
            field->ESTQSAI := ESTQSAI - mQTDE
         case mOPER = "A"
            field->ESTQSAI := ESTQSAI - mOLDQTDDE+mQTDE
         case mOPER = "R"
            field->ESTQSAI := ESTQSAI - mOLDQTDDE+mQTDE
      endcase
   else
      do case
         case mOPER = "E"
            field->ESTQENT := ESTQENT - mQTDE
         case mOPER = "I"
            field->ESTQENT := ESTQENT+mQTDE
         case mOPER = "A"
            field->ESTQENT := ESTQENT - mOLDQTDDE+mQTDE
         case mOPER = "R"
            field->ESTQENT := ESTQENT - mOLDQTDDE+mQTDE
      endcase
   endif
   //Gravando o Saldo de Estoque
   nESTQXXX       := ESTQSAL
   field->ESTQSAL := ESTQINI+ESTQENT - ESTQSAI
   nESTQYYY       := ESTQSAL
   //Acumulando as saidas no Campo Saimim para fazer o estoque minimo
   do case
      case mOPER = "I"
         field->SAIMIN := SAIMIN+mQTDE
      case mOPER = "E"
         field->SAIMIN := SAIMIN - mQTDE
      case mOPER = "A"
         field->SAIMIN := SAIMIN - mOLDQTDDE+mQTDE
      case mOPER = "R"
         field->SAIMIN := SAIMIN - mOLDQTDDE+mQTDE
   endcase
   //Calculando o Estoque Minimo
   xDIAS          := mDATA - DATMIN
   VAR1           := SAIMIN / xDIAS
   VAR2           := if(DIASENT > 0,DIASENT,1) * VAR1
   VAR3           := if(DIASEST > 0,DIASEST,1) * VAR1
   field->ESTQMIN := VAR2+VAR3
   if xDIAS > zMEDIA
      field->DATMIN := mDATA - zMEDIA
      field->SAIMIN := VAR1 * zMEDIA
   endif
   dbunlock()
endif
dbselectar(ARQMOV)
dbclosearea()
GRAVALAY({{"ESTQXXX","ESTQYYY"},{"nESTQXXX","nESTQYYY"}},ARQEST,,.F.,,.F.)
dbclosearea()
IF nESTQYYY < 0
   ALERTX(ALLTRIM(yCODIGO)+" Estoque Negativo")
ENDIF
IF nESTQYYY > 9999999
   ALERTX(ALLTRIM(yCODIGO)+" Estoque >99999999")
ENDIF
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function pegoldqtd()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func pegoldqtd(cARQ,nNRNOTA)


local nOLDQTDE := 0.000
if valtype(cARQ) # "C"
   cARQ := "MM02"
endif
ARQEST := ESTQARQ(mTIPOENT,0)
if !USEREDE(ARQEST,1,99)
   retu 0
endif
dbgotop()
dbseek(padr(cARQ,8)+str(nNRNOTA,8)+str(mFORNECEDO,5)+trim(yCODIGO))
while trim(str(nNRNOTA,8)+str(mFORNECEDO,5)+YCODIGO) = trim(DOCUMENTO) .and. !eof()
   nOLDQTDE := QTDE
   dbskip()
enddo
dbclosearea()
retu nOLDQTDE


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAM2K06()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAM2K06(cARQ)


if valtype(cARQ) # "C"
   cARQ := "MM02"
endif
retu pegoldqtd(Carq,mNUMERO)


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAK2K06()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAK2K06(cARQ)


if valtype(cARQ) # "C"
   cARQ := "MK02"
endif
retu pegoldqtd(Carq,mNRNOTA)


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ESTQARQ()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func ESTQARQ(cTIP,nTIP)


local cRETU := "XXXX"
do case
   case nTIP = 0
      do case
         case cTIP = "M"
            cRETU := "MU99"
         case cTIP = "P"
            cRETU := "MS99"
         case cTIP = "B"
            cRETU := "MR99"
         case cTIP = "S"
            cRETU := "MQ99"
         case cTIP = "C"
            cRETU := "MT99"
         case cTIP = "1" .or. cTIP = "E"
            cRETU := "MP91"
         case cTIP = "2" .or. cTIP = "H"
            cRETU := "MP92"
         case cTIP = "3" .or. cTIP = "T"
            cRETU := "MP93"
         case cTIP = "O"
            cRETU := "MW95"
         case cTIP = "R"
            cRETU := "MW97"
         otherwise
            cRETU := "XXXX"
      endcase
   case nTIP = 1
      do case
         case cTIP = "M"
            cRETU := "MU01"
         case cTIP = "P"
            cRETU := "MS01"
         case cTIP = "B"
            cRETU := "MR01"
         case cTIP = "S"
            cRETU := "MQ01"
         case cTIP = "C"
            cRETU := "MT01"
         case cTIP = "1" .or. cTIP = "E"
            cRETU := "MP01"
         case cTIP = "2" .or. cTIP = "H"
            cRETU := "MP02"
         case cTIP = "3" .or. cTIP = "T"
            cRETU := "MP03"
         case cTIP = "O"
            cRETU := "MW05"
         case cTIP = "I"
            cRETU := "ME04"
         case cTIP = "R"
            cRETU := "MW07"
         otherwise
            cRETU := "XXXX"
      endcase
   case nTIP = 2
      do case
         case cTIP = "M"
            cRETU := "U9"
         case cTIP = "B"
            cRETU := "R9"
         case cTIP = "P"
            cRETU := "S9"
         case cTIP = "S"
            cRETU := "Q9"
         case cTIP = "C"
            cRETU := "T9"
         case cTIP = "1" .or. cTIP = "E"
            cRETU := "P1"
         case cTIP = "2" .or. cTIP = "H"
            cRETU := "P2"
         case cTIP = "3" .or. cTIP = "T"
            cRETU := "P3"
         case cTIP = "O"
            cRETU := "W5"
         case cTIP = "R"
            cRETU := "W7"
         otherwise
            cRETU := "XX"
      endcase
endcase
retu cRETU


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ZERAEST()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func ZERAEST(cARQ,cTIPO)


local cFILTRO
IF VALTYPE(cTIPO) # "C"
   cTIPO := "T"
ENDIF
cFILTRO := ''
cFILTRO := RFILORD(cARQ,.F.)
IF !MDG("Zerar Estoque")
   RETU .F.
ENDIF
MDS("Aguarde Zerando")
if !USEREDE(cARQ,1,99)
   retu .F.
endif
if !empty(cFILTRO)
   set filter to &cFILTRO
endif
dbgotop()
while !eof()
   @ 24,40 say recno()         
   IF cTIPO = "T" .OR. (cTIPO = "N" .AND. ESTQSAL < 0)
      netreclock()
      field->ESTQINI   := 0
      field->ESTQENT   := 0
      field->ESTQSAI   := 0
      field->ESTQSAL   := 0
      field->DATABALAN := ZDATA
      dbunlock()
   ENDIF
   dbskip()
enddo
dbcloseall()

