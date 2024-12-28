*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_24.prg
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
*+    Documentado em 27-Dez-2024 as  9:32 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :  FOPTO_24.PRG : Alterar a Totaliza‡„o do Ponto
// :
// :*****************************************************************************


////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOPTO_24()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION FOPTO_24

PARA nTIPO

CABE2('FOPTO_24 - Alterar a Totalizacao do Ponto')

lVALORES  := MDG("Editar Valores")
lVALBANCO := MDG("Editar Banco")
cPT       := "XX"
DO CASE
CASE nTIPO = 1
   cPT := "PT"+ANOMESW
   PADRAO(cPT,cPT,"STR(mNUMERO,8)+' '+mNOME","mNUMERO","Totalizacao do Ponto","Funcionario Nome",;
    {|| PEGCHAVE("mNUMERO",0,"Numero")},{|| tFOPTO24()},{|| gFOPTO24()},{|| ALLTRUE()},.t.,2,,,ZTIPVID)
CASE nTIPO = 2
   cPT := "PS"+ANOMESW
   PADRAO(cPT,cPT,"STR(mNUMERO,8)+' '+DTOC(mSEMFIM)+' '+mNOME","STR(mNUMERO,8)+DTOS(mSEMFIM)","Totalizacao do Ponto","Funcionario Nome",;
    {|| PEGCHAVE("mNUMERO",0,"Numero")},{|| tFOPTO24()},{|| gFOPTO24()},{|| ALLTRUE()},.t.,2,,,ZTIPVID)
CASE nTIPO = 3
   cPT := "FO_PTT"
   PADRAO(cPT,cPT,"STR(mNUMERO,8)+' '+STR(mMES)+'/'+STR(mANO)+' '+mNOME","STR(mNUMERO,8)+STR(mANO,4)+STR(mMES,2)","Totalizacao do Ponto","Funcionario Nome",;
    {|| PEGCHAVE("mNUMERO",0,"Numero")},{|| tFOPTO24()},{|| gFOPTO24()},{|| ALLTRUE()},.t.,2,,,ZTIPVID)
ENDCASE
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function tFOPTO24()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC tFOPTO24

HB_DISPBOX(3,0,23,79,B_DOUBLE+" ")
@  4,2  SAY "Numero"                                                                            
@  4,16 SAY " Nome"                                                                             
@  5,62 say "Bco Horas"                                                                         
@  6,2  SAY replicate('-',34)+" Horas "+replicate('-',35)                                       
@  7,7  SAY "Cta01   Cta02   Cta03   Cta04   Cta05   Cta06   Cta07   Cta08"                     
@  9,7  SAY "Cta09   Cta10   Cta11   Cta12   Cta13   Cta14   Cta15   Cta16"                     
@ 11,7  SAY "Cta17   Cta18   Cta19   Cta20   Cta21   Cta22   Cta23   Cta24"                     
@ 13,2  SAY replicate('-',33)+" Anuais  "+replicate('-',34)                                     
@ 17,2  SAY replicate('-',33)+" Valores "+replicate('-',34)                                     
@ 18,2  SAY "Valor 01     Valor 02     Valor 03     Valor 04     Valor 05     Valor 06"         
@ 20,2  SAY "Valor 07     Valor 08     Valor 09     Valor 10     Valor 11     Valor 12"         
@ 22,2  SAY "Valor 13     Valor 14     Valor 15     Valor 16     Valor 17     Valor 18"         


@  4,8  SAY mNUMERO PICTURE '99999999'        
@  4,23 SAY mNOME                             

IF nTIPO = 1
   nSALDO := pegsaldobco(mNUMERO,nANOANT,nMESANT,.t.)
   @  4,62 say STRZERO(nMESANT,2)+"/"+strZERO(nANOANT,4)                       
   @  4,70 say nSALDO                                    pict "9999.99"        
   aTOTANO := PEGTOTANO(mNUMERO,.T.)
   for X := 1 to 8
      @ 14,(X * 10) - 8 say aTOTANO[X] pict '9999.99'        
   next X
   for X := 1 to 8
      @ 15,(X * 10) - 8 say aTOTANO[X+8] pict '9999.99'        
   next X
   for X := 1 to 8
      @ 16,(X * 10) - 8 say aTOTANO[X+16] pict '9999.99'        
   next X
