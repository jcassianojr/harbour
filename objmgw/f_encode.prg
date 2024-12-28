// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : f_encode.prg
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

#define ADJVAL  30

// ****************************************************************
//
// function encode
//
// ****************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ENCODE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ENCODE( in_string, lUPPER )

   LOCAL counter := in_len := 0, next_char := out_string := '', nASC

   IF ValType( lUPPER ) <> "L"
      lUPPER := .T.
   ENDIF

   IF in_string != NIL

      // Ajusta a cadeia especificada e converte as letras em maiusculas.
      in_string := AllTrim( in_string )
      IF lUPPER
         in_string := Upper( in_string )
      ENDIF

      in_len := Len( in_string )

      // Inverte a cadeia, inclui 30 em cada caracter e o duplica.
      FOR counter := 1 TO in_len

         // Obtem os caracteres na ordem inversa.
         next_char := SubStr( in_string, counter * -1, 1 )

         // Inclui o caracter na cadeia de retorno, se for numerico,alfabetico ou simbolo valido

         // next_char == '.'.OR. next_char == '_'.OR.            ISDIGIT(next_char) .OR. ISALPHA(next_char)
         IF IsDigit( next_char ) .OR. IsAlpha( next_char ) .OR. next_char $ '-+_!@#$%^&*., ?'
            nASC := ( Asc( next_char ) + ADJVAL ) * 2
            IF nASC > 255
               nASC := nASC - 220  // -255 gerava caracteres de controle minimo = 32 espaco 255-32=223 usando 220 z(122)=304 - 220 = 84
               // z ultimo valor aceitabel
            ENDIF
            out_string := out_string + Chr( nASC )   // CHR((ASC(next_char) + ADJVAL) * 2)
         ENDIF
      NEXT
   ENDIF

   RETURN out_string

// ****************************************************************
//
// function decode
//
// ****************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DECODE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION DECODE( in_string )

// # define ADJVAL  30
   LOCAL counter := in_len := 0, out_string := '', nASC
   IF in_string != NIL

      // Ajusta a cadeia especificada.
      in_string := AllTrim( in_string )
      in_len    := Len( in_string )

      // Obtem o valor ASCII de cada posicao e recupera o valor original.
      FOR counter := 1 TO in_len
         nASC := Asc( SubStr( in_string, counter * -1, 1 ) )  // CHR((ASC(SUBSTR(in_string, counter * -1, 1)) /2) - ADJVAL)
         IF nASC < 85  // -255 gerava caracteres de controle minimo = 32 espaco 255-32=223 usando 220 z(122)=304 - 220 = 84
            nASC := nASC + 220   // z ultimo valor aceitaVel
         ENDIF
         nASC       := Int( nASC / 2 )
         nASC       := nASC - ADJVAL
         out_string := out_string + Chr( nASC )  // CHR((ASC(SUBSTR(in_string, counter * -1, 1)) /2) - ADJVAL)
      NEXT

   ENDIF

   RETURN out_string

// ****************************************************************
//
// function encodeval
//
// ****************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ENCODEVAL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ENCODEVAL( in_string )

   LOCAL counter, next_char, aCHAVE

   aCHAVE := Array( 10 )
   AFill( aCHAVE, 0 )
   in_string := AllTrim( in_string )
   IF Empty( in_string )
      RETURN aCHAVE
   ENDIF
   FOR counter := 1 TO Len( in_string )  // out_string := out_string +  CHR((ASC(next_char) + ADJVAL) * 2)
      next_char         := SubStr( in_string, counter * -1, 1 )   // *-1 apra reversao das string
      nCHAR             := Asc( next_char )
      nCHAR             := nCHAR + ADJVAL
      nCHAR             := nCHAR * 2
      aCHAVE[ counter ] := nCHAR
   NEXT

   RETURN aCHAVE

// ****************************************************************
//
// function decodeval
//
// ****************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DECODEVAL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION DECODEVAL( aVALOR )

   LOCAL in_string, nVALOR, counter, nLEN, nPOSREV

   in_string := ""
   nLEN      := Len( aVALOR )
   FOR counter := 1 TO Len( aVALOR )
      nPOSREV := nLEN - counter + 1
      IF aVALOR[ nPOSREV ] > 0
         nVALOR    := aVALOR[ nPOSREV ]  // CHR((ASC(SUBSTR(in_string, counter * -1, 1)) /2) - ADJVAL)
         nVALOR    := Int( nVALOR / 2 )
         nVALOR    := nVALOR - ADJVAL
         in_string := in_string + Chr( nVALOR )
      ENDIF
   NEXT

   RETURN in_string


// +--------------------------------------------------------------------
// +
// +    Function XDECODE()
// +
// +--------------------------------------------------------------------
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function XDECODE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION XDECODE( cVAR )

   RETURN if( Empty( cVAR ), cVAR, DECODE( cVAR ) )

// +--------------------------------------------------------------------
// +
// +    Function XENCODE()
// +
// +--------------------------------------------------------------------
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function XENCODE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION XENCODE( cVAR, lUPPER )

   RETURN if( Empty( cVAR ), cVAR, ENCODE( cVAR, lUPPER ) )

// +--------------------------------------------------------------------
// +
// +    Function XDECDAT()
// +
// +--------------------------------------------------------------------
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function XDECDAT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION XDECDAT( cVAR )

   cVAR := XDECODE( cVAR )
   cVAR := CToD( Left( cVAR, 2 ) + '/' + SubStr( cVAR, 3, 2 ) + '/' + Right( cVAR, 2 ) )

   RETURN cVAR

// + EOF: f_encode.prg
// +
