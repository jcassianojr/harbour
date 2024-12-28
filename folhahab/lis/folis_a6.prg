*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : folis_a6.prg
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

// :*****************************************************************************
// :
// :
// :   FOLIS_A6.PRG: Gerar Arquivo para RAIS
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 2007,  SOFTEC  S/C Ltda.
// :  Atualizado em: 30/01/2007
// :
// :*****************************************************************************

#INCLUDE "INKEY.CH"
#INCLUDE "BOX.CH"

CABE2('Preparar Arquivo para Rais')
IF !MDG('Voce ja conferiu o Cadastro Empresas, estao OK.')
   FOLIS_D2()
   RETU
ENDIF
IF !MDG('Voce ja conferiu o Cadastro Funcionarios, estao OK.')
   FOLIS_D1(1)
   RETU
ENDIF
IF !MDG('Voce ja acumulou Rais')
   FOLIS_A3()
   RETU
ENDIF
IF !MDG('Voce ja conferiu o Acumulo Rais, est„o OK.')
   FOLIS_D1(2)
   RETU
ENDIF


//Variaveis de Trabalho
ANOBASE := YEAR(DXDIA)
RAISARQ := "C:\FOLHA\RAIS"+STrZERO(ANOBASE,4)+".TXT              "
GERA    := date()
SEQ     := 1
FILTRO  := ""
INX     := ""
xrRET   := "2"



IF !netuse("firma")
   RETU .F.
ENDIF
DBGOTOP()
IF !DBSEEK(NREMP)
   DBCLOSEALL()
   ALERTX("Falta Cadastro Empresa")
   RETU
ENDIF
xrCGC      := CGC
xrNOME     := RAZAO
xrBAIRRO   := BAIRRO
xrCEP      := CEP
mNAT       := NAT_ESTAB
xrCODIBGE  := CODIBGE
xrCIDADE   := CIDADE
xrESTADO   := ESTADO
xrDDD      := STRTRAN(DDD," ","")
xrDDD      := STRTRAN(xrDDD,"0","")
xrDDD      := PADR(LEFT(xrDDD,2),2)
xrTEL      := TELEFONE
xPTOREP    := ""
xrPESSOA   := PESSOA
xrCEI      := CEI
mEMAIL     := EMAIL
mPAT       := PAT
mPATMENOS  := mPATMAIS := 0
nPER01     := nPER02 := nPER03 := nPER04 := nPER05 := nPER06 := 0
mRESPONSAV := RESPONSAV
mCPFRESP   := CPFRESP
xrDNRESP   := DNRESP
xCNPJPAT   := REPL("0",14)
xCNPJCON   := REPL("0",14)
xCNPJASS   := REPL("0",14)
xCNPJSIN   := REPL("0",14)
xVALPAT    := 0.00
xVALCON    := 0.00
xVALASS    := 0.00
xVALSIN    := 0.00
DO CASE
CASE PAT = "S"
   mPAT := "1"
OTHERWISE
   mPAT := "2"
ENDCASE
mPORTE := PORTE
DO CASE
CASE mPORTE = "S"
   mPORTE := "1"
CASE mPORTE = "N"
   mPORTE := "2"
CASE mPORTE = "0"
   mPORTE := "3"
OTHERWISE
   mPORTE := "3"
ENDCASE
mSIMPLES := "N"
DO CASE   //Simples 1/2 Diferente Rais/Informe/Dirf/Sefip
CASE SIMPLES = "N" .OR. SIMPLES = "1"
   mSIMPLES := "2"
CASE SIMPLES = "S" .OR. SIMPLES = "2" .OR. SIMPLES = "3" .OR. SIMPLES = "4"
   mSIMPLES := "1"
ENDCASE
mRAISNEG := RAISNEG
DBCLOSEALL()

IF EMPTY(MRAISNEG)
   mRAISNEG := "0"
ENDIF
mENCERRA := "2"
mDEND    := ZDATA
IF EMPTY(mSIMPLES)
   mSIMPLES := "2"
ENDIF
DBCLOSEALL()




IF !netuse("BCOFGTS")
   RETU .F.
ENDIF
DBGOTOP()
IF !DBSEEK(NREMP)
   DBCLOSEALL()
   ALERTX("Falta Cadastro Detalhes Empresa")
   RETU
ENDIF
xrEND := ENDERECO
xrNUM := STRZERO(VAL(NUMEROEMP),6)
xrCOM := COMPLEMEN
DBCLOSEALL()

