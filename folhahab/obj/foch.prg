*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foch.prg
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
*+    Documentado em 27-Dez-2024 as  9:45 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :       FOCH.PRG: Listar Cadastro de Ocorrˆncias
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/94     11:43
// :
// :    Chamado por: FOC.PRG
// :
// :          Chama: MDL()              (fun‡„o    em FOLPROC.PRG)
// :
// :       Arq. Dados: FO_OCO - Cadastro de Ocorroncia
// :
// :        Indices: &MTEMP
// :
// :     Documentado 05/13/94 em 14:53                DISK!  vers„o 5.01
// :*****************************************************************************
////#INCLUDE "COMANDO.CH"

IF !MDL('Listar Cadastro de Ocorrencias',0)
   RETU
ENDIF
CTLIN := 80
FL    := 0

mTEMP := tmpfile(cRDDEXT)
IF !NETUSE("FO_OCO")
   RETU
ENDIF
FILTRO := ''
INX    := ""
FILORD(.T.)
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
if valtype(INX) = "N"
   dbsetorder(INX)
ELSE
   ordDestroy("temp")
   ordcreate(,"temp",inx)
   ordSetFocus("temp")
ENDIF
set filter to &FILTRO


IMPRESSORA()
DBGOTOP()
WHILE !EOF()
   IF CTLIN > 60
      FL ++
      @  1,1   SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))                  
      @  1,1   SAY IMPCHR(14)+MSG2                                                
      @  2,1   SAY IMPCHR(14)+'CADASTRO OCORRENCIAS C/PESSOAL'                    
      @  4,120 SAY 'FL. '                                                         
      @  4,125 SAY FL                                            PICT '##'        
      @  5,110 SAY 'DATA =>'                                                      
      @  5,118 SAY DXDIA                                                          
      @  6,0   SAY REPL('-',132)                                                  
      @  7,1   SAY 'Depto'                                                        
      @  7,7   SAY 'Chapa'                                                        
      @  7,13  SAY 'N. Reg'                                                       
      @  7,20  SAY 'Nome Funcionario'                                             
      @  7,53  SAY 'Data Saida'                                                   
      @  7,64  SAY 'Paga'                                                         
      @  7,69  SAY 'Data Retorno'                                                 
      @  7,82  SAY 'Codigo/Descriminacao'                                         
      @  7,103 SAY '13% Sal'                                                      
      @  7,112 SAY 'Maximo Dias'                                                  
      @  7,124 SAY 'Conta'                                                        
      @  8,0   SAY REPL('-',132)                                                  
      CTLIN := 9
   ENDIF
   CTR := NUMERO
   @ CTLIN,1   SAY DEPTO              
   @ CTLIN,7   SAY CHAPA              
   @ CTLIN,13  SAY NUMERO             
   @ CTLIN,20  SAY NOMEF              
   @ CTLIN,53  SAY DATASAIDA          
   @ CTLIN,64  SAY PERIODOPAG         
   @ CTLIN,69  SAY DATARETORN         
   @ CTLIN,82  SAY CODIGO             
   @ CTLIN,85  SAY NOME               
   @ CTLIN,105 SAY TEM_13_SAL         
   @ CTLIN,112 SAY PRAZOMAXIM         
   @ CTLIN,124 SAY CONTA              
   CTLIN ++
   DBSKIP()
ENDDO
@ CTLIN,0 SAY REPL('-',132)         
DBCLOSEALL()
IMPFOL()
VIDEO()
IMPEND()
RETU



*+ EOF: foch.prg
*+
