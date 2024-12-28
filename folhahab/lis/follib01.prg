*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : follib01.prg
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
*+    Documentado em 27-Dez-2024 as  9:26 pm
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
*+    Function ARQIRR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC ARQIRR(nARQ,nSHA,nARU)

LOCAL cARQ := cIND := ""
DO CASE
CASE nARU = 1
   DO CASE
   CASE nARQ = 1
      cARQ := "AJUDIRF"
      cIND := "AJUDIRF"
   CASE nARQ = 2
      cARQ := "AJUDIRD"
      cIND := "AJUDIRD"
   CASE nARQ = 3 .OR. nARQ = 4
      cARQ := "AJUDIRA"
      cIND := "AJUDIRA"
   ENDCASE
CASE nARU = 2
   DO CASE
   CASE nARQ = 1
      cARQ := "FO_IRR"
      cIND := "FO_IRR"
   CASE nARQ = 2
      cARQ := "FO_IRD"
      cIND := "FO_IRD"
   CASE nARQ = 3 .OR. nARQ = 4
      cARQ := "FO_IRA"
      cIND := "FO_IRA"
   ENDCASE
CASE nARU = 3
   DO CASE
   CASE nARQ = 1
      cARQ := "FO_PES"
      cIND := "FO_PES"
   CASE nARQ = 2
      cARQ := "FO_DIR"
      cIND := "FO_DIR"
   CASE nARQ = 3
      cARQ := "MG01"
      cIND := "MG01"
   CASE nARQ = 4
      cARQ := "RPA01"
      cIND := "RPA01"
   ENDCASE
CASE nARU = 4
   DO CASE
   CASE nARQ = 1 .OR. nARQ = 2
      cARQ := "CONTAS"
      cIND := "CONTAS"
   CASE nARQ = 3
      cARQ := "CTARPA"
      cIND := "CTARPA"
   ENDCASE
ENDCASE
IF nSHA = 0
   RETU netuse(cARQ,,.F.,,,,)
ELSE
   RETU NETUSE(cARQ)
endif
RETU .F.




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function IRRESC()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC IRRESC

LOCAL cTELA := SAVESCREEN(6,26,16,58)
CLSBOX(6,26,16,58)
WHILE .T.
   HB_DISPBOX(6,26,16,58,B_DOUBLE)
   oPCAO(8,28," &A - Funcionarios    ",65)
   oPCAO(9,28," &B - Diretores       ",66)
   oPCAO(10,28," &C - RPA Folha       ",67)
   oPCAO(11,28," &D - RPA Programa    ",67)
   nARQ := MENU(,0)
   IF nARQ > 0 .AND. nARQ < 5
      EXIT
   ENDIF
ENDDO
RESTSCREEN(6,26,16,58,cTELA)
RETU nARQ

*+ EOF: follib01.prg
*+
