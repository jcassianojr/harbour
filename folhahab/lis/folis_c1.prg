// +--------------------------------------------------------------------
// +
// +    Programa  : folis_c1.prg  ProvisAo de 13o. Contabil
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +--------------------------------------------------------------------
// +


function folis_c1()
IF !MDL( 'Listar 13§ Provis„o', 0 )
RETU
ENDIF
DIARFE := Date()
MDS( 'Qual a data de referencia' )
@ 24, 40 GET DIARFE
READCUR()
ANOFIM    := Year( DIARFE )
MESFIM    := Month( DIARFE )
DIAFIM    := Day( DIARFE )
FILTRO    := ""
lPRIMEIRA := MDG( "Abater Primeira Parcela 13o. Sal rio" )
lGRAVA    := MDG( "Gravar Resultados- Apura‡„o Contabil" )
lANAL     := MDG( "Deseja Resumo Analitico" )
IF MDG( "Incluir Demitidos Mes" )
FILTRO := '(EMPTY(DEMITIDO).OR.(MONTH(DEMITIDO)>=MONTH(DIARFE).AND.YEAR(DEMITIDO)>=YEAR(DIARFE)))'
ELSE
FILTRO := 'EMPTY(DEMITIDO)'
ENDIF


FL       := CODFPAS := TOTENC := TOTALAVO := TOTALVAL := 0
TOTALTER := TOTALENC := TOTALE := INSSDESC := 0


VERSEHA( "FIRMA", "", NREMP,,, .F., { { "FPAS", "CODFPAS" } } )
VERSEHA( "CONFINSS",, Val( CODFPAS ),,, .F., { { "EMPRESA+TOTAL+ACIDENTE+8", "TOTENC" } } )


MDS( 'Encargos Calculados Pelo Computador' )
@ 24, 40 GET TOTENC
READCUR()
TOTENC := TOTENC / 100

aXCON := PEGRELCTA( "PROV13" )


IF !NETUSE( pes )
dbCloseAll()
RETU
ENDIF
FILTRO := ''
INX    := ""
FILORD( .T. )
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
IF ValType( INX ) = "N"
dbSetOrder( INX )
ELSE
ordDestroy( "temp" )
ordCreate(, "temp", inx )
ordSetFocus( "temp" )
ENDIF
SET FILTER TO &FILTRO

IF MDG( 'Deseja Digitar Sal rio Vari vel' )
dbSelectAr( PES )
dbGoTop()
WHILE !Eof()
PETELA( 8 )
NETRECLOCK()
MDS( 'Digite o vari vel para o Funcionario Acima' )
@ 24, 50 GET SALVAR13S PICT '###,###,###,###.##'
READCUR()
dbUnlock()
dbSkip()
ENDDO
ENDIF

IF lPRIMEIRA
IF File( PATHX + "\FO_FP13A.DBF" )
IF !NETUSE( "FO_FP13A" )
dbCloseAll()
RETU
ENDIF
ELSE
IF !NETUSE( F13 )   // competencias antigas
dbCloseAll()
RETU .F.
ENDIF
ENDIF
cSELE2 := Alias()
ENDIF

IF lGRAVA
IF !NETUSE( "PROV13" )
dbCloseAll()
RETU .F.
ENDIF
nLASTREC := LastRec()
MDS( "Aguarde Preparando Arquivo Acumulado" )
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| ANO = MESFIM .AND. MES = MESFIM }, {|| zei_fort( nLASTREC,,, 1 ) } )
dbCloseArea()
NETPACK( "PROV13" )
ENDIF

IF !NETUSE( FOL )
dbCloseAll()
RETU .F.
ENDIF


