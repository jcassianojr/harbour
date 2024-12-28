*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fo3e.prg
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

#INCLUDE "BOX.CH"
caRQ := PEGCAMINI("CURSO")+"CURSO"


PADRAO(cARQ,cARQ,"' '+mCURSO+' '+mDESCUR","mCURSO","Cadastro de Cursos","Curso"+spac(6)+"Descri‡„o",;
 {|| PEGCHAVE("mCURSO",SPACE(10),"Codigo:")},{|| tFO3E()},{|| gFO3E()},{|| FO_FOR("GRUPO='CURSO'")})
RETU .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gFO3E()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC gFO3E

@  4,1  SAY mCURSO                              
@  4,12 GET mDESCUR                             
@  6,1  GET mCARGA  PICTURE '99999.99'          
@  6,12 GET mCERT   VALID mCERT $ "SN"          
@  6,25 GET mTIPCUR VALID mTIPCUR $ "IE"        
READCUR()
RETU .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function tFO3E()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC tFO3E

HB_DISPBOX(2,0,23,79,B_DOUBLE+" ")
@  3,1  SAY "Curso"+spac(6)+"Descri‡„o"                 
@  5,1  SAY "Carga Hor. Certificado  Tipo"              
@  6,14 SAY "(S/N)"+spac(9)+"(Interno/Externo)"         
RETU .T.

*+ EOF: fo3e.prg
*+
