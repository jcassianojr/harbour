// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib08.prg
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
// +    Function MPAGAR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MPAGAR( cCOND, nVALOR, dDATA, lGRAVA, dENTREGA )

   LOCAL aRETU   := Array( 3, 10 )
   LOCAL aDIA
   LOCAL aPOR
   LOCAL aCAI    := {}
   LOCAL X
   LOCAL cSEMANA
   LOCAL cDATA
   LOCAL nDATAS  := 0
   LOCAL lCAI

   IF ValType( lGRAVA ) # "L"
      lGRAVA := .F.
   ENDIF
   FOR X := 1 TO 10
      aRETU[ 1, X ] := CToD( "  /  /  " )
      aRETU[ 2, X ] := 0.00
      aRETU[ 3, X ] := ""
   NEXT X
   IF Empty( nVALOR )
      ALERTX( "N„o h  valor para distribuir pagamentos" )
      RETU aRETU
   ENDIF
   IF Empty( dDATA )
      ALERTX( "N„o h  DATA para distribuir pagamentos" )
      RETU aRETU
   ENDIF
   IF !USEREDE( "MJ01", 1, 1 )
      RETU aRETU
   ENDIF
   dbGoTop()
   IF dbSeek( cCOND )
      aDIA           := { DIA1, DIA2, DIA3, DIA4, DIA5, DIA6, DIA7, DIA8, DIA9, DIA10 }
      aPOR           := { POR1, POR2, POR3, POR4, POR5, POR6, POR7, POR8, POR9, POR10 }
      aRETU[ 3, 1 ]  := TPC01
      aRETU[ 3, 2 ]  := TPC02
      aRETU[ 3, 3 ]  := TPC03
      aRETU[ 3, 4 ]  := TPC04
      aRETU[ 3, 5 ]  := TPC05
      aRETU[ 3, 6 ]  := TPC06
      aRETU[ 3, 7 ]  := TPC07
      aRETU[ 3, 8 ]  := TPC08
      aRETU[ 3, 9 ]  := TPC09
      aRETU[ 3, 10 ] := TPC10
      IF !Empty( CAI1 )
         AAdd( aCAI, CAI1 )
      ENDIF
      IF !Empty( CAI2 )
         AAdd( aCAI, CAI2 )
      ENDIF
      IF !Empty( CAI3 )
         AAdd( aCAI, CAI3 )
      ENDIF
      IF !Empty( CAI4 )
         AAdd( aCAI, CAI4 )
      ENDIF
      cSEMANA := SEMANA
      cDATA   := DATA
   ELSE
      dbCloseArea()
      ALERTX( "Condi‡„o de Pagamento n„o Encontrada" )
      RETU aRETU
   ENDIF
   dbCloseArea()
   IF cDATA = "E" .AND. ValType( dENTREGA ) = "D"
      IF !Empty( dENTREGA )
         dDATA := dENTREGA - 1
      ENDIF
   ENDIF
   IF cDATA = "S" .AND. DoW( dDATA ) = 2   // Se ‚ Segunda e fora semana requer +1
      dDATA++// Ajusta case abaixo
   ENDIF   // Pois caindo na segunda n„o somava uma semana
   DO CASE
   CASE cDATA = "A"
      dDATA--// Subtrai 1 dia para ajustar soma de datas
   CASE cDATA = "L"  // Emiss„o nao subtrair um nada pois precisa mais 1
   CASE cDATA = "D"  // Fora Dezena
      WHILE Day( dDATA ) # 11 .AND. Day( dDATA ) # 21 .AND. Day( dDATA ) # 1
         dDATA++
      ENDDO
      dDATA--// Subtrai 1 dia para ajustar soma de datas
   CASE cDATA = "Q"  // Fora Quinzena
      WHILE Day( dDATA ) # 16 .AND. Day( dDATA ) # 1
         dDATA++
      ENDDO
      dDATA--// Subtrai 1 dia para ajustar soma de datas
   CASE cDATA = "M"  // Fora Mˆs
      WHILE Day( dDATA ) # 1
         dDATA++
      ENDDO
      dDATA--// Subtrai 1 dia para ajustar soma de datas
   CASE cDATA = "U"  // Dias Uteis
      WHILE DoW( dDATA ) = 7 .OR. DoW( dDATA ) = 1
         dDATA++
      ENDDO
      dDATA--// Subtrai 1 dia para ajustar soma de datas
   CASE cDATA = "S"  // Fora Semana
      WHILE DoW( dDATA ) # 2
         dDATA++
      ENDDO
      dDATA--// Subtrai 1 dia para ajustar soma de datas
   ENDCASE

   FOR X := 1 TO 10
      IF !Empty( aDIA[ X ] )
         nDATAS++
      ENDIF
   NEXT X
   IF Empty( aPOR[ 1 ] )
      mPER := 100 / nDATAS
      FOR X := 1 TO 10
         IF !Empty( aDIA[ X ] )
            aPOR[ X ] := mPER
         ENDIF
      NEXT X
   ENDIF
   FOR X := 1 TO 10
      IF !Empty( aDIA[ X ] ) .AND. !Empty( aPOR[ X ] )
         aRETU[ 1, X ] := dDATA + aDIA[ X ]
         aRETU[ 2, X ] := Round( nVALOR * aPOR[ X ] / 100, 2 )
      ENDIF
   NEXT X
