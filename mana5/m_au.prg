*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_au.prg
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


//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"

//Criar Vars Sub Arquivos
CRIARVARS("MA01")
CRIARVARS(ARQWORK)
CRIARVARS(ARQ2)
CRIARVARS(ARQ3)
CRIARVARS(ARQ4)
CRIARVARS(ARQI)

//Variaveis Auxiliares
xEMPFRETE  := OBTER("MANEMP",ZNUMERO,"CUSFRETE")
xCODIPI    := xCOTIN1 := xCOTIN2 := xNOME := xUNIDADE := ""
mTOTCUSTO  := XESTQINI := xCOTVAL := xCOTCO1 := xCOTCO2 := 0
xDATABALAN := xCOTDA1 := xCOTDA2 := ctod(space(8))
zNOME      := ""
zNOMEOLD   := ""


mOBSERVA := mMATERIAL := mNOMEMAT := ""
ZNOME    := ""

//Senhas de Acesso
sMAU001 := SENHAX(cSEN+"001",,.F.)
sMAU002 := SENHAX(cSEN+"002",,.F.)
sMAU003 := SENHAX(cSEN+"003",,.F.)
sMAU005 := SENHAX(cSEN+"005",,.F.)
sMAU006 := SENHAX(cSEN+"006",,.F.)
priv mVALIPI
priv mVALFRE

aTELMAU := TELAPEG("MAU001")

PADRAO(0,1,0,ARQWORK,"C¢digo        Nome"+spac(37)+"Estoque",;
 "' '+mCODIGO+' '+STR(mESTQSAL, 10, 3)+' '+mNOME+' '+mNOM2",;
 "MAU",{|| TELASAY(aTELMAU)},{|| GMAU()},,,{| nKEY | MAUKEY(nKEY)},{|| MAUIGU()},{|| MAUKEYROD()},;
 ,,,{|| MAUDEL()})


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAUKEY()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAUKEY(nKEY)


do case
   case nKEY = K_ALT_F1
      mCODIGO := aPAD2[pPAD]
      xCODIGO := mCODIGO
      PEGACAMPO(ARQWORK,"xCODIGO",{"NOME","UNIDADE"},{"xNOME","xUNIDADE"})
      PADRAO(1,1,0,ARQ2,"C¢digo:  Descri‡„o:"+spac(21)+"Unidade:",;
       "' '+mCODIGO+' '+mNOME+' '+STR(mCOTFORN)+' '+mCOTCOGN",;
       "MAU2",,,{|| IMAU3()},{|| PADARR(ARQ2,xCODIGO,"CODIGO","XCODIGO")},,;
       {|| iMAU2()})
   case nKEY = K_ALT_F2
      mCODIGO := aPAD2[pPAD]
      xCODIGO := mCODIGO
      PEGACAMPO(ARQWORK,"xCODIGO",{"NOME","UNIDADE"},{"xNOME","xUNIDADE"})
      PADRAO(1,1,0,ARQ3,"C¢digo   T Cliente"+spac(12)+"NF Ent.  Saldo",;
       "' '+mCODIGO+' '+mTIPOCLI+' '+STR(mCLIENTE,5)+' '+mCOGNOME+' '+STR(mNRNOTAINI,8)+' '+STR(mTOTKGEST,9,2)","MAU3","MAU301","MAU301",;
       {|| iMAU3()},{|| PADARR(ARQ3,xCODIGO,"CODIGO","XCODIGO")} ;
       ,,,,,{|| MAU301(ARQ3,ARQ3BX)})

   case nKEY = K_ALT_F4
      if sMAU005
         xARQWORK := ARQWORK
         ARQWORK  := ARQ9
         mCODIGO  := aPAD2[pPAD]
         M_AS99(0)
         ARQWORK := xARQWORK
      endif
   case nKEY = K_ALT_F5
      mCODIGO := aPAD2[pPAD]
      xCODIGO := mCODIGO
      M_AU4(ARQ4,STR4)
   case nKEY = K_ALT_F6
      mCODIGO := aPAD2[pPAD]
      xCODIGO := mCODIGO
      PADRAO(1,1,0,ARQWORK+"I","Codigo"+spac(19)+"Ite Tip Especificado",;
       "' '+mCODIGO+' '+STR(mITEM,  3)+' '+mTIPA+' '+mESPE",;
       "MSI",,,{|| mCODIGO := xCODIGO},{|| PADARR(ARQWORK+"I",xCODIGO,"CODIGO","xCODIGO")})
endcase
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAUIGU()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAUIGU()


if INCLUI
   EMAILINT("INC00001",mCHAVE)
   mFREPES    := 'S'
   mDATABALAN := ZDATA
   nDATMIN    := ZDATA
endif
xESTQINI   := mESTQINI
xCOTVAL    := mCOTVAL
xCOTIN1    := mCOTIN1
xCOTDA1    := mCOTDA1
xCOTCO1    := mCOTCO1
xCOTIN2    := mCOTIN2
xCOTDA2    := mCOTDA2
xCOTCO2    := mCOTCO2
xCODIPI    := mCODIPI
xDATABALAN := mDATABALAN
retu .F.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAUKEYROD()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAUKEYROD()


