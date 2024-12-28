// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foy4.prg
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


IF MDG( 'Refaz controles da folha' )
LIMPAR( FOL, FOL )
dbCloseAll()
ENDIF
IF MDG( 'Refazer Folha V.Transp.' )
LIMPAR( "VTFOLHA", "VTFOLHA" )
ENDIF
IF MDG( 'Refazer Folha V.Transp Avulsa' )
LIMPAR( "VTAVUL", "VTAVUL" )
ENDIF
IF MDG( 'Refazer Programa V.Transp ' )
LIMPAR( "VTFIXO", "VTFIXO" )
ENDIF
IF MDG( 'Refaz controles Folha F‚rias' )
LIMPAR( "FO_PFE", "FO_PFE" )
ENDIF
IF MDG( 'Refaz controles Folha Rescis„o' )
LIMPAR( "FO_RSS", "FO_RSS" )
ENDIF
RETU
IF MDG( 'Refaz controles Folha 13 Salario' )
LIMPAR( PEG13( 1 ) )
LIMPAR( PEG13( 2 ) )
LIMPAR( PEG13( 3 ) )
LIMPAR( PEG13( 4 ) )
ENDIF

   RETURN


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function limpar()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC limpar( cARQ, cIND )

   IF ValType( cIND ) # "C"
      cIND := cARQ
   ENDIF
   IF !netuse( pes )
      RETU .F.
   ENDIF
   IF !netuse( carq )
      dbCloseAll()
      RETU .F.
   ENDIF
   dbSelectAr( cARQ )
   nLASTREC := LastRec()
   MDS( "Ajustando Codigos de Trabalho" )
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "CONTROLE", ( NUMERO * 10000 ) + CONTA ) },, {|| zei_fort( nLASTREC,,, 1 ) } )

// arqui nao funciona dbeval pos a comparacao e apos skip duplicidades
   MDS( "Checando Codigos de Trabalho" )
   dbGoTop()
   WHILE !Eof()
      ctr := controle
      dbSkip()
      IF controle = ctr
         netrecdel()
      ENDIF
   ENDDO

   MDS( "Excluindo funcionarios 0" )
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netrecDel() }, {|| NUMERO = 0 }, {|| zei_fort( nLASTREC,,, 1 ) } )
   MDS( "Excluindo Contas=0" )
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netrecdel() }, {|| CONTA = 0 }, {|| zei_fort( nLASTREC,,, 1 ) } )
   MDS( "Excluindo Lancamentos com valor e horas zerados" )
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netrecdel() }, {|| HORAS = 0 .AND. VALOR = 0 }, {|| zei_fort( nLASTREC,,, 1 ) } )

   MDS( "Checando Consistencia Dados" )
   dbSelectAr( cARQ )
   dbGoTop()
   WHILE !Eof()
      mNUMERO := NUMERO
      dbSelectAr( PES )
      dbGoTop()
      lACHEI := dbSeek( mNUMERO )
      dbSelectAr( cARQ )
      WHILE mNUMERO = NUMERO .AND. !Eof()
         IF !lACHEI
            netrecdel()
         ENDIF
         dbSkip()
      ENDDO
      @ 24, 00 SAY CONTROLE
   ENDDO
   dbSelectAr( cARQ )
   dbCloseAll()
   MDS( "Fixando o Arquivo" )
   netpack( Carq )
   RETU .T.


// + EOF: foy4.prg
// +
