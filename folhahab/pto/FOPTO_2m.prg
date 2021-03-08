////#INCLUDE "COMANDO.CH"



CABE2('FOPTO_2M - Ajuste SA/DO ')
mNUMERO:=0
mDATA:=DATE()
@ 24,00 GET mNUMERO  PICT "99999999"
@ 24,10 GET mDATA
IF ! READCUR()
   RETU
ENDIF
cPN := "PN" + ANOMESW
if ! netuse(cPN)
   dbcloseall()
   retu
endif
dbgotop()
if dbseek( str( mNUMERO, 8 ) + dtos(mDATA ) )
   if cod="SA" .OR. cod="DO"
      netreclock()
      field->COD:=""
      netrecunlcom()
   endif
else
   ALERTX("Data nao Encontrada")
endif
dbclosearea()