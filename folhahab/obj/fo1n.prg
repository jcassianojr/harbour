// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo1n.prg
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
// :       FO1N.PRG: Eliminar Folha de Ponto
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/25/94     11:09
// :
// :  Procs & Fncts: FO1N()
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************


CABEX( "Eliminar Folha de Ponto" )
IF !MDG( 'Vocˆ tem certeza' )
RETU
ENDIF
IF !MDG( 'Vocˆ realmente tem certeza' )
RETU
ENDIF

DELDBFNTX( "AFDTERR" )
DELDBFNTX( "BCOBAK" )
DELDBFNTX( "BCODEK" )
DELDBFNTX( "BCODEM" )
DELDBFNTX( "BCOHRS" )
DELDBFNTX( "BCOREQ" )
DELDBFNTX( "BCOREQ" )   //
DELDBFNTX( "BCRBAK" )
DELDBFNTX( "CESTA" )
DELDBFNTX( "CTRHOR" )
DELDBFNTX( "FERIAS" )
DELDBFNTX( "FO_DIO" )
DELDBFNTX( "FO_PDES" )  //
DELDBFNTX( "FO_PHOR" )  //
DELDBFNTX( "FO_PMAN" )  //
DELDBFNTX( "FO_POCO" )  //
DELDBFNTX( "FO_PON" )
DELDBFNTX( "FO_PON" )   //
DELDBFNTX( "FO_POS" )
DELDBFNTX( "FO_POS" )   //
DELDBFNTX( "FO_POT" )
DELDBFNTX( "FO_POT" )   //
DELDBFNTX( "FO_PTT" )
DELDBFNTX( "FO_RELHR" )
DELDBFNTX( "FOPTOALM" )
DELDBFNTX( "FOPTOATR" )
DELDBFNTX( "FOPTOBCO" )
DELDBFNTX( "FOPTOCOM" )
DELDBFNTX( "FOPTOCOM" )   //
DELDBFNTX( "FOPTOCON" )
DELDBFNTX( "FOPTOCON" )   // Configuracao
DELDBFNTX( "FOPTOEVE" )
DELDBFNTX( "FOPTOHOR" )
DELDBFNTX( "FOPTOHRE" )
DELDBFNTX( "FOPTOPRD" )
DELDBFNTX( "FOPTOPRO" )
DELDBFNTX( "FOPTOREL" )
DELDBFNTX( "FOPTOREV" )
DELDBFNTX( "FOPTOREV" )   //
DELDBFNTX( "HTTTROCA" )
DELDBFNTX( "RBTEMP" )
RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DELDBFNTX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC DELDBFNTX( cARQ )

   MDS( 'Deletando ' + cARQ )
   FErase( ZDIRN + cARQ + ".DBF" )
   FErase( ZDIRN + cARQ + "." + cRDDEXT )
   FErase( ZDIRN + cARQ + ".DBF" )
   FErase( ZDIRN + cARQ + "." + cRDDEXT )
   FErase( cARQ + ".DBF" )
   FErase( cARQ + "." + cRDDEXT )
   RETU

// : FIM: FO1N.PRG

// + EOF: fo1n.prg
// +
