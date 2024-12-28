*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_4h.prg
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



//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

v_pic := "@S18"
PADRAO("FIRMA","FIRMA","STR(mNRCLIEN)+' '+mRAZAO","mNRCLIEN","FOPTO_4H - Cadastro de Empresas","Codigo Raz„o",;
 {|| ALERTX("nao disponivel neste modulo")},{|| tFOPTO4H()},{|| gFOPTO4H()},{|| FO_RELL("PONTOCAD09")},,2,,,"E")


retu .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gFOPTO4H()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function gFOPTO4H

@  5,3  say mNRCLIEN                                                                                                                                                     
@  5,11 get mCOGNOME                                                                                                                                                     
@  5,28 get mRAZAO                                                                                                                                                       
@  5,77 get mPESSOA    pict "!"                            valid mPESSOA $ 'FJCO '                                                                                       
@  9,13 GET mCGC       PICT(v_pic)                         WHEN {| oGet | CNPJCPFPICT(oGet,mPESSOA,9,13)}                            VALID CNPJCPFVAL(mCGC,mPESSOA)      
@  7,11 get mENDERECO                                                                                                                                                    
@  7,49 get mBAIRRO                                                                                                                                                      
@  8,10 get mESTADO    pict "!!"                           valid CHECKTAB(padr("UF",4)+padr(mESTADO,5),24,0,"Estado N„o Cadastrado")                                     
@  8,13 get mCIDADE    VALID CHECKCID(mESTADO,mCIDADE,.T.)                                                                                                               
@  8,33 get mCEP       pict "99999-999"                    VALID CHKUFCEP(mCEP,mESTADO)                                                                                  
@  8,49 get mTELEFONE                                                                                                                                                    
@  8,69 get mFAX                                                                                                                                                         
@  9,43 get mINSC      VALID                               VALIE(mINSC,mESTADO,mPESSOA)                                                                                  
@  9,70 get mCRTPONTO  VALID mCRTPONTO $ "SN"                                                                                                                            
@ 10,13 get mCTRALMOCO VALID mCTRALMOCO $ "SN"                                                                                                                           
READCUR()
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function tFOPTO4H()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function tFOPTO4H


// Desenha a Tela
HB_DISPBOX(2,0,23,79,B_DOUBLE+" ")
@  4,2 say "Codigo + Cognome "+replicate('-',7)+"+ Raz„o "+replicate('-',35)+"+ Pessoa -+"                   
@  5,0 say "|"+spac(8)+"|"+spac(16)+"|"+spac(42)+"| (F/J)   |"                                               
@  6,0 say "|"+replicate('-',8)+"-"+replicate('-',16)+"-"+replicate('-',42)+"-"+replicate('-',9)+"|"         
@  7,0 say "| Endere‡o:"+spac(33)+"Bair:"+spac(16)+"    "+spac(10)+"|"                                       
@  8,0 say "| Cidade:"+spac(17)+"                 FONE:"+spac(15)+"FAX :"+spac(20)+"|"                       
@  9,0 say "| C.G.C.   :"+spac(20)+"Ins.Est. :"+spac(17)+"Tem Ponto"+SPACE(13)+"|"                           
@ 10,0 say "Marca Almoco:"                                                                                   
@ 11,0 say "+"+replicate('-',78)+"+"                                                                         
retu .T.


*+ EOF: fopto_4h.prg
*+
