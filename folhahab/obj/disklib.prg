// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disklib.prg
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


// //#INCLUDE "COMANDO.CH"
#include "INKEY.CH"
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NOTEP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION NOTEP

   PRIV mNOME := Space( 10 ), GETLLIST := {}
   PRIV mOBS1 := mOBS2 := mOBS3 := mOBS4 := mOBS5 := mOBS6 := mOBS7 := mOBS8 := Space( 60 )

   aAMBNOT := SALVAA()
   PADRAO( "NOTA", "NOTA", "mNOME+' '+mOBS1", "mNOME", "Cadastro de Anotacoes", "Anotacao", ;
      {|| PEGCHAVE( "mNOME", Space( 10 ), "Codigo" ) }, "MDG001", "MDG001", {|| FO_RELL( "ANOTACOES" ) },, 4 )
   RESTAA( aAMBNOT )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function AGEN()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION AGEN

   PRIV mCDDATA := CToD( "  /  /  " ), GETLLIST := {}
   PRIV mOBS1   := mOBS2 := mOBS3 := mOBS4 := mOBS5 := mOBS6 := mOBS7 := mOBS8 := Space( 60 )

   aAMBAGE := SALVAA()
   PADRAO( "AGENDA", "AGENDA", "DTOC(mCDDATA)+' '+mOBS1", "mCDDATA", "Cadastro de Compromissos", "Compromisso", ;
      {|| PEGCHAVE( "mCDDATA", Date(), "Data:" ) }, "MDF001", "MDF001", {|| FO_RELL( "AGENDA" ) },, 4 )
   RESTAA( aAMBAGE )

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TELE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION TELE

   PRIV mNOME := Space( 15 ), mESPECIF := Space( 35 ), mTELEF := Space( 14 ), ;
      mFAX := Space( 14 ), GETLIST := {}

   aAMBTEL := SALVAA()
   PADRAO( "TELEMEMO", "TELEMEMO", "mNOME+' '+mTELEF", "mNOME", "Cadastro de Telefones", "Nome Telefone", ;
      {|| PEGCHAVE( "mNOME", Space( 10 ), "Codigo:" ) }, "MDE001", "MDE001", {|| FO_RELL( "TELEMEMO" ) },, 4 )
   RESTAA( aAMBTEL )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function LOGOTIPO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION LOGOTIPO( TITULO )

   ANT := SetColor()
   SetColor( "W/N" )
   CLEAR
   SetColor( "+W/R" )
   @ 00, 00 CLEA TO 02, 79
   @ 01, 00 SAY PadC( TITULO, 80 )
   @ 21, 00 CLEA TO 23, 79
   SetColor( ANT )
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FIM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION FIM( TITULO )  // ENCERRA O PROGRAMA

   SetColor( "+W/BR,N/W" )
   CLEAR
   hb_DispBox( 20, 25, 22, 53, B_DOUBLE + " " )
   SetColor( "W/N" )
   @ 00, 00 SAY TITULO
   QUIT

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function QUADRO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION QUADRO( TITULO )   // (MOLDURA PARA TECLAS ESPECIAIS)

   SetColor( "+W/B" )
   hb_DispBox( 04, 07, 18, 71, B_DOUBLE + " " )
   @ 06, 09 SAY TITULO
   @ 07, 09 SAY "------------------------------------------------------------"
   @ 16, 09 SAY "------------------------------------------------------------"

   RETURN


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NEXTREC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION NEXTREC  // DA UM DBSKIP(E VERIFICA SE NAO E FINAL DE ARQUIVO

   dbskipex()
   IF Eof()
      MDT( ' --------- Vocˆ est  no fim do arquivo ! -------- ' )
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PREVREC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION PREVREC  // DA UM DBSKIP()-1 E VERIFICA SE NAO E COMECO DE ARQUIVO

   dbskipex( - 1 )
   IF Bof()
      MDT( ' -------- Voce esta no comeco do arquivo ! ------- ' )
   ENDIF

   RETURN ( .T. )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DELEREC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION DELEREC  // CONFIRMA E MARCA UM REGISTRO COMO DELETADO

   IF MDG( 'Confirma exclus„o ?' )
      netrecdel()
      PCK := .T.
   ELSE
      RECALL
   ENDIF
   NEXTREC()

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MD   // TELA PARA AS MENSAGENS

   @ MaxRow(), 00

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MDT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MDT( cMSG )  // EXIBE MENSAGEM POR UM TEMPO

   hb_Alert( cMSG,,, 1 )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MUDADATA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MUDADATA

   MDS( 'Digite a Data Operacional' )
   @ 24, 30 SAY digadata( DXDIA, 3, 3, 2, "," )
   @ 24, 70 GET DXDIA
   READCUR()
   ANO := Year( DXDIA )
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function OBSSAY()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION OBSSAY( LIN )  // AUXILIAR DE TRABALHO

   SetColor( "+N/W" )
   @ LIN, 09   SAY OBS1
   @ LIN + 1, 09 SAY OBS2
   @ LIN + 2, 09 SAY OBS3
   @ LIN + 3, 09 SAY OBS4
   @ LIN + 4, 09 SAY OBS5
   @ LIN + 5, 09 SAY OBS6
   @ LIN + 6, 09 SAY OBS7
   @ LIN + 7, 09 SAY OBS8
   SetColor( "W/N" )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function OBSGET()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION OBSGET( LIN )  // AUXILIAR DE TRABALHO

   SetColor( "+GR/B" )
   @ LIN, 09   GET OBS1
   @ LIN + 1, 09 GET OBS2
   @ LIN + 2, 09 GET OBS3
   @ LIN + 3, 09 GET OBS4
   @ LIN + 4, 09 GET OBS5
   @ LIN + 5, 09 GET OBS6
   @ LIN + 6, 09 GET OBS7
   @ LIN + 7, 09 GET OBS8
   READCUR()
   SetColor( "W/N" )

   RETURN .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOYD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FOYD

   IF !NETUSE( PES )
      dbCloseAll()
      RETU .F.
   ENDIF
   dbGoTop()
   WHILE !Eof()
      PETELA( 8 )
      netreclock()
      CorrigeFo_pes()
      dbUnlock()
      dbSkip()
   ENDDO
   dbCloseAll()

   RETURN


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CorrigeFo_pes()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CorrigeFo_pes()

   FIELD->CNUMERO   := StrZero( NUMERO, 8 )
   FIELD->DEPSETSEC := DEPTO * 1000000 + SETOR * 1000 + SECAO
   field->cpf       := formatacpf( CPF )
   field->RG        := formatarg( RG )
   FIELD->ENDER     := CorrigeEndereco( "ENDER", "ENDNUM", "ENDCOMPL", "ENDTIP" )

   IF NASCPAIS = "1058"
      FIELD->ANONASCI := 0
   ENDIF
   FIELD->PROFIS := StrZero( Val( PROFIS ), 7 )
   FIELD->SERIE  := StrZero( Val( SERIE ), 5 )
   IF Empty( FGTS )
      FIELD->FGTS := admitido
   ENDIF
   IF Empty( DEFICI )
      FIELD->DEFICI := "0"
   ENDIF
   IF DEFICI = "N"
      FIELD->DEFICI := "0"
   ENDIF
   IF DEFICI = "S"   // colocar codigo _ para forcar codigo valido 1/6
      FIELD->DEFICI := "_"
   ENDIF
   DO CASE
   CASE FIELD->OCOFGTS = "0" .OR. FIELD->OCOFGTS = "1" .OR. FIELD->OCOFGTS = "5" .OR. Empty( FIELD->OCOFGTS )
      FIELD->EOCO := "1"   // nao exposto
   CASE FIELD->OCOFGTS = "4" .OR. FIELD->OCOFGTS = "8"
      FIELD->EOCO := "2"   // 25 anos
   CASE FIELD->OCOFGTS = "3" .OR. FIELD->OCOFGTS = "7"
      FIELD->EOCO := "3"   // 20 anos
   CASE FIELD->OCOFGTS = "2" .OR. FIELD->OCOFGTS = "6"
      FIELD->EOCO := "4"   // 15 anos
   ENDCASE
   IF Empty( FIELD->EIADM )
      FIELD->EIADM := "1"  // 1 Normal 2 ação fiscal 3 ação judicial
   ENDIF
   IF Empty( FIELD->EREGI )
      FIELD->EREGI := "CLT"  // CLT RJV RJP
   ENDIF
   IF Empty( FIELD->EPREV )
      FIELD->EPREV := "RGPS"   // RGPS RPPS RPE
   ENDIF
   IF Empty( FIELD->ELTRA )
      FIELD->ELTRA := "1"  // 1 Urbano //2rural
   ENDIF
   IF Empty( FIELD->RGTIP )
      FIELD->RGTIP := "RG"
   ENDIF
   IF Empty( FIELD->ETJOR )
      FIELD->ETJOR := "1"  // padrao horario clt
   ENDIF
   IF Empty( FIELD->ETCOR )
      FIELD->ETCOR := "1"  // contrato indetermindo
   ENDIF

   IF Empty( "EVINC" )
      DO CASE
      CASE FIELD->CATEGORIA = "01"   // Funcionario rais=10
         FIELD->EVINC := "101"
      CASE FIELD->CATEGORIA = "07"   // aprendiz rais=55
         FIELD->EVINC := "103"
      CASE FIELD->CATEGORIA = "11"   // diretor rais=80
         FIELD->EVINC := "722"
      ENDCASE
      // rais 50=temporarios evinc="105"
   ENDIF

   IF Empty( "CATEGORIA" )
      DO CASE
      CASE FIELD->EVINC = "101"
         FIELD->CATEGORIA := "01"  // Funcionario rais=10
      CASE FIELD->EVINC = "103"
         FIELD->CATEGORIA := "07"  // aprendiz rais=55
      CASE FIELD->EVINC = "722"
         FIELD->CATEGORIA := "11"  // diretor rais=80
      ENDCASE
      // rais 50=temporarios evinc="105"
   ENDIF


   IF Empty( FIELD->TIPFGTS ) .AND. !Empty( FIELD->CATEGORIA ) .AND. !Empty( FIELD->E1ADM )
      cPREF := "9"
      IF FIELD->CATEGORIA = "07"
         cPREF := "3"
      ENDIF
      IF FIELD->CATEGORIA = "11"
         cPREF := "1"
      ENDIF
      IF !Empty( FIELD->dattransf )
         cPREF += "C"
      ELSE
         IF FIELD->E1ADM = "N"
            cPREF += "B"
         ELSE
            cPREF += "A"
         ENDIF
      ENDIF
      FIELD->TIPFGTS := cPREF
   ENDIF
   DO CASE
   CASE TIPO = "1"
      FIELD->TIPO := "M"
   CASE TIPO = "2"
      FIELD->TIPO := "Q"
   CASE TIPO = "3"
      FIELD->TIPO := "S"
   CASE TIPO = "4"
      FIELD->TIPO := "D"
   CASE TIPO = "5"
      FIELD->TIPO := "H"
   CASE TIPO = "6"
      FIELD->TIPO := "T"
   CASE TIPO = "7"
      FIELD->TIPO := "O"
   ENDCASE

   IF Empty( FIELD->RACS )
      cRACA := OBTER( "FO_RAIS",, "NUMERO", "RACA",,,,,, "" )
      cRACS := ""
      DO CASE
      CASE cRACA = "1"
         cRACS := "5"
      CASE cRACA = "2"
         cRACS := "1"
      CASE cRACA = "4"
         cRACS := "2"
      CASE cRACA = "6"
         cRACS := "3"
      CASE cRACA = "8"
         cRACS := "4"
      CASE cRACA = "9"
         cRACS := "9"
      ENDCASE
      IF !Empty( cRACS )
         FIELD->RACS := cRACS
      ENDIF
   ENDIF

   RETURN .T.

