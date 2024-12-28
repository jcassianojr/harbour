*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foe22.prg
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
// :      FOE22.PRG: Exibir Entrada de Dados
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  SOFTEC  S/C Ltda.
// :  Atualizado em: 30/06/98
// :
// :*****************************************************************************

#INCLUDE "BOX.CH"

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function foe22()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function foe22

PARA CC
CABEX('Exibir Entrada de Dados')
IF CC = 9 .OR. CC = 10
   MDT("Use a op‡„o Folha Pagamento")
   RETU
ENDIF

DECLARE CTA[3]
AFILL(CTA,0)
HB_dispbox(8,0,10,38,B_DOUBLE+" ")
HB_dispbox(7,41,15,79,B_DOUBLE+" ")
@  9,2  SAY "Digite o Numero da Contas Desejadas"                   
@  9,46 SAY "Conta 1 :"                                             
@ 11,46 SAY "Conta 2 :"                                             
@ 13,46 SAY "Conta 3 :"                                             
@ 09,59 GET CTA[1]                                PICT '###'        
@ 11,59 GET CTA[2]                                PICT '###'        
@ 13,59 GET CTA[3]                                PICT '###'        
READCUR()
IF !MDG('Tudo ok !(S/N)')
   RETU
ENDIF

IF !ARQPES(CC,1,0)
   DBCLOSEALL()
   RETU .F.
ENDIF
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES.AND.YEAR(DEMITIDO)>=ANO))'
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

cSELE1 := ALIAS()

IF !ARQUSAR(CC,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE2 := ALIAS()

HB_dispbox(3,0,24,79,B_DOUBLE+" ")
@  4,08 SAY "-"+REPL('-',25)+"-"+REPL('-',14)+"-"+REPL('-',14)+"-"                                          
@  4,03 SAY "NUM  Ý NOME"+SPAC(20)+"Ý   Ý"+SPAC(10)+"Ý"+SPAC(14)+"Ý"                                        
@  5,00 SAY 'Ç'+REPL('-',7)+"+"+REPL('-',25)+"+"+REPL('-',14)+"+"+REPL('-',14)+"+"+REPL('-',14)+'¶'         
FOR X := 6 TO 21
   @ X,8 SAY "Ý"+SPAC(25)+"Ý"+SPAC(14)+"Ý"+SPAC(14)+"Ý"         
NEXT
@ 22,00 SAY 'Ç'+REPL('-',7)+"-"+REPL('-',25)+"-"+REPL('-',5)+"-"+REPL('-',8)+"-"+REPL('-',14)+"-"+REPL('-',14)+'¶'         
@ 24,40 SAY "-"                                                                                                            

FOR X := 1 TO 3
   @ 04,(20+X * 15) SAY CTA[X]         
NEXT X

QTFUN := 0
CTLIN := 6
DBSELECTAR(cSELE1)
DBGOTOP()
WHILE !EOF()
   IF CTLIN > 21
      @ 23,69 SAY QTFUN PICTURE "####"        
      INKEY(0)
      IF LASTKEY() = 27
         DBCLOSEALL()
         RETU
      ENDIF
      @ 10,00 CLEA TO 21,79
      FOR X := 10 TO 21
         @ X,00 SAY "Ý       Ý"+SPAC(25)+"Ý"+SPAC(14)+"Ý"+SPAC(14)+"Ý              Ý"         
      NEXT
      CTLIN := 6
   ENDIF
   NUM := NUMERO
   QTFUN ++
   @ CTLIN,2 SAY NUMERO            PICTURE "######"        
   @ CTLIN,9 SAY SUBSTR(NOME,1,25)                         
   FOR X := 1 TO 3
      BUSCA := (NUM * 10000)+CTA[X]
      DBSELECTAR(cSELE2)
      DBGOTOP()
      IF DBSEEK(BUSCA)
         IF HORAS # 0
            @ CTLIN,(20+X * 15) SAY HORAS PICT '###.##'        
         ELSE
            @ CTLIN,(20+X * 15) SAY VALOR PICT '###,###,###.##'        
         ENDIF
      ENDIF
   NEXT X
   CTLIN ++
   DBSELECTAR(cSELE1)
   DBSKIP()
ENDDO
@ 23,69 SAY QTFUN PICTURE "####"        
INKEY(0)
DBCLOSEALL()
RETU
// : FIM: FOE22.PRG

*+ EOF: foe22.prg
*+
