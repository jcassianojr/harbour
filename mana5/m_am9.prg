*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_am9.prg
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
*+    Function M_am9()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function M_am9

para cARQ
mESTADO := "  "
ZESTADO := OBTER("MANEMP",ZNUMERO,"ESTADO")
ARQUSO  := ""
xDAT01  := CTOD(SPACE(8))
CRIARVARS("ML01")

PADRAO(0,1,0,cARQ,"Lote  Nota Fiscal  Data     Cliente/Fornecedor CFO   CodRec Valor",;
 "' '+STR(mLOTE,5)+' '+STR(mNUMERO,8)+' '+STR(mITEM,3)+' '+DTOC(mDATA)+' '+STR(mFORNECEDO,5)+' '+mCOGNOME+' '+mDCFONEW+' '+mCODREC+' '+STR(mDVALORNF,15,2)",;
 "M9",,,{|| ULTIMOREG(cARQ,"LOTE","mLOTE")} ;
 ,,,{|| M9POSIGU()},,,{|| M9POSREP()})




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function M9POSIGU()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC M9POSIGU

//ALERTX("EQU")
xDAT01 := mDAT01
RETU .F.  //Para Continuar


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function M9POSREP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC M9POSREP

//ALERTX("REP")
if cARQ = "MK09"
   CPAGA := if(INCLUI,OBTER("MD04",mDCFONEW,"CONTAS",2,,,,,"S"),"N")
   @ 24,00 clea
   @ 24,05 say "Transfere Dados para o Contas a Pagar <S/N> ?  " get CPAGA pict '@!' valid CPAGA $ 'SN'      
   READCUR()
   IF cPAGA = "S"
      mNRNOTA    := mNUMERO
      mVENCIMENT := mDAT01
      mTIPOCLI   := mTIPOFOR
      mVALOR     := mVAL01
      mVALATUAL  := mVAL01
      mCOD       := mCODDEP
      mTIPFAT    := " "
      //Evita Conflito mesmo Campo
      mSITUACAO := 0
      //Apaga o Da Data Antiga Evitar Erro
      APAGAREG("ML01",dtos(xDAT01)+str(mNRNOTA,8)+mTIPFAT,.F.)
      APAGAREG("ML01",dtos(mVENCIMENT)+str(mNRNOTA,8)+mTIPFAT,.F.)
      NOVOREG("ML01",dtos(mVENCIMENT)+str(mNRNOTA,8)+mTIPFAT)
   ENDIF
endif
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MM09IMP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MM09IMP(cTIPO)

MDI(" Ý Importando Notas")
if cTIPO = "E"
   aRETU := PERFEC({"MK01"},{"K1"},{"MK91"},{"DATAREF"})
else
   aRETU := PERFEC({"MM01"},{"M1"},{"MM91"},{"DATAREF"})
endif
nMESUSO := aRETU[1]
nANOUSO := aRETU[2]
cARQ    := aRETU[5,1]
if cTIPO = "E"
   cDES := "MK09"
else
   cDES := "MM09"
endif
if !USEMULT({{cDES,1,99},{cARQ,1,0},{"MB01",1,1}})
   retu .F.
endif
dbselectar(cDES)
INITVARS()
CLRVARS()
dbselectar(cARQ)
INITVARS()
CLRVARS()
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
IF cTIPO = "E"
   ordDestroy("temp")
   ordcreate(,"temp","dataref")
   ordSetFocus("temp")   
ELSE
   ordDestroy("temp")
   ordcreate(,"temp","data")
   ordSetFocus("temp")
ENDIF
dbgotop()
while !eof()
   @ 24,00 SAY RECNO()         
   if ESPECIE = "NFS"
      EQUVARS()
      mESPECIE := ""
      mSERIE   := ""
      mCODREC  := ""
      IF mTIPOCLI = "F"
         dbselectar("MB01")
         dbgotop()
         if dbseek(mFORNECEDO)
            mESPECIE := NFSESP
            mSERIE   := NFSSER
            mCODREC  := NFSCOD
         ENDIF
      ENDIF
      if cTIPO = "E"
         mNUMERO := mNRNOTA
      endif
      dbselectar(cDES)
      dbgotop()
      if !dbseek(str(mNUMERO,8)+str(mFORNECEDO,8))
         mITEM     := 1
         mSITUACAO := 'T'
         if cTIPO = "E"
            mNUMERO := mNRNOTA
         endif
         if cTIPO = "S"
            mDATAREF := mDATA
            mORDEM   := mNUMERO
         endif
         mDVALORNF := mTOTNF
         mTIPOFOR  := mTIPOCLI
         mDCFONEW  := mCFONEW
         //         mDBASEICM := mTOTBICM
         mDICM    := mICM
         mDVALICM := mTOTICM
         PEGLOTE(IF(cTIPO = "E",5,6),mDATAREF,"mLOTE")
         if cTIPO = "E"
            mORDEM := mLOTE
         endif
         NOVOOPA(cDES)
      endif
   endif
   dbselectar(cARQ)
   dbskip()
