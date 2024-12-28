// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foat.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

#include "BOX.CH"

SET COLOR TO + W / B
hb_DispBox( 9, 0, 13, 79, B_DOUBLE + " " )
@  9, 10 SAY "Â" + repl( 'Ä', 37 ) + "Â"
@ 13, 10 SAY "Á" + repl( 'Ä', 37 ) + "Á"
@ 10, 2  SAY "C¢digo  ³ Descri‡„o" + spac( 27 ) + "³ Valor de Cada Passe"
@ 11, 0  SAY 'Ã' + repl( 'Ä', 9 ) + "Å" + repl( 'Ä', 37 ) + "Å" + repl( 'Ä', 30 ) + '´'
@ 12, 10 SAY "³" + spac( 37 ) + "³"
@ 12, 03 SAY CODIGO                                                 PICT '####'
@ 12, 12 SAY DESCR
@ 12, 50 SAY VALOR                                                  PICTURE "###,###.##"
SET COLO TO
RETU


// + EOF: foat.prg
// +
