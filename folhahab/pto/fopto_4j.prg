// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4j.prg Provisorios
// +
// +
// +
// +     Sistema:FOLHA DE PAGAMENTO - MODULO PONTO
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
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +



#include "INKEY.CH"


FUNCTION fopto_4j()

   CRIARVARS( "FOPTOPRO" )



   WHILE .T.
      CABE3( 'FOPTO_4J - Provisorios   ', 23 )
      OPCAO( 04, 01, " &A - Consultar Competencia em Uso", 65, " Consultar                                     " )
      OPCAO( 05, 01, " &B - Consultar Todos Lancamentos ", 66, "                          Arquivado            " )
      OPCAO( 06, 01, " &C - Consultar Arquivado         ", 67, " Consultar Arquivados                          " )
      OPCAO( 07, 01, " &D - Arquivar Demitidos          ", 68, " Arquiva             Demitidos                 " )
      OPCAO( 08, 01, " &E - Arquivar Um ano             ", 69, " Arquiva Um Ano                                " )
      OPCAO( 09, 01, " &F - Arquivar Competencia MesAno ", 70, " Arquiva uma competencia mes/ano               " )
      OPCAO( 10, 01, " &G - Arquivar Um Funcionario     ", 71, " Arquiva Um Funcionario                        " )
      OPCAO( 11, 01, " &H - Retornar Demitidos          ", 72, " Retorna             Demitidos                 " )
      OPCAO( 12, 01, " &I - Retornar Um ano             ", 73, " Retorna Um Ano                                " )
      OPCAO( 13, 01, " &J - Retornar Competencia MesAno ", 74, " Retorna uma competencia mes/ano               " )
      OPCAO( 14, 01, " &K - Retornar Um Funcionario     ", 75, " Retorna Um Funcionario                        " )
// OPCAO( 15, 01, " &L - Excluir um Funcionario+Mvto ", 76, " Excluir um Funcionario Provisorio+Movimento   " )
      OPCAO := menu( 1, 24 )
      DO CASE
      CASE OPCAO = 1   // A Consulta Atual So competencia
         cFILTRO := "DATA>=ZDATAINI.AND.DATA<=ZDATAFIM"
         PADRAO( "FOPTOPRO", "FOPTOPRO", "STR(mORIGEM)+' '+DTOC(mDATA)+' '+STR(mDESTINO)+' '+mNOME", "STR(mORIGEM)+DTOS(mDATA)", "Cadastro de Provisorios", "Origem      Dia   Destino Obs", ;
            {|| iFOPTO4J() }, {|| tFOPTO4J() }, {|| gFOPTO4J() }, {|| FO_RELL( "PONTOCAD11" ) }, cFILTRO, 2 )
      CASE OPCAO = 2   // B Consulta Atual
         PADRAO( "FOPTOPRO", "FOPTOPRO", "STR(mORIGEM)+' '+DTOC(mDATA)+' '+STR(mDESTINO)+' '+mNOME", "STR(mORIGEM)+DTOS(mDATA)", "Cadastro de Provisorios", "Origem      Dia   Destino Obs", ;
            {|| iFOPTO4J() }, {|| tFOPTO4J() }, {|| gFOPTO4J() }, {|| FO_RELL( "PONTOCAD11" ) },, 2 )
      CASE OPCAO = 3   // C Consultar Arquivados
         PADRAO( "FOPTOPRD", "FOPTOPRD", "STR(mORIGEM)+' '+DTOC(mDATA)+' '+STR(mDESTINO)+' '+mNOME", "STR(mORIGEM)+DTOS(mDATA)", "Cadastro de Provisorios", "Origem      Dia   Destino Obs", ;
            {|| iFOPTO4J() }, {|| tFOPTO4J() }, {|| gFOPTO4J() }, {|| FO_RELL( "PONTOCAD11" ) },, 2 )
      CASE OPCAO = 4   // D Arquiva Demitido
         fopto4u( 1, 3 )
      CASE OPCAO = 5   // E Arquiva Ano
         fopto4u( 2, 3 )
      CASE OPCAO = 6   // F Arquiva Mes Ano
         fopto4u( 3, 3 )
      CASE OPCAO = 7   // G Arquiva Funcionario
         fopto4u( 4, 3 )
      CASE OPCAO = 8   // H Retorna Demitidos
         fopto4u( 1, 4 )
      CASE OPCAO = 9   // I Retorna Ano
         fopto4u( 2, 4 )
      CASE OPCAO = 10  // J Retorna mes ano
         fopto4u( 3, 4 )
      CASE OPCAO = 11  // K Retorna funcionario
         fopto4u( 4, 4 )
      OTHERWISE
         RETU
      ENDCASE
      IF opcao = 1 .OR. opcao = 2
         IF mdg( "Atualizar Importacao Provisorios" )
            TrocaPro()
            IF MDG( "Deseja Transferir Dados Ponto do Mes" )
               FOPTO_12()
            ENDIF
         ENDIF
      ENDIF
   ENDDO
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iFOPTO4J()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC iFOPTO4J

   MDS( 'Provisorio Real    Motivo:' )
   @ 24, 26 GET mORIGEM  PICT "99999999"                                                               VALID mORIGEM > 0
   @ 24, 35 GET mDESTINO PICT "99999999"                                                               VALID mDESTINO <> mORIGEM .AND. mDESTINO > 0
   @ 24, 44 GET mMOTIVO  VALID ALLTRUE( IF( Empty( mNOME ), mNOME := OBTER( "FOPTOMOT",, mMOTIVO, "NOME" ), "" ) )
   @ 24, 53 GET mNOME    PICT "@S20"                                                                   VALID !Empty( mNOME )
   IF !READCUR()
      RETU .F.
   ENDIF
   mADMITIDO  := OBTER( PES,, mDESTINO, "ADMITIDO" )
   mDEMITIDO  := OBTER( PES,, mDESTINO, "DEMITIDO" )
   mDATTRANSF := OBTER( PES,, mDESTINO, "DATTRANSF" )
   IF mDATTRANSF > mADMITIDO
      mADMITIDO := mDATTRANSF
   ENDIF
   dINI := zdataini
   dFIM := zdatafim
   IF mADMITIDO > dINI
      dINI := mADMITIDO
   ENDIF
   IF !Empty( mDEMITIDO )
      IF dFIM > mDEMITIDO
         dFIM := mDEMITIDO
      ENDIF
   ELSE
      mDEMITIDO := dFIM
   ENDIF
   MDS( 'Digite o Periodo ' )
   @ 24, 40 GET dINI VALID dINI >= mADMITIDO
   @ 24, 50 GET dFIM VALID dFIM <= mDEMITIDO
   IF !READCUR()
      RETU .F.
   ENDIF
