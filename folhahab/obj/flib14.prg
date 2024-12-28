// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : flib14.prg
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
// +    Documentado em 27-Dez-2024 as  9:44 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// //#INCLUDE "COMANDO.CH"

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function PEGRELCTA()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC PEGRELCTA( cNAME )

   LOCAL aCON := Array( 15 )

   IF Empty( cNAME )
      cNAME := Space( 8 )
      MDS( "Digite o Nome da Planilha" )
      @ 24, 40 GET cNAME
      READCUR()
   ENDIF
   AFill( aCON, 0 )

   IF !netuse( "RELCONTA" )  // AREDE("RELCONTA","RELCONTA",1)
      RETU
   ENDIF
   dbGoTop()
   IF dbSeek( cNAME )
      aCON := { C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15 }
   ELSE
      dbCloseArea()
      ALERTX( "Sequencia de Contas n„o encontrada: " + cNAME )
      RETU aCON
   ENDIF
   dbCloseArea()
   RETU aCON

// + EOF: flib14.prg
// +
