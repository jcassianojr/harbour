*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fores_eb.prg
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
// :   FORES_EB.PRG: Solicita‡„o de Abono Pecuniario de F‚rias
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/26/94      9:08
// :
// :  Procs & Fncts: FORES_EB()
// :
// :     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
// :*****************************************************************************

////#INCLUDE "COMANDO.CH"

EMITIDO := DATFERIASF - 16
MDS('Confirme Data de Emissao')
@ 24,40 GET EMITIDO         
READCUR()
IMPRESSORA()
FOR X := 1 TO COP
   @ PROW()+ 1,0  SAY IMPCHR(cIMPTIT)+'SOLICITACAO DE ABONO PECUNIARIO DE FERIAS'                                                                           
   @ PROW()+ 1,20 SAY IMPSTR(cIMPCOM)+'Paragrafo 1. artigo 143 da C.L.T., com as alteracoes do Dec. Lei nro. 1535 de 13/04/1977'+IMPSTR(cIMPEXP)            
   @ PROW()+ 1,0  SAY REPL('=',80)                                                                                                                          
   @ PROW()+ 2,0  SAY 'Local: '+CID1+','+EST1+'-'+DTOC(EMITIDO)                                                                                             
   @ PROW()+ 2,0  SAY 'Firma '+MSG2                                                                                                                         
   @ PROW()+ 1,0  SAY 'Endereco '+ENDER1+'-'+BAI1+'-'+CID1+'-'+EST1                                                                                         
   @ PROW()+ 2,0  SAY 'Prezado(s) Senhor(es),'                                                                                                              
   @ PROW()+ 2,0  SAY IMPSTR(cIMPCOM)                                                                                                                       
   @ PROW(), 0    SAY 'O infra assinado,  funcionario dessa firma, vem  respeitosamente, requerer lhe seja concedido um terco  do periodo de  suas'         
   @ PROW()+ 1,0  SAY 'ferias, a  quem tem  direito, em abono pecuniario, ficando a  criterio da firma a designacao da data da epoca da concessao,'         
   @ PROW()+ 1,0  SAY 'tudo de acordo com a Consolidacao das Leis do Trabalho'                                                                              
   @ PROW()+ 1,0  SAY 'Relativas ao periodo aquisitivo de '+DTOC(DATFERIAS)+' a '+DTOC(DATFERIASF)                                                          
   @ PROW()+ 1,0  SAY 'Favor dar o ciente na copia deste.'+IMPSTR(cIMPEXP)                                                                                  
   @ PROW()+ 1,0  SAY REPL('=',80)                                                                                                                          
   DBSELECTAR(PES)
   @ PROW()+ 1,0  SAY 'Numero: '+STR(NUMERO)+' Nome: '+NOME                                                                                                                                           
   @ PROW()+ 1,0  SAY 'CTPS: '+IF(left(TIRAOUT(CPF),7) = PROFIS,CPF,PROFIS+"-"+SERIE+"/"+CTPSUF) //CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes         
   @ PROW()+ 1,0  SAY REPL('=',80)                                                                                                                                                                    
   @ PROW()+ 1,0  SAY 'Atenciosamente'                                                                                                                                                                
   @ PROW(),39    SAY 'Ciente em     /    /    '                                                                                                                                                      
   @ PROW()+ 3,0  SAY REPL('-',30)                                                                                                                                                                    
   @ PROW(),39    SAY REPL('-',30)                                                                                                                                                                    
   @ PROW()+ 1,10 SAY 'Empregado'                                                                                                                                                                     
   @ PROW(),49    SAY 'Empregador'                                                                                                                                                                    
   @ PROW()+ 2,0  SAY REPL('=',80)                                                                                                                                                                    
   IMPFOL()
   DBSELECTAR("FO_FER")
NEXT X
VIDEO()
IMPEND()
RETU
// : FIM: FORES_EB.PRG

*+ EOF: fores_eb.prg
*+
