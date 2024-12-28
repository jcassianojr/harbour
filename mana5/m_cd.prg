// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_cd.prg
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
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +



#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"
#include "BOX.CH"

// Help de Contexto
PRIV HELPDBF := "CONFIGU"


@ 01, 00 SAY PadR( " Ý Vocˆ est  editando a configura‡„o basica do sistema ", 80 )

IF ZUSER = "/C" .OR. ZSUPER
ELSE
ALERTX( "Acesso Permitido Somente Para o Supervisor" )
RETU .F.
ENDIF


IF !USECHK( "CONFIGU",, .F. )
QUIT
ENDIF
hb_DispBox( 2, 0, 23, 79, B_DOUBLE )
@  3, 3 SAY "Arquivo Ajuda :" + spac( 11 ) + "Impressora:" + spac( 14 ) + "Letra:"
@  4, 3 SAY "Arquivo de Configura‡„o Arquivos :" + spac( 11 ) + "Arquivo do Manual"
@  5, 3 SAY "Arquivo de Configura‡„o Indexa‡„o:" + spac( 11 ) + "Arquivo Historico"
@  6, 3 SAY "Diret¢rio dos Arquivos de Configura‡„o"
@  8, 3 SAY "Diret¢rio dos Arquivos Integrados"
@ 10, 3 SAY "Diret¢rio dos Arquivos Principal"
@ 12, 3 SAY "Diret¢rio dos Arquivos Empresa"
@ 14, 3 SAY "Diret¢rio dos Arquivos do Banco"
@ 16, 3 SAY "Diret¢rio dos Arquivos de Cep"
@ 18, 3 SAY "Configura‡„o da Moeda"
@ 19, 3 SAY "Moeda" + spac( 11 ) + "Singular" + spac( 22 ) + "Plural"
@ 20, 3 SAY "Centavos" + spac( 8 ) + "Singular" + spac( 22 ) + "Plural"
@ 21, 3 SAY "Separador Moeda/Centavos" + spac( 22 ) + "Simbolo"
@ 22, 3 SAY "Sistema Multi-Empresa? (S/N)     CGCMA01    CGCMB01"
// Get nas Menvars
@  3, 19 GET HELP
@  3, 41 GET IMPPAD
@  3, 61 GET ARQFON
@  4, 38 GET ARQ
@  4, 66 GET MANUAL
@  5, 38 GET ARQ1
@  5, 66 GET ARQHIS
@  7, 3  GET DIRC
@  9, 3  GET DIRI
@ 11, 3  GET DIRP
@ 13, 3  GET DIRE
@ 15, 3  GET DIRB
@ 17, 3  GET DIRA
@ 19, 28 GET MOEDA01
@ 19, 57 GET MOEDA02
@ 20, 28 GET MOEDA03
@ 20, 57 GET MOEDA04
@ 21, 28 GET MOEDA05
@ 21, 57 GET MOEDA06
@ 22, 32 GET MULTIEMP VALID MULTIEMP $ 'SN'
@ 22, 44 GET INXCGCMA PICTURE '9'
@ 22, 55 GET INXCGCMB PICTURE '9'
READCUR()
dbCloseArea()

// Pega a Configura‡ao
MCD01()


// Nao pode Ser chamado pois as vezes chama sem ter as telas
// aMCDGET:=EDITPEG("MCD001")
// aMCDTEL:=TELAPEG("MCD001")
// TELASAY(aMCDTEL)
// EDITSAY(aMCDGET)





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MCD01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MCD01()

// Pegando Configura‡”es do Sistema
   WHILE .T.
      IF USECHK( "CONFIGU",, .T. )
         EXIT
      ELSE
         RETU .F.
      ENDIF
   ENDDO
   ZARQHIS   := AllTrim( ARQHIS )  // Nome do arquivo do Historico
   HELPARQ   := AllTrim( HELP )  // Nome do Arquivo do Help
   ZARQMAN   := AllTrim( MANUAL )  // Nome do Arquivo do Manual
   ZARQ      := AllTrim( ARQ )   // Nome do Arquivo de Configura‡„o Arquivos
   ZARQ1     := AllTrim( ARQ1 )  // Nome do Arquivo de Configura‡„o Indexa‡„o
   ZDIRC     := AllTrim( DIRC )  // Nome do Diret¢rio de Configura‡„o
   ZDIRI     := AllTrim( DIRI )  // Nome do Diret¢rio de Arquivos Integrados
   ZDIRP     := AllTrim( DIRP )  // Nome do Diret¢rio Principal
   ZDIRA     := AllTrim( DIRA )  // Nome do Diret¢rio Ceps
   ZDIRB     := AllTrim( DIRB )  // Nome do Diret¢rio Banco
   ZDIREx    := AllTrim( DIRE )  // Nome do Diret¢rio da Empresa
   ZMOEDA01  := AllTrim( MOEDA01 )   // Configura‡„o da Moeda Corrente Fun‡„o Extenso
   ZMOEDA02  := AllTrim( MOEDA02 )
   ZMOEDA03  := AllTrim( MOEDA03 )
   ZMOEDA04  := AllTrim( MOEDA04 )
   ZMOEDA05  := AllTrim( MOEDA05 )
   ZMOEDA06  := AllTrim( MOEDA06 )
   zMULTIEMP := MULTIEMP
   zARQFON   := AllTrim( ARQFON )
   zIMPPAD   := AllTrim( IMPPAD )
   ZIMA      := INXCGCMA
   ZIMB      := INXCGCMB
   cRDDEXT   := AllTrim( DRIVER )
   dbCloseAll()
   RETU .T.


// : FIM: M_CD.PRG

// + EOF: m_cd.prg
// +
