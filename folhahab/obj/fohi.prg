*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fohi.prg
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

// :*****************************************************************************
// :
// :       FOHI.PRG: Imprimir Guia DARF
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  SOFTEC  S/C Ltda.
// :  Atualizado em: 30/06/98
// :
// :*****************************************************************************

////#INCLUDE "COMANDO.CH"

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fohi()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function fohi

PARA ARQ

CABEX('Imprimir Guia DARF ')
IF ARQ = 9 .OR. ARQ = 10
   MDT('Use a opcao Folha de Pagamento')
   RETU
ENDIF
IF ARQ = 6
   ALERTX("Nao Disponivel VT")
   RETU .F.
ENDIF


DXDIA1   := DXDIA2 := DATE()
PERIODO  := SPAC(9)
COD      := '    '
mUFIR    := 0
ATUALIZA := 1.000000
MDS('Qual o Fator de Atualiza‡„o')
@ 24,40 GET ATUALIZA PICT "99999999999.999999"        
READCUR()
MDS('DIGITE O CODIGO PARA A GUIA')
@ 24,50 GET COD         
READCUR()

IF !netuse("CODIRRF")
   RETU
ENDIF
DBGOTOP()
DBSEEK(COD)
IF !FOUND()
   DBCLOSEALL()
   MDT('C¢digo para o DARF n„o encontrado')
   RETU
ENDIF
RECEITA := COD
DBCLOSEALL()


CTA := 0
DO CASE
CASE ARQ = 1    //FOL
   CTA := 503
CASE ARQ = 2    //FER
   CTA := 524
CASE ARQ = 3    //RES
   CTA := 504
CASE ARQ = 4    //13
   CTA := 505
CASE ARQ = 5    //COM
   CTA := 503
CASE ARQ = 7    //SEM
   CTA := 501
CASE ARQ = 8    //FOL
   CTA := 503
CASE ARQ = 9    //ADI
   CTA := 501
CASE ARQ = 10   //PRE
   CTA := 527
ENDCASE


@ 10,20 TO 19,61 DOUB
@ 11,23 SAY 'Data de Vencimento => ' GET DXDIA1                              
@ 12,23 SAY 'Per¡odo de Apura‡„o=> ' GET PERIODO                             
@ 13,23 SAY 'Data de Apura‡„o ===> ' GET DXDIA2                              
@ 14,23 SAY 'C¢digo da Receita ==> ' GET RECEITA                             
@ 15,23 SAY 'Valor da Ufir     ==> ' GET mUFIR   PICT '###,###,###.##'       
@ 16,23 SAY 'Conta             ==> ' GET CTA     PICT '###'                  
READCUR()

IF !NETUSE("FIRMA")   //AREDE("FIRMA","FIRMA",1)
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



IF !MDL('Listar Darf - IRRF',0)
   RETU
ENDIF

IF !ARQUSAR(ARQ,1,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
DBGOTOP()
TOTDESC := 0
WHILE !EOF()
   IF CTA = CONTA
      TOTDESC += VALOR
   ENDIF
   IF ARQ = 3 .AND. CTA = 502 .AND. CTA = 522
      TOTDESC += VALOR
   ENDIF
   DBSKIP()
ENDDO
DBCLOSEALL()

IF TOTDESC = 0
   MDT("Nenhum Valor a Recolher")
   RETU .T.
ENDIF
TOTDESC := IF(ATUALIZA # 1,ROUND(TOTDESC * ATUALIZA,2),TOTDESC)
IMPVAL  := MDG('Deseja j  imprimir os valores a recolher')
mUFIR   := IF(mUFIR > 0,mUFIR,1)
mVALUF  := TOTDESC / mUFIR

SET PRIN ON
QQOUT(CHR(27)+'C'+CHR(24))
QQOUT(IMPSTR(cIMPEXP))
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
@ PROW(),41 SAY IMPSTR(cIMPCOM)+FONE1+IMPSTR(cIMPEXP)         
DO CASE
CASE CTA = 501
   @ PROW()+ 3,1 SAY 'IRRF - ADIANTAMENTO DE SALARIO'         
CASE CTA = 503
   @ PROW()+ 3,1 SAY IF(NRSEN = 'DiReT','IRRF - PRO LABORE','IRRF - FOLHA DE PAGAMENTO')         
CASE CTA = 502
   @ PROW()+ 3,1 SAY ACENTO('IRRF - F‚rias')         
CASE CTA = 504
   @ PROW()+ 3,1 SAY ACENTO('IRRF - Rescis„o')         
CASE CTA = 527
   @ PROW()+ 3,1 SAY 'IRRF - Premio'         
CASE CTA = 505
   @ PROW()+ 3,1 SAY ACENTO('IRRF - 13o. Sal rio')         
ENDCASE
@ PROW()+ 1,1 SAY ""         
IF !IMPVAL
   @ PROW()+ 1,1 SAY 'Valor Original '+ZMOEDA06                              
   @ PROW(),24   SAY TOTDESC                    PICT '###,###,###.##'        
ELSE
   @ PROW()+ 1,0 SAY ''         
ENDIF
@ PROW()+ 1,1 SAY ACENTO('Data de Apura‡„o -> ')          
@ PROW(),24   SAY DXDIA2                                  
@ PROW()+ 1,1 SAY ACENTO('Periodo de Apura‡„o->')         
@ PROW(),24   SAY PERIODO                                 
IF IMPVAL
   @ PROW(),59 SAY TOTDESC PICT '###,###,###.##'        
ENDIF
IF !IMPVAL
   @ PROW()+ 1,1 SAY 'Imposto em UFIR->'         
   IF mUFIR # 1
      @ PROW(),24 SAY mVALUF PICT '###,###,###.##'        
   ENDIF
   @ PROW()+ 1,1 SAY 'Valor da UFIR->'         
   IF mUFIR # 1
      @ PROW(),24 SAY mUFIR PICT '###,###,###.##'        
   ENDIF
ENDIF
IMPFOL()
VIDEO()
SET PRIN ON
QQOUT(CHR(27)+'C'+CHR(66))
SET PRIN OFF
IMPEND()
RETU
// : FIM: FOHI.PRG

*+ EOF: fohi.prg
*+