// !*****************************************************************************
// !
// !         Funcao: PETELA()
// !
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PETELA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION PETELA( COL )

   @ COL, 0 CLEAR TO COL + 2, 79
   @ COL, 00   SAY "+-DEPTO-++-SETOR-++-SECAO-++-CHAPA-++REGISTRO++--NOME DO FUNCIONARIO-----------+"
   @ COL + 1, 00 SAY "|       ||       ||       ||       ||        ||                                |"
   @ COL + 2, 00 SAY "+-------++-------++-------++-------++--------++--------------------------------+"
   @ COL + 1, 02 SAY DEPTO
   @ COL + 1, 12 SAY SETOR
   @ COL + 1, 21 SAY SECAO
   @ COL + 1, 30 SAY CHAPA
   @ COL + 1, 39 SAY NUMERO
   @ COL + 1, 48 SAY NOME

   RETURN .T.

// !*****************************************************************************
// !
// !         Funcao: PEGVALTAB(cTAB,nMES,nANO)
// !  ASSMED,ASSODO,FOPTOALM,TABARRE,TABTROCO
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGVALTAB()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC PEGVALTAB( cTAB, nMES, nANO )

   LOCAL aRETU := {}
   LOCAL lRETU := .F.

   IF ValType( nMES ) # "L"
      nMES := MESTRAB
   ENDIF
   IF ValType( nANO ) # "L"
      nANO := ANOUSO
   ENDIF
   aRETU := { 0, 0, 0, 0, 0 }
   IF !NETUSE( cTAB )
      RETU aRETU
   ENDIF
   dbGoTop()
   IF dbSeek( Str( nANO, 4 ) + Str( nMES, 2 ) )  // Tenta ano mes
      aRETU := { DESCT, DESCTB, DESCTC, DESCTD, DESCTE }
      lRETU := .T.
   ELSE
      IF dbSeek( Str( 0, 4 ) + Str( nMES, 2 ) )  // so mes
         aRETU := { DESCT, DESCTB, DESCTC, DESCTD, DESCTE }
         lRETU := .T.
      ENDIF
   ENDIF
   dbCloseArea()
   IF !lRETU
      ALERTX( "Nao Encontrado Valores tabela: " + cTAB )
   ENDIF
   RETU aRETU

