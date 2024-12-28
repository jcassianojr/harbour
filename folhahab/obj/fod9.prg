// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fod9.prg
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

// :*****************************************************************************
// :
// :       FOD9.PRG: Calcular o Tempo Tributado
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/94     11:51
// :
// :  Procs & Fncts: FOD9()
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :               : FOD7()             (fun‡„o    em FOD7.PRG)
// :               : TABIRRF            (processo  em FOD.PRG)
// :               : PETELA()           (fun‡„o    em FOLPROC.PRG)
// :               : VALCTA()           (fun‡„o    em FOLPROC.PRG)
// :               : GRAVA2()           (fun‡„o    em FOLPROC.PRG)
// :               : CALCDEPE()         (fun‡„o    em FOD.PRG)
// :               : CALCIRRF()         (fun‡„o    em FOD.PRG)
// :               : VALARRE()          (fun‡„o    em FOD.PRG)
// :               : FODZER             (processo  em FOLPROC.PRG)
// :
// :     Arq. dados: CONTAS
// :
// :         Indice:  CONTA      Por ordem de c¢digo
// :                             CODIGO
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************
#include "BOX.CH"

CABEX( 'Calcular o Premio Tributado' )
SetColor( "R/GR" )
hb_DispBox( 08, 00, 21, 79, B_DOUBLE + " " )
@ 10, 03 SAY 'Vocˆ s¢ poder  calcular o premio tributado ap¢s ter iniciado'
@ 12, 03 SAY 'o mˆs, caso vocˆ j  tenha iniciado o mˆs  digite  S  para  o'
@ 14, 03 SAY 'para o cumputador iniciar os c lculos, caso vocˆ  n„o  tenha'
@ 16, 03 SAY 'iniciado o mˆs digite N, e inicie o mˆs'
SET COLOR TO
IF !MDG( 'Deseja continuar' )
IF MDG( 'Deseja Inciar Agora o Mˆs' )
FOD7()
ELSE
RETU
ENDIF
ENDIF
ARREDONDA := 0
MDS( 'DIGITE ARREDONDAMENTO = ' )
@ 24, 57 GET ARREDONDA PICT '###,###.##'
READCUR()

MDS( 'Carregando Tabela do IRRF' )
QTDEIRRF   := VDEPENDE := DESC_MINIMO := SALFAMILIA := IRRF1 := IRTX1 := IRPA1 := 0
TETOFAMIL  := SALFAMIL1 := 0
IRRF2      := IRTX2 := IRPA2 := IRRF3 := IRTX3 := IRPA3 := IRRF4 := IRTX4 := IRPA4 := 0
IRRF5      := IRTX5 := IRPA5 := IRRF6 := IRTX6 := IRPA6 := IRRF7 := IRTX7 := IRPA7 := 0
ARREIRRF   := DESPIRRF := 'N'
XA         := XB := XC := XD := XE := XF := 1
mFATORIRRF := mFATORIRR2 := 0
TABIRRF()

IF !netuse( pes )   // AREDE(PES,PES,0)
RETU
ENDIF
FILTRO := FILTRO( 'EMPTY(DEMITIDO)' )
SET FILTER TO &FILTRO

IF !netuse( fol )   // AREDE(FOL,FOL,0)
RETU
ENDIF

IF !netuse( "contas" )  // AREDE("CONTAS","CONTAS",0)
RETU
ENDIF
@ 07, 00 CLEA
dbSelectAr( pes )
dbGoTop()
WHILE !Eof()
PETELA( 7 )
CTR := NUMERO
DEP := FOSFAMQTDE( CTR )
VEN := VAL2 := VBIP := VALE := VAL4 := VAL := VALINSS := 0
dbSelectAr( fol )
VEN := VALCTA( CTR, 170 )
IF VEN # 0
dbSelectAr( fol )
VAL2    := VALCTA( CTR, 402 )
VALINSS := VALCTA( CTR, 493 )
VBIP    := VAL2 + VEN
VALE    := VBIP
GRAVA2( 409 )
VALE := CALCDEPE()
GRAVA2( 417 )
GRAVA2( 430 )
BASE := VBIP - VAL4 - VALINSS
IR3  := DESCIR := VALDESCIR := 0
CALCIRRF()
dbSelectAr( fol )
VAL  := VALCTA( CTR, 492 )
DES  := VALDESCIR - VAL
DES  := IF( DES > 0, DES, 0 )
VALE := VALE + VAL
GRAVA2( 494 )
VEN  := VEN + IF( ARREDONDA # 0, VALARRE( ARREDONDA ), 0 )
VALE := VEN
GRAVA2( 445 )
VALE := VEN - DES
GRAVA2( 44 )
VALE := DES
GRAVA2( 527 )
ENDIF
dbSelectAr( pes )
dbSkip()
ENDDO
dbSelectAr( fol )
FODZER()
dbCloseAll()
RETU
// : FIM: FOD9.PRG

// + EOF: fod9.prg
// +
