// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_a2.prg
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
// +    Documentado em 27-Dez-2024 as  9:41 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :  FORES_A2.PRG : Remanejamento de F‚rias
// :     Linguagem : Clipper 5.2e
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :      Copyright (c) 1997,  SOFTEC  S/C Ltda.
// :  Atualizado em: 08/07/97
// :
// :*****************************************************************************


CABE2( 'Remanejamento de F‚rias' )
DIAFIM := Date()
MDS( 'Digite a data Termino:' )
@ 24, 40 GET DIAFIM
READCUR()


IF !netuse( pes )
RETU
ENDIF
IF !netuse( "FO_FER" )
RETU
ENDIF

MDS( "Checando Competencia" )
dbSelectAr( "FO_FER" )
dbGoTop()
WHILE !Eof()
IF Empty( DATFERIAS ) .OR. Empty( DATFERIASF )
netrecdel()
ENDIF
dbSkip()
ENDDO

MDS( "Excluindo Funcionarios de Anos Anteriores" )
dbSelectAr( "FO_FER" )
dbGoTop()
WHILE !Eof()
mNUMERO := NUMERO
dbSelectAr( PES )
dbGoTop()
dbSeek( mNUMERO )
lFUNC := Found()
dbSelectAr( "FO_FER" )
WHILE mNUMERO = NUMERO .AND. !Eof()
IF !lFUNC
netrecdel()
ENDIF
dbSkip()
ENDDO
ENDDO
MDS( "Fixando o arquivo" )
// PACK

MDS( "Remanejando o Arquivo" )
dbSelectAr( PES )
FILTRO := FILTRO( 'EMPTY(DEMITIDO)' )
SET FILTER TO &FILTRO
dbGoTop()
WHILE !Eof()
PETELA( 8 )
CTR  := NUMERO
NOM  := NOME
DEP1 := DEPTO
SEC1 := SECAO
SET1 := SETOR
CHA1 := CHAPA
DAT  := ADMITIDO
IF Empty( ADMITIDO )
ALERTX( 'Funcion rio sem data de admiss„o' )
dbSkip()
LOOP
ENDIF
dbSelectAr( "FO_FER" )
dbGoTop()
dbSeek( CTR * 100000000 )
WHILE CTR = NUMERO .AND. !Eof()
DAT := DATFERIASF + 1
dbSkip()
ENDDO
WHILE DAT < DIAFIM
GRAVAREM()
DAT := DATFERIASF + 1
ENDDO
dbSelectAr( PES )
dbSkip()
ENDDO
dbCloseAll()
RETU


// !*****************************************************************************
// !
// !       GRAVAREM
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAVAREM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION GRAVAREM   // GRAVA DADOS DO REMANEJAMENTO

   IF Day( DAT ) = 29 .AND. Month( DAT ) = 02
      DAT++
   ENDIF
   CTLE := ( ( ( ( ( CTR * 10000 ) + Year( DAT ) ) * 100 ) + Month( DAT ) ) * 100 ) + Day( DAT )
   dbSelectAr( "FO_FER" )
   dbGoTop()
   IF !dbSeek( CTLE )
      netrecapp()
      FO_FER->CONTROLE := CTLE
      IF Day( DAT ) # 1 .OR. Month( DAT ) # 3
         DATF := CToD( SubStr( DToC( DAT - 1 ), 1, 6 ) + ANOSTR( Year( DAT - 1 ) + 1 ) )
      ELSE
         DATF := CToD( '28/02/' + ANOSTR( Year( DAT - 1 ) + 1 ) )
      ENDIF
      FO_FER->DATFERIAS  := DAT
      FO_FER->DATFERIASF := DATF
      FO_FER->BAIXADO    := 'N'
      FO_FER->DIASJUS    := 30
   ELSE
      netreclock()
   ENDIF
   IF Empty( DIASGOZA3 )
      FO_FER->DIASGOZA3 := DIASJUS - DIASPAGO - DIASPAGO2 - DIASPAGO3
   ENDIF
   FO_FER->NUMERO := CTR
   FO_FER->DEPTO  := DEP1
   FO_FER->SECAO  := SEC1
   FO_FER->SETOR  := SET1
   FO_FER->NOME   := NOM
   FO_FER->CHAPA  := CHA1
   dbUnlock()
   RETU

// : FIM: FORES_A2.PRG

// + EOF: fores_a2.prg
// +
