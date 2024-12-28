*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fog7.prg
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
// :       FOG7.PRG: PLANILHA HORARIO DE TRABALHO
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/08/94     10:45
// :
// :  Procs & Fncts: FOG7()
// :
// :          Chama: MDL()              (funáÑo    em FOLPROC.PRG)
// :
// :     Arq. Dados: FO_HOR
// :
// :     Documentado 05/13/94 em 14:54                DISK!  versÑo 5.01
// :*****************************************************************************


IF !MDL('Listar Planilha de Horario de Trabalho')
   RETU
ENDIF
IF !netuse("FO_HOR")
   RETU
ENDIF
FILTRO := ''
FI     := TRIM(FILTRO)
FILTRO := FILTRO(FI)
SET FILTER TO &FILTRO
DBGOTOP()
SET DEVI TO PRIN
LIN := 80
FL  := 0
WHILE !EOF()
   IF LIN > 50
      @  1,1 SAY IF(IM1 = 'A',impstr(Cimpcom),impstr(Cimpexp))         
      FL ++
      @  2,20  SAY IMPCHR(cIMPTIT)+MSG2                                           
      @  3,120 SAY 'FL. '                                                         
      @  3,125 SAY FL                                            PICT '##'        
      @  4,110 SAY 'DATA =>'                                                      
      @  4,118 SAY DXDIA                                                          
      @  5,0   SAY REPL('-',132)                                                  
      @  6,20  SAY IMPCHR(cIMPTIT)+ACENTO('HORèRIO DE TRABALHO')                  
      @  7,0   SAY REPL('-',132)                                                  
      @  8,1   SAY 'NRo.'                                                         
      @  8,7   SAY 'NOME'                                                         
      @  9,0   SAY REPL('-',132)                                                  
      LIN := 9
   ENDIF
   LIN ++
   @ LIN,1 SAY NUMERO         
   @ LIN,7 SAY NOME           
   LIN ++
   @ LIN,0 SAY 'Segunda : '+D1         
   LIN ++
   @ LIN,0 SAY ACENTO('Teráa   : ')+D2         
   LIN ++
   @ LIN,0 SAY 'Quarta  : '+D3         
   LIN ++
   @ LIN,0 SAY 'Quinta  : '+D4         
   LIN ++
   @ LIN,0 SAY 'Sexta   : '+D5         
   LIN ++
   @ LIN,0 SAY ACENTO('S†bado  : ')+D6         
   LIN ++
   @ LIN,0 SAY 'Domingo : '+D7         
   LIN ++
   @ LIN,0 SAY REPL('-',132)         
   DBSKIP()
ENDDO
SET DEVI TO SCRE
DBCLOSEALL()
RETU
// : FIM: FOG7.PRG

*+ EOF: fog7.prg
*+
