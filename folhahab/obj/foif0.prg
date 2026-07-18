// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foif0.prg
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
// +    Documentado em 27-Dez-2024 as  9:46 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :      FOIF0.PRG: Acumular Ficha Financeira Empresa
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  jcassiano  S/C Ltda.
// :  Atualizado em: 17/07/98
// :
// :*****************************************************************************

#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foif0()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foif0

   PARA CC

   CABEX( "Escolha o Grupo de Empresas" )
   MDS( "Inicialmente escolha qual empresas deseja Acumular" )

   IF MDG( "Deseja Apagar Acumulo Anterior" )
      netzap( "FO_FFE" )
   ENDIF

   PATWORK := hb_cwd()
   aEMP01  := {}   // NUMERO
   aEMP02  := {}   // COGNOME
   aRETU   := RFILORD( "FIRMA", .F. )
   INX     := aRETU[ 1 ]
   FILTRO  := aRETU[ 2 ]
   IF !netuse( "firma" )
      RETU .F.
   ENDIF
   SET FILTER TO &FILTRO
   dbGoTop()
   WHILE !Eof()
      AAdd( aEMP01, NRCLIEN )
      AAdd( aEMP02, COGNOME )
      dbSkip()
   ENDDO
   dbCloseAll()

   IF !NETUSE( "CONFIGU",,,,, .F., )
      RETU
   ENDIF
   INITVARS()
   EQUVARS()

   dbCloseAll()
   hb_DispBox( 8, 0, 23, 79, B_DOUBLE + " " )
   @  9, 24 SAY "FATORES DE ATUALIZA€ŽO/CONVERSŽO"
   @ 10, 0  SAY '+' + REPL( '-', 78 ) + 'Ý'
   @ 12, 2  SAY "JAN" + SPAC( 23 ) + "FEV" + SPAC( 24 ) + "MAR"
   @ 15, 2  SAY "ABR" + SPAC( 23 ) + "MAI" + SPAC( 24 ) + "JUN"
   @ 18, 2  SAY "JUL" + SPAC( 23 ) + "AGO" + SPAC( 24 ) + "SET"
   @ 21, 2  SAY "OUT" + SPAC( 23 ) + "NOV" + SPAC( 24 ) + "DEZ"
// Get nas Menvars
   @ 12, 7  GET mFFFE01
   @ 12, 33 GET mFFFE02
   @ 12, 60 GET mFFFE03
   @ 15, 7  GET mFFFE04
   @ 15, 33 GET mFFFE05
   @ 15, 60 GET mFFFE06
   @ 18, 7  GET mFFFE07
   @ 18, 33 GET mFFFE08
   @ 18, 60 GET mFFFE09
   @ 21, 7  GET mFFFE10
   @ 21, 33 GET mFFFE11
   @ 21, 60 GET mFFFE12
   IF !READCUR()
      RETU .T.
   ENDIF
   FAT := { mFFFE01, mFFFE02, mFFFE03, mFFFE04, mFFFE05, mFFFE06, ;
      mFFFE07, mFFFE08, mFFFE09, mFFFE10, mFFFE11, mFFFE12 }

   IF !NETUSE( "CONFIGU",,,,, .F., )
      RETU
   ENDIF
   REPLVARS()
   dbCloseAll()

   IF !netuse( "FO_FFE" )
      RETU .F.
   ENDIF
// Loop de Empresas
   FIMEMP := Len( aEMP01 )
   FOR W := 1 TO FIMEMP
      CABEX( "Aguarde Acumulando Empresa: " + aEMP02[ W ] )
      // PATH DA FIRMA
      PATFIR := PATWORK + '\EMP' + ANOWORK + StrZero( aEMP01[ W ], 3 ) + "\"
      // Loop de Meses
      FOR Q := 1 TO 12
         ARQMES := "FP" + StrZero( aEMP01[ W ], 4 ) + StrZero( Q, 2 )
         INFOR( PATFIR + ARQMES, "CONTROLE", PATFIR + ARQMES, .T. )
         IF !NETUSE( PATFIR + ARQMES )   // BREDE(PATFIR+ARQMES,0)
            dbCloseAll()
            RETU .F.
         ENDIF
         cSELE1 := Alias()
         GRAPP  := 1
         GRAPT  := LastRec()
         GRAPT( "Acumulando mes de : " + MMES( Q ) )
         dbGoTop()
         WHILE !Eof()
            mCONTA := CONTA
            mHORAS := HORAS
            mVALOR := IF( FAT[ Q ] = 0, VALOR, Round( ( VALOR / FAT[ Q ] ), 2 ) )
            dbSelectAr( "FO_FFE" )
            dbGoTop()
            IF !dbSeek( mCONTA * 100 + Q )
               NETRECAPP()
               FIELD->CONTA    := mCONTA
               FIELD->MES      := Q
               FIELD->CONTROLE := mCONTA * 100 + MES
            ELSE
               NETRECLOCK()
            ENDIF
            FIELD->HORAS := HORAS + mHORAS
            FIELD->VALOR := VALOR + mVALOR
            dbSelectAr( cSELE1 )
            GRAPS()
            dbSkip()
         ENDDO
         dbSelectAr( cSELE1 )
         dbCloseArea()
      NEXT Q
   NEXT W
   dbCloseAll()
// : FIM: FOIF0.PRG

// + EOF: foif0.prg
// +
