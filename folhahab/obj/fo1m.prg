// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo1m.prg
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
// :       FO1M.PRG: Cria‡„o Arquivos Folha de Ponto
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/07/94     16:12
// :
// :  Procs & Fncts: FO1M()
// :               : CRIARQ()
// :               : REPARQ()
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :               : CRIARQ()           (fun‡„o    em FO1M.PRG)
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************



CABEX( "Criar Folha de Ponto" )
IF !MDG( 'Voce tem certeza' )
RETURN
ENDIF
IF !MDG( 'Voce realmente tem certeza' )
RETU
ENDIF
MAKEDBF( "FOPTOREL.dbe", .F. )
MAKEDBF( "FOPTOHRE.DBE", .F. )
MAKEDBF( "FOPTOCON.DBE", .F. )   // Configuracao
MAKEDBF( "FOPTOBCO.DBE", .F. )   // configuracao
MAKEDBF( "FO_DIO.DBE", .F. )   //
MAKEDBF( "FO_PON.DBE", .F. )   //
MAKEDBF( "FO_POT.DBE", .F. )   //
MAKEDBF( "FO_POS.DBE", .F. )   //
MAKEDBF( "FO_POCO.DBE", .F. )  //
MAKEDBF( "FOPTOCOM.DBE", .F. )   //
MAKEDBF( "FO_PHOR.DBE", .F. )  //
MAKEDBF( "FO_PDES.DBE", .F. )  //
MAKEDBF( "FO_PMAN.DBE", .F. )  //
MAKEDBF( "FOPTOHOR.DBE", .F. )
MAKEDBF( "FOPTOALM.DBE", .F. )
MAKEDBF( "FOPTOREV.DBE", .F. )   //
MAKEDBF( "FOPTOPRO.DBE", .F. )
MAKEDBF( "FOPTOPRD.DBE", .F. )
MAKEDBF( "BCOREQ.DBE", .F. )   //
hb_cwd( PATHX )
MAKEDBF( "..\FO_RELHR.DBE", .F. )
MAKEDBF( "..\FOPTOEVE.DBE", .F. )
MAKEDBF( "..\FO_PTT.DBE", .F. )
MAKEDBF( "..\AFDTERR", .F. )
MAKEDBF( "..\BCRBAK.DBE", .F. )  //
MAKEDBF( "..\BCOHRS.DBE", .F. )
MAKEDBF( "..\BCOBAK.DBE", .F. )  //
MAKEDBF( "..\BCODEM.DBE", .F. )
MAKEDBF( "..\BCODEK.DBE", .F. )  //
MAKEDBF( "..\HTTTROCA.DBE", .F. )
MAKEDBF( "..\FOPTOATR.DBE", .F. )
MAKEDBF( "..\CESTA", .F. )
MAKEDBF( "..\CTRHOR", .F. )
MAKEDBF( "..\FERIAs", .F. )
hb_cwd( '..' )
// Requer Um Registro arquivo configuracao por empresa
IF NETUSE( "FOPTOBCO" )
dbGoTop()
IF !dbSeek( nremp )
NETrecapp()
field->empresa := nremp
ENDIF
dbCloseArea()
ENDIF
IF netuse( "FOPTOCON" )
dbGoTop()
IF !dbSeek( nremp )
NETrecapp()
field->empresa := nremp
ENDIF
dbCloseArea()
ENDIF
RETU

// + EOF: fo1m.prg
// +
