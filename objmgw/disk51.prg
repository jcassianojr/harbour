*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    DISK51.PRG
*+
*+    Funcoes: Function Ext()
*+             Function Extx()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function Ext()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func Ext( val_ext, lin, tam1, tam2, tam3 )


priv cen
priv dez
priv uni
priv str_ext
priv ret_ext
priv p01
priv p02
priv p03
priv p04
priv p05
priv tab1
priv tab2
priv linha1
priv linha2
priv linha3
cen := { "Cento", "Duzentos", "Trezentos", "Quatrocentos", "Quinhentos", ;
         "Seiscentos", "Setecentos", "Oitocentos", "Novecentos" }
dez := { "Dez", "Vinte", "Trinta", "Quarenta", "Cinquenta", "Sessenta", "Setenta", ;
         "Oitenta", "Noventa" }
uni := { "Um", "Dois", "Tres", "Quatro", "Cinco", "Seis", "Sete", "Oito", "Nove", ;
         "Dez", "Onze", "Doze", "Treze", "Quatorze", "Quinze", "Dezesseis", ;
         "Dezessete", "Dezoito", "Dezenove" }
str_ext := str( val_ext, 15, 2 )
ret_ext := ""
p01     := substr( str_ext, 1, 3 )
p02     := substr( str_ext, 4, 3 )
p03     := substr( str_ext, 7, 3 )
p04     := substr( str_ext, 10, 3 )
p05     := '0' + substr( str_ext, 14, 2 )
if val( p01 ) > 0
   ret_ext += Extx( p01 )
   ret_ext += if( val( p01 ) > 1, ' Bilhoes', ' Bilhao' )
   if val( p02 ) = 0 .and. val( p03 ) = 0 .and. val( p04 ) = 0
      ret_ext += ' de ' + zmoeda02
   endif
endif
if val( p02 ) > 0
   ret_ext += if( empty( ret_ext ), '', if( val( p03 ) = 0 .and. val( p04 ) = 0, ' e ', ', ' ) )
   ret_ext += Extx( p02 )
   ret_ext += if( val( p02 ) > 1, ' Milhoes', ' Milhao' )
   if val( p03 ) = 0 .and. val( p04 ) = 0
      ret_ext += ' de ' + zmoeda02
   endif
endif
if val( p03 ) > 0
   ret_ext += if( empty( ret_ext ), '', if( val( p04 ) = 0 .and. val( p05 ) = 0, ' e ', ', ' ) )
   ret_ext += Extx( p03 )
   ret_ext += ' Mil'
   if val( p04 ) = 0
      ret_ext += ' ' + zmoeda01
   endif
endif
if val( p04 ) > 0
   ret_ext += if( empty( ret_ext ), '', if( val( p05 ) = 0, ' e ', ', ' ) )
   ret_ext += Extx( p04 )
   ret_ext += if( val( p04 ) > 1, ' ' + zmoeda01, ' ' + zmoeda02 )
endif
if val( p05 ) > 0
   ret_ext += if( empty( ret_ext ), '', ' ' + zmoeda05 + ' ' )
   ret_ext += Extx( p05 )
   ret_ext += if( val( p05 ) > 1, ' ' + zmoeda03, ' ' + zmoeda04 )
endif
// *** POSICIONADO O EXTENSO DENTRO DAS LINHAS PRE-DETERMINADAS NO FORMULARIO
ret_ext := alltrim( ret_ext ) + ' '
ret_ext += ( repl( '*', 240 - len( ret_ext ) ) )

tab1 := tam1
if substr( ret_ext, tab1, 1 ) <> " " .and. substr( ret_ext, tab1, 1 ) <> "*"
   if substr( ret_ext, tab1 + 1, 1 ) <> " " .and. substr( ret_ext, tab1 + 1, 1 ) <> "*"
      while substr( ret_ext, tab1, 1 ) <> " " .and. substr( ret_ext, tab1, 1 ) <> "*"
         tab1 --
      enddo
      tab1 --
   endif
else
   tab1 --
endif
linha1 := alltrim( substr( ret_ext, 1, tab1 ) )
tab2   := tab1 + 2 + tam2
if substr( ret_ext, tab2, 1 ) <> " " .and. substr( ret_ext, tab2, 1 ) <> "*"
   if substr( ret_ext, tab2 + 1, 1 ) <> " " .and. substr( ret_ext, tab2 + 1, 1 ) <> "*"
      while substr( ret_ext, tab2, 1 ) <> " " .and. substr( ret_ext, tab2, 1 ) <> "*"
         tab2 --
      enddo
      tab2 --
   endif
else
   tab2 --
endif
linha2 := alltrim( substr( ret_ext, tab1 + 2, ( tab2 - ( tab1 + 2 ) ) + 1 ) )
linha3 := substr( ret_ext, tab2 + 2, tam3 )
if lin = 1
   ret_ext := linha1
elseif lin = 2
   ret_ext := linha2
elseif lin = 3
   ret_ext := linha3
else
   ret_ext := ' '
endif

retu alltrim( ret_ext )



*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function Extx()
*+
*+    Called from ( disk51.prg   )   5 - function ext()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func Extx(pp)           // VERIFICANDO DEZENA E UNIDADES

priv retorno
priv pp01
priv pp02
priv pp03
retorno := ""
pp01    := val( substr( pp, 1, 1 ) )
pp02    := val( substr( pp, 2, 1 ) )
pp03    := val( substr( pp, 3, 1 ) )
if pp01 > 0
   retorno := cen[ PP01 ]
   if pp02 = 0 .and. pp03 = 0
      if pp01 = 1
         retorno := "Cem"
      endif
   endif
endif
if pp02 > 1
   retorno += if( empty( retorno ), '', ' e ' ) + dez[ PP02 ]
endif
if pp02 = 1
   retorno += if( empty( retorno ), '', ' e ' ) + uni[ 10 + PP03 ]
endif
if pp03 > 0 .and. pp02 # 1
   retorno += if( empty( retorno ), '', ' e ' ) + uni[ PP03 ]
endif
retu ( retorno )

*+ EOF: DISK51.PRG
