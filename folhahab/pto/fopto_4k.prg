*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_4k.prg
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
*+    Documentado em 27-Dez-2024 as  9:33 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

CABE2("FOPTO_4K - Lan‡amento Multiplos Banco de Horas")

cBH := IF(lSECBCO,"BK","BH")+ANOMESW  //ANOWORK+strzero(mestrab,2)

CHECKCRI(cBH,"BCOREQ","REQUISI")
CRIARVARS(cBH)

@ 23,00
@ 24,00
@ 23,10 SAY "Data     T  Horas  Dias Obs"                                   
@ 24,10 GET mDATA                                                           
@ 24,19 GET mTIPO                         VALID mTIPO $ "CD" PICT "!"       
@ 24,22 GET mHORAS                        PICT '999.99'                     
@ 24,29 GET mDIAS                         PICT '999.99'                     
@ 24,35 GET mOBS                          PICT "@S40"                       
IF !READCUR()
   RETU .F.
ENDIF

//SELE 1
IF !NETUSE(PES)
   RETU
ENDIF
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
FILTRO := FILTRO(FILTRO)
SET FILTER TO &FILTRO
//SELE 2
IF !NETUSE(cBH)
   DBCLOSEALL()
   RETU
ENDIF
DBGOBOTTOM()
mREQUISI := REQUISI
mREQUISI ++

dbselectar(pes)
DBGOTOP()
WHILE !EOF()
   mNUMERO := NUMERO
   dbselectar(cBH)
   netrecapp()
   REPLVARS()
   mREQUISI ++
   dbselectar(pes)
   DBSKIP()
ENDDO
DBCLOSEALL()

FOPTO4Q01()   //Ajusta Saldos

*+ EOF: fopto_4k.prg
*+
