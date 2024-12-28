// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bz1.prg
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
// +    Documentado em 28-Dez-2024 as 10:47 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
// +
// +    Source Module => J:\ITAESBRA\M_BZ1.PRG
// +
// +    Functions: Function MBZ101()
// +               Function MBZ102()
// +               Function MBZCAB()
// +
// +    Reformatted by Click! 2.03 on Oct-4-2004 at  4:44 pm
// +
// +²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

// #INCLUDE "COMANDO.CH"

// Modo de Trabalho no Video
MDI( " þ Imprimir Fluxo Financeiro Dia a Dia " )

DODIA  := ATEDIA := ZDATA
DODI2  := ATEDI2 := ZDATA
SALANT := 0.00
CTLIN  := NRCOPIA := 1
VEZES  := 0
TIPOPG := "V"
TIPORC := "V"
cANAL  := "N"

@ 20, 50 SAY "(V)encimento (D)Data Documento"
@ 21, 00 SAY 'Pagar do Dia   : '              GET DODIA
@ 21, 32 SAY 'At‚ o Dia    : '                GET ATEDIA
@ 21, 60 SAY 'Tipo     :'                     GET TIPOPG  PICT "!"               VALID TIPOPG $ "VD"
@ 22, 00 SAY 'Receber do Dia : '              GET DODI2
@ 22, 32 SAY 'At‚ o Dia    : '                GET ATEDI2
@ 22, 60 SAY 'Tipo     :'                     GET TIPORC  PICT "!"               VALID TIPORC $ "VD"
@ 23, 00 SAY 'Saldo Anterior : '              GET SALANT  PICT '@E 999999999.99'
@ 23, 32 SAY 'Numero Copias:'                 GET NRCOPIA
@ 23, 60 SAY 'Analitico:'                     GET cANAL   PICT "!"               VALID cANAL $ "SN"
IF !READCUR()
RETU .F.
ENDIF

aRETU  := PERFEC( { "ML01", "MN01" }, { "ML", "MN" }, { "ML99", "MN99" } )
cARQPG := aRETU[ 5, 1 ]
cARQRC := aRETU[ 5, 2 ]
cCAB   := aRETU[ 7 ]

lCOLTOT2 := .F.
lCOM     := MDG( "Comprimido" )
MDS( 'Zerando Arquivo Fluxo Financeiro' )
ZAPARQ( { { "MZ01", .F., .F. } } )
initvars()
clrvars()
IF !USEREDE( "MF01", 1, 1 )
dbCloseAll()
RETU .F.
ENDIF

IF cARQPG = "ML01"
IF MDG( "Incluir Contas a Pagar" )
MDS( 'Carregando o Contas a Pagar' )
MBZ101( cARQPG, "ML01" )
ENDIF
IF MDG( "Incluir Contas a Receber" )
MDS( 'Carregando o Contas a Receber' )
MBZ101( cARQRC, "MN01" )
ENDIF
IF MDG( "Incluir Contas Pagas" )
MDS( 'Carregando o Contas Pagas' )
MBZ101( "ML01PG", "ATUMLPG" )
lCOLTOT2 := .T.
ENDIF
IF MDG( "Incluir Contas Recebidas" )
MDS( 'Carregando o Contas Recebidas' )
MBZ101( "MN01PG", "ATUMNPG" )
lCOLTOT2 := .T.
ENDIF
ELSE
IF MDG( "Incluir Contas Pagas" )
MDS( 'Carregando o Contas Pagas' )
MBZ101( cARQPG, "MLPG" )
ENDIF
IF MDG( "Incluir Contas Recebidas" )
MDS( 'Carregando o Contas Recebidas' )
MBZ101( cARQRC, "MNPG" )
ENDIF
ENDIF

dbSelectAr( "MZ01" )
dbGoTop()
IF Eof()
dbCloseAll()
ALERTX( "N„o h  Movimenta‡„o Para Imprimir !" )
RETU .T.
ENDIF

IF !CHECKIMP( 0 )
RETU .F.
ENDIF
cEMP := IMP( "ZEMP" )

IMPRESSORA()
IF Lcom
@  0, 0 SAY IMPSTR( aCHR[ 1 ] )
ENDIF

WHILE VEZES < NRCOPIA
VEZES++
CTLIN   := 80
ZPAGINA := 0
TOTSAL  := SALANT
TOTSA2  := SALANT
TOT1    := TOT2 := TOT3 := 0.00
TOB1    := TOB2 := TOB3 := 0.00
dbGoTop()
WHILE !Eof()

xVENC  := VENCIMENT   // Guarda data de Vencimento em Var Auxiliar
TOTREC := TOTPAG := 0.00
TOTRE2 := TOTPA2 := 0.00

