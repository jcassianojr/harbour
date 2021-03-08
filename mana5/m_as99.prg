*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_as99.prg
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

//
//  Movimenta‡„o da Pe‡a
//
//
aMAS99 := {}
IF !USEREDE(ARQWORK,1,2)
   RETU .F.
ENDIF
DBGOTOP()
DBSEEK(mCODIGO)
WHILE ALLTRIM(CODIGO) == ALLTRIM(mCODIGO) .AND. !EOF()
   AADD(aMAS99,' '+DTOC(DATA)+' '+MAS99(ARQUIVO)+' '+STR(NUMERO,8)+' '+OPERACAO+' '+STR(ESTQXXX,11,3)+' '+STR(QTDE,11,3)+IF(ESTQYYY > ESTQXXX,"+","-")+' '+STR(ESTQYYY,11,3)+' '+USUARIO)
   DBSKIP()
ENDDO
DBCLOSEAREA()
IF LEN(aMAS99) = 0
   ALERTX("Sem Movimenta‡„o")
   RETU .F.
ENDIF
ESCARR(aMAS99,2,0,23,79,,"Data     Org Numero   O QTDE")
RETU .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAS99()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MAS99(cARQUSO)

LOCAL cARQ := "   "
DO CASE
   CASE cARQUSO = "MY" 
      cARQ := "REQ"
   CASE cARQUSO = "MK" 
      cARQ := "NFE"
   CASE cARQUSO = "MM" 
      cARQ := "NFV"
ENDCASE
RETU cARQ

