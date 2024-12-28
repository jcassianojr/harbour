// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : folis_b4.prg
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
// +    Documentado em 27-Dez-2024 as  9:26 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :   FOLIS_B4.PRG: Transfere Dados
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function folis_b4()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION folis_b4

   PARA CC

   CABE2( 'Tranferencia de dados' )
   IF !MDG( 'Vocˆ quer realmente transferir' )
      RETU
   ENDIF
   ANOUSO := .T.
   IF CC = 3
      ANOUSO := MDG( "Transferir para o ano atual" )
   ENDIF
   XA := XB := XC := XD := XE := XF := 1

   IF File( ZDIRE + "FO_FP13A.DBF" )
      c13 := PEG13( CC )
      IF !netuse( c13 )
         dbCloseAll()
         RETU
      ENDIF
   ELSE
      IF !netuse( f13 )  // antigo calculo
         dbCloseAll()
         RETU .F.
      ENDIF
   ENDIF
   cSELE1 := Alias()
   FILTRO := ''
   FI     := Trim( FILTRO )
   FILTRO := FILTRO( FI )
   SET FILTER TO &FILTRO


   IF CC # 3 .OR. ANOUSO
      IF !NETUSE( FOL )
         RETU
      ENDIF
   ELSE
      PATHN := hb_cwd() + 'EMP' + StrZero( NREMP, 5 ) + "\"
      IF !NETUSE( PATHN + FOL )
         RETU
      ENDIF
   ENDIF
   cSELE2 := Alias()

   IF !netuse( "contas" )
      RETU
   ENDIF
   dbSelectAr( cSELE1 )
   dbGoTop()
   MDS( 'Transferindo dados Aguarde...' )
   WHILE !Eof()
      CTR      := NUMERO
      CTRC     := CONTA
      CTRH     := HORAS
      VALE     := VALOR
      TRANSFER := .F.
      CTRC     := IF( CTRC = 398, 912, CTRC )
      CTRC     := IF( CTRC = 426, 438, CTRC )
      dbSelectAr( "contas" )
      dbGoTop()
      IF dbSeek( CTRC )
         IF CC = 1 .AND. TR13S1 = 0
            TRANSFER := .T.
         ENDIF
         IF CC = 2 .AND. TR13S2 = 0
            TRANSFER := .T.
         ENDIF
         IF CC = 3 .AND. TR13SC = 0
            TRANSFER := .T.
         ENDIF
      ENDIF
      IF TRANSFER
         dbSelectAr( cSELE2 )
         GRAVA2( CTRC, VALE )
         FIELD->HORAS := CTRH
      ENDIF
      dbSelectAr( cSELE1 )
      dbSkip()
   ENDDO
   dbCloseAll()
   RETU .T.
// : FIM: FOLIS_B4.PRG

// + EOF: folis_b4.prg
// +
