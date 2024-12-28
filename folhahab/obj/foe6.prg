*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foe6.prg
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
// :       FOE6.PRG: Apura‡„o geral da folha
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/94     11:58
// :
// :*****************************************************************************
#INCLUDE "BOX.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function foe6()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function foe6

PARA CC
CABEX('Apura‡„o geral da folha ')

IF !ARQUSAR(CC,1,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","conta")
ordSetFocus("temp")

cSELE1 := ALIAS()

IF !ARQCTA(CC)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE2 := ALIAS()


DBSELECTAR(cSELE1)
FILTRO := ''
FI     := TRIM(FILTRO)
FILTRO := FILTRO(FI)
SET FILTER TO &FILTRO
HB_dispbox(3,0,24,79,B_DOUBLE+" ")
@  3,6 SAY "-"+REPL('-',37)+"-"+REPL('-',13)+"-"                                          
@  4,2 SAY "CTA Ý DESCRIMINACAO DA CONTA"+SPAC(14)+"Ý HORAS"+SPAC(7)+"Ý   TOTAL"          
@  5,0 SAY 'Ç'+REPL('-',5)+"+"+REPL('-',37)+"+"+REPL('-',13)+"+"+REPL('-',20)+'¶'         
FOR X := 6 TO 21
   @ X,6 SAY "Ý"+SPAC(37)+"Ý"+SPAC(13)+"Ý"         
NEXT X
@ 22,00 SAY 'Ç'+REPL('-',5)+"-"+REPL('-',33)+"-"+REPL('-',3)+"-"+REPL('-',13)+"-"+REPL('-',20)+'¶'         
@ 23,02 SAY "Continua (S/N) "+REPL('-',3)+CHR(16)+SPAC(19)+"Ý Liquido "+REPL('-',3)+CHR(16)                
@ 24,40 SAY "-"                                                                                            

VENC  := DESC := LIQ := 0
CTLIN := 6
DBSELECTAR(cSELE1)
DBGOTOP()
WHILE !EOF()
   IF CTLIN > 21
      LIQ := VENC - DESC
      @ 23,65 SAY LIQ PICTURE "###,###,###.##"        
      INKEY(0)
      IF LASTKEY() = 27
         DBCLOSEALL()
         RETU
      ENDIF
      @  6,0 CLEAR TO 21,79
      FOR X := 6 TO 21
         @ X,00 SAY "Ý     Ý"+SPAC(37)+"Ý"+SPAC(13)+"Ý                    Ý"         
      NEXT
      CTLIN := 6
   ENDIF
   CTA := CONTA
   HOR := VAL := 0
   IMP := .T.
   IF CC # 4 .AND. CC # 6 .AND. CC # 8  //13o. e VT RPA
      IF CTA > 120 .AND. CTA < 150
         IMP := .F.
      ENDIF
      IF CTA = 910 .OR. CTA = 911 .OR. CTA = 505 .OR. CTA = 506
         IMP := .F.
      ENDIF
   ENDIF
   IF IMP
      DBSELECTAR(cSELE1)
      WHILE CTA = CONTA .AND. !EOF()
         HOR := HOR+HORAS
         VAL := VAL+VALOR
         DBSKIP()
      ENDDO
      DO CASE
      CASE CTA = 399 .AND. CC # 6
         VENC := VAL
      CASE CTA = 999 .AND. CC # 6
         DESC := VAL
      ENDCASE
      @ CTLIN,02 SAY CTA PICTURE "###"        
      DBSELECTAR(cSELE2)
      DBGOTOP()
      DBSEEK(CTA)
      @ CTLIN,08 SAY IF(FOUND(),DESCR,'Conta nao Cadastrada')         
      IF HOR # 0
         @ CTLIN,46 SAY HOR PICT '###,###.##'        
      ENDIF
      @ CTLIN,65 SAY VAL PICT '###,###,###.##'        
      CTLIN ++
   ELSE
      DBSELECTAR(cSELE1)
      WHILE CONTA = CTA .AND. !EOF()
         DBSKIP()
      ENDDO
   ENDIF
   DBSELECTAR(cSELE1)
ENDDO
LIQ := VENC - DESC
@ 23,65 SAY LIQ PICTURE "###,###,###.##"        
INKEY(0)
DBCLOSEALL()
RETU
// : FIM: FOE6.PRG

*+ EOF: foe6.prg
*+
