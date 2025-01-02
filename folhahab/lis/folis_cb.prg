// +--------------------------------------------------------------------
// +
// +    Programa  : folis_cb.prg Listar Resumo Rais Empresa Empregados
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


FUNCTION folis_cb()

   IF !MDL( 'Listar RAIS Resumo Empregados', 0 )
      RETU
   ENDIF
   CTLIN    := 1
   MESTADO  := ""
   MCIDADE  := ""
   MNESTADO := ""
   MNCIDADE := ""
   MPAIS    := ""


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

   IF !NETUSE( "FORAIS" )
      dbCloseAll()
      RETU .F.
   ENDIF

   nVEZES := 3
   IMPRESSORA()
   dbSelectAr( PES )
   dbGoTop()
   WHILE !Eof()
      mNUMERO := NUMERO
      ALLTRUE( CHECKCID(,, .F., IBGE, { { "UF", "mESTADO" }, { "NOME", "mCIDADE" } } ) )
      ALLTRUE( CheckBacen( NASCPAIS, mPAIS, .F., { { "STRZERO(BACEN,4)", "NACPAIS" }, { "NOME", "mPAIS" } } ) )
      IF nVEZES = 3
         CTLIN := 1
         @ CTLIN, 0 SAY Replicate( "-", 80 )
         nVEZES := 1
      ELSE
         nVEZES := nVEZES + 1
      ENDIF
      dbSelectAr( "FORAIS" )
      dbGoTop()
      IF !dbSeek( Str( nanouso, 4 ) + Str( mNUMERO, 8 ) )
         netrecapp()
         field->numero := mNUMERO
         field->ano    := nanouso
      ENDIF

      CTLIN++
      @ CTLIN, 3  SAY "PIS/PASEP     : " + PIS
      @ CTLIN, 34 SAY "Nome: " + NOME
      CTLIN++
      @ CTLIN, 3  SAY "Cart.Profiss. : " + IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, Left( TIRAOUT( CPF ), 7 ) + "/" + SubStr( TIRAOUT( CPF ), 8 ), PROFIS + "-" + SERIE + "/" + CTPSUF ) // CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
      @ CTLIN, 35 SAY "CPF: " + CPF
      @ CTLIN, 54 SAY "Data Adm: " + DToC( ADMITIDO )
      @ CTLIN, 73 SAY "Tipo: " + FORAIS->TIPOADM
      CTLIN++
      @ CTLIN, 3  SAY "Data Nascim.  : " + DToC( NASC )
      @ CTLIN, 35 SAY "CBO:" + OBTER( "FUNCAO",, FO_PES->FUNCAO, "CBONEW" ) // CBONEW
      @ CTLIN, 53 SAY "Vinculo: " + FORAIS->RAISVINC
      @ CTLIN, 68 SAY "Escolaridade: " + ESCRAIS
      CTLIN++
      IF Empty( DEMITIDO )
         tSAL := "SALDEZ"
      ELSE
         MESDEM := Month( DEMITIDO )
         XSAL   := MMES( Month( DEMITIDO ) )
         XSAL   := SubStr( XSAL, 1, 3 )
         tSAL   := 'SAL' + XSAL
      ENDIF
      @ CTLIN, 3  SAY "Sal.Contrat. -> " + TRANS( &TSAL., "@E 9999999999.99" )
      @ CTLIN, 34 SAY "Tipo: " + TIPO + " HS sem: " + Str( HRSEM, 5, 2 )
      @ CTLIN, 56 SAY "Dem-> " + FORAIS->RAISDEM + " Dia/Mes: " + SubStr( DToC( DEMITIDO ), 1, 5 )
      CTLIN++
      @ CTLIN, 3  SAY "Opcao FGTS ---> " + IF( Empty( FGTS ), "2", "1" ) + "  Data: " + DToC( FGTS )
      @ CTLIN, 42 SAY "Nacionalidade-> " + NASCPAIS + IF( NACPAIS <> "1058", " Ano Chegada: " + Str( ANONASCI, 2 ) + ' ' + mPAIS, "" )
      CTLIN++
      dbSelectAr( "FORAIS" )

      @ CTLIN, 3  SAY "13.Sal.Adiant-> " + TRANS( SAL13_1, "@E 9999999.99" )
      @ CTLIN, 33 SAY "Mes: " + Str( MES_1, 2 )
      @ CTLIN, 42 SAY "13 Parc.Final-> " + TRANS( SAL13_2, "@E 9999999.99" )
      @ CTLIN, 72 SAY "Mes: " + Str( MES_2, 2 )
      CTLIN++
