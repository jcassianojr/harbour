// +--------------------------------------------------------------------
// +
// +    Programa  : disk72.prg
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +--------------------------------------------------------------------
// +

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Module => DISK72.PRG hb_filenamesplit
// +
// +    Functions: Function FILENAMES(GRUPO ,cCASE)
// +               Function TIRAEXT(cFile, opcional cEXT) ''so troca se passar cext senao so tira a extensao
// +               Function TROCAEXT(cFile, cEXT)
// +               Function DELETAARQ(cGRUPO)
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FILENAMES() 
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FILENAMES( GRUPO, cCASE )
   LOCAL aARQUIVOS
   LOCAL X
   LOCAL nLEN
   

   IF ValType( cCASE ) <> "C"
      cCASE := ""
   ENDIF
   aRETU:={}
   aARQUIVOS:={}
   X:=0
   nLEN:=0
   
   aARQUIVOS := hb_Directory( GRUPO ) 
   nLEN      := LEN(aARQUIVOS)
   FOR X := 1 TO nLEN
        DO CASE
           CASE cCASE = 'U'
                AADD(aRETU,Upper( aARQUIVOS[ X, 1 ] ))
           CASE cCASE = 'L'
                AADD(aRETU,Lower( aARQUIVOS[ X, 1 ] ))
           OTHERWISE
                AADD(aRETU,       aARQUIVOS[ X, 1 ]  )   
        ENDCASE 
    NEXT X
    RETURN aRETU


// +--------------------------------------------------------------------
// +
// +    Function TIRAEXT(cFile, cEXT) hb_FNameSplit(cPATHFILENAME_EXT , @cCAMINHO, cARQUIVO, cEXTENSAO )
// +
// +--------------------------------------------------------------------
// +

FUNCTION TIRAEXT( cFile, cEXT )  // Arquivo teste.txt ->teste se cext="tmp" test.tmp

   LOCAL cFILENAME

   hb_FNameSplit( cFile,, @cFILENAME )
   IF ValType( cEXT ) = "C"
      IF At( ".", cEXT ) = 0
         cEXT := "." + cEXT
      ENDIF
      cFilename += cEXT
   ENDIF
   RETU cFileName


// +--------------------------------------------------------------------
// +
// +    Function TROCAEXT()  'compatibilizar chamada com chamada trocaext ja em alguns programa evitando trocar o nome da funcao e evitar que nao exista
// +
// +--------------------------------------------------------------------
// +

FUNCTION TROCAEXT( cFile, cEXT )

   RETURN TIRAEXT( cFile, cEXT )



// +--------------------------------------------------------------------
// +
// +    Function DELETAARQ()
// +
// +--------------------------------------------------------------------
// +
FUNCTION DELETAARQ( cGRUPO )

   LOCAL aRETU
   LOCAL X

   IF ValType( cGRUPO ) # "C"
      cGRUPO := "TEMP*.*"
   ENDIF
   aRETU := FILENAMES( cGRUPO )
   FOR X := 1 TO Len( aRETU )
      FErase( aRETU[ X ] )
   NEXT X

