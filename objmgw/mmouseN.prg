*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\OBJ\MMOUSEN.PRG
*+
*+    Functions: Function OPCAO()
*+               Function menu()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

function OPCAO( nRow, nCol, cText, nAccl, cMES, bEXE )
cTEXT:=STRTRAN(ctext,"&","")
@  nRow, nCOL prompt cTEXT message cMES
return NIL

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function menu()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function menu( nCurrentPrompt, nMES )
IF VALTYPE(nMES)="N"
	Set( _SET_MESSAGE, nMES , .T. )
ENDIF    
menu to nCurrentPrompt
return nCurrentPrompt