// @ CTLIN, 30 say "Remuneracao em R$"
// CTLIN++
      @ CTLIN, 3  SAY "Jan " + Transform( RAIZJAN, "@E 9999999.99" )
      @ CTLIN, 20 SAY "Jul " + Transform( RAIZJUL, "@E 9999999.99" )
      @ CTLIN, 40 SAY "Aviso  " + Transform( RAIZAVI, "@E 9999999.99" )
      CTLIN++
      @ CTLIN, 3  SAY "Fev " + Transform( RAIZFEV, "@E 9999999.99" )
      @ CTLIN, 20 SAY "Ago " + Transform( RAIZAGO, "@E 9999999.99" )
      @ CTLIN, 40 SAY "FerInd " + Transform( RAIZFER, "@E 9999999.99" )
      CTLIN++
      @ CTLIN, 3  SAY "Mar " + Transform( RAIZMAR, "@E 9999999.99" )
      @ CTLIN, 20 SAY "Set " + Transform( RAIZSET, "@E 9999999.99" )
      @ CTLIN, 40 SAY "Acresc " + Transform( RAIZACR, "@E 9999999.99" )
      @ CTLIN, 60 SAY MESACR
      CTLIN++
      @ CTLIN, 3  SAY "Abr " + Transform( RAIZABR, "@E 9999999.99" )
      @ CTLIN, 20 SAY "Out " + Transform( RAIZOUT, "@E 9999999.99" )
      @ CTLIN, 40 SAY "Gratif " + Transform( RAIZGRA, "@E 9999999.99" )
      @ CTLIN, 60 SAY MESGRA
      CTLIN++
      @ CTLIN, 3  SAY "Mai " + Transform( RAIZMAI, "@E 9999999.99" )
      @ CTLIN, 20 SAY "Nov " + Transform( RAIZNOV, "@E 9999999.99" )
      @ CTLIN, 40 SAY "MFgts  " + Transform( RAIZMUL, "@E 9999999.99" )
      CTLIN++
      @ CTLIN, 3  SAY "Jun " + Transform( RAIZJUN, "@E 9999999.99" )
      @ CTLIN, 20 SAY "Dez " + Transform( RAIZDEZ, "@E 9999999.99" )
      @ CTLIN, 40 SAY "BcoHrs " + Transform( RAIZBCH, "@E 9999999.99" )
      @ CTLIN, 60 SAY MESBCH
      CTLIN++
      @ CTLIN, 2 SAY "Confederativa CNPJ:" + CGCCON + " Valor:" + Transform( VALCON, "@E 9999999.99" )
      CTLIN++
      @ CTLIN, 2 SAY "Associativa   CNPJ:" + CGCSOC1 + " Valor:" + Transform( VALSOC1, "@E 9999999.99" )
      CTLIN++
      @ CTLIN, 2 SAY "Assistencial  CNPJ:" + CGCASS + " Valor:" + Transform( VALASS, "@E 9999999.99" )
      CTLIN++
      @ CTLIN, 2 SAY "Sindical      CNPJ:" + CGCSIN + " Valor:" + Transform( VALSIN, "@E 9999999.99" )
      CTLIN++

      @ CTLIN, 0 SAY Replicate( "-", 80 )
      dbSelectAr( PES )
      dbSkip()
   ENDDO
   dbCloseAll()
   IMPFOL()
   VIDEO()
   IMPEND()

   RETURN .T.

// + EOF: folis_cb.prg
// +
