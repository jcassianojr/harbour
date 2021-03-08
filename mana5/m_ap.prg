*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ap.prg
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

// :*****************************************************************************
// :
// :   M_AP   .PRG : Cadastro de M„o de Obra
// :   Linguagem   : Clipper 5.X
// :        Sistema: MANA5
// :      Copyright (c) 1997, Softec Sistemas S/C Ltda.
// :
// :*****************************************************************************

//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_ap()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_ap

Para ARQWORK
PRIV xESTQINI := 0
PADRAX(0,,0,{ARQWORK,ARQWORK+"A",ARQWORK+"I"},"C¢digo"+spac(7)+"Nome"+spac(27)+"Qtde M¡nima  Custo",;
 "' '+mCODIGO+' '+mNOME+' '+STR(mQTDEMIN,12,2)+' '+STR(mVALOR,12,2)","MAP001","MAP001",;
 ,{|| PADDEL(ARQWORK+"A",xCHAVE,"CODIGO","xCHAVE")},{|| MAP01()},,"MAP",{|| xESTQINI := mESTQINI})
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ETI()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC ETI

PRIV xESTQINI
PADRAX(0,,0,{"ETI","MP03I"},"C¢digo"+spac(7)+"Nome",;
 "' '+mCODIGO+' '+mNOME","ETI001","ETI001",;
 ,{|| PADDEL("MP03I",xCHAVE,"CODIGO","xCHAVE")},{|| MPINS("MP03I")},,"ETI")
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MPINS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MPINS(cARQ)

IF MDG("Verificar Sequencia de Ensaios")
   xCODIGO := ALLTRIM(mCODIGO)
   PADRAO(1,1,0,cARQ,"Codigo"+spac(19)+"Ite Tip Especificado",;
    "' '+mCODIGO+' '+STR(mITEM,  3)+' '+mTIPA+' '+mESPE",;
    "MSI","MSI","MSI",;
    {|| mCODIGO := xCODIGO},{|| PADARR(cARQ,xCODIGO,"CODIGO","xCODIGO")})
ENDIF
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ETI02()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC ETI02(cCHAVE)

RETU PADR(OBTER("ETI",cCHAVE,"ALLTRIM(NOME)+' '+ALLTRIM(CAMADA)+' '+ALLTRIM(SALTO)+' '+ALLTRIM(ESPE)+' '+ALLTRIM(SUPE)"),200)


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAP01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAP01

IF MDG("Verificar Prioridades de Distribui‡Æo")
   xCODIGO := mCODIGO
   PADRAO(1,1,0,ARQWORK+"A","Maq          Seq Codigo        Mao de Obra",;
    "' '+mCODIGO+' '+STR(mSEQ,  3)+' '+mCODMPSB+' '+mNOMMPSB",;
    "MAPA","MAPA01","MAPA01",;
    {|| mCODIGO := xCODIGO},{|| PADARR(ARQWORK+"A",xCODIGO,"CODIGO","xCODIGO")})
ENDIF
MPINS(ARQWORK+"I")
RETU .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function M_AP5()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC M_AP5

MDI("Lan‡ar Balanco de Horas")
cTIPO1 := "M"
cTIPO2 := "M"
nDIAS  := 1
@ 22,00 SAY "(E)quipamentos (H)omem (T)ratamento"                                     
@ 23,00 SAY "(M)ensal (S)emanal (D)iario"                                             
@ 24,00 SAY "Digite os Tipos"                                                         
@ 24,20 GET cTIPO1                                PICT "!" VALID cTIPO1 $ "EHT"       
@ 24,25 GET cTIPO2                                PICT "!" VALID cTIPO2 $ "MSD"       
@ 24,30 GET nDIAS                                                                     
IF !READCUR()
   RETU .F.
ENDIF
cARQ := ESTQARQ(cTIPO1,1)
IF !USEREDE(cARQ,1,99)
   RETU .F.
ENDIF
DBGOTOP()
WHILE !EOF()
   netreclock()
   FIELD->ESTQENT := 0
   FIELD->ESTQSAI := 0
   DO CASE
      CASE cTIPO2 = "M" 
         FIELD->ESTQINI := CHM * nDIAS * QTDEEQ
      CASE cTIPO2 = "S" 
         FIELD->ESTQINI := CHS * nDIAS * QTDEEQ
      CASE cTIPO2 = "D" 
         FIELD->ESTQINI := CHD * nDIAS * QTDEEQ
   ENDCASE
   FIELD->ESTQSAL   := ESTQINI
   FIELD->DATABALAN := ZDATA
   DBUNLOCK()
   DBSKIP()
