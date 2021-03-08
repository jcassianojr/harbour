*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_a6.prg
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
*+    Function MA6JUR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MA6JUR()

PADRAX(0,,0,{"IRRF01","IRRF02"},"Numero   Nome"+spac(37)+"CGC",;
 "' '+STR(mNUMERO,  8)+' '+mNOME+' '+mCGC","MA6001","MA6001",;
 ,{|| PADDEL("IRRF02",str(xCHAVE,8),"NUMERO","xCHAVE")},;
 {|| MA6REP()},{|| mNUMERO := ULTIMOREG("IRRF01","NUMERO","mNUMERO")})
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MA6FIS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MA6FIS()

PADRAO(0,1,0,"IRRF","CPF - Nome","' '+mCPF+' '+mNOME","MA63","MA6301","MA6301")
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MA6REP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MA6REP()


xNUMERO := mNUMERO
PADRAO(1,1,0,"IRRF02","Numero   It Mes  Cod  Natureza"+spac(13)+"Renda"+spac(8)+"Aliq. Reten‡„o",;
 "' '+STR(mNUMERO,  8)+' '+STR(mITEM,  2)+' '+STR(mMES,  4)+' '+mDARF+' '+mNATUREZA+' '+STR(mRENDA, 12, 2)+' '+STR(mALIQUOTA,  5, 2)+' '+STR(mIRRF,  8, 2)",;
 "MA62","MA6201","MA6201",{|| mNUMERO := xNUMERO},{|| PADARR("IRRF02",str(xNUMERO,8),"STR(xNUMERO,8)","STR(NUMERO,8)")})
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function DARF()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func DARF(cCODIGO)


if !USEREDE("MD02",1,1)
   retu .T.
endif
dbgotop()
if dbseek(padr("CODIRRF",12)+padr(cCODIGO,12))
   mNATUREZA := left(DESCRICAO,20)
   if empty(mALIQUOTA)
      mALIQUOTA := VARIACAO
   endif
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MA6GER()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MA6GER


GRAVA1     := "S"
mrXTEL     := mrXDDD := mrXFAX := ""
xrCGC      := xrNOME := ""
xrDDD      := xrTEL := xrPESSOA := ""
xrRESN     := xrRESC := xrFAX := xrRAMAL := mNOME := ""
mEMAIL     := CPFCNPJ := ""
ANO        := STRZERO(YEAR(DATE()) - 1,4)
ANOREF     := STRZERO(YEAR(DATE()),4)
ARQ        := "C:\TEMP\DIRF    .TXT"
ARQDET     := " "
OPER       := "O"
CODRET     := "0561"
SITU       := "1"
NATUR      := "0"
IDEN       := "0"
nREG02     := 0
xNUMEROANT := SPACE(12)


MDI(" Gera IRRF ")
if !USEREDE("MANEMP",1,1)
   retu .F.
endif
dbgotop()
if !dbseek(ZNUMERO)
   dbcloseall()
   ALERTX("Falta Cadastro Empresa")
   retu
endif
xrCGC    := CGC
xrNOME   := ACEPAD(NOME,60)
xrDDD    := DDD
xrTEL    := TELEFONE
xrPESSOA := PESSOA
xrFAX    := TELEFAX
xrRAMAL  := ACEPAD(RAMAL,6)
dbcloseall()

xrRESN  := space(60)
xrRESC  := space(14)
CPFCNPJ := space(14)
mEMAIL  := space(50)

mrXTEL := strtran(xrTEL,"-","")
mrXTEL := strtran(mrXTEL," ","0")
mrXTEL := strzero(val(mrxTEL),8)
mrXFAX := strtran(xrFAX,"-","")
mrXFAX := strtran(mrXFAX," ","0")
mrXFAX := strzero(val(mrxFAX),8)
mrXDDD := strzero(val(XRDDD),4)

DIRFPEGDAD(2)
ARQ      := alltrim(ARQ)
mCGC     := substr(xrCGC,1,2)+substr(xrCGC,4,3)+substr(xrCGC,8,3)
mEST     := substr(xrCGC,12,4)+substr(xrCGC,17,2)
mrCPF    := substr(xrRESC,1,3)+substr(xrRESC,5,3)+substr(xrRESC,9,3)+substr(xrRESC,13,2)
mCPFCNPJ := substr(CPFCNPJ,1,3)+substr(CPFCNPJ,5,3)+substr(CPFCNPJ,9,3)+substr(CPFCNPJ,13,2)

SEQ     := 1
aTOTREN := array(13)
aTOTDED := array(13)
aTOTIRR := array(13)
afill(aTOTREN,0)
afill(aTOTDED,0)
afill(ATOTIRR,0)

if !USEREDE("IRRF01",1,1)   //Shared Brede PES
   retu .F.
endif
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","CGC")
ordSetFocus("temp")


if !USEREDE("IRRF02",1,1)   //SHARED Arede ajudir
   dbcloseall()
   retu .F.
endif

//Criando o Arquivo
USO := fcreate(ARQ)
IF FERROR() # 0
   ALERTX("Erro na Cria‡„o do Arquivo")
   RETU
ENDIF
if GRAVA1 = "S"
   Mnrclien := znumero
   DIRFREG01()
ENDIF

dbselectar("IRRF01")
dbgotop()
while !eof()
   @ 24,00 say NOME         
   aREND := array(13)
   aDEDU := array(13)
   aIRRF := array(13)
   afill(aREND,0)
   afill(aDEDU,0)
   afill(aIRRF,0)
   mNOME   := NOME
   mNUMERO := NUMERO
   mPESSOA := PESSOA
   if PESSOA = "J"
      USOCGC := substr(CGC,1,2)+substr(CGC,4,3)+substr(CGC,8,3)
      USOCGC += substr(CGC,12,4)+substr(CGC,17,2)
   else
      USOCGC := substr(CGC,1,3)+substr(CGC,5,3)+substr(CGC,9,3)+substr(CGC,13,2)
      USOCGC := "000"+USOCGC
   endif
   GRAVA := .F.
   dbselectar("IRRF02")
   dbgotop()
   dbseek(str(mNUMERO,8))
   while mNUMERO = NUMERO .and. !eof()
      if MES > 0 .and. MES < 13 .and. DARF = CODRET
         GRAVA := .T.
         aREND[MES] += RENDA
         aDEDU[MES] += 0
         aIRRF[MES] += IRRF
      endif
      dbskip()
   enddo
   dbselectar("IRRF01")
   if GRAVA
      DIRFREG02()
   endif
   dbselectar("IRRF01")
   dbskip()
enddo
dbcloseall()


fwrite(USO,chr(26))
fclose(USO)
retu .T.



