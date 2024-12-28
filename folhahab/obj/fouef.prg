*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fouef.prg
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
// :      FOUEF.PRG: IMPRIMIR CONTRATO DE EXPERIENCIA
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/08/94      8:39
// :
// :*****************************************************************************

////#INCLUDE "COMANDO.CH"

DECLARE SEM[7]
SEM[1] = 'Segunda : '
SEM[2] = 'Terca   : '
SEM[3] = 'Quarta  : '
SEM[4] = 'Quinta  : '
SEM[5] = 'Sexta   : '
SEM[6] = 'Sabado  : '
SEM[7] = 'Domingo : '
IF !MDL('Imprimir contrado de Experiencia')
   RETU
ENDIF
IF !CHECKIMP(0)
   RETU .F.
ENDIF
CTR := 0
MDS('Digite o n£mero do Funcionario')
@ 24,40 GET CTR         
READCUR()

lPRORROGA := MDG("Deseja Termo de Prorrogacao")
IF !NETUSE(PES)
   RETU
ENDIF
DBGOTOP()
if !dbsEEK(CTR)
   MDT('Funcionario nao Encontrado')
   DBCLOSEALL()
   RETU
ENDIF
BUSCAD := DEPTO * 1000000+SETOR * 1000+SECAO
BUSCAF := FUNCAO

IF !NETUSE("FO_EXP")
   dbcloseall()
   RETU
ENDIF
DBGOTOP()
if !dbSEEK(CTR)
   MDT('Experiencia nao Encontrada')
   DBCLOSEALL()
   RETU
ENDIF

NFUNCAO := OBTER("FUNCAO",,FUNCAO,"NOME")
NSETOR  := OBTER("DEPTO",,BUSCAD,"NOME")



IF !NETUSE("FO_HOR")
   RETU
ENDIF
DBSELECTAR(PES)
VAR1 := SALM := SALH := 0
SALHM()
TIPOS := CHECKTAB("TSA2"+TIPO+"    ",,,"Tipo naoCadastrado",2)
IF MDG('Deseja detalhes em negrito')
   N := cIMPNEG
   M := cIMPNER
ELSE
   N := ""
   m := ""
ENDIF

SET DEVI TO PRINT
@ PROW(), 0   SAY 'CONTRATO DE TRABALHO A TITULO DE EXPERIENCIA'                                                                                                           
@ PROW()+ 1,0 SAY REPL('-',80)                                                                                                                                             
@ PROW()+ 1,0 SAY 'Por este instrumento particular, que entre si fazem a firma'                                                                                            
@ PROW()+ 1,0 SAY N+MSG2+M                                                                                                                                                 
@ PROW()+ 1,0 SAY 'sita: '+N+ender1+' - '+bai1+' - '+cid1+m+' Estado '+N+est1+m                                                                                            
@ PROW()+ 1,0 SAY 'Neste ato denominada simplismente "Empregadora", e o SR.'                                                                                               
@ PROW()+ 1,0 SAY N+NOME+M                                                                                                                                                 
@ PROW()+ 1,0 SAY 'portador da Carteira Profissional No.'+N+IF(left(TIRAOUT(CPF),7) = PROFIS,LEFT(TIRAOUT(CPF),7),PROFIS+m+' Serie: '+N+SERIE+m+' UF:'+N+CTPSUF)+M         
@ PROW()+ 1,0 SAY 'PIS: '+N+pis+m+' CPF: '+N+cpf+m                                                                                                                         
@ PROW()+ 1,0 SAY 'Doravante, denominado, simplesmente ,"empregado:, firmam o presente contrato'                                                                           
@ PROW()+ 1,0 SAY 'Individual de trabalho, em caracter de experiencia, conforme a letra "C",do '                                                                           
@ PROW()+ 1,0 SAY 'artigo 443 da Consolidacao das Leis do Trabalho, mediante as seguintes condicoes'                                                                       
@ PROW()+ 1,0 SAY REPL('-',80)                                                                                                                                             
@ PROW()+ 1,0 SAY ACENTO('1) - O Empregado trabalhar  para a Empregadora, exercendo as funcoes de: ')                                                                      
@ PROW()+ 1,5 SAY N+TRIM(NFUNCAO)+m+' na secao: '+N+TRIM(NSETOR)+m                                                                                                         
@ PROW()+ 1,5 SAY 'percebendo o salario de: '+N+STR(VAR1)+m+' por '+N+tipos+m                                                                                              
@ PROW()+ 1,5 SAY impstr(Cimpcom)+N+EXT(VAR1,1,132,132,132)+M+impstr(CimpexP)                                                                                              
@ PROW()+ 1,0 SAY '2) - O horario a ser obdecido sera o seguinte: de '+ht                                                                                                  
@ PROW()+ 1,5 SAY 'sendo um total de '+STR(HRSEM)+' horas semanais, podendo ser alterado quantas '                                                                         
@ PROW()+ 1,5 SAY ACENTO('vezes se fizer necess rio')                                                                                                                      
L := 3
DBSELECTAR("FO_HOR")
DBGOTOP()
IF DBSEEK(CTR)
   FOR X := 1 TO 7
      HORD := 'D'+STR(X,1)
      @ PROW()+ 1,5 SAY SEM[X]+&HORD         
   NEXT X
   L := 1
