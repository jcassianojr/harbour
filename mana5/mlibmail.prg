*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlibmail.prg
*+
*+
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2010, Jorge Cassiano
*+
*+
*+
*+    Documentado em 30-Ago-2011 as 10:55 am
*+
*+
*+
*+--------------------------------------------------------------------
*+


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function EMAILINT()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC EMAILINT(cERRO,cTEXTO)

LOCAL cDBF := ALIAS()
cDIGA := cTEXTO
cDIZ  := ""
IF ValType(cDIGA) = "A"
   FOR X := 1 TO Len(cDIGA)
      cDIZ += cDIGA[X]+CHR(13)+CHR(10)
   NEXT X
ELSE
   cDIZ := cTEXTO
ENDIF
WHILE !USEMULT({{"MAIL",1,0},{"MAILERRO",1,1},{"MAILPARA",1,1}})
ENDDO
DBSELECTAR("MAILERRO")
DBGOTOP()
IF DBSEEK(cERRO)
   cASSUNTO := ASSUNTO
   DBSELECTAR("MAILPARA")
   DBGOTOP()
   DBSEEK(cERRO)
   WHILE ERRO = cERRO .AND. !EOF()
      cDESTINO := DESTINO
      DBSELECTAR("MAIL")
      netrecapp()
      FIELD->NUMERO  := RECNO()
      FIELD->DATA    := DATE()
      FIELD->HORA    := TIME()
      FIELD->DE      := ZUSER
      FIELD->ERRO    := cERRO
      FIELD->DESTINO := cDESTINO
      FIELD->ASSUNTO := cASSUNTO
      FIELD->TEXTO   := cDIZ
      DBSELECTAR("MAILPARA")
      DBSKIP()
   ENDDO
ENDIF
DBSELECTAR("MAIL")
DBCLOSEAREA()
DBSELECTAR("MAILERRO")
DBCLOSEAREA()
DBSELECTAR("MAILPARA")
DBCLOSEAREA()
IF !EMPTY(cDBF)
   SELE &cDBF.
ENDIF
RETU .T.