xrDATA := DATE()

xEXERCE := "1"
xEMPSIN := "1"
mCGCCEN := REPL("0",14)

HB_DISPBOX(4,0,23,79,B_DOUBLE)
@  4,2  SAY "CGC"+spac(17)+"Nome"                                                                    
@  4,65 SAY "CGC-CENT"                                                                               
@  6,2  SAY "eMAIL"                                                                                  
@  7,2  SAY "End.:"+spac(31)+"No.       Complemento"                                                 
@  8,2  SAY "Bairro"+spac(10)+"Cep"+spac(7)+"Cod.Mu. Cidade"+spac(10)+"UF  DDD Telefone"             
@ 10,2  say "Patronal      CNPJ:"+SPACE(15)+"Valor:"                                                 
@ 10,52 SAY "Sindicalizada  1(Sim)2(Nao)"                                                            
@ 11,2  say "Confederativa CNPJ:"+SPACE(15)+"Valor:"                                                 
@ 12,2  say "Assistencial  CNPJ:"+SPACE(15)+"Valor:"                                                 
@ 13,2  SAY "Sindical      CNPJ:"+SPACE(15)+"Valor:"                                                 
@ 14,02 SAY "Ano Base      Gera‡„o         Arquivo"                                                  
@ 15,2  SaY "Encerramento Atividade    1(Sim) 2(Nao)"                                                
@ 15,68 say "Tipo Relogio:"                                                                          
@ 16,2  SAY "Declaracao Retificacao    1(Retificada)  2(Normal 1¦Entrega)"                           
@ 17,2  SAY "Rais Negativa             0(Nao-Com Empregados) 1(Sim-Sem Empregados)"                  
@ 18,2  SAY "Responsavel:"+spac(42)+"CPF:"                                                           
@ 19,2  SAY "Porte:  1(Micro)2(Pequeno Porte)3(Outros) Data Nasc Resp:" //2011 recibo fixo 1         
@ 20,2  SAY "Simples  :  1(Sim) 2(Nao)"                                                              
@ 20,28 SAY "Atividade:  1(Sim) 2(Nao)  Codigo:"                                                     
@ 21,2  SAY "PAT                       1(Sim) 2(Nao) N§<5SalMin       N§>5SalMin"                    
@ 22,2  SAY "%Ser.Pro"                                                                               
@ 22,15 SAY "%Adm.Coz"                                                                               
@ 22,28 SAY "%Ref.Con"                                                                               
@ 22,41 SAY "%Ref.Tra"                                                                               
@ 22,54 SAY "%Ref Ces"                                                                               
@ 22,67 SAY "%Alm.Con"                                                                               
set key K_F11 to TECLAF11
@  5,2  GET xrCGC                                                                                                                                            
@  5,21 GET xrNOME                                                                                                                                           
@  5,65 GET mCGCCEN                                                                                                                                          
@  6,08 GET mEMAIL                                        valid checkemail(mEMAIL)                                                                           
@  7,7  GET xrEND                                                                                                                                            
@  7,41 GET xrNUM                                                                                                                                            
@  7,60 GET xrCOM                                                                                                                                            
@  9,2  GET xrBAIRRO                                                                                                                                         
@  9,18 GET xrCEP                                         PICTURE "99999-999"                                                                                
@  9,28 GET xrCODIBGE                                                                                                                                        
@  9,36 GET xrCIDADE                                                                                                                                         
@  9,52 GET xrESTADO                                      PICTURE "!!"                                                                                       
@  9,56 GET xrDDD                                                                                                                                            
@  9,61 GET xrTEL // PICTURE "9999-9999" tirado mascara t                                                                                                    
@ 10,21 GET xCNPJPAT                                                                                                                                         
@ 10,43 GET xvalPAT                                       PICTURE "9999999.99"                                                                               
@ 10,66 GET xEMPSIN                                       PICT "!"                                                              VALID XEMPSIN $ "12"         
@ 10,78 GET xPTOREP                                       PICT "99"                                                                                          
@ 11,21 GET xCNPJCON                                                                                                                                         
@ 11,43 GET xvalCON                                       PICTURE "9999999.99"                                                                               
@ 12,21 GET xCNPJASS                                                                                                                                         
@ 12,43 GET xvalASS                                       PICTURE "9999999.99"                                                                               
@ 13,21 GET xCNPJSIN                                                                                                                                         
@ 13,43 GET xvalSIN                                       PICTURE "9999999.99"                                                                               
@ 14,10 GET ANOBASE                                       PICT "9999"                                                                                        
@ 14,23 GET GERA                                                                                                                                             
@ 14,40 GET RAISARQ                                                                                                                                          
@ 15,25 GET mENCERRA                                      PICT "!"                                                              VALID mENCERRA $ "12"        
@ 15,45 GET mDEND                                                                                                                                            
@ 16,25 GET xrRET                                         PICT "!"                                                              VALID xrRET $ "12"           
@ 16,64 GET xRDATA                                                                                                                                           
@ 17,25 GET mRAISNEG                                      PICT "!"                                                              VALID mRAISNEG $ "01"        
@ 18,15 GET mRESPONSAV                                                                                                                                       
@ 18,61 GET mCPFRESP                                      PICT "999.999.999-99"                                                 VALID VALCPF(mCPFRESP)       
@ 19,08 GET mPORTE                                        PICT "!"                                                              VALID mPORTE $ "123"         
@ 19,61 get xrDNRESP                                                                                                                                         
@ 20,12 GET mSIMPLES                                      PICT "!"                                                              VALID mSIMPLES $ "12"        
@ 20,38 GET xEXERCE                                       PICT "!"                                                              VALID xEXERCE $ "12"         
@ 20,62 GET mNAT                                          VALID VERSEHA("RAISNATJ",,mNAT,"NOME","'Natureza Juridica Invalida'")                              
@ 21,25 GET mPAT                                          PICT "!"                                                              VALID mPAT $ "12"            
@ 21,52 GET mPATMENOS                                     PICT "999999"                                                                                      
@ 21,70 GET mPATMAIS                                      PICT "999999"                                                                                      
@ 22,11 GET nPER01                                        PICT "999"                                                                                         
@ 22,24 GET nPER02                                        PICT "999"                                                                                         
@ 22,37 GET nPER03                                        PICT "999"                                                                                         
@ 22,50 GET nPER04                                        PICT "999"                                                                                         
@ 22,63 GET nPER05                                        PICT "999"                                                                                         
@ 22,75 GET nPER06                                        PICT "999"                                                                                         
IF !READCUR()
   set key K_F11
   RETURN .F.
