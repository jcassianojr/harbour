// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fod.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :       FOGD.PRG: Menu Para Calcular e Apurar
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  SOFTEC  S/C Ltda.
// :  Atualizado em: 17/07/98
// :
// :*****************************************************************************




PRIV HELPDBF
HELPDBF := "FOD"

Set( _SET_MESSAGE, 23, .T. )
WHILE .T.
op := 4
CABEX( 'Menu Principal de Calculos' )
MD()
@ 07, 00 TO 21, 39 DOUB
@ 07, 40 TO 21, 79 DOUB
@ 09, 03 SAY "C lculos:"
@ 09, 43 SAY "Refazer Incidencias:"
@ 11, 03 PROM "1 - Iniciar o Mˆs.        " MESS "Faz os movimentos para come‡ar um mˆs"
@ 13, 03 PROM "2 - Premio Tributado.     " MESS "Faz o calculo do Premio Tributado"
@ 14, 03 PROM "3 - Adiantamento Salarial." MESS "Faz o calculo do Adiantamento Salarial"
@ 16, 03 PROM "4 - Folha de Pagamento.   " MESS "Faz o calculo da Folha de Pagamento"
@ 17, 03 PROM "5 - Folha Semanal         " MESS "Faz o calculo da Folha Semanal"
@ 18, 03 PROM "6 - Folha Complementar.   " MESS "Faz o calculo da Folha de Pagamento"
@ 19, 03 PROM "7 - Folha RPA             " MESS "Faz o calculo da Folha Semanal"
@ 11, 43 PROM "A - Folha de Pagamento.   " MESS "Refaz incidencias tribut rias Folha"
@ 13, 43 PROM "B - Folha de F‚rias.      " MESS "Refaz incidencias tribut rias F‚rias"
@ 15, 43 PROM "C - Folha de Rescis„o.    " MESS "Refaz incidencias tribut rias Rescis„o"
@ 17, 43 PROM "D - Folha de 13o.S lario  " MESS "Refaz incidencias tribut rias 13o.Salario"
@ 19, 43 PROM "E - Folha Complementar    " MESS "Refaz incidencias tribut rias Complementar"
MENU TO OP
DO CASE
CASE OP = 1
FOD7()
CASE OP = 2
FOD9()
CASE OP = 3
FOD1()
CASE OP = 4
FOD2( 1 )
CASE OP = 5
FOD5( 1 )
CASE OP = 6
FOD2( 2 )
CASE OP = 7
FOD5( 2 )
CASE OP = 8
FODINS( 1 )
CASE OP = 9
FODINS( 2 )
CASE OP = 10
FODINS( 3 )
CASE OP = 11
FODINS( 4 )
CASE OP = 12
FODINS( 5 )
OTHERWISE
RETU
ENDCASE
ENDDO

// !*****************************************************************************
// !
// !       TABIRRF
// !
// !    Chamado por: FOD9.PRG
// !               : FOD2.PRG
// !               : FOD1B.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TABIRRF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION TABIRRF

   IF !netuse( "TABIRRF" )   // BREDE("TABIRRF",1)
      RETU .F.
   ENDIF
   dbGoto( MESTRAB )
   QTDEIRRF    := QTDEDEP
   VDEPENDE    := VALDEPENDE
   DESC_MINIMO := MINIMO
   IRRF1       := ATESAL1
   IRTX1       := TAXA1
   IRPA1       := PARCELA1
   IRRF2       := ATESAL2
   IRTX2       := TAXA2
   IRPA2       := PARCELA2
   IRRF3       := ATESAL3
   IRTX3       := TAXA3
   IRPA3       := PARCELA3
   IRRF4       := ATESAL4
   IRTX4       := TAXA4
   IRPA4       := PARCELA4
   IRRF5       := ATESAL5
   IRTX5       := TAXA5
   IRPA5       := PARCELA5
   IRRF6       := ATESAL6
   IRTX6       := TAXA6
   IRPA6       := PARCELA6
   IRRF7       := ATESAL7
   IRTX7       := TAXA7
   IRPA7       := PARCELA7
   ARREIRRF    := ARREDONDA
   DESPIRRF    := DESPRESA
   mFATORIRRF  := FATORIRRF
   mFATORIRR2  := FATORIRR2
   dbCloseArea()
   RETU .T.

