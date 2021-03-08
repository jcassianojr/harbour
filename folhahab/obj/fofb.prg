*:*****************************************************************************
*:
*:       FOFB.PRG: Cadastro de Mensagens nos Holleriths
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1999,  SOFTEC  S/C Ltda.
*:  Atualizado em: 10/03/99
*:
*:*****************************************************************************

#INCLUDE "BOX.CH"

PADRAO("MESHOL","MESHOL","' '+mNOME+' '+LEFT(mMES1,50)","mNOME","Cadastro de Mensagens","Nome Mensagem",;
       {|| PEGCHAVE("mNOME",SPACE(6),"Codigo:")},{|| MESHOLT()},{|| MESHOLG()},{|| FO_FOR("GRUPO='MESHOL'")})
RETU .T.


FUNC MESHOLG
@ 11, 26 GET mNOME
@ 14, 26 GET mMES1
@ 16, 26 GET mMES2
@ 18, 26 GET mMES3
READCUR()
RETU .T.


FUNC MESHOLT
HB_dispbox( 8, 0, 20, 78,B_DOUBLE+" ")
@ 11,13 SAY "Mensagem  "+CHR(16)+SPAC(10)+CHR(17)
@ 14,13 SAY "1  Linha "+CHR(26)
@ 16,13 SAY "2  Linha "+CHR(26)
@ 18,13 SAY "3  Linha "+CHR(26)
@ 08,00 SAY " - "
@ 08,03 SAY SPAC(23)+"Mensagens  Para  Holleriths"+SPAC(26)
hb_scroll(09,79,21,79)
@ 21,01 SAY SPAC(78)
RETU .T.

*: FIM: FOFB.PRG
