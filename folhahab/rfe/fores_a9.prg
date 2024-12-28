*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fores_a9.prg
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
*+    Documentado em 27-Dez-2024 as  9:41 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

#INCLUDE "BOX.CH"

PADRAO("PROVFE","PROVFE","' '+STR(mNUMERO,  8)+' '+DTOC(mCOMP)+' '+STR(mMES,  2)+' '+STR(mANO,  4)+' '+STR(mDEPTO,  4)+' '+STR(mSETOR,  3)+' '+STR(mSECAO,  3)+' '+STR(mVALTOT, 12, 2)","STRZERO(mNUMERO,8)+DTOS(mCOMP)+STRZERO(mANO,4)+STRZERO(mMES,2)","Provis„o Ferias Acumulada","Numero   Comp.    Mes/Ano Dep  Set Sec Valor",;
 {|| alltrue(mCHAVE := STRZERO(mNUMERO,8)+DTOS(mCOMP)+STRZERO(mANO,4)+STRZERO(mMES,2))},{|| tRESA9()},{|| gRESA9()},{|| FO_FOR("GRUPO='PROVFE'")})

//{||iRESA9()}
MMES := MMES(OP)  //Volta Status
RETU .T.

//alltrue(mCHAVE:=STRZERO(mNUMERO,8)+DTOS(mCOMP)+STRZERO(mANO,4)+STRZERO(mMES,2))

//FUNC iRESA9
//mCHAVE:=STRZERO(mNUMERO,8)+DTOS(mCOMP)+STRZERO(mANO,4)+STRZERO(mMES,2)
//RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function tRESA9()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC tRESA9

HB_DISPBOX(3,0,23,79,B_DOUBLE)
@  4,1 SAY "Numero   Compete. Mes/Ano Dep  Set Sec Salario"+spac(6)+"Sal.Variavel"         
@  7,1 SAY "Avos Dias Valor"+spac(8)+"1/3"+spac(10)+"Encargos     Total"                   
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gRESA9()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC gRESA9

@  5,1  SAY mNUMERO  PICTURE '99999999'            
@  5,10 SAY mCOMP                                  
@  5,19 SAY mMES     PICTURE '99'                  
@  5,22 SAY mANO     PICTURE '9999'                
@  5,27 SAY mDEPTO   PICTURE '9999'                
@  5,32 SAY mSETOR   PICTURE '999'                 
@  5,36 SAY mSECAO   PICTURE '999'                 
@  5,40 GET mSALARIO PICTURE '999999999.99'        
@  5,53 GET mSALVAR  PICTURE '999999999.99'        
@  8,2  GET mAVOS    PICTURE '99'                  
@  8,7  GET mDIAS    PICTURE '99'                  
@  8,11 GET mVALOR   PICTURE '999999999.99'        
@  8,24 GET mVALTER  PICTURE '999999999.99'        
@  8,37 GET mVALENC  PICTURE '999999999.99'        
@  8,50 GET mVALTOT  PICTURE '999999999.99'        
READCUR()
RETU .T.


*+ EOF: fores_a9.prg
*+
