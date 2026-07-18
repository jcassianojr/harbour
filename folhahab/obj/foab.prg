// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foab.prg
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
// :       FOAB.PRG: Lan‡amento Automatico Pre Programado
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/25/94     11:32
// :
// :  Procs & Fncts: FOAB()
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :               : PETELA()           (fun‡„o    em FOLPROC.PRG)
// :               : GRAVA2()           (fun‡„o    em FOLPROC.PRG)
// :
// :     Arq. Dados: FO_PFE - Folha de F‚rias
// :                 FO_RSS - Folha de Rescis„o
// :                 FO_COMP - Folha Complementar
// :                 CONTAS - Cadastro de Vencimentos e Descontos
// :
// :        Indices: RSS    Codigo de Trabalho
// :                        CONTROLE
// :                 CONTA  Por ordem de c¢digo
// :                        CODIGO
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************



CABEX( "Lan‡amento Automatico Pre Programado" )
PARA CC
XA := XB := XC := XD := XE := XF := 0

IF !NETUSE( "FO_LAN" )  // BREDE("FO_LAN",0)
RETU .F.
ENDIF

IF !ARQUSAR( CC )
dbCloseAll()
RETU .F.
ENDIF
cSELE2 := Alias()


IF !netuse( "contas" )  // AREDE("CONTAS","CONTAS",0)
dbCloseAll()
RETU .F.
ENDIF

IF !netuse( pes )   // AREDE(PES,PES,0)
dbCloseAll()
RETU .F.
ENDIF


dbSelectAr( "FO_LAN" )
dbGoTop()
WHILE !Eof()
mCONTA := CONTA
VALE   := VALOR
mGRUPO := GRUPO
MDS( ' ' + Str( CONTA, 3 ) + ' ' + Str( VALOR, 10, 2 ) + ' ' + SubStr( GRUPO, 1, 60 ) )
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
IF Empty( DEMITIDO )
PETELA( 8 )
ANOADM := Year( ADMITIDO )
MESADM := Month( ADMITIDO )
ANOATU := Year( DXDIA )
MESATU := Month( DXDIA )
MESTRA := ( 12 - MESADM ) + MESATU
ANOTRA := ANOATU - ANOADM - 1 + Int( MESTRA / 12 )
CTR    := NUMERO
IF &mGRUPO
GRAVA2( mCONTA )
IF XB = 1 .OR. XB = 3
FIELD->HORAS := VALOR
FIELD->VALOR := 0
ENDIF
ENDIF
ENDIF
dbSelectAr( PES )
dbSkip()
ENDDO
dbSelectAr( "FO_LAN" )
dbSkip()
ENDDO
dbCloseAll()
RETU
// : FIM: FOAB.PRG

// + EOF: foab.prg
// +
