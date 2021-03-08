*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_ao0.prg
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
*+    Function MAOFP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOFP


PADRAO(0,1,0,"MOFP","No."+spac(6)+"Produto"+spac(18)+"SEQ SSQ MAQ  Data     Inicial  Baixada",;
 "' '+STR(mFP,8)+' '+mCODIGO+' '+STR(mSEQ,3)+' '+STR(mSSQ,3)+' '+mME01COD+' '+DTOC(mDATA)+' '+STR(mQTDEPF,8)+' '+STR(mQTDEBX,8)",;
 "MOFP",,,{|| ULTIMOREG("MOFP","FP","mFP")})
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function maofo3()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func maofo3


PADRAO(0,1,0,"OF03","OF"+spac(11)+"Seq SSQ Codigo"+spac(19)+"Limite   Fabricar     Falta",;
 "' '+STR(mOF,8,2)+' '+STR(mITEM,3)+' '+STR(mSEQ,3)+' '+STR(mSSQ,3)+' '+mCODIGO+' '+DTOC(mDLIMP)+' '+STR(mQTFAB,10,3)+' '+STR(mQTFAL,10,3)",;
 "MAOF3","MAOF31","MAOF31")
retu .t.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOCDA()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOCDA


MDI(" Ý Importar Padrao RND ")
cVAR     := space(128)
cCODIGO  := space(24)
cPLANTA  := space(10)
cSISCO   := space(5)
cPONTO   := "S"
nHANDLE  := 0
dINI     := dFIM := dPRG := ZDATA
cTIPO    := "S"
cARQ     := ""
cARQUIVO := ""
cAUTPED  := "N"
cSOMAPR  := "S"
cCHKPRG  := "S"
nLINHA   := 0
cPLINI   := space(10)
cPLFIM   := repl("Z",10)
TELASAY("RND001")
EDITSAY("RND001")
do case
   case cTIPO = "S"
      cTIPO    := "PE"
      cARQ     := "OSPRG"
      cARQUIVO := "\EDIWISE\EXPORT\GMB     .TXT"
   case cTIPO = "D"
      cTIPO    := "PD"
      cARQ     := "OSPR2"
      cARQUIVO := "\EDIWISE\EXPORT2\GMB     .TXT"
   case cTIPO = "A"
      cTIPO    := "DA"
      cARQ     := "OSPR2"
      cARQUIVO := "\EDIWISE\EXPORT2\DIA     .TXT"
   case cTIPO = "B"
      cTIPO    := "SA"
      cARQ     := "OSPRG"
      cARQUIVO := "\EDIWISE\EXPORT\SEM     .TXT"
endcase
cPLINI   := alltrim(cPLINI)
cPLFIM   := alltrim(cPLFIM)
cPLREF   := SPACE(5)
cPLPAD   := "NAO"
cTIRAP   := "NAO"
cARQUIVO := PADR(cARQUIVO,70)
MDI(" Ý Importar Padrao RND ")
@ 21,00 SAY "Arquivo"                                                                     
@ 21,10 get cARQUIVO                                                                      
@ 22,00 SAY "Planta Referencia"                                                           
@ 22,30 GET cPLREF                                                                        
@ 22,40 GET cPLPAD              PICT "!!!" VALID cPLPAD = "NAO" .OR. cPLPAD = "SIM"       
@ 23,00 SAY "Remover Pontos"                                                              
@ 23,30 GET cTIRAP              PICT "!!!" VALID cTIRAP = "NAO" .OR. cTIRAP = "SIM"       
if !READCUR()
   retu .F.
endif
cARQUIVO := alltrim(cARQUIVO)
cARQUIVO := STRTRAN(cARQUIVO," ","")
if ! file(cARQUIVO)
   ALERTX("N„o Encontrei o Arquivo")
   retu .F.
endif
dIMP := FILEDATE(cARQUIVO)
if !MDG("Importar:"+cARQUIVO+" de "+dtoc(dIMP))
   retu .F.