enddo
dbcloseall()
release all like m*


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MM09DES()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MM09DES(cTIPO,cLAY)

IF VALTYPE(cTIPO) # "C"
   cTIPO := "S"
ENDIF
IF VALTYPE(cLAY) # "C"
   cLAY := "SP"
   IF MDG("SIM=GIS NAO=SP")
      cLAY := "GIS"
   ENDIF
ENDIF
set centurY on
ARQ := "C:\TEMP\DES.TXT"+SPACE(40)
MDS("Confirme o Arquivo")
@ 24,20 GET ARQ         
IF !READCUR()
   RETU .F.
ENDIF
IF cTIPO = "E"
   aRETU := PERFEC({"MK01","MK09"},{"K1","K9"},{"MK91","MK90"})
ELSE
   aRETU := PERFEC({"MM01","MM09"},{"M1","M9"},{"MM91","MM90"})
ENDIF
nMES         := aRETU[1]
nANO         := aRETU[2]
ARQWORK1     := aRETU[5,1]
ARQWORK2     := aRETU[5,2]
mCOMPETENCIA := aRETU[7]
mCGCUSO      := TIRAOUT(OBTER("MANEMP",ZNUMERO,"CGC"))

if !USEMULT({{ARQWORK1,1,1},{ARQWORK2,1,0},{"MA01",1,1},{"MB01",1,1}})
   retu .F.
endif


USO := fcreate(ARQ)
IF FERROR() # 0
   ALERTX("Erro na Cria‡„o do Arquivo")
   RETU
ENDIF