aTOTGER := { 0, 0, 0, 0, 0, 0 }
CTLIN   := 80
LISTARUE( {| X | FOLISC1( X ) }, {|| FOLISC1B() } )
return



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOLISC1B()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC FOLISC1B

   IF !lANAL
      CTLIN++
      @ CTLIN, 40 SAY 'Total Geral '
      @ CTLIN, 58 SAY aTOTGER[ 1 ]     PICT '99999'
      @ CTLIN, 68 SAY aTOTGER[ 2 ]     PICT '@E 9999,999,999.99'
      @ CTLIN, 84 SAY aTOTGER[ 3 ]     PICT '@E 9999,999,999.99'
      IF lPRIMEIRA
         @ CTLIN, 100 SAY aTOTGER[ 4 ] PICT '@E 9999,999,999.99'
      ENDIF
      @ CTLIN, 116 SAY aTOTGER[ 5 ] PICT '@E 9999,999,999.99'
      IF aTOTGER[ 6 ] > 0
         CTLIN++
         @ CTLIN, 0  SAY 'Valor Pagos'
         @ CTLIN, 68 SAY aTOTGER[ 6 ]    PICT '@E 9999,999,999.99'
      ENDIF
      IMPFOL()
   ENDIF
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOLISC1A()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOLISC1A( lCAB )

   FL++
   @  0, 0   SAY IF( IM1 = 'A', IMPSTR( cIMPCOM ), IMPSTR( cIMPEXP ) )
   @  2, 20  SAY IMPCHR( cIMPTIT ) + MSG2
   @  3, 120 SAY 'FL. ' + StrZero( FL, 4 )
   @  4, 110 SAY 'DATA =>' + DToC( DXDIA )
   @  5, 0   SAY REPL( '-', 132 )
   IF lCAB
      DO CASE
      CASE KEY = 1
         @  6, 00 SAY IMPCHR( cIMPTIT ) + ACENTO( 'PROVISAO DE 13o Salario: ' + NOMSETOR + " " + DToC( DIARFE ) )
      CASE KEY = 2
         @  6, 00 SAY IMPCHR( cIMPTIT ) + ACENTO( 'PROVISAO DE 13o Salario: ' + Str( DEP ) + ' ' + NOMSETOR + " " + DToC( DIARFE ) )
      CASE KEY = 3
      CASE KEY = 4
      ENDCASE
   ELSE
      @  6, 00 SAY IMPCHR( cIMPTIT ) + ACENTO( 'PROVISŽO DE 13o Sal rio: ' ) + DToC( DIARFE )
   ENDIF
   @  7, 0  SAY REPL( '-', 132 )
   @  8, 0  SAY 'NUM'
   @  8, 6  SAY 'NOME'
   @  8, 34 SAY ACENTO( 'SALRIO+VARIVEL' )
   @  8, 51 SAY ACENTO( 'ADMISSŽO' )
   @  8, 62 SAY 'AVOS'
   @  8, 80 SAY 'VALOR'
   @  8, 93 SAY 'ENCARGOS'
   IF lPRIMEIRA
      @  8, 108 SAY '1a. Parcela'
   ENDIF
   @  8, 124 SAY 'TOTAL'
   @  9, 0   SAY REPL( '-', 132 )
   CTLIN := 10
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOLISC1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOLISC1

   PARA COMPARE

   TOTALIZA := .F.
   TOTALDES := TOTALPRI := TOTALAVO := TOTALENC := TOTALVAL := 0
   IF lANAL
      CTLIN := 80
   ENDIF
   dbSelectAr( PES )
   dbGoTop()
   WHILE !Eof()
      IF &COMPARE
         TOTALIZA := .T.
         IF CTLIN > 55 .AND. lANAL
            FOLISC1A( .T. )
         ENDIF
         AVOS := VALOR := 0
         IF Year( ADMITIDO ) = ANOFIM .AND. Month( ADMITIDO ) > MESFIM
            dbSkip()
            LOOP
         ENDIF
         IF Year( ADMITIDO ) < ANOFIM
            AVOS := MESFIM
         ENDIF
         IF Year( ADMITIDO ) = ANOFIM
            AVOS := MESFIM - Month( ADMITIDO )
            IF DIAFIM - Day( ADMITIDO ) + 1 > 14
               AVOS++
            ENDIF
         ENDIF
         IF !Empty( DEMITIDO )
            IF Day( DEMITIDO ) < 15
               AVOS--
            ENDIF
         ENDIF
         mDEMITIDO := DEMITIDO
         SALH      := SALM := VAR1 := 0
         SALHM()
         VALORPRI   := 0   // Valor 1a. Parcela
         mSALVAR13S := SALVAR13S
         IF lPRIMEIRA
            CTR := NUMERO
            dbSelectAr( cSELE2 )
            VALORPRI := VALCTA( CTR, 460 )
            dbSelectAr( PES )
         ENDIF
         VALOR    := ( SALM + mSALVAR13S ) * AVOS / 12
         TOTALE   := Round( VALOR * TOTENC, 2 )
         TOTAL    := TOTALE + VALOR - VALORPRI
         TOTALAVO += AVOS
         TOTALVAL += VALOR
         TOTALENC += TOTALE
         TOTALPRI += VALORPRI
         IF lANAL
            CTLIN++
            @ CTLIN, 0  SAY NUMERO
            @ CTLIN, 6  SAY NOME
            @ CTLIN, 36 SAY SALM + SALVAR13S  PICT '@E 999,999,999.99'
            @ CTLIN, 51 SAY ADMITIDO
            @ CTLIN, 61 SAY StrZero( AVOS, 2 )
            @ CTLIN, 68 SAY VALOR           PICT '@E 9999,999,999.99'
            @ CTLIN, 84 SAY TOTALE          PICT '@E 9999,999,999.99'
            IF lPRIMEIRA
               @ CTLIN, 100 SAY VALORPRI PICT '@E 9999,999,999.99'
            ENDIF
            @ CTLIN, 116 SAY TOTAL PICT '@E 9999,999,999.99'
         ENDIF
         mNUMERO := NUMERO
         IF lGRAVA
            mSALVAR := SALVAR13S
            mDEPTO  := DEPTO
            mSETOR  := SETOR
            mSECAO  := SECAO
            mAVOS   := AVOS
            mVALOR  := VALOR
            dbSelectAr( "PROV13" )
            dbGoTop()
            IF !dbSeek( StrZero( mNUMERO, 8 ) + StrZero( ANOFIM, 4 ) + StrZero( MESFIM, 2 ) )
               NETRECAPP()
               FIELD->NUMERO := mNUMERO
               FIELD->MES    := MESFIM
               FIELD->ANO    := ANOFIM
            ELSE
               NETRECLOCK()
            ENDIF
            FIELD->SALARIO := SALM
            FIELD->SALVAR  := mSALVAR
            FIELD->AVOS    := mAVOS
            FIELD->DEPTO   := mDEPTO
            FIELD->SETOR   := mSETOR
            FIELD->SECAO   := mSECAO
            FIELD->VALOR   := mVALOR
            FIELD->VALENC  := TOTALE
            FIELD->VALTOT  := mVALOR + TOTALE
            FIELD->VALPRI  := VALORPRI
            FIELD->VALLIQ  := mVALOR + TOTALE - VALORPRI
            dbUnlock()
         ENDIF
         dbSelectAr( FOL )
         nDESCONTA := 0
         FOR W := 1 TO 15
            IF !Empty( aXCON[ W ] )
               dbGoTop()
               IF dbSeek( mNUMERO * 10000 + aXCON[ W ] )
                  nDESCONTA += VALOR
               ENDIF
            ENDIF
         NEXT W
         IF nDESCONTA > 0
            IF lANAL
               CTLIN++
               @ CTLIN, 6 SAY "Pago"
               IF !Empty( mDEMITIDO )
                  @ CTLIN, 15 SAY "Demitido:" + DToC( mDEMITIDO )
               ENDIF
               @ CTLIN, 68 SAY nDESCONTA PICT '@E 9999,999,999.99'
            ENDIF
            TOTALDES += nDESCONTA
         ENDIF
      ENDIF
      dbSelectAr( PES )
      dbSkip()
   ENDDO
   IF TOTALIZA
      IF !lANAL .AND. CTLIN > 55
         FOLISC1A( .F. )
      ENDIF
      TOTAL := TOTALVAL + TOTALENC
      IF lANAL
         CTLIN++
         @ CTLIN, 0 SAY REPL( '-', 132 )
      ENDIF
      CTLIN++
      IF !lANAL
         DO CASE
         CASE KEY = 1
            @ CTLIN, 0 SAY NOMSETOR
         CASE KEY = 2
            @ CTLIN, 0 SAY Str( DEP ) + " - " + NOMSETOR
         ENDCASE
      ENDIF
      @ CTLIN, 49 SAY 'Total '
      @ CTLIN, 58 SAY Str( TOTALAVO, 5 )
      @ CTLIN, 68 SAY TOTALVAL        PICT '@E 9999,999,999.99'
      @ CTLIN, 84 SAY TOTALENC        PICT '@E 9999,999,999.99'
      IF lPRIMEIRA
         @ CTLIN, 100 SAY TOTALPRI PICT '@E 9999,999,999.99'
      ENDIF
      @ CTLIN, 116 SAY TOTAL - TOTALPRI PICT '@E 9999,999,999.99'
      IF TOTALDES > 0
         CTLIN++
         @ CTLIN, 0  SAY 'Valor Pagos'
         @ CTLIN, 68 SAY TOTALDES      PICT '@E 9999,999,999.99'
      ENDIF
      CTLIN++
      @ CTLIN, 0 SAY REPL( '-', 132 )
      IF lANAL
         IMPFOL()
      ENDIF
      aTOTGER[ 1 ] += TOTALAVO
      aTOTGER[ 2 ] += TOTALVAL
      aTOTGER[ 3 ] += TOTALENC
      aTOTGER[ 4 ] += TOTALPRI
      aTOTGER[ 5 ] += TOTAL - TOTALPRI
      aTOTGER[ 6 ] += TOTALDES
   ENDIF
   RETU


// : FIM: FOLIS_C1.PRG

// + EOF: folis_c1.prg
// +
