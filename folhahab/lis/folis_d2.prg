*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : folis_d2.prg
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

// :******************************************************************************:
// :
// :   FOLIS_D2.PRG: Revis„o e Altera‡„o de Dados da Rais Empresa
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************


//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"

v_pic := "@S18"
PADRAO("FIRMA","FIRMA","STR(mNRCLIEN)+' '+mRAZAO","mNRCLIEN","FOPTO_4H - Cadastro de Empresas","Codigo Raz„o",;
 {|| ALERTX("nao disponvivel neste modulo")},{|| tFOLISD2()},{|| gFOLISD2()},{|| FO_FOR("GRUPO='FIRMA'")},,2,,,"E")
return .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gFOLISD2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function gFOLISD2

@  8,60 GET mDBASE     PICTURE '99'                                                                                                                                                                                           
@ 10,16 GET mRAZAO                                                                                                                                                                                                            
@ 11,11 GET mPESSOA    PICTURE "!"                                                                              VALID mPESSOA $ 'FJOC '                                                                                       
@ 11,13 GET mCGC       PICT(v_pic)                                                                              WHEN {| oGet | CNPJCPFPICT(oGet,mPESSOA,11,13)}                           VALID CNPJCPFVAL(mCGC,mPESSOA)      
@ 12,12 GET mENDERECO                                                                                                                                                                                                         
@ 12,54 GET mBAIRRO                                                                                                                                                                                                           
@ 14,13 GET mESTADO    PICTURE "!!"                                                                             VALID CHECKTAB(PADR("UF",4)+PADR(mESTADO,5),24,0,"Estado Nao Cadastrado")                                     
@ 14,16 GET mCIDADE    VALID CHECKCID(mESTADO,mCIDADE,.T.)                                                                                                                                                                    
@ 14,43 GET mCEP       PICT "99999-999"                                                                         VALID CHKUFCEP(mCEP,mESTADO)                                                                                  
@ 14,65 GET mCODIBGE                                                                                                                                                                                                          
@ 16,30 GET mRAISNEG   VALID CHECKTAB("RNEG"+mRAISNEG,24,0,"Indicador Incorreto")                                                                                                                                             
@ 16,49 GET mATIVIDADE VALID VERSEHA("FO_CNAE2",,mATIVIDADE,"DESCRICAO","'COdigo de Atividade inconsistente '")                                                                                                               
@ 16,65 GET mNAT_ESTAB VALID VERSEHA("RAISNATJ",,mNAT_ESTAB,"NOME","'Natureza Juridica Invalida'")                                                                                                                            
@ 18,16 GET mNR_SOCIOS                                                                                                                                                                                                        
@ 18,29 GET mSIMPLES   VALID CHECKTAB(PADR("SIMP",4)+PADR(mSIMPLES,4),24,0,"Codigo Simples Nao Cadastrado")                                                                                                                   
@ 18,62 GET mPORTE     VALID PORTE $ "SNO123"                                                                   PICT "!"                                                                                                      
@ 18,69 GET mPAT       VALID PAT $ "SN12"                                                                       PICT "!"                                                                                                      
READCUR()
return .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function tFOLISD2()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func tFOLISD2

@ 06,00 CLEA
@  8,2 SAY "Numero :"+spac(8)+"CGC/CEI :"+spac(21)+"Data Base:"                          
@ 10,2 SAY "Razao Social:"                                                               
@ 12,2 SAY "Endereco:"+spac(35)+"Bairro:"                                                
@ 14,2 SAY "Municipio:"+spac(18)+"UF:     CEP:"+spac(12)+"Cod.Cidade"                    
@ 16,2 SAY "Indicador de RAIS Negativa:    Ativ.Economica:"+spac(7)+"Natureza:"          
@ 18,2 SAY "Proprietarios:     Simples:                   Porte Empresa:   Pat:"         
retu .T.





*+ EOF: folis_d2.prg
*+