ENDIF
set key K_F11

RAISARQ := ALLTRIM(RAISARQ)

USO := FCREATE(RAISARQ)   //ABRINDO ARQUIVO
IF FERROR() # 0
   ALERTX("Erro na CriaCAo do Arquivo")
   RETU
ENDIF
lPRIMA := .T.
mFUN   := 0

IF !NETUSE("FIRMA")
   RETU
ENDIF
DBGOTOP()
IF DBSEEK(NREMP)
   mRZA := PADR(TIRACE(UPPER(RAZAO)),52)
   mEND := TIRACE(UPPER(ENDERECO)+SPAC(20))
   mBAI := PADR(TIRACE(UPPER(BAIRRO)+SPAC(4)),19)
   mMUN := TIRACE(UPPER(CIDADE)+SPAC(15))
   mUFE := TIRACE(UPPER(ESTADO))
   mCEP := SUBSTR(CEP,1,5)+SUBSTR(CEP,7)
   mATI := SUBSTR(ATIVIDADE,1,7)
   mPRO := NR_SOCIOS
   mFAM := NR_FAMILIA
   tCGC := CGC
   IF PESSOA = 'J'
      mCGC := SUBSTR(tCGC,1,2)+SUBSTR(tCGC,4,3)+SUBSTR(tCGC,8,3)+SUBSTR(tCGC,12,4)+SUBSTR(tCGC,17,2)
      mINC := "1"   //INDICA CGC
   ELSE
      mCGC := "00"+CEI
      mINC := "3"   //INDICA CEI
   ENDIF
ELSE
   DBCLOSEAREA()
   ALERTX("Cheque Cadastro Empresa")
ENDIF
mALTINS  := ALTINS
mTIPINS  := TIPINS
mALTEND  := ALTEND
mPAG01   := PAG01
mPAG02   := PAG02
mPAG03   := PAG03
mPAG04   := PAG04
mPAG05   := PAG05
mCGCANT  := CGCANT
mCGCANT  := STRTRAN(mCGCANT,"/","")
mCGCANT  := STRTRAN(mCGCANT,".","")
mCGCANT  := STRTRAN(mCGCANT,"-","")
mCGCANT  := STRTRAN(mCGCANT," ","")
mCODIBGE := CODIBGE
mDBASE   := DBASE
mTEL     := STRTRAN(TELEFONE,"-","")
mTEL     := STRTRAN(mTEL," ","0")
mTEL     := STRZERO(VAL(mTEL),8)
mDDD     := STRTRAN(DDD,"0","")
mDDD     := STRTRAN(mDDD," ","")
mDDD     := STRZERO(VAL(DDD),2)
DBCLOSEAREA()