// !*****************************************************************************
// !
// !         Funcao: PEGVALTIP(cTIPVAL,aVAL)
// !  ASSMED,ASSODO,FOPTOALM,TABARRE,TABTROCO
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGVALTIP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PEGVALTIP( cTIPVAL, aVAL )

   LOCAL nVALOR := 0

   IF !Empty( cTIPVAL ) .AND. cTIPVAL # 'N'
      DO CASE
      CASE cTIPVAL = "E"
         nVALOR := aVAL[ 5 ]
      CASE cTIPVAL = "D"
         nVALOR := aVAL[ 4 ]
      CASE cTIPVAL = "C"
         nVALOR := aVAL[ 3 ]
      CASE cTIPVAL = "B"
         nVALOR := aVAL[ 2 ]
      OTHERWISE    // A ou S
         nVALOR := aVAL[ 1 ]
      ENDCASE
   ENDIF
   RETU nVALOR

// !*****************************************************************************
// !
// !         Fun‡„o: PEGFOLMES()
// !
// !*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGFOLMES()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION PEGFOLMES()

   CONTINUA := .T.
   WHILE CONTINUA
      @  7, 0 CLEAR
      @ 09, 14 SAY "+-----------------------------------------------------+"
      @ 10, 14 SAY "|         ESCOLHA O MES QUE DESEJA TRABALHAR:         |"
      @ 11, 14 SAY "|-----------------------------------------------------|"
      @ 12, 14 SAY "|" + SPAC( 53 ) + "|"
      @ 13, 14 SAY "|" + SPAC( 53 ) + "|"
      @ 14, 14 SAY "|" + SPAC( 53 ) + "|"
      @ 15, 14 SAY "|" + SPAC( 53 ) + "|"
      @ 16, 14 SAY "+-----------------------------------------------------+"
      OPCAO( 12, 16, ' Janeiro   ', 74 )
      OPCAO( 13, 16, ' Fevereiro ', 70 )
      OPCAO( 14, 16, ' Marco     ', 77 )
      OPCAO( 15, 16, ' Abril     ', 65 )
      OPCAO( 12, 35, ' 5-maio    ', 73 )
      OPCAO( 13, 35, ' 6-junho   ', 78 )
      OPCAO( 14, 35, ' 7-julho   ', 76 )
      OPCAO( 15, 35, ' 8-agosto  ', 71 )
      OPCAO( 12, 53, ' Setembro  ', 83 )
      OPCAO( 13, 53, ' Outubro   ', 79 )
      OPCAO( 14, 53, ' Novembro  ', 86 )
      OPCAO( 15, 53, ' Dezembro  ', 68 )
      OP := MENU( Month( Date() ), 0 )
      IF OP > 0
         IF MDG( 'Confirme: ' + Mmes( OP ) )
            CONTINUA := .F.
         ENDIF
      ENDIF
   ENDDO
   RETU OP