@ 23,00 say "ALT+ F1=Pre‡o F2=Remes F4=Mov.Esqt. F5=Medio F6=Ensaio"         
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAUDEL()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAUDEL()

EMAILINT("DEL00001",mCHAVE)
PADDEL(ARQ2,mCODIGO,"CODIGO","mCODIGO")
PADDEL(ARQ4,mCODIGO,"CODIGO","mCODIGO")
PADDEL(ARQI,mCODIGO,"CODIGO","mCODIGO")
maupe("DEL")
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function mAUPE()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC mAUPE(cTIPO)

LOCAL cTEXTO
cTEXTO := CHR(13)+CHR(10)+"Atual:"+ALLTRIM(ZNOME)
cTEXTO += CHR(13)+CHR(10)+"Antigo:"+ALLTRIM(ZNOMEOLD)
while !USEMULT({{"MW02",1,99},{"PE",1,99},{"PE01",1,99}})
enddo
dbselectar("PE")
dbsetorder(3)
dbgotop()
dbseek(alltrim(mCODIGO))
while alltrim(mCODIGO) = alltrim(CODIGO) .and. !eof()
   nPE := PEDIDO
   netreclock()
   field->COMPRAS   := 0
   field->COMITEM   := 0
   field->fornecedo := 0
   field->cognome   := ""
   field->NOME      := ""
   field->NOM2      := ""
   dbunlock()
   dbselectar("PE01")
   dbgotop()
   dbseek(str(nPE,5))
   while nPE = PEDIDO .and. !eof()
      netreclock()
      field->NOME := ""
      field->NOM2 := ""
      dbunlock()
      dbskip()
   enddo
   dbselectar("PE")
   IF cTIPO = "DEL"
      EMAILINT("DEL00002","PE:"+str(PEDIDO))
   ELSE
      EMAILINT("MUD00002","PE:"+str(PEDIDO)+cTEXTO)
   ENDIF
   dbskip()
enddo
dbselectar("MW02")
dbsetorder(3)
dbgotop()
dbseek(alltrim(mCODIGO))
while alltrim(mCODIGO) = alltrim(ITECOD) .and. !eof()
   netreclock()
   IF cTIPO = "DEL"
      FIELD->ITETIP := ""
   ENDIF
   field->ITECOD := "**"+ITECOD
   field->ITENOM := "**"+ITENOM
   dbunlock()
   IF cTIPO = "DEL"
      EMAILINT("DEL00003","Pedido"+str(COMPED,8)+str(ITEM,3))
   ELSE
      EMAILINT("MUD00003","Pedido"+str(COMPED,8)+str(ITEM,3)+cTEXTO)
   ENDIF
   dbskip()
enddo
dbcloseall()
retu .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gMAU()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func gMAU


// Get nas Menvars
zNOME    := padr(mNOME+mNOM2,100)
zNOMEOLD := padr(mNOME+mNOM2,100)
if sMAU001
   @  2,02 get mCODIGO                    
   @  3,02 get zNOME   pict "@S76"        
else
   @  2,02 say mCODIGO         
   @  2,25 say mNOME           
   @  3,25 say mNOM2           
endif
@  4,15 get mDIMX      pict '999999.99'        
@  4,33 get mDIMY      pict '999999.99'        
@  4,54 get mDIMZ      pict '999999.99'        
@  4,70 get mPESLIQ                            
@  5,12 get mAPLICACAO pict "@S25"             
@  6,12 get mINSTRU    pict "@S25"             
if ZLANC = 0
   @  6,39 get mCTACONTB pict ZPICCC valid CHECKCC()       
else
   @  6,39 get mCTACONTB valid CHECKCC()        
endif
@  6,55 get mLOCACAO                                                                                                              
@  6,70 get mUNIDADE  valid CHECKEXI("MD07","mUNIDADE","UNIDADE+' '+UNIDDES","UNIDADE","UNIDADE")                                 
@  6,73 get mCODIPI   valid CHECKCIPI(mCODIPI,"mIPI","mCLASSIPI")                                                                 
@  7,65 get mCLASSIPI when empty(mCODIPI)                                                         valid CHECKIPI(mCLASSIPI)       
READCUR()
mNOME := substr(zNOME,1,50)
mNOM2 := substr(zNOME,51)