IF !NETUSE("BCOFGTS")
   RETU
ENDIF
DBGOTOP()
IF DBSEEK(NREMP)
   mXNOM := PADR(UPPER(ENDERECO),40)
   mXNUM := STRZERO(VAL(NUMEROEMP),6)
   mXCOM := PADR(UPPER(COMPLEMENT),21)
ELSE
   DBCLOSEAREA()
   ALERTX("Cheque Cadastro Empresa")
ENDIF
DBCLOSEAREA()

SETCOLOR("W/N,N/W")
//Registro tipo zero CabeCario So uma vez
IF lPRIMA
   mrXEND := PADR(UPPER(xrEND),40)
   mrXNUM := PADR(UPPER(xrNUM),6)
   mrXCOM := PADR(UPPER(xrCOM),21)
   mrXTEL := STRTRAN(xrTEL,"-","")
   mrXTEL := STRTRAN(mrXTEL," ","0")
   mrXTEL := STRZERO(VAL(mrxTEL),9)   //2012 9 digitos 2011 8 digitos
   mrXDDD := STRZERO(VAL(XRDDD),2)
   xmRZA  := PADR(TIRACE(UPPER(xrNOME)+SPAC(20)),40)
   xmBAI  := PADR(TIRACE(UPPER(xrBAIRRO)+SPAC(4)),19)
   xmMUN  := PADR(TIRACE(UPPER(xrCIDADE)),30)
   xmUFE  := TIRACE(UPPER(xrESTADO))
   xmCEP  := SUBSTR(xrCEP,1,5)+SUBSTR(xrCEP,7)
   xtCGC  := xrCGC
   //xMAIL:=PADR(TIRACE(UPPER(mEMAIL)),39)
   //aumento 45 rais2003
   xMAIL := PADR(TIRACE(UPPER(mEMAIL)),45)
   IF xRPESSOA = 'J'
      xmCGC := SUBSTR(xtCGC,1,2)+SUBSTR(xtCGC,4,3)+SUBSTR(xtCGC,8,3)+SUBSTR(xtCGC,12,4)+SUBSTR(xtCGC,17,2)
      xmINC := "1"  //INDICA CGC
   ELSE
      IF EMPTY(xRCEI)
         xmCGC := STRTRAN(xtCGC,".","")
         xmCGC := STRTRAN(xmCGC,"-","")
         xmCGC := STRTRAN(xmCGC," ","")
         xmCGC := STRZERO(VAL(xmCGC),14)
         xmINC := "4"   //INDICA CPF
      ELSE
         xmCGC := "00"+xRCEI
         xmINC := "3"   //INDICA CEI
      ENDIF
   ENDIF
   mXRDATA   := STRZERO(DAY(xrDATA),2)+STRZERO(MONTH(xrDATA),2)+STRZERO(YEAR(xrDATA),4)
   mXRDNRESP := STRZERO(DAY(xrDNRESP),2)+STRZERO(MONTH(xrDNRESP),2)+STRZERO(YEAR(xrDDNRESP),4)
   xGERA     := STRZERO(DAY(GERA),2)+STRZERO(MONTH(GERA),2)+STRZERO(YEAR(GERA),4)
   FWRITE(USO,STRZERO(SEQ,6))
   FWRITE(USO,XMCGC)
   FWRITE(USO,"00")
   FWRITE(USO,"0")
   FWRITE(USO,"1")
   FWRITE(USO,XMCGC)
   FWRITE(USO,xmINC)
   FWRITE(USO,xmRZA)
   FWRITE(USO,mrXEND)
   FWRITE(USO,mrXNUM)
   FWRITE(USO,mrXCOM)
   FWRITE(USO,xmBAI)
   FWRITE(USO,xmCEP)
   FWRITE(USO,xrCODIBGE)
   FWRITE(USO,xmMUN)
   FWRITE(USO,xmUFE)
   FWRITE(USO,mrXDDD)
   FWRITE(USO,mrXTEL)
   FWRITE(USO,xrRET)
   FWRITE(USO,IF(xrRET = "1",mxrDATA,"00000000"))
   FWRITE(USO,xGERA)
   FWRITE(USO,xMAIL)
   FWRITE(USO,PADR(mRESPONSAV,52))
   FWRITE(USO,SPACE(24))  // FWRITE(USO,SPACE(20))
   // FWRITE(USO,"0551")
   FWRITE(USO,STRZERO(VAL(TIRAOUT(mCPFRESP)),11))
   FWRITE(USO,STRZERO(0,12))  //CREA
   FWRITE(USO,mxrDNRESP)
   FWRITE(USO,repl(" ",159))  // FWRITE(USO,repl(" ",160)) um a menos 8/9 digitos telefone 2012
   FWRITE(USO,CHR(13)+CHR(10))
   SEQ ++
   lPRIMA := .F.
