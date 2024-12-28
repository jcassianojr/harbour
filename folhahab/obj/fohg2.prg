*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fohg2.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 27-Dez-2024 as  9:46 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+



CABEX('Gerar Arquivo para RE FGTS')
if ARQ # 1
   ALERTX("Somente para Folha de Pagamento")
   retu .F.
endif
if empty(ZPESSOA)
   ALERTX("Cadastre Tipo de Pessoa Cadastro Empresa")
   retu .F.
endif
if empty(CGC1)
   ALERTX("Cadastre CPF ou CGC Cadastro Empresa")
   retu .F.
endif
INSREP := SPACE(14)
TIPREP := " "
do case
case ZPESSOA = 'J'
   INSREP := substr(CGC1,1,2)+substr(CGC1,4,3)+substr(CGC1,8,3)+substr(CGC1,12,4)+substr(CGC1,17,2)
   TIPREP := "1"
case ZPESSOA = 'C'
   INSREP := "00"+ZCEI
   TIPREP := "2"
case ZPESSOA = 'F'
   INSREP := "000"+substr(CGC1,1,3)+substr(CGC1,5,3)+substr(CGC1,9,3)+substr(CGC1,13,2)
   TIPREP := "3"
endcase
mPAGGPS := "2100"
GRACTA  := "N"
mRAZAO  := TIRACX(MSG2,30)
CONTATO := TIRACX(OBTER("FIRMA",,NREMP,"RESPONSAV"),20)
mEMAIL  := OBTER("FIRMA",,NREMP,"EMAIL")
SIMPLES := OBTER("FIRMA",,NREMP,"SIMPLES")
SIMPLES := if(SIMPLES = "N","1",SIMPLES)
SIMPLES := if(SIMPLES = "S","2",SIMPLES)
IF SIMPLES = "2"
   mPAGGPS := "2003"
ENDIF
INCDIR    := if(HB_FILEEXISTS(ZDIRE+"FO_DIR.DBF"),"S","N")
INCFUN    := if(PES = "FO_PES","S","N")
ALTEND    := "N"
mCODREC   := "115"
mINDFGS   := "1"
mSITUI    := "1"
mREMESSA  := "1"
mMODAL    := " "
mTIPFOR   := "1"
mCGCFOR   := INSREP
FILAN     := 0
mVCOOPER  := 0
mGPSANT   := 0
mCOMERFIS := 0
mCOMERJUR := 0

mCLASSE  := OBTER("BCOFGTS",,NREMP,"TIPOEMP")
mCODCAI  := OBTER("BCOFGTS",,NREMP,"CODEMP+CODEMPDV+SEQUENCIA+SEQUENDV")
mUNIDADE := OBTER("BCOFGTS",,NREMP,"UNIDADE")
mBCO     := OBTER("BCOFGTS",,NREMP,"NUMERO")
mAGENCIA := OBTER("BCOFGTS",,NREMP,"AGENCIA")
mCONTA   := OBTER("BCOFGTS",,NREMP,"AGENCTA")

mINDINSS  := 0
mCEP      := strtran(CEP1,"-","")
mFPAS     := OBTER("FIRMA",,NREMP,"FPAS")
mENDERECO := TIRACX(ENDER1,50)
mBAIRRO   := TIRACX(BAI1,20)
mCIDADE   := TIRACX(CID1,20)
mESTADO   := EST1
mTEL      := strzero(val(OBTER("FIRMA",,NREMP,"DDD")),3)
mTEL      += strzero(val(strtran(zTELEFONE,"-","")),9)
mALTC     := "N"
mCNAE     := OBTER("FIRMA",,NREMP,"ATIVIDADE")
mDELIM    := "S"
mCHR26    := "N"
INSS12    := GPS12 := 0
IND12     := "0"

mCOMP  := strzero(ANO,4)+strzero(MESTRAB,2)
MESXXX := MESTRAB+1
ANOXXX := ANO
if MESXXX = 13
   MESXXX := 1
   ANOXXX += 1
endif
mDATFGT := "07"+strzero(MESXXX,2)+strzero(ANOXXX,4)
mDATINS := "01"+strzero(MESXXX,2)+strzero(ANOXXX,4)

mSAT    := 0
mCODTER := space(4)
VERSEHA("CONFINSS",,val(mFPAS),,'COdigo FPAS INEXISTENTE',.T.,;
 {{"ACIDENTE","mSAT"},;
 {"STRZERO(TERCEIRO,4)","mCODTER"}})