endif
lAPAGA := MDG("Zerar todos lan‡amentos Anteriores")
if !USEREDE(cARQ,0,99)
   retu .F.
endif
if lAPAGA
   zap
endif
dbgobottom()
nREG := NUMERO
nREG ++
dbsetorder(3)   //Produto Planta Programa
nHANDLE := fopen(cARQUIVO)
IF nHANDLE <= 0
   DBCLOSEALL()
   ALERTX("Erro Abrindo "+Carquivo)
   RETU .F.
ENDIF
lITP     := .F.
lPRI     := .F.
cLINHA01 := ""
cHORA    := ""
if nHANDLE = 0
   ALERTX("Arquivo n„o Pode ser Aberto")
   dbcloseall()
   retu .f.
endif
MDI(" Ý Importar Padrao RND ")
while .T.
   cVAR := FREADLINE(nHANDLE)
   if empty(cLINHA01)
      cLINHA01 := cVAR
   else
      lPRI := .T.
   endif
   cREFTIP := " "
   nLINHA ++
   @ 23,00 say "Linha "+str(nLINHA,8)         
   @ 24,00 say left(cVAR,3)                   
   do case
      case cLINHA01 = cVAR .and. lPRI
         ALERTX("Retornou ao primeiro Registro")
         if MDG("Encerrar Importacao-Recomendavel")
            exit
         endif
      case left(cVAR,3) = "   "
         ALERTX("Linha em Branco")
         if MDG("Encerrar Importacao-Recomendavel")
            exit
         endif
      case cTIPO = "DA" .or. cTIPO = "SA"
         cSISCO  := alltrim(substr(cVAR,25,10))
         cPLANTA := cSISCO
         cCODIGO := alltrim(substr(cVAR,1,24))
         if cPONTO = "S"
            cCODIGO := substr(cCODIGO,1,2)+"."+substr(cCODIGO,3,3)+"."+substr(cCODIGO,6,3)
         endif
         cDATA    := dtoc(STOD(substr(cVAR,35,8)))
         cQTDE    := substr(cVAR,43,8)
         dDATAPRG := STOD(substr(cVAR,51,8))
         if dDATAPRG = dPRG .or. cCHKPRG = "N"
            MAOCDAGRV()
         endif
      case !lITP .and. left(cVAR,3) = "ITP"
         lITP := .T.
      case lITP .and. left(cVAR,3) = "ITP"
         ALERTX("Retornou ao primeiro Registro")
         if MDG("Encerrar Importacao-Recomendavel")
            exit
         endif
      case left(cVAR,3) = "PE1"
         cSISCO  := alltrim(substr(cVAR,109,5))   //109 113
         cPLANTA := cSISCO
         cCODIGO := alltrim(substr(cVAR,37,30))
         if cPONTO = "S"
            cCODIGO := substr(cCODIGO,1,2)+"."+substr(cCODIGO,3,3)+"."+substr(cCODIGO,6,3)
         endif
      case left(cVAR,3) = "PD1"
         cSISCO  := alltrim(substr(cVAR,65,5))  //109 113
         cPLANTA := cSISCO
         cCODIGO := alltrim(substr(cVAR,4,11))
         if cPONTO = "S"
            cCODIGO := substr(cCODIGO,1,2)+"."+substr(cCODIGO,3,3)+"."+substr(cCODIGO,6,3)
         endif
         cREFTIP := substr(cVAR,177,1)
      case left(cVAR,3) = "FTP"   //nLIDO<=0
         exit
   endcase
   if left(cVAR,3) = "PE3" .and. cTIPO <> "DA"
      for X := 1 to 7
         cPRO  := substr(cVAR,(X * 17) - 13,17)
         cDATA := substr(cPRO,5,2)+"/"+substr(cPRO,3,2)+"/"+substr(cPRO,1,2)
         cQTDE := substr(cPRO,9,9)
         MAOCDAGRV()
      next X
   endif
   if left(cVAR,3) = "PD2" .and. cTIPO <> "DA"
      for X := 1 to 6
         cPRO  := substr(cVAR,(X * 19) - 15,19)
         cDATA := substr(cPRO,5,2)+"/"+substr(cPRO,3,2)+"/"+substr(cPRO,1,2)
         cHORA := Substr(cPRO,7,4)
         //         ALERTX(cHORA)
         //         QUIT
         cQTDE := substr(cPRO,11,9)
         MAOCDAGRV()
      next X
   endif
