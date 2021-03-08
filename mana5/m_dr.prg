*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_dr.prg
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
// :   M_DR   .PRG : Mala Direta
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :  Procs & Fncts: fMDR()
// :
// :    Chamado por:
// :
// :          Chama: fMDR  (fun��o em M_DR.PRG )
// :
// :  Arq. Dados   : MALA       - Mala Direta
// :
// :  Indices      : MALA       - Numero de Controle
// :                 NUMERO
// :
// :
// :  Documentado em:  29, 1994 as 13:08:07                DISK!  vers�o 5.01
// :*****************************************************************************



//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
// #INCLUDE "MEMOGET.CH"

aVARL := {}   //Variavel de Pr� Lan�amento

//Monta Pr� Lan�amento
IF USEREDE(HELPARQ,1,1)
   DBGOTOP()
   DBSEEK(ARQWORK)
   WHILE DBF = ARQWORK .AND. !EOF()
      IF !EMPTY(PRELAN)
         AADD(aVARL,{CAMPO,PRELAN})
      ENDIF
      DBSKIP()
   ENDDO
   DBCLOSEAREA()
ENDIF



PADRAO(0,1,0,ARQWORK,"Numero  Nome",;
 "' '+STR(mNUMERO,  8)+' '+mNOME",;
 "MDR","MDR001",{|| gMDR()})


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MDRINS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MDRINS

mNUMERO := ULTIMOREG(ARQWORK,"NUMERO")
mNUMERO ++
IF !EMPTY(aVARL)
   FOR X := 1 TO LEN(aVARL)
      cCAMPO   := aVARL[X,1]
      cVAR     := aVARL[X,2]
      &cCAMPO. := &cVAR.
   NEXT X
ENDIF




//Get Nas Mvars

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gMDR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC gMDR

SETCOLOR(CORPAD[2])
@  4,10 GET mNOME                                                                                                                                                                                                   
@  7,1  GET mESTADO                                        VALID CHECKUF("mESTADO")                                                                                                                                 
@  7,5  GET mCIDADE                                        VALID CHECKCID(mESTADO,"mCIDADE")                                                                                                                        
@  7,43 GET mBAIRRO                                                                                                                                                                                                 
@ 10,1  GET mENDLOG                                        WHEN IF(EMPTY(mENDLOG),ESCOLHELOG("mENDLOG"),.T.)                                                                                                        
@ 10,14 GET mENDRUA                                        VALID ENDCID(mESTADO,mCIDADE,"mENDRUA","mCEP","mENDNUM") .AND. MDR01(11,1)                                                                               
@ 10,64 GET mENDNUM                                        VALID ENDCID(mESTADO,mCIDADE,"mENDRUA","mCEP","mENDNUM") .AND. MDR01(11,1)                                                                               
@ 11,1  GET mENDERECO                                      WHEN EMPTY(mENDLOG)                                                                                                                                      
@ 11,70 GET mCEP                                           PICTURE "99999-999"                                                        WHEN VERCEP("mCEP")   VALID CHECK5CEP(mCEP) .AND. CHKUFCEP(mCEP,mESTADO)      
@ 14,1  GET mDDD                                           WHEN VERDDD("mDDD")                                                                                                                                      
@ 14,6  GET mTELEFONE                                                                                                                                                                                               
@ 14,16 GET mCONTATO                                                                                                                                                                                                
@ 14,27 GET mDATACONTA                                                                                                                                                                                              
@ 14,41 GET mIMPRIME                                       PICTURE "!"                                                                VALID mIMPRIME $ 'SN'                                                         
// @ 17,1  GET mOBS MEMO coord {17,1,23,78} //boxcolor MCFN03                                                                                                                                                          
IF !READCUR()
   RETU .T.
ENDIF

RETU .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MDR01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MDR01(nROW,nCOL,eDIZ)

IF VALTYPE(nROW) # "N"
   nROW := 24
ENDIF
IF VALTYPE(nCOL) # "N"
   nCOL := 01
ENDIF
IF !EMPTY(mENDLOG)
   mENDERECO := PADR(ALLTRIM(mENDLOG)+' '+ALLTRIM(mENDRUA)+' '+ALLTRIM(mENDNUM),68)
   IF VALTYPE(eDIZ) = "C"
      @ nROW,nCOL SAY &eDIZ         
   ELSE
      @ nROW,nCOL SAY mENDERECO         
   ENDIF
ENDIF
RETU .T.
