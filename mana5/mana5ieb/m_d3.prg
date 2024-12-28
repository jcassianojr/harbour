// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_d3.prg
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
// +    Documentado em 28-Dez-2024 as 10:47 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

MDI( "Lan‡ar Composicao Produtos pela Sequencia" )


// Filtro da Listagem
FILTRO := ''
FILTRO := RFILORD( "MS06", .F., FILTRO )

IF !USEMULT( { { "MS06", 1, 1 }, { "MS03", 1, 99 } } )
RETU .F.
ENDIF


dbSelectAr( "MS06" )
IF !Empty( FILTRO )
SET FILTER TO &FILTRO
ENDIF
dbGoTop()
WHILE !Eof()
@ 24, 00 SAY CODIGO
yCODIGO := CODIGO
aCOMP   := {}
aQTDE   := {}
WHILE yCODIGO = CODIGO .AND. !Eof()
nPECAS := IF( PCHORA > 0, 1 / PCHORA, 0 )
IF FATOR # 0
nPECAS := nPECAS * FATOR
ENDIF
MD301( "H", CODMP02 )
MD301( "H", CODMP02B )
MD301( "H", CODMP02C )
MD301( "H", CODMP02D )
MD301( "E", CODMP01 )
MD301( "T", CODMP03 )
dbSkip()
ENDDO
dbSelectAr( "MS03" )
FOR W := 1 TO Len( aCOMP )
dbGoTop()
dbSeek( yCODIGO + aCOMP[ W ] )
IF !Found()
netrecapp()
FIELD->CODIGO  := yCODIGO
FIELD->TIPOENT := Left( aCOMP[ W ], 1 )
FIELD->CODCOMP := SubStr( aCOMP[ W ], 2 )
FIELD->QTDDE   := aQTDE[ W ]
FIELD->TOTAL   := Round( QTDDE * PRECO, 2 )
IF Left( aCOMP[ W ], 1 ) $ "EHT"
FIELD->NOMECOMP := OBTER( ESTQARQ( Left( aCOMP[ W ], 1 ), 1 ), SubStr( aCOMP[ W ], 2 ), "NOME" )
ENDIF
ELSE
NETGRVCAM( "QTDDE", aQTDE[ W ] )
ENDIF
NEXT W
dbSelectAr( "MS06" )
ENDDO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MD301()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC MD301( cTIP, cCOD )

   IF !Empty( cCOD )
      nPOS := AScan( aCOMP, cTIP + cCOD )
      IF nPOS > 0
         aQTDE[ nPOS ] += nPECAS
      ELSE
         AAdd( aCOMP, cTIP + cCOD )
         AAdd( aQTDE, nPECAS )
      ENDIF
   ENDIF
   RETU .T.

// + EOF: m_d3.prg
// +