enddo
fclose(nHANDLE)
//Apagando Duplicidades
dbselectar(cARQ)
dbsetorder(3)
dbgotop()
while !eof()
   mCHAVE := PRODUTO+PLANTA+dtos(PROGRAMA)+str(QTDE,8)
   dbskip()
   if !eof() .and. mCHAVE = PRODUTO+PLANTA+dtos(PROGRAMA)+str(QTDE,8)
      DELEREG(,,.F.,.F.)
   endif
enddo
dbcloseall()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOCDAGRV()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOCDAGRV

IF EMPTY(cPLANTA) .OR. cPLPAD = "SIM"
   cPLANTA := cPLREF
ENDIF
IF cTIRAP = "SIM"
   cCODIGO := TIRAOUT(cCODIGO)
ENDIF
dDATA := ctod(cDATA)
nQTDE := val(cQTDE)
if dDATA < dINI .or. dDATA > dFIM
   if cAUTPED = "N"
      retu
   endif
   cOPCAO := "N"
   @ 10,10 say "Programa Fora do Periodo"                                    
   @ 11,10 say "Produto: "+cCODIGO                                           
   @ 12,10 say "Planta:  "+cPLANTA                                           
   @ 13,10 say "Programa:"+dtoc(dDATA)                                       
   @ 14,10 say "Qtde:"+cQTDE                                                 
   @ 15,10 say "Op‡ao:"                                                      
   @ 16,10 say "Gravar (S)im (N)ao"                                          
   @ 15,20 get cOPCAO                     valid cOPCAO $ "SN" pict "!"       
   Readcur()
   if cOPCAO = "N"
      retu .F.
   endif
endif
if alltrim(cPLANTA) >= cPLINI .and. alltrim(cPLANTA) <= cPLFIM
else
   retu .F.
endif
if dow(dDATA) = 0 .or. dow(dDATA) = 7
   cOPCAO := "N"
   cOPCA2 := "1"
   @ 10,10 say "Programa Final de Semana"                                                   
   @ 11,10 say "Produto: "+cCODIGO                                                          
   @ 12,10 say "Planta:  "+cPLANTA                                                          
   @ 13,10 say "Programa:"+dtoc(dDATA)+" "+Cdia(ddata)                                      
   @ 14,10 say "Qtde:"+cQTDE                                                                
   @ 15,10 say "Op‡ao:"                                                                     
   @ 16,10 say "Gravar (S)im (N)ao"                                                         
   @ 17,10 say "Op‡ao:"                                                                     
   @ 18,10 say "1(Segunda)2(Sexta)3(Sabado)4(Domingo)"                                      
   @ 15,20 get cOPCAO                                  valid cOPCAO $ "SN"   pict "!"       
   @ 17,20 get cOPCA2                                  valid cOPCA2 $ "1234" pict "!"       
   Readcur()
   if cOPCAO = "N"
      retu .F.
   endif
   do case
      case dow(dDATA) = 0 .and. cOPCA2 = "1"  //Domingo Segunda
         dDATA ++
      case dow(dDATA) = 0 .and. cOPCA2 = "3"  //Domingo Sabado
         dDATA --
      case dow(dDATA) = 0 .and. cOPCA2 = "2"  //Domingo Sexta
         dDATA -= 2
      case dow(dDATA) = 7 .and. cOPCA2 = "4"  //Sabado Domingo
         dDATA ++
      case dow(dDATA) = 7 .and. cOPCA2 = "2"  //Sabado Sexta
         dDATA --
      case dow(dDATA) = 7 .and. cOPCA2 = "1"  //Sabado Segunda
         dDATA += 2
   endcase
endif