ENDIF
DBSELECTAR("FO_EXP")
IF lPRORROGA
   @ PROW()+L,0  SAY '3) - Este contrato tem inicio a partir de '+N+DTOC(admitido)+M+' Vencendo-se em'             
   @ PROW()+ 1,5 SAY N+DTOC(DATAFIM1)+M+',podendo ser prorrogado, obedecido o disposto no Paragrafo Unico'         
   @ PROW()+ 1,5 SAY 'do Artigo 445 da CLT.'                                                                       
ELSE
   @ PROW()+L,0  SAY '3) - Este contrato tem inicio a partir de '+N+DTOC(admitido)+M+' Vencendo-se em '+N+DTOC(DATAFIM1)+M           
   @ PROW()+ 1,5 SAY 'se o contrato continuar ap¢s esta data se considera automaticamente  '                                         
   @ PROW()+ 1,5 SAY 'prorrogado at‚ '+N+DTOC(DATAFIM2)+M+' obedecido o disposto no '+impCHR(21)+' Unico do Art 445 da CLT.'         
ENDIF
@ PROW()+ 1,0  SAY '4) - O empregado se compromete a trabalhar em regime de compensacao e de'                 
@ PROW()+ 1,5  SAY 'prorrogacao de horas, inclusive em periodo noturno, sempre que as'                        
@ PROW()+ 1,5  SAY 'necessidades assim o exigirem, observadas as formalidades legais.'                        
@ PROW()+ 1,0  SAY '5) - Obriga-se o empregado, alem de executar com dedicacao e lealdade o seu '             
@ PROW()+ 1,5  SAY 'servico, a cumprir o Regulamento Interno da Empregadora, as instrucoes de'                
@ PROW()+ 1,5  SAY 'sua administracao e as ordens de seus chefes e superiores hieararquicos,'                 
@ PROW()+ 1,5  SAY 'relativas as peculiaridades dos servicos que lhe forem confiados.'                        
@ PROW()+ 1,0  SAY '6) - Aplicam-se a este contrato todas as normas em vigor,relativos aos contratos'         
@ PROW()+ 1,5  SAY 'a prazo determinado, devendo sua rescis„o antecipada, por justa causa,'                   
@ PROW()+ 1,5  SAY 'obdecer ao disposto nos artigos 482 e 483 da C.L.T., conforme o caso:'                    
@ PROW()+ 1,0  SAY '7) - Vencido o periodo experimental e continuando o empregado a prestar servicos'         
@ PROW()+ 1,5  SAY 'a Empregadora, por tempo indeterminado,ficam prorrogados todas as clausulas'              
@ PROW()+ 1,5  SAY 'aqui estabelecidas, enquanto n„o se rescindir o contrato de trabalho.'                    
@ PROW()+ 1,0  SAY '8)- A empregadora descontara dos salarios do EMPREGADO, com sua expressa '                
@ PROW()+ 1,5  SAY 'concordancia, nao so o que ja e de lei ou Convencao Coletiva como ainda a '               
@ PROW()+ 1,5  SAY 'importancia corespondente dos danos causados pelo EMPREGADO, por dolo ou'                 
@ PROW()+ 1,5  SAY 'culpa,nos termos do paragrafo 1o do artigo 462 da CLT'                                    
@ PROW()+ 1,0  SAY REPL('=',80)                                                                               
@ PROW()+ 1,0  SAY 'CONTRATO'                                                                                 
@ PROW()+ 1,0  SAY 'E por estarem de pleno acordo, assinam ambas as partes, em duas vias de igual'            
@ PROW()+ 1,0  SAY 'teor na presenca de duas testemunhas'                                                     
@ PROW()+ 1,0  SAY cid1+N+DTOC(admitido)+M                                                                    
@ PROW()+ 1,39 SAY REPL('-',35)                                                                               
@ PROW()+ 1,39 SAY 'Responsavel quando menor'                                                                 
@ PROW()+ 2,0  SAY REPL('-',35)                                                                               
@ PROW(),39    SAY REPL('-',35)                                                                               
@ PROW()+ 1,0  SAY 'Empregador'                                                                               
@ PROW(),39    SAY 'Empregado'                                                                                
@ PROW()+ 1,0  SAY REPL('=',80)                                                                               
IF lPRORROGA
   @ PROW()+ 1,0  SAY 'TERMO DE PRORROGACAO'                                                                   
   @ PROW()+ 1,0  SAY 'Por mutuo acordo entre as partes, fica o presente contrato de experiencia, que'         
   @ PROW()+ 1,0  SAY 'deveria vencer nesta data,prorrogado ate:     /     /'                                  
   @ PROW()+ 1,0  SAY cid1                                                                                     
   @ PROW()+ 1,39 SAY REPL('-',35)                                                                             
   @ PROW()+ 1,0  SAY REPL('=',80)                                                                             
ENDIF
@ PROW()+ 1,0 SAY 'TESTEMUNHAS'         
@ PROW()+ 2,0 SAY REPL('-',35)          
@ PROW(),39   SAY REPL('-',35)          
@ PROW()+ 2,0 SAY REPL('=',80)          
IMPFOL()
DBCLOSEALL()
IMPEND()
RETU
// : FIM: FOUEF.PRG

*+ EOF: fouef.prg
*+