//Altera Pre‡o
if sMAU002
   @  9,14 get mCOTFORN pict '99999'        valid ALLTRUE(PEGACAMPO("MB01","mCOTFORN","COGNOME","mCOTCOGN"))       
   @  9,20 get mCOTCOGN                                                                                            
   @  9,41 get mCOTDATA                                                                                            
   @  9,58 get mCOTCONT                                                                                            
   @ 12,2  get mCOTVAL  pict "999999999.99" valid MAUK01() .and. ;                                                 
    CONVTAB(mCOTIN1,,mCOTDA1,"mCOTIV1",mCOTVAL,"mCOTCO1",6,12,38,"@E 99999.999999",12,54,"@E 99999.999999") .and. ;
    CONVTAB(mCOTIN2,,mCOTDA2,"mCOTIV2",mCOTVAL,"mCOTCO2",6,13,38,"@E 99999.999999",13,54,"@E 99999.999999")
   @ 12,15 get mCOTIN1 valid CONVTAB(mCOTIN1,,mCOTDA1,"mCOTIV1",mCOTVAL,"mCOTCO1",6,12,38,"@E 99999.999999",12,54,"@E 99999.999999")        
   @ 12,28 get mCOTDA1 valid CONVTAB(mCOTIN1,,mCOTDA1,"mCOTIV1",mCOTVAL,"mCOTCO1",6,12,38,"@E 99999.999999",12,54,"@E 99999.999999")        
   @ 13,15 get mCOTIN2 valid CONVTAB(mCOTIN2,,mCOTDA2,"mCOTIV2",mCOTVAL,"mCOTCO2",6,13,38,"@E 99999.999999",13,54,"@E 99999.999999")        
   @ 13,28 get mCOTDA2 valid CONVTAB(mCOTIN2,,mCOTDA2,"mCOTIV2",mCOTVAL,"mCOTCO2",6,13,38,"@E 99999.999999",13,54,"@E 99999.999999")        
   if sMAU002
      @ 15,7  get mIPI    pict "99.99"           valid MAUK01()                            
      @ 15,17 get mVALIPI pict "@E 9,999,999.99" valid MAUK01()                            
      @ 15,36 get mFREPES pict "!"               valid mFREPES $ 'SN' .and. MAUK01()       
      @ 15,40 get mVALFRE pict "@E 9,999,999.99" valid MAUK01()                            
   endif
endif
READCUR()

//Altera Estoque
if sMAU003
   @ 17,22 get mCONSIG    pict "!"            valid mCONSIG $ "SN"       
   @ 18,12 get mESTQINI   pict '99999999.999' valid MAUK02()             
   @ 19,12 get mESTQENT   pict '99999999.999' valid MAUK02()             
   @ 20,12 get mESTQSAI   pict '99999999.999' valid MAUK02()             
   @ 18,28 get mDATABALAN                                                
   @ 19,28 get mVALINV                                                   
   @ 19,65 get mDIASENT   pict '99999999'                                
   @ 20,65 get mDIASEST   pict '99999999'                                
   @ 22,12 get mESTQMIN   pict '99999999.999'                            
   @ 22,27 get mCCM       pict '9999,999.999'                            
   @ 22,41 get mMINDI     pict '9999,999.999'                            
   @ 22,54 get mMININD    pict '9999,999.999'                            
   @ 22,67 get mCAUTO     pict '9999,999.999'                            
   READCUR()
endif
IF zNOME # zNOMEOLD
   maupe("MUD")
   ALERTX("Troca de Nome")
ENDIF
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAUK01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAUK01


mVALIPI  := round(mCOTVAL * mIPI / 100,2)
mVALFRE  := if(mFREPES = 'S',round(mPESLIQ * xEMPFRETE,2),0.00)
mPRECUST := mCOTVAL+mVALIPI+mVALFRE
if sMAU002
   @ 15,58 say mPRECUST pict "@E 9,999,999.99"        
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAUK02()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAUK02(cPICT)


if valtype(cPICT) # "C"
   cPICT := '@E 99,999,999.999'
endif
if xESTQINI # mESTQINI
   GRAVALOG(mCHAVE+"_"+str(xESTQINI),"ETQ","ESTQINI")
   GRAVALOG(mCHAVE+"_"+str(mESTQENT),"ETQ","ESTQENT")
   GRAVALOG(mCHAVE+"_"+str(mESTQSAI),"ETQ","ESTQSAI")
   mESTQENT := 0
   mESTQSAI := 0
   GRAVALOG(mCHAVE+"_"+str(mESTQINI),"ETQ","ESTQINI")
   xESTQINI := mESTQINI
endif
if xDATABALAN # mDATABALAN
   mDATMIN := mDATABALAN
   mSAIMIN := 0.00
endif
mESTQSAL := mESTQINI+mESTQENT - mESTQSAI
@ 19,12 say mESTQENT pict cPICT        
@ 20,12 say mESTQSAI pict cPICT        
@ 21,12 say mESTQSAL pict cPICT        
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CALCINV()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC CALCINV(cTIPO)

MDI("Calculando Valor Inventario")
nFATOR := 0.8200
MDS("Digite o Fator")
@ 24,20 GET nFATOR         
IF !READCUR()
   RETU .F.
ENDIF
IF !USEREDE(ESTQARQ(cTIPO,1),1,99)
   RETU .F.
ENDIF
DBGOTOP()
WHILE !EOF()
   @ 24,00 SAY CODIGO         
   netreclock()
   IF ULTPRC > 0
      FIELD->VALINV := ULTPRC * nFATOR
   ELSE
      IF PRECUST > 0
         FIELD->VALINV := ULTPRC * nFATOR
      ENDIF
   ENDIF
   DBUNLOCK()
   DBSKIP()
ENDDO
DBCLOSEAREA()

