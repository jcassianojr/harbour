*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_27.PRG
*+
*+    Reformatted by Click! 2.03 on Jun-25-2003 at  5:17 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

CABE2( 'FOPTO_27 - Marcar um dia com um cўdigo' )
dINI := zdataini
dFIM := zdatafim
mCOD := "  "
mRED := " "
mBCO := " "
mFOL := " "
mEXT := " "
mSOD := "  "
mALM := " "
mZER := "N"
@ 18, 00 say 'Digite o Periodo para marca‡„o'
@ 19, 00 say 'Digite o Cўdigo/Sub para marca‡„o'
@ 19, 50 say 'Zerar'
@ 20, 00 say 'Redu‡ao Horario  SN'
@ 21, 00 say 'Banco de Horas   SNF'
@ 22, 00 say 'Folga Indicada   SNV'
@ 23, 00 say 'Hora Extra       SNVTZ'
@ 24, 00 say 'Almoco           ABCDESN'
@ 18, 40 get dINI
@ 18, 50 get dFIM
@ 19, 40 get mCOD
@ 19, 43 get mSOD
@ 19, 55 get mZER pict "!"   valid mZER $ "SN "
@ 20, 40 get mRED pict "!"   valid mRED $ "SN "
@ 21, 40 get mBCO pict "!"   valid mBCO $ "SNF "
@ 22, 40 get mFOL pict "!"   valid mFOL $ "SNVM "
@ 23, 40 get mEXT pict "!"   valid mEXT $ "SNVTZ "
@ 24, 40 get mALM pict "!"   valid mALM $ "ABCDESN "
if !READCUR()
   retu .F.
endif

cPN := "PN" + ANOMESW  

MDS( 'Aguarde Fazendo as substitui‡”es' )

if ! NETUSE(PES)
   retu
endif
FILTRO := FILTRO( "EMPTY(DEMITIDO)" )
set filter to &FILTRO
if ! NETUSE(cPN) 
   DBCLOSEALL()
   retu
endif

dbselectar( PES )
dbgotop()
while !eof()
   PETELA( 8 )
   mNUMERO := NUMERO
   fopto2h( if( mZER = "S", .T., .F. ) )
   dbselectar( PES )
   dbskip()
enddo
dbcloseall()
return .T.

*+ EOF: FOPTO_27.PRG
