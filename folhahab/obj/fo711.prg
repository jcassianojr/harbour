*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fo711.prg
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
// :       FO711.PRG: Rela‡„o de ntes
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1997,  SOFTEC  S/C Ltda.
// :  Atualizado em: 22/10/97     11:25
// :
// :*****************************************************************************

////#INCLUDE "COMANDO.CH"

IF !MDL('Relacao Dependentes',0)
   RETU .F.
ENDIF

POS1 := SPAC(40)
dLIM := CTOD(SPACE(8))
cSIM := "N"
@ 23,00 SAY 'Cabecario Complementar'         
@ 23,42 SAY 'Limite'                         
@ 23,51 SAY 'Sintetico'                      
@ 24,00 GET POS1                             
@ 24,42 GET dLIM                             
@ 24,51 GET cSIM                             
IF !READCUR()
   RETU .F.
ENDIF

IF !NETUSE("FOSFAM")
   RETURN .F.
ENDIF


if !NETUSE(pes)
   dbcloseall()
   retu
endif
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

CTLIN := 80
QTFUN := 0
QTDEP := 0
FL    := 0



IMPRESSORA()
DBSELECTAR(PES)
DBGOTOP()
WHILE !EOF()
   nTIT    := 0
   nDEP    := 0
   mNUMERO := NUMERO
   IF CTLIN > 55
      FL ++
      @  1,0   SAY IF(IM1 = 'A',IMPstr(Cimpcom),impstr(Cimpexp))         
      @  2,20  SAY IMPCHR(14)+MSG2                                       
      @  3,18  SAY IMPCHR(14)+'CADASTRO DEPENDENTES'                     
      @  5,0   SAY POS1                                                  
      @  5,100 SAY TIME()                                                
      @  5,110 SAY DATE()                                                
      @  5,120 SAY 'FL. '+STRZERO(FL,4)                                  
      @  6,0   SAY REPL('-',132)                                         
      @  7,0   SAY "No."                                                 
      @  7,10  SAY "Nome"                                                
      @  7,55  SAY "Nasc."                                               
      IF cSIM = "S"
         @  7,65 SAY "Dep"         
      ENDIF
      @  8,0 SAY REPL('-',132)         
      CTLIN := 9
   ENDIF
   dbselectar(pes)
   @ CTLIN,00 SAY NUMERO         
   @ CTLIN,10 SAY NOME           
   @ CTLIN,55 SAY NASC           
   QTFUN ++
   IF cSIM = "N"
      CTLIN ++
   ENDIF
   dbselectar("FOSFAM")
   dbgotop()
   dbseek(STR(mNUMERO,8))
   while mNUMERO = NUMERO .AND. !EOF()
      IF EMPTY(dLIM) .OR. NASCTO <= dLIM
         IF cSIM = "N"
            @ CTLIN,10 SAY NASCTO         
            @ CTLIN,12 SAY IRRF           
            @ CTLIN,14 SAY BAIXA          
            @ CTLIN,16 SAY CNS            
            @ CTLIN,32 SAY NOME           
            CTLIN ++
         ELSE
            nDEP ++
         ENDIF
         QTDEP ++
      ENDIF
      dbskip()
   enddo
   IF cSIM = "S"
      @ CTLIN,65 SAY nDEP         
      CTLIN ++
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
@ PROW()+ 1,0  SAY REPL('-',132)                                          
@ PROW()+ 1,20 SAY 'Quantidade de Funcionarios --> '                      
@ PROW(),53    SAY QTFUN                             PICTURE '###'        
@ PROW()+ 1,20 SAY 'Quantidade de Dependentes --> '                       
@ PROW(),53    SAY QTDEP                             PICTURE '###'        
IF !EMPTY(dLIM)
   @ PROW()+ 1,0 SAY "Data Limite Referencia: "+DTOC(dLIM)         
ENDIF
IMPFOL()
VIDEO()
DBCLOSEALL()
IMPEND()
RETU .T.


*+ EOF: fo711.prg
*+
