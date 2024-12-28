*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foug.prg
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

////#INCLUDE "COMANDO.CH"
#INCLUDE "INKEY.CH"
#INCLUDE "BOX.CH"

CABEX('Requerimento de Seguro Desemprego - SD')
IF EMPTY(ZPESSOA)
   ALERTX("Cadastre Tipo de Pessoa Cadastro Empresa")
   RETU .F.
ENDIF
IF EMPTY(CGC1)
   ALERTX("Cadastre CPF ou CGC Cadastro Empresa")
   RETU .F.
ENDIF

mCONTINUA := " "
mNUMERO   := 0
MDS("Qual Funcionario")
@ 24,40 GET mNUMERO         
IF !READCUR()
   RETU .F.
ENDIF

IF !NETUSE(PES)
   RETU .F.
ENDIF
DBGOTOP()
IF !DBSEEK(mNUMERO)
   DBCLOSEAREA()
   ALERTX("Funcion rio nao Cadastrado")
   RETU .F.
ENDIF
mNOME     := NOME
mENDERECO := ENDER+","+alltrim(ENDNUM)+" "+alltrim(ENDCOMPL)
mCEP      := CEP
mUF       := ESTADO
//mTELEFONE:=TELEFONE
mTELEFONE := SPACE(10)
mMAE      := MAE
mPIS      := PIS
mCTPS     := IF(left(TIRAOUT(CPF),7) = PROFIS,CPF,PROFIS)   //CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
mSERIE    := RIGHT(SERIE,3)
mCTPSUF   := CTPSUF
mCBONEW   := OBTER("FUNCAO",,FUNCAO,"CBONEW")   //CBONEW
mOCUPACAO := OBTER("FUNCAO",,FUNCAO,"NOME")
mADM      := ADMITIDO
mDEM      := DEMITIDO
mSEXO     := IF(SEXO = "M","1","2")
mINST     := ESCRAIS  //ESCOLA
mNAS      := NASC
mHORAS    := HRSEM
mMES01    := MONTH(DEMITIDO) - 2
IF mMES01 <= 0
   mMES01 += 12
ENDIF
mMES02 := MONTH(DEMITIDO) - 1
IF mMES02 <= 0
   mMES02 += 12
ENDIF
mMES03 := MONTH(DEMITIDO)
mSAL01 := SALMES(mMES01)
mSAL02 := SALMES(mMES02)
mSAL03 := SALMES(mMES03)
mMESES := (DEMITIDO - ADMITIDO) / 30
IF mMESES > 36
   mMESES := 36
ENDIF
DBCLOSEAREA()
DO CASE
CASE ZPESSOA = 'J'
   mINSREP := SUBSTR(CGC1,1,2)+SUBSTR(CGC1,4,3)+SUBSTR(CGC1,8,3)+SUBSTR(CGC1,12,4)+SUBSTR(CGC1,17,2)
   mTIPREP := "1"
CASE ZPESSOA = 'C'
   mINSREP := "00"+ZCEI
   mTIPREP := "2"
CASE ZPESSOA = 'F'
   mINSREP := "000"+SUBSTR(CGC1,1,3)+SUBSTR(CGC1,5,3)+SUBSTR(CGC1,9,3)+SUBSTR(CGC1,13,2)
   mTIPREP := "3"
ENDCASE
mCNAE   := OBTER("FIRMA",,NREMP,"ATIVIDADE")
mBCO    := OBTER("BCOFGTS",,NREMP,"NUMERO")
mAGE    := OBTER("BCOFGTS",,NREMP,"AGENCIA")
mDIV    := OBTER("BCOFGTS",,NREMP,"DIVAGENCI")
mNBCO   := SPACE(20)
mRECEBE := "2"
mAVISO  := "2"


