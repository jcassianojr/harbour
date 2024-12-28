// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foresrg.prg
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
// +    Documentado em 27-Dez-2024 as  9:41 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :   FORESRG.PRG :
// :     Linguagem : Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/26/94      8:53
// :
// :  Procs & Fncts: FORESRG()
// :
// :     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
// :*****************************************************************************



MDS( 'Preencha os dados referente a este per¡odo aquisitivo' )
netreclock()
@ 11, 30 GET DATFERIASF
@ 12, 19 GET SALVAR     PICT "###,###,###.##"
@ 12, 58 GET PROGRAMA
@ 12, 69 GET PROGRAMA1
READCUR()
@ 14, 16 GET FA01
@ 14, 25 GET FA02
@ 14, 34 GET FA03
@ 14, 43 GET FA04
@ 14, 52 GET FA05
@ 14, 61 GET FA06
@ 15, 07 GET FA07
@ 15, 16 GET FA08
@ 15, 25 GET FA09
@ 15, 34 GET FA10
@ 15, 43 GET FA11
@ 15, 52 GET FA12
@ 15, 61 GET FA13
READCUR()
TOTFAL := FA01 + FA02 + FA03 + FA04 + FA05 + FA06 + FA07 + FA08 + FA09 + FA10 + FA11 + FA12 + FA13
JUZ    := 30
DO CASE
CASE TOTFAL >= 6 .AND. TOTFAL < 15
JUZ := 24
CASE TOTFAL >= 15 .AND. TOTFAL < 24
JUZ := 18
CASE TOTFAL >= 24 .AND. TOTFAL < 33
JUZ := 12
CASE TOTFAL >= 33
JUZ := 0
ENDCASE
FO_FER->FALTAS  := TOTFAL
FO_FER->DIASJUS := JUZ
WHILE .T.
@ 14, 75 SAY FALTAS
@ 15, 76 SAY DIASJUS
@ 17, 23 GET GOZOU1DE
@ 17, 34 GET GOZOU1ATE VALID ( GOZOU1ATE >= GOZOU1DE .AND. GOZOU1ATE - GOZOU1DE <= DIASJUS )
IF !READCUR()
ALERTX( "Vocˆ digitou ESC, Confirme os Dados" )
LOOP
ENDIF
IF GOZOU1ATE >= GOZOU1DE .AND. GOZOU1ATE - GOZOU1DE <= DIASJUS
EXIT
ENDIF
ALERTX( "Verifique as Datas" )
ENDDO
PAGO             := IF( ( Day( GOZOU1DE ) <> 0 .AND. Day( GOZOU1ATE ) <> 0 ), GOZOU1ATE - GOZOU1DE + 1, 0 )
FO_FER->DIASPAGO := PAGO
GOZA             := DIASJUS - DIASPAGO
FO_FER->DIASGOZA := GOZA
@ 17, 56 SAY DIASPAGO
@ 17, 74 SAY DIASGOZA
IF Month( GOZOU1ATE ) # Month( GOZOU1DE )
DATAI             := DToC( GOZOU1ATE )
DATAI             := '01' + SubStr( DATAI, 3 )
DATAI             := CToD( DATAI )
FO_FER->COMPDATAI := DATAI
FO_FER->COMPDATAF := GOZOU1ATE
ELSE
FO_FER->COMPDATAI := CToD( '00/00/00' )
FO_FER->COMPDATAF := CToD( '00/00/00' )
ENDIF
@ 19, 23 GET ABONO1DE
@ 19, 34 GET ABONO1ATE VALID ( ABONO1ATE >= ABONO1DE .AND. ABONO1ATE - ABONO1DE <= DIASGOZA )
READCUR()
IF Month( ABONO1ATE ) # Month( ABONO1DE )
DATAI            := DToC( ABONO1ATE )
DATAI            := '01' + SubStr( DATAI, 3 )
DATAI            := CToD( DATAI )
FO_FER->COMPABOI := DATAI
FO_FER->COMPABOF := ABONO1ATE
ELSE
FO_FER->COMPABOI := CToD( '00/00/00' )
FO_FER->COMPABOF := CToD( '00/00/00' )
ENDIF
PAGO2             := IF( ( Day( ABONO1DE ) <> 0 .AND. Day( ABONO1ATE ) <> 0 ), ABONO1ATE - ABONO1DE + 1, 0 )
FO_FER->DIASPAGO2 := PAGO2
GOZA2             := DIASJUS - PAGO - PAGO2
FO_FER->DIASGOZA2 := GOZA2
@ 19, 56 SAY DIASPAGO2
@ 19, 74 SAY DIASGOZA2
@ 20, 23 GET GOZOU2DE
@ 20, 34 GET GOZOU2ATE VALID ( GOZOU2ATE >= GOZOU2DE .AND. GOZOU2ATE - GOZOU2DE <= DIASGOZA2 )
READCUR()
PAGO3             := IF( ( Day( GOZOU2DE ) <> 0 .AND. Day( GOZOU2ATE ) <> 0 ), GOZOU2ATE - GOZOU2DE + 1, 0 )
FO_FER->DIASPAGO3 := PAGO3
GOZA3             := DIASJUS - PAGO - PAGO2 - PAGO3
FO_FER->DIASGOZA3 := GOZA3
@ 20, 56 SAY DIASPAGO3
@ 20, 74 SAY DIASGOZA3
IF Month( ABONO1DE ) # 0
IF Month( ABONO1DE ) < Month( GOZOU1DE ) .AND. Empty( COMPDATAI )
FO_FER->COMPDATAI := GOZOU1DE
FO_FER->COMPDATAF := GOZOU1ATE
ENDIF
IF Month( ABONO1DE ) > Month( GOZOU1DE ) .AND. Empty( COMPABOI )
FO_FER->COMPABOI := ABONO1DE
FO_FER->COMPABOF := ABONO1ATE
ENDIF
IF Month( ABONO1DE ) = 01 .AND. Month( GOZOU1DE ) = 12 .AND. Empty( COMPABOI )
FO_FER->COMPABOI := ABONO1DE
FO_FER->COMPABOF := ABONO1ATE
ENDIF
ENDIF
@ 18, 23 SAY COMPDATAI
@ 18, 34 SAY COMPDATAF
@ 18, 55 SAY COMPABOI
@ 18, 66 SAY COMPABOF
FO_FER->BAIXADO := IF( MDG( 'Baixar Este Per¡odo Aquisitivo' ), 'S', 'N' )
dbUnlock()
RETU
// : FIM: FORESRG.PRG

// + EOF: foresrg.prg
// +
