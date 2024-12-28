// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : folis_da.prg
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
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :   FOLIS_DA.PRG: DIRF Avulsa
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************

// #INCLUDE "COMANDO.CH"
CABE2( 'IRRF Avulso' )


MDS( '* CARREGANDO DADOS DA FIRMA *' )
IF !NETUSE( "FIRMA" )
RETU
ENDIF
dbGoTop()
IF dbSeek( NREMP )
NRCGC  := CGC
xrTEL  := TELEFONE
xrRESN := RESPONSAV
ELSE
RETU .F.
dbCloseAll()
ENDIF
dbCloseAll()

DXDIA2  := Date()
CONTAR  := 1
ANOBASE := Year( DXDIA2 )

@ 21, 00 CLEA
@ 21, 00 SAY 'Nome do Respons vel'
@ 22, 00 SAY 'Qual a data para impressao'
@ 23, 00 SAY 'Qual o ano base'
@ 24, 00 SAY 'Quantas Copias Deseja'
@ 21, 40 GET xrRESN
@ 22, 40 GET DXDIA2
@ 23, 40 GET ANOBASE                      PICT '####'
@ 24, 40 GET CONTAR                       PICT '##'
IF !READCUR()
RETU .F.
ENDIF

UFIR := .F.
mCPF := Space( 14 )
IF !NETUSE( "IRRF" )  // AREDE("IRRF","IRRF",0)
dbCloseAll()
RETU
ENDIF
dbGoTop()
WHILE .T.
IRRFTEL()
IF Empty( CGC )
NETRECLOCK()
FIELD->CGC := NRCGC
dbUnlock()
ENDIF
@  3, 7  SAY CPF
@  3, 32 SAY NOME
@  5, 16 SAY V401  PICTURE '999999999.99'
@  6, 16 SAY V402  PICTURE '999999999.99'
@  7, 16 SAY V403  PICTURE '999999999.99'
@  8, 16 SAY V404  PICTURE '999999999.99'
@  9, 16 SAY V407  PICTURE '999999999.99'
@ 10, 16 SAY V405  PICTURE '999999999.99'
@  5, 56 SAY V501  PICTURE '999999999.99'
@  6, 56 SAY V502  PICTURE '999999999.99'
@  7, 56 SAY V503  PICTURE '999999999.99'
@  8, 56 SAY V504  PICTURE '999999999.99'
@  9, 56 SAY V505  PICTURE '999999999.99'
@ 10, 56 SAY V506  PICTURE '999999999.99'
@ 11, 16 SAY CGC
@ 11, 56 SAY V507  PICTURE '999999999.99'
@ 13, 3  SAY OBS01
@ 15, 21 SAY V605  PICTURE '999999999.99'
@ 15, 34 SAY V606  PICTURE '999999999.99'
@ 15, 47 SAY V601  PICTURE '999999999.99'
@ 16, 21 SAY V610  PICTURE '999999999.99'
@ 16, 34 SAY V612  PICTURE '999999999.99'
@ 16, 47 SAY V602  PICTURE '999999999.99'
@ 18, 3  SAY OBS02
@ 20, 3  SAY OBS03
@ 21, 3  SAY OBS04
@ 22, 3  SAY OBS05
@ 24, 00 CLEA
@ 24, 02 PROM 'P>r¢ximo'
@ 24, 11 PROM 'R>etorna'
@ 24, 20 PROM 'A>ltera'
@ 24, 28 PROM 'B>usca'
@ 24, 36 PROM 'N>ovo'
@ 24, 42 PROM 'L>istar'
@ 24, 52 PROM 'D>eleta'
@ 24, 71 PROM 'S>a¡da'
MENU TO OPCAO
DO CASE
CASE OPCAO = 1
NEXTREC()
CASE OPCAO = 2
PREVREC()
CASE OPCAO = 3
NETRECLOCK()
IRRFGET( .T. )
dbUnlock()
CASE OPCAO = 4
MDS( 'Digite o CPF' )
@ 24, 40 GET mCPF
READCUR()
dbGoTop()
IF !dbSeek( mCPF )
MDT( 'CPF n„o encontrado' )
ENDIF
CASE OPCAO = 5
NETRECAPP()
CASE OPCAO = 6
IMPDA()
CASE OPCAO = 7
IF MDG( "Apagar" )
NETRECDEL()
IF Eof()
dbSkip( - 1 )
ENDIF
ENDIF
OTHERWISE
dbCloseAll()
RETU
ENDCASE
ENDDO




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function IMPDA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC IMPDA

   IF !CHECKIMP( 0 )
      RETU .F.
   ENDIF
   IMPRESSORA()
   IMPINFO()
   VIDEO()
   IMPEND()
   RETU .T.

// + EOF: folis_da.prg
// +
