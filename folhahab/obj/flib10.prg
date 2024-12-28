*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : flib10.prg
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

/* agora unficada f_encode
FUNCTION XDECODE(cVAR)
RETURN IF(EMPTY(cVAR),cVAR,DECODE(cVAR))

FUNCTION XENCODE(cVAR)
RETURN IF(EMPTY(cVAR),cVAR,ENCODE(cVAR))

FUNCTION XDECDAT(cVAR)
cVAR:=XDECODE(cVAR)
cVAR:=CTOD(LEFT(cVAR,2)+'/'+SUBSTR(cVAR,3,2)+'/'+RIGHT(cVAR,2))
RETURN cVAR
*/


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function USERMCRI()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION USERMCRI(cUSER,cITEM,nPOS)

RETURN ENCODE(STRZERO(nPOS,2)+LEFT(cUSER,2)+cITEM+SUBSTR(cUSER,3))


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function USERMDEC()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION USERMDEC(cUSER,cITEM,nPOS)

RETURN DECODE(STRZERO(nPOS,2)+LEFT(cUSER,2)+cITEM+SUBSTR(cUSER,3))

*+ EOF: flib10.prg
*+