// !*****************************************************************************
// !
// !         Fun‡„o: PEGFOLSEN()
// !
// !*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGFOLSEN()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION PEGFOLSEN( lDIR )

   IF ValType( lDIR ) # "L"
      lDIR := .T.
   ENDIF
   WHILE CONSEN
      NRSEN := SPAC( 5 )
      MDS( 'DIGITE A SUA SENHA EMPRESA' )
      SetColor( "G/G,G/G" )
      @ 24, 57 GET NRSEN
      READCUR()
      SetColor( "W/N,N/W" )
      // IF NRSEN='HELPS'
      // OP_SENHA='MENTOR'
      // ENDIF
      IF NRSEN = 'DISKC' .OR. NRSEN = MSG3
         CONSEN := .F.
      ELSE
         IF NRSEN = 'DiReT'
            IF !lDIR
               ALERTX( "Nao Processa Diretores" )
            ELSE
               CONSEN := .F.
            ENDIF
         ENDIF
      ENDIF
   ENDDO

   RETURN NRSEN


// !*****************************************************************************
// !
// !         Fun‡„o: PEGFOLPAT()
// !
// !*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGFOLPAT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION PEGFOLPAT()

// Verifica o ano Se nao e' 00 (ano atual)
   IF File( hb_cwd() + 'EMP' + ANOWORK + StrZero( NREMP, 3 ) + "\FO_PES.DBF" )
      ZDIRE := hb_cwd() + 'EMP' + ANOWORK + StrZero( NREMP, 3 ) + "\"
   ELSE
      ZDIRE := hb_cwd() + 'EMP' + StrZero( NREMP, 5 ) + "\"
      IF !hb_FileExists( ZDIRE + "FO_PES.DBF" )
         ALERTX( "Falta Arquivo de Funcionarios" )
         NREMP := 0
         RETURN .F.
      ENDIF
   ENDIF
   ZDIRN := hb_cwd() + 'E' + StrZero( ANOUSO, 4 ) + "\"
   MakeDir( ZDIRE )
   MakeDir( ZDIRN )

   cPATH := ZDIRE + ";" + ZDIRN
   Set( _SET_PATH, cPATH )
