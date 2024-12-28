// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo1x.prg
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
// :       FO1X.PRG: Transfere Folha Entre Firma com Convers„o
// :      Linguagem: ClipSr 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/07/94     14:46
// :
// :  Procs & Fncts: FO1X()
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :               : OBTER()            (fun‡„o    em FOLPROC.PRG)
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************

#include "BOX.CH"

// Variaveis de Trabalho
nFIRORI := NREMP
nFIRDES := NREMP + 1
nCONV   := 0.000000
tCONV   := "D"

// Desenha a Tela
CABEX( "Transferir Folha entre Firmas" )
hb_DispBox( 7, 0, 23, 79, B_DOUBLE + " " )
@ 10, 6 SAY "Firma de Origem" + SPAC( 6 ) + ":"
@ 12, 6 SAY "Firma Destino" + SPAC( 8 ) + ":"
@ 14, 6 SAY "Fator de Convers„o   :"
@ 16, 6 SAY "Multiplicar Dividir  :"

// Get nas Menvars
@ 10, 31 GET nFIRORI PICT "9999"
@ 12, 31 GET nFIRDES PICT "9999"
@ 14, 31 GET nCONV   PICT "999,999,999.999999"
@ 16, 31 GET tCONV   PICT "!"                  VALID tCONV $ "MD"
IF !READCUR()
RETU
ENDIF
nCONV := IF( nCONV = 0, 1, nCONV )

// Confirma‡„o de continua‡„o
@ 17, 31 SAY OBTER( "FIRMA",, nFIRORI, "COGNOME" )
@ 19, 31 SAY OBTER( "FIRMA",, nFIRDES, "COGNOME" )
IF !MDG( "Tudo OK pode-se Continuar" )
RETU
ENDIF
IF !MDG( "Deseja iniciar a convers„o" )
RETU
ENDIF

cPATHORI := hb_cwd() + 'EMP' + StrZero( nFIRORI, 5 ) + "\"
cPATHDES := hb_cwd() + 'EMP' + StrZero( nFIRDES, 5 ) + "\"


IF NRSEN <> 'DiReT'
FOLORI := 'FP' + StrZero( nFIRORI, 4 ) + ARQMES
FOLDES := 'FP' + StrZero( nFIRDES, 4 ) + ARQMES
ELSE
FOLORI := 'SO' + StrZero( nFIRORI, 4 ) + ARQMES
FOLDES := 'SO' + StrZero( nFIRDES, 4 ) + ARQMES
ENDIF

IF MDG( "Deseja transferir Arquivos da Folha" )
INFOR( cPATHDES + FOLDES, "CONTROLE", cPATHDES + FOLDES, .T. )
IF MDG( "Deseja Apagar Arquivo da Folha Antes de Transferir" )
MDS( "Apagando a Folha de Destino" )
netzap( cPATHDES + FOLDES )
ENDIF

MDS( "Atualizando folha de destino" )
ATUALIZA( cPATHORI + FOLORI, "CONTROLE", cPATHDES + FOLDES )

MDS( "Convertendo Folha de Destino" )
IF !netuse( cPATHDES + FOLDES )  // AREDE(cPATHDES+FOLDES,cPATHDES+FOLDES,0)
RETU
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
IF tCONV = "D"
dbEval( {|| netgrvcam( "VALOR", VALOR / nCONV ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
ELSE
dbEval( {|| netgrvcam( "VALOR", VALOR * nCONV ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
ENDIF
dbCloseAll()
ENDIF

IF MDG( "Deseja Transferir Cadastro de Funcionarios" )
IF MDG( "Deseja Apagar Arquivo Funcionarios Antes de Transferir" )
MDS( "Apagando Cadastro de Funcionarios" )
netzap( cPATHDES + PES )
ENDIF
MDS( "Atualizando Cadastro de Funcion rios" )
ATUALIZA( cPATHORI + PES, "NUMERO", cPATHDES + PES, cPATHDES + PES )
MDS( "Convertendo Salario de Destino" )
IF !netuse( cPATHDES + PES )
RETU
ENDIF
xSAL     := "SAL" + SubStr( MMES, 1, 3 )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
IF tCONV = "D"
dbEval( {|| netgrvcam( xSAL, &xSAL. / nCONV ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
ELSE
dbEval( {|| netgrvcam( xSAL, &xSAL. * nCONV ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
ENDIF
dbCloseAll()
ENDIF
RETU .T.
// : FIM: FO1X.PRG

// + EOF: fo1x.prg
// +