if SIMPLES = "2"
   mCODTER := space(4)
endif

aCTA01 := PEGRELCTA("FGTS01")
aCTA02 := PEGRELCTA("FGTS02")
aCTA03 := PEGRELCTA("FGTS03")
aCTA04 := PEGRELCTA("FGTS04")
aCTA05 := PEGRELCTA("FGTS05")
aCTA10 := PEGRELCTA("FGTS10")
aCTA11 := PEGRELCTA("FGTS11")
aCTA12 := PEGRELCTA("FGTS12")

mSALFAM := 0
mVALMAT := 0
MDS("Somando Salario Familia/AuxMat.")
if !NETUSE(FOL,,,,,.F.,)  //BREDE( FOL, 1 )
   dbcloseall()
   retu .F.
endif
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","conta")
ordSetFocus("temp")

for X := 1 to 15
   if !empty(aCTA05[X])
      dbgotop()
      dbseek(aCTA05[X])
      while CONTA = aCTA05[X] .and. !eof()
         mSALFAM += VALOR
         dbskip()
      enddo
   endif
   if !empty(aCTA12[X])
      dbgotop()
      dbseek(aCTA12[X])
      while CONTA = aCTA12[X] .and. !eof()
         mVALMAT += VALOR
         dbskip()
      enddo
   endif
next X
dbclosearea()
@ 24,00

ALERTX("Confirme os Dados com Aten‡„o")
TELASAY("FOHG21")
EDITSAY("FOHG21")



mMESYYY := substr(mCOMP,5)
//ALERTX(mMESYYY)
if mMESYYY = "13"
   aCTA04 := PEGRELCTA("FGTS1301")
endif