// Corrige Nao Preenchimento 1§Data
   IF Empty( aRETU[ 1, 1 ] )
      aRETU[ 1, 1 ] := dDATA
   ENDIF
// Corrige Nao Preenchimento 1§%
   IF Empty( aRETU[ 2, 1 ] )
      aRETU[ 2, 1 ] := nVALOR
   ENDIF
// Exclui Final de Semana
   FOR X := 1 TO 10
      IF DoW( aRETU[ 1, X ] ) # 0
         DO CASE
         CASE cSEMANA = 9  // Segunda/Terca/Quarta 2/3/4
            WHILE DoW( aRETU[ 1, X ] ) < 2 .OR. DoW( aRETU[ 1, X ] ) > 4
               aRETU[ 1, X ]++
            ENDDO
         CASE cSEMANA = 8  // Dias Uteils
            IF DoW( aRETU[ 1, X ] ) = 7
               aRETU[ 1, X ] += 2
            ENDIF
            IF DoW( aRETU[ 1, X ] ) = 1
               aRETU[ 1, X ]++
            ENDIF
         CASE cSEMANA = 7  // Sabado
            WHILE DoW( aRETU[ 1, X ] ) # 7
               aRETU[ 1, X ]++
            ENDDO
         CASE cSEMANA = 6  // Sexta
            WHILE DoW( aRETU[ 1, X ] ) # 6
               aRETU[ 1, X ]++
            ENDDO
         CASE cSEMANA = 5  // Quinta
            WHILE DoW( aRETU[ 1, X ] ) # 5
               aRETU[ 1, X ]++
            ENDDO
         CASE cSEMANA = 4  // Quarta
            WHILE DoW( aRETU[ 1, X ] ) # 4
               aRETU[ 1, X ]++
            ENDDO
         CASE cSEMANA = 3  // Terca
            WHILE DoW( aRETU[ 1, X ] ) # 3
               aRETU[ 1, X ]++
            ENDDO
         CASE cSEMANA = 2  // Segunda
            WHILE DoW( aRETU[ 1, X ] ) # 2
               aRETU[ 1, X ]++
            ENDDO
         CASE cSEMANA = 1  // Domingo
            WHILE DoW( aRETU[ 1, X ] ) # 1
               aRETU[ 1, X ]++
            ENDDO
         ENDCASE
      ENDIF
   NEXT X
   IF Len( aCAI ) > 0
      FOR X := 1 TO 10
         IF DoW( aRETU[ 1, X ] ) # 0
            WHILE .T.
               lCAI := .F.
               FOR Y := 1 TO Len( aCAI )
                  IF aCAI[ Y ] = 99  // Ultimo Dia do Mes
                     IF Day( aRETU[ 1, X ] ) = 1  // 1§ Dia Mes Seguinte
                        aRETU[ 1, X ]--// Tira um Para ultimo mes anterior
                        lCAI := .T.
                     ENDIF
                  ELSE
                     IF Day( aRETU[ 1, X ] ) = aCAI[ Y ]
                        lCAI := .T.
                     ENDIF
                  ENDIF
               NEXT Y
               IF lCAI
                  EXIT
               ELSE
                  aRETU[ 1, X ]++
               ENDIF
            ENDDO
         ENDIF
      NEXT X
   ENDIF
   IF lGRAVA
      mDAT01 := aRETU[ 1, 1 ]
      mDAT02 := aRETU[ 1, 2 ]
      mDAT03 := aRETU[ 1, 3 ]
      mDAT04 := aRETU[ 1, 4 ]
      mDAT05 := aRETU[ 1, 5 ]
      mDAT06 := aRETU[ 1, 6 ]
      mDAT07 := aRETU[ 1, 7 ]
      mDAT08 := aRETU[ 1, 8 ]
      mDAT09 := aRETU[ 1, 9 ]
      mDAT10 := aRETU[ 1, 10 ]

      mVAL01 := aRETU[ 2, 1 ]
      mVAL02 := aRETU[ 2, 2 ]
      mVAL03 := aRETU[ 2, 3 ]
      mVAL04 := aRETU[ 2, 4 ]
      mVAL05 := aRETU[ 2, 5 ]
      mVAL06 := aRETU[ 2, 6 ]
      mVAL07 := aRETU[ 2, 7 ]
      mVAL08 := aRETU[ 2, 8 ]
      mVAL09 := aRETU[ 2, 9 ]
      mVAL10 := aRETU[ 2, 10 ]

      mTPC01 := aRETU[ 3, 1 ]
      mTPC02 := aRETU[ 3, 2 ]
      mTPC03 := aRETU[ 3, 3 ]
      mTPC04 := aRETU[ 3, 4 ]
      mTPC05 := aRETU[ 3, 5 ]
      mTPC06 := aRETU[ 3, 6 ]
      mTPC07 := aRETU[ 3, 7 ]
      mTPC08 := aRETU[ 3, 8 ]
      mTPC09 := aRETU[ 3, 9 ]
      mTPC10 := aRETU[ 3, 10 ]

   ENDIF
   RETU aRETU


// + EOF: mlib08.prg
// +