ENDDO
DBCLOSEALL()


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MSI01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MSI01

IF EMPTY(mESPE)
   mESPE := OBTER("CRMENS",mTIPA,"ALLTRIM(NOME)")+;
    ": "+IF(EMPTY(mVALPAD),"",STR(mVALPAD))+;
    " "+IF(EMPTY(mTOLMAX),"","+"+STR(mTOLMAX))+;
    " "+IF(EMPTY(mTOLMIN),"","-"+STR(mTOLMIN))+;
    " "+IF(EMPTY(mVALMAX),"","Max="+STR(mVALMAX))+;
    " "+IF(EMPTY(mVALMIN),"","Min="+STR(mVALMIN))+" "+mUNIDADE
   mESPE := STRTRAN(mESPE,"  "," ")
   mESPE := PADR(STRTRAN(mESPE,"  "," "),60)
ENDIF
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MSI02()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MSI02

IF EMPTY(mENCO)
   mENCO := OBTER("CRMENS",mTIPA,"ALLTRIM(NOME)")+;
    ":  "+mUNIDADE
   mENCO := STRTRAN(mENCO,"  "," ")
   mENCO := PADR(STRTRAN(mENCO,"  "," "),60)
ENDIF
RETU .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function M_AP6()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC M_AP6(cTIPO)

IF VALTYPE(cTIPO) # "C"
   mTIPO := " "
ELSE
   mTIPO := cTIPO
ENDIF
CRIARVARS("MU01I")
mCODIGO := SPACE(24)
MDS("Tipo e Codigo")
IF EMPTY(mTIPO)
   @ 24,40 GET mTIPO VALID CHECKTAB("MW0503","mTIPO","MW0503",,"LEFT(CODIGO1,1)")        
ELSE
   @ 24,40 GET mTIPO         
ENDIF
@ 24,50 GET mCODIGO VALID IF(mTIPO # "X",CHECKEXI(ESTQARQ(mTIPO,1),"mCODIGO","CODIGO+' '+NOME","CODIGO","CODIGO",.F.),.T.)        
IF !READCUR()
   RETU .F.
ENDIF
MPINS(ESTQARQ(mTIPO,1)+"I")
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAP8()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAP8(Carq)

PADULT(cARQ,"Numero   Funcion  Codigo"+spac(19)+"Data     Prazo    Devolucao",;
 "' '+STR(mNUMERO,8)+' '+STR(mNUMMP04,8)+' '+mCODIGO+' '+DTOC(mDATA)+' '+DTOC(mPRAZO)+' '+DTOC(mRETORNO)",;
 "MP8","NUMERO","mNUMERO")
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function mapclass()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func mapclass()

if !usemult({{"MP03",1,99},{"MS01",1,2},{"MQ01",1,1},{"MD03",1,1}})
   retu .f.
endif
DBSELECTAR("MP03")
DBGOTOP()
WHILE !EOF()
   @ 24,00 SAY CODIGO         
   cCODIGO   := ALLTRIM(CODIGO)
   cAPLICA   := ALLTRIM(APLICACAO)
   cSUBPRD   := ALLTRIM(SUBPROD)
   cSUBAPL   := ALLTRIM(SUBAPL)
   cCLASSIPI := ""
   cCODIPI   := ""
   IF EMPTY(CLASSIPI)
      DO CASE
         CASE !EMPTY(cSUBPRD)
            MAPCLASS01("MQ01",cSUBPRD)
         CASE !EMPTY(cSUBAPL)
            MAPCLASS01("MS01",cSUBAPL)
         otherwise
            IF !MAPCLASS01("MS01",cCODIGO)
               MAPCLASS01("MS01",cAPLICA)
            ENDIF
      ENDCASE
   ENDIF
   IF EMPTY(cCLASSIPI) .AND. !EMPTY(cCODIPI)
      DBSELECTAR("MD03")
      DBGOTOP()
      IF DBSEEK(cCODIPI)
         cCLASSIPI := CLASSIFIC
      ENDIF
   ENDIF
   DBSELECTAR("MP03")
   IF !EMPTY(cCLASSIPI) .AND. EMPTY(CLASSIPI)
      netgrvcam("CLASSIPI",cCLASSIPI)
   ENDIF
   DBSKIP()
ENDDO
DBCLOSEALL()


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAPCLASS01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAPCLASS01(cARQ,cCODIGO)

LOCAL lRETU := .F.
DBSELECTAR(cARQ)
DBGOTOP()
IF DBSEEK(cCODIGO)
   cCLASSIPI := CLASSIPI
   cCODIPI   := CODIPI
   lRETU     := .T.
ENDIF
RETU lRETU
