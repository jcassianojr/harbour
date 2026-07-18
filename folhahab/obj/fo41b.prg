// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo41b.prg
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
// +    Documentado em 27-Dez-2024 as  9:44 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :      FO41B.PRG: Calculo de Sal rio M‚dio Indexado
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/07/94     14:47
// :
// :  Procs & Fncts: FO41B()
// :
// :          Chama: CLSROW()           (fun‡„o    em ?)
// :               : RFILORD()          (fun‡„o    em FOLPROC.PRG)
// :               : PETELA()           (fun‡„o    em FOLPROC.PRG)
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************




// Include de Trabalho
// //#INCLUDE "COMANDO.CH"
#include "BOX.CH"

// Inicializando Variaveis
FAT011 := FAT012 := FAT021 := FAT022 := FAT031 := FAT032 := FAT041 := FAT042 := 0.000000
FAT051 := FAT052 := FAT061 := FAT062 := FAT071 := FAT072 := FAT081 := FAT082 := 0.000000
FAT091 := FAT092 := FAT101 := FAT102 := FAT111 := FAT112 := FAT121 := FAT122 := 0.000000
FATP01 := FATP02 := 0.00
MESGRA := 0
FATGRA := 0.000000

// Desenha a Tela
SetColor( '+W/B' )
hb_DispBox( 6, 0, 23, 79, B_DOUBLE + " " )
@  8, 0  SAY 'Ç'
@  8, 79 SAY '¶'
@ 23, 55 SAY "Ï"
SetColor( '+GR/B' )
@  7, 23 SAY "Calculo de Sal rio M‚dio Indexado"
@  8, 1  SAY Replicate( '-', 54 ) + "-" + Replicate( '-', 23 )
@  9, 16 SAY "1o. Pagamento :" + SPAC( 8 ) + "2o. Pagamento : Ý  Gravar no Mˆs de"
@ 10, 2  SAY "Percentual" + SPAC( 43 ) + "Ý"
@ 11, 2  SAY "Janeiro" + SPAC( 46 ) + "Ý"
@ 12, 2  SAY "Fevereiro" + SPAC( 44 ) + "Ý"
@ 13, 2  SAY "Mar‡o" + SPAC( 48 ) + "Ý"
@ 14, 2  SAY "Abril" + SPAC( 48 ) + "Ý"
@ 15, 2  SAY "Maio" + SPAC( 49 ) + "Ý"
@ 16, 2  SAY "Junho" + SPAC( 48 ) + "Ý Fator Atualiza‡„o "
@ 17, 2  SAY "Julho" + SPAC( 48 ) + "Ý"
@ 18, 2  SAY "Agosto" + SPAC( 47 ) + "Ý"
@ 19, 2  SAY "Setembro" + SPAC( 45 ) + "Ý"
@ 20, 2  SAY "Outubro" + SPAC( 46 ) + "Ý"
@ 21, 2  SAY "Novembro" + SPAC( 45 ) + "Ý"
@ 22, 2  SAY "Dezembro" + SPAC( 45 ) + "Ý"
SetColor( '+W/RB' )
// Get nas Menvars
@ 10, 21 GET FATP01 PICT "###.##"
@ 10, 39 GET FATP02 PICT "###.##"
@ 11, 18 GET FAT011 PICT "#######.######"
@ 11, 39 GET FAT012 PICT "#######.######"
@ 12, 18 GET FAT021 PICT "#######.######"
@ 12, 39 GET FAT022 PICT "#######.######"
@ 13, 18 GET FAT031 PICT "#######.######"
@ 13, 39 GET FAT032 PICT "#######.######"
@ 14, 18 GET FAT041 PICT "#######.######"
@ 14, 39 GET FAT042 PICT "#######.######"
@ 15, 18 GET FAT051 PICT "#######.######"
@ 15, 39 GET FAT052 PICT "#######.######"
@ 16, 18 GET FAT061 PICT "#######.######"
@ 16, 39 GET FAT062 PICT "#######.######"
@ 17, 18 GET FAT071 PICT "#######.######"
@ 17, 39 GET FAT072 PICT "#######.######"
@ 18, 18 GET FAT081 PICT "#######.######"
@ 18, 39 GET FAT082 PICT "#######.######"
@ 19, 18 GET FAT091 PICT "#######.######"
@ 19, 39 GET FAT092 PICT "#######.######"
@ 20, 18 GET FAT101 PICT "#######.######"
@ 20, 39 GET FAT102 PICT "#######.######"
@ 21, 18 GET FAT111 PICT "#######.######"
@ 21, 39 GET FAT112 PICT "#######.######"
@ 22, 18 GET FAT121 PICT "#######.######"
@ 22, 39 GET FAT122 PICT "#######.######"
@ 11, 65 GET MESGRA PICT "##"
@ 18, 60 GET FATGRA PICT "#######.######"
READCUR()

