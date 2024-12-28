*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fores_e8.prg
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

// :*****************************************************************************
// :
// :   FORES_E8.PRG: Nome do Programa
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/26/94      9:07
// :
// :  Procs & Fncts: FORES_E8()
// :
// :          Chama: CABE2()            (fun‡„o    em FORESP.PRG)
// :               : VALCTA()           (fun‡„o    em FORESP.PRG)
// :               : MDL()              (fun‡„o    em FORESP.PRG)
// :
// :     Arq. Dados: FIRMA -  Cadastro de Empresas
// :               : FO_PES -  Arquivo de Funcionarios
// :               : FO_RSS -  FOLHA DE RESCISAO
// :               : CODIRRF -  Codigos de Retencao do IRRF
// :
// :         Indice:  FIRNR     N£mero de Cadastramento
// :                            NRCLIEN
// :               :  PES       Sequencia de numero de registro
// :                            NUMERO
// :               :  RSS       CODIGO DE TRABALHO
// :                            CONTROLE
// :               :  CODIRRF   Codigo de Retencao
// :                            CODIGO
// :
// :     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
// :*****************************************************************************
////#INCLUDE "COMANDO.CH"


CABE2('Imprimir Guia DARF ')
DXDIA1   := DXDIA2 := DATE()
PERIODO  := SPACE(9)
COD      := SPACE(4)
mUFIR    := 0
ATUALIZA := 1.000000
CTR      := 0


@ 21,00 SAY 'Qual Funcion rio'                                             
@ 22,00 SAY 'Qual o Fator de Atualiza‡„o'                                  
@ 23,00 SAY 'DIGITE O CODIGO PARA A GUIA'                                  
@ 21,00 GET CTR                                                            
@ 22,40 GET ATUALIZA                      PICT "99999999999.999999"        
@ 23,50 GET COD                                                            
IF !READCUR()
   RETU .F.
ENDIF


IF !NETUSE("CODIRRF")
   RETU
ENDIF
IF DBSEEK(COD)
   RECEITA := COD
   MDS('Descrimina‡„o do c¢digo: '+NOME)
ELSE
   DBCLOSEALL()
   MDS('C¢digo para o DARF n„o encontrado')
   RETU .F.
ENDIF
DBCLOSEALL()

@ 10,20 TO 19,61 DOUB
@ 11,23 SAY 'Data de Vencimento => ' GET DXDIA1                              
@ 12,23 SAY 'Periodo de Apuracao=> ' GET PERIODO                             
@ 13,23 SAY 'Data de Apuracao ===> ' GET DXDIA2                              
@ 14,23 SAY 'Codigo da Receita ==> ' GET RECEITA                             
@ 15,23 SAY 'Valor da Ufir     ==> ' GET mUFIR   PICT '###,###,###.##'       
READCUR()

IF !NETUSE("FIRMA")
   RETU
ENDIF
DBGOTOP()
IF DBSEEK(NREMP)
   MSG2  := ALLTRIM(RAZAO)
   END   := ENDERECO
   BAI   := BAIRRO
   CID   := CIDADE
   UF    := ESTADO
   CEP1  := CEP
   CGC1  := CGC
   FONE1 := TELEFONE
ENDIF
DBCLOSEALL()

IF !NETUSE(PES)   //AREDE(PES,PES,1)
   RETU
ENDIF
DBGOTOP()
DBSEEK(CTR)
IF !FOUND()
   DBCLOSEALL()
   MDT('Funcion rio n„o Cadastrado')
   RETU
ENDIF
mNOME := NOME
DBCLOSEALL()
TIPO := 'F'
MDS('Guia para F-F‚rias R-Rescisao')
@ 24,40 GET TIPO         
READCUR()
IMPVAL := MDG('Deseja j  imprimir os valores a recolher')
IF TIPO = 'F'
   IF !NETUSE("FO_PFE")   //AREDE("FO_PFE","FO_PFE",1)
      DBCLOSEALL()
      RETU
   ENDIF
   TOTDESC := VALCTA(CTR,424)
ELSE
   IF !NETUSE("FO_RSS")   //AREDE("FO_RSS","FO_RSS",1)
      DBCLOSEALL()
      RETU
   ENDIF
   TOTDESC := VALCTA(CTR,502)
   TOTDESC += VALCTA(CTR,504)
   TOTDESC += VALCTA(CTR,522)
ENDIF
DBCLOSEALL()
TOTDESC := IF(ATUALIZA # 1,ROUND(TOTDESC * ATUALIZA,2),TOTDESC)
mUFIR   := IF(mUFIR > 0,mUFIR,1)
mVALUF  := TOTDESC / mUFIR

IF !MDL('Listar Darf - IRRF',0)
   RETU
ENDIF
SET PRIN ON
?? IMPCHR(27)+'C'+IMPCHR(24)
?? IMPSTR(cIMPEXP)
SET PRIN OFF
IMPRESSORA()
@ PROW(),28    SAY 'CGC :'                                                    
@ PROW(),34    SAY CGC1                                                       
@ PROW(),70    SAY DXDIA1                                                     
@ PROW()+ 1,28 SAY IMPSTR(cIMPCOM)+MSG2+IMPSTR(cIMPEXP)                       
@ PROW()+ 1,28 SAY IMPSTR(cIMPCOM)+END+IMPSTR(cIMPEXP)                        
@ PROW(),59    SAY CGC1                                                       
@ PROW()+ 1,28 SAY IMPSTR(cIMPCOM)+BAI+' - CEP '+CEP1+IMPSTR(cIMPEXP)         
@ PROW()+ 1,28 SAY IMPSTR(cIMPCOM)+TRIM(CID)+' - '+UF+IMPSTR(cIMPEXP)         
@ PROW(),70    SAY RECEITA                                                    
@ PROW()+ 6,2  SAY MSG2                                                       
IF IMPVAL
   @ PROW(),59 SAY TOTDESC PICT '###,###,###.##'        
ENDIF
@ PROW(),41   SAY IMPSTR(cIMPCOM)+FONE1+IMPSTR(cIMPEXP)                    
@ PROW()+ 3,1 SAY IF(TIPO = "F",'IRRF - FERIAS','IRRF - RESCISAO')         
@ PROW()+ 1,1 SAY mNOME                                                    
IF !IMPVAL
   @ PROW()+ 1,1 SAY 'Valor Original '+ZMOEDA06                              
   @ PROW(),24   SAY TOTDESC                    PICT '###,###,###.##'        
ELSE
   @ PROW()+ 1,0 SAY ''         
ENDIF
@ PROW()+ 1,1 SAY 'Data de Apuracao -> '          
@ PROW(),24   SAY DXDIA2                          
@ PROW()+ 1,1 SAY 'Periodo de Apuracao->'         
@ PROW(),24   SAY PERIODO                         
IF IMPVAL
   @ PROW(),59 SAY TOTDESC PICT '###,###,###.##'        
ENDIF
IF !IMPVAL
   @ PROW()+ 1,1 SAY 'Imposto em UFIR->'                              
   @ PROW(),24   SAY mVALUF              PICT '###,###,###.##'        
   @ PROW()+ 1,1 SAY 'Valor da UFIR->'                                
   @ PROW(),24   SAY mUFIR               PICT '###,###,###.##'        
ENDIF
IMPFOL()
VIDEO()
SET PRIN ON
?? IMPCHR(27)+'C'+IMPCHR(66)
SET PRIN OFF
RETU
// : FIM: FORES_E8.PRG

*+ EOF: fores_e8.prg
*+