HB_DISPBOX(4,0,23,79,B_DOUBLE+" ")
@  5,2  SAY "CONFIRA COM ATENCAO OS DADOS ABAIXO - CONSULTE O MANUAL SEGURO DESEMPREGO"         
@  6,2  SAY "Tipo Inscri‡„o"+spac(7)+"Atividade   Bco Age  D Nome"                              
@  9,2  SAY "Nome:"+spac(26)+"Mae:"                                                             
@ 11,2  SAY "Endere‡o"+spac(23)+"CEP"+spac(7)+"Estado Telefone"                                 
@ 13,2  SAY "Pis:"+spac(8)+"CTPS"+spac(13)+"CBO   Ocupacao"                                     
@ 15,2  SAY "Admitido Demitido Sexo 1-Mas G.Ins Nascimento HR."                                 
@ 16,25 SAY "2-Fem"                                                                             
@ 17,2  SAY "Sal rios"                                                                          
@ 19,2  SAY "Quantidade Meses trabalhados ultimos 36"                                           
@ 20,2  SAY "Recebeu Salarios em 6 ultimos Meses"+spac(9)+"(1-Sim 2-N„o)"                       
@ 21,2  SAY "Aviso Previo Indenizado:"+spac(20)+"(1-Sim 2-N„o)"                                 
@ 22,2  SAY "Tudo Ok Deseja Continuar"+spac(20)+"(S-Sim Continua)"                              

WHILE mCONTINUA <> "S"
   set key K_F11 to TECLAF11
   // Get nas Menvars
   @  7,2  GET mTIPREP   PICT "!"                                                                                 VALID mTIPREP $ '12'                                                        
   @  7,4  GET mINSREP                                                                                                                                                                        
   @  7,23 GET mCNAE     VALID VERSEHA("FO_CNAE2",,mCNAE,"DESCRICAO","'Codigo de Atividade inconsistente '")                                                                                  
   @  7,35 GET mBCO                                                                                                                                                                           
   @  7,39 GET mAGE                                                                                                                                                                           
   @  7,44 GET mDIV                                                                                                                                                                           
   @  7,46 GET mNBCO                                                                                                                                                                          
   @ 10,2  GET mNOME                                                                                                                                                                          
   @ 10,33 GET mMAE      PICTURE "@S30"                                                                                                                                                       
   @ 12,2  GET mENDERECO                                                                                                                                                                      
   @ 12,33 GET mUF       PICTURE "!!"                                                                             VALID CHECKTAB(PADR("UF",4)+PADR(mUF,5),24,0,"Estado N„o Cadastrado")       
   @ 12,43 GET mCEP      PICTURE "#####-###"                                                                      VALID CHKUFCEP(mCEP,mUF)                                                    
   @ 12,50 GET mTELEFONE                                                                                                                                                                      
   @ 14,2  GET mPIS      VALID VALPIS(mPIS,.t.,.t.,mEVINC)                                                                                                                                    
   @ 14,14 GET mCTPS     PICTURE "999999"                                                                                                                                                     
   @ 14,22 GET mSERIE    PICTURE "99999"                                                                                                                                                      
   @ 14,28 GET mCTPSUF   PICTURE "!!"                                                                                                                                                         
   @ 14,31 GET mCBONEW   VALID VERSEHA("FO_CBON",,mCBONEW,"STRZERO(CAGEDESCO,2)+' '+NOME",'"CBO Nao Cadastrado"')                                                                             
   @ 14,37 GET mOCUPACAO                                                                                                                                                                      
   @ 16,2  GET mADM                                                                                                                                                                           
   @ 16,11 GET mDEM                                                                                                                                                                           
   @ 16,21 GET mSEXO     VALID mSEXO $ "12"                                                                                                                                                   
   @ 16,32 GET mINST     valid CHECKTAB("EESC"+mINST,24,0,"Escolaridade nao Cadastrada")                                                                                                      
   @ 16,37 GET mNAS                                                                                                                                                                           
   @ 16,48 GET mHORAS    PICTURE '99.99'                                                                          VALID mHORAS > 0                                                            
   @ 18,2  GET mMES01    PICT "99"                                                                                                                                                            
   @ 18,5  GET mSAL01    PICT "999,999.99"                                                                                                                                                    
   @ 18,18 GET mMES02    PICT "99"                                                                                                                                                            
   @ 18,21 GET mSAL02    PICT "999,999.99"                                                                                                                                                    
   @ 18,34 GET mMES03    PICT "99"                                                                                                                                                            
   @ 18,37 GET mSAL03    PICT "999,999.99"                                                                                                                                                    
   @ 19,43 GET mMESES    PICT "99"                                                                                                                                                            
   @ 20,43 GET mRECEBE                                                                                                                                                                        
   @ 21,43 GET mAVISO                                                                                                                                                                         
   @ 22,43 GET mCONTINUA PICT "!"                                                                                                                                                             
   IF !READCUR()
      set key K_F11
      RETU .F.
   ENDIF
   set key K_F11
