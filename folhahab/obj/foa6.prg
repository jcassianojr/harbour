// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foa6.prg
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

#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foa6()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foa6

   PARA nARQ

   CABEX( " Lancamento Insalubridade " )
   aCTA    := PEGRELCTA( "INS01" )
   aEXT    := PEGRELCTA( "INS02" )
   nVALINS := 0
   hb_DispBox( 7, 0, 23, 79, B_DOUBLE + " " )
   @  9, 2  SAY "Credito Hrs  :" // 1
   @ 10, 2  SAY "Credito Dias :" // 2
   @ 11, 2  SAY "Insalubridade:" // 3
   @ 12, 2  SAY "Insal.Extras :" // 4
   @ 13, 2  SAY "Insal.Valor  :"
   @ 14, 2  SAY "Desconto Hrs :" // 5 //6 //7
   @ 15, 2  SAY "Contas Extras:"
   @  9, 15 GET aCTA[ 1 ]                      PICT "999"
   @ 10, 15 GET aCTA[ 2 ]                      PICT "999"
   @ 11, 15 GET aCTA[ 3 ]                      PICT "999"
   @ 12, 15 GET aCTA[ 4 ]                      PICT "999"
   @ 13, 15 GET nVALINS                      PICT "9999.99"
   @ 14, 15 GET aCTA[ 5 ]                      PICT "999"
   @ 14, 19 GET aCTA[ 6 ]                      PICT "999"
   @ 14, 23 GET aCTA[ 7 ]                      PICT "999"
   @ 15, 15 GET aEXT[ 1 ]                      PICT "999"
   @ 15, 19 GET aEXT[ 2 ]                      PICT "999"
   @ 15, 23 GET aEXT[ 3 ]                      PICT "999"
   @ 15, 27 GET aEXT[ 4 ]                      PICT "999"
   @ 15, 31 GET aEXT[ 5 ]                      PICT "999"
   @ 15, 35 GET aEXT[ 6 ]                      PICT "999"
   @ 15, 39 GET aEXT[ 7 ]                      PICT "999"
   @ 15, 43 GET aEXT[ 8 ]                      PICT "999"
   @ 15, 47 GET aEXT[ 9 ]                      PICT "999"
   @ 15, 51 GET aEXT[ 10 ]                     PICT "999"
   @ 15, 55 GET aEXT[ 11 ]                     PICT "999"
   @ 15, 59 GET aEXT[ 12 ]                     PICT "999"
   @ 15, 63 GET aEXT[ 13 ]                     PICT "999"
   @ 15, 67 GET aEXT[ 14 ]                     PICT "999"
   @ 15, 71 GET aEXT[ 15 ]                     PICT "999"
   IF !READCUR()
      RETU .F.
   ENDIF




   IF !ARQPES( nARQ )
      dbCloseAll()
      RETU .F.
   ENDIF
   FILTRO := 'EMPTY(DEMITIDO).AND.INSALUBRI="S"'
   FI     := Trim( FILTRO )
   FILTRO := FILTRO( FI )
   SET FILTER TO &FILTRO
   cSELE1 := Alias()

   IF !ARQUSAR( nARQ, 1 )
      dbCloseAll()
      RETU .F.
   ENDIF
   cSELE2 := Alias()

   IF !ARQCTA( nARQ )
      dbCloseAll()
      RETU .F.
   ENDIF
   cSELE3 := Alias()

   dbSelectAr( cSELE1 )
   WHILE !Eof()
      PETELA( 8 )
      mNUMERO  := NUMERO
      lMENSAL  := IF( TIPO = "1" .OR. TIPO = 'M', .T., .F. )
      nCREDITO := FOA601( mNUMERO, IF( lMENSAL, aCTA[ 2 ], aCTA[ 1 ] ), 1 )
      nDEBITO  := FOA601( mNUMERO, aCTA[ 5 ], 1 ) + FOA601( mNUMERO, aCTA[ 6 ], 1 ) + FOA601( mNUMERO, aCTA[ 7 ], 1 )
      IF nDEBITO > 0 .AND. lMENSAL
         nDEBITO := Round( nDEBITO / 7.33, 2 )
      ENDIF
      nHORAS := nCREDITO - nDEBITO
      IF nHORAS > 0
         nVALOR := IF( lMENSAL, nHORAS * nVALINS / 30, nHORAS * nVALINS / 220 )
         FOA602( mNUMERO, aCTA[ 3 ], nVALOR, nHORAS )
      ENDIF
      nEXTRA := 0
      FOR X := 1 TO 15
         nEXTRA += FOA601( mNUMERO, aEXT[ X ], 2 )
      NEXT X
      IF nEXTRA > 0
         FOA602( mNUMERO, aCTA[ 4 ], nEXTRA, 0 )
      ENDIF
      dbSelectAr( cSELE1 )
      dbSkip()
   ENDDO
   dbCloseAll()
   RETU




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOA601()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOA601( nNUMERO, nCONTA, nTIPO )

   LOCAL nRETU := 0

   IF nCONTA = 0
      RETU nRETU
   ENDIF
   dbSelectAr( cSELE2 )
   dbGoTop()
   IF dbSeek( nNUMERO * 10000 + nCONTA )
      nRETU := VALOR
      IF nTIPO = 1
         nRETU := HORAS
      ENDIF
      IF nTIPO = 2
         nRETU := HORAS * FATOR * ( nVALINS / 220 )
      ENDIF
   ENDIF
   RETU nRETU


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOA602()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOA602( nNUMERO, nCONTA, nVALOR, nHORAS )

   dbSelectAr( cSELE3 )
   dbGoTop()
   IF dbSeek( nCONTA )
      XA := FATOR
      XB := TIPO
      XC := TRIBUTINPS
      XD := TRIBUTIRR
      XE := TRIB_FGTS
      XF := VALOR
   ELSE
      XA := 1
      XB := 0
      XC := 1
      XD := 1
      XE := 1
      XF := 0
   ENDIF
   dbSelectAr( cSELE2 )
   dbGoTop()
   IF !dbSeek( nNUMERO * 10000 + nCONTA )
      NETRECAPP()
      FIELD->NUMERO   := nNUMERO
      FIELD->CONTA    := nCONTA
      FIELD->CONTROLE := nNUMERO * 10000 + nCONTA
   ELSE
      NETRECLOCK()
   ENDIF
   FIELD->VALOR      := nVALOR
   FIELD->HORAS      := nHORAS
   FIELD->FATOR      := XA
   FIELD->TIPO       := XB
   FIELD->TRIBUTINPS := XC
   FIELD->TRIBUTIRR  := XD
   FIELD->TRIB_FGTS  := XE
   FIELD->VALORBASE  := XF
   dbUnlock()

// + EOF: foa6.prg
// +
