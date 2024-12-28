// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fod2cre.prg
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
// :    FOD2CRE.PRG: Calcular os Vencimentos da Folha de Pagamento
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/94     11:46
// :
// :  Procs & Fncts: FOD2CRE()
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :               : PETELA()           (fun‡„o    em FOLPROC.PRG)
// :               : SALHM()            (fun‡„o    em FOLPROC.PRG)
// :               : GRAVA2()           (fun‡„o    em FOLPROC.PRG)
// :
// :     Arq. Total: CONTAS - Cadastro de Vencimentos e Descontos
// :
// :        Indices: CONTA    Por ordem de c¢digo
// :                          CODIGO
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************



CABEX( 'Calculando Folha de Pagamento' )
IF !NETUSE( PES )   // AREDE(PES,PES,0)
RETU
ENDIF
SET FILTER TO &FILTRO

IF nFOLTIP = 1
IF !NETUSE( FOL )  // AREDE(FOL,FOL,0)
RETU
ENDIF
ELSE
IF !NETUSE( "FO_COMP" )  // AREDE("FO_COMP","FO_COMP",0)
RETU
ENDIF
ENDIF
cSELE2 := Alias()

IF !NETUSE( "CONTAS" )  // AREDE("CONTAS","CONTAS",0)
RETU
ENDIF
dbSelectAr( cSELE2 )
dbGoTop()
WHILE !Eof()
CTR := NUMERO
dbSelectAr( PES )
dbGoTop()
IF dbSeek( CTR )
PETELA( 7 )
VALE1 := VALDSR := VALVENC := VALFER := VALPVENC := SALM := SALH := VALPROD := 0.00
SALHM()
dbSelectAr( cSELE2 )
MDS( "Calculando dados fornecidos " )
WHILE NUMERO = CTR
IF TIPO <> 0
DO CASE
CASE TIPO = 1
STORE( HORAS * SALH ) TO VALE1
IF FATOR <> 0.00
VALE1 := VALE1 * FATOR
ENDIF
CASE TIPO = 2
STORE( VALORBASE ) TO VALE1
CASE TIPO = 3
STORE( HORAS * VALORBASE ) TO VALE1
IF FATOR <> 0.00
VALE1 := VALE1 * FATOR
ENDIF
CASE TIPO = 4
VALE1 := Round( SALM * HORAS / 30, 2 )
VALE1 := IF( FATOR # 0, Round( VALE1 * FATOR, 2 ), VALE1 )
ENDCASE
REPL VALOR WITH VALE1
ENDIF
IF CONTA = 520
REPL VALOR WITH HORAS * ALMOCO
ENDIF
IF CONTA > 19 .AND. CONTA < 40
VALDSR := VALOR + VALDSR
ENDIF
IF CONTA > 9 .AND. CONTA < 17
VALDSR := VALOR + VALDSR
ENDIF
IF PROD
MDS( 'Verificando Produtividade' )
BUSCA := CONTA
dbSelectAr( "CONTAS" )
dbGoTop()
IF dbSeek( BUSCA )
IF GRAT = 0
dbSelectAr( cSELE2 )
VALPROD := VALPROD + VALOR
ENDIF
ENDIF
dbSelectAr( cSELE2 )
ENDIF
dbSelectAr( cSELE2 )
dbSkip()
ENDDO
REG   := RecNo()
VALEX := 0.00
MDS( "ADICIONAIS DAS HORAS EXTRAS  " )
STORE( ( VALDSR / ( 30 - DOMINGO ) ) * DOMINGO ) TO VALEX
VALE := VALEX
dbSelectAr( fol )
GRAVA2( 6 )
VALE := VALPROD
dbSelectAr( fol )
GRAVA2( 397 )
dbGoto( REG )
ELSE
dbSelectAr( cSELE2 )
WHILE NUMERO = CTR .AND. !Eof()
dbSkip()
ENDDO
ENDIF
dbSelectAr( cSELE2 )
ENDDO
dbCloseAll()
RETU

// : FIM: FOD2CRE.PRG

// + EOF: fod2cre.prg
// +