if nQTDE > 0 .and. !empty(dDATA)
   cOPCAO := "S"
   dbselectar(cARQ)
   dbgotop()
   if !dbseek(padr(cCODIGO,24)+padr(cPLANTA,10)+dtos(dDATA))
      netrecapp()
      field->NUMERO   := nREG
      field->PRODUTO  := cCODIGO
      field->PLANTA   := cPLANTA
      field->PROGRAMA := dDATA
      field->DATAIMP  := dIMP
      field->HORAPRG  := VAL(cHORA) / 100
      nREG ++
   else
      do case
         case cSOMAPR = "S"
            @ 09,10 say "Arquivo TXT com Duplicidade Programa"          
            @ 10,10 say "Produto: "+cCODIGO                             
            @ 11,10 say "Planta:  "+cPLANTA                             
            @ 12,10 say "Programa:"+dtoc(dDATA)+" "+Cdia(ddata)         
            @ 13,10 say "Data Ori:"+cDATA+" "+Cdia(ctod(Cdata))         
            @ 14,10 say "Qtde:"+cQTDE                                   
            @ 15,10 say "Anterior:"+str(QTDE)                           
            if cREFTIP = "4"
               @ 16,10 say "Atualiza‡Æo"         
            endif
            if cREFTIP = "5"
               @ 16,10 say "Substitui‡ao"         
            endif
            @ 17,10 say "Op‡ao:"                                                         
            @ 18,10 say "(S)oma (M)anter (A)tualiza"                                     
            @ 17,20 get cOPCAO                       valid cOPCAO $ "SMA" pict "!"       
            Readcur()
         case cSOMAPR = "D"
            if int(QTDE) = int(nQTDE)
               cOPCAO := "M"
            endif
         otherwise
            cOPCAO := "S"
      endcase
      netreclock()
   endif
   do case  //Op‡ao M Mantem Valor
      case cOPCAO = "S"
         field->QTDE := QTDE+nQTDE
      case cOPCAO = "A"
         field->QTDE := nQTDE
   endcase
   dbunlock()
endif

retu .t.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function prgtrcplt()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func prgtrcplt()

mdi(" Ý Trocar Planta de Programa Recebido")
cTIPO  := "S"
cPLORI := space(10)
cPLDES := space(10)
@ 21,00 SAY "Planta "                                                        
@ 22,00 SAY "Prg(S)emanal Prg(D)iaria Electrolux->D(E)lfor (O)rders"         
@ 21,20 get cPLORI                                                           
@ 21,35 get cPLDES                                                           
@ 22,78 get cTIPO                                                            
if !READCUR()
   retu .F.
endif
cPLORI := alltrim(cPLORI)
cPLDES := alltrim(cPLDES)
do case
   case cTIPO = "S"
      cARQ := "OSPRG"
   case cTIPO = "D"
      cARQ := "OSPR2"
   case cTIPO = "E"
      cARQ := "OSPRE"
   case cTIPO = "O"
      cARQ := "OSPR3"
endcase
IF USEREDE(cARQ,0,99)
   nLASTREC := LASTREC()
   zei_fort(nLASTREC,,,0)
   DBEVAL({|| netgrvcam("PLANTA",&cPLDES.)},{|| PLANTA = &cPLORI.},{|| zei_fort(nLASTREC,,,1)})
   DBCLOSEALL()
ENDIF


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function OSPRG()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func OSPRG


MDI(" Ý Importa‡Æo Programa‡ao Para Pedidos")
if !MDG("Os Progamas Antigos Foram Excluidos")
   retu .F.
endif
dINI   := dFIM := ZDATA
cTIPO  := "S"
cARQ   := ""
cPLINI := space(10)
cPLFIM := repl("Z",10)
@ 20,00 SAY "Periodo "                                                       
@ 21,00 SAY "Planta "                                                        
@ 22,00 SAY "Prg(S)emanal Prg(D)iaria Electrolux->D(E)lfor (O)rders"         
@ 20,20 get dINI                                                             
@ 20,30 get dFIM                                                             
@ 21,20 get cPLINI                                                           
@ 21,35 get cPLFIM                                                           
@ 22,78 get cTIPO                                                            
if !READCUR()
   retu .F.
