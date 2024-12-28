// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : manemp.prg
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



// Teclas Operacionais
#include "INKEY.CH"
// #INCLUDE "COMANDO.CH"



PADRAO( 0, 1, 0, "MANEMP", "No.   Nome da Empresa" + spac( 26 ) + "DDD   Telefone", ;
      "' '+STR(mNUMERO,  5)+' '+mNOME+' '+mDDD+' '+mTELEFONE", "MAZ",, {|| gMAZ() } )



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gMAZ()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC gMAZ

   EDITSAY( "MAZ001" )
   TELASAY( "MAZ002" )
   EDITSAY( "MAZ002" )
   TELASAY( "MAZ003" )
   EDITSAY( "MAZ003" )
   ZREDUZ   := mREDUZIDO
   ZPOSI    := mPOSI
   ZLANC    := mLANC
   ZBATE    := mBATE
   ZNIV     := { mNIVEL1, mNIVEL2, mNIVEL3, mNIVEL4, mNIVEL5, mNIVEL6, mNIVEL7, mNIVEL8, mNIVEL9 }
   ZEMPRESA := mNOME
   IF ZNIV[ 1 ] = 0
      ZPICCC := "XXXXXXXXXXX"
      ZTAMCC := 11
   ELSE
      ZPICCC := "@R "
      FOR X := 1 TO 9
         IF ZNIV[ X ] > 0
            IF X # 1
               ZPICCC += "."
            ENDIF
            ZPICCC += REPL( "9", ZNIV[ X ] )
         ENDIF
      NEXT X
      ZTAMCC := Len( ZPICCC ) - 3
   ENDIF
   RETU .T.



// + EOF: manemp.prg
// +
