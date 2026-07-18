// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : focj.prg
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
// :       FOCJ.PRG: Imprimir Notas para Troco
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/08/94     10:29
// :
// :*****************************************************************************
// //#INCLUDE "COMANDO.CH"
IF !MDL( "Distribuicao de Notas Para Troco", 0 )
RETU .F.
ENDIF

// Parametros de trabalho
PARA PP, CW

// Verifica se nao e VT
IF PP = 6
MDT( 'N„o Disponivel para Este cadastro' )
RETU .F.
ENDIF

// Pega as Contas de Credito e Debito
lVALE := .F.
CC    := 399
CD    := 999
DO CASE
CASE PP = 3
CC := 900
CD := 0
CASE PP = 9   // Abre Folha
CC    := 41
CD    := 501
lVALE := .T.
PP    := 1
CASE PP = 10    // Abre Folha
CC := 445
CD := 527
PP := 1
ENDCASE


MDS( "Confirme Contas Credito Debito" )
@ 24, 40 GET CC PICT "999"
@ 24, 50 GET CD PICT "999"
IF !READCUR()
RETU .F.
ENDIF

// Prepara as Variaveis
NOTAS := Array( 12 )
QTDE  := Array( 12 )
AFill( QTDE, 0 )
LIN  := 80
FL   := QTFUN := TOTAL := RESTO := 0
POS1 := SPAC( 40 )

// Descri‡„o Complementar
MDS( 'Digite Cabe‡ario Complementar' )
@ 24, 35 GET POS1
IF !READCUR()
RETU .F.
ENDIF


// Pega os Valores da Cedula
IF !netuse( "TABTROCO" )
RETU
ENDIF
dbGoTop()
FOR X := 1 TO 12
NOTAS[ X ] = DESCT
dbSkip()
NEXT X
dbCloseAll()

IF !ARQUSAR( PP, 1 )
RETU .F.
ENDIF
cSELE1 := Alias()

IF !ARQPES( PP, 1, 1 )
RETU
ENDIF
cSELE2 := Alias()
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES))'
FI     := Trim( FILTRO )
FILTRO := FILTRO( FI )
SET FILTER TO &FILTRO

IF CW > 1
IF !NETUSE( "DEPTO" )
RETU
ENDIF
DO CASE
CASE CW = 2
FILTRA := 'SETOR=0.AND.SECAO=0'
COMPAR := 'DEP=DEPTO'
CASE CW = 3
FILTRA := 'SETOR#0.AND.SECAO=0'
COMPAR := 'DEP=DEPTO.AND.SET=SETOR'
CASE CW = 4
FILTRA := 'SETOR#0.AND.SECAO#0'
COMPAR := 'DEP=DEPTO.AND.SET=SETOR.AND.SEC=SECAO'
ENDCASE
SET FILTER TO &FILTRA
ENDIF


IMPRESSORA()
IF CW = 1
FOCJX( ".T." )
ELSE
dbSelectAr( "DEPTO" )
dbGoTop()
WHILE !Eof()
DEP := DEPTO
SET := SETOR
SEC := SECAO
FOCJX( COMPAR )
dbSelectAr( "DEPTO" )
dbSkip()
ENDDO
ENDIF
dbCloseAll()
VIDEO()
IMPEND()
RETU