endif
cPLINI := alltrim(cPLINI)
cPLFIM := alltrim(cPLFIM)

do case
   case cTIPO = "S"
      cARQ := "OSPRG"
   case cTIPO = "D"
      cARQ := "OSPR2"
   case cTIPO = "E"
      cARQ := "OSPRE"
   case cTIPO = "O"
      cARQ := "OSPR3"
endcase
if !USEMULT({{"MO01",1,99},{"MO02",1,99},{"MA01",1,6},{cARQ,1,99},{"OSCRT",1,2},{"MS01",1,2},{"MS02",1,5}})
   retu .F.
endif
dbselectar("MO01")
INITVARS()
CLRVARS()
dbselectar("MO02")
INITVARS()
CLRVARS()
mDATA := ZDATA
MDS("")

//Primeira Etapa Checar os
lCONTINUA := .T.
dbselectar(carq)
dbgotop()
while !eof()
   cPLANTA := alltrim(PLANTA)
   if alltrim(cPLANTA) >= cPLINI .and. alltrim(cPLANTA) <= cPLFIM
      mCODIGO := alltrim(PRODUTO)
      @ 24,00 SAY RECNO()         
      @ 24,10 SAY cPLANTA         
      @ 24,20 SAY mCODIGO         
      dbselectar("MA01")
      dbgotop()
      if dbseek(cPLANTA)
         mFORNECEDO := NUMERO
         dbgotop()
         dbselectar("OSCRT")
         if !dbseek(str(mFORNECEDO,8)+mCODIGO)
            cERRO := "Produto:"+mCODIGO+" Cliente:"+str(mFORNECEDO,8)
            ALERTX("Falta Os"+cERRO)
            EMAILINT("MOC00001",cERRO)
            lCONTINUA := .F.
            if empty(PEDIDOCLI)
               cERRO := "Produto:"+mCODIGO+" Cliente:"+str(mFORNECEDO,8)+" OS:"+str(OS)
               ALERTX("N§ Pedido Cliente Em Branco"+cERRO)
               EMAILINT("MOC00001",cERRO)
               lCONTINUA := .F.
               IF !MDG("Continuar")
                  EXIT
               ENDIF
            endif
         endif
      else
         cERRO := "Planta:"+cPLANTA
         ALERTX("Planta NÆo Associada ao Cadastro Cliente"+cERRO)
         EMAILINT("MOC00002",cERRO)
         lCONTINUA := .F.
         IF !MDG("Continuar")
            EXIT
         ENDIF
      endif
      dbselectar(cARQ)
   endif
   dbskip()
enddo
if !lCONTINUA
   dbcloseall()
   ALERTX("Prg Nao Importada Corriga os Erros")
   retu
endif

