*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : flib13.prg
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
*+    Documentado em 27-Dez-2024 as  9:44 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function LISTARUE()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC LISTARUE(bREL,bGER)

PRIV NUMDEP := 0,aFUE := {}
CLSROW(8)
HB_DISPBOX(08,00,18,64,B_DOUBLE+" ")
OPCAO(10,2," &A - Global       (Lista Sequencialmente, sem quebras)    ",65)
OPCAO(12,2," &B - Departamento (Quebra a listagem a cada Departamento) ",66)
OPCAO(14,2," &C - Setor        (Quebra a listagem a cada Setor)        ",67)
OPCAO(16,2," &D - Secao        (Quebra a listagem a cada Secao)        ",68)
OPCAO(17,2," &E - Sequencia Indicada Funcionarios                      ",69)
KEY := MENU(,0)

IF KEY = 0
   RETU
ENDIF

IF KEY > 1 .AND. KEY < 5
   DO CASE
   CASE KEY = 2
      FILTRA := 'SETOR=0.AND.SECAO=0'
      COMPAR := 'DEP=DEPTO'
   CASE KEY = 3
      FILTRA := 'SETOR#0.AND.SECAO=0'
      COMPAR := 'DEP=DEPTO.AND.SET=SETOR'
   CASE KEY = 4
      FILTRA := 'SETOR#0.AND.SECAO#0'
      COMPAR := 'DEP=DEPTO.AND.SET=SETOR.AND.SEC=SECAO'
   ENDCASE
   MDNOM := {}
   MDDEP := {}
   MDSET := {}
   MDSEC := {}
   IF !netuse("DEPTO")
      DBCLOSEALL()
      RETURN .F.
   ENDIF
   SET FILTER TO &FILTRA
   DBGOTOP()
   IF EOF()
      DBCLOSEALL()
      MDT('Verifique o Cadastro de Departamentos')
      RETURN .F.
   ENDIF
   WHILE !EOF()
      AADD(MDNOM,NOME)
      AADD(MDDEP,DEPTO)
      AADD(MDSET,SETOR)
      AADD(MDSEC,SECAO)
      DBSKIP()
   ENDDO
   DBCLOSEAREA()
   NUMDEP := LEN(MDNOM)
ENDIF
IF KEY = 5
   nNUMERO := 0
   @ 24,00 SAY "Funcionario No."                
   @ 24,60 SAY "Esc ou 0 para encerrar"         
   WHILE .T.
      @ 24,20 GET nNUMERO         
      IF !READCUR()
         EXIT
      ENDIF
      IF EMPTY(nNUMERO)
         EXIT
      ENDIF
      AADD(aFUE,nNUMERO)
   ENDDO
ENDIF



FL := 0
IMPRESSORA()
DO CASE
CASE KEY = 1
   NOMSETOR := ""
   EVAL(bREL,".T.")
CASE KEY = 5
   NOMSETOR := ""
   EVAL(bREL,"ASCAN(aFUE,NUMERO)>0")
OTHERWISE
   FOR X := 1 TO NUMDEP
      NOMSETOR := MDNOM[X]
      DEP      := MDDEP[X]
      SET      := MDSET[X]
      SEC      := MDSEC[X]
      EVAL(bREL,COMPAR)
   NEXT X
ENDCASE
DBCLOSEALL()
IF VALTYPE(bGER) = "B"
   EVAL(bGER)
ENDIF
VIDEO()
IMPEND()
RETURN .T.

*+ EOF: flib13.prg
*+