mCODTER := if(SIMPLES # "2",strzero(val(mCODTER),4),space(4))

cTOM1 := " "
cTOMA := space(14)
if mCODREC = "130" .or. mCODREC = "150" .or. mCODREC = "155" .or. mCODREC = "608"
   cTOMA := repl("0",14)
   cTOM1 := "1"
endif

cVALFAM := GRVVAL(mSALFAM,15,2)
if mSAT > 0
   cSAT := GRVVAL(mSAT,2,1)
else
   cSAT := space(2)
endif

if FILAN > 0
   cFILAN := GRVVAL(FILAN,5,2)
else
   cFILAN := space(5)
endif

cVALMAT := GRVVAL(mVALMAT,15,2)

cINSS12 := GRVVAL(INSS12,15,2)

cGPS12 := GRVVAL(GPS12,14,2)

if INCFUN = "S"
   if !NETUSE(PES,,,,,.F.,)
      retu .F.
   endif
   FILTRO := FILTRO("")
   if !empty(FILTRO)
      set filter to &FILTRO
   endif
   nLASTREC := LASTREC()
   zei_fort(nLASTREC,,,0)
   ordDestroy("temp")
   ordcreate(,"temp","pis")
   ordSetFocus("temp")


   if !NETUSE('FP'+EMP+ARQMES)
      dbcloseall()
      retu .F.
   endif
   cSELE2 := ALIAS()
endif

if !NETUSE("FO_OCO")
   dbcloseall()
   retu .F.
endif
if INCDIR = "S"
   if !NETUSE("FO_DIR",,,,,.F.,)
      dbcloseall()
      retu .F.
   endif
   FILTR2 := FILTRO("")
   if !empty(FILTR2)
      set filter to &FILTR2
   endif
   nLASTREC := LASTREC()
   zei_fort(nLASTREC,,,0)
   ordDestroy("temp")
   ordcreate(,"temp","ci")
   ordSetFocus("temp")


   cSELE4 := ALIAS()

   if !NETUSE('SO'+EMP+ARQMES)  //AREDE( 'SO' + EMP + ARQMES, 'SO' + EMP + ARQMES, 1 )
      dbcloseall()
      retu .F.
   endif
   cSELE5 := ALIAS()

endif

ARQUIVO := ZDIRE+"SEFIP.RE"
USO     := fcreate(ARQUIVO)
IF FERROR() # 0
   ALERTX("Erro na Cria‡„o do Arquivo")
   RETU
ENDIF
FWRITX("00",2)  //1 00-Header
FWRITX(space(51),51)  //2
FWRITX(mREMESSA,1,,1)   //3
FWRITX(TIPREP,1,,1)   //4
FWRITX(INSREP,14,,1)  //5
FWRITX(mRAZAO,30)   //6
FWRITX(CONTATO,20)  //7
FWRITX(mENDERECO,50)  //8
FWRITX(mBAIRRO,20)  //9
FWRITX(mCEP,8,,1)   //10
FWRITX(mCIDADE,20)  //11
FWRITX(mESTADO,2)   //12
FWRITX(mTEL,12,,1)  //13
FWRITE(USO,PADR(mEMAIL,60))   //14
FWRITX(mCOMP,6)   //15
FWRITX(mCODREC,3,,1)  //16
FWRITX(mINDFGS,1)   //17
FWRITX(mMODAL,1)  //18
if mINDFGS = "2"
   FWRITX(mDATFGT,8)  //19
else
   FWRITX(space(8),8)   //19
endif
FWRITX(mSITUI,1,,1)   //20
if mSITUI = "2"
   FWRITX(mDATINS,8)  //21
else
   FWRITX(space(8),8)   //21
endif
if mINDINSS > 0
   FWRITX(mINDINSS,7,,1)  //22
else
   FWRITX(space(7),7)   //22
endif
FWRITX(mTIPFOR,1,,1)  //23
FWRITX(mCGCFOR,14,,1)   //24
FWRITX(space(18),18)  //25
FWRITX("*",1)   //26
if mDELIM = "S"
   fwrite(USO,chr(13)+chr(10))
endif

fwrite(USO,"10")  // 10-Dados da Empresa //1
FWRITX(TIPREP,1,,1)   //2
FWRITX(INSREP,14,,1)  //3
FWRITX(repl("0",36),36,,1)  //4
FWRITX(mRAZAO,40)   //5
FWRITX(mENDERECO,50)  //6
FWRITX(mBAIRRO,20)  //7
FWRITX(mCEP,8,,1)   //8
FWRITX(mCIDADE,20)  //9
FWRITX(mESTADO,2)   //10
FWRITX(mTEL,12,,1)  //11
FWRITX(ALTEND,1)  //12
FWRITX(mCNAE,7,,1)  //13
FWRITX(mALTC,1)   //14
FWRITX(cSAT,2,,1)   //15
FWRITX(mCLASSE,1,,1)  //16
FWRITX(SIMPLES,1,,1)  //17
FWRITX(mFPAS,3,,1)  //18
FWRITX(mCODTER,4)   //19
FWRITX(mPAGGPS,4)   //20
FWRITX(cFILAN,5)  //21
FWRITX(cVALFAM,15)  //22
FWRITX(cVALMAT,15)  //23
FWRITX(cINSS12,15)  //24
FWRITX(IND12,1)   //25
FWRITX(cGPS12,14)   //26
if GRACTA = "N"
   FWRITX(space(3),3)   //27
   FWRITX(space(4),4)   //28
   FWRITX(space(9),9)   //29
else
   FWRITX(mBCO,3,,1)  //27
   FWRITX(mAGENCIA,4,,1)  //28
   FWRITX(mCONTA,9)   //29
endif
FWRITX(repl("0",15),15)   //30
FWRITX(repl("0",15),15)   //30
FWRITX(repl("0",15),15)   //30
FWRITX(space(4),4)  //31
FWRITX("*",1)   //32
if mDELIM = "S"
   fwrite(USO,chr(13)+chr(10))
endif

if mvCOOPER > 0 .OR. mGPSANT > 0 .OR. mCOMERFIS > 0 .OR. mCOMERFIS > 0
   fwrite(USO,"12")   // 12-Dados da Empresa Complemento //1
   FWRITX(TIPREP,1,,1)  //2 tIPO Inscri‡ao
   FWRITX(INSREP,14,,1)   //3 cgc
   FWRITX(repl("0",36),36)  //4  zeros
   FWRITX(repl("0",15),15)  //5 Ded 13 Mat
   FWRITX(repl("0",15),15)  //6 Evento Desportivo
   FWRITX(" ",1)  //7 Origem Desportivo
   FWRITX(GRVVAL(mCOMERFIS,15,2),15)  //8 Comercializacao Rural Fisica
   FWRITX(GRVVAL(mCOMERJUR,15,2),15)  //9 Comercializacao Rural Juridica
   FWRITX(space(11),11)   //10 Outras Inf Processo
   FWRITX(space(4),4)   //11 Ano Processo
   FWRITX(space(5),5)   //12 Vara
   FWRITX(space(6),6)   //13 Periodo Ini
   FWRITX(space(6),6)   //14 Perido Fim
   FWRITX(repl("0",15),15)  //15 Compensacao
   FWRITX(space(6),6)   //16 Inicio Compensacao
   FWRITX(space(6),6)   //17 Fim Compensacao
   FWRITX(GRVVAL(mGPSANT,15,2),15)  //18 GPS<R$ 29 Meses Anteriores
   FWRITX(repl("0",15),15)  //19 GPS<R$ 29 oUTRAS Entidades
   FWRITX(repl("0",15),15)  //20 GPS<R$ 29 Comer.Rural
   FWRITX(repl("0",15),15)  //21 GPS<R$ 29 Corer.OUTRAS
   FWRITX(repl("0",15),15)  //22 GPS<R$ 29 Evento Desp
   FWRITX(repl("0",15),15)  //23 pARCELAMENTO
   FWRITX(repl("0",15),15)  //24 Parcelamento
   FWRITX(repl("0",15),15)  //25 Parcelamento
   FWRITX(GRVVAL(mVCOOPER,15,2),15)   //26 Valor Cooperados
   FWRITX(repl("0",15),15)  //27 Futura
   FWRITX(repl("0",15),15)  //27 Futura
   FWRITX(repl("0",15),15)  //27 Futura
   FWRITX(space(6),6)   //28 Preencher Brancos
   FWRITX("*",1)  //29 Final de Linha
   if mDELIM = "S"
      fwrite(USO,chr(13)+chr(10))
   endif

endif

for K := 1 to 3
   if INCFUN = "S"
      DBSELECTAR(PES)
      dbgotop()
      while !eof()
         PETELA(8)
         mNUMERO := NUMERO
         mNOME   := NOME
         mPIS    := PIS
         mCI     := CI
         mCAT    := CATEGORIA
         mOCO    := OCOFGTS
         if empty(mPIS)
            mPIS := "1"+space(10)
         endif
         if empty(mCAT)
            mCAT := "01"
         endif
         if empty(mOCO)
            mOCO := "0"
         endif
         nGRUP01 := 2
         if mCAT = "01" .or. mCAT = "02" .or. mCAT = "03" .or. mCAT = "04" .or. mCAT = "05" .or. mCAT = "12"
            nGRUP01 := 1
         endif
         nGRUP02 := 2
         if mCAT = "01" .or. mCAT = "03" .or. mCAT = "04" .or. mCAT = "05" ;
                    .or. mCAT = "06" .or. mCAT = "07" .or. mCAT = "11" ;
                    .or. mCAT = "12" .or. mCAT = "19" .or. mCAT = "20" ;
                    .or. mCAT = "21"
            nGRUP02 := 1
         endif
         mADM := strzero(day(ADMITIDO),2)+strzero(month(ADMITIDO),2)+strzero(year(ADMITIDO),4)
         mDFG := strzero(day(FGTS),2)+strzero(month(FGTS),2)+strzero(year(FGTS),4)
         mDEM := strzero(day(DEMITIDO),2)+strzero(month(DEMITIDO),2)+strzero(year(DEMITIDO),4)
         mNAS := strzero(day(NASC),2)+strzero(month(NASC),2)+strzero(year(NASC),4)
         mCEP := substr(CEP,1,5)+substr(CEP,7,3)
         do case
         case K = 1
            G2R13()
         case K = 2
            G2R14()
         case K = 3
            G2R30(2)
            G2R32(2)
         endcase
         DBSELECTAR(PES)
         dbskip()
      enddo
   endif
   if INCDIR = "S" .and. K = 3  //Diretores
      aCTA01 := PEGRELCTA("FGTSD01")
      aCTA02 := PEGRELCTA("FGTSD02")
      aCTA03 := PEGRELCTA("FGTSD03")
      aCTA04 := PEGRELCTA("FGTSD04")
      DBSELECTAR(cSELE4)
      dbgotop()
      while !eof()
         PETELA(8)
         mNUMERO := NUMERO
         mPIS    := PIS
         mCAT    := CATEGORIA
         mOCO    := OCOFGTS
         mCI     := CI
         if empty(mPIS)
            mPIS := "1"+space(10)
         endif
         if empty(mCAT)
            mCAT := "11"
         endif
         if empty(mOCO)
            mOCO := "1"
         endif
         nGRUP01 := 2
         if mCAT = "01" .or. mCAT = "02" .or. mCAT = "03" .or. mCAT = "04" .or. mCAT = "05" .or. mCAT = "12"
            nGRUP01 := 1
         endif
         nGRUP02 := 2
         if mCAT = "01" .or. mCAT = "03" .or. mCAT = "04" .or. mCAT = "05" ;
                    .or. mCAT = "06" .or. mCAT = "07" .or. mCAT = "11" ;
                    .or. mCAT = "12" .or. mCAT = "19" .or. mCAT = "20" ;
                    .or. mCAT = "21"
            nGRUP02 := 1
         endif
         mADM := strzero(day(ADMITIDO),2)+strzero(month(ADMITIDO),2)+strzero(year(ADMITIDO),4)
         mDFG := strzero(day(FGTS),2)+strzero(month(FGTS),2)+strzero(year(FGTS),4)
         mDEM := strzero(day(DEMITIDO),2)+strzero(month(DEMITIDO),2)+strzero(year(DEMITIDO),4)
         mNAS := strzero(day(NASC),2)+strzero(month(NASC),2)+strzero(year(NASC),4)
         mCEP := substr(CEP,1,5)+substr(CEP,7,3)
         G2R30(5)
         G2R32(5)
         DBSELECTAR(cSELE4)
         dbskip()
      enddo
   endif
next K
dbcloseall()

fwrite(USO,"90")  //1          //90 Totalizador
fwrite(USO,repl("9",51))  //2
fwrite(USO,space(306))  //3
fwrite(USO,"*")   //4
if mDELIM = "S"
   fwrite(USO,chr(13)+chr(10))
endif
IF mCHR26 = "S"
   fwrite(USO,chr(26))
ENDIF
fclose(USO)

if MDG("Deseja Ver o Arquivo")
   VERTXT(ARQUIVO)
endif
if MDG("Deseja imprimir o Arquivo")
   imparq(ARQUIVO,,,,,,,360,)
endif

ALERTX("N„o Esque‡a de Utilizar o Validador")

retu


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function TIRACX()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func TIRACX(cVAR,nLEN,nDEC,cREP)

IF VALTYPE(cVAR) # "C"
   IF VALTYPE(nLEN) = "N" .AND. VALTYPE(nDEC) = "N"
      cVAR := STRVAL(cVAR,nLEN,nDEC)
   ELSE
      cVAR := STRVAL(cVAR,nLEN,nDEC)
   ENDIF
ENDIF
IF VALTYPE(cREP) # "C"
   cREP := " "
ENDIF
cVAR := TIRACE(cVAR)
cVAR := strtran(cVAR,"/",cREP)
cVAR := strtran(cVAR,"-",cREP)
cVAR := strtran(cVAR,".",cREP)
cVAR := strtran(cVAR,",",cREP)
cVAR := strtran(cVAR,":",cREP)
cVAR := strtran(cVAR,"&",cREP)
cVAR := strtran(cVAR,"  ",cREP)   //Duplos Espacos
cVAR := ALLTRIM(cVAR)
IF VALTYPE(nLEN) = "N"
   cVAR := padr(alltrim(cVAR),nLEN)
ENDIF
retu cVAR


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FWRITX()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func FWRITX(cVAR,nLEN,nDEC,nTIP)


if valtype(nTIP) # "N"
   nTIP := 0
endif
do case
case valtype(cVAR) = "N"
   cVAR := strzero(cVAR,nLEN)
case valtype(cVAR) = "C" .and. nTIP = 1
   cVAR := strzero(val(cVAR),nLEN)
case valtype(cVAR) = "C"
   cVAR := TIRACX(cVAR,nLEN)
endcase
fwrite(USO,cVAR)
retu


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function G2R13()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func G2R13


if val(mCAT) > 10   //cAT 11,12,13,14,15,16,17
   if ALTFGTS = "404" .or. ALTFGTS = "405"
   else
      retu .T.
   endif
endif
if mMESYYY = "13"
   retu
endif
if !empty(ALTFGTS) .and. ALTFGTS # "END"  //13  Alteracao cadastral do trabalhador.
   cCAMPO := ""
   do case
   case ALTFGTS = "403"
      cCAMPO := substr(PROFIS,1,7)+substr(SERIE,1,5)
   case ALTFGTS = "404"
      cCAMPO := NOME
   case ALTFGTS = "405"
      cCAMPO := PIS
   case ALTFGTS = "406"
      cCAMPO := NUMERO
   case ALTFGTS = "408"
      cCAMPO := mADM
   case ALTFGTS = "426"
      cCAMPO := mUNIDADE
   case ALTFGTS = "427"
      cCAMPO := OBTER("FUNCAO",,FUNCAO,"CBONEW")  //CBONEW CBONEW
   case ALTFGTS = "428"
      cCAMPO := mNAS
   endcase
   FWRITX("13",2)   //1
   FWRITX(TIPREP,1,,1)  //2
   FWRITX(INSREP,14,,1)   //3
   FWRITX(repl("0",36),36,,1)   //4
   if nGRUP01 = 1
      FWRITX(mPIS,11,,1)  //5
   else
      FWRITX(mCI,11,,1)   //5
   endif
   if nGRUP02 = 1
      FWRITX(mADM,8)  //6
   else
      fwrite(USO,space(8))  //6
   endif
   FWRITX(mCAT,2,,1)  //11
   if val(mCAT) > 12
      fwrite(USO,space(11))   //7
   else
      FWRITX(mNUMERO,11,,1)   //7
   endif
   if mCAT = "01" .or. mCAT = "02" .or. mCAT = "03" .or. mCAT = "04"
      FWRITX(substr(PROFIS,1,7),7,,1)   //8
      FWRITX(substr(SERIE,1,5),5,,1)  //9
   else
      fwrite(USO,space(7))
      fwrite(USO,space(5))
   endif
   FWRITX(NOME,70)  //10
   if val(mCAT) < 6
      FWRITX(mCODCAI,14,,1)   //12
      FWRITX(CONTAFGTS,11,,1)   //13
   else
      fwrite(USO,space(14))
      fwrite(USO,space(11))
   endif
   FWRITX(ALTFGTS,3,,1)   //14
   FWRITX(cCAMPO,70)  //15
   fwrite(USO,space(94))  //16
   FWRITX("*",1)  //17
   if mDELIM = "S"
      fwrite(USO,chr(13)+chr(10))
   endif
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function G2R14()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func G2R14


//FWRITE(USO,"14") 14  Alteracao do endere‡o do trabalhador.
if nGRUP01 = 1 .or. mCAT = "11"
else
   retu .T.
endif
if mMESYYY = "13"
   retu
endif

if (month(ADMITIDO) = MES .and. year(ADMITIDO) = ANO) .or. (ALTFGTS = "END")
   FWRITX("14",2)   //1
   FWRITX(TIPREP,1,,1)  //2
   FWRITX(INSREP,14,,1)   //3
   FWRITX(repl("0",36),36,,1)   //4
   FWRITX(mPIS,11,,1)   //5
   if mCAT = "11"
      fwrite(USO,space(8))  //16
   else
      FWRITX(mADM,8)  //6
   endif
   FWRITX(mCAT,2,,1)  //8
   FWRITX(NOME,70)  //7
   if mCAT = "11" .or. mCAT = "12" .or. mCAT = "05"
      fwrite(USO,space(7))  //16
      fwrite(USO,space(5))  //16
   else
      FWRITX(substr(PROFIS,1,7),7,,1)   //9
      FWRITX(substr(SERIE,1,5),5,,1)  //10
   endif
   FWRITX(ENDER+","+alltrim(ENDNUM)+" "+alltrim(ENDCOMPL),50)   //11
   FWRITX(BAIRRO,20)  //12
   FWRITX(mCEP,8,,1)  //13
   FWRITX(CIDADE,20)  //14
   FWRITX(ESTADO,2)   //15
   fwrite(USO,space(103))   //16
   FWRITX("*",1)  //17
   if mDELIM = "S"
      fwrite(USO,chr(13)+chr(10))   //INDICA FINAL DE REGISTRO
   endif
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function G2R30()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func G2R30(nSELE)


nVAL01 := nVAL02 := nVAL03 := nVAL04 := nVAL10 := nVAL11 := 0

//nVAL1 Remuneracao sem 13o (Destinado ainformacao da remuneracao paga, devida ou creditada ao trabalhador no mes, conforme base de incidencia registrada na p gina 04 do Manual. Excluir do valor da remuneracao o 13§ sal rio pago no mes. 146 160 15 V Opci
//nVAL2 Remuneracao sobre 13o  (Destinado ainformacao da parcela de  13§ sal rio pago no mes ao trabalhador). 161 175 15 V Este campo nÆo deve ser informado para a competencia AAAA13 . Somente acatar a informacao de 13o sal rio das categorias de trabalha
//nVAL3 Mult¡plos V¡nculos - Valor Retido Segurado (Destinado ainformacao do valor da contribuicao do trabalhador que possuir mais de um v¡nculo empregat¡cio. O valor informado ser  considerado como contribuicao do segurado) 182 196 15 V Campo opcional p
//nVAL4 Base de C lculo 13o  Sal rio Previdencia Social (Indicar o valor total do 13§ sal rio pago no ano ao trabalhador. Sobre o valor informado incide contribuicao previdenci ria) 197 211 15 V Campo obrigat¢rio para a competencia AAAA13 e opcional para
//Nval10 Segurado/Exercito
//nval11 Complemento/13

if nSELE = 2
   DBSELECTAR(cSELE2)
else
   DBSELECTAR(cSELE5)
endif
dbgotop()
dbseek(mNUMERO * 10000)
while mNUMERO = NUMERO .and. !eof()
   for X := 1 to 15
      if aCTA01[X] = CONTA
         nVAL01 += VALOR
      endif
      if aCTA02[X] = CONTA
         nVAL02 += VALOR
      endif
      if aCTA03[X] = CONTA
         nVAL03 += VALOR
      endif
      if aCTA04[X] = CONTA
         nVAL04 += VALOR
      endif
      if aCTA10[X] = CONTA
         nVAL10 += VALOR
      endif
      if aCTA11[X] = CONTA
         nVAL11 += VALOR
      endif
   next X
   dbskip()
enddo
if nSELE = 2
   DBSELECTAR(PES)
else
   DBSELECTAR(cSELE4)
endif
if mMESYYY = "13"
   nVAL01 := 0
   nVAL02 := 0
   nVAL03 := 0
   nVAL10 := 0
   nVAL11 := 0
endif
cVAL01 := GRVVAL(nVAL01,15,2)
cVAL02 := GRVVAL(nVAL02,15,2)
cVAL03 := GRVVAL(nVAL03,15,2)
cVAL04 := GRVVAL(nVAL04,15,2)
cVAL10 := GRVVAL(nVAL10,15,2)
cVAL11 := GRVVAL(nVAL11,15,2)

if (nVAL01+nVAL02+nVAL03+nVAL04+nVAL10+nVAL11 > 0) .or. (month(DEMITIDO) = MES .and. year(DEMITIDO) = ANO)
   FWRITX("30",2)   //1   //30  Registro de empregado.
   FWRITX(TIPREP,1,,1)  //2
   FWRITX(INSREP,14,,1)   //3
   FWRITX(cTOM1,1)  //4 Tomador em Branco
   FWRITX(cTOMA,14)   //5 Tomador insc em branco
   if nGRUP01 = 1
      FWRITX(mPIS,11,,1)  //5
   else
      FWRITX(mCI,11,,1)   //5
   endif
   if nGRUP02 = 1
      FWRITX(mADM,8)  //6
   else
      fwrite(USO,space(8))  //6
   endif
   FWRITX(mCAT,2,,1)  //18
   FWRITX(NOME,70)  //9
   if val(mCAT) > 12
      fwrite(USO,space(11))
   else
      FWRITX(mNUMERO,11,,1)
   endif
   if val(mCAT) < 7 .and. mCAT # "02" .and. mCAT # "05"
      FWRITX(substr(PROFIS,1,7),7,,1)   //8
      FWRITX(substr(SERIE,1,5),5,,1)  //9
   else
      fwrite(USO,space(7))
      fwrite(USO,space(5))
   endif
   if val(mCAT) < 7 .and. mCAT # "02"
      FWRITX(mDFG,8)  //13
   else
      fwrite(USO,space(8))
   endif
   if nGRUP01 = 1
      FWRITX(mNAS,8)  //14
   else
      fwrite(USO,space(8))
   endif

   //   IF EMPTY(CBONEW)
   //      FWRITX( CBO, 5 )                     //15
   //   ELSE
   FWRITX("0"+LEFT(OBTER("FUNCAO",,FO_PES->FUNCAO,"CBONEW"),4),5)
   //ENDIF

   FWRITX(cVAL01,15)  //16
   FWRITX(cVAL02,15)  //17
   if !empty(CLASSE) .and. CLASSE < 11 .and. mMESYYY <> "13"
      FWRITX(CLASSE,2,,1)   //18
   else
      FWRITX("  ",2)  //18
   endif
   if mCAT = "01" .or. mCAT = "02" .or. mCAT = "04" .or. mCAT = "12"
      FWRITX(mOCO,2,,1)   //19
   else
      FWRITX("  ",2)
   endif
   FWRITX(cVAL03,15)  //20
   FWRITX(cVAL10,15)  //21
   FWRITX(cVAL04,15)  //22
   FWRITX(cVAL11,15)  //23
   fwrite(USO,space(98))  //24
   FWRITX("*",1)  //25
   if mDELIM = "S"
      fwrite(USO,chr(13)+chr(10))
   endif
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function G2R32()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func G2R32(nTIP)


if nGRUP01 = 1 .or. mCAT = "11"
else
   retu .T.
endif
if mMESYYY = "13"
   retu
endif

if month(DEMITIDO) = MES .and. year(DEMITIDO) = ANO
   FWRITX("32",2)   //1   //32 Movimento Empregado demiss„o
   FWRITX(TIPREP,1,,1)  //2
   FWRITX(INSREP,14,,1)   //3
   FWRITX(cTOM1,1)  //4 Tomador em Branco
   FWRITX(cTOMA,14)   //5 Tomador insc em branco
   if nGRUP01 = 1
      FWRITX(mPIS,11,,1)  //6
   else
      FWRITX(mCI,11,,1)   //6
   endif
   if nGRUP02 = 1
      FWRITX(mADM,8)  //7
   else
      fwrite(USO,space(8))  //7
   endif
   FWRITX(mCAT,2,,1)  //8
   FWRITX(NOME,70)  //9
   FWRITX(FGTSMOT,2)  //10
   FWRITX(mDEM,8)   //11
   if left(FGTSMOT,1) = "I" .or. left(FGTSMOT,1) = "L"
      FWRITX(PGFGTS,1)  //12
   else
      FWRITX(" ",1)   //12
   endif
   fwrite(USO,space(225))   //13
   FWRITX("*",1)  //14
   if mDELIM = "S"
      fwrite(USO,chr(13)+chr(10))
   endif
endif
if nTIP = 5
   retu .T.
endif
DBSELECTAR("FO_OCO")
dbgotop()
dbseek(str(mNUMERO,8))
while mNUMERO = NUMERO .and. !eof()
   IF !EMPTY(CODFGS)
      if (month(DATASAIDA) = MES .and. year(DATASAIDA) = ANO) .OR. ;
                         (month(DATARETORN) = MES .and. year(DATARETORN) = ANO)
         mDATASAIDA := strzero(day(DATASAIDA),2)+strzero(month(DATASAIDA),2)+strzero(year(DATASAIDA),4)
         FWRITX("32",2)   //1   //32 Movimento Empregado demiss„o
         FWRITX(TIPREP,1,,1)  //2
         FWRITX(INSREP,14,,1)   //3
         FWRITX(cTOM1,1)  //4 Tomador em Branco
         FWRITX(cTOMA,14)   //5 Tomador insc em branco
         if nGRUP01 = 1
            FWRITX(mPIS,11,,1)  //6
         else
            FWRITX(mCI,11,,1)   //6
         endif
         if nGRUP02 = 1
            FWRITX(mADM,8)  //7
         else
            fwrite(USO,space(8))  //7
         endif
         FWRITX(mCAT,2,,1)  //8
         FWRITX(mNOME,70)   //9
         FWRITX(CODFGS,2)   //10
         FWRITX(mDATASAIDA,8)   //11
         FWRITX(PGFGS,1)  //12
         fwrite(USO,space(225))   //13
         FWRITX("*",1)  //14
         if mDELIM = "S"
            fwrite(USO,chr(13)+chr(10))
         endif
      endif
      if month(DATARETORN) = MES .and. year(DATARETORN) = ANO
         mDATARETOR := strzero(day(DATARETORN),2)+strzero(month(DATARETORN),2)+strzero(year(DATARETORN),4)
         FWRITX("32",2)   //1   //32 Movimento Empregado demiss„o
         FWRITX(TIPREP,1,,1)  //2
         FWRITX(INSREP,14,,1)   //3
         FWRITX(cTOM1,1)  //4 Tomador em Branco
         FWRITX(cTOMA,14)   //5 Tomador insc em branco
         FWRITX(mPIS,11,,1)   //6
         FWRITX(mADM,8)   //7
         FWRITX(mCAT,2,,1)  //8
         FWRITX(mNOME,70)   //9
         FWRITX(CODFGR,2)   //10
         FWRITX(mDATARETOR,8)   //11
         FWRITX(PGFGR,1)  //12
         fwrite(USO,space(225))   //13
         FWRITX("*",1)  //14
         if mDELIM = "S"
            fwrite(USO,chr(13)+chr(10))
         endif
      endif
   ENDIF
   dbskip()
enddo
retu .T.


*+ EOF: fohg2.prg
*+
