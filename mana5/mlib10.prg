// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib10.prg
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



#include "INKEY.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function VERUF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION VERUF( eCEP, eUF, eCID )

   LOCAL X
   LOCAL lCONT := .T.
   LOCAL cCEP

   IF &eUF. = "XX" .OR. &eUF. = "EX" .OR. &eUF. = "??"   // Nao Checa Exterior
      ZRUA    := ""
      ZDDD    := ""
      ZCEP    := ""
      ZCEPFIM := ""
      ZKM     := 0
      ZRUA    := ""
      RETU .T.
   ENDIF
   IF Empty( Left( &eCEP., 5 ) )
      PRIV GETLIST := {}
      MDS( "Digite o Cep" )
      @ 24, 40 GET &eCEP PICTURE "99999-999"
      READ
   ENDIF
   IF !Empty( &eCEP. ) .AND. ( Empty( &eUF ) .OR. Empty( &eCID ) )
      IF USEREDE( "MD10", 1, 2 )
         lCONT := .T.
         X     := 5
         WHILE lCONT
            cCEP := Left( &eCEP., X )
            dbGoTop()
            IF dbSeek( cCEP )
               IF cCEP >= Left( INICEP, X ) .AND. cCEP <= Left( FIMCEP, X )
                  &eUF  := UF
                  &eCID := NOME
                  lCONT := .F.
               ENDIF
            ELSE
               dbSkip( - 1 )
               IF cCEP >= Left( INICEP, X ) .AND. cCEP <= Left( FIMCEP, X )
                  &eUF  := UF
                  &eCID := NOME
                  lCONT := .F.
               ENDIF
            ENDIF
            X--
            IF x = 0
               lCONT := .F.
            ENDIF
         ENDDO
         dbCloseArea()
      ENDIF
   ENDIF
   RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function VERDDD()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION VERDDD( cVAR )

   IF Empty( ZDDD )
      RETU .T.
   ENDIF
   &cVAR. := ZDDD

   RETURN .F.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function VERCEP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION VERCEP( cVAR )

   LOCAL cCEP

   cCEP := &cVAR.
   IF !Empty( ZCEP ) .AND. Empty( ZCEPFIM )
      cCEP := ZCEP + Right( cCEP, 3 )
   ENDIF
   cCEP  := StrTran( cCEP, " ", "0" )
   cCEP  := StrTran( cCEP, "-", "" )
   cCEP  := StrZero( Val( cCEP ), 8 )
   cCEP  := Left( cCEP, 5 ) + "-" + Right( cCEP, 3 )
   &cVAR := cCEP
   IF !Empty( ZCEP ) .AND. Empty( ZCEPFIM )
      KEYBOARD repl( Chr( K_RIGHT ), 5 )
   ENDIF

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function VERKM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION VERKM( cVAR )

   IF Empty( ZKM )
      RETU .T.
   ENDIF
   &cVAR. := ZKM

   RETURN .F.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CHECK5CEP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION CHECK5CEP( cCEP, eRUA, eBAI, eTIP, lMES )

   LOCAL cCEP8  := TIRAOUT( cCEP )   // left(cCEP,5)+right(cCEP,3) 12345-123 OU 1234578
   LOCAL nCHVBA

   IF ValType( lMES ) <> "L"
      lMES := .T.
   ENDIF

   IF Empty( ZRUA ) .AND. lMES   // nao tem ceps por rua
      VERSEHA( "MD11", Left( cCEP, 5 ),, "'Verifique 5 digitos cep'", .T. )
   ELSE
      IF VERSEHA( ZRUA, cCEP8, "ALLTRIM(TIPO)+' '+ALLTRIM(RUA)", "'Cep da Rua nao Cadastrado '+ZRUA", lMES, 2 )   // ,.T.,2)
         IF ValType( eRUA ) = "C" .AND. !Empty( eRUA )
            IF Empty( &eRUA )
               IF ValType( eTIP ) = "C" .AND. !Empty( eTIP ) .AND. Empty( &eTIP )
                  &eRUA := PadR( OBTER( ZRUA, cCEP8, "ALLTRIM(RUA)", 2 ), 40 )
                  &eTIP := PadR( OBTER( ZRUA, cCEP8, "ALLTRIM(TIPO)", 2 ), 40 )
               ELSE
                  &eRUA := PadR( OBTER( ZRUA, cCEP8, "ALLTRIM(TIPO)+' '+ALLTRIM(RUA)", 2 ), 40 )
               ENDIF
            ENDIF
         ENDIF
         IF ValType( eTIP ) = "C" .AND. !Empty( eTIP )
            IF Empty( &eTIP )
               &eTIP := PadR( OBTER( ZRUA, cCEP8, "ALLTRIM(TIPO)", 2 ), 40 )
            ENDIF
         ENDIF
         IF ValType( eBAI ) = "C" .AND. !Empty( eBAI )
            IF Empty( &eBAI )
               nCHVBA := OBTER( ZRUA, cCEP8, "CHVBAI", 2 )
               &eBAI  := PadR( OBTER( "CEPBAI", nCHVBA, "BAI_NO" ), 30 )
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   IF !Empty( ZCEPFIM ) .AND. lMES
      cCEP := Left( cCEP, 5 )
      IF cCEP < Left( ZCEP, 5 ) .OR. cCEP > Left( ZCEPFIM, 5 )
         ALERTX( "Fora da Faixa Ceps da Cidade de " + ZCEP + " a " + ZCEPFIM )
      ENDIF
   ENDIF

   RETURN .T.


// + EOF: mlib10.prg
// +
