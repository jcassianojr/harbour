// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foao.prg
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
// :       FOAO.PRG: Transferir Ocorrencias para Folha
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/94     11:34
// :
// :*****************************************************************************



CABEX( 'Transferir Ocorrencias para Folha' )
IF !NETUSE( PES )   // AREDE(PES,PES,1)
RETU
ENDIF

IF !NETUSE( FOL )   // AREDE(FOL,FOL,0)
RETU
ENDIF

IF !NETUSE( "CONTAS" )  // AREDE("CONTAS","CONTAS",1)
RETU
ENDIF

IF !netuse( "fo_oco" )  // BREDE("FO_OCO",1)
RETU
ENDIF
FILTRO := 'CONTA#0'
FI     := Trim( FILTRO )
FILTRO := FILTRO( FI )
SET FILTER TO &FILTRO
XA := XB := XC := XD := XE := XF := 1
dbSelectAr( "FO_oco" )
dbGoTop()
WHILE !Eof()
DATAREF := IF( DATARETORN < DATAFIMPAG, DATARETORN, DATAFIMPAG )
FIM     := Month( DATAREF )
INI     := Month( DATASAIDA )
IF Year( DATAREF ) >= ANO
IF INI <= MES .AND. FIM >= MES
DIAS := VALE := SALH := SALM := VAR1 := 0
CTR  := NUMERO
CTAX := CONTA
IF INI = FIM
IF MES = FIM
DIAS := Day( DATAREF ) - Day( DATASAIDA ) + 1
ENDIF
ELSE
IF INI = MES .AND. FIM > MES
DATAI := '01/' + StrZero( INI + 1, 2 ) + '/' + StrZero( ANO, 4 )
DATAI := ( CToD( DATAI ) ) - 1
DIAS  := Day( DATAI ) - Day( DATASAIDA ) + 1
ENDIF
IF INI < MES .AND. FIM > MES
DATAI := '01/' + StrZero( MES + 1, 2 ) + '/' + StrZero( ANO, 4 )
DATAI := ( CToD( DATAI ) ) - 1
DIAS  := Day( DATAI )
ENDIF
IF INI < MES .AND. FIM = MES
DIAS := Day( DATAREF )
ENDIF
ENDIF
dbSelectAr( PES )
dbGoTop()
IF dbSeek( CTR )
SALHM()
VALE := DIAS * SALM / 30
dbSelectAr( "CONTAS" )
dbGoTop()
IF dbSeek( CTAX )
IF ACEITE # "S" .OR. ZUSER = "SUPERVISOR"
dbSelectAr( FOL )
GRAVA2( CTAX )
ELSE
ALERTX( "Inclus„o desta Conta Permitida Somente para o Supervisor" )
ENDIF
ELSE
ALERTX( "Conta N„o Cadastrada" )
ENDIF
ENDIF
ENDIF
ENDIF
dbSelectAr( "FO_oco" )
dbSkip()
ENDDO
dbCloseAll()
RETU

// : FIM: FOAO.PRG

// + EOF: foao.prg
// +