dbselectar(arqwork2)
dbgotop()
while !eof()
   xFORNECEDO := FORNECEDO
   mCGCFORN   := ""
   mCIDADE    := ""
   mUF        := ""
   mTIPOFOR   := TIPOFOR
   mPESSOA    := " "
   mNOME      := ""
   mCCM       := ""
   mIE        := ""
   mCEP       := ""
   mEND       := ""
   mBAI       := ""
   dbselectar(if(mTIPOFOR = "C","MA01","MB01"))
   dbgotop()
   if dbseek(xFORNECEDO)
      mCCM    := ALLTRIM(IMUNICIPI)
      mCIDADE := TIRACE(CIDADE)
      mUF     := ESTADO
      mPESSOA := PESSOA
      mNOME   := TIRACE(NOME)
      mCEP    := CEP
      mEND    := TIRACE(ENDERECO)
      mBAI    := TIRACE(BAIRRO)
      mIE     := if(mTIPOFOR = "C",INSCR,IESTADUAL)
      IF PESSOA = "F"
         mCGCFORN := "000"+ALLTRIM(TIRAOUT(CGC))
         IF !VALCPF(CGC)
            ALERTX(STR(xFORNECEDO,8)+" "+CGC)
         ENDIF
      ELSE
         IF ! VALCGC(CGC,,,mUF)
            ALERTX(STR(xFORNECEDO,8)+" "+CGC)
         ENDIF
         mCGCFORN := ALLTRIM(TIRAOUT(CGC))
      ENDIF
   else
      ALERTX(STR(xFORNECEDO,8)+" Nao Encontrado")
   endif
   mCGCFORN := STRZERO(VAL(mCGCFORN),14)  //Possiveis Erros de Tipo
   dbselectar(ARQWORK2)
   cESPECIE := padr(especie,5)
   IF cLAY = "SP"
      IF EMPTY(cESPECIE)
         IF mCIDADE = "SAO PAULO"
            cESPECIE := "NFS  "
         ELSE
            cESPECIE := "FORA "
         ENDIF
      ENDIF
      IF cESPECIE = "NFS  " .AND. mCIDADE = "SAO PAULO" .AND. SERIE = "UN"
         ALERTX("Verificar NF: "+STR(NUMERO,8)+"SAO PAULO NFS UN")
      ENDIF
      FWRITE(USO,mCGCUSO)   //1-cgc
      FWRITE(USO,cESPECIE)  //2-especie tipo NFS,RPA....
      IF EMPTY(SERIE)
         FWRITE(USO,padr("-",5))  //3-serie
      ELSE
         FWRITE(USO,padr(serie,5))
      ENDIF
      FWRITE(USO,strzero(numero,8))   //4-numero
      FWRITE(USO,dtoc(dataref))   //5-data
      FWRITE(USO,GRVVAL(DVALORNF,15,2))   //6-valor do documento
      FWRITE(USO,STRZERO(VAL(codrec),5))  //7-codigo recolhimento
      FWRITE(USO,GRVVAL(DBASEICM,15,2))   //8-valor da base ICM = ISS
      FWRITE(USO,mCGCFORN)  //9 cgc do tomador
      FWRITE(USO,mUF)   //10 UF
      FWRITE(USO,PADR(mCIDADE,50))  //11 CIDADE
      FWRITE(USO,PADR(TIRACE(OBS),200))   //12 OBS
      FWRITE(USO,CHR(13)+CHR(10))
   ENDIF
   IF cLAY = "GIS"
      FWRITE(USO,"T")   //1
      FWRITE(USO,strzero(numero,10))  //2
      FWRITE(USO,padr(serie,10))  //3
      FWRITE(USO,dtoc(dataref))   //4
      FWRITE(USO,SITUACAO)  //5 1-NORMAL 4-ISENTA 3-ANULADA 5-RETIDA
      FWRITE(USO,GRVVAL(DVALORNF,12,2))   //6
      FWRITE(USO,padr(codrec,10))   //7
      IF mPESSOA = "F"
         FWRITE(USO,"1")  //8
      ELSE
         FWRITE(USO,"2")  //8
      ENDIF
      FWRITE(USO,"S")   //9
      FWRITE(USO,padr(mNOME,100))   //10
      mDIG := "  "
      nLEN := LEN(mCCM)
      IF nLEN > 0
         IF SUBSTR(mCCM,nLEN - 2,1) = "-"
            mDIG := SUBSTR(mCCM,nLEN - 1)
            mCCM := SUBSTR(mCCM,1,nLEN - 2)
         ENDIF
         IF SUBSTR(mCCM,nLEN - 1,1) = "-"
            mDIG := "0"+SUBSTR(mCCM,nLEN)
            mCCM := SUBSTR(mCCM,1,nLEN - 1)
         ENDIF
      ENDIF
      FWRITE(USO,STRZERO(VAL(TIRAOUT(mCCM)),10))  //11 Imunicipi
      FWRITE(USO,mDIG)  //12 digito
      FWRITE(USO,mCGCFORN)  //13
      IF mIE = "ISENTO"
         FWRITE(USO,"S")  //14
         FWRITE(USO,repl("0",15))   //15
      ELSE
         FWRITE(USO,"N")  //14
         FWRITE(USO,STRZERO(VAL(TIRAOUT(mIE)),15))  //15
      ENDIF
      FWRITE(USO,STRZERO(VAL(TIRAOUT(mCEP)),8))   //16
      FWRITE(USO,SPACE(5))  //17
      FWRITE(USO,SPACE(5))  //18
      FWRITE(USO,PADR(mEND,50))   //19
      FWRITE(USO,SPACE(40))   //20
      FWRITE(USO,SPACE(10))   //21
      FWRITE(USO,PADR(mBAI,50))   //22
      FWRITE(USO,mUF)   //23
      FWRITE(USO,PADR(mCIDADE,50))  //24
      FWRITE(USO,"D")   //25
      FWRITE(USO," ")   //26
      FWRITE(USO,SPACE(10))   //27
      FWRITE(USO,CHR(13)+CHR(10))
   ENDIF
   dbselectar(ARQWORK2)
   dbskip()
enddo
//FWRITE(USO,CHR(26))
FCLOSE(ARQ)
set centurY off
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MM09VOL()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MM09VOL

MDI(" Ý Importar Gerado Des")
aRETU   := PERFEC({"MK01","MK09"},{"K1","K9"},{"MK91","MK99"},{"DATAREF","DATAREF"})
nMESUSO := aRETU[1]
nANOUSO := aRETU[2]
cARQNF  := aRETU[5,1]
cARQ    := aRETU[5,2]

