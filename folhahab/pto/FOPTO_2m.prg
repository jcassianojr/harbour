// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : FOPTO_2m.prg
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
// +    Documentado em 27-Dez-2024 as  9:32 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// //#INCLUDE "COMANDO.CH"



CABE2( 'FOPTO_2M - Ajuste SA/DO ' )
mNUMERO := 0
mDATA   := Date()
@ 24, 00 GET mNUMERO PICT "99999999"
@ 24, 10 GET mDATA
IF !READCUR()
RETU
ENDIF
cPN := "PN" + ANOMESW
IF !netuse( cPN )
dbCloseAll()
RETU
ENDIF
dbGoTop()
IF dbSeek( Str( mNUMERO, 8 ) + DToS( mDATA ) )
IF cod = "SA" .OR. cod = "DO"
netreclock()
field->COD := ""
netrecunlcom()
ENDIF
ELSE
ALERTX( "Data nao Encontrada" )
ENDIF
dbCloseArea()

// + EOF: FOPTO_2m.prg
// +
