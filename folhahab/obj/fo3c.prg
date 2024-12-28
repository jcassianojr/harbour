*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fo3c.prg
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
*+    Documentado em 27-Dez-2024 as  9:44 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fo3c()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function fo3c

para cARQ
if cARQ = "FO_CBON"
   PADRAO(cARQ,cARQ,"' '+mCODIGO+' '+STRZERO(mCAGEDESCO,2)+' '+mNOME","mCODIGO","Codigos","Codigo Escolaridade Nome",;
    {|| PEGCHAVE("mCODIGO",SPACE(5),"Codigo:")},{|| mds("Desc:")},{|| gcadcbo()},{|| FO_FOR("GRUPO='CBO'")})
ELSE
   PADRAO(cARQ,cARQ,"' '+mCODIGO+' '+mNOME+' '","mCODIGO","Codigos","Codigo Nome",;
    {|| PEGCHAVE("mCODIGO",SPACE(5),"Codigo:")},{|| mds("Desc:")},{|| gcadcbo()},{|| FO_FOR("GRUPO='CBO'")})
ENDIF


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gCADCBO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
funcTION gCADCBO

@ maxrow(),08 get mNOME pict "@S50"        
if cARQ = "FO_CBON"
   @ maxrow(),60 get mCAGEDESCO         
endif

READCUR()



*+ EOF: fo3c.prg
*+