ENDIF

//Registro Tipo 1 Empresa
FWRITE(USO,STRZERO(SEQ,6))
FWRITE(USO,mCGC)
FWRITE(USO,"00")
FWRITE(USO,"1")
FWRITE(USO,PADR(mRZA,52))
FWRITE(USO,mXNOM)
FWRITE(USO,mXNUM)
FWRITE(USO,mXCOM)
FWRITE(USO,mBAI)
FWRITE(USO,mCEP)
FWRITE(USO,mCODIBGE)
FWRITE(USO,PADR(mMUN,30))
FWRITE(USO,PADR(mUFE,2))
FWRITE(USO,mDDD)
FWRITE(USO,mTEL)
FWRITE(USO,xMAIL)
FWRITE(USO,mATI)
FWRITE(USO,mNAT)
FWRITE(USO,STRZERO(mPRO,2))
FWRITE(USO,STRZERO(mDBASE,2))
FWRITE(USO,mINC)  //1=CGC 3=CEI
FWRITE(USO,mRAISNEG)
FWRITE(USO,"00")  //Zeros
FWRITE(USO,REPL("0",12))
FWRITE(USO,STRZERO(ANOBASE,4))
FWRITE(USO,mPORTE)
FWRITE(USO,mSIMPLES)
FWRITE(USO,mPAT)
FWRITE(USO,STRZERO(mPATMENOS,6))
FWRITE(USO,STRZERO(mPATMAIS,6))
FWRITE(USO,STRZERO(nPER01,3))
FWRITE(USO,STRZERO(nPER02,3))
FWRITE(USO,STRZERO(nPER03,3))
FWRITE(USO,STRZERO(nPER04,3))
FWRITE(USO,STRZERO(nPER05,3))
FWRITE(USO,STRZERO(nPER06,3))
FWRITE(USO,mENCERRA)
FWRITE(USO,IF(mENCERRA = "1",mDEND,"00000000"))
FWRITE(USO,XCNPJPAT)  //cnpj entidade patronal
FWRITE(USO,GRVVAL(XVALPAT,9,2))   //valor entidade patronal
FWRITE(USO,XCNPJSIN)  //cnpj entidade contribuicao sindical
FWRITE(USO,GRVVAL(XVALSIN,9,2))   //valor entidade contribuicao sindical
FWRITE(USO,XCNPJASS)  //cnpj entidade contribuicao assistencial
FWRITE(USO,GRVVAL(XVALASS,9,2))   //valor entidade contribuicao assistencial
FWRITE(USO,XCNPJCON)  //cnpj entidade contribuicao confederativa
FWRITE(USO,GRVVAL(XVALCON,9,2))   //valor entidade contribuicao confederativa
fwrite(USO,xEXERCE)   //Exerceu atividade
fwrite(uso,mCGCCEN)   //cnpj centralizadora
fwrite(uso,XEMPSIN)   // sindicalizada 1sim 2ano
fwrite(uso,xPTOREP)   //TIPO REp
fwrite(uso,repl(" ",85))  //Brancos
FWRITE(USO,STRZERO(NREMP,12))   //Codigo da Empresa
FWRITE(USO,CHR(13)+CHR(10))   //FECHAR LINHA

SEQ ++
PATHRE := HB_CWD()+'EMP'+ANOWORK+STRZERO(NREMP,3)+"\"
IF NRSEN <> 'DiReT'
   PESRE   := PATHRE+'FO_PES'
   FOLRE   := 'FP'+EMP+ARQMES
   ARQRAIS := PATHRE+'FORAIS'