cARQUIVO := "C:\TEMP\DES.TXT"+SPACE(40)
@ 24,00 GET cARQUIVO         
IF !READCUR()
   RETU .F.
ENDIF
cARQUIVO := ALLTRIM(CARQUIVO)
IF ! file(cARQUIVO)
   ALERTX("Arquivo Des NÆo Encontrado")
   RETU .F.
ENDIF


IF !USEMULT({{cARQ,1,99},{cARQNF,1,99},{"MB01",1,ZIMB},{"MA01",1,ZIMA}})
   RETU .F.
ENDIF

DBSELECTAR(cARQ)
INITVARS()
CLRVARS()
nHANDLE := fopen(cARQUIVO)
IF nHANDLE <= 0
   DBCLOSEALL()
   ALERTX("Erro Abrindo "+Carquivo)
   RETU .F.
ENDIF


WHILE .T.
   cVAR := FREADLINE(nHANDLE)
   @ 23,00 SAY cVAR         
   IF cVAR = "__FINAL__"
      exit
   endif
   mITEM     := 1
   mSITUACAO := 'T'
   mESPECIE  := SUBSTR(cVAR,15,5)
   mSERIE    := SUBSTR(cVAR,20,5)
   mNUMERO   := VAL(SUBSTR(cVAR,25,8))
   mDATA     := CTOD(SUBSTR(cVAR,33,10))
   mDATAREF  := mDATA
   mDVALORNF := VAL(SUBSTR(cVAR,43,15)) / 100
   mCODREC   := SUBSTR(cVAR,58,5)
   mDBASEICM := VAL(SUBSTR(cVAR,63,15)) / 100
   mCGC      := SUBSTR(cVAR,78,14)
   IF LEFT(mCGC,3) = "000"  //CPF
      mCGC := SUBSTR(mCGC,4,3)+"."+SUBSTR(mCGC,7,3)+"."+SUBSTR(mCGC,10,3)+"-"+SUBSTR(mCGC,13,2)
   ELSE
      mCGC := LEFT(mCGC,2)+"."+SUBSTR(mCGC,3,3)+"."+SUBSTR(mCGC,6,3)+"/"+SUBSTR(mCGC,9,4)+"-"+SUBSTR(mCGC,13,2)
   ENDIF
   mFORNECEDO := 0
   mCOGNOME   := ""
   mTIPOFOR   := "F"
   mESPECIE   := ""
   mSERIE     := ""
   mCODREC    := ""
   DBSELECTAR("MB01")
   DBGOTOP()
   IF DBSEEK(mCGC)
      mFORNECEDO := NUMERO
      mCOGNOME   := COGNOME
      mESPECIE   := NFSESP
      mSERIE     := NFSSER
      mCODREC    := NFSCOD
   ENDIF
   IF mFORNECEDO = 0  //Tenta Cliente
      DBSELECTAR("MA01")
      DBGOTOP()
      IF DBSEEK(mCGC)
         mFORNECEDO := NUMERO
         mCOGNOME   := COGNOME
         mTIPOFOR   := "C"
      ENDIF
   ENDIF
   IF mFORNECEDO > 0
      DBSELECTAR(cARQNF)
      DBGOTOP()
      IF DBSEEK(STR(mNUMERO,8)+STR(mFORNECEDO,5))
         mDCFONEW := CFONEW
         mDATA    := DATA
      ENDIF
   ENDIF
   PEGLOTE(5,mDATAREF,"mLOTE")
   mORDEM := mLOTE
   NOVOOPA(cARQ)
ENDDO
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MM09LOTE()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MM09LOTE(cTIPO)

IF cTIPO = "E"
   aRETU := PERFEC({"MK09"},{"K9"},{"MK90"})
ELSE
   aRETU := PERFEC({"MM09"},{"M9"},{"MM90"})
ENDIF
nMES  := aRETU[1]
nANO  := aRETU[2]
cARQ  := aRETU[5,1]
nLOTE := 1
IF !MDG("Ajustar Lotes "+aRETU[7])
   RETU .F.
ENDIF
IF !USEREDE(cARQ,1,0)
   RETU .F.
ENDIF
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","DATAREF")
ordSetFocus("temp")
DBGOTOP()
WHILE !EOF()
   GRAVACAMPO({"LOTE","ORDEM"},{"nLOTE","nLOTE"})
   nLOTE ++
   DBSKIP()
ENDDO
DBCLOSEALL()
M_DB("ARQUIVO='"+cARQ+"'")


