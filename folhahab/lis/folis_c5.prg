*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : folis_c5.prg
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

// :*****************************************************************************
// :
// :
// :  FOLIS_C5.PRG : Listar Ficha Financeira de Funcion rios
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************


////#INCLUDE "COMANDO.CH"
IF !MDL('Listar Ficha Financeira',0)
   RETU
ENDIF

SETCOLOR("W/N,N/W")
@ 08,00 CLEA
IF IM1 = 'A'
   @ 17,00 TO 21,79 DOUB
   @ 18,10 SAY 'ATENCAO !!!'                                                  
   @ 19,10 SAY 'Sua Impressora nao permite o preenchimento completo.'         
   @ 20,10 SAY 'Sendo Assim altera a configracao e use o 132 colunas'         
   IF !MDG("Deseja Continuar")
      RETU
   ENDIF
ENDIF

MESTADO  := ""
MCIDADE  := ""
MNESTADO := ""
MNCIDADE := ""
MPAIS    := ""


FL  := CONTINUA := 0
VAL := ARRAY(12)

IF !NETUSE(PES)
   RETU
ENDIF
FILTRO := ''
FI     := TRIM(FILTRO)
FILTRO := FILTRO(FI)
SET FILTER TO &FILTRO
DBGOTOP()

IF !NETUSE("CONTAS")
   RETU
ENDIF

IF !NETUSE("FUNCAO")
   RETU
ENDIF


IF !NETUSE("SINDICAT")
   RETU
ENDIF

IF !NETUSE("DEPTO")
   RETU
ENDIF

