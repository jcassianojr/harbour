*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foldirf.prg
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
*+    Documentado em 27-Dez-2024 as  9:26 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

#INCLUDE "INKEY.CH"
#INCLUDE "BOX.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function DIRFPEGDAD()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION DIRFPEGDAD(nUSO)

PRIVate v_pic := "@S18"
IF VALTYPE(nUSO) # "N"
   nUSO := 1
ENDIF
set key K_F11 to TECLAF11
HB_DISPBOX(4,0,23,79,B_DOUBLE)
@  5,2  SAY "Dados do Reponsavel Pelo Arquivo"                                 
@  7,2  SAY "CGC"+spac(17)+"Nome"                                              
@  9,02 SAY "E-Mail"                                                           
@ 10,2  SAY "DDD   Telefone  Telefax  Ramal"                                   
@ 12,02 SAY "Ano Base/Ano Ref "                                                
@ 12,40 SAY "Codigo de Reten‡ao"                                               
@ 14,02 SAY "Operacao"                                                         
@ 14,15 SAY "O-riginal R-etifica"                                              
@ 14,39 SAY "(1)Nor(2)Esp"                                                     
@ 14,50 SAY "Natureza"                                                         
@ 14,61 SAY "Identifi"                                                         
@ 15,02 SAY "Numero Entrega Dec.Anterior"                                      
@ 17,02 SAY "Responsavel"                                                      
@ 18,02 SAY "CPF"                                                              
@ 18,42 SAY "CPF/CNPJ"                                                         
@ 19,02 SAY "Nome do Arquivo"                                                  
@ 20,02 SAY "Arquivo Detalhes"                                                 
@ 21,02 SAY "Grava Reg 1"                                                      
@  8,2  GET xrCGC                                                              
@  8,22 GET xrNOME                             PICT "@S40"                     
@  9,10 GET mEMAIL                             valid checkemail(mEMAIL)        
@ 11,02 GET mrXDDD                                                             
@ 11,08 GET mrXTEL                                                             
@ 11,18 GET mrXFAX                                                             
@ 11,28 GET xrRAMAL                                                            
@ 12,20 GET ANO                                                                
@ 12,25 GET ANOREF                                                             
IF nUSO = 1
   @ 12,60 GET CODRET VALID VERSEHA("CODIRRF",,CODRET,"NOME",'"Codigo de Retencao n„o cadastrado"')        
ELSE
   @ 12,60 GET CODRET         
ENDIF
@ 14,11 GET OPER       PICT "!"                   VALID OPER $ "OR"                                                                      
@ 14,48 GET SITU       VALID SITU $ "12"                                                                                                 
@ 14,59 GET NATUR      VALID NATUR $ "0123456789"                                                                                        
@ 14,70 GET IDEN       VALID IDEN $ "01"                                                                                                 
@ 15,35 GET xNUMEROANT                                                                                                                   
@ 17,15 GET xrRESN                                                                                                                       
@ 18,10 GET xrRESC     PICT "999.999.999-99"      VALID VALCPF(xrRESC)                                                                   
@ 18,50 GET mPESSOA    PICTURE "!"                VALID mPESSOA $ 'FJOC '                                                                
@ 18,52 GET CPFCNPJ    PICT(v_pic)                WHEN {| oGet | CNPJCPFPICT(oGet,mPESSOA,18,52)} VALID CNPJCPFVAL(CPFCNPJ,mPESSOA)      
@ 19,20 GET ARQ                                                                                                                          
@ 20,20 GET ARQDET                                                                                                                       
@ 21,14 GET GRAVA1                                                                                                                       
IF !READCUR()
   set key K_F11 to
   RETU .F.
ENDIF
set key K_F11 to
ARQ    := ALLTRIM(ARQ)
ARQDET := ALLTRIM(ARQDET)
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function DIRFREG01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC DIRFREG01()

//GravanDo o Header Empresa Tipo 1
FWRITE(USO,STRZERO(SEQ,8))
FWRITE(USO,"1")
FWRITE(USO,mCGC+mEST)
FWRITE(USO,"DIRF")
FWRITE(USO,ANO)
FWRITE(USO,OPER)  //(O)ori (R)eti
FWRITE(USO,SITU)  //1-Nor (2)Esp
IF XRPESSOA = "F"
   FWRITE(USO,"1")  //Pessoa fisica
