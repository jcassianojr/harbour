// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_28.prg  Pre Lan‡amento Valor
// +
// +
// +
// +     Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
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
// +    Documentado em 27-Dez-2024 as  9:32 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

FUNCTION fopto_28()

   CABE2( 'FOPTO_28 - Pre Lan‡amento Valor' )
   dINI   := zdataini
   dFIM   := zdatafim
   nCTA   := 0
   nVALOR := 0
   MDS( 'Digite o Periodo ' )
   @ 24, 40 GET dINI
   @ 24, 50 GET dFIM
   IF !READCUR()
      RETU .F.
   ENDIF
   MDS( 'Digite a Conta e o Valor' )
   @ 24, 40 GET nCTA   PICT "99"
   @ 24, 50 GET nVALOR PICT "999.99"
   IF !READCUR()
      RETU .F.
   ENDIF
   IF nCTA < 1 .OR. nCTA > 17
      RETU .F.
   ENDIF
   IF nVALOR = 0
      IF !MDG( "Marcar com valor 0" )
         RETU .F.
      ENDIF
   ENDIF
   cCTA := "CTA" + StrZero( nCTA, 2 )
   cPN  := "PN" + ANOMESW

   IF !NETUSE( PES )
      RETU
   ENDIF
   FILTRO := FILTRO( "EMPTY(DEMITIDO)" )
   SET FILTER TO &FILTRO

   IF !netuse( cPN )
      dbCloseAll()
      RETU
   ENDIF
   dbSelectAr( pes )
   dbGoTop()
   WHILE !Eof()
      PETELA( 8 )
      NUM := NUMERO
      dbSelectAr( cPN )
      BUSCA := Str( NUM, 8 ) + DToS( dINI )
      dbGoTop()
      IF dbSeek( BUSCA )
         WHILE DATA >= dINI .AND. DATA <= dFIM .AND. !Eof()
            netreclock()
            field->&cCTA. := nVALOR
            dbUnlock()
            dbSkip()
         ENDDO
      ENDIF
      dbSelectAr( pes )
      dbSkip()
   ENDDO
   dbCloseAll()

   RETURN .F.


// + EOF: fopto_28.prg
// +
