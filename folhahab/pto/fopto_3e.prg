////#INCLUDE "COMANDO.CH"

function fopto_3e
para  cTIPO


IF ! MDL('FOPTO_3E - Passagens de Funcion rios ')
   RETU
ENDIF

ntipo:=PEGRELOGIO()

CTLIN:=80
PAG=1
DIAX=DATE()

cARQ := TARQREL( nTIPO, .T., cTIPO )

IF cTIPO # "D"
   IF ! NETUSE(cARQ,,,,,.F.,) 
      RETU
   ENDIF
ELSE
  IF ! NETUSE(carq) 
      RETU
  ENDIF
  dbsetorder(2)
ENDIF


FILTRO=''
FI=TRIM(FILTRO)
FILTRO=FILTRO(FI)
SET FILTER TO &FILTRO

IMPRESSORA()
DBGOTOP()
WHILE ! EOF()
   IF CTLIN>50
      CABEC("Passagens","")
      CTLIN:=8
   ENDIF
   @ CTLIN,00 SAY NUMERO
   @ CTLIN,09 SAY HORA
   @ CTLIN,17 SAY DATA
   DBSKIP()    //3 Colunas Diferentes Razao Skip
   IF ! EOF()
      @ CTLIN,26 SAY NUMERO
      @ CTLIN,35 SAY HORA
      @ CTLIN,43 SAY DATA
   ENDIF
   DBSKIP()
   IF ! EOF()
      @ CTLIN,52 SAY NUMERO
      @ CTLIN,61 SAY HORA
      @ CTLIN,69 SAY DATA
   ENDIF
   CTLIN++
   DBSKIP()
ENDDO
IMPFOL()
DBCLOSEALL()
IMPEND()
