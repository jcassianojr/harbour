// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disk72.prg
// +
// +
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +
// +
// +
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +
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

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function FILENAMES() hb_FNameSplit(cPATHFILENAME_EXT , @cCAMINHO, cARQUIVO, cEXTENSAO )
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

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

   LOCAL DIR
   LOCAL RET_ARRAY
   LOCAL X

   IF ValType( cCASE ) <> "C"
      cCASE := ""
   ENDIF
   RET_ARRAY := Array( Len( DIR := Directory( GRUPO ) ) )
   FOR X := 1 TO Len( DIR )
      DO CASE
      CASE cCASE = 'U'
         RET_ARRAY[ X ] := Upper( DIR[ X, 1 ] )
      CASE cCASE = 'L'
         RET_ARRAY[ X ] := Lower( DIR[ X, 1 ] )
      CASE cCASE = ''
         RET_ARRAY[ X ] := DIR[ X, 1 ]
      ENDCASE
   NEXT X
   RETU RET_ARRAY

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function TIRAEXT(cFile, cEXT) hb_FNameSplit(cPATHFILENAME_EXT , @cCAMINHO, cARQUIVO, cEXTENSAO )
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TIRAEXT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
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

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function TROCAEXT ''compatibilizar chamada com chamada trocaext ja em alguns programa evitando trocar o nome da funcao e evitar que nao exista
// +
// hb_FNameSplit(cPATHFILENAME_EXT , @cCAMINHO, cARQUIVO, cEXTENSAO )
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TROCAEXT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION TROCAEXT( cFile, cEXT )

   RETURN TIRAEXT( cFile, cEXT )


// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function DELETAARQ() hb_FNameSplit(cPATHFILENAME_EXT , @cCAMINHO, cARQUIVO, cEXTENSAO )
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DELETAARQ()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
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

// + EOF: DISK72.PRG

// + EOF: disk72.prg
// +
