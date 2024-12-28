*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_2j.prg
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



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fopto_2j()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function fopto_2j

para lPER

PEGPTOHOR("XX",.T.,.F.)   //Verifica indices

IF ZFECHADO = "S"
   ALERTX("Mes ja Fechado")
   RETU .F.
ENDIF


IF VALTYPE(lPER) # "L"
   lPER := .T.
ENDIF
CABE2("FOPTO_2J - Lancar Correcoes Horarios - "+ANOMESW)
IF lPER
   if !MDG("Lancar Correcoes Horarios")
      retu .F.
   endif
ENDIF

cPH := "PH"+ANOMESW
cPN := "PN"+ANOMESW

if !NETUSE(cPH)
   retu .F.
endif
if !NETUSE(cPN)
   dbcloseall()
   retu .F.
endif
if !NETUSE("FOPTOHOR")
   dbcloseall()
   retu .T.
endif

dbselectar(cPH)
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
dbgotop()
while !eof()
   mNUMERO := NUMERO
   dINI    := OCOINI
   dFIM    := OCOFIM
   if empty(dFIM)
      dFIM := dINI
   endif
   dOCO := OCOCOD
   if !empty(dOCO)
      aRETU := PEGPTOHOR(dOCO,.F.)
      if aRETU[6]
         dbselectar(cPN)
         for J := dINI to dFIM
            dbgotop()
            IF dbseek(str(mNUMERO,8)+dtos(J))
               netreclock()
               field->CODREV  := dOCO
               field->ENTREV  := aRETU[1]
               field->ALIREV  := aRETU[2]
               field->ALSREV  := aRETU[3]
               field->SAIREV  := aRETU[4]
               field->virada  := aRETU[5]
               field->folsn   := aRETU[7]
               field->horario := aRETU[8]
               field->mudhor  := "#"
               DBUNLOCK()
            endif
         next
      endif
   endif
   dbselectar(cPH)
   dbskip()
   zei_fort(nLASTREC,,,1)
enddo
dbcloseall()


*+ EOF: fopto_2j.prg
*+
