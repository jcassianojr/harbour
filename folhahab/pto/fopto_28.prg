*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_28.PRG
*+
*+    Reformatted by Click! 2.03 on Jun-25-2003 at  5:17 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

CABE2( 'FOPTO_28 - Pre Lan‡amento Valor' )
dINI  :=zdataini
dFIM := zdatafim
nCTA   := 0
nVALOR := 0
MDS( 'Digite o Periodo ' )
@ 24, 40 get dINI
@ 24, 50 get dFIM
if !READCUR()
   retu .F.
endif
MDS( 'Digite a Conta e o Valor' )
@ 24, 40 get nCTA   pict "99"
@ 24, 50 get nVALOR pict "999.99"
if !READCUR()
   retu .F.
endif
if nCTA < 1 .or. nCTA > 17
   retu .F.
endif
if nVALOR = 0
   if !MDG( "Marcar com valor 0" )
      retu .F.
   endif
endif
cCTA := "CTA" + strzero( nCTA, 2 )
cPN  := "PN" + ANOMESW 

if ! NETUSE(PES) 
   retu
endif
FILTRO := FILTRO( "EMPTY(DEMITIDO)" )
set filter to &FILTRO

if ! netuse(cPN) 
   dbcloseall()
   retu
endif
dbselectar(pes)
dbgotop()
while !eof()
   PETELA( 8 )
   NUM := NUMERO
   dbselectar(cPN)
   BUSCA := str( NUM, 8 ) + dtos( dINI )
   dbgotop()
   if dbseek( BUSCA )
      while DATA >= dINI .and. DATA <= dFIM .and. !eof()
         netreclock()
         field->&cCTA. := nVALOR
         dbunlock()
         dbskip()
      enddo
   endif
   dbselectar(pes)
   dbskip()
enddo
dbcloseall()
return .F.

*+ EOF: FOPTO_28.PRG