/*
Calculo do Valor dos Dependentes
*/
// !*****************************************************************************
// !
// !         Fun‡„o: CALCDEPE()
// !
// !    Chamado por: FOD9.PRG
// !               : FOD1B.PRG
// !               : FOD2BAS.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CALCDEPE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CALCDEPE

   VAL4 := IF( DEP > QTDEIRRF, QTDEIRRF * VDEPENDE, DEP * VDEPENDE )
   IF mFATORIRRF # 0
      VAL4 := Round( VAL4 / mFATORIRRF, 2 )
   ENDIF
   RETU VAL4


/*
Calculo do Valor do Desconto do Irrf
*/
// !*****************************************************************************
// !
// !         Fun‡„o: CALCIRRF()
// !
// !    Chamado por: FOD9.PRG
// !               : FOD1B.PRG
// !               : FOD2DES.PRG
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CALCIRRF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CALCIRRF

   nBASEIRRF := IF( mFATORIRRF # 0, Round( BASE * mFATORIRRF, 2 ), BASE )
   DO CASE
   CASE nBASEIRRF <= IRRF1
      IR3    := IRTX1
      DESCIR := IRPA1
   CASE nBASEIRRF <= IRRF2
      IR3    := IRTX2
      DESCIR := IRPA2
   CASE nBASEIRRF <= IRRF3
      IR3    := IRTX3
      DESCIR := IRPA3
   CASE nBASEIRRF <= IRRF4
      IR3    := IRTX4
      DESCIR := IRPA4
   CASE nBASEIRRF <= IRRF5
      IR3    := IRTX5
      DESCIR := IRPA5
   CASE nBASEIRRF <= IRRF6
      IR3    := IRTX6
      DESCIR := IRPA6
   CASE nBASEIRRF <= IRRF7
      IR3    := IRTX7
      DESCIR := IRPA7
   ENDCASE
   IF IR3 <> 0
      IR3A      := ( IR3 / 100 )
      IR2       := ( nBASEIRRF * IR3A )
      VALDESCIR := ( IR2 - DESCIR )
      // * VALOR MINIMO DE DESCONTO = MIN_DESCON = DIV5
      IF VALDESCIR <= DESC_MINIMO
         VALDESCIR := IR3 := 0.00
      ENDIF
   ELSE
      VALDESCIR := IR3 := 0.00
   ENDIF
   IF ARREIRRF = 'S' .AND. VALDESCIR > 0
      VALDESCIR := ( Int( ( VALDESCIR + .5 ) * 100 ) / 100 )
   ENDIF
   IF DESPIRRF = 'S'
      VALDESCIR := Int( VALDESCIR )
   ENDIF
   VALDESCIR := IF( mFATORIRR2 # 0, Round( VALDESCIR / mFATORIRR2, 2 ), VALDESCIR )
   RETU

// !*****************************************************************************
// !
// !         Fun‡„o: VALARRE()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function VALARRE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC VALARRE

   PARA XARRE

   MDS( 'Arredondando' )
   IF VEN > DES
      SALDO  := VEN - DES
      SALDO1 := Int( SALDO / XARRE )
      SALDO2 := SALDO1 * XARRE
      SALDO3 := SALDO2 + XARRE
      SALDO4 := Round( SALDO3 - SALDO + 0.001, 2 )
   ELSE
      RETU ( DES - VEN )
   ENDIF
   RETU ( IF( SALDO4 = XARRE, 0, SALDO4 ) )

// !***************************************************************************
// !
// !         Fun‡„o: TRUNCAR()
// !
// !***************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TRUNCAR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC TRUNCAR( Arg1 )

   LOCAL Local1 := 0, Local2 := 0, vdpos

   vdpos := At( ".", Str( Arg1 * 100 ) ) - 1
   IF ( vdpos > 0 )
      Local2 := Val( SubStr( Str( Arg1 * 100 ), 1, vdpos ) )
      Local1 := Local2 / 100
   ELSE
      Local1 := Arg1
   ENDIF

   RETURN Local1



// : FIM: FOD.PRG

// + EOF: fod.prg
// +
