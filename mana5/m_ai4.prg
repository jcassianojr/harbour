// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ai4.prg
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
// +    Documentado em 28-Dez-2024 as  9:56 am
// +
// +
// +
// +--------------------------------------------------------------------
// +




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_ai4()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_ai4

   PARA nREG

   DO CASE
   CASE nREG = 1
      aRETU := PEGMES( { "K3" }, .T., { "MK03" } )
   CASE nREG = 2
      aRETU := PEGMES( { "K4" }, .T., { "MK04" } )
   CASE nREG = 3
      aRETU := PEGMES( { "K5" }, .T., { "MK05" } )
   OTHERWISE
      RETU
   ENDCASE

   nMES  := aRETU[ 1 ]
   nANO  := aRETU[ 2 ]
   cARQ1 := aRETU[ 5, 1 ]


   DO CASE
   CASE nREG = 1
      xMES := "SAL" + StrZero( nMES, 2 )
   CASE nREG = 2
      xMES := "SAS" + StrZero( nMES, 2 )
   CASE nREG = 3
      xMES := "SAO" + StrZero( nMES, 2 )
   ENDCASE

   IF !USEMULT( { { cARQ1, 1, 2 }, { "MI01", 1, 1 } } )
      RETU .F.
   ENDIF
   dbSelectAr( cARQ1 )
   dbGoTop()
   dbSeek( Str( nANO, 4 ) + Str( nMES, 2 ) )
   WHILE nMES = MES .AND. nANO = ANO .AND. !Eof()
      xCONTA  := CONTA
      mTOTCTA := 0
      WHILE xCONTA = CONTA .AND. !Eof()
         mTOTCTA += VALORMES
         dbSkip()
      ENDDO
      dbSelectAr( "MI01" )
      dbGoTop()
      IF dbSeek( xCONTA )
         netgrvcam( xMES, mTOTCTA )
      ENDIF
      dbSelectAr( cARQ1 )
   ENDDO

   dbSelectAr( "MI01" )
   dbGoTop()
   WHILE !Eof()
      IF IDENTIFICA = 'S'
         xCONTA := AllTrim( CONTA )
         xVALOR := 0
         xREC   := RecNo()
         WHILE AllTrim( CONTA ) = xCONTA .AND. !Eof()
            IF xCONTA != CONTA
               xVALOR += &xMES
            ENDIF
            dbSkip()
         ENDDO
         dbGoto( xREC )
         netgrvcam( xMES, xVALOR )
      ENDIF
      dbSkip()
   ENDDO
   RETU

// + EOF: m_ai4.prg
// +
