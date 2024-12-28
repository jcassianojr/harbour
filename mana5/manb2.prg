// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : manb2.prg
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


COD := ZCODIGO := MCODIGO

DO CASE
CASE ARQRE1 = "MANRE1"
IF !PEGACS( "R", "M" + ZCODIGO + ZUSER, .T., "Relatorio nao liberado" )
RETU .F.
ENDIF
CASE ARQRE1 = "PADRE1"
IF !PEGACS( "R", "P" + ZCODIGO + ZUSER, .T., "Relatorio nao liberado" )
RETU .F.
ENDIF
OTHERWISE
ALERTX( "Arquivos de Relatorios N„o Configurado" )
RETU .F.
ENDCASE

GRAVAMVAR( ARQREL, mMENU + mCODIGO, { "ACESSOS", "DATAULT" }, { "ACESSOS+1", "ZDATA" } )

IF mFOLHA = 999   // Relatorios em Prgs
DO &mCODIGO
ENDIF

DODIA      := bom( ZDATA )
ATEDIA     := eom( ZDATA )
COPIAS     := 1
ZCOD1      := ZCODIGO1 := mCODIGO1
DESC       := mNOME
ZDESCRICAO := Trim( MNOME_LISTA )
PROG       := mSETUP
LINHAS     := mFOLHA
ALT        := mALTURA
LARG       := mLARGURA
COL        := mCOLUNAS
FIL        := Trim( mFILTRO )
ETIQ       := mETIQ
MARQ1      := AllTrim( mARQUIVO1 )
MARQ2      := AllTrim( mARQUIVO2 )
MARQ3      := AllTrim( mARQUIVO3 )
MARQ4      := AllTrim( mARQUIVO4 )
MARQ5      := AllTrim( mARQUIVO5 )
MARQ6      := AllTrim( mARQUIVO6 )
INDI1      := mINDICE1
INDI2      := mINDICE2
INDI3      := mINDICE3
INDI4      := mINDICE4
INDI5      := mINDICE5
INDI6      := mINDICE6
R1A        := mREL1ARQ
R2A        := mREL2ARQ
R3A        := mREL3ARQ
R4A        := mREL4ARQ
REL1       := mRELACAO1
REL2       := mRELACAO2
REL3       := mRELACAO3
REL4       := mRELACAO4
QBR1A      := mQUEBRA1A
QBR1B      := mQUEBRA1B
QBR1C      := mQUEBRA1C
QBR1D      := mQUEBRA1D
QBR1E      := mQUEBRA1E
QBR2A      := mQUEBRA2A
QBR2B      := mQUEBRA2B
QBR2C      := mQUEBRA2C
QBR2D      := mQUEBRA2D
QBR2E      := mQUEBRA2E
QBR3A      := mQUEBRA3A
QBR3B      := mQUEBRA3B
QBR3C      := mQUEBRA3C
QBR3D      := mQUEBRA3D
QBR3E      := mQUEBRA3E
QBR4A      := mQUEBRA4A
QBR4B      := mQUEBRA4B
QBR4C      := mQUEBRA4C
QBR4D      := mQUEBRA4D
QBR4E      := mQUEBRA4E
QBR5A      := mQUEBRA5A
QBR5B      := mQUEBRA5B
QBR5C      := mQUEBRA5C
QBR5D      := mQUEBRA5D
QBR5E      := mQUEBRA5E
FAT1       := mFATOR1
FAT2       := mFATOR2
FAT3       := mFATOR3
FAT4       := mFATOR4
FAT5       := mFATOR5
DES1       := mDESCRICA1
DES2       := mDESCRICA2
DES3       := mDESCRICA3
DES4       := mDESCRICA4
DES5       := mDESCRICA5
TAM1       := mTAM1
TAM2       := mTAM2
TAM3       := mTAM3
TAM4       := mTAM4
TAM5       := mTAM5
DEFA       := IF( mDEFAULT = 0, 1, mDEFAULT )
AREA       := "mARQ" + IF( mSELECAO > 9, Str( mSELECAO, 2 ), Str( mSELECAO, 1 ) )
FATOR      := FATOR_AUX := CTR1 := CTR2 := 0.00
aTOTAL     := Array( 20 )
AFill( aTOTAL, 0 )


@  5, 1 CLEA TO 22, 78
@  5, 6 SAY COD + ' ' + DESC
SET COLOR TO
@  8, 0 CLEAR
@  8, 33 TO 11, 46 DOUBLE
OPCAO( 09, 35, " &Imprimir ", 73 )
OPCAO( 10, 35, "  &Exibir  ", 69 )
OPCAO3 := MENU(, 0 )


IF mARQ2 = "MI01"
nMESREF := Month( ZDATA )
MDS( "Digite o Mes de Referencia" )
@ 23, 40 GET nMESREF
IF !READCUR()
RETU .F.
ENDIF
ENDIF

// Ajustando Atrasos Contas a Pagar
IF mARQ1 == "ML01"
IF mdg( "Ajustar Atrasos Contas a Pagar" )
CRIARVARS( "ML01" )
IF !USEREDE( "ML01", 1, 99 )
RETU .F.
ENDIF
dbGoTop()
WHILE !Eof()
EQUVARS()
MAL01( .F. )
netreclock()
FIELD->JUROS     := mJUROS
FIELD->DIAS      := mDIAS
FIELD->DIFERENCA := mDIFERENCA
FIELD->VALATUAL  := mVALATUAL
FIELD->PREVATR   := mPREVATR
dbUnlock()
dbSkip()
ENDDO
dbCloseArea()
ENDIF
ENDIF

// Ajustando Atrasos Contas a Receber
IF mARQ1 == "MN01"
IF mdg( "Ajustar Atrasos Contas a Receber" )
CRIARVARS( "MN01" )
IF !USEREDE( "MN01", 1, 99 )
RETU .F.
ENDIF
dbGoTop()
WHILE !Eof()
EQUVARS()
MAN01( .F. )
netreclock()
FIELD->JUROS     := mJUROS
FIELD->DIAS      := mDIAS
FIELD->DIFERENCA := mDIFERENCA
FIELD->VALATUAL  := mVALATUAL
FIELD->PREVATR   := mPREVATR
dbUnlock()
dbSkip()
ENDDO
dbCloseArea()
ENDIF
ENDIF


// Montando o Fluxo
IF Trim( mGRUPO ) = 'MZ'
FLUXO()
ENDIF

// Filtro de Dados
FILTRO := ''
IF !Empty( FIL )
FILTRO := FIL
ENDIF
FILTRO := RFILORD( MARQ1, .F., FILTRO, DEFA )



// Ajustas Meses j  Fechados
cSTRFEC := "  "
cSTRFEC := OBTER( "MANFEC", mARQ1, "STRDES" )
IF !Empty( cSTRFEC )
IF ! mdg( "Mˆs Corrente?" )
cUSO  := MESANO()
mARQ1 := cSTRFEC + cUSO
IF !Empty( mARQ2 )
mARQ2 := OBTER( "MANFEC", mARQ2, "STRDES" ) + cUSO
ENDIF
ENDIF
ENDIF



