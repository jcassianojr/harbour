// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foic1.prg
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
// :     FOIC1.PRG : LISTAR RESUMO GERENCIAL
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/25/94     12:14
// :
// :*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foic1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foic1

   PARA CC

   IF !MDL( 'LISTAR RESUMO GERENCIAL' )
      RETU
   ENDIF
   FILEcopy( "AJUGER.DBF", "AJUGERD.DBF" )

   DIV := 1.00
   MDS( 'Digite o divisor' )
   @ 24, 35 GET DIV PICT '###,###.##'
   READCUR()

   POS1 := SPAC( 40 )
   MDS( 'DIGITE O NOME DO RESUMO' )
   @ 24, 38 GET POS1
   READCUR()

   IF CC = 1
      FILTRO  := 'SETOR=0.AND.SECAO=0'
      TIPORES := 'Por Departamento'
   ENDIF
   IF CC = 2
      FILTRO  := 'SETOR<>0.AND.SECAO=0'
      TIPORES := 'Por Setor'
   ENDIF
   IF CC = 3
      FILTRO  := 'SETOR<>0.AND.SECAO<>0'
      TIPORES := 'Por Secao'
   ENDIF

   DECLARE TOTD[ 15 ], TOTS[ 15 ], TOTT[ 15 ]
   AFill( TOTD, 0 )
   AFill( TOTS, 0 )
   AFill( TOTT, 0 )

   IF !NETUSE( "AJUGERD" )
      RETU
   ENDIF

   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "VL1", VL1 / DIV ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "VL2", VL2 / DIV ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "VL3", VL3 / DIV ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "VL4", VL4 / DIV ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "VL5", VL5 / DIV ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "SALARIO", SALARIO / DIV ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
   zei_fort( nLASTREC,,, 0 )
   dbEval( {|| netgrvcam( "TURN", TURN / DIV ) },, {|| zei_fort( nLASTREC,,, 1 ) } )
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "AJUGERD" )
   ordCreate(, "AJUGERD", "CONTROLE " )
   ordSetFocus( "AJUGERD" )


   FI     := Trim( FILTRO )
   FILTRO := FILTRO( FI )
   SET FILTER TO &FILTRO
   dbGoTop()
   WHILE !Eof()
      FOR Q := 1 TO 5
         QTW := 'QT' + Str( Q, 1 )
         VLW := 'VL' + Str( Q, 1 )
         TOTT[ Q ] += &QTW.
         TOTT[ Q + 5 ] += &VLW.
      NEXT X
      TOTT[ 11 ] += ADM
      TOTT[ 12 ] += DEM
      TOTT[ 13 ] += ATI
      TOTT[ 14 ] += SALARIO
      TOTT[ 15 ] += TURN
      dbSkip()
   ENDDO

   IF !NETUSE( "TILRESG",,,,, .F., )
      RETU
   ENDIF

   IF MDG( 'Deseja Gravar em Arquivo' )
      // ARQUIVO='GERENCIAL.TXT'
      // MDS('Confirme o nome do Arquivo')
      // @ 24,40 GET ARQUIVO
      // READCUR()
      ARQUIVO := WIN_GETSAVEFILENAME(, "Salvar Gerencial", hb_cwd(), "txt", "*.txt", 1,, "gerencial.txt" )
      USO     := FCreate( ARQUIVO )
      IF FError() # 0
         ALERTX( "Erro na Criacao do Arquivo" )
         RETURN .F.
      ENDIF
      FWrite( USO, REPL( '-', 240 ) + Chr( 13 ) + Chr( 10 ) )
      FWrite( USO, 'RESUMO GERENCIAL' + Chr( 13 ) + Chr( 10 ) )
      FWrite( USO, REPL( '-', 240 ) + Chr( 13 ) + Chr( 10 ) )
      FWrite( USO, "DEPT SET SEC NOME" + SPAC( 12 ) + "ATI  ADM  DEM  " )
      FWrite( USO, "SALARIO" + SPAC( 14 ) )
      dbSelectAr( "TILRESG" )
      dbGoTop()
      WHILE !Eof()
         FWrite( USO, TITULO + SPAC( 17 ) )
         dbSkip()
      ENDDO
      FWrite( USO, 'TURNOVER' + Chr( 13 ) + Chr( 10 ) )
      FWrite( USO, SPAC( 65 ) )
      FOR X := 1 TO 5
         FWrite( USO, 'HORAS      VALOR' + SPAC( 13 ) )
      NEXT X
      FWrite( USO, Chr( 13 ) + Chr( 10 ) )
      FWrite( USO, REPL( '-', 240 ) + Chr( 13 ) + Chr( 10 ) )
      dbSelectAr( "AJUGERD" )
      dbGoTop()
      WHILE !Eof()
         MDS( NOME )
         FWrite( USO, Str( DEPTO, 4 ) + ' ' )
         FWrite( USO, Str( SETOR, 3 ) + ' ' )
         FWrite( USO, Str( SECAO, 3 ) + ' ' )
         FWrite( USO, NOME + ' ' )
         FWrite( USO, Str( ATI, 4 ) + ' ' )
         FWrite( USO, Str( ADM, 4 ) + ' ' )
         FWrite( USO, Str( DEM, 4 ) + ' ' )
         FWrite( USO, Str( SALARIO, 18, 2 ) + ' ' )
         FOR X := 1 TO 5
            QTW := 'QT' + Str( X, 1 )
            VLW := 'VL' + Str( X, 1 )
            FWrite( USO, Str( &QTW, 9, 2 ) + ' ' )
            FWrite( USO, Str( &VLW, 18, 2 ) + ' ' )
         NEXT X
         FWrite( USO, Str( TURN, 18, 2 ) + ' ' + Chr( 13 ) + Chr( 10 ) )
         dbSkip()
      ENDDO
      FWrite( USO, REPL( '-', 240 ) + Chr( 13 ) + Chr( 10 ) )
      FClose( USO )
      dbCloseAll()
      RETU
   ENDIF
   IF MDG( 'Deseja em 132 colunas' )
      FOIC1A()
   ELSE
      FOIC1B()
   ENDIF
   RETU
// : FIM: FOIC1.PRG

// + EOF: foic1.prg
// +
