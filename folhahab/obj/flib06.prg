#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function OBTER()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
funcTION OBTER( cARQ,eSemUso, KEYINDEX, cCAMPO, nIND, nROW, nCOL, cMES, cMES2, cDEF )            
local cDBF := alias()
local FECHAR  := .F.
local cRETU   := ""
if valtype( nIND ) # "N"
   nIND := 1
endif
if valtype (cDEF) # "U"
   cRETU := cDEF
endif
if select( cARQ ) = 0 
   if ! netuse(cARQ) 
      return cRETU
   endif
   FECHAR := .T.
else
   dbselectar( cARQ )
endif
if nIND > 1
   dbsetorder( nIND )
endif
dbgotop()
IF dbseek(keyindex)
   cRETU:=&cCAMPO.
else
   IF VALTYPE(cDEF)="U"
     cRETU:=MAKE_EMPTY(cCAMPO)
   ENDIF
endif
if valtype( nROW ) = "N"
   if ! EMPTY(cRETU)
      @ nROW, nCOL say &cMES.
   else
      @ nROW, nCOL say &cMES2.
   endif
endif
if FECHAR
   dbclosearea()
endif
if ! empty( cDBF )
   dbselectar(cDBF)
endif
return cRETU