dbselectar(cARQ)
dbgotop()
while !eof()
   cPLANTA := alltrim(PLANTA)
   @ 24,00 say recno()         
   if alltrim(cPLANTA) >= cPLINI .and. alltrim(cPLANTA) <= cPLFIM
      if PROGRAMA >= dINI .and. PROGRAMA <= dFIM
         cPLANTA := alltrim(PLANTA)
         mCODIGO := alltrim(PRODUTO)
         @ 24,10 SAY cPLANTA         
         @ 24,20 SAY mCODIGO         
         mENTREGA   := PROGRAMA
         mDATABASE  := PROGRAMA
         mQTDEPED   := QTDE
         mDATAIMP   := DATAIMP
         nOS        := 0
         mUNID      := "PC"
         mPEDIDOCLI := ""
         IF cTIPO = "O" .OR. cTIPO = "E"
            mPEDCLIITE := SEQCLIPRG
         ELSE
            mPEDCLIITE := 0
         ENDIF
         mFORNECEDO := 0
         nPEDIDO    := 0
         mLISTA     := 0
         mHORAPRG   := HORAPRG
         dbselectar("MA01")
         dbgotop()
         if dbseek(cPLANTA)
            mFORNECEDO := NUMERO
            mCOGNOME   := COGNOME
            mESTADO    := ESTADO
            mCONDPAG   := CONDPAG
            mVENDEDOR  := VENDEDOR
            mZONA      := ZONA
            mICM       := OBTER("MD05",mESTADO,"ALIQUOTA")
            mLISTA     := MO02LISTA
            //         mLISTA:=NUMERO
            //         IF ! EMPTY(MO02LISTA)
            //            mLISTA:=MO02LISTA
            //         ENDIF
         endif
         dbselectar("MS01")
         dbgotop()
         if dbseek(mCODIGO)
            mUNID := UNID
            mNOME := NOME
            dbselectar("MS02")
            dbgotop()
            dbseek(padr(mCODIGO,24)+str(mLISTA,5))
            while alltrim(mCODIGO) = alltrim(CODIGO) .and. mLISTA = FORNECEDO .and. !eof()
               if ATUAL # "N"
                  if !empty(UNIDE)
                     mUNID := UNIDE
                  endif
               endif
               dbskip()
            enddo
            if mUNID = "CT"
               mQTDEPED /= 100
            endif
            if mUNID = "ML"
               mQTDEPED /= 1000
            endif
         endif
         mQTDESAL := mQTDEPED
         dbselectar("OSCRT")
         dbgotop()
         if dbseek(str(mFORNECEDO,8)+mCODIGO)
            mPEDIDOCLI := alltrim(PEDIDOCLI)
            //            IF cTIPO<>"O".and
            //               mPEDCLIITE := PEDCLIITE
            //            ENDIF
            mDATABASE := DATA
            nOS       := OS
            netreclock()
            field->DATAIMP := mDATAIMP
            dbunlock()
         else
            cERRO := "Produto:"+mCODIGO+" Cliente:"+str(mFORNECEDO,8)
            ALERTX("Falta Os"+cERRO)
            EMAILINT("MOC00001",cERRO)
         endif
         if nOS > 0
            dbselectar("MO02")
            dbsetorder(5)
            dbgotop()
            if dbseek(str(Mfornecedo,5)+padr(mCODIGO,24)+dtos(mENTREGA)+str(mHORAPRG,5,2))
               cOPCAO := "A"
               @ 09,10 say "Os Ja Cadastrada Produto/Cliente/Entrega"                                        
               @ 10,10 say "OS:"+str(OS)                                                                     
               @ 11,10 say "Produto: "+CODIGO                                                                
               @ 12,10 say "Cliente:  "+str(FORNECEDO)                                                       
               @ 13,10 say "Entrega:"+dtoc(ENTREGA)+" "+STR(HORAPRG,5,2)                                     
               @ 14,10 say "Qtde:"+str(mQTDEPED)                                                             
               @ 15,10 say "Anterior:"+str(QTDEPED)                                                          
               @ 17,10 say "Op‡ao:"                                                                          
               @ 18,10 say "(S)oma (M)anter (A)tualiza"                                                      
               @ 17,20 get cOPCAO                                        valid cOPCAO $ "SMA" pict "!"       
               Readcur()
               netreclock()
               if cOPCAO = "A"
                  field->QTDEENT := 0
                  field->QTDEPED := mQTDEPED
                  field->HORAPRG := mHORAPRG
               endif
               if cOPCAO = "S"
                  field->QTDEPED := QTDEPED+mQTDEPED
               endif
               field->QTDESAL := QTDEPED - QTDEENT
               dbunlock()
            else
               mPEDIDO := int(nOS)
               dbselectar("MO01")
               dbsetorder(1)
               dbgotop()
               if dbseek(mPEDIDO+.99)
                  while dbseek(mPEDIDO)
                     mPEDIDO += .01
                  enddo
               else
                  dbseek(mPEDIDO)
                  while int(nOS) = int(PEDIDO) .and. !eof()
                     mPEDIDO := PEDIDO
                     dbskip()
                  enddo
                  mPEDIDO += .01
               endif
               mOS       := mPEDIDO
               mTIPOPRG  := cTIPO
               mBAIXAM   := "N"
               mITEM     := 1
               mCONSUMO  := "N"
               mTIPOSERV := "1"
               mPEDMEN   := "N"
               mGERAOF   := "N"
               NOVOOPA("MO01",.T.,.T.)
               NOVOOPA("MO02",.T.,.T.)
            endif
         endif
      endif
   endif
   dbselectar(cARQ)
   dbskip()
