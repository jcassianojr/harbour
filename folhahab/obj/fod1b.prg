// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fod1b.prg
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
// :       FOD1.PRG: Calculando adiantamento salarial
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/25/94     11:45
// :
// :  Procs & Fncts: FOD1B()
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :               : TABIRRF            (processo  em FOD.PRG)
// :               : PETELA()           (fun‡„o    em FOLPROC.PRG)
// :               : SALHM()            (fun‡„o    em FOLPROC.PRG)
// :               : VALCTA()           (fun‡„o    em FOLPROC.PRG)
// :               : GRAVA2()           (fun‡„o    em FOLPROC.PRG)
// :               : CALCDEPE()         (fun‡„o    em FOD.PRG)
// :               : CALCIRRF()         (fun‡„o    em FOD.PRG)
// :               : VALARRE()          (fun‡„o    em FOD.PRG)
// :               : FODZER             (processo  em FOLPROC.PRG)
// :
// :     Arq. Dados: CONTAS - Cadastro de Vencimentos e Descontos
// :
// :        Indices: CONTA      Por ordem de c¢digo
// :                            CODIGO
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************


CABEX( 'Calculando adiantamento salarial' )
IF !MDG( 'Deseja Continuar' )
RETU
ENDIF

CC := IF( MDG( 'Deseja Confirmar os valores' ), 1, 0 )

IF RECOIRRF # 'S'
MDS( 'Aguarde Carregando Tabela de IRRF' )
QTDEIRRF   := VDEPENDE := DESC_MINIMO := SALFAMILIA := IRRF1 := IRTX1 := IRPA1 := 0
TETOFAMIL  := SALFAMIL1 := 0
IRRF2      := IRTX2 := IRPA2 := IRRF3 := IRTX3 := IRPA3 := IRRF4 := IRTX4 := IRPA4 := 0
IRRF5      := IRTX5 := IRPA5 := IRRF6 := IRTX6 := IRPA6 := IRRF7 := IRTX7 := IRPA7 := 0
mFATORIRRF := mFATORIRR2 := 0
ARREIRRF   := DESPIRRF := 'N'
TABIRRF()
ENDIF

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

dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
PETELA( 7 )
MDS( 'Calculando o Vale' )
CTR  := NUMERO
DEP  := FOSFAMQTDE( CTR )
SALH := SALM := VEN := DES := VAL4 := 0
SALHM()
VEN := IF( TIPO = '1' .OR. TIPO = 'M', SALM * VAR0, SALH * VAR0 * MESHORA )
VEN := IF( EXCVALE = "S", 0, VEN )
IF EXCVALE = "P"
VEN := IF( TIPO = '1' .OR. TIPO = 'M', SALM * VALEHORA / 30, SALH * VALEHORA / MESHORA )
IF VEN > IF( TIPO = '1' .OR. TIPO = 'M', SALM * VAR0, SALH * VAR0 * MESHORA ) + .01
IF ZUSER <> "SUPERVISOR"
ALERTX( "Adiantamento maior que o fator permitido para o SUPERVISOR" )
VEN := IF( TIPO = '1' .OR. TIPO = 'M', SALM * VAR0, SALH * VAR0 * MESHORA )
ENDIF
ENDIF
ENDIF
VEN := Round( VEN, 2 )
@ 17, 3  SAY 'C lculos do Micro =>'
@ 17, 37 SAY VEN                    PICT '###,###,###.##'
IF CC = 1
WHILE .T.
@ 20, 37 GET VEN PICT '###,###,###.##'
READCUR()
IF VEN > IF( TIPO = '1' .OR. TIPO = 'M', SALM * VAR0, SALH * VAR0 * MESHORA ) + .01
IF ZUSER <> "SUPERVISOR"  // So troca Senha
ALERTX( "Adiantamento maior que o fator permitido para o SUPERVISOR" )
LOOP
ENDIF
ENDIF
EXIT
ENDDO
ENDIF
dbSelectAr( FOL )
VXX9 := VALCTA( CTR, 442 )
IF RECOIRRF # 'S'
MDS( 'Calculando IRRF' )
VXX1 := VALCTA( CTR, 445 )
VXX2 := VALCTA( CTR, 527 )
VXX3 := VALCTA( CTR, 402 )
VXX4 := VALCTA( CTR, 493 )
VXX5 := VALCTA( CTR, 515 )
VXX6 := VALCTA( CTR, 516 )
VXX7 := VALCTA( CTR, 492 )
VXX8 := VALCTA( CTR, 415 )
VAL3 := VEN + VXX3 + VXX1
VALE := VAL3
GRAVA2( 403 )
VALE := CALCDEPE()
GRAVA2( 417 )
DEDUCAO := VAL4 + VXX4 + VXX5 + VXX6 + VXX8 + VXX9
VALE    := DEDUCAO
GRAVA2( 430 )
BASE := VAL3 - DEDUCAO
IR3  := DESCIR := VALDESCIR := 0
CALCIRRF()
DES  := VALDESCIR - VXX7 - VXX2
VALE := DES + VXX7 + VXX2
GRAVA2( 494 )
ENDIF
VALE := IF( ARREDONDA # 0, VALARRE( ARREDONDA ), 0 )
GRAVA2( 997 )
VALE := VEN
GRAVA2( 41 )
// Verifica se o vale n„o ‚ negativo
DES  := IF( DES > 0, DES, 0 )
VALE := DES
GRAVA2( 501 )
VALE := VEN - DES - VXX9
GRAVA2( 441 )
dbSelectAr( PES )
dbSkip()
ENDD
dbSelectAr( FOL )
FODZER()
dbCloseAll()
RETU

// : FIM: FOD1B.PRG

// + EOF: fod1b.prg
// +