// Confirmacao dos Dados
IF MESGRA < 1 .OR. MESGRA > 12
MDT( "Erro no mˆs de destino" )
RETU .F.
ENDIF
@ 13, 61 SAY PadC( MMES( MESGRA ), 15 )
IF !MDG( "Tudo Ok. posso Calcular" )
RETU .F.
ENDIF
IF !MDG( "Voce Realmente tem certeza" )
RETU .F.
ENDIF

// Montando Variaves de Referencia
MED := 'SAL' + SubStr( MMES( MESGRA ), 1, 3 )
FAT := { { FAT011, FAT012 }, { FAT021, FAT022 }, { FAT031, FAT032 }, { FAT041, FAT042 }, ;
      { FAT051, FAT052 }, { FAT061, FAT062 }, { FAT071, FAT072 }, { FAT081, FAT082 }, ;
      { FAT091, FAT092 }, { FAT101, FAT102 }, { FAT111, FAT112 }, { FAT121, FAT122 } }

// Iniciando Calculo
CLSROW( 6 )
aRETU  := RFILORD( "PES", .F., FILTRO )
INX    := aRETU[ 1 ]
FILTRO := aRETU[ 2 ]
IF !netuse( pes )   // AREDE(PES,PES,0)
RETU .F.
ENDIF
SET FILTER TO &FILTRO
dbGoTop()
WHILE !Eof()
SALBASE := SALP01 := SALP02 := 0.00
MEDIA   := SOMA := 0.000000
MESDIV  := 0
PETELA( 8 )
FOR X := 1 TO 12
IF FAT[ X,  1 ] > 0 .OR. FAT[ X,  2 ] > 0
XSAL    := 'SAL' + SubStr( MMES( X ), 1, 3 )
SALBASE := &XSAL
MESDIV++
IF FAT[ X,  1 ] > 0
SALP01 := IF( FATP01 # 0 .AND. SALBASE > 0, SALBASE * FATP01 / 100, 0 )
SOMA   += IF( SALP01 > 0 .AND. FAT[ X, 1 ] > 0, SALP01 / FAT[ X, 1 ], 0 )
ENDIF
IF FAT[ X,  2 ] > 0
SALP02 := IF( FATP02 # 0 .AND. SALBASE > 0, SALBASE * FATP02 / 100, 0 )
SOMA   += IF( SALP02 > 0 .AND. FAT[ X, 2 ] > 0, SALP02 / FAT[ X, 2 ], 0 )
ENDIF
ENDIF
NEXT X
IF SOMA > 0 .AND. MESDIV > 0
MEDIA := SOMA / MESDIV
IF FATGRA # 0
MEDIA *= FATGRA
ENDIF
ENDIF
IF MEDIA > 0
netreclock()
FIELD->&MED. := Round( MEDIA, 2 )
dbUnlock()
ENDIF
dbSkip()
ENDDO
SetColor( "W/N,N/W" )
dbCloseAll()

// : FIM: FO41B.PRG

// + EOF: fo41b.prg
// +
