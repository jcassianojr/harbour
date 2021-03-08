//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"

*!*****************************************************************************
*!
*!         Fun‡„o: FECFOL()  Final de Folha de Impress„o
*!
*!*****************************************************************************
FUNC FECFOL(nCOL,lSALTA)
LOCAL LIN:=57-CTLIN,TRA
IF VALTYPE(nCOL)#"N"
   nCOL:=132
ENDIF
IF VALTYPE(lSALTA)#"L"
   lSALTA:=.T.
ENDIF
TRA:=INT((nCOL-LIN)/2)
@ CTLIN,0 SAY REPL("-",TRA)
FOR X=1 TO LIN
   @ CTLIN,TRA+X SAY "-"
   CTLIN++
NEXT X
@ CTLIN,nCOL-TRA SAY REPL("-",TRA)
IF lSALTA
   EJECT
ENDIF
RETU .T.

