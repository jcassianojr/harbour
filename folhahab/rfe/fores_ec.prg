*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fores_ec.prg
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
// :   FORES_EC.PRG: Recibo de Ferias
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 03/03/99
// :
// :*****************************************************************************

////#INCLUDE "COMANDO.CH"

EMITIDO := GOZOU1DE - 1
EMITIDO := EMITIDO - IF(DOW(EMITIDO) = 7,1,0)
EMITIDO := EMITIDO - IF(DOW(EMITIDO) = 7,2,0)
MDS('Confirme a Data de Emiss„o')
@ 24,40 GET EMITIDO         
READCUR()
IMPRESSORA()
@ PROW(), 0 SAY IMPSTR(cIMPEXP)         
FOR X := 1 TO COP
   @ PROW()+ 1,0  SAY REPL('=',80)                                                                
   @ PROW()+ 1,0  SAY IMPCHR(cIMPTIT)+' RECIBO  DE  FERIAS '+IF(OPX # 3,'COMPLEMENTO','')         
   @ PROW()+ 1,15 SAY 'De acordo com o paragrafo unico do artigo 145 da C.L.T.'                   
   @ PROW()+ 1,0  SAY REPL('=',80)                                                                
   DBSELECTAR(PES)
   VAR1 := SALH := SALM := 0
   SALHM(MEF)
   @ PROW()+ 1,5 SAY 'nome do empregado'                                                                                                                                                    
   @ PROW(),50   SAY 'c.t.p.s.'                                                                                                                                                             
   @ PROW(),70   SAY 'registro'                                                                                                                                                             
   @ PROW()+ 1,0 SAY REPL('-',80)                                                                                                                                                           
   @ PROW()+ 1,7 SAY NOME                                                                                                                                                                   
   @ PROW(),44   SAY IF(left(TIRAOUT(CPF),7) = PROFIS,CPF,PROFIS+"-"+SERIE+"/"+CTPSUF) //CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes         
   @ PROW(),70   SAY NUMERO                                                                                                                                                                 
   @ PROW()+ 1,0 SAY REPL('-',80)                                                                                                                                                           
   DBSELECTAR("FO_FER")
   @ PROW()+ 1,10 SAY 'periodo de aquisicao'                                         
   @ PROW(),54    SAY IF(OPX = 3,'periodo de gozo','periodo de complemento')         
   @ PROW()+ 1,0  SAY REPL('-',80)                                                   
   @ PROW()+ 1,6  SAY DATFERIAS                                                      
   @ PROW(),20    SAY 'A'                                                            
   @ PROW(),25    SAY DATFERIASF                                                     
   @ PROW(),48    SAY IF(OPX = 3,GOZOU1DE,COMPDATAI)                                 
   @ PROW(),60    SAY 'A'                                                            
   @ PROW(),65    SAY IF(OPX = 3,GOZOU1ATE,COMPDATAF)                                
   VENC := DESC := 0
   @ PROW()+ 1,0  SAY REPL('-',80)                                                                         
   @ PROW()+ 1,10 SAY 'BASE PARA CALCULO DA REMUNERACAO DAS FERIAS'                                        
   @ PROW()+ 1,0  SAY REPL('-',80)                                                                         
   @ PROW()+ 1,1  SAY 'Faltas|'                                                                            
   @ PROW(), 9    SAY 'Salario base |'                                                                     
   @ PROW(),24    SAY 'Tipo            | Salario Variavel | Remuneracao Base'                              
   @ PROW()+ 1,1  SAY REPL('-',80)                                                                         
   @ PROW()+ 1,4  SAY FALTAS                                                  PICT '###'                   
   @ PROW(), 9    SAY VAR1                                                    PICT '###,###,###.##'        
   DBSELECTAR(PES)
   VIDEO()
   XTIPO := CHECKTAB("TSA2"+TIPO+"    ",,,"Tipo nao Cadastrado",2)
   IMPRESSORA()
   @ PROW(),24 SAY xTIPO         
   DBSELECTAR("FO_FER")
   @ PROW(),42    SAY IF(OPX = 3,SALVAR,SALVARC)      PICT '###,###,###.##'        
   @ PROW(),62    SAY SALM+IF(OPX = 3,SALVAR,SALVARC) PICT '###,###,###.##'        
   @ PROW()+ 1,0  SAY REPL('*',80)                                                 
   @ PROW()+ 1,25 SAY 'DEMONSTRATIVO FINANCEIRO'                                   
   @ PROW()+ 1,0  SAY REPL('*',80)                                                 
   @ PROW()+ 1,1  SAY 'CONTA'                                                      
   @ PROW(), 7    SAY 'DESCRIMINACAO DA CONTA'                                     
   @ PROW(),49    SAY '  VENCIMENTOS '                                             
   @ PROW(),64    SAY '   DESCONTOS  '                                             
   @ PROW()+ 1,0  SAY REPL('-',80)                                                 
   DBSELECTAR("FO_PFE")
   DBGOTOP()
   WHILE !EOF()
      CTA := CONTA
      DBSELECTAR("CONTAS")
      DBGOTOP()
      IF DBSEEK(CTA)
         IF (PRFER = 0 .AND. OPX = 3) .OR. (PRFCO = 0 .AND. OPX = 5)
            @ PROW()+ 1,3 SAY CODIGO PICT '###'        
            @ PROW(), 9   SAY DESCR                    
            DBSELECTAR("FO_PFE")
            VENC += IF(CONTA < 400,VALOR,0)
            DESC += IF(CONTA > 500,VALOR,0)
            @ PROW(),IF(CONTA < 400,49,64) SAY VALOR PICT '###,###,###.##'        
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
   @ PROW(),64    SAY SALDO                                                                                                                             PICT '###,###,###.##'        
   @ PROW(),64    SAY SALDO                                                                                                                             PICT '###,###,###.##'        
   @ PROW()+ 2,2  SAY IMPSTR(cIMPCOM)+'Recebi da '+MSG2+'; Estabelecida a '+ENDER1+';'                                                                                               
   @ PROW()+ 1,2  SAY+BAI1+'-'+CID1+'-'+EST1                                                                                                                                         
   @ PROW()+ 1,2  SAY 'a importancia de '+ZMOEDA06                                                                                                                                   
   @ PROW(),24    SAY SALDO                                                                                                                             PICT '###,###,###.##'        
   @ PROW()+ 1,02 SAY EXT(SALDO,1,132,0,0)                                                                                                                                           
   @ PROW()+ 1,2  SAY 'Que me paga adiantadamente por motivo de minhas ferias regulamentares, ora concedidas e que vou gozar de acordo com a descricao'                              
   @ PROW()+ 1,2  SAY 'acima; tudo conforme o aviso que recebi em tempo, ao qual dei meu ciente.'                                                                                    
   @ PROW()+ 1,2  SAY 'Para clareza e documento, firmo o presente recibo, dando a firma plena e geral quitacao.'+IMPSTR(cIMPEXP)                                                     
   @ PROW()+ 2,0  SAY 'Local: '+CID1+','+EST1+'-'+DTOC(EMITIDO)                                                                                                                      
   @ PROW(),52    SAY '___________________________'                                                                                                                                  
   @ PROW()+ 1,63 SAY 'Empregado'                                                                                                                                                    
   @ PROW()+ 1,0  SAY REPL('=',80)                                                                                                                                                   
   IMPFOL()
NEXT X
VIDEO()
DBCLOSEALL()
IMPEND()
RETU
// : FIM: FORES_EC.PRG

*+ EOF: fores_ec.prg
*+
