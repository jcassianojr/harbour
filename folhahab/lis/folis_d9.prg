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
*+    Documentado em 27-Dez-2024 as  9:26 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :   FOLIS_D9.PRG: Rais Ajustes de Codigos Velhos/Novos
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************

IF !NETUSE(PES)
   RETU .F.
ENDIF

IF !NETUSE("FORAIS")
   DBCLOSEALL()
   RETU .F.
ENDIF

dbselectar(pes)
DBGOTOP()
WHILE !EOF()
   mNUMERO := NUMERO
   PETELA(8)
   netreclock()
   CHECKMOTDEM()
   CorrigeFo_pes()
   DBSELECTAR("FORAIS")
   DBGOTOP()
   IF !DBSEEK(STR(nANOUSO,4)+STR(mNUMERO,8))
      netrecapp()
      FIELD->NUMERO := CTR
      FIELD->ANO    := ANOUSO
   ELSE
      netreclock()
   ENDIF
   IF EMPTY(RAISVINC)
      FIELD->RAISVINC := "10"
   ENDIF
   IF RAISVINC == "1 "
      FIELD->RAISVINC := "10"
   ENDIF
   IF EMPTY(TIPOADM)
      FIELD->TIPOADM := "2"
   ENDIF
   IF EMPTY(ALVARA)
      FIELD->ALVARA := "N"
   ENDIF
   IF EMPTY(DEMITIDO)
      FIELD->RAISDEM := "00"
   ENDIF
   dbselectar(pes)
   IF EMPTY(MOTIVO)
      FIELD->MOTIVO := OBTER("FO_RCAU",,FORAIS->RAISDEM,"CODIGO",2)
   ENDIF
   dbunlock()
   DBSKIP()
ENDDO
DBCLOSEALL()

*+ EOF: folis_d9.prg
*+