ELSE
   PESRE   := PATHRE+'FO_DIR'
   FOLRE   := 'SO'+EMP+ARQMES
   ARQRAIS := PATHRE+'FORAISD'
ENDIF

IF !NETUSE(PESRE)
   DBCLOSEALL()
   FCLOSE(USO)
   RETU .F.
ENDIF
FILTRO   := 'EMPTY(DEMITIDO) .OR. YEAR(DEMITIDO)=ANOBASE'
FILFUN   := FILTRO(FILTRO)
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","pis")  //  eval zei_fort(nLASTREC,,,1)
ordSetFocus("temp")
SET FILTER TO &FILFUN

IF !NETUSE(ARQRAIS)
   DBCLOSEALL()
   RETU .F.
ENDIF

DBSELECTAR(PESRE)
DBGOTOP()
WHILE !EOF()
   PETELA(8)
   mNUMERO := NUMERO
   mPIS    := PIS
   mNOM    := TIRACE(UPPER(NOME))
   mCTP    := IF(left(TIRAOUT(CPF),7) = PROFIS,strzero(val(TIRAOUT(CPF)),13),strzero(val(PROFIS),8)+strzero(val(SERIE),5))
   mNSC    := STRZERO(DAY(NASC),2)+STRZERO(MONTH(NASC),2)+STRZERO(YEAR(NASC),4)
   mADM    := STRZERO(DAY(ADMITIDO),2)+STRZERO(MONTH(ADMITIDO),2)+STRZERO(YEAR(ADMITIDO),4)
   tFGTS   := DTOC(FGTS)
   mFGT    := SUBST(tFGTS,4,2)+SUBSTR(tFGTS,7,2)

   //Rais 2003 Cbo Novo
   //mCBO=SUBSTR(CBO,1,5)

   mCBO  := OBTER("FUNCAO",,FUNCAO,"CBONEW")  //CBONEW CBONEW
   mRACA := OBTER("FO_TAB",,"RACS"+ALLTRIM(STR(RACS)),"CODIG2")
   mDEFI := IF(EMPTY(DEFICI),"0",DEFICI)
   IF mDEFI = "S"
      mDEFI := "9"  //forca preenchimento valores validos 1-6
   ENDIF
   IF mDEFI = "N"
      mDEFI := "0"
   ENDIF
   mSEXO := IF(SEXO = "M","1","2")
   mSIND := IF(EMPTY(SOCIOSIND),"N",SOCIOSIND)
   mSIND := IF(mSIND = "N","2","1")

   mESC := ESCRAIS  //STRZERO(ESCOLA,2)
   IF mESC = "10"
      mESC := "09"
   ENDIF
   IF mESC = "11"
      mESC := "10"
   ENDIF
   IF mESC = "12"
      mESC := "11"
   ENDIF


   mTIP := TIPO
   mNAC := BacenNacion(NASCPAIS)
   mNAC := STRZERO(mNAC,2)  //layout ainda 2
   mCHE := IF(mNAC # "10",STRZERO(ANONASCI,4),"0000")

   IF EMPTY(DEMITIDO)
      tSAL := SALDEZ
   ELSE
      MESDEM := MONTH(DEMITIDO)
      XSAL   := MMES(MONTH(DEMITIDO))
      XSAL   := SUBSTR(XSAL,1,3)
      XSAL   := 'SAL'+XSAL
      tSAL   := &XSAL
   ENDIF
   tSAL := STRZERO(tSAL,10,2)
   mSAL := STRTRAN(tSAL,".","")
   mHOR := STRZERO(HRSEM,2)

   tDEM := DTOC(DEMITIDO)
   mDEM := IF(EMPTY(DEMITIDO),'0000',SUBST(tDEM,1,2)+SUBSTR(tDEM,4,2))
   mCPF := STRTRAN(CPF,".","")
   mCPF := STRTRAN(mCPF,"-","")
   mCPF := STRTRAN(mCPF," ","")
   mCPF := STRZERO(VAL(mCPF),11)

   DBSELECTAR("FORAIS")
   DBGOTOP()
   IF DBSEEK(STR(ANOUSO,4)+STR(mNUMERO,8))
      mVIN     := RAISVINC
      mSIT     := RAISSITU
      mMOT     := IF(EMPTY(RAISDEM),'00',RAISDEM)
      mALVARA  := IF(EMPTY(ALVARA),"N",ALVARA)
      mALVARA  := IF(mALVARA = "N","2","1")
      mTIPOADM := TIPOADM
      m13B     := STRZERO(MES_1,2)
      m13D     := STRZERO(MES_2,2)
      //mNES    = STRZERO(AVOSM,2)
      m13A    := GRVVAL(SAL13_1,9,2)
      m13C    := GRVVAL(SAL13_2,9,2)
      mJAN    := GRVVAL(RAIZJAN,9,2)
      mFEV    := GRVVAL(RAIZFEV,9,2)
      mMAR    := GRVVAL(RAIZMAR,9,2)
      mABR    := GRVVAL(RAIZABR,9,2)
      mMAI    := GRVVAL(RAIZMAI,9,2)
      mJUN    := GRVVAL(RAIZJUN,9,2)
      mJUL    := GRVVAL(RAIZJUL,9,2)
      mAGO    := GRVVAL(RAIZAGO,9,2)
      mSET    := GRVVAL(RAIZSET,9,2)
      mOUT    := GRVVAL(RAIZOUT,9,2)
      mNOV    := GRVVAL(RAIZNOV,9,2)
      mDEZ    := GRVVAL(RAIZDEZ,9,2)
      mAVISO  := GRVVAL(RAIZAVI,9,2)
      lGRAVA  := .T.
      TOTRAIZ := RAIZJAN+RAIZFEV+RAIZMAR+RAIZABR+RAIZMAI+RAIZJUN
      TOTRAIZ := TOTRAIZ+RAIZJUL+RAIZAGO+RAIZSET+RAIZOUT+RAIZNOV+RAIZDEZ
      TOTRAIZ := TOTRAIZ+SAL13_1+SAL13_2+RAIZAVI
      IF TOTRAIZ = 0
         IF MDG("Funcionário sem Remuneração - Excluir Rais")
            lGRAVA := .F.
         ENDIF
      ENDIF
      IF lGRAVA
         FWRITE(USO,STRZERO(SEQ,6))
         FWRITE(USO,mCGC)
         FWRITE(USO,"00")
         FWRITE(USO,'2')
         FWRITE(USO,mPIS)
         FWRITE(USO,PADR(mNOM,52))
         FWRITE(USO,mNSC)
         FWRITE(USO,mNAC)
         FWRITE(USO,mCHE)
         FWRITE(USO,mESC)
         FWRITE(USO,mCPF)
         FWRITE(USO,mCTP)
         FWRITE(USO,mADM)
         FWRITE(USO,PADR(mTIPOADM,2))
         FWRITE(USO,mSAL)
         FWRITE(USO,mTIP)
         FWRITE(USO,mHOR)
         FWRITE(USO,mCBO)
         FWRITE(USO,mVIN)
         FWRITE(USO,mMOT)
         FWRITE(USO,mDEM)

         FWRITE(USO,mJAN)
         FWRITE(USO,mFEV)
         FWRITE(USO,mMAR)
         FWRITE(USO,mABR)
         FWRITE(USO,mMAI)
         FWRITE(USO,mJUN)
         FWRITE(USO,mJUL)
         FWRITE(USO,mAGO)
         FWRITE(USO,mSET)
         FWRITE(USO,mOUT)
         FWRITE(USO,mNOV)
         FWRITE(USO,mDEZ)
         FWRITE(USO,m13A)
         FWRITE(USO,m13B)
         FWRITE(USO,m13C)
         FWRITE(USO,m13D)

         FWRITE(USO,mRACA)
         FWRITE(USO,IF(mDEFI = "0","2","1"))  //0 sem deficiencia 1=sim 2=nao
         FWRITE(USO,mDEFI)  //Codigo da deficiencia
         FWRITE(USO,mALVARA)
         FWRITE(USO,mAVISO)
         FWRITE(USO,mSEXO)

         //Incluido Afastamentos Rais 2003
         //1Ý
         FWRITE(USO,STRZERO(VAL(CODAFA01),2))
         FWRITE(USO,STRZERO(VAL(INIAFA01),4))
         FWRITE(USO,STRZERO(VAL(FIMAFA01),4))
         //2Ý
         FWRITE(USO,STRZERO(VAL(CODAFA02),2))
         FWRITE(USO,STRZERO(VAL(INIAFA02),4))
         FWRITE(USO,STRZERO(VAL(FIMAFA02),4))
         //3Ý
         FWRITE(USO,STRZERO(VAL(CODAFA03),2))
         FWRITE(USO,STRZERO(VAL(INIAFA03),4))
         FWRITE(USO,STRZERO(VAL(FIMAFA03),4))
         //Qtde Dias
         FWRITE(USO,STRZERO(DIASAFA,3))


         fwrite(USO,GRVVAL(RAIZFER,8,2))  //ferias indenizadas

         fwrite(USO,GRVVAL(RAIZBCH,8,2))  //banco de horas
         fwrite(uso,STRZERO(MESBCH,2))  //qtde competencias

         fwrite(USO,GRVVAL(RAIZACR,8,2))  //acrescimo categoria
         fwrite(uso,STRZERO(MESACR,2))  //qtde competencias

         fwrite(USO,GRVVAL(RAIZGRA,8,2))  //gratificacoes
         fwrite(uso,STRZERO(MESGRA,2))  //qtde competencias

         fwrite(USO,GRVVAL(RAIZMUL,8,2))  //multa fgts


         //1a Ocorrencia
         FWRITE(USO,STRZERO(VAL(CGCSOC1),14))   //cnpj entidade contribuicao associativa
         FWRITE(USO,GRVVAL(VALSOC1,8,2))  //valor entidade contribuicao associativa
         //2a Ocorrencia
         FWRITE(USO,STRZERO(VAL(CGCSOC2),14))   //cnpj entidade contribuicao associativa
         FWRITE(USO,GRVVAL(VALSOC2,8,2))  //valor entidade contribuicao associativa
         //contibuicao sindical
         FWRITE(USO,STRZERO(VAL(CGCSIN),14))  //cnpj
         FWRITE(USO,GRVVAL(VALSIN,8,2))   //valor
         //contibuicao assistencial
         FWRITE(USO,STRZERO(VAL(CGCASS),14))  //cnpj
         FWRITE(USO,GRVVAL(VALASS,8,2))   //valor
         //contibuicao confederativa
         FWRITE(USO,STRZERO(VAL(CGCCON),14))  //cnpj
         FWRITE(USO,GRVVAL(VALCON,8,2))   //valor

         //codigo municipio servicos
         FWRITE(USO,STRZERO(VAL(IBGECOD),7))  //valor

         //horas trabalhadas
         FWRITE(USO,strzero(horjan,3))  //jan
         FWRITE(USO,strzero(horfev,3))  //fev
         FWRITE(USO,strzero(hormar,3))  //mar
         FWRITE(USO,strzero(horabr,3))  //abr
         FWRITE(USO,strzero(hormai,3))  //mai
         FWRITE(USO,strzero(horjun,3))  //jun
         FWRITE(USO,strzero(horjul,3))  //jul
         FWRITE(USO,strzero(horago,3))  //ago
         FWRITE(USO,strzero(horset,3))  //set
         FWRITE(USO,strzero(horout,3))  //out
         FWRITE(USO,strzero(hornov,3))  //nov
         FWRITE(USO,strzero(hordez,3))  //dez

         FWRITE(USO,mSIND)  //Sindicalizado 1 sim 2 nao
         FWRITE(USO,STRZERO(mNUMERO,6))
         FWRITE(USO,STRZERO(NREMP,6))
         FWRITE(USO,CHR(13)+CHR(10))  //FECHAR LINHA
         mFUN ++
         SEQ ++
      ENDIF
   ENDIF
   DBSELECTAR(PESRE)
   DBSKIP()
ENDDO
DBCLOSEAREA()


//Encerramento do Arquivo  9
FWRITE(USO,STRZERO(SEQ,6))  //06
FWRITE(USO,mCGC)  //14
FWRITE(USO,"00")  //02
FWRITE(USO,"9")   //01
FWRITE(USO,STRZERO(1,6))  //06
FWRITE(USO,STRZERO(mFUN,6))   //06
FWRITE(USO,SPACE(516))  //515
FWRITE(USO,CHR(13)+CHR(10))   //FECHAR LINHA
FWRITE(USO,CHR(26))   //FECHAMENTO ARQUIVO
FCLOSE(USO)

IF MDG("Deseja Ver o Arquivo")
   VERTXT(RAISARQ)
ENDIF
IF MDG("Deseja imprimir o Arquivo")
   imparq(RAISARQ,,,,,,,550,)
ENDIF

ALERTX("NAo EsqueCa de Utilizar o Validador/Importador")

RETU




*+ EOF: folis_a6.prg
*+