// !*****************************************************************************
// !
// !         Fun‡„o: FOCJX()
// !
// !    Chamado por: FOCJ.PRG
// !
// !          Chama: VALCTA()           (fun‡„o    em FOLPROC.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOCJX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FOCJX

   PARA COMPARE

   TOTALIZA := .F.
   dbSelectAr( cSELE2 )
   WHILE !Eof()
      IF &COMPARE
         TOTALIZA := .T.
         NUM      := NUMERO
         CRE      := DEB := LIQ := 0
         IF LIN > 60
            FL++
            @  1, 0   SAY IF( IM1 = 'A', IMPSTR( cIMPCOM ), IMPSTR( cIMPEXP ) )
            @  2, 20  SAY IMPCHR( cIMPTIT ) + ACENTO( MSG2 )
            @  3, 18  SAY IMPCHR( cIMPTIT ) + ACENTO( 'Rela‡„o de Notas para Troco' )
            @  5, 0   SAY ACENTO( POS1 )
            @  5, 100 SAY Time()
            @  5, 110 SAY Date()
            @  5, 120 SAY 'FL. ' + StrZero( FL, 4 )
            @  6, 0   SAY REPL( '-', 132 )
            @  7, 0   SAY ACENTO( "N£mero" ) + "Nome"
            @  7, 45  SAY "Valor"
            FOR X := 1 TO 12
               @  7, 55 + ( X * 5 ) SAY "NT" + StrZero( X, 2 )
            NEXT X
            @  8, 0 SAY REPL( '-', 132 )
            LIN := 9
         ENDIF
         LIN++
         @ LIN, 00 SAY NUMERO       PICTURE "######"
         @ LIN, 08 SAY ACENTO( NOME )
         dbSelectAr( cSELE1 )
         CRE   := VALCTA( NUM, CC ) + IF( lVALE, VALCTA( NUM, 997 ), 0 )
         DEB   := VALCTA( NUM, CD ) + IF( lVALE, VALCTA( NUM, 442 ), 0 )
         LIQ   := CRE - DEB
         TOTAL += LIQ
         @ LIN, 40 SAY LIQ PICT "@E 999,999,999.99"
         FOR X := 1 TO 12
            IF NOTAS[ X ] # 0
               IF Round( LIQ, 2 ) > Round( NOTAS[ X ], 2 ) .OR. Round( LIQ, 2 ) = Round( NOTAS[ X ], 2 )
                  QTNOTA := 0
                  WHILE Round( LIQ, 2 ) > Round( NOTAS[ X ], 2 ) .OR. Round( LIQ, 2 ) = Round( NOTAS[ X ], 2 )
                     QTNOTA++
                     LIQ -= NOTAS[ X ]
                  ENDDO
                  QTDE[ X ] += QTNOTA
                  @ LIN, 50 + ( X * 5 ) SAY QTNOTA PICTURE '####'
               ENDIF
            ENDIF
         NEXT X
         RESTO += LIQ
         QTFUN++
      ENDIF
      dbSelectAr( cSELE2 )
      dbSkip()
   ENDDO
   IF TOTALIZA
      TODIS := 0
      @ PRow() + 1, 0 SAY REPL( '-', 132 )
      IF PRow() > 40
         IMPFOL()
      ENDIF
      @ PRow() + 1, 00 SAY REPL( "=", 132 )
      @ PRow() + 1, 10 SAY ACENTO( "Resumo Final de Distribui‡„o" )
      @ PRow() + 1, 00 SAY REPL( "=", 132 )
      FOR X := 1 TO 12
         @ PRow() + 1, 2 SAY QTDE[ X ]            PICT "99999"
         @ PRow(), 10   SAY NOTAS[ X ]           PICT "@E 999,999,999,999.99"
         @ PRow(), 40   SAY QTDE[ X ] * NOTAS[ X ] PICT "@E 999,999,999,999.99"
         TODIS += QTDE[ X ] * NOTAS[ X ]
      NEXT X
      @ PRow() + 1, 00 SAY REPL( "=", 132 )
      @ PRow() + 1, 01 SAY ACENTO( "Funcion rios" )
      @ PRow(), 31    SAY "Resto"
      @ PRow(), 47    SAY "Distribuido"
      @ PRow(), 67    SAY "Total"
      @ PRow() + 1, 01 SAY QTFUN                  PICT "9999"
      @ PRow(), 21    SAY RESTO                  PICT "@E 999,999,999.99"
      @ PRow(), 37    SAY TODIS                  PICT "@E 999,999,999,999.99"
      @ PRow(), 57    SAY TOTAL                  PICT "@E 999,999,999,999.99"
      @ PRow() + 1, 00 SAY REPL( "=", 132 )
      LIN := 80
   ENDIF
   RETU .T.
// : FIM: FOCJ.PRG

// + EOF: focj.prg
// +
