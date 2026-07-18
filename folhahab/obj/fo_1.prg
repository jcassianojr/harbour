// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo_1.prg
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
// :       FO_1.PRG: VERIFICACAO DA EMPRESA SOLICITADA)
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1999,  jcassiano  S/C Ltda.
// :  Atualizado em: 10/03/99
// :
// :*****************************************************************************



CABEX( 'Empresa nÑo Cadastrada' )
IF !MDG( 'Deseja Cadastr†-la' )
@ 04, 00 CLEA
RETU .F.
ENDIF
mSENHA := Space( 5 )
MDS( 'Digite a sua Senha' )
SET COLOR TO, G / G
@ 23, 40 GET mSENHA
READCUR()
CRIARVARS( "FIRMA" )
CRIARVARS( "BCOFGTS" )
mNRCLIEN := NREMP
mEMP     := NREMP


NOVOREG( "FIRMA", "FIRMA", mNRCLIEN )
NOVOREG( "BCOFGTS", "BCOFGTS", mEMP )


MDS( 'Criando Area de Trabalho' )   // CRIA DIRETORIO
NOVOPATH := 'EMP' + SubStr( StrZero( Year( DXDIA ), 4 ), 3, 2 ) + StrZero( NREMP, 3 )
IF DIRMAKE( NOVOPATH ) # 0
ALERTX( "Erro Ao Criar empresa(Diretorio)" )
RETU .F.
ENDIF
cOLDDIR := hb_cwd()
// IF DIRCHANGE(HB_CWD()+NOVOPATH)#0
IF hb_cwd( NOVOPATH ) = cOLDIR
ALERTX( "Erro Ao Criar empresa(Mover Dir)" )
RETU .F.
ENDIF
MAKEDBF( "..\AJUDIRF.DBE" )
MAKEDBF( "..\DEPTO.DBE" )
// MAKEDBF("..\FO_CHIS.DBE") Miodulo rh
MAKEDBF( "..\FO_COMP.DBE" )
MAKEDBF( "..\FO_EXP.DBE" )
MAKEDBF( "..\FO_FER.DBE" )
MAKEDBF( "..\FO_HOR.DBE" )
MAKEDBF( "..\FO_IRR.DBE" )
MAKEDBF( "..\FO_OCO.DBE" )
MAKEDBF( "..\FO_LAN.DBE" )
MAKEDBF( "..\FO_PES.DBE" )
MAKEDBF( "..\FO_PFE.DBE" )
MAKEDBF( "..\FO_PSL.DBE" )
MAKEDBF( "..\FO_RES.DBE" )
MAKEDBF( "..\FO_RSS.DBE" )
MAKEDBF( "..\FO_VAR.DBE" )
MAKEDBF( "..\FO_VBR.DBE" )
MAKEDBF( "..\FUNCAC.DBE" )
MAKEDBF( "..\FUNCAO.DBE" )
MAKEDBF( "..\IRRF.DBE" )
MAKEDBF( "..\IRRF01.DBE" )
MAKEDBF( "..\IRRF02.DBE" )
MAKEDBF( "..\MG01.DBE" )
// MAKEDBF("..\MP05.DBE")
MAKEDBF( "..\PROV13.DBE" )
MAKEDBF( "..\PROVFE.DBE" )
MAKEDBF( "..\RESFOR.DBE" )
aFOLHA := { { "NUMERO", "N", 5, 0 }, { "CONTAS", "N", 4, 0 }, ;
      { "HORAS", "N", 7, 2 }, { "VALOR", "N", 12, 2 }, ;
      { "CONTROLE", "N", 9, 0 }, { "FATOR", "N", 6, 4 }, ;
      { "TRIBUTIRR", "N", 1, 0 }, { "TRIBUTINPS", "N", 1, 0 }, ;
      { "TRIB_FGTS", "N", 1, 0 }, { "TIPO", "N", 1, 0 }, ;
      { "VALORBASE", "N", 1, 0 } }
FOR X := 0 TO 12
dbCreate( "FP" + StrZero( NREMP, 4 ) + StrZero( X, 2 ), aFOLHA )
NEXT X
dbCreate( "FO_FP13A", aFOLHA )
dbCreate( "FO_FP13B", aFOLHA )
dbCreate( "FO_FP13C", aFOLHA )
hb_cwd( '..' )
// DIRCHANGE('..')
ALERTX( "Empresa Criada" )
ALERTX( "Use Cadastro Empresa Para os Dados Cadastrais" )
ALERTX( "ê Necessario indexar Arquivos em Configura Sistema" )
RETU

// : FIM: FO_1.PRG

// + EOF: fo_1.prg
// +