ENDIF
IF nTIPO = 2
   @  7,2  SAY "Semana"         
   @  7,12 SAY mSEMINI          
   @  7,22 SAY mSEMFIM          
ENDIF
IF nTIPO = 3
   @  7,2  SAY "Competencia"         
   @  7,12 SAY mMES                  
   @  7,18 SAY mANO                  
ENDIF
RETURN .T.




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gFOPTO24()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC gFOPTO24

@  5,70 GET mBCOHRS PICTURE '9999.99' WHEN lVALBANCO       
@ 08,7  GET mCTA01  PICTURE '9999.99'                      
@ 08,15 GET mCTA02  PICTURE '9999.99'                      
@ 08,23 GET mCTA03  PICTURE '9999.99'                      
@ 08,31 GET mCTA04  PICTURE '9999.99'                      
@ 08,39 GET mCTA05  PICTURE '9999.99'                      
@ 08,47 GET mCTA06  PICTURE '9999.99'                      
@ 08,55 GET mCTA07  PICTURE '9999.99'                      
@ 08,63 GET mCTA08  PICTURE '9999.99'                      
READCUR()
@ 10,7  GET mCTA09 PICTURE '9999.99'        
@ 10,15 GET mCTA10 PICTURE '9999.99'        
@ 10,23 GET mCTA11 PICTURE '9999.99'        
@ 10,31 GET mCTA12 PICTURE '9999.99'        
@ 10,39 GET mCTA13 PICTURE '9999.99'        
@ 10,47 GET mCTA14 PICTURE '9999.99'        
@ 10,55 GET mCTA15 PICTURE '9999.99'        
@ 10,63 GET mCTA16 PICTURE '9999.99'        
READCUR()
@ 12,7  GET mCTA17 PICTURE '9999.99'        
@ 12,15 GET mCTA18 PICTURE '9999.99'        
@ 12,23 GET mCTA19 PICTURE '9999.99'        
@ 12,31 GET mCTA20 PICTURE '9999.99'        
@ 12,39 GET mCTA21 PICTURE '9999.99'        
@ 12,47 GET mCTA22 PICTURE '9999.99'        
@ 12,55 GET mCTA23 PICTURE '9999.99'        
@ 12,63 GET mCTA24 PICTURE '9999.99'        
READCUR()
if lVALORES
   @ 19,2  GET mVAL01 PICTURE '999999999.99'        
   @ 19,15 GET mVAL02 PICTURE '999999999.99'        
   @ 19,28 GET mVAL03 PICTURE '999999999.99'        
   @ 19,41 GET mVAL04 PICTURE '999999999.99'        
   @ 19,54 GET mVAL05 PICTURE '999999999.99'        
   @ 19,67 GET mVAL06 PICTURE '999999999.99'        
   READCUR()
   @ 21,2  GET mVAL07 PICTURE '999999999.99'        
   @ 21,15 GET mVAL08 PICTURE '999999999.99'        
   @ 21,28 GET mVAL09 PICTURE '999999999.99'        
   @ 21,41 GET mVAL10 PICTURE '999999999.99'        
   @ 21,54 GET mVAL11 PICTURE '999999999.99'        
   @ 21,67 GET mVAL12 PICTURE '999999999.99'        
   READCUR()
   @ 23,2  GET mVAL13 PICTURE '999999999.99'        
   @ 23,15 GET mVAL14 PICTURE '999999999.99'        
   @ 23,28 GET mVAL15 PICTURE '999999999.99'        
   @ 23,41 GET mVAL16 PICTURE '999999999.99'        
   @ 23,54 GET mVAL17 PICTURE '999999999.99'        
   @ 23,67 GET mVAL18 PICTURE '999999999.99'        
   READCUR()
ENDIF
RETURN .T.
// : FIM: FOPTO_24.PRG

*+ EOF: fopto_24.prg
*+
