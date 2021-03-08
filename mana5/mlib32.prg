*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib32.prg
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
#INCLUDE "BOX.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CHECKPAR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CHECKPAR(lDESCFO,bAUXGET,mVARNUM,mVARTOT,mVARDIF)


if valtype(lDESCFO) # "L"
   lDESCFO := .F.
endif
if valtype(mVARTOT) # "N"
   mVARTOT := mTOTNF
endif
//Fechamento do Pedido
HB_DISPBOX(2,0,23,79,B_DOUBLE)
@  3,3  say "Nota    Emiss„o F CLI/FOR   "+spac(9)+"S Ope P S Pag  Valor Total da NF"                                                                     
@  4,0  say '+'+replicate('-',78)+'Ý'                                                                                                                     
@  6,0  say '+'+replicate('-',52)+"-"+replicate('-',25)+'Ý'                                                                                               
@  7,10 say "Vencimentos e Valores Desta Entrada"                                                                                                         
@  8,5  say "Vencer  Ý Valor  :"                                                                                                                          
@  9,1  say "1-"+spac(10)+"Ý"+spac(19)+"Ý"                                                                                                                
@ 10,1  say "2-"+spac(10)+"Ý"+spac(19)+"Ý"                                                                                                                
@ 11,1  say "3-"+spac(10)+"Ý"+spac(19)+"Ý"                                                                                                                
@ 12,1  say "4-"+spac(10)+"Ý"+spac(19)+"Ý"                                                                                                                
@ 13,1  say "5-"+spac(10)+"Ý"+spac(19)+"Ý"                                                                                                                
@  9,41 say "6-"+spac(10)+"Ý"+spac(19)+"Ý"                                                                                                                
@ 10,41 say "7-"+spac(10)+"Ý"+spac(19)+"Ý"                                                                                                                
@ 11,41 say "8-"+spac(10)+"Ý"+spac(19)+"Ý"                                                                                                                
@ 12,41 say "9-"+spac(10)+"Ý"+spac(19)+"Ý"                                                                                                                
@ 13,40 say "10-"+spac(09)+"Ý"+spac(19)+"Ý"                                                                                                               
@ 14,0  say '+'+replicate('-',12)+"-"+replicate('-',19)+"-"+replicate('-',5)+"-"+replicate('-',13)+"-"+replicate('-',5)+"-"+replicate('-',19)+'Ý'         
@ 15,22 say "Da Nota Fiscal   Ý"                                                                                                                          
@ 16,1  say "Tot.Mercadoria"+spac(24)+"Ý"                                                                                                                 
@ 17,1  say "Total do IPI  "+spac(24)+"Ý"                                                                                                                 
@ 18,1  say "Total N.Fiscal"+spac(24)+"Ý"                                                                                                                 
@ 19,1  say "Valor do ICMS "+spac(24)+"Ý"                                                                                                                 
@ 20,1  say "Base Calc. IPI"+spac(24)+"Ý"                                                                                                                 
@ 21,1  say "Base Calc. ICM"+spac(24)+"Ý"                                                                                                                 
// Get nas Menvars
@  5,1  say &mVARNUM.          
@  5,10 say mDATA              
@  5,19 say mTIPOCLI           
@  5,21 say mFORNECEDO         
@  5,27 say mCOGNOME           
if lDESCFO
   @  5,42 say mOPERACAO+'-'+trim(mDESCFO)         
else
   @  5,42 say mOPERACAO         
endif
@  5,46 say mTIPOENT          
@  5,48 say mSITUACAO         
@  5,50 say mCONDPAG          
while .T.
   @  9,4  get mDAT01                              
   @  9,14 get mVAL01 pict "999,999,999.99"        
   @ 10,4  get mDAT02                              
   @ 10,14 get mVAL02 pict "999,999,999.99"        
   @ 11,4  get mDAT03                              
   @ 11,14 get mVAL03 pict "999,999,999.99"        
   @ 12,4  get mDAT04                              
   @ 12,14 get mVAL04 pict "999,999,999.99"        
   @ 13,4  get mDAT05                              
   @ 13,14 get mVAL05 pict "999,999,999.99"        
   @  9,44 get mDAT06                              
   @  9,54 get mVAL06 pict "999,999,999.99"        
   @ 10,44 get mDAT07                              
   @ 10,54 get mVAL07 pict "999,999,999.99"        
   @ 11,44 get mDAT08                              
   @ 11,54 get mVAL08 pict "999,999,999.99"        
   @ 12,44 get mDAT09                              
   @ 12,54 get mVAL09 pict "999,999,999.99"        
   @ 13,44 get mDAT10                              
   @ 13,54 get mVAL10 pict "999,999,999.99"        
   if valtype(bAUXGET) = "C"
      do case
         case bAUXGET = "1"
            @ 16,20 get mTOTMER  pict '999,999,999.99'        
            @ 17,20 get mTOTIPI  pict '999,999,999.99'        
            @ 18,20 get mTOTNF   pict "999,999,999.99"        
            @ 19,20 get mTOTICM  pict '999,999,999.99'        
            @ 20,20 get mBASEIPI pict '999,999,999.99'        
            @ 21,20 get mBASEICM pict '999,999,999.99'        
         case bAUXGET = "2" .or. bAUXGET = "3"
            @ 16,44 SAY 'Pis'                                  
            @ 17,44 SAY 'Cofins'                               
            @ 22,02 say 'Frete'                                
            @ 22,20 say mTOTFRETE pict '999,999,999.99'        
            @ 16,20 get mTOTMER   pict '999,999,999.99'        
            @ 17,20 get mTOTIPI   pict '999,999,999.99'        
            @ 18,20 get mTOTNF    pict "999,999,999.99"        
            @ 19,20 get mTOTICM   pict '999,999,999.99'        
            @ 20,20 get mTOTBIPI  pict '999,999,999.99'        
            @ 21,20 get mTOTBICM  pict '999,999,999.99'        
            @ 16,54 GET mVALPIS   pict '999,999,999.99'        
            @ 17,54 GET mVALFIN   pict '999,999,999.99'        
      endcase
   endif
   if valtype(bAUXGET) = "B"
      eval(bAUXGET)
   endif
   READCUR()
   if valtype(mVARDIF) # "C"
      if round(mVAL01+mVAL02+mVAL03+mVAL04+mVAL05+;
                     mVAL06+mVAL07+mVAL08+mVAL09+mVAL10,2) # round(mVARTOT,2)
         ALERTX("As Somas da Parcela n„o Conferem com o Total")
      else
         exit
      endif
   else
      if round(mVAL01+mVAL02+mVAL03+mVAL04+mVAL05+;
                     mVAL06+mVAL07+mVAL08+mVAL09+mVAL10,2) # round(mVARTOT+&mVARDIF.,2)
         ALERTX("As Somas da Parcela n„o Conferem com o Total")
         if MDG("Lan‡ar Diferen‡a")
            MDS("Digite o Valor da Diferen‡a")
            @ 24,40 get &mVARDIF.         
            READCUR()
         endif
      else
         exit
      endif
   endif
enddo
retu .T.