// Acumala Anual
cSTRANU  := "  "
cSTRANU2 := "  "
cSTRATU  := Space( 8 )
cSTRBAI  := Space( 8 )
cCAMDAT  := Space( 10 )
cCAMDA2  := Space( 10 )
IF PEGACAMPO( "MANFEC", "mARQ1", { "STRANO", "STRDES", "STRATU", "STRBAI", "CAMDAT", "CAMDA2" }, { "cSTRANU", "cSTRANU2", "cSTRATU", "cSTRBAI", "cCAMDAT", "cCAMDA2" }, 2 )
IF mdg( "Reacumular" )
SOMAANO( cSTRANU, cSTRANU2,,, cSTRATU, cCAMDAT, cSTRBAI, cCAMDA2 )
ENDIF
ENDIF


// Receber+Recebidas
IF mARQ1 == "MN99"
CRIARVARS( "MN01" )
tFILTRO1 := ""
tFILTRO2 := ""
MDS( "Grupo de dados Para Contas a Receber" )
RFILORD( "MN01", .F., tFILTRO1 )
MDS( "Grupo de dados Para Contas Recebidas" )
RFILORD( "MN01PG", .F., tFILTRO2 )
ZAPARQ( { { "MN99", .F., .T. } } )
mCREDEB := "C"
IF !USEREDE( "MN01", 1, 1 )
dbCloseAll()
RETU .F.
ENDIF
IF !Empty( tFILTRO1 )
SET FILTER TO &tFILTRO1
ENDIF
dbGoTop()
WHILE !Eof()
EQUVARS()
NOVOOPA( "MN99" )
dbSelectAr( "MN01" )
dbSkip()
ENDDO
mCREDEB := "D"
dbCloseArea()
IF !USEREDE( "MN01PG", 1, 1 )
dbCloseAll()
RETU .F.
ENDIF
IF !Empty( tFILTRO2 )
SET FILTER TO &tFILTRO2
ENDIF
dbGoTop()
WHILE !Eof()
EQUVARS()
NOVOOPA( "MN99" )
dbSelectAr( "MN01PG" )
dbSkip()
ENDDO
dbCloseAll()
ENDIF



IF mARQ1 == "ME04"
IF !USEREDE( "ME04", 1, 99 )
RETU .F.
ENDIF
dbGoTop()
WHILE !Eof()
IF !Empty( CALULT ) .AND. !Empty( CALIBRAR )
netgrvcam( "CALPRO", ADDMONTH( CALULT, CALIBRAR ) )
ENDIF
dbSkip()
ENDDO
dbCloseArea()
ENDIF


// Apagar+Pagas
IF mARQ1 == "ML99"
CRIARVARS( "ML01" )
tFILTRO1 := ""
tFILTRO2 := ""
MDS( "Grupo de dados Para Contas a Pagar" )
RFILORD( "ML01", .F., tFILTRO1 )
MDS( "Grupo de dados Para Contas Pagas" )
RFILORD( "ML01PG", .F., tFILTRO2 )
ZAPARQ( { { "ML99", .F., .T. } } )
mCREDEB := "C"
IF !USEREDE( "ML01", 1, 1 )
dbCloseAll()
RETU .F.
ENDIF
IF !Empty( tFILTRO1 )
SET FILTER TO &tFILTRO1
ENDIF
dbGoTop()
WHILE !Eof()
EQUVARS()
NOVOOPA( "ML99" )
dbSelectAr( "ML01" )
dbSkip()
ENDDO
mCREDEB := "D"
dbCloseArea()
IF !USEREDE( "ML01PG", 1, 1 )
dbCloseAll()
RETU .F.
ENDIF
IF !Empty( tFILTRO2 )
SET FILTER TO &tFILTRO2
ENDIF
dbGoTop()
WHILE !Eof()
EQUVARS()
NOVOOPA( "ML99" )
dbSelectAr( "ML01PG" )
dbSkip()
ENDDO
dbCloseAll()
ENDIF



// Abrindo os Arquivos
IF !Empty( mARQ1 )
IF mPIND1 = "S"
INDI1 := NUMIND( mARQ1, INDI1 )
ENDIF
IF !USEREDE( mARQ1, 1, INDI1 )
dbCloseAll()
RETU .F.
ENDIF
ENDIF
IF !Empty( mARQ2 )
IF mPIND2 = "S"
INDI2 := NUMIND( mARQ2, INDI2 )
ENDIF
IF !USEREDE( mARQ2, 1, INDI2 )
dbCloseAll()
RETU .F.
ENDIF
ENDIF
IF !Empty( mARQ3 )
IF mPIND3 = "S"
INDI3 := NUMIND( mARQ3, INDI3 )
ENDIF
IF !USEREDE( mARQ3, 1, INDI3 )
dbCloseAll()
RETU .F.
ENDIF
ENDIF
IF !Empty( mARQ4 )
IF mPIND4 = "S"
INDI4 := NUMIND( mARQ4, INDI4 )
ENDIF
IF !USEREDE( mARQ4, 1, INDI4 )
dbCloseAll()
RETU .F.
ENDIF
ENDIF
IF !Empty( mARQ5 )
IF mPIND5 = "S"
INDI5 := NUMIND( mARQ5, INDI5 )
ENDIF
IF !USEREDE( mARQ5, 1, INDI5 )
dbCloseAll()
RETU .F.
ENDIF
ENDIF
IF !Empty( mARQ6 )
IF mPIND6 = "S"
INDI6 := NUMIND( mARQ6, INDI6 )
ENDIF
IF !USEREDE( mARQ6, 1, INDI6 )
dbCloseAll()
RETU .F.
ENDIF
ENDIF

TEMPDBF := TMPFILE( "DBF" )
TEMPDBF := SubStr( TEMPDBF, 1, At( ".", TEMPDBF ) - 1 )
IF !USEREDE( ARQRE1, 1, 1 )   // nIND
dbCloseAll()
RETU .F.
ENDIF
aESTRU := dbStruct()
cINDEX := IndexKey()
dbCreate( TEMPDBF, aESTRU )
IF !USECHK( TEMPDBF,, .F. )
dbCloseAll()
RETU .F.
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
ordDestroy( "temp" )
ordCreate(, "temp", cINDEX )
ordSetFocus( "temp" )

dbSelectAr( ARQRE1 )
dbGoTop()
dbSeek( mMENU1 + mCODIGO1 )
WHILE CODIGO = mCODIGO1 .AND. !Eof()
EQUVARS()
NOVOOPA( TEMPDBF )
dbSelectAr( ARQRE1 )
dbSkip()
ENDDO
dbSelectAr( ARQRE1 )
dbCloseArea()

dbSelectAr( TEMPDBF )
dbGoTop()
H1 := RecNo()
IF !Empty( FAT1 )
@ 08, 00 CLEAR
I := 0
FOR I := 1 TO 5
X := Str( I, 1 )
IF !Empty( FAT&X )
MASC := ''
IF FAT&X = 'D'
ZFATOR&X := CToD( '  /  /  ' )
ELSEIF FAT&X = 'N'
ZFATOR&X := 0.00000
MASC     := '999,999,999.99999'
ELSEIF FAT&X = 'C'
ZFATOR&X := Space( TAM&X )
ENDIF
IF Empty( MASC )
@  8 + I, 2 SAY DES&X GET ZFATOR&X
ELSE
@  8 + I, 2 SAY DES&X GET ZFATOR&X PICT MASC
ENDIF
ENDIF
NEXT
READCUR()
ENDIF
dbSelectAr( &AREA )
@ 08, 00 CLEAR
IMPX := .F.
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF
dbGoTop()
dbSelectAr( TEMPDBF )
dbGoTop()
LISTAR1()
dbCloseAll()
DELETEFILE( TEMPDBF + ".DBF" )
RETU .T.




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function LISTAR1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION LISTAR1

   @ 22, 00
   @ 22, 01 SAY 'oRDEM'
