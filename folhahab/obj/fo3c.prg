*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => J:\FOLHA\OBJ\FO3C.PRG
*+
*+    Functions: Function CADCBO()
*+
*+    Reformatted by Click! 2.03 on Mar-7-2003 at  1:41 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

function fo3c
para cARQ
if cARQ="FO_CBON"
   PADRAO(cARQ,cARQ,"' '+mCODIGO+' '+STRZERO(mCAGEDESCO,2)+' '+mNOME","mCODIGO","Codigos","Codigo Escolaridade Nome",;
          {|| PEGCHAVE("mCODIGO",SPACE(5),"Codigo:")},{|| mds("Desc:")},{||gcadcbo()},{|| FO_FOR("GRUPO='CBO'")})
ELSE
   PADRAO(cARQ,cARQ,"' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
          {|| PEGCHAVE("mCODIGO",SPACE(5),"Codigo:")},{|| mds("Desc:")},{||gcadcbo()},{|| FO_FOR("GRUPO='CBO'")})
ENDIF

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function CADCBO()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
funcTION gCADCBO
@ maxrow(), 08 get mNOME pict "@S50"
if cARQ="FO_CBON"
  @ maxrow(), 60 get mCAGEDESCO
endif  

READCUR()


*+ EOF: FO3C.PRG
