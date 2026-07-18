// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo42a.prg
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
// :      FO42A.PRG: Recria Planilha de Projecao
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/07/94     14:48
// :
// :  Procs & Fncts: FO42A()
// :
// :          Chama: RFILORD()          (fun‡„o    em FOLPROC.PRG)
// :
// :     Arq. Dados: FO_PSL - Proje‡„o Salarial
// :                 FUNCAO - Arquivo de Fun‡”es
// :
// :        Indices: FUNCOD   Codigo da Funcao
// :                          CODIGO
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************


// **FO4L RECRIA PLANILHA DE PROJECAO
xANO := 0
XMES := 0
MDS( 'DIGITE O MES REFERENCIA' )
@ 24, 60 GET XMES RANGE 1, 12 PICT "99"
IF !READCUR()
RETU .F.
ENDIF

MDS( 'DIGITE O ANO REFERENCIA 00 PARA O Atual' )
@ 24, 60 GET XANO PICT "99"
IF !READCUR()
RETU .F.
ENDIF

SALMES := 'SAL' + Upper( SubStr( MMES( XMES ), 1, 3 ) )
MDS( 'AGUARDE CRIANDO NOVA PLANILHA' )
FILTRO := 'EMPTY(DEMITIDO)'
aRETU  := RFILORD( "PES", .F., FILTRO )
INX    := aRETU[ 1 ]
FILTRO := aRETU[ 2 ]


XPES := "\FOLHA\EMP" + StrZero( XANO, 2 ) + StrZero( NREMP, 3 ) + "\" + PES

IF !NETUSE( XPES )
RETU
ENDIF
SET FILTER TO &FILTRO
cSELE1 := Alias()

NETZAP( "FO_PSL" )
IF !NETUSE( "FO_PSL" )
RETU
ENDIF

IF !NETUSE( "FUNCAO" )
RETU
ENDIF
dbSelectAr( cSELE1 )
dbGoTop()
WHILE !Eof()
GRVPSL()
dbSelectAr( cSELE1 )
dbSkip()
ENDDO
dbCloseAll()
RETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRVPSL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION GRVPSL

   NUM := NUMERO
   NOM := NOME
   ADM := ADMITIDO
   SAL := &SALMES
   NOF := OBTER( "FUNCAO",, FUNCAO, "FNOME" )
   dbSelectAr( "FO_PSL" )
   NETRECAPP()
   FIELD->NUMERO   := NUM
   FIELD->NOME     := NOM
   FIELD->ADMITIDO := ADM
   FIELD->FUNCAO   := NOF
   FIELD->SALANT   := SAL

   RETURN

// : FIM: FO42A.PRG

// + EOF: fo42a.prg
// +
