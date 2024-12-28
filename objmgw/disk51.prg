// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disk51.prg
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
// +    DISK51.PRG
// +
// +    Funcoes: Function Ext()
// +             Function Extx()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function Ext()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Ext()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC Ext( val_ext, lin, tam1, tam2, tam3 )

   PRIV cen
   PRIV dez
   PRIV uni
   PRIV str_ext
   PRIV ret_ext
   PRIV p01
   PRIV p02
   PRIV p03
   PRIV p04
   PRIV p05
   PRIV tab1
   PRIV tab2
   PRIV linha1
   PRIV linha2
   PRIV linha3

   cen := { "Cento", "Duzentos", "Trezentos", "Quatrocentos", "Quinhentos", ;
      "Seiscentos", "Setecentos", "Oitocentos", "Novecentos" }
   dez := { "Dez", "Vinte", "Trinta", "Quarenta", "Cinquenta", "Sessenta", "Setenta", ;
      "Oitenta", "Noventa" }
   uni := { "Um", "Dois", "Tres", "Quatro", "Cinco", "Seis", "Sete", "Oito", "Nove", ;
      "Dez", "Onze", "Doze", "Treze", "Quatorze", "Quinze", "Dezesseis", ;
      "Dezessete", "Dezoito", "Dezenove" }
   str_ext := Str( val_ext, 15, 2 )
   ret_ext := ""
   p01     := SubStr( str_ext, 1, 3 )
   p02     := SubStr( str_ext, 4, 3 )
   p03     := SubStr( str_ext, 7, 3 )
   p04     := SubStr( str_ext, 10, 3 )
   p05     := '0' + SubStr( str_ext, 14, 2 )
   IF Val( p01 ) > 0
      ret_ext += Extx( p01 )
      ret_ext += if( Val( p01 ) > 1, ' Bilhoes', ' Bilhao' )
      IF Val( p02 ) = 0 .AND. Val( p03 ) = 0 .AND. Val( p04 ) = 0
         ret_ext += ' de ' + zmoeda02
      ENDIF
   ENDIF
   IF Val( p02 ) > 0
      ret_ext += if( Empty( ret_ext ), '', if( Val( p03 ) = 0 .AND. Val( p04 ) = 0, ' e ', ', ' ) )
      ret_ext += Extx( p02 )
      ret_ext += if( Val( p02 ) > 1, ' Milhoes', ' Milhao' )
      IF Val( p03 ) = 0 .AND. Val( p04 ) = 0
         ret_ext += ' de ' + zmoeda02
      ENDIF
   ENDIF
   IF Val( p03 ) > 0
      ret_ext += if( Empty( ret_ext ), '', if( Val( p04 ) = 0 .AND. Val( p05 ) = 0, ' e ', ', ' ) )
      ret_ext += Extx( p03 )
      ret_ext += ' Mil'
      IF Val( p04 ) = 0
         ret_ext += ' ' + zmoeda01
      ENDIF
   ENDIF
   IF Val( p04 ) > 0
      ret_ext += if( Empty( ret_ext ), '', if( Val( p05 ) = 0, ' e ', ', ' ) )
      ret_ext += Extx( p04 )
      ret_ext += if( Val( p04 ) > 1, ' ' + zmoeda01, ' ' + zmoeda02 )
   ENDIF
   IF Val( p05 ) > 0
      ret_ext += if( Empty( ret_ext ), '', ' ' + zmoeda05 + ' ' )
      ret_ext += Extx( p05 )
      ret_ext += if( Val( p05 ) > 1, ' ' + zmoeda03, ' ' + zmoeda04 )
   ENDIF
// *** POSICIONADO O EXTENSO DENTRO DAS LINHAS PRE-DETERMINADAS NO FORMULARIO
   ret_ext := AllTrim( ret_ext ) + ' '
   ret_ext += ( repl( '*', 240 - Len( ret_ext ) ) )

   tab1 := tam1
   IF SubStr( ret_ext, tab1, 1 ) <> " " .AND. SubStr( ret_ext, tab1, 1 ) <> "*"
      IF SubStr( ret_ext, tab1 + 1, 1 ) <> " " .AND. SubStr( ret_ext, tab1 + 1, 1 ) <> "*"
         WHILE SubStr( ret_ext, tab1, 1 ) <> " " .AND. SubStr( ret_ext, tab1, 1 ) <> "*"
            tab1--
         ENDDO
         tab1--
      ENDIF
   ELSE
      tab1--
   ENDIF
   linha1 := AllTrim( SubStr( ret_ext, 1, tab1 ) )
   tab2   := tab1 + 2 + tam2
   IF SubStr( ret_ext, tab2, 1 ) <> " " .AND. SubStr( ret_ext, tab2, 1 ) <> "*"
      IF SubStr( ret_ext, tab2 + 1, 1 ) <> " " .AND. SubStr( ret_ext, tab2 + 1, 1 ) <> "*"
         WHILE SubStr( ret_ext, tab2, 1 ) <> " " .AND. SubStr( ret_ext, tab2, 1 ) <> "*"
            tab2--
         ENDDO
         tab2--
      ENDIF
   ELSE
      tab2--
   ENDIF
   linha2 := AllTrim( SubStr( ret_ext, tab1 + 2, ( tab2 - ( tab1 + 2 ) ) + 1 ) )
   linha3 := SubStr( ret_ext, tab2 + 2, tam3 )
   IF lin = 1
      ret_ext := linha1
   ELSEIF lin = 2
      ret_ext := linha2
   ELSEIF lin = 3
      ret_ext := linha3
   ELSE
      ret_ext := ' '
   ENDIF

   RETU AllTrim( ret_ext )



// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function Extx()
// +
// +    Called from ( disk51.prg   )   5 - function ext()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function Extx()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC Extx( pp )   // VERIFICANDO DEZENA E UNIDADES

   PRIV retorno
   PRIV pp01
   PRIV pp02
   PRIV pp03

   retorno := ""
   pp01    := Val( SubStr( pp, 1, 1 ) )
   pp02    := Val( SubStr( pp, 2, 1 ) )
   pp03    := Val( SubStr( pp, 3, 1 ) )
   IF pp01 > 0
      retorno := cen[ PP01 ]
      IF pp02 = 0 .AND. pp03 = 0
         IF pp01 = 1
            retorno := "Cem"
         ENDIF
      ENDIF
   ENDIF
   IF pp02 > 1
      retorno += if( Empty( retorno ), '', ' e ' ) + dez[ PP02 ]
   ENDIF
   IF pp02 = 1
      retorno += if( Empty( retorno ), '', ' e ' ) + uni[ 10 + PP03 ]
   ENDIF
   IF pp03 > 0 .AND. pp02 # 1
      retorno += if( Empty( retorno ), '', ' e ' ) + uni[ PP03 ]
   ENDIF
   RETU ( retorno )

// + EOF: DISK51.PRG

// + EOF: disk51.prg
// +
