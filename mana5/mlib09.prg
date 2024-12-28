// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib09.prg
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
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +
// +
// +--------------------------------------------------------------------
// +





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MESANO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MESANO( eMES, eANO )

   LOCAL aDAD
   PRIV GETLIST := {}

   aDAD := PEGMES( { "" } )
   IF ValType( eMES ) = "C"
      &eMES. := aDAD[ 1 ]
   ENDIF
   IF ValType( eANO ) = "C"
      &eANO. := aDAD[ 2 ]
   ENDIF
   RETU aDAD[ 4 ] + aDAD[ 3 ]



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEDPER()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PEDPER( lPER, aPER )

   LOCAL lRETU := .T.
   LOCAL lACUM := .T.

   IF ValType( aPER ) = "A"
      nINIANO := aPER[ 1 ]
      nFIMANO := aPER[ 2 ]
      nINIMES := aPER[ 3 ]
      nFIMMES := aPER[ 4 ]
      lACUM   := aPER[ 6 ]
   ELSE
      nINIANO := Year( ZDATA )
      nFIMANO := Year( ZDATA )
      nINIMES := Month( ZDATA )
      nFIMMES := Month( ZDATA )
   ENDIF
   IF lPER
      MDS( "Digite o Periodo Mˆs e Ano" )
      @ 24, 30      SAY "Inicial"
      @ 24, Col() + 1 GET nINIMES
      @ 24, Col() + 1 GET nINIANO
      @ 24, Col() + 1 SAY "Final"
      @ 24, Col() + 1 GET nFIMMES
      @ 24, Col() + 1 GET nFIMANO
      IF !READCUR()
         lRETU := .F.
      ENDIF
      mds( "" )
   ENDIF
   nMESES := 0
   IF nINIANO = nFIMANO
      nMESES := nFIMMES - nINIMES + 1
   ELSE
      nMESES += 13 - nINIMES
      nMESES += nFIMMES
      IF nFIMANO - nINIANO > 1
         nMESES += ( nFIMANO - nINIANO - 1 ) * 12
      ENDIF
   ENDIF
   RETU { nINIANO, nFIMANO, nINIMES, nFIMMES, lRETU, lACUM, nMESES }



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGMES()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PEGMES( aDAD, lPER, aBAS )

   LOCAL cARQ
   LOCAL mMES
   LOCAL mANO
   LOCAL cMESUSO
   LOCAL cANOUSO
   LOCAL X
   LOCAL lFEC
   LOCAL aRETU   := { 0, 0, "XX", "XX", aDAD, 0, "MM/YYYY", .F. }

   lfec := .T.
   IF ValType( lper ) # "L"
      lper := .F.
   ENDIF
   mMES := Month( ZDATA )
   mANO := Year( ZDATA )
   MDS( "Confirme a Competencia" )
   @ 24, 50 GET mMES PICT "99"
   @ 24, 60 GET mANO PICT "9999"
   IF !READCUR()
      RETU aRETU
   ENDIF
   mds( "" )
   IF lper
      IF !mdg( "Mes fechado" )
         lfec := .F.
      ENDIF
   ENDIF
   aRETU := {}
   AAdd( aRETU, mMES )  // 1 mes
   AAdd( aRETU, mANO )  // 2 ano
   AAdd( aRETU, StrZero( mMES, 2 ) )   // 3 mes string
   AAdd( aRETU, SubStr( StrZero( mANO, 4 ), 3, 2 ) )   // 4 ano string AA
   FOR X := 1 TO Len( aDAD )
      IF lfec
         cARQ := aDAD[ X ] + aRETU[ 4 ] + aRETU[ 3 ]
         aDAD[ X ] = cARQ
      ELSE
         IF ValType( aBAS ) = "A"
            cARQ := aBAS[ X ]
            aDAD[ X ] = cARQ
         ENDIF
      ENDIF
   NEXT X
   AAdd( aRETU, aDAD )  // 5 nomes do arquivos
   AAdd( aRETU, 2 )   // 6 -- tipo 2 mes fechado
   AAdd( aRETU, MMES( aRETU[ 1 ] ) + "/" + StrZero( mANO, 4 ) )  // 7 Competencia
   RETU aRETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PERFEC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC PERFEC( aNOR, aSTR, aFEC, aDAT )  // aDAT nome do campo da data para o somano

