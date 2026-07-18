// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fohs.prg
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
// +    Documentado em 27-Dez-2024 as  9:46 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :       FOHH.PRG: Guia de Contribui‡„o ao Sindicato
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  jcassiano  S/C Ltda.
// :  Atualizado em: 30/06/98
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"

IF ARQ = 9 .OR. ARQ = 10
MDT( 'Use a opcao Folha de Pagamento' )
RETU
ENDIF
IF ARQ = 6
ALERTX( "Nao Disponivel VT" )
RETU .F.
ENDIF


IF !MDL( 'Rela‡„o de Contribui‡„o ao Sindical', 0 )
RETU .F.
ENDIF


TIPATIV := OBTER( "FIRMA",, NREMP, "ATIDES" )

CTA := 630
@ 24, 00 SAY "Confirme a Conta"
@ 24, 60 GET CTA                PICT '####'
IF !READCUR()
RETU .F.
ENDIF

IF !ARQCTA( ARQ )
dbCloseAll()
RETU .F.
ENDIF
dbGoTop()
IF !dbSeek( CTA )
dbCloseAll()
ALERTX( "Conta N„o Cadastrada" )
RETU .F.
ENDIF
dbCloseAll()

xDATA := DXDIA
MDS( "Confirme data de Vencimento" )
@ 24, 40 GET xDATA
READCUR()
xANO := ANOWORK
MDS( "Confirme Ano de Competencia" )
@ 24, 40 GET xANO
READCUR()

IF !ARQUSAR( ARQ, 1 )
dbCloseAll()
RETU .F.
ENDIF
cSELE1 := Alias()

TOTFUN := 0
IF !ARQPES( ARQ, 1, 1 )
dbCloseAll()
RETU .F.
ENDIF
FILTRO := FILTRO( "" )
dbGoTop()
WHILE !Eof()
IF ( ( Empty( DEMITIDO ) ) .OR. ( Month( DEMITIDO ) >= MES .AND. Year( DEMITIDO ) >= ANO ) )
TOTFUN++
ENDIF
dbSkip()
ENDDO
SET FILTER TO &FILTRO
cSELE2 := Alias()

IF !NETUSE( "SINDICAT" )  // AREDE("SINDICAT","SINDICAT",1)
dbCloseAll()
RETU .F.
ENDIF


IMPRESSORA()
dbSelectAr( "SINDICAT" )
dbGoTop()
WHILE !Eof()
mCODIGO   := CODIGO
mNOME     := NOME
mCGC      := CGC
mTELEFONE := TELEFONE
mENDERECO := ENDERECO
mBAIRRO   := BAIRRO
mESTADO   := ESTADO
mCIDADE   := CIDADE
mCEP      := CEP
mENTIDADE := ENTIDADE
TOTREC    := CONT := CONTT := 0
FOHHS()
dbSelectAr( "SINDICAT" )
dbSkip()
ENDDO
dbCloseAll()
VIDEO()
IMPEND()
RETU

// !*****************************************************************************
// !
// !         Fun‡„o: FOHHS()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOHHS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FOHHS

   dbSelectAr( cSELE2 )
   dbGoTop()
   WHILE !Eof()
      CTR := NUMERO
      IF SINDICATO = mCODIGO
         dbSelectAr( cSELE1 )
         VALF := VALCTA( CTR, CTA )
         IF VALF # 0
            TOTREC += VALF
            CONT ++
         ENDIF
      ENDIF
      dbSelectAr( cSELE2 )
      dbSkip()
   ENDDO
   IF TOTREC > 0
      dbSelectAr( "SINDICAT" )
      @ PRow() + 5, 77 SAY CGC1
      @ PRow() + 2, 77 SAY xDATA
      @ PRow(), 92    SAY xANO
      @ PRow() + 3, 03 SAY mNOME
      @ PRow(), 77    SAY mENTIDADE
      @ PRow() + 2, 03 SAY mENDERECO
      @ PRow(), 77    SAY mCGC
      @ PRow() + 2, 03 SAY mBAIRRO
      @ PRow(), 40    SAY mCEP
      @ PRow(), 54    SAY mCIDADE
      @ PRow(), 91    SAY mESTADO
      @ PRow() + 3, 03 SAY MSG2
      @ PRow() + 2, 03 SAY ENDER1
      @ PRow() + 2, 03 SAY CEP1
      @ PRow(), 19    SAY CID1
      @ PRow(), 54    SAY BAI1
      @ PRow(), 91    SAY EST1
      @ PRow() + 2, 03 SAY TIPATIV
      @ PRow(), 28    SAY ATIV1
      @ PRow(), 60    SAY "X"
      @ PRow() + 3, 36 SAY "X"
      @ PRow(), 78    SAY TOTREC
      @ PRow() + 2, 44 SAY CONT
      @ PRow() + 4, 44 SAY TOTFUN
      @ PRow() + 2, 44 SAY TOTFUN - CONT
      @ PRow(), 78    SAY TOTREC
      @ PRow() + 10, 03 SAY "" // Ajuste Tamanho Formulario
   ENDIF
   RETU .T.


// : FIM: FOHS.PRG

// + EOF: fohs.prg
// +