// @ 22,20 SAY &ORD
// INKEY(0)
   @  8, 0 CLEAR
   COPIAS := 1
   @ 19, 0 SAY 'Quantas copias?' GET COPIAS PICT '999'
   READCUR()
   @ 21, 0 TO 23, 11 DOUBLE
   OPCAO( 22, 1, " &Imprimir ", 73 )
   OPCAO4 := MENU(, 0 )
   IF OPCAO4 = 1
      IF OPCAO3 = 1 .AND. !CHECKIMP( 0 )
         ALERTX( 'Impressora nao disponivel' )
      ENDIF
      IF OPCAO3 = 1
         SET DEVI TO PRINT
         SET PRINT ON
         IF !Empty( PROG )
            IF ALT = 0
               ?? &PROG
            ENDIF
         ENDIF
         SET PRINT OFF
      ELSE
         LINHAS := 20
      ENDIF
      FOR I := 1 TO COPIAS
         IF I > 1
            FATOR := FATOR_AUX
         ENDIF
         IF ETIQ <> 'S'
            CTLIN   := 80
            ZPAGINA := 0
            OCULTO  := .F.
            F1      := F2 := T2 := F3 := T3 := R3 := F4 := T4 := R4 := F5 := T5 := R5 := 0
            T1A     := T1B := T1C := T1D := T1E := 0
            T2A     := T2B := T2C := T2D := T2E := 0
            T3A     := T3B := T3C := T3D := T3E := 0
            T4A     := T4B := T4C := T4D := T4E := 0
            T5A     := T5B := T5C := T5D := T5E := 0
            D1      := D2 := D3 := D4 := D5 := R2 := O1 := O2 := 0
            ZTOTAL1 := ZTOTAL2 := ZTOTAL3 := ZTOTAL4 := ZTOTAL5 := 0.00
            XTOTAL1 := XTOTAL2 := XTOTAL3 := XTOTAL4 := XTOTAL5 := 0.00
            YTOTAL1 := YTOTAL2 := YTOTAL3 := YTOTAL4 := YTOTAL5 := 0.00
            ZTOT1   := ZTOT2 := ZTOT3 := ZTOT4 := ZTOT5 := ' '
            cTOT1   := cTOT2 := cTOT3 := cTOT4 := cTOT5 := ' '
            dbSelectAr( &AREA )
            dbGoTop()
            FOR COUNTER := 1 TO FCount()
               CAMP := FIELD( COUNTER )
               IF Type( CAMP ) = 'N'
                  CAMP      := SubStr( CAMP, 2, Len( CAMP ) - 1 )
                  Z1&CAMP   := 0.00
                  A         := '1'
                  B         := '2'
                  C         := '3'
                  D         := '4'
                  E         := '5'
                  Y1&CAMP&A := X1&CAMP&A := 0.00
                  Y1&CAMP&B := X1&CAMP&B := 0.00
                  Y1&CAMP&C := X1&CAMP&C := 0.00
                  Y1&CAMP&D := X1&CAMP&D := 0.00
                  Y1&CAMP&E := X1&CAMP&E := 0.00
               ENDIF
            NEXT
            IF ETIQ = '%'
               SET DEVI TO SCREEN
               @ 21, 0 TO 23, 15 DOUBLE
               SET COLOR TO N / W
               @ 22, 01 SAY " Apurando ... "
               SET COLOR TO
               IF OPCAO3 = 1
                  SET DEVI TO PRINT
               ENDIF
               WHILE !Eof()
                  FOR COUNTER := 1 TO FCount()
                     CAMP := FIELD( COUNTER )
                     IF Type( CAMP ) = 'N'
                        CAMP1    := SubStr( CAMP, 2, Len( CAMP ) - 1 )
                        X1&CAMP1 := &CAMP + X1&CAMP1
                     ENDIF
                  NEXT
                  IF !Eof()
                     dbSkip()
                  ENDIF
               ENDDO
               WTOT1 := WTOT2 := WTOT3 := WTOT4 := WTOT5 := ' '
               dbGoTop()
               WHILE !Eof()
                  dbSelectAr( TEMPDBF )
                  dbGoTop()
                  WHILE !Eof()
                     TOT := TOTALIZA
                     IF TOT
                        DIZERES := Trim( CONTEUDO )
                        dbSelectAr( &AREA )
                        IF WTOT1 = ' ' .OR. DIZERES = WTOT1
                           XTOTAL1 := XTOTAL1 + &DIZERES
                           WTOT1   := DIZERES
                        ELSEIF WTOT2 = ' ' .OR. DIZERES = WTOT2
                           XTOTAL2 := XTOTAL2 + &DIZERES
                           WTOT2   := DIZERES
                        ELSEIF WTOT3 = ' ' .OR. DIZERES = WTOT3
                           XTOTAL3 := XTOTAL3 + &DIZERES
                           WTOT3   := DIZERES
                        ELSEIF WTOT4 = ' ' .OR. DIZERES = WTOT4
                           XTOTAL4 := XTOTAL4 + &DIZERES
                           WTOT4   := DIZERES
                        ELSEIF WTOT5 = ' ' .OR. DIZERES = WTOT5
                           XTOTAL5 := XTOTAL5 + &DIZERES
                           WTOT5   := DIZERES
                        ENDIF
                        dbSelectAr( TEMPDBF )
                     ENDIF
                     IF !Eof()
                        dbSkip()
                     ENDIF
                  ENDDO
                  dbSelectAr( &AREA )
                  IF !Eof()
                     dbSkip()
                  ENDIF
               ENDDO
               dbSelectAr( TEMPDBF )
               dbGoTop()
            ENDIF
            IF OPCAO3 = 2
               CLEAR
            ELSE
               SET DEVI TO SCREEN
               @ 21, 0 TO 23, 17 DOUBLE
               SET COLOR TO N / W
               @ 22, 01 SAY " Imprimindo ... "
               SET COLOR TO
               IF OPCAO3 = 1
                  SET DEVI TO PRINT
               ENDIF
            ENDIF
            dbSelectAr( mARQ1 )
            dbGoTop()
            WHILE ! Eof()
               IF !Empty( QBR1A )
                  NR1A  := QBR1A
                  CTR1A := &NR1A
                  IF !Empty( QBR1B )
                     NR1B  := QBR1B
                     CTR1B := &NR1B
                     IF !Empty( QBR1C )
                        NR1C  := QBR1C
                        CTR1C := &NR1C
                        IF !Empty( QBR1D )
                           NR1D  := QBR1D
                           CTR1D := &NR1D
                           IF !Empty( QBR1E )
                              NR1E  := QBR1E
                              CTR1E := &NR1E
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
               dbSelectAr( TEMPDBF )
               IF CTLIN >= LINHAS
                  IF CABEC()
                     RETURN
                  ENDIF
               ENDIF
               IF D1 > 0
                  GO D1
                  DO IMPRIME WITH 'D', 1
               ELSEIF D2 > 0
                  DO LISTAR2 WITH 2
                  EXIT
               ELSEIF D3 > 0
                  DO LISTAR3 WITH 2
                  EXIT
               ELSEIF D4 > 0
                  DO LISTAR4 WITH 2
                  EXIT
               ELSEIF D5 > 0
                  DO LISTAR5 WITH 2
                  EXIT
               ELSEIF O1 > 0
                  OCULTO := .T.
                  GO O1
                  DO IMPRIME WITH 'O', 1
               ELSEIF O2 > 0
                  OCULTO := .T.
                  GO O2
                  DO LISTAR2 WITH 2
                  EXIT
               ENDIF
               dbSelectAr( mARQ1 )
               IF ! Eof()
                  IF !Empty( REL1 )
                     IF R1A = 0 .OR. R1A = 2
                        DO LISTAR2 WITH 1, "1"
                     ELSEIF R1A = 3
                        DO LISTAR3 WITH 1, "1"
                     ELSEIF R1A = 4
                        DO LISTAR4 WITH 1, "1"
                     ELSEIF R1A = 5
                        DO LISTAR5 WITH 1, "1"
                     ENDIF
                  ENDIF
                  dbSelectAr( mARQ1 )
                  SKIP
                  IF !Empty( QBR1A ) .AND. T1A > 0
                     IF &NR1A <> CTR1A
                        dbSelectAr( TEMPDBF )
                        GO T1A
                        DO IMPRIME WITH 'T', 1, 1
                     ENDIF
                     IF !Empty( QBR1B )
                        dbSelectAr( mARQ1 )
                        IF &NR1B <> CTR1B
                           dbSelectAr( TEMPDBF )
                           GO T1B
                           DO IMPRIME WITH 'T', 1, 2
                        ENDIF
                        IF !Empty( QBR1C )
                           dbSelectAr( mARQ1 )
                           IF &NR1C <> CTR1C
                              dbSelectAr( TEMPDBF )
                              GO T1C
                              DO IMPRIME WITH 'T', 1, 3
                           ENDIF
                           IF !Empty( QBR1D )
                              dbSelectAr( mARQ1 )
                              IF &NR1D <> CTR1D
                                 dbSelectAr( TEMPDBF )
                                 GO T1D
                                 DO IMPRIME WITH 'T', 1, 4
                              ENDIF
                              IF !Empty( QBR1E )
                                 dbSelectAr( mARQ1 )
                                 IF &NR1E <> CTR1E
                                    dbSelectAr( TEMPDBF )
                                    GO T1E
                                    DO IMPRIME WITH 'T', 1, 5
                                 ENDIF
                              ENDIF
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
               dbSelectAr( mARQ1 )
            ENDDO
            dbSelectAr( TEMPDBF )
            IF F1 > 0
               GO F1
               DO IMPRIME WITH 'F', 1
            ENDIF
            IF OPCAO3 = 1
               IMPFOL()
            ELSE
               IF LastKey() <> 27
                  Inkey( 0 )
                  CLEAR
               ENDIF
            ENDIF
         ELSE
            IF OPCAO3 = 1
               SET DEVI TO PRINT
               SET PRINT ON
               ?? Chr( 27 ) + 'C' + Chr( ALT )
               SET PRINT OFF
            ENDIF
            dbSelectAr( mARQ1 )
            dbGoTop()
            WHILE ! Eof()
               RRR := RecNo()
               IF OPCAO3 = 2
                  CLEAR
                  IF LastKey() = 27
                     EXIT
                  ENDIF
               ENDIF
               CTLIN := 0
               dbSelectAr( TEMPDBF )
               dbGoTop()
               WHILE ! Eof()
                  CTLIN   := CTLIN + ESPACEJAR
                  DIZERES := Trim( CONTEUDO )
                  FOR CT := 1 TO COL
                     CTCOL := COLUNA
                     IF CT = 2
                        CTCOL := COLUNA + LARG + 1
                     ELSEIF CT = 3
                        CTCOL := COLUNA + ( LARG * 2 ) + 2
                     ELSEIF CT = 4
                        CTCOL := COLUNA + ( LARG * 3 ) + 3
                     ENDIF
                     dbSelectAr( mARQ1 )
                     GO RRR
                     IF CT = 2
                        SKIP + 1
                     ELSEIF CT = 3
                        SKIP + 2
                     ELSEIF CT = 4
                        SKIP + 3
                     ENDIF
                     @ CTLIN, CTCOL SAY &DIZERES
                     dbSelectAr( TEMPDBF )
                  NEXT
                  SKIP
               ENDDO
               dbSelectAr( mARQ1 )
               SKIP
            ENDDO
            IF OPCAO3 = 1
               IMPFOL()
               SET PRINT ON
               ?? Chr( 27 ) + '@'
               SET PRINT OFF
               SET DEVI TO SCREEN
            ELSE
               IF LastKey() <> 27
                  Inkey( 0 )
                  CLEAR
               ENDIF
               CLEAR
            ENDIF
         ENDIF
      NEXT
   ENDIF

   SET DEVI TO SCREEN

   IF IMPX
      dbSelectAr( DBF )
      nLASTREC := LastRec()
      zei_fort( nLASTREC,,, 0 )
      dbEval( {|| netGRVCAM( "IMPRIME", ' ' ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
      SET FILTER TO
      dbGoTop()
   ENDIF

   RETURN


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function LISTAR2()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION LISTAR2

   PARA P01, P02

   IF P01 = 1
      REL       := REL&P02
      RELAC&P02 := &REL
   ENDIF
   dbSelectAr( TEMPDBF )
   IF D2 = 0 .OR. O2 = 0
      WHILE TIPO <> 'D' .AND. TIPO <> 'O' .AND. ARQUIVO <> 2
         IF Eof()
            EXIT
         ELSE
            SKIP
         ENDIF
      ENDDO
      IF !Eof()
         IF TIPO = 'D'
            D2 := RecNo()
         ELSEIF TIPO = 'O'
            O2 := RecNo()
         ENDIF
      ELSE
         RETURN
      ENDIF
   ENDIF
   dbSelectAr( mARQ2 )
   FOR COUNTER := 1 TO FCount()
      CAMP := FIELD( COUNTER )
      IF Type( CAMP ) = 'N'
         CAMP    := SubStr( CAMP, 2, Len( CAMP ) - 1 )
         Z2&CAMP := Y2&CAMP := X2&CAMP := 0.00
      ENDIF
   NEXT
   dbGoTop()
   IF ETIQ = '%'
      WHILE !Eof()
         FOR COUNTER := 1 TO FCount()
            CAMP := FIELD( COUNTER )
            IF Type( CAMP ) = 'N'
               CAMP1    := SubStr( CAMP, 2, Len( CAMP ) - 1 )
               X2&CAMP1 := &CAMP + X2&CAMP1
            ENDIF
         NEXT
         IF !Eof()
            SKIP
         ENDIF
      ENDDO
      dbGoTop()
   ENDIF
   IF P01 = 1
      SEEK RELAC&P02
      IF Found()
         REL&P02.A := IndexKey( 0 )
         REL       := REL&P02.A
         RELAC&P02 := &REL
         CONDICAO1 := REL&P02.A + '=RELAC&P02'
      ELSE
         CONDICAO1 := '.F.'
      ENDIF
   ELSE
      CONDICAO1 := '! EOF()'
   ENDIF
   WHILE &CONDICAO1
      IF !Empty( QBR2A )
         NR2A  := QBR2A
         CTR2A := &NR2A
         IF !Empty( QBR2B )
            NR2B  := QBR2B
            CTR2B := &NR2B
            IF !Empty( QBR2C )
               NR2C  := QBR2C
               CTR2C := &NR2C
               IF !Empty( QBR2D )
                  NR2D  := QBR2D
                  CTR2D := &NR2D
                  IF !Empty( QBR2E )
                     NR2E  := QBR2E
                     CTR2E := &NR2E
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( TEMPDBF )
      IF CTLIN >= LINHAS
         FCABEC := CABEC()
         IF FCABEC
            RETURN
         ENDIF
      ENDIF
      IF O2 > 0
         OCULTO := .T.
         GO O2
         DO IMPRIME WITH 'O', 2
      ELSE
         GO D2
         DO IMPRIME WITH 'D', 2
      ENDIF
      dbSelectAr( mARQ2 )
      IF ! Eof()
         IF !Empty( REL2 )
            IF R2A = 0 .OR. R2A = 3
               DO LISTAR3 WITH 1, "2"
            ELSEIF R2A = 4
               DO LISTAR4 WITH 1, "2"
            ELSEIF R2A = 5
               DO LISTAR5 WITH 1, "2"
            ENDIF
         ENDIF
         dbSelectAr( mARQ2 )
         SKIP
         IF !Empty( QBR2A ) .AND. T2A > 0
            IF &NR2A <> CTR2A
               dbSelectAr( TEMPDBF )
               GO T2A
               DO IMPRIME WITH 'T', 2, 1
            ENDIF
            IF !Empty( QBR2B )
               dbSelectAr( mARQ2 )
               IF &NR2B <> CTR2B
                  dbSelectAr( TEMPDBF )
                  GO T2B
                  DO IMPRIME WITH 'T', 2, 2
               ENDIF
               IF !Empty( QBR2C )
                  dbSelectAr( mARQ2 )
                  IF &NR2C <> CTR2C
                     dbSelectAr( TEMPDBF )
                     GO T2C
                     DO IMPRIME WITH 'T', 2, 3
                  ENDIF
                  IF !Empty( QBR2D )
                     dbSelectAr( mARQ2 )
                     IF &NR2D <> CTR2D
                        dbSelectAr( TEMPDBF )
                        GO T2D
                        DO IMPRIME WITH 'T', 2, 4
                     ENDIF
                     IF !Empty( QBR2E )
                        dbSelectAr( mARQ2 )
                        IF &NR2E <> CTR2E
                           dbSelectAr( TEMPDBF )
                           GO T2E
                           DO IMPRIME WITH 'T', 2, 5
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( mARQ2 )
   ENDDO
   dbSelectAr( TEMPDBF )
   IF F2 > 0
      GO F2
      DO IMPRIME WITH 'F', 2
   ENDIF
   IF R2 > 0
      GO R2
      DO IMPRIME WITH 'R', 2
   ENDIF
   dbSelectAr( mARQ1 )

   RETURN



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function LISTAR3()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION LISTAR3

   PARA P01, P02

   IF P01 = 1
      REL       := REL&P02
      RELAC&P02 := &REL
   ENDIF
   dbSelectAr( TEMPDBF )
   IF D3 = 0
      WHILE TIPO <> 'D' .AND. ARQUIVO <> 3
         IF Eof()
            EXIT
         ELSE
            SKIP
         ENDIF
      ENDDO
      IF !Eof()
         D3 := RecNo()
      ELSE
         RETURN
      ENDIF
   ENDIF
   dbSelectAr( mARQ3 )
   dbGoTop()
   FOR COUNTER := 1 TO FCount()
      CAMP := FIELD( COUNTER )
      IF Type( CAMP ) = 'N'
         CAMP    := SubStr( CAMP, 2, Len( CAMP ) - 1 )
         Z3&CAMP := Y3&CAMP := X3&CAMP := 0.00
      ENDIF
   NEXT
   IF ETIQ = '%'
      WHILE !Eof()
         FOR COUNTER := 1 TO FCount()
            CAMP := FIELD( COUNTER )
            IF Type( CAMP ) = 'N'
               CAMP1    := SubStr( CAMP, 2, Len( CAMP ) - 1 )
               X3&CAMP1 := &CAMP + X3&CAMP1
            ENDIF
         NEXT
         IF !Eof()
            SKIP
         ENDIF
      ENDDO
      dbGoTop()
   ENDIF
   IF P01 = 1
      SEEK RELAC&P02
      IF Found()
         REL&P02.A := IndexKey( 0 )
         REL       := REL&P02.A
         RELAC&P02 := &REL
         CONDICAO2 := REL&P02.A + '=RELAC&P02'
      ELSE
         CONDICAO2 := '.F.'
      ENDIF
   ELSE
      CONDICAO2 := '! EOF()'
   ENDIF
   WHILE &CONDICAO2
      IF !Empty( QBR3A )
         NR3A  := QBR3A
         CTR3A := &NR3A
         IF !Empty( QBR3B )
            NR3B  := QBR3B
            CTR3B := &NR3B
            IF !Empty( QBR3C )
               NR3C  := QBR3C
               CTR3C := &NR3C
               IF !Empty( QBR3D )
                  NR3D  := QBR3D
                  CTR3D := &NR3D
                  IF !Empty( QBR3E )
                     NR3E  := QBR3E
                     CTR3E := &NR3E
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( TEMPDBF )
      IF CTLIN >= LINHAS
         FCABEC := CABEC()
         IF FCABEC
            RETURN
         ENDIF
      ENDIF
      GO D3
      DO IMPRIME WITH 'D', 3
      dbSelectAr( mARQ3 )
      IF ! Eof()
         IF !Empty( REL3 )
            IF R3A = 0 .OR. R3A = 4
               DO LISTAR4 WITH 1, "3"
            ELSEIF R3A = 5
               DO LISTAR5 WITH 1, "3"
            ENDIF
         ENDIF
         dbSelectAr( mARQ3 )
         SKIP
         IF !Empty( QBR3A )
            IF &NR3A <> CTR3A .AND. T3A > 0
               dbSelectAr( TEMPDBF )
               GO T3A
               DO IMPRIME WITH 'T', 3, 1
            ENDIF
            IF !Empty( QBR3B )
               dbSelectAr( mARQ3 )
               IF &NR3B <> CTR3B
                  dbSelectAr( TEMPDBF )
                  GO T3B
                  DO IMPRIME WITH 'T', 3, 2
               ENDIF
               IF !Empty( QBR3C )
                  dbSelectAr( mARQ3 )
                  IF &NR3C <> CTR3C
                     dbSelectAr( TEMPDBF )
                     GO T3C
                     DO IMPRIME WITH 'T', 3, 3
                  ENDIF
                  IF !Empty( QBR3D )
                     dbSelectAr( mARQ3 )
                     IF &NR3D <> CTR3D
                        dbSelectAr( TEMPDBF )
                        GO T3D
                        DO IMPRIME WITH 'T', 3, 4
                     ENDIF
                     IF !Empty( QBR3E )
                        dbSelectAr( mARQ3 )
                        IF &NR3E <> CTR3E
                           dbSelectAr( TEMPDBF )
                           GO T3E
                           DO IMPRIME WITH 'T', 3, 5
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( mARQ3 )
   ENDDO
   dbSelectAr( TEMPDBF )
   IF F3 > 0
      GO F3
      DO IMPRIME WITH 'F', 3
   ENDIF
   IF R3 > 0
      GO R3
      DO IMPRIME WITH 'R', 3
   ENDIF
   dbSelectAr( mARQ2 )

   RETURN



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function LISTAR4()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION LISTAR4

   PARA P01, P02

   IF P01 = 1
      REL       := REL&P02
      RELAC&P02 := &REL
   ENDIF
   dbSelectAr( TEMPDBF )
   IF D4 = 0
      WHILE TIPO <> 'D' .AND. ARQUIVO <> 4
         IF Eof()
            EXIT
         ELSE
            SKIP
         ENDIF
      ENDDO
      IF !Eof()
         D4 := RecNo()
      ELSE
         RETURN
      ENDIF
   ENDIF
   dbSelectAr( mARQ4 )
   dbGoTop()
   FOR COUNTER := 1 TO FCount()
      CAMP := FIELD( COUNTER )
      IF Type( CAMP ) = 'N'
         CAMP    := SubStr( CAMP, 2, Len( CAMP ) - 1 )
         Z4&CAMP := Y4&CAMP := 0.00
      ENDIF
   NEXT
   IF ETIQ = '%'
      WHILE !Eof()
         FOR COUNTER := 1 TO FCount()
            CAMP := FIELD( COUNTER )
            IF Type( CAMP ) = 'N'
               CAMP1    := SubStr( CAMP, 2, Len( CAMP ) - 1 )
               X4&CAMP1 := &CAMP + X4&CAMP1
            ENDIF
         NEXT
         IF !Eof()
            SKIP
         ENDIF
      ENDDO
      dbGoTop()
   ENDIF
   IF P01 = 1
      SEEK RELAC&P02
      IF Found()
         REL&P02.A := IndexKey( 0 )
         REL       := REL&P02.A
         RELAC&P02 := &REL
         CONDICAO3 := REL&P02.A + '=RELAC&P02'
      ELSE
         CONDICAO3 := '.F.'
      ENDIF
   ELSE
      CONDICAO3 := '! EOF()'
   ENDIF
   WHILE &CONDICAO3
      IF !Empty( QBR4A )
         NR4A  := QBR4A
         CTR4A := &NR4A
         IF !Empty( QBR4B )
            NR4B  := QBR4B
            CTR4B := &NR4B
            IF !Empty( QBR4C )
               NR4C  := QBR4C
               CTR4C := &NR4C
               IF !Empty( QBR4D )
                  NR4D  := QBR4D
                  CTR4D := &NR4D
                  IF !Empty( QBR4E )
                     NR4E  := QBR4E
                     CTR4E := &NR4E
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( TEMPDBF )
      IF CTLIN >= LINHAS
         FCABEC := CABEC()
         IF FCABEC
            RETURN
         ENDIF
      ENDIF
      GO D4
      DO IMPRIME WITH 'D', 4
      dbSelectAr( mARQ4 )
      IF ! Eof()
         IF !Empty( REL4 )
            DO LISTAR5 WITH 1, "4"
         ENDIF
         SKIP
         IF !Empty( QBR4A )
            IF &NR4A <> CTR4A .AND. T4A > 0
               dbSelectAr( TEMPDBF )
               GO T4A
               DO IMPRIME WITH 'T', 4, 1
            ENDIF
            IF !Empty( QBR4B )
               dbSelectAr( mARQ4 )
               IF &NR4B <> CTR4B
                  dbSelectAr( TEMPDBF )
                  GO T4B
                  DO IMPRIME WITH 'T', 4, 2
               ENDIF
               IF !Empty( QBR4C )
                  dbSelectAr( mARQ4 )
                  IF &NR4C <> CTR4C
                     dbSelectAr( TEMPDBF )
                     GO T4C
                     DO IMPRIME WITH 'T', 4, 3
                  ENDIF
                  IF !Empty( QBR4D )
                     dbSelectAr( mARQ4 )
                     IF &NR4D <> CTR4D
                        dbSelectAr( TEMPDBF )
                        GO T4D
                        DO IMPRIME WITH 'T', 4, 4
                     ENDIF
                     IF !Empty( QBR4E )
                        dbSelectAr( mARQ4 )
                        IF &NR4E <> CTR4E
                           dbSelectAr( TEMPDBF )
                           GO T4E
                           DO IMPRIME WITH 'T', 4, 5
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( mARQ4 )
   ENDDO
   dbSelectAr( TEMPDBF )
   IF F4 > 0
      GO F4
      DO IMPRIME WITH 'F', 4
   ENDIF
   IF R4 > 0
      GO R4
      DO IMPRIME WITH 'R', 4
   ENDIF
   dbSelectAr( mARQ3 )

   RETURN



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function LISTAR5()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION LISTAR5

   PARA P01, P02

   IF P01 = 1
      REL       := REL&P02
      RELAC&P02 := &REL
   ENDIF
   dbSelectAr( TEMPDBF )
   IF D5 = 0
      WHILE TIPO <> 'D' .AND. ARQUIVO <> 5
         IF Eof()
            EXIT
         ELSE
            SKIP
         ENDIF
      ENDDO
      IF !Eof()
         D5 := RecNo()
      ELSE
         RETURN
      ENDIF
   ENDIF
   dbSelectAr( mARQ5 )
   dbGoTop()
   FOR COUNTER := 1 TO FCount()
      CAMP := FIELD( COUNTER )
      IF Type( CAMP ) = 'N'
         CAMP    := SubStr( CAMP, 2, Len( CAMP ) - 1 )
         Z5&CAMP := Y5&CAMP := 0.00
      ENDIF
   NEXT
   IF ETIQ = '%'
      WHILE !Eof()
         FOR COUNTER := 1 TO FCount()
            CAMP := FIELD( COUNTER )
            IF Type( CAMP ) = 'N'
               CAMP1    := SubStr( CAMP, 2, Len( CAMP ) - 1 )
               X5&CAMP1 := &CAMP + X5&CAMP1
            ENDIF
         NEXT
         IF !Eof()
            SKIP
         ENDIF
      ENDDO
      dbGoTop()
   ENDIF
   IF P01 = 1
      SEEK RELAC&P02
      IF Found()
         REL&P02.A := IndexKey( 0 )
         REL       := REL&P02.A
         RELAC&P02 := &REL
         CONDICAO4 := REL&P02.A + '=RELAC&P02'
      ELSE
         CONDICAO4 := '.F.'
      ENDIF
   ELSE
      CONDICAO4 := '! EOF()'
   ENDIF
   WHILE &CONDICAO4
      IF !Empty( QBR5A )
         NR5A  := QBR5A
         CTR5A := &NR5A
         IF !Empty( QBR5B )
            NR5B  := QBR5B
            CTR5B := &NR5B
            IF !Empty( QBR5C )
               NR5C  := QBR5C
               CTR5C := &NR5C
               IF !Empty( QBR5D )
                  NR5D  := QBR5D
                  CTR5D := &NR5D
                  IF !Empty( QBR5E )
                     NR5E  := QBR5E
                     CTR5E := &NR5E
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( TEMPDBF )
      IF CTLIN >= LINHAS
         FCABEC := CABEC()
         IF FCABEC
            RETURN
         ENDIF
      ENDIF
      GO D5
      DO IMPRIME WITH 'D', 5
      dbSelectAr( mARQ5 )
      IF ! Eof()
         SKIP
         IF !Empty( QBR5A )
            IF &NR5A <> CTR5A .AND. T5A > 0
               dbSelectAr( TEMPDBF )
               GO T5A
               DO IMPRIME WITH 'T', 5, 1
            ENDIF
            IF !Empty( QBR5B )
               dbSelectAr( mARQ5 )
               IF &NR5B <> CTR5B
                  dbSelectAr( TEMPDBF )
                  GO T5B
                  DO IMPRIME WITH 'T', 5, 2
               ENDIF
               IF !Empty( QBR5C )
                  dbSelectAr( mARQ5 )
                  IF &NR5C <> CTR5C
                     dbSelectAr( TEMPDBF )
                     GO T5C
                     DO IMPRIME WITH 'T', 5, 3
                  ENDIF
                  IF !Empty( QBR5D )
                     dbSelectAr( mARQ5 )
                     IF &NR5D <> CTR5D
                        dbSelectAr( TEMPDBF )
                        GO T5D
                        DO IMPRIME WITH 'T', 5, 4
                     ENDIF
                     IF !Empty( QBR5E )
                        dbSelectAr( mARQ5 )
                        IF &NR5E <> CTR5E
                           dbSelectAr( TEMPDBF )
                           GO T5E
                           DO IMPRIME WITH 'T', 5, 5
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( mARQ5 )
   ENDDO
   dbSelectAr( TEMPDBF )
   IF F5 > 0
      GO F5
      DO IMPRIME WITH 'F', 5
   ENDIF
   IF R5 > 0
      GO R5
      DO IMPRIME WITH 'R', 5
   ENDIF
   dbSelectAr( mARQ4 )

   RETURN


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function IMPRIME()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION IMPRIME

   PARA P01, P02, P03

   ARQU := Str( P02, 1 )
   IF P01 = 'R'
      ARQU := Str( P02 - 1, 1 )
   ENDIF
   IF PCount() = 3
      QB := Chr( 64 + P03 )
   ENDIF
   COND := 'TIPO=P01 .AND. ARQUIVO=P02'
   IF P01 = 'T'
      COND := COND + ' .AND. QUEBRAR=P03'
   ENDIF
   IF P01 = 'T' .AND. OCULTO
      SELE &ARQU
      SKIP - 1
      dbSelectAr( TEMPDBF )
   ENDIF
   WHILE &COND .AND. !Eof()
      IMPR    := .T.
      PULAR   := ESPACEJAR
      G       := FORMULA
      DIZERES := Trim( CONTEUDO )
      CTCOL   := COLUNA
      MASC    := Trim( MASCARA )
      TOT     := TOTALIZA
      QUEBROU := Str( QUEBRAR, 1 )
      IF DIZERES = '@CABEC'
         REGISTRO := RecNo()
         CABEC()
         GO REGISTRO
         IMPR := .F.
      ENDIF
      SELE &ARQU
      COND_ := "TOT .OR. TYPE(DIZERES)='N'"
      IF Trim( mGRUPO ) = 'MZ'
         COND_ := "TYPE(DIZERES)='N'"
      ENDIF
      IF &COND_
         IF P01 = 'T'
            DIZERES1 := FCAMPO( DIZERES, 'N' )
            IF Empty( DIZERES1 )
               IF DIZERES = ZTOT1
                  DIREZES := 'M->YTOTAL1'
               ELSEIF DIZERES = ZTOT2
                  DIREZES := 'M->YTOTAL2'
               ELSEIF DIZERES = ZTOT3
                  DIREZES := 'M->YTOTAL3'
               ELSEIF DIZERES = ZTOT4
                  DIREZES := 'M->YTOTAL4'
               ELSEIF DIZERES = ZTOT5
                  DIREZES := 'M->YTOTAL5'
               ENDIF
            ELSE
               DIZERES := FCAMPO( DIZERES, 'N' )
               DIZERES := 'M->Y' + ARQU + SubStr( DIZERES, 2, Len( DIZERES ) - 1 ) + QUEBROU
            ENDIF
         ELSEIF P01 = 'F'
            DIZERES1 := FCAMPO( DIZERES, 'N' )
            IF Empty( DIZERES1 )
               IF DIZERES = ZTOT1
                  DIREZES := 'ZTOTAL1'
               ELSEIF DIZERES = ZTOT2
                  DIREZES := 'ZTOTAL2'
               ELSEIF DIZERES = ZTOT3
                  DIREZES := 'ZTOTAL3'
               ELSEIF DIZERES = ZTOT4
                  DIREZES := 'ZTOTAL4'
               ELSEIF DIZERES = ZTOT5
                  DIREZES := 'ZTOTAL5'
               ENDIF
            ELSE
               DIZERES := DIZERES1
               DIZERES := 'M->Z' + ARQU + SubStr( DIZERES, 2, Len( DIZERES ) - 1 )
            ENDIF
            // IMPR=IF(QUEBROU=2,.F.,IMPR)
         ELSEIF P01 $ 'DO' .AND. TOT
            cTOT&QUEBROU := DIZERES
            IMPR         := IF( P01 = 'O', .F., IMPR )
            DIZERES1     := FCAMPO( DIZERES, 'N' )
            IF Empty( DIZERES1 )
               IF ZTOT1 = ' ' .OR. ZTOT1 = DIZERES
                  YTOTAL1 := &DIZERES + YTOTAL1
                  ZTOTAL1 := &DIZERES + ZTOTAL1
                  ZTOT1   := DIZERES
               ELSEIF ZTOT2 = ' ' .OR. ZTOT2 = DIZERES
                  YTOTAL2 := &DIZERES + YTOTAL2
                  ZTOTAL2 := &DIZERES + ZTOTAL2
                  ZTOT2   := DIZERES
               ELSEIF ZTOT3 = ' ' .OR. ZTOT3 = DIZERES
                  YTOTAL3 := &DIZERES + YTOTAL3
                  ZTOTAL3 := &DIZERES + ZTOTAL3
                  ZTOT3   := DIZERES
               ELSEIF ZTOT4 = ' ' .OR. ZTOT4 = DIZERES
                  YTOTAL4 := &DIZERES + YTOTAL4
                  ZTOTAL4 := &DIZERES + ZTOTAL4
                  ZTOT4   := DIZERES
               ELSEIF ZTOT5 = ' ' .OR. ZTOT5 = DIZERES
                  YTOTAL5 := &DIZERES + YTOTAL5
                  ZTOTAL5 := &DIZERES + ZTOTAL5
                  ZTOT5   := DIZERES
               ENDIF
            ELSE
               CAMP  := 'Y' + ARQU + SubStr( DIZERES1, 2, Len( DIZERES1 ) - 1 ) + QUEBROU
               &CAMP := &CAMP + &DIZERES
               CAMP  := 'Z' + ARQU + SubStr( DIZERES1, 2, Len( DIZERES1 ) - 1 )
               IF QUEBROU = "1"
                  &CAMP := &CAMP + &DIZERES
               ELSEIF cTOT1 <> cTOT2
                  &CAMP := &CAMP + &DIZERES
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      IF IMPR
         IF Empty( G )
            CTLIN := CTLIN + PULAR
         ELSE
            CTLIN := &G
         ENDIF
         @ CTLIN, CTCOL SAY iif( Empty( MASC ), &DIZERES, TRAN( &DIZERES, MASC ) )
      ENDIF
      IF P01 = 'T'
         IF Left( DIZERES, 4 ) = 'M->Y'
            &DIZERES := 0
         ENDIF
      ENDIF
      dbSelectAr( TEMPDBF )
      SKIP
   ENDDO
   IF P01 = 'T' .AND. OCULTO
      SELE &ARQU
      SKIP
      dbSelectAr( TEMPDBF )
   ENDIF
   IF D1 = 0 .AND. TIPO = 'D' .AND. ARQUIVO = 1
      D1 := RecNo()
   ELSEIF D2 = 0 .AND. TIPO = 'D' .AND. ARQUIVO = 2
      D2 := RecNo()
   ELSEIF D3 = 0 .AND. TIPO = 'D' .AND. ARQUIVO = 3
      D3 := RecNo()
   ELSEIF D4 = 0 .AND. TIPO = 'D' .AND. ARQUIVO = 4
      D4 := RecNo()
   ELSEIF D5 = 0 .AND. TIPO = 'D' .AND. ARQUIVO = 5
      D5 := RecNo()
   ELSEIF O1 = 0 .AND. TIPO = 'O' .AND. ARQUIVO = 1
      O1 := RecNo()
   ELSEIF O2 = 0 .AND. TIPO = 'O' .AND. ARQUIVO = 2
      O2 := RecNo()
   ELSEIF T1A = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 1 .AND. QUEBRAR = 1
      T1A := RecNo()
   ELSEIF T1B = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 1 .AND. QUEBRAR = 2
      T1B := RecNo()
   ELSEIF T1C = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 1 .AND. QUEBRAR = 3
      T1C := RecNo()
   ELSEIF T1D = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 1 .AND. QUEBRAR = 4
      T1D := RecNo()
   ELSEIF T1E = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 1 .AND. QUEBRAR = 5
      T1E := RecNo()
   ELSEIF F1 = 0 .AND. TIPO = 'F' .AND. ARQUIVO = 1
      F1 := RecNo()
   ELSEIF T2A = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 2 .AND. QUEBRAR = 1
      T2A := RecNo()
   ELSEIF T2B = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 2 .AND. QUEBRAR = 2
      T2B := RecNo()
   ELSEIF T2C = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 2 .AND. QUEBRAR = 3
      T2C := RecNo()
   ELSEIF T2D = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 2 .AND. QUEBRAR = 4
      T2D := RecNo()
   ELSEIF T2E = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 2 .AND. QUEBRAR = 5
      T2E := RecNo()
   ELSEIF F2 = 0 .AND. TIPO = 'F' .AND. ARQUIVO = 2
      F2 := RecNo()
   ELSEIF T3A = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 3 .AND. QUEBRAR = 1
      T3A := RecNo()
   ELSEIF T3B = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 3 .AND. QUEBRAR = 2
      T3B := RecNo()
   ELSEIF T3C = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 3 .AND. QUEBRAR = 3
      T3C := RecNo()
   ELSEIF T3D = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 3 .AND. QUEBRAR = 4
      T3D := RecNo()
   ELSEIF T3E = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 3 .AND. QUEBRAR = 5
      T3E := RecNo()
   ELSEIF F3 = 0 .AND. TIPO = 'F' .AND. ARQUIVO = 3
      F3 := RecNo()
   ELSEIF T4A = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 4 .AND. QUEBRAR = 1
      T4A := RecNo()
   ELSEIF T4B = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 4 .AND. QUEBRAR = 2
      T4B := RecNo()
   ELSEIF T4C = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 4 .AND. QUEBRAR = 3
      T4C := RecNo()
   ELSEIF T4D = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 4 .AND. QUEBRAR = 4
      T4D := RecNo()
   ELSEIF T4E = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 4 .AND. QUEBRAR = 5
      T4E := RecNo()
   ELSEIF F4 = 0 .AND. TIPO = 'F' .AND. ARQUIVO = 4
      F4 := RecNo()
   ELSEIF T5A = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 5 .AND. QUEBRAR = 1
      T5A := RecNo()
   ELSEIF T5B = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 5 .AND. QUEBRAR = 2
      T5B := RecNo()
   ELSEIF T5C = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 5 .AND. QUEBRAR = 3
      T5C := RecNo()
   ELSEIF T5D = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 5 .AND. QUEBRAR = 4
      T5D := RecNo()
   ELSEIF T5E = 0 .AND. TIPO = 'T' .AND. ARQUIVO = 5 .AND. QUEBRAR = 5
      T5E := RecNo()
   ELSEIF F5 = 0 .AND. TIPO = 'F' .AND. ARQUIVO = 5
      F5 := RecNo()
   ELSEIF R2 = 0 .AND. TIPO = 'R' .AND. ARQUIVO = 2
      R2 := RecNo()
   ELSEIF R3 = 0 .AND. TIPO = 'R' .AND. ARQUIVO = 3
      R3 := RecNo()
   ELSEIF R4 = 0 .AND. TIPO = 'R' .AND. ARQUIVO = 4
      R4 := RecNo()
   ELSEIF R5 = 0 .AND. TIPO = 'R' .AND. ARQUIVO = 5
      R5 := RecNo()
   ENDIF

   RETURN



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABEC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CABEC

   RESPOSTA := .F.
   IF OPCAO3 = 2 .AND. ZPAGINA > 0
      Inkey( 0 )
      IF LastKey() = 27
         RESPOSTA := .T.
      ENDIF
      CLEAR
   ENDIF
   ZPAGINA++
   IF ZPAGINA > 1
      IF F1 > 0
         GO F1
         DO IMPRIME WITH 'F', 1
      ENDIF
   ENDIF
   CTLIN := 0
   GO H1
   DO IMPRIME WITH 'H', 1
   IF RESPOSTA
      RETURN .T.
   ELSE
      RETURN .F.
   ENDIF




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FCAMPO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FCAMPO

   PARA STRING, TIP

   CT  := 0
   RET := ""
   WHILE CT < FCount()
      CT++
      IF Trim( mGRUPO ) # 'MZ' .AND. "FATOR(" $ STRING
         EXIT
      ELSEIF Trim( mGRUPO ) # 'MZ' .AND. "OBTER(" $ STRING
         EXIT
      ELSEIF Trim( mGRUPO ) # 'MZ' .AND. "TABELA(" $ STRING
         EXIT
      ELSEIF Trim( mGRUPO ) # 'MZ' .AND. "(" $ STRING
         EXIT
      ELSEIF FIELD( CT ) = STRING
         RET := FIELD( CT )
         EXIT
      ELSEIF FIELD( CT ) $ STRING
         IF Type( FIELD( CT ) ) = TIP
            IN := SubStr( STRING, At( FIELD( CT ), STRING ) - 1, 1 )
            FI := SubStr( STRING, At( FIELD( CT ), STRING ) + Len( FIELD( CT ) ), 1 )
            IF Asc( IN ) < 65 .OR. Asc( IN ) > 90
               IF Asc( FI ) < 65 .OR. Asc( FI ) > 90
                  RET := FIELD( CT )
                  EXIT
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDDO

   RETURN RET



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function SOMA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION SOMA( VAR1, VAR2, VAR3 )

   &VAR1 := &VAR1. + &VAR2. + IF( ValType( VAR3 ) # "U", VALOR3, 0 )

   RETURN &VAR1.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MONTOTAL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MONTOTAL( nIND, eEXP )

   IF ValType( nIND ) # "N"
      nIND := 1
   ENDIF
   IF nIND > 20
      nIND := 1
   ENDIF
   IF ValType( eEXP ) = "C"
      aTOTAL[ nIND ] += &eEXP.
   ENDIF
   IF ValType( eEXP ) # "N"
      aTOTAL[ nIND ] += eEXP
   ENDIF
   RETU aTOTAL[ nIND ]


// : FIM: MAN_B.PRG

// + EOF: manb2.prg
// +
