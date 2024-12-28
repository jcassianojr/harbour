*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fouec.prg
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
// :      FOUEC.PRG: IMPRIME Contrato de Experiencia
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 2004,  SOFTEC  S/C Ltda.
// :  Atualizado em: 31/08/2004    8:37
// :
// :*****************************************************************************




IF !MDL('Imprimir Funcion rios em experiencia')
   RETU
ENDIF
IF !CHECKIMP(0)
   RETU .F.
ENDIF
IF !NETUSE("FO_EXP")
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

DBGOTOP()
CL := 80
FL := 0
SET DEVI TO PRIN
WHILE !EOF()
   IF CL > 60
      FL ++
      @  2,1   SAY IMPCHR(cIMPTIT)                               
      @  2,20  SAY MSG2                                          
      @  4,120 SAY 'FL. '                                        
      @  4,125 SAY FL                           PICT '##'        
      @  5,2   SAY 'Experiencia'                                 
      @  5,110 SAY 'DATA =>'                                     
      @  5,118 SAY DXDIA                                         
      @  6,1   SAY REPL('-',132)                                 
      @  7,1   SAY IMPCHR(cIMPTIT)                               
      @  7,20  SAY 'Experiencia '+MMES                           
      @  8,1   SAY REPL('-',132)                                 
      @ 09,00  SAY 'DEPT SET SEC NUMER NOME'                     
      @ 09,50  SAY 'ADMITIDO DATAFIM1 DATAFIM2'                  
      @ 10,1   SAY REPL('-',132)                                 
      CL := 11
   ENDIF
   @ CL,00 SAY DEPTO            
   @ CL,05 SAY SETOR            
   @ CL,09 SAY SECAO            
   @ CL,13 SAY NUMERO           
   @ CL,19 SAY NOME             
   @ CL,50 SAY ADMITIDO         
   @ CL,59 SAY DATAFIM1         
   @ CL,68 SAY DATAFIM2         
   CL ++
   DBSKIP()
ENDDO
IF FL > 0
   IMPFOL()
ENDIF
SET DEVI TO SCRE
DBCLOSEALL()
IMPEND()
RETU
// : FIM: FOUEC.PRG

*+ EOF: fouec.prg
*+