// padrao funcao DATA "PADRAO" p/Competencia

   LOCAL aRETU := { 0, 0, "XX", "XX", aNOR, 1, CMES( ZDATA ) + "/" + StrZero( Year( ZDATA ), 4 ) }
   LOCAL X
   IF MDG( "Mes j  Fechado" )
      aRETU := PEGMES( aSTR )
   ELSE
      IF MDG( "Deseja Acumulado" )
         aPER := PEDPER( .T. )
         IF MDG( "Deseja Reacumular" )
            FOR X := 1 TO Len( aFEC )
               IF ValType( aDAT ) = "A"
                  SOMAANO( aFEC[ X ], aSTR[ X ], aDAT[ X ],,,,,, aPER )
               ELSE
                  SOMAANO( aFEC[ X ], aSTR[ X ],,,,,,, aPER )
               ENDIF
            NEXT X
         ENDIF
         aRETU := { 0, 0, "XX", "XX", aFEC, 3, MMES( aPER[ 3 ] ) + "/" + StrZero( aPER[ 1 ], 4 ) + " - " + MMES( aPER[ 4 ] ) + "/" + StrZero( aPER[ 2 ], 4 ) }   // tipo 3 acumulado
      ENDIF
   ENDIF
   RETU aRETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function SOMAANO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC SOMAANO( cARQSOM, cSTRREF, cVARSOM, bSOMA, cATU, eDAT, cBAI, eDA2, aPER, bUSE )

   LOCAL lAC01 := lAC02 := lAC03 := .F.

   CRIARVARS( cARQSOM )
   IF ValType( aPER ) # "A"
      aPER := PEDPER( .F. )
   ENDIF
   IF ( Empty( cATU ) .AND. Empty( cBAI ) ) .OR. MDG( "Reacumular o Periodo" )
      aPER  := PEDPER( .T., aPER )
      lAC01 := .T.
   ENDIF
   IF !Empty( cBAI ) .AND. MDG( "Incluir Baixados" )
      lAC02 := .T.
   ENDIF
   IF !Empty( cATU ) .AND. MDG( "Incluir Ativos" )
      lAC03 := .T.
   ENDIF
   ZAPARQ( { { cARQSOM, .F., .T. } } )
   IF lAC01
      DO CASE
      CASE aPER[ 1 ] = aPER[ 2 ]
         FOR X := aPER[ 3 ] TO aPER[ 4 ]
            SOMAARQ( X, aPER[ 1 ], cSTRREF, cARQSOM, cVARSOM, bSOMA, bUSE )
         NEXT X
      CASE aPER[ 1 ] + 1 = aPER[ 2 ]
         FOR X := aPER[ 3 ] TO 12
            SOMAARQ( X, aPER[ 1 ], cSTRREF, cARQSOM, cVARSOM, bSOMA, bUSE )
         NEXT X
         FOR X := 1 TO aPER[ 4 ]
            SOMAARQ( X, aPER[ 2 ], cSTRREF, cARQSOM, cVARSOM, bSOMA, bUSE )
         NEXT X
      OTHERWISE
         FOR X := aPER[ 3 ] TO 12
            SOMAARQ( X, aPER[ 1 ], cSTRREF, cARQSOM, cVARSOM, bSOMA, bUSE )
         NEXT X
         FOR Y := aPER[ 1 ] + 1 TO aPER[ 2 ] - 1
            FOR X := 1 TO 12
               SOMAARQ( X, Y, cSTRREF, cARQSOM, cVARSOM, bSOMA, bUSE )
            NEXT X
         NEXT Y
         FOR X := 1 TO aPER[ 4 ]
            SOMAARQ( X, aPER[ 2 ], cSTRREF, cARQSOM, cVARSOM, bSOMA, bUSE )
         NEXT X
      ENDCASE
   ENDIF
   IF lAC02
      SOMAARQ(,, AllTrim( cBAI ), cARQSOM, eDA2 )
   ENDIF
   IF lAC03
      SOMAARQ(,, AllTrim( cATU ), cARQSOM, eDAT )
   ENDIF
   dbCloseAll()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function SOMAARQ()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC SOMAARQ( nMES, nANO, cREF, cARQREF, cVARSOM, bBLOCO, bUSE )

   LOCAL cANO, cMES, cARQ

   IF ValType( nANO ) = "N" .AND. ValType( nMES ) = "N"
      cANO := SubStr( StrZero( nANO, 4 ), 3, 2 )
      cMES := StrZero( nMES, 2 )
      cARQ := cREF + cANO + cMES
   ELSE
      cARQ := cREF
   ENDIF
   IF ValType( bBLOCO ) = "B"
      Eval( bBLOCO, nMES, nANO, cARQ, cARQREF )
      RETU .F.
   ENDIF
   MDS( "Aguarde Apurando " + cARQ )
   IF ValType( bUSE ) = "B"
      Eval( bUSE, cARQ )
   ELSE
      IF !USEREDE( cARQ, 1, 0 )
         RETU .F.
      ENDIF
   ENDIF
   IF ValType( "DATA" ) = "U" .AND. ValType( "cVARSOM" ) = "U"   // Verifica se o arquivo tem o campo data
      cVARSOM := "PADRAO"
   ENDIF
   dbGoTop()
   WHILE !Eof()
      EQUVARS()
      IF ValType( cVARSOM ) = "C"
         IF cVARSOM = "PADRAO"
            mMES := nMES
            mANO := nANO
         ELSE
            mMES := Month( &cVARSOM. )
            mANO := Year( &cVARSOM. )
         ENDIF
      ELSE
         mMES := Month( DATA )
         mANO := Year( DATA )
      ENDIF
      NOVOOPA( cARQREF,,, .F. )
      dbSelectAr( cARQ )
      dbSkip()
   ENDDO
   dbCloseArea()
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CALCPER()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CALCPER( aPER, nANO, nMES, eCALC )

   IF nANO = aPER[ 1 ] .AND. aPER[ 1 ] # aPER[ 2 ]
      IF nMES >= aPER[ 3 ]
         Eval( eCALC )
      ENDIF
   ENDIF
   IF nANO = aPER[ 2 ]
      IF aPER[ 1 ] = aPER[ 2 ]
         IF nMES >= aPER[ 3 ] .AND. nMES <= aPER[ 4 ]
            Eval( eCALC )
         ENDIF
      ELSE
         IF nMES <= aPER[ 4 ]
            Eval( eCALC )
         ENDIF
      ENDIF
   ENDIF
   RETU .T.


// + EOF: mlib09.prg
// +
