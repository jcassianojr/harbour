*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foe24.prg
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
// :      FOE24.PRG: Nome do Programa
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/08/94     10:37
// :
// :*****************************************************************************
#INCLUDE "BOX.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function foe24()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function foe24

PARA CC
CABEX('Pagamento Executado Simples')

lVALE := .F.
CRE   := 399
DEB   := 999
IF CC = 10  //Premio
   CRE := 445
   DEB := 527
ENDIF
IF CC = 9   //Adiantamento
   CRE   := 41
   DEB   := 501
   lVALE := .T.
ENDIF
IF CC = 6   //VT
   CRE := 443
   DEB := 530
ENDIF

IF CC = 9 .OR. CC = 10 .OR. CC = 6  //Abre Arquivo Folha adiantamento/premio/vt
   CC := 1
ENDIF

MDS("Confirme Contas Credito Debito")
@ 24,40 GET CRE PICT "999"        
@ 24,50 GET DEB PICT "999"        
IF !READCUR()
   RETU .F.
ENDIF

IF !ARQUSAR(CC,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE1 := ALIAS()

IF !ARQPES(CC,1,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE2 := ALIAS()

FILTRO := FILTRO('((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES.AND.YEAR(DEMITIDO)>=ANO))')
SET FILTER TO &FILTRO

HB_dispbox(3,0,24,79,B_DOUBLE+" ")
@ 03,10 SAY "-"+REPL('-',48)+"-"                                                 
@ 04,02 SAY "Numero  Ý Nome do Funcionario"+SPAC(28)+"Ý   Valor a Pagar"         
@ 05,00 SAY 'Ç'+REPL('-',9)+"+"+REPL('-',48)+"+"+REPL('-',19)+'¶'                
FOR X := 6 TO 21
   @ X,10 SAY "Ý"+SPAC(48)+"Ý"         
NEXT X
@ 22,00 SAY 'Ç'+REPL('-',9)+"-"+REPL('-',15)+"-"+REPL('-',19)+"-"+REPL('-',12)+"-"+REPL('-',19)+'¶'                                      
@ 23,02 SAY "Funcionarios  "+REPL('-',2)+CHR(16)+SPAC(7)+"Ý Continua  "+REPL('-',2)+CHR(16)+"     Ý  Total "+REPL('-',2)+CHR(16)         
@ 24,26 SAY "-"+REPL('-',19)+"-"                                                                                                         

CTLIN := 6
TOTAL := QTFUN := 0

DBSELECTAR(cSELE2)
DBGOTOP()
WHILE !EOF()
   CTR := NUMERO
   IF CTLIN > 21
      @ 23,21 SAY QTFUN PICT "###"                   
      @ 23,63 SAY TOTAL PICT "###,###,###.##"        
      INKEY(0)
      IF LASTKEY() = 27
         DBCLOSEALL()
         RETU
      ENDIF
      @ 10,0 CLEA TO 21,79
      FOR X := 10 TO 21
         @ X,0 SAY 'Ý'+SPAC(9)+"Ý"+SPAC(48)+"Ý"+SPAC(19)+'Ý'         
      NEXT X
      CTLIN := 6
   ENDIF
   DBSELECTAR(cSELE1)
   VAL  := VALCTA(CTR,CRE)+IF(lVALE,VALCTA(CTR,997),0)
   VAL1 := VALCTA(CTR,DEB)+IF(lVALE,VALCTA(CTR,442),0)
   LIQ  := VAL - VAL1
   IF LIQ # 0
      DBSELECTAR(cSELE2)
      @ CTLIN,02 SAY NUMERO PICT "######"                
      @ CTLIN,12 SAY NOME                                
      @ CTLIN,63 SAY LIQ    PICT '###,###,###.##'        
      TOTAL += LIQ
      QTFUN ++
      CTLIN ++
   ENDIF
   DBSELECTAR(cSELE2)
   DBSKIP()
ENDDO
@ 23,21 SAY QTFUN PICT "###"                   
@ 23,63 SAY TOTAL PICT "###,###,###.##"        
INKEY(0)
DBCLOSEALL()
RETU

// : FIM: FOE24.PRG

*+ EOF: foe24.prg
*+