WHILE VENCIMENT = xVENC .AND. !Eof()
DO CASE
CASE DEBCRE = 'C'
TOTREC += VALORS  // totaliza valor a receber por dia
TOT1   += VALORS
TOT3   += VALORS
CASE DEBCRE = 'D'
TOTPAG += VALORS  // totaliza valor a pagar por dia
TOT2   += VALORS
TOT3   -= VALORS
CASE DEBCRE = 'N'
TOTRE2 += VALORS  // totaliza valor a receber por dia
TOB1   += VALORS
TOB3   += VALORS
CASE DEBCRE = 'L'
TOTPA2 += VALORS  // totaliza valor a pagar por dia
TOB2   += VALORS
TOB3   -= VALORS
ENDCASE
IF cANAL = "S"
MBZCAB()
@ CTLIN, 0  SAY NRNOTA
@ CTLIN, 9  SAY DATA
@ CTLIN, 20 SAY CLIENTE
@ CTLIN, 29 SAY COGNOME
@ CTLIN, 45 SAY VENCIMENT
@ CTLIN, 56 SAY VALORS
CTLIN++
ENDIF
dbSkip()
ENDDO

TOTSAL += TOTREC
TOTSAL -= TOTPAG
TOTSA2 += TOTRE2
TOTSA2 -= TOTPA2

MBZCAB()

@ CTLIN, 000 SAY xVENC
MBZ102( TOTREC, 10 )
MBZ102( TOTPAG, 25 )
MBZ102( TOTSAL, 40 )

IF lCOLTOT2
MBZ102( TOTRE2, 55 )
MBZ102( TOTPA2, 70 )
MBZ102( TOTSA2, 85 )
MBZ102( TOTSA2 - TOTSAL, 100 )
ENDIF

CTLIN++
@ CTLIN, 000 SAY repl( '-', 132 )
CTLIN++
ENDDO
@ CTLIN, 0 SAY repl( '_', 132 )
CTLIN++
@ CTLIN, 000 SAY "Totais"
MBZ102( TOT1, 10 )
MBZ102( TOT2, 25 )
MBZ102( TOT3, 40 )

IF lCOLTOT2
MBZ102( TOB1, 55 )
MBZ102( TOB2, 70 )
MBZ102( TOB3, 85 )
MBZ102( TOB3 - TOT3, 100 )
ENDIF

CTLIN++
@ CTLIN, 0 SAY repl( '_', 132 )
CTLIN++
ENDDO
VIDEO()
dbCloseAll()
RELEASE ALL LIKE M *
IMPEND()
RETU

