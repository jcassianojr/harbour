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
*+    Documentado em 15-Out-2026 as 10:21 am
*+
*+
*+
*+--------------------------------------------------------------------
*+


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fopto_2y()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION fopto_2y()


CABE2('FOPTO_2Y - Exclusao Demitidos')
cPN := "PN"+ANOMESW



IF !NETUSE(PES)
   RETU
ENDIF

IF !NETUSE(cPN)
   dbCloseAll()
   RETU
ENDIF
dbSelectAr(PES)
WHILE !Eof()
   IF !Empty(DEMITIDO)
      PETELA(8)
      mNUMERO := NUMERO
      mDATA   := DEMITIDO
      mDATA ++
      dbSelectAr(cPN)
      dbGoTop()
      dbSeek(Str(mNUMERO,8)+DToS(mDATA))
      WHILE mNUMERO = NUMERO .AND. !Eof()
         netrecdel()
         dbSkip()
      ENDDO
   ENDIF
   dbSelectAr(PES)
   dbSkip()
ENDDO
dbCloseAll()

RETURN


*+ EOF: fopto_2y.prg
*+