enddo
dbcloseall()
release all like M *
if MDG("Atualizar Pedidos-Recomendavel")
   MAOITA01()
else
   MAOFIXAR()
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOFIXAR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOFIXAR()


MDS(" Aguarde. Fechando os arquivos de dados ...")
if !USEMULT({{"MO01",1,99},{"MO02",1,99},{"OF01",1,99},{"OF02",1,99}})
   retu .F.
endif
dbselectar("MO02")
dbgotop()
while !eof()
   @ 24,00 say PEDIDO         
   mPEDIDO := PEDIDO
   IF PEDIDO = 0
      DELEREG(,,.F.,.F.)
   ENDIF
   dbselectar("MO01")
   dbgotop()
   lTEM := dbseek(mPEDIDO)
   dbgotop()
   dbselectar("MO02")
   if !lTEM
      mOF     := PEDIDO
      mITEM   := ITEM
      mCODIGO := CODIGO
      DELEREG(,,.F.,.F.)
      DELEREG("OF01",str(mPEDIDO,8,2)+str(mITEM,3),.F.,.F.,.T.)
      MAOFDEL(.F.)
      dbselectar("MO02")
   endif
   dbskip()
enddo

dbselectar("mo02")
dbsetorder(4)   //Pedido
dbselectar("mo01")
dbgotop()
while !eof()
   @ 24,00 SAY PEDIDO         
   mPEDIDO := PEDIDO
   IF PEDIDO = 0
      DELEREG(,,.F.,.F.)
   ENDIF
   dbselectar("MO02")
   dbgotop()
   lTEM := DBSEEK(mPEDIDO)
   dbselectar("mo01")
   IF !lTEM
      DELEREG(,,.F.,.F.)
   ENDIF
   dbskip()
enddo
dbcloseall()

FIXAR("MO01")
FIXAR("MO02")
FIXAR("OF01")
FIXAR("OF02")
for X := 1 to 18
   IF X < 13 .AND. x > 14   //13 e catorze nao usam mais
      cARQ := "OR"+strzero(X,2)
      FIXAR(cARQ)
   ENDIF
next X
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function OFZER()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func OFZER()


ZAPARQ({{"OF01",.F.,.F.},{"OF02",.T.,.F.},{"OR01",.T.,.F.},{"OR02",.T.,.F.},;
 {"OR03",.T.,.F.},{"OR04",.T.,.F.},{"OR05",.T.,.F.},;
 {"OR06",.T.,.F.},{"OR07",.T.,.F.},{"OR08",.T.,.F.},;
 {"OR09",.T.,.F.},{"OR10",.T.,.F.},{"OR11",.T.,.F.},;
 {"OR17",.T.,.F.},{"OR18",.T.,.F.},;
 {"OR12",.T.,.F.},{"OR15",.T.,.F.},{"OR16",.T.,.F.}})
ZAPARQ({{"OF03",.T.,.F.},{"OR01BX",.T.,.F.},{"OR02BX",.T.,.F.},;
 {"OR03BX",.T.,.F.},{"OR04BX",.T.,.F.},{"OR05BX",.T.,.F.},;
 {"OR06BX",.T.,.F.},{"OR07BX",.T.,.F.},{"OR08BX",.T.,.F.},;
 {"OR09BX",.T.,.F.},{"OR10BX",.T.,.F.},{"OR11BX",.T.,.F.},;
 {"OR17BX",.T.,.F.},{"OR18BX",.T.,.F.},;
 {"OR12BX",.T.,.F.},{"OR15BX",.T.,.F.},{"OR16BX",.T.,.F.}})
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function mAORENUM()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func mAORENUM()