ENDDO

IF !CHECKIMP(0)
   RETU .F.
ENDIF

IF !netuse("REL2")  //AREDE("REL2","REL2",1)
   RETU
ENDIF
IF !DBSEEK('CD')
   ALERTX("Configura‡ao Nao Encontrada CD")
   DBCLOSEALL()
   RETU .F.
ENDIF
INITVARS()
EQUVARS()

mINST := VAL(mINST)
IF mINST > 10
   mINST := "9"
ELSE
   mINST := STR(mINST,1)
ENDIF

IMPRESSORA()
FOUG01(mA,mB,mNOME)
FOUG01(mC,mB,mENDERECO)
FOUG01(mC,mD,mCEP)
FOUG01(0,mE,mUF)
FOUG01(0,mF,mTELEFONE)
FOUG01(mC,mB,mMAE)
FOUG01(mG,mH,mTIPREP)
FOUG01(mI,mJ,mINSREP)
FOUG01(0,mK,mCNAE,5)
FOUG01(mC,mB,mPIS)
FOUG01(0,mL,mCTPS,5)
FOUG01(0,mM,mSERIE,3)
FOUG01(0,mK,mCTPSUF)
FOUG01(mC,mB,mCBONEW)
FOUG01(0,mN,mOCUPACAO)
FOUG01(mO,mB,mADM)
FOUG01(0,mP,mDEM)
FOUG01(0,mQ,mSEXO)
FOUG01(0,mR,mINST,1)
FOUG01(0,mS,mNAS)
FOUG01(0,mT,mHORAS,2)
FOUG01(mC,mB,mMES01,2)
FOUG01(0,mU,mSAL01,11,2)
FOUG01(0,mV,mMES02,2)
FOUG01(0,mW,mSAL02,11,2)
FOUG01(0,mX,mMES03,2)
FOUG01(0,mY,mSAL03,11,2)
FOUG01(mC,mB,mSAL01+mSAL02+mSAL03,12,2)
FOUG01(0,mV,mBCO,3)
FOUG01(0,mZ,mAGE)
FOUG01(0,mAA,mDIV)
FOUG01(0,mK,mNBCO)
FOUG01(mC,mV,mMESES,2)
FOUG01(0,mAB,mRECEBE)
FOUG01(0,mAC,mAVISO)
FOUG01(mAD,mB,mPIS)
FOUG01(mC,mB,mNOME)
FOUG01(mG,mAE,MSG2,,,.F.)
FOUG01(mO,mAF,CID1,,,.F.)
FOUG01(0,mJ,DAY(ZDATA),2,,.F.)
FOUG01(0,mJ+5,MONTH(ZDATA),2,,.F.)
FOUG01(0,mJ+10,YEAR(ZDATA),4,,.F.)
IMPFOL()
VIDEO()
IMPEND()


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOUG01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC FOUG01(nROW,nCOL,eVAR,nDEC,nSUB,lEXP)

IF VALTYPE(lEXP) # "L"
   lEXP := .T.
ENDIF
IF VALTYPE(eVAR) = "N"
   IF VALTYPE(nSUB) = "N"
      eVAR := STRZERO(eVAR,nDEC,nSUB)
      eVAR := STRTRAN(eVAR,".","")
   ELSE
      eVAR := STRZERO(eVAR,nDEC)
   ENDIF
ENDIF
IF VALTYPE(eVAR) = "D"
   eVAR := DTOC(eVAR)
   eVAR := STRTRAN(eVAR,"/","")
ENDIF
IF lEXP
   @ PROW()+nROW,nCOL SAY expand(evar,2)         
ELSE
   @ PROW()+nROW,nCOL SAY eVAR         
ENDIF
RETU .F.


*+ EOF: foug.prg
*+
