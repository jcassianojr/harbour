*****************************************************************
FUNCTION ENCODE (in_string)
*****************************************************************
# define ADJVAL  30

LOCAL counter := in_len := 0, next_char := out_string := ''

IF in_string != NIL

    * Ajusta a cadeia especificada e converte as letras em maiusculas.
    in_string := ALLTRIM(UPPER(in_string))
    in_len := LEN(in_string)

    * Inverte a cadeia, inclui 30 em cada caracter e o duplica.
    FOR counter = 1 TO in_len

         * Obtem os caracteres na ordem inversa.
         next_char = SUBSTR(in_string, counter * -1, 1)

         * Inclui o caracter na cadeia de retorno, se for numerico,
         * alfabetico, espaco, ou caracter de sublinhado.

         IF next_char == '.'.OR. next_char == '_'.OR. ;
            ISDIGIT(next_char) .OR. ISALPHA(next_char)
             out_string := out_string + ;
                           CHR((ASC(next_char) + ADJVAL) * 2)
         ENDIF
    NEXT
ENDIF

RETURN out_string

*****************************************************************
FUNCTION ENCODE (in_string)
*****************************************************************
FUNCTION DECODE (in_string)
# define ADJVAL  30
LOCAL counter := in_len := 0, out_string := ''
IF in_string != NIL

    * Ajusta a cadeia especificada.
    in_string := ALLTRIM(in_string)
    in_len := LEN(in_string)

    * Obtem o valor ASCII de cada posicao e recupera o valor original.
    FOR counter = 1 TO in_len
         out_string := out_string +  ;
         CHR((ASC(SUBSTR(in_string, counter * -1, 1)) /2) - ADJVAL)
    NEXT

ENDIF

RETURN out_string
