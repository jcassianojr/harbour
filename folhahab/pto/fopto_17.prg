*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => J:\FOLHA\PTO\FOPTO_17.PRG
*+
*+
*+    Reformatted by Click! 2.03 on Dec-19-2002 at 10:11 am
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

CABE2( 'FOPTO_17 - Criando Arquivo de Reserva' )

ntipo:=PEGRELOGIO()

ARQREL := TARQREL( nTIPO, .F., "D" )
cDD    := TARQREL( nTIPO, .F. )
DCORTE := ZDATAINI
DCORTF := ZDATAFIM
MDS( 'Informe o Periodo' )
@ 24, 40 get DCORTE
@ 24, 50 get DCORTF
if ! READCUR()
   retu .f.
ENDIF

FO21CRI(cDD,"FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )

if ! NETUSE(ARQrel,,,,,.F.,)  
   retu
endif
if ! netuse(Cdd) 
   dbcloseall()
   retu .F.
endif

dbselectar( ARQREL )
initvars()
GRAPP := 1
GRAPT := lastrec()
GRAPT( 'AGUARDE ATUALIZANDO DADOS ' )
dbgotop()
while !eof()
   equvars()
   @ 24, 00 say NUMERO
   @ 24, 10 say DATA
   @ 24, 20 say HORA
   dbselectar( cDD )
   dbgotop()
   if ! dbseek( str( mNUMERO, 8 ) + DTOS( mDATA) + str( mHORA, 7, 2 ) )
      netrecapp()
      REPLVARS()
   endif
   dbselectar( ARQREL )
   GRAPS()
   dbskip()
enddo
dbcloseall()
retu .T.

*+ EOF: FOPTO_17.PRG
