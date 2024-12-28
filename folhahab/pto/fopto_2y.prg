*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_2y.prg
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
*+    Documentado em 27-Dez-2024 as  9:32 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

CABE2('FOPTO_2Y - Exclusao Demitidos')
cPN := "PN"+ANOMESW



IF !NETUSE(PES)
   RETU
ENDIF

IF !NETUSE(cPN)
   DBCLOSEALL()
   RETU
ENDIF
DBSELECTAR(PES)
WHILE !EOF()
   IF !EMPTY(DEMITIDO)
      PETELA(8)
      mNUMERO := NUMERO
      mDATA   := DEMITIDO
      mDATA ++
      DBSELECTAR(cPN)
      DBGOTOP()
      DBSEEK(STR(mNUMERO,8)+DTOS(mDATA))
      WHILE mNUMERO = NUMERO .AND. !EOF()
         netrecdel()
         DBSKIP()
      ENDDO
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
DBCLOSEALL()

*+ EOF: fopto_2y.prg
*+
