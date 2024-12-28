*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fores_ed.prg
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
// :   FORES_ED.PRG: Recibo Abono Pecuniario Ferias
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/26/94      9:09
// :
// :*****************************************************************************
////#INCLUDE "COMANDO.CH"



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fores_ed()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function fores_ed

PARA CC
EMITIDO := GOZOU1DE - 1
EMITIDO := EMITIDO - IF(DOW(EMITIDO) = 7,1,0)
EMITIDO := EMITIDO - IF(DOW(EMITIDO) = 7,2,0)
MDS('Confirme Data de Pagamento')
@ 24,40 GET EMITIDO         
READCUR()
POS1   := IMPCHR(cIMPTIT)+IMPSTR(cIMPCOM)+'RECIBO DE 1/3 (um terco) DE ABONO PECUNIARIO DE FERIAS'
POS1   := POS1+IF(CC = 0,""," Complemento")+IMPSTR(cIMPEXP)
COMPAR := IF(CC = 0,"CTA=82.OR.CTA=83.OR.CTA=174.OR.CTA=175.OR.CTA=583.OR.CTA=992","CTA=176.OR.CTA=177.OR.CTA=992")

IMPRESSORA()
FOR X := 1 TO COP
   @ PROW()+ 1,0  SAY REPL('=',80)                                               
   @ PROW()+ 1,0  SAY POS1                                                       
   @ PROW()+ 1,48 SAY 'Artigo 145 e Paragrafo da C.L.T.'+IMPSTR(cIMPEXP)         
   @ PROW()+ 1,0  SAY REPL('=',80)                                               
   DBSELECTAR(PES)
   VAR1 := SALM := SALH := 0
   SALHM(MEF)
   @ PROW()+ 1,5 SAY 'nome do empregado'                                                                                                                                                                                                   
   @ PROW(),50   SAY 'c.t.p.s.'                                                                                                                                                                                                            
   @ PROW(),70   SAY 'registro'                                                                                                                                                                                                            
   @ PROW()+ 1,0 SAY REPL('-',80)                                                                                                                                                                                                          
   @ PROW()+ 1,1 SAY NUMERO                                                                                                                                                                                                                
   @ PROW(), 7   SAY NOME                                                                                                                                                                                                                  
   @ PROW(),48   SAY IF(left(TIRAOUT(CPF),7) = PROFIS,LEFT(TIRAOUT(CPF),7)+"/"+SUBSTR(TIRAOUT(CPF),8),PROFIS+"-"+SERIE+"/"+CTPSUF) //CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes         
   @ PROW()+ 1,0 SAY REPL('-',80)                                                                                                                                                                                                          
   DBSELECTAR("FO_FER")
   @ PROW()+ 1,8 SAY 'periodo completo das ferias'                                  
   @ PROW(),44   SAY 'dias  - periodo de 1/3 das Licenca '                          
   @ PROW()+ 1,0 SAY REPL('-',80)                                                   
   @ PROW()+ 1,8 SAY IF(ABONO1DE > GOZOU1DE,GOZOU1DE,ABONO1DE)                      
   @ PROW(),22   SAY 'A'                                                            
   @ PROW(),27   SAY IF(ABONO1ATE > GOZOU1ATE,ABONO1ATE,GOZOU1ATE)                  
   @ PROW(),45   SAY DIASPAGO2                                     PICT '##'        
   @ PROW(),48   SAY ABONO1DE                                                       
   @ PROW(),60   SAY 'A'                                                            
   @ PROW(),65   SAY ABONO1ATE                                                      
   VENC := DESC := 0
   @ PROW()+ 1,0  SAY REPL('-',80)                                                                         
   @ PROW()+ 1,18 SAY 'BASE PARA CALCULO DA REMUNERACAO DAS FERIAS '                                       
   @ PROW()+ 1,0  SAY REPL('-',80)                                                                         
   @ PROW()+ 1,1  SAY 'Faltas|'                                                                            
   @ PROW(), 9    SAY 'Salario base |'                                                                     
   @ PROW(),24    SAY 'Tipo            | Salario Variavel | Remuneracao Base'                              
   @ PROW()+ 1,0  SAY REPL('-',80)                                                                         
   @ PROW()+ 1,4  SAY FALTAS                                                  PICT '###'                   
   @ PROW(), 9    SAY VAR1                                                    PICT '###,###,###.##'        
   @ PROW(), 9    SAY VAR1                                                    PICT '###,###,###.##'        
   DBSELECTAR(PES)
   VIDEO()
   XTIPO := CHECKTAB("TSA2"+TIPO+"    ",,,"Tipo nao Cadastrado",2)
   IMPRESSORA()
   DBSELECTAR("FO_FER")
   @ PROW(),42    SAY IF(OPX = 4,SALVAR,SALVARC)      PICT '###,###,###.##'        
   @ PROW(),62    SAY SALM+IF(OPX = 4,SALVAR,SALVARC) PICT '###,###,###.##'        
   @ PROW()+ 1,0  SAY REPL('*',80)                                                 
   @ PROW()+ 1,25 SAY 'DEMONSTRATIVO FINANCEIRO'                                   
   @ PROW()+ 1,0  SAY REPL('*',80)                                                 
   @ PROW()+ 1,0  SAY 'CONTA'                                                      
   @ PROW(), 7    SAY 'DESCRIMINACAO DA CONTA'                                     
   @ PROW(),49    SAY '  VENCIMENTOS '                                             
   @ PROW(),64    SAY '   DESCONTOS  '                                             
   @ PROW()+ 1,0  SAY REPL('-',80)                                                 
   DBSELECTAR("FO_PFE")
   DBGOTOP()
   WHILE !EOF()
      CTA := CONTA
      IF &COMPAR
         DBSELECTAR("CONTAS")
         DBGOTOP()
         IF DBSEEK(CTA)
            COL := IF(CTA < 400,49,64)
            @ PROW()+ 1,3 SAY CODIGO PICT '###'        
            @ PROW(), 9   SAY DESCR                    
            DBSELECTAR("FO_PFE")
            @ PROW(),COL SAY VALOR PICT '###,###,###.##'        
            VENC := VENC+IF(CTA < 400,VALOR,0)
            DESC := DESC+IF(CTA > 500,VALOR,0)
         ENDIF
      ENDIF
      DBSELECTAR("FO_PFE")
      DBSKIP()
   ENDDO
   @ PROW()+ 1,0  SAY REPL('-',80)                                               
   @ PROW()+ 1,38 SAY 'Totais => '                                               
   @ PROW(),49    SAY VENC                          PICT '###,###,###.##'        
   @ PROW(),64    SAY DESC                          PICT '###,###,###.##'        
   @ PROW()+ 1,0  SAY REPL('=',80)                                               
   @ PROW()+ 1,35 SAY 'Total Liquido a Receber => '                              
   SALDO := VENC - DESC
   @ PROW(),64    SAY SALDO                                                                                                                        PICT '###,###,###.##'        
   @ PROW(),64    SAY SALDO                                                                                                                        PICT '###,###,###.##'        
   @ PROW()+ 1,0  SAY REPL('=',80)                                                                                                                                              
   @ PROW()+ 1,0  SAY POS1                                                                                                                                                      
   @ PROW()+ 1,35 SAY IMPSTR(cIMPCOM)+'De acordo com o paragrafo unico do artigo 145 da C.L.T.'+IMPSTR(cIMPEXP)                                                                 
   @ PROW()+ 1,0  SAY REPL('=',80)                                                                                                                                              
   @ PROW()+ 2,0  SAY IMPSTR(cIMPCOM)+'Recebi da '+msg2+'; Estabelecida a '+ENDER1                                                                                              
   @ PROW()+ 1,0  SAY BAI1+'-'+CID1+'-'+EST1                                                                                                                                    
   @ PROW()+ 1,0  SAY 'a importancia de '+ZMOEDA06                                                                                                                              
   @ PROW(),24    SAY SALDO                                                                                                                        PICT '###,###,###.##'        
   @ PROW()+ 1,0  SAY EXT(SALDO,1,132,0,0)                                                                                                                                      
   @ PROW()+ 2,0  SAY 'correspondente ao abono pecuniario de 1/3 (um terco) das minhas ferias, referente ao periodo acima descrito, tudo conforme'                              
   @ PROW()+ 1,0  SAY 'requerimento que apresentei em tempo habil, dando plena e geral quitacao deste recebimento '+IMPSTR(cIMPEXP)                                             
   @ PROW()+ 2,0  SAY 'Local: '+CID1+','+EST1+'-'+DTOC(EMITIDO)                                                                                                                 
   @ PROW(),52    SAY '___________________________'                                                                                                                             
   @ PROW()+ 1,63 SAY 'Empregado'                                                                                                                                               
   @ PROW()+ 1,1  SAY REPL('=',80)                                                                                                                                              
   IMPFOL()
NEXT X
VIDEO()
DBCLOSEALL()
IMPEND()
RETU
// : FIM: FORES_ED.PRG

*+ EOF: fores_ed.prg
*+
