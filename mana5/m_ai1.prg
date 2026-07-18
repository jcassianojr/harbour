// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_ai1.prg
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


// :*****************************************************************************
// :
// :   M_AI   .PRG : Plano de Contas
// :   Linguagem   : harbour
// :        Sistema: MANA5
// :      Copyright (c) 1999, jcassiano Sistemas
// :
// :*****************************************************************************


// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"

aMAIGET := EDITPEG( "MAIB01" )


PADRAO( 0, 1, 0, "MI01", "C¢digo" + spac( ZTAMCC - 6 ) + "Discrimina‡„o da Conta" + spac( 9 ) + "T N I Reduzido", ;
      "' '+TRANS(mCONTA,ZPICCC)+' '+LEFT(mNOME,30)+' '+mTIPO+' '+STR(mNIVEL,1)+' '+mIDENTIFICA+' '+STR(mNUMERO,  6)", ;
      "MAI",, {|| gMAI1() }, {|| iMAI1() } )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function iMAI1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC iMAI1()

   mNIVEL := NIVELAR( mCONTA )
   IF mNIVEL > 1
      nPOS := 0
      FOR X := 1 TO mNIVEL - 1
         nPOS += ZNIV[ X ]
      NEXT X
      IF !VERSEHA( "MI01", Left( mCONTA, nPOS ) )
         ALERTX( "Cadastre o N¡vel Superior Primeiro" )
         RETU .F.
      ENDIF
   ENDIF
   RETU .T.

// Get Nas Mvars


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMAI1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gMAI1

   xCONTA := mCONTA
   SetColor( PAD002 )
   @  4, 2 GET mCONTA PICT ZPICCC VALID MAI101()
   READCUR()
   mNIVEL  := NIVELAR( mCONTA )
   mNIVEL  := NIVELAR( mCONTA )
   mDAC    := NUMDAC( mCONTA, INCLUI, mNIVEL )
   mNUMERO := NUMRED( mCONTA, mNUMERO )
   @  4, 29 GET mNOME      PICT "@S30"
   @  7, 02 GET mTIPO      PICT "!"    VALID mTIPO $ "CD"
   @  7, 15 SAY mNIVEL     PICT "9"
   @  7, 21 GET mIDENTIFIC PICT "!"    VALID mIDENTIFIC $ 'AS'
   IF ZREDUZ = '3'
      @ 08, 36 GET mNUMERO PICT '999999'
   ELSE
      @ 08, 36      SAY mNUMERO PICT '999999'
      @ 08, Col() + 1 SAY '-'
      @ 08, Col() + 1 SAY mDAC    PICT '9'
   ENDIF
   READCUR()
   EDITSAY( aMAIGET )




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAI101()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MAI101

   IF xCONTA # mCONTA
      IF VERSEHA( "MI01", mCONTA )
         ALERTX( "Conta Duplicada" )
         RETU .F.
      ENDIF
      xCONTA := mCONTA
   ENDIF
   IF Empty( mCONTA )
      ALERTX( "C¢digo n„o Pode estar em Branco" )
      RETU .F.
   ENDIF
   RETU .T.



// !*****************************************************************************
// !
// !         Fun‡„o: NUMDAC()
// !
// !    Chamado por: M_AI()             (fun‡„o    em C_AA.PRG)
// !
// !          Chama: DIGITO()           (fun‡„o    em MLIBRARY.PRG)
// !
// !*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NUMDAC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC NUMDAC( PR1, PR2, PR3 )

   LOCAL N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, SOMA1, COD

   IF ZREDUZ = "2" .OR. ZREDUZ = "3"
      mDAC := 0
      RETU 0
   ENDIF
   IF ValType( PR3 ) # "N"
      PR3 := 0
   ENDIF
   PR1 := AllTrim( PR1 ) + REPL( '0', 13 - Len( AllTrim( PR1 ) ) )