// N„o Grava o ultimo por que a funcao padrao fara
   FOR W := dINI TO dFIM
      mDATA  := W
      mCHAVE := Str( mORIGEM ) + DToS( W )
      IF VIDEO <> "B"
         IF NOVOREG( "FOPTOPRO", "FOPTOPRO", mCHAVE )
            IF VIDEO = 'S'
               AAdd( aPAD1, NIL )
               AAdd( aPAD2, NIL )
               POS  := Len( aPAD1 )
               POSW := 1
               IF POS > 1
                  FOR X := 1 TO POS - 1
                     mDARE := aPAD2[ X ]
                     IF mCHAVE <= mDARE
                        EXIT
                     ENDIF
                  NEXT
                  POSW := X
               ENDIF
               AIns( aPAD1, POSW )
               AIns( aPAD2, POSW )
               aPAD1[ POSW ] = Str( mORIGEM ) + ' ' + DToC( W ) + ' ' + Str( mDESTINO ) + ' ' + mNOME
               aPAD2[ POSW ] = Str( mORIGEM ) + DToS( W )
               pPAD := POSW
            ENDIF
         ENDIF
      ELSE
         dbGoTop()
         IF !dbSeek( mCHAVE )
            netrecapp()
            REPLVARS()
         ENDIF
      ENDIF
   NEXT W
   mCHAVE := Str( mORIGEM ) + DToS( DFIM )
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFOPTO4J()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION gFOPTO4J

   @ 24, 30 GET mMOTIVO VALID ALLTRUE( IF( Empty( mNOME ), mNOME := OBTER( "FOPTOMOT",, mMOTIVO, "NOME" ), "" ) )
   @ 24, 40 GET mNOME   PICT "@S20"                                                                   VALID !Empty( mNOME )
   READCUR()

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFOPTO4J()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION tFOPTO4J

   @ 24, 00 clea
   @ 24, 00 SAY mORIGEM
   @ 24, 10 SAY mDATA
   @ 24, 20 SAY mDESTINO
   @ 24, 30 SAY mMOTIVO
   @ 24, 40 SAY mNOME

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TrocaPro()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION TrocaPro( cPD, dINI, dFIM )

   LOCAL i

   IF ValType( cPD ) # "C"
      nTIPO := PEGRELOGIO()
      IF nTIPO = 1 .OR. nTIPO = 4 .OR. nTIPO = 5
         cPD := PARQDIO( nTIPO )
      ELSE
         RETU
      ENDIF
   ENDIF
   IF ValType( dini ) # "D"
      Dini := zdataini
      Dfim := zdatafim
      MDS( 'Digite o periodo ' )
      @ 24, 40 GET Dini
      @ 24, 60 GET Dfim
      IF !READCUR()
         RETU .F.
      ENDIF
   ENDIF
   mds( "Provisorios" )
   CHECKCRI( cPD, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
   IF !NETUSE( cPD )
      dbCloseAll()
      RETU
   ENDIF
   IF !NETUSE( "FOPTOPRO" )
      dbCloseAll()
      RETU
   ENDIF
   dbSelectAr( "foptopro" )
   dbGoTop()
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   WHILE !Eof()
      IF DATA >= DINI .AND. DATA <= DFIM
         mNUMERO  := ORIGEM
         mDESTINO := DESTINO
         mDATA    := DATA
         aORI     := {}
         aDES     := {}
         aREL     := {}
         cCHAVE   := Str( mNUMERO, 8 ) + DToS( mDATA )
         @ 24, 20 SAY cCHAVE
         dbSelectAr( cPD )
         dbGoTop()
         dbSeek( cCHAVE )
         WHILE numero = mNUMERO .AND. DATA = mDATA .AND. !Eof()  // pegue os horarios
            AAdd( aORI, Str( mNUMERO, 8 ) + DToS( mDATA ) + Str( HORA, 5, 2 ) )  // Necessario matriz pois cpd index e data e reposiona
            AAdd( aDES, Str( mDESTINO, 8 ) + DToS( mDATA ) + Str( HORA, 5, 2 ) )
            AAdd( aREL, { HORA, RELOGIO, TIPOR } )
            dbSkip()
         ENDDO
         FOR i := 1 TO Len( aORI )
            dbSelectAr( cPD )  // desconsidera a com cracha provisorio
            dbGoTop()
            IF dbSeek( aORI[ I ] )
               netrecdel()
            ENDIF
            dbSelectAr( cPD )  // considera a com cracha correto
            dbGoTop()
            IF !dbSeek( ades[ I ] )
               netrecapp()
               field->NUMERO  := mDESTINO
               FIELD->DATA    := mDATA
               FIELD->HORA    := aREL[ I, 1 ]
               FIELD->RELOGIO := aREL[ I, 2 ]
               FIELD->TIPOR   := aREL[ I, 3 ]
            ENDIF
         NEXT i

      /* abaixo
     dbselectar(cPD)
     dbseek(cCHAVE)
     while numero=mNUMERO.AND.DATA=mDATA.and. ! eof()
         mHORA:=HORA
         dbskip()
         if numero=mNUMERO.AND.DATA=mDATA.and.HORA=mHORA.AND.! EOF()   //Apaga dupliciadades
            NETRECDEL()
         endif
     enddo
     */
      ENDIF
      dbSelectAr( "foptopro" )
      dbSkip()
      zei_fort( nLASTREC,,, 1 )
   ENDDO


   dbSelectAr( cPD )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbGoTop()
   WHILE !Eof()
      mNUMERO := NUMERO
      mDATA   := DATA
      mHORA   := HORA
      dbSkip()
      IF numero = mNUMERO .AND. DATA = mDATA .AND. HORA = mHORA .AND. !Eof()   // Apaga dupliciadades
         NETRECDEL()
      ENDIF
      zei_fort( nLASTREC,,, 1 )
   ENDDO
   dbCloseAll()
   netpack( cPD )


// FUNCtion APAGAPRO(mNUMERO)
// cPD := "PD" + ANOMESW
// CHECKCRI( cPD, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
//
// if ! NETUSE(cPD)
// dbcloseall()
// retu
// endif
// dbgotop()
// dbseek(STR(mNUMERO,8))
// WHILE numero=mNUMERO.AND.! EOF()
// netrecdel()
// dbskip()
// ENDDO
// dbcloseall()
// if ! NETUSE("FOPTOPRO")
// dbcloseall()
// retu
// endif
// dbselectar("foptopro")
// dbgotop()
// while ! eof()
// IF ORIGEM=mNUMERO.OR.DESTINO=mNUMERO
// netrecdel()
// ENDIF
// dbskip()
// ENDDO
// dbcloseall()
// fopto_2a("NUMERO="+STR(mNUMERO,8))



// + EOF: fopto_4j.prg
// +