// +±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// +
// +    Function MBZ101()
// +
// +    Called from ( m_bz1.prg    )   6 -
// +
// +±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBZ101()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MBZ101( cARQ, cTIPO )

   LOCAL nDINI
   LOCAL nDFIM

   nDINI := DODIA
   nDFIM := ATEDIA
   cVAR  := "VENCIMENT"

   IF cTIPO = "MN01"
      nDINI := DODI2
      nDFIM := ATEDI2
      IF TIPORC = "D"
         cVAR := "DATA"
      ENDIF
   ELSE
      IF TIPOPG = "D"
         cVAR := "DATA"
      ENDIF
   ENDIF
   IF !USEREDE( cARQ, 1, 1 )   // Contas a Pagar
      dbCloseAll()
      RETU
   ENDIF
   INITVARS()
   CLRVARS()
   dbGoTop()
   WHILE !Eof()
      IF ( cTIPO = "MLPG" .OR. cTIPO = "MNPG" ) .OR. ( &cVAR. >= nDINI .AND. ( &cVAR. ) <= nDFIM )
         EQUVARS()
         DO CASE
         CASE cTIPO = "MLPG" .OR. cTIPO = "ATUMLPG"
            @ 24, 70 SAY NRNOTA
            EQUVARS()
            mVALOR   := mVALOR
            mCLIENTE := mFORNECEDO
            mVALORS  := mVALORPG
            IF cTIPO = "MLPG"
               mDEBCRE := 'D'
            ELSE
               mDEBCRE := 'L'
            ENDIF
            mVENCIMENT := mDATAPG
         CASE cTIPO = "MNPG" .OR. cTIPO = "ATUMNPG"
            @ 24, 70 SAY NUMERO
            mVALOR   := VALOR
            mCLIENTE := mFORNECEDO
            mVALORS  := VALORPG
            mNRNOTA  := mNUMERO
            IF cTIPO = "MNPG"
               mDEBCRE := 'C'
            ELSE
               mDEBCRE := 'N'
            ENDIF
            mVENCIMENT := mDATAPG
         CASE cTIPO = "ML01"
            @ 24, 70 SAY NRNOTA
            EQUVARS()
            mVALOR   := VALOR
            mCLIENTE := mFORNECEDO
            mVALORS  := VALATUAL
            mDEBCRE  := 'D'
            DO CASE
            CASE DoW( VENCIMENT ) = 1  // Se cai no Domingo
               mVENCIMENT := VENCIMENT + 1   // 2   vai para segunda
            CASE DoW( VENCIMENT ) = 7  // Se cai no S bado
               mVENCIMENT := VENCIMENT + 2   // 3   vai para segunda
            OTHERWISE
               mVENCIMENT := VENCIMENT
            ENDCASE
         CASE cTIPO = "MN01"
            @ 24, 70 SAY NUMERO
            mVALOR   := VALOR
            mCLIENTE := mFORNECEDO
            mVALORS  := VALATUAL
            mNRNOTA  := mNUMERO
            mDEBCRE  := 'C'
            mBANCO   := StrZero( BANCO, 3 )
            // Banco 99 carteira mesmo dia
            lDIA := .F.
            IF BANCO = 99
               lDIA := .T.
            ENDIF
            dbSelectAr( "MF01" )
            dbGoTop()
            IF dbSeek( mBANCO )
               IF FLUXODIA = "S"   // mesmo dia
                  lDIA := .T.
               ENDIF
            ENDIF
            dbSelectAr( carq )
            DO CASE
            CASE DoW( VENCIMENT ) = 1 .AND. !lDIA  // Se cai no Domingo
               mVENCIMENT := VENCIMENT + 2
            CASE DoW( VENCIMENT ) = 7 .AND. !lDIA  // Se cai no S bado
               mVENCIMENT := VENCIMENT + 3
            CASE DoW( VENCIMENT ) = 6 .AND. !lDIA  // Se cai na Sexta-Feira
               mVENCIMENT := VENCIMENT + 3
            CASE DoW( VENCIMENT ) = 1 .AND. lDIA   // Se cai no Domingo Segunda
               mVENCIMENT := VENCIMENT + 1
            CASE DoW( VENCIMENT ) = 7 .AND. lDIA   // Se cai no Sabado Segunda
               mVENCIMENT := VENCIMENT + 2
            OTHERWISE  // Outros casos,  acrescenta
               IF !lDIA
                  mVENCIMENT := VENCIMENT + 1  // mais um dia no vencimento
               ENDIF
            ENDCASE
         ENDCASE
         NOVOOPA( "MZ01", .T., .T. )
      ENDIF
      dbSelectAr( cARQ )
      dbSkip()
   ENDDO
   dbSelectAr( cARQ )
   dbCloseArea()

// +±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// +
// +    Function MBZ102()
// +
// +    Called from ( m_bz1.prg    )  14 -
// +
// +±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBZ102()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MBZ102( nVALOR, nROW )

   IF nVALOR > 0
      nROW++
      @ CTLIN, nROW SAY trans( nVALOR, '@E 999999,999.99' )
   ENDIF
   IF nVALOR < 0
      @ CTLIN, nROW SAY "(" + trans( Abs( nVALOR ), '@E 999999,999.99' ) + ")"
   ENDIF

// +±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// +
// +    Function MBZCAB()
// +
// +    Called from ( m_bz1.prg    )   2 -
// +
// +±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBZCAB()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MBZCAB()

   IF CTLIN > 55
      ZPAGINA++
      @  0, 0  SAY cEMP
      @  1, 01 SAY 'M_BZ1'
      IF cARQPG = "ML01"
         @  1, 20 SAY 'FLUXO FINANCEIRO (A Receber/ A Pagar)'
      ELSE
         @  1, 20 SAY 'FLUXO FINANCEIRO (Recebidas/Pagas)'
      ENDIF
      @  1, 80  SAY Time()
      @  1, 90  SAY 'Emitida em: ' + DToC( ZDATA )
      @  1, 110 SAY ACENTO( '    P gina: ' ) + Str( ZPAGINA, 2 )
      @  2, 0   SAY repl( '-', 132 )
      @  3, 3   SAY 'Saldo Anterior : '
      @  3, 20  SAY SALANT                                PICT '@E 99999,999.99'
      @  4, 00  SAY 'DIA'
      IF cARQPG = "ML01"
         @  4, 010 SAY 'A  Receber'
         @  4, 025 SAY 'A  Pagar'
         @  4, 040 SAY 'Saldo'
         IF lCOLTOT2
            @  4, 055 SAY 'Recebidas'
            @  4, 070 SAY 'Pagas'
            @  4, 085 SAY 'Saldo'
            @  4, 100 SAY 'Dif Saldo'
         ENDIF
      ELSE
         @  4, 010 SAY 'Recebidas'
         @  4, 025 SAY 'Pagas'
         @  4, 040 SAY 'Saldo'
      ENDIF
      @ 05, 0 SAY repl( '-', 132 )
      CTLIN := 6
   ENDIF

// + EOF: M_BZ1.PRG

// + EOF: m_bz1.prg
// +