ELSE
   FWRITE(USO,"2")  //Pessoa Juridica
ENDIF
FWRITE(USO,NATUR)   //0-9 Conforme Tipo Pessoa
FWRITE(USO,IDEN)
FWRITE(USO,ANOREF)
FWRITE(USO,"0")   //Sem Deposito Judiciario
FWRITE(USO,SPACE(1))
FWRITE(USO,xrNOME)
FWRITE(USO,mCPFCNPJ)
//FWRITE(USO,SPACE(37))
fwrite(USO,SPACE(8))  //data evento
fwrite(USO,space(1))  //tipo evento //1 encerramento espolio 2-saida definitiva pais
//fwrite(USO,space(28))
//FWRITE(USO,mCGC+mEST) //28+14 MCGC+MEST mudado 2007 vai em branco
fwrite(USO,space(42))
FWRITE(USO,xNUMEROANT)
FWRITE(USO,SPACE(229))
FWRITE(USO,mrCPF)
FWRITE(USO,xrRESn)
FWRITE(USO,mrXDDD)
FWRITE(USO,mrXTEL)
FWRITE(USO,STRZERO(VAL(xrRAMAL),6))
FWRITE(USO,mrXFAX)
FWRITE(USO,mEMAIL)
FWRITE(USO,SPACE(165))
FWRITE(USO,STRZERO(mNRCLIEN,12))
FWRITE(USO,"9")
FWRITE(USO,CHR(13)+CHR(10))
SEQ ++
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function DIRFREG02()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC DIRFREG02(cTIPO)

//Registro tipo 2 Beneficiario
FWRITE(USO,STRZERO(SEQ,8))
IF cTIPO <> "3"
   FWRITE(USO,"2")
ELSE
   FWRITE(USO,"3")
ENDIF
FWRITE(USO,mCGC+mEST)
FWRITE(USO,CODRET)
IF cTIPO <> "3"
   IF mPESSOA = "F"
      FWRITE(USO,"1")   //Beneficiario Pessoa fisica
   ELSE
      FWRITE(USO,"2")   //Beneficiario Pessoa Juridica
   ENDIF
   FWRITE(USO,USOCGC)
   FWRITE(USO,ACEPAD(mNOME,60))
ELSE
   FWRITE(USO,STRZERO(nREG02,8))
   FWRITE(USO,SPACE(67))
ENDIF
IF cTIPO <> "3"
   FOR X := 1 TO 13
      aTOTREN[X] += aREND[X]
      aTOTDED[X] += aDEDU[X]
      aTOTIRR[X] += aIRRF[X]
      IF cTIPO = "0"
         FWRITE(USO,GRVVAL(aREND[X],15,2))
         FWRITE(USO,GRVVAL(aDEDU[X],15,2))
         FWRITE(USO,GRVVAL(aIRRF[X],15,2))
      ENDIF
      IF cTIPO = "1"
         FWRITE(USO,GRVVAL(aPREV[X],15,2))
         FWRITE(USO,GRVVAL(aDEPE[X],15,2))
         FWRITE(USO,GRVVAL(aPENS[X],15,2))
      ENDIF
      IF cTIPO = "2"
         FWRITE(USO,GRVVAL(aPRIV[X],15,2))
         FWRITE(USO,GRVVAL(0,15,2))
         FWRITE(USO,GRVVAL(0,15,2))
      ENDIF
   NEXT X
ELSE
   FOR X := 1 TO 13
      FWRITE(USO,GRVVAL(aTOTREN[X],15,2))
      FWRITE(USO,GRVVAL(aTOTDED[X],15,2))
      FWRITE(USO,GRVVAL(aTOTIRR[X],15,2))
   NEXT X
ENDIF
FWRITE(USO,"0")
IF CTIPO = 3
   FWRITE(USO,"0")
ELSE
   FWRITE(USO,cTIPO)  // 0=BASE/DEDU/IRRF 1=PREV/DEP/PENSAO 2=PRIV
ENDIF
FWRITE(USO,SPACE(8))
FWRITE(USO,SPACE(20))
FWRITE(USO,STRZERO(mNUMERO,12))
FWRITE(USO,"9")
FWRITE(USO,CHR(13)+CHR(10))
nREG02 ++
SEQ ++
RETU .T.

*+ EOF: foldirf.prg
*+
