*****************************************************************
FUNCTION ENCODE (in_string)
*****************************************************************

* Codifica a cadeia informada. Ignora os caracteres nao-alfanumericos.

* Copyright(c) 1991 -- James Occhiogrosso

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