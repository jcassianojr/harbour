/*  $DOC$
 *  $TEMPLATE$
 *      Function
 *  $NAME$
 *      DECODE()
 *  $SYNTAX$
 *      DECODE( in_string )
 *  $ARGUMENTS$
 *      <in_string>
 *  $DESCRIPTION$
 *      descriptografa um string
 *  $END$
*/
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
