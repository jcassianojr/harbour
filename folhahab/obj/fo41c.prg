** Rejuste de Salarios por Faixa
////#INCLUDE "COMANDO.CH"

function fo41c
PARA wFO41C
CABEX('Calcular Reajuste Salarial')
MESD:=MES
@ 13,02 SAY "Digite o Mˆs do Novo Sal rio ======> "
@ 13,44 GET MESD PICT "##" RANGE 1,12
IF ! READCUR()
   RETU .F.
ENDIF   
IF ! MDG("Rejustar Sal rio do Mˆs de "+MMES(MESD))
   RETU .F.
ENDIF
MED='SAL'+SUBSTR(MMES(MESD),1,3)
zNORM:=OBTER("FIRMA",,NREMP,"SALNOR")
FILTRO:="EMPTY(DEMITIDO)"
FILTRO:=FILTRO(FILTRO)

IF ! netuse(pes)
   RETU .F.
ENDIF
SET FILTER TO &FILTRO

IF ! netuse("fo_fai") 
   DBCLOSEALL() 
   RETU .F.
ENDIF   
dbselectar(pes)
DBGOTOP()
WHILE ! EOF()
   mVALOR:=0
   mFAIXA:=OBTER("FUNCAO",,FUNCAO,"FAIXA")
   mTIPO :=TIPO
   dbselectar("fo_fai")
   DBGOTOP()
   if DBSEEK(mFAIXA)
      IF wFO41C=0
         mVALOR:=VALOR
      ELSE
         mVALOR:=INDICE*zNORM
      ENDIF
   ENDIF
   dbselectar(pes)
   IF ! EMPTY(mVALOR)
      //Corrige Mensalista
      mVALOR:=IF(TIPO="1" .OR. TIPO='M' ,mVALOR*MESHORA,mVALOR)
      netreclock()
      FIELD->&MED.:=ROUND(mVALOR,2)
      dbunlock()
   ENDIF
   DBSKIP()
ENDDO
DBCLOSEALL()