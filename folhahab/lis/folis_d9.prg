*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : folis_d9.prg
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
*+    Documentado em 14-Out-2026 as  4:52 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function folis_d9()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION folis_d9()


IF !NETUSE(PES)
   RETU .F.
ENDIF

IF !NETUSE("FORAIS")
   dbCloseAll()
   RETU .F.
ENDIF

dbSelectAr(pes)
dbGoTop()
WHILE !Eof()
   mNUMERO := NUMERO
   PETELA(8)
   netreclock()
   CHECKMOTDEM()
   CorrigeFo_pes()
   dbSelectAr("FORAIS")
   dbGoTop()
   IF !dbSeek(Str(nANOUSO,4)+Str(mNUMERO,8))
      netrecapp()
      FIELD->NUMERO := CTR
      FIELD->ANO    := ANOUSO
   ELSE
      netreclock()
   ENDIF
   IF Empty(RAISVINC)
      FIELD->RAISVINC := "10"
   ENDIF
   IF RAISVINC == "1 "
      FIELD->RAISVINC := "10"
   ENDIF
   IF Empty(TIPOADM)
      FIELD->TIPOADM := "2"
   ENDIF
   IF Empty(ALVARA)
      FIELD->ALVARA := "N"
   ENDIF
   IF Empty(DEMITIDO)
      FIELD->RAISDEM := "00"
   ENDIF
   dbSelectAr(pes)
   IF Empty(MOTIVO)
      FIELD->MOTIVO := OBTER("FO_RCAU",,FORAIS->RAISDEM,"CODIGO",2)
   ENDIF
   dbUnlock()
   dbSkip()
ENDDO
dbCloseAll()

RETURN


*+ EOF: folis_d9.prg
*+