// multiplicacao inversa de cada numero para num-dac
   N1    := ( Val( SubStr( PR1, 1, 1 ) ) * 14 ) + 1
   N2    := ( Val( SubStr( PR1, 2, 1 ) ) * 13 ) + 2
   N3    := ( Val( SubStr( PR1, 3, 1 ) ) * 12 ) + 3
   N4    := ( Val( SubStr( PR1, 4, 1 ) ) * 11 ) + 4
   N5    := ( Val( SubStr( PR1, 5, 1 ) ) * 10 ) + 5
   N6    := ( Val( SubStr( PR1, 6, 1 ) ) * 9 ) + 6
   N7    := ( Val( SubStr( PR1, 7, 1 ) ) * 8 ) + 7
   N8    := ( Val( SubStr( PR1, 8, 1 ) ) * 7 ) + 8
   N9    := ( Val( SubStr( PR1, 9, 1 ) ) * 6 ) + 9
   N10   := ( Val( SubStr( PR1, 10, 1 ) ) * 5 ) + 10
   N11   := ( Val( SubStr( PR1, 11, 1 ) ) * 4 ) + 11
   N12   := ( Val( SubStr( PR1, 12, 1 ) ) * 3 ) + 12
   N13   := ( Val( SubStr( PR1, 13, 1 ) ) * 2 ) + 13
   SOMA1 := N1 + N2 + N3 + N4 + N5 + N6 + N7 + N8 + N9 + N10 + N11 + N12 + N13
   COD   := SubStr( PR1, 1, 2 ) + StrZero( SOMA1, 3 ) + Str( PR3, 1 )
   IF Len( COD ) > 6
      mNUMERO := Val( AllTrim( Left( COD, 6 ) ) )
   ELSE
      mNUMERO := Val( AllTrim( Left( COD, 6 ) ) )
   ENDIF
   mDAC := DIGITO( Val( COD ) )
   RETU DIGITO( Val( COD ) )

// !*****************************************************************************
// !
// !         Fun‡„o: DIGITO()
// !
// !    Chamado por: NUMDAC()           (fun‡„o    em MLIBRARY.PRG)
// !
// !*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DIGITO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC DIGITO( COD )

   LOCAL N1, N2, N3, N4, N5, N6, SOMAFIN, DIVFIN, RESTFIN, DIG

   COD     := Str( COD, 6 )
   N1      := Val( SubStr( COD, 1, 1 ) ) * 6
   N2      := Val( SubStr( COD, 2, 1 ) ) * 5
   N3      := Val( SubStr( COD, 3, 1 ) ) * 4
   N4      := Val( SubStr( COD, 4, 1 ) ) * 3
   N5      := Val( SubStr( COD, 5, 1 ) ) * 2
   N6      := Val( SubStr( COD, 6, 1 ) ) * 1
   SOMAFIN := N1 + N2 + N3 + N4 + N5 + N6
   DIVFIN  := SOMAFIN / 11
   RESTFIN := SOMAFIN - ( Int( DIVFIN ) * 11 )
   IF RESTFIN = 0 .OR. RESTFIN = 1
      DIG := 0
   ELSE
      DIG := 11 - RESTFIN  // definicao do dac
   ENDIF
   RETU DIG

// !*****************************************************************************
// !
// !         Fun‡„o: NIVELAR()
// !
// !    Chamado por: M_AI()
// !
// !    Parametros : P1 = CODIGO DA CONTA
// !
// !*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NIVELAR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC NIVELAR( P1 )

   LOCAL NIV, I, nTOTPOS

   NIV     := 0
   nTOTPOS := 0
   FOR I := 1 TO 9
      NIV := I
      IF I <> 9  // Evita Erro de Asseco a Matriz
         nTOTPOS += ZNIV[ I ]
         IF ZNIV[ I + 1 ] = 0 .OR. ( Len( AllTrim( P1 ) ) < nTOTPOS + ZNIV[ I + 1 ] )
            EXIT
         ENDIF
      ENDIF
   NEXT
   RETU NIV





// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NUMRED()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC NUMRED( cCONTA, nNUMERO )

   LOCAL xTAM

   IF zREDUZ # "2"
      RETU nNUMERO
   ENDIF
   XTAM := Len( AllTrim( cCONTA ) )
   IF XTAM > ZPOSI
      nNUMERO := Val( SubStr( cCONTA, ZPOSI, ( XTAM - ZPOSI + 1 ) ) )
   ENDIF
   RETU nNUMERO

// + EOF: m_ai1.prg
// +
