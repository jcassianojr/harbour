*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => DISK72.PRG
*+
*+    Functions: Function FILENAMES(GRUPO ,cCASE)
*+               Function TIRAEXT(cFile, opcional cEXT) ''so troca se passar cext senao so tira a extensao
*+               Function TROCAEXT(cFile, cEXT) 
*+               Function DELETAARQ(cGRUPO)
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function FILENAMES()
*+
*+    Called from ( disk72.prg   )   1 - function deletaarq()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function FILENAMES( GRUPO ,cCASE)
local dir
local RET_ARRAY
local X
IF VALTYPE(cCASE)<>"C"
   cCASE:=""
ENDIF
RET_ARRAY := array( len( DIR := directory( GRUPO ) ) )
for X := 1 to len( DIR )
   DO CASE
      CASE cCASE='U'
           RET_ARRAY[ X ] := UPPER(dir[ X, 1 ])
      CASE cCASE='L'
           RET_ARRAY[ X ] := LOWER(dir[ X, 1 ])
      CASE cCASE=''
           RET_ARRAY[ X ] := dir[ X, 1 ]
  ENDCASE	   
next X
retu RET_ARRAY

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function TIRAEXT(cFile, cEXT)
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION TIRAEXT( cFile, cEXT )             //Arquivo teste.txt ->teste se cext="tmp" test.tmp
   LOCAL cFILENAME 
   hb_fNameSplit( cFile,,@cFILENAME )
   if valtype( cEXT ) = "C"
      IF AT(".",cEXT)=0
        cEXT += "." + cEXT
      ENDIF
      cFilename += cEXT
   endif
   retu cFileName

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function TROCAEXT ''compatibilizar chamada com chamada trocaext ja em alguns programa evitando trocar o nome da funcao e evitar que nao exista
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION TROCAEXT(cFile, cEXT)
RETURN TIRAEXT( cFile, cEXT )


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function DELETAARQ()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function DELETAARQ( cGRUPO )

local aRETU
local X
if valtype( cGRUPO ) # "C"
   cGRUPO := "TEMP*.*"
endif
aRETU := FILENAMES( cGRUPO )
for X := 1 to len( aRETU )
   ferase( aRETU[ X ] )
next X

*+ EOF: DISK72.PRG