// ser path to &cPath.
// ZDIRE+= "\"
// ZDIRN+= "\"

   RETURN .T.


// !*****************************************************************************
// !
// !         Fun‡„o: SALHM()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function SALHM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION SALHM( XXMES, XXANO, lOPEN )   // CALCULA SALARIO MES E HORA

   LOCAL cALIAS, xNUMERO, XSAL, VAR1

   IF ValType( lOPEN ) <> "L"
      lOPEN := .T.
   ENDIF
   xNUMERO := NUMERO
   cALIAS  := dbSelectAr()
   IF lOPEN
      IF !netuse( "fo_sal" )
         salh := 0
         salm := 0
         RETURN 0
      ENDIF
   ENDIF
   XXMES := IF( ValType( XXMES ) = "N" .AND. XXMES # 0, XXMES, MESTRAB )
   XXANO := IF( ValType( XXANO ) = "N" .AND. XXANO # 0, XXANO, ANOUSO )
   XSAL  := 'SAL' + SubStr( MMES( XXMES ), 1, 3 )
   dbSelectAr( "fo_sal" )
   dbGoTop()
   IF dbSeek( Str( xNUMERO, 8 ) + Str( XXANO, 4 ) )
      VAR1 := &XSAL.
   ELSE
      netrecapp()
      field->numero := xNUMERO
      field->ano    := xxano
      dbUnlock()
      var1 := 0
   ENDIF
   IF lOPEN
      dbSelectAr( "fo_sal" )
      dbCloseArea()
   ENDIF
   IF !Empty( cALIAS )
      dbSelectAr( cALIAS )
   ENDIF
   DO CASE
   CASE TIPO = '1' .OR. TIPO = "M"
      SALH := ( VAR1 / MESHORA )
      SALM := VAR1
   CASE TIPO = '5' .OR. TIPO = "H"
      SALH := VAR1
      SALM := VAR1 * MESHORA
   ENDCASE

   RETURN SALM




// + EOF: disklib.prg
// +