MDI("Renumerar Numero de Pedido")
nORI := 0
nDES := 0
MDS("Digite Pedido Origem/Destino")
@ 24,40 get nORI pict "9999.99"        
@ 24,60 get nDES pict "9999.99"        
READCUR()
if VERSEHA("MO01",nDES)
   ALERTX("Pedido Destino Ja existente")
   retu .F.
endif
if !VERSEHA("MO01",nORI)
   ALERTX("Pedido Origem nao Existente")
   retu .F.
endif
if !USEMULT({{"MO01",0,99},{"MO02",0,99}})
   retu .F.
endif
dbselectar("MO01")
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
DBEVAL({|| netgrvcam("PEDIDO",nDES)},{|| PEDIDO = nORI},{|| zei_fort(nLASTREC,,,1)})
dbselectar("MO02")
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
DBEVAL({|| netgrvcam("PEDIDO",nDES)},{|| PEDIDO = nORI},{|| zei_fort(nLASTREC,,,1)})
dbselectar("MO01")
dbgotop()
if dbseek(nDES)
   field->OS := nDES
endif
dbselectar("MO02")
dbgotop()
if dbseek(nDES)
   field->OS := nDES
endif
dbcloseall()


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAORECLI()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAORECLI()


cORIGEM := cDESTINO := space(20)
MDI("Renumerar Pedido Cliente")
@ 22,00 say "Origem"          
@ 23,00 say "Destino"         
@ 22,10 get cORIGEM           
@ 23,10 get cDESTINO          
if !READCUR()
   retu .F.
endif
cORIGEM := alltrim(cORIGEM)
if !USEREDE("MO01",1,99)
   retu .F.
endif
MDS("Alterando")
dbgotop()
while !eof()
   if !empty(PEDIDOCLI)   //Trava Sem Numero
      if cORIGEM = alltrim(PEDIDOCLI)
         netgrvcam("PEDIDOCLI",cDESTINO)
         @ 24,00 say recno()         
      endif
   endif
   dbskip()
enddo
dbcloseall()


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAOZERCLI()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAOZERCLI()


MDI("Zerar Codigo Cliente")
mFORNECEDO := 0
MDS("Digite o Codigo do Cliente")
@ 24,40 get mFORNECEDO         
if !READCUR()
   retu .F.
endif
if empty(mFORNECEDO)
   retu .F.
endif
if !USEREDE("MO01",1,99)
   retu .F.
endif
MDS("Alterando")
dbgotop()
while !eof()
   if !empty(FORNECEDO)   //Trava Sem Numero
      if FORNECEDO = mFORNECEDO
         netgrvcam("PEDIDOCLI","")
         @ 24,00 say recno()         
      endif
   endif
   dbskip()
enddo
dbcloseall()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAODUP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAODUP


MDI(" Ý Duplica‡ao Pedido")
nORI     := 0.00
nDES     := 0.00
nQTD     := 1
dENTREGA := ZDATA
CRIARVARS("MO01")
CRIARVARS("MO02")
MDS("Origem Destino Entrega Quantidade")
@ 24,30 get nORI     pict "9999.99"        
@ 24,40 get nDES     pict "9999.99"        
@ 24,50 get dENTREGA                       
@ 24,60 get nQTD                           
if !READCUR()
   retu .F.
endif
if USEMULT({{"MO01",1,99},{"MO02",1,99}})
   for X := 1 to nQTD
      dbselectar("MO01")
      dbgotop()
      if dbseek(nORi)
         EQUVARS()
         mPEDIDO  := nDES
         mOS      := nDES
         mENTREGA := dENTREGA
         NOVOOPA("MO01")
         dbselectar("MO02")
         dbgotop()
         if dbseek(str(nORI,8,2))
            EQUVARS()
            mPEDIDO  := nDES
            mOS      := nDES
            mENTREGA := dENTREGA
            NOVOOPA("MO02")
         endif
      endif
      nDES     += .01
      dENTREGA += 7
   next X
   dbcloseall()
endif