SET DEVI TO PRIN
DBSELECTAR(PES)
DBGOTOP()
WHILE !EOF()
   FL ++
   NUM := NUMERO
   ALLTRUE(CHECKCID(,,.F.,IBGE,{{"UF","mESTADO"},{"NOME","mCIDADE"}}))
   ALLTRUE(CheckBacen(NASCPAIS,mPAIS,.f.,{{"STRZERO(BACEN,4)","NACPAIS"},{"NOME","mPAIS"}}))
   @  1,1   SAY IMPSTR(cIMPEXP)                                                  
   @  2,20  SAY IMPCHR(cIMPTIT)+MSG2                                             
   @  3,20  SAY IMPCHR(cIMPTIT)+'FICHA FINANCEIRA FUNCIONARIO ( ANUAL )'         
   @  4,30  SAY IMPCHR(cIMPTIT)+MMES+'/'+STRZERO(ANO,4)                          
   @  5,100 SAY TIME()                                                           
   @  5,110 SAY DXDIA                                                            
   @  5,120 SAY 'FL. '+STRZERO(FL,4)                                             
   // * DADOS DO FUNCIONARIO
   @ PROW()+ 1,0 SAY REPL('-',132)              
   @ PROW()+ 1,1 SAY 'DEPTO'                    
   @ PROW(), 8   SAY 'SETOR'                    
   @ PROW(),15   SAY 'SECAO'                    
   @ PROW(),59   SAY 'CHAPA'                    
   @ PROW(),65   SAY 'N. Reg'                   
   @ PROW(),73   SAY 'NOME FUNCIONARIO'         
   @ PROW(),105  SAY 'ORDEM'                    
   @ PROW()+ 1,2 SAY DEPTO                      
   @ PROW(), 9   SAY SETOR                      
   @ PROW(),16   SAY SECAO                      
   DDEM := DEPTO * 1000000+SETOR * 1000+SECAO
   @ PROW(),60  SAY CHAPA          
   @ PROW(),66  SAY NUMERO         
   @ PROW(),73  SAY NOME           
   @ PROW(),107 SAY ORDEM          
   IF !EMPTY(DEMITIDO)
      @ PROW(),102 SAY 'D E M I T I D O'         
      @ PROW(),102 SAY 'D E M I T I D O'         
      @ PROW(),102 SAY 'D E M I T I D O'         
   ENDIF
   @ PROW()+ 1,0 SAY REPL('-',132)                                                                
   @ PROW()+ 1,2 SAY 'ENDERECO -->'                                                               
   @ PROW(),14   SAY ENDER+","+alltrim(ENDNUM)+" "+alltrim(ENDCOMPL)                              
   @ PROW(),50   SAY 'PIS --------->'                                                             
   @ PROW(),64   SAY PIS                                                                          
   @ PROW(),92   SAY 'BANCO --------->'                                                           
   @ PROW(),108  SAY BANCO                                                                        
   @ PROW()+ 1,2 SAY 'BAIRRO ---->'                                                               
   @ PROW(),14   SAY BAIRRO                                                                       
   @ PROW(),50   SAY 'F.G.T.S ----->'                                                             
   @ PROW(),64   SAY FGTS                                                                         
   @ PROW(),92   SAY 'AGENCIA ------->'                                                           
   @ PROW(),108  SAY AGENCIA                                                                      
   @ PROW()+ 1,2 SAY 'CIDADE ---->'                                                               
   @ PROW(),14   SAY CIDADE                                                                       
   @ PROW(),50   SAY 'DT ADMISSAO ->'                                                             
   @ PROW(),64   SAY ADMITIDO                                                                     
   @ PROW(),92   SAY 'N. CONTA ------>'                                                           
   @ PROW(),108  SAY CONTA                                                                        
   @ PROW()+ 1,2 SAY 'ESTADO ---->'                                                               
   @ PROW(),14   SAY ESTADO                                                                       
   @ PROW(),50   SAY 'TIPO -------->'                                                             
   @ PROW(),64   SAY TIPO+'-'+CHECKTAB("TSA2"+TIPO+"    ",,,"Tipo n„o Cadastrado",2)              
   @ PROW(),65   SAY '-'                                                                          
   @ PROW(),66   SAY TIP                                                                          
   @ PROW(),92   SAY 'SOCIO SIND ---->'                                                           
   @ PROW(),108  SAY SOCIOSIND                                                                    
   @ PROW()+ 1,2 SAY 'CEP ------->'                                                               
   @ PROW(),14   SAY CEP                                                                          
   @ PROW(),50   SAY 'H. SEMANAIS ->'                                                             
   @ PROW(),64   SAY HRSEM                                                                        
   @ PROW(),92   SAY 'SITUACAO ------>'                                                           
   @ PROW(),108  SAY SITUACAO+'-'+CHECKTAB("SITU"+SITUACAO,,,"Situacao nao Cadastrado",2)         
   @ PROW()+ 1,2 SAY 'TELEFONE -->'                                                               
   @ PROW(),14   SAY FONE                                                                         
   @ PROW(),50   SAY 'FUNCAO ------>'                                                             
   @ PROW(),64   SAY FUNCAO                                                                       
   @ PROW(),68   SAY '-'                                                                          
   @ PROW(),69   SAY OBTER("FUNCAO",,FUNCAO,"FNOME")                                              
   DBSELECTAR(PES)
   @ PROW(),92   SAY 'INSALUBRIDADE-->'                                                               
   @ PROW(),108  SAY INSALUBRI                                                                        
   @ PROW()+ 1,2 SAY 'DT NASCTO ->'                                                                   
   @ PROW(),14   SAY NASC                                                                             
   @ PROW(),50   SAY 'CBO ->'                                                                         
   @ PROW(),62   SAY OBTER("FUNCAO",,FUNCAO,"CBONEW") //CBONEW                                        
   @ PROW(),92   SAY 'PERICULOSIDADE->'                                                               
   @ PROW(),108  SAY PERICULO                                                                         
   @ PROW()+ 1,2 SAY 'EST. CIVIL->'                                                                   
   @ PROW(),14   SAY ESTCIVIL+"-"+CHECKTAB("ECIV"+ESTCIVIL,,,"Estado Civil nao Cadastrado",2)         
   @ PROW(),50   SAY 'DEMITIDO ---->'                                                                 
   @ PROW(),64   SAY DEMITIDO                                                                         
   @ PROW()+ 1,2 SAY 'Escolarid.->'                                                                   
   @ PROW(),14   SAY ESCRAIS+'-'+CHECKTAB("EESC"+ESCRAIS,,,"Escolaridade nao Cadastrada",2)           
   @ PROW(),50   SAY 'DT REC.SIND.->'                                                                 
   @ PROW(),64   SAY DATCONTSIN                                                                       
   @ PROW(),92   SAY 'N. SINDICATO--->'                                                               
   @ PROW(),108  SAY SINDICATO                                                                        
   @ PROW(),110  SAY '-'                                                                              
   DDEM := SINDICATO
   DBSELECTAR("SINDICAT")
   @ PROW(),111 SAY IF(DBSEEK(DDEM),COGNOME,'NAO CADASTRADO')         
   DBSELECTAR(PES)
   @ PROW()+ 1,2 SAY 'Nacionalidade: '+NACPAIS+" "+mPAIS                                                                                                                                                                                        
   @ PROW(),50   SAY 'C.P.F ------->'                                                                                                                                                                                                           
   @ PROW(),64   SAY CPF                                                                                                                                                                                                                        
   @ PROW(),92   SAY 'CTPS:'+IF(left(TIRAOUT(CPF),7) = PROFIS,LEFT(TIRAOUT(CPF),7)+"/"+SUBSTR(TIRAOUT(CPF),8),PROFIS+"-"+SERIE+"/"+CTPSUF) //CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes         
   @ PROW()+ 1,0 SAY REPL('-',132)                                                                                                                                                                                                              
   @ PROW()+ 1,1 SAY IMPSTR(cIMPCOM)                                                                                                                                                                                                            
   @ PROW(), 1   SAY 'CONTA'                                                                                                                                                                                                                    
   @ PROW(), 8   SAY 'Nome Conta '                                                                                                                                                                                                              
   FOR X := 1 TO 12
      COL := 24+(X * 14)
      @ PROW(),COL SAY MMES(X)         
   NEXT X
   @ PROW(),208  SAY 'Total   Ano'                  
   @ PROW()+ 1,1 SAY '000 - Salario do Mes'         
   FOR X := 1 TO 12
      COL  := 22+(X * 14)
      XSAL := MMES(X)
      XSAL := SUBSTR(XSAL,1,3)
      XSAL := 'SAL'+XSAL
      @ PROW(),COL SAY &XSAL PICT '###,###,###.##'        
   NEXT X
   CONTAR := 0
   DBSELECTAR(RES)
   DBGOTOP()
   DBSEEK(NUM * 10000000)
   DO WHILE NUMERO = NUM .AND. !EOF()
      CTA := CONTA
      @ PROW()+ 1,1 SAY CONTA PICT '###'        
      HOR  := .F.
      TVAL := 0.00
      AFILL(VAL,0)
      DBSELECTAR("CONTAS")
      DBGOTOP()
      IF DBSEEK(CTA)
         DESC := SUBSTR(DESCR,1,30)
         IF TIPO = 1 .OR. TIPO = 3
            @ PROW(), 6 SAY DESC+'(HR)'         
            HOR := .T.
         ENDIF
      ELSE
         DESC := "Conta nao Cadastrada"
      ENDIF
      DBSELECTAR(RES)
      DO WHILE CONTA = CTA .AND. !EOF()
         COL := MES * 14+22
         IF HOR
            @ PROW(),COL SAY HORAS PICT '###,###,###.##'        
            TVAL := TVAL+HORAS
         ENDIF
         VAL[MES] = VALOR
         DBSKIP()
      ENDDO
      IF HOR
         @ PROW(),208 SAY TVAL PICT '#########.##'        
         CONTAR := CONTAR+1
         @ PROW()+ 1,6 SAY DESC         
      ELSE
         @ PROW(), 6 SAY DESC         
      ENDIF
      FOR X := 1 TO 12
         IF VAL[X] # 0
            COL := X * 14+22
            @ PROW(),COL SAY VAL[X] PICT '###,###,###.##'        
            TVAL := TVAL+VAL[X]
         ENDIF
      NEXT X
      @ PROW(),208 SAY TVAL PICT '#########.##'        
      CONTAR := CONTAR+1
      IF CONTAR > 35
         DBSELECTAR(PES)
         CONTAR := 0
         FL     := FL+1
         @  1,1  SAY IMPSTR(cIMPEXP)                                  
         @  2,01 SAY IMPCHR(cIMPTIT)                                  
         @  2,20 SAY MSG2                                             
         @  3,1  SAY IMPCHR(cIMPTIT)                                  
         @  3,20 SAY 'FICHA FINANCEIRA FUNCIONARIO ( ANUAL )'         
         XANO := STR(YEAR(DXDIA),4)
         @  4,1   SAY IMPCHR(cIMPTIT)                  
         @  4,30  SAY MMES+'/'+XANO                    
         @  5,120 SAY 'FL. '                           
         @  5,125 SAY FL              PICT '##'        
         @  5,100 SAY 'DATA =>'                        
         @  5,108 SAY DXDIA                            
         // * DADOS DO FUNCIONARIO
         @ PROW()+ 1,0 SAY REPL('-',132)              
         @ PROW()+ 1,1 SAY 'DEPTO'                    
         @ PROW(), 8   SAY 'SETOR'                    
         @ PROW(),15   SAY 'SECAO'                    
         @ PROW(),59   SAY 'CHAPA'                    
         @ PROW(),65   SAY 'N. Reg'                   
         @ PROW(),73   SAY 'NOME FUNCIONARIO'         
         @ PROW(),105  SAY 'ORDEM'                    
         @ PROW()+ 1,2 SAY DEPTO                      
         @ PROW(), 9   SAY SETOR                      
         @ PROW(),16   SAY SECAO                      
         DDEM := DEPTO * 1000000+SETOR * 1000+SECAO
         DBSELECTAR("DEPTO")
         DBGOTOP()
         IF DBSEEK(DDEM)
            @ PROW(),20 SAY NOME         
         ELSE
            @ PROW(),20 SAY 'SECAO NAO CADASTRADA'         
         ENDIF
         DBSELECTAR(PES)
         @ PROW(),60  SAY CHAPA          
         @ PROW(),66  SAY NUMERO         
         @ PROW(),73  SAY NOME           
         @ PROW(),107 SAY ORDEM          
         IF !EMPTY(DEMITIDO)
            @ PROW(),102 SAY 'D E M I T I D O'         
            @ PROW(),102 SAY 'D E M I T I D O'         
            @ PROW(),102 SAY 'D E M I T I D O'         
         ENDIF
         @ PROW()+ 1,0 SAY REPL('-',132)           
         @ PROW()+ 1,1 SAY IMPSTR(cIMPCOM)         
         @ PROW(), 1   SAY 'CONTA'                 
         @ PROW(), 8   SAY 'Nome Conta '           
         FOR X := 1 TO 12
            COL := 24+(X * 14)
            @ PROW(),COL SAY MMES(X)         
         NEXT X
         @ PROW(),208 SAY 'Total   Ano'         
      ENDIF
      DBSELECTAR(RES)
   ENDDO
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
DBCLOSEALL()
IMPFOL()
IMPEND()
RETU
// : FIM: FOLIS_C5.PRG

*+ EOF: folis_c5.prg
*+
