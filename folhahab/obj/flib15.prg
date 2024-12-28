// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : flib15.prg
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

#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TELAPEG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION TELAPEG( cCOD, cARQ )

   LOCAL aRETU := {}, cDBF := Alias()

   IF ValType( cARQ ) # "C"
      cARQ := "FOLTEL"
   ENDIF
   IF !NetUse( cARQ )
      RETU aRETU
   ENDIF
   dbGoTop()
   dbSeek( cCOD )
   WHILE CODIGO = cCOD .AND. !Eof()
      AAdd( aRETU, { TIP, LININI, COLINI, LINFIM, COLFIM, DIZER, ESTILO } )
      dbSkip()
   ENDDO
   dbCloseArea()
   IF !Empty( cDBF )
      dbSelectAr( cDBF )
   ENDIF
   RETU aRETU



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TELASAY()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION TELASAY( aTEL )

   LOCAL i, cTIP, nLININI, nCOLINI, nLINFIM, nCOLFIM, cESTILO
   PRIV cDIZ := ""

   IF ValType( aTEL ) = "C" .AND. ValType( aTEL ) <> 'A'   // Recebeu o Codigo do layout e nao a matriz
      aTEL := TELAPEG( aTEL )  // Pega o relatorio
   ENDIF
   IF Empty( aTEL )
      ALERTX( "Layout de Tela Vazio" )
      RETU .F.
   ENDIF
   FOR i := 1 TO Len( aTEL )
      cTIP    := aTEL[ I, 1 ]
      nLININI := aTEL[ I, 2 ]
      nCOLINI := aTEL[ I, 3 ]
      nLINFIM := aTEL[ I, 4 ]
      nCOLFIM := aTEL[ I, 5 ]
      cDIZ    := AllTrim( aTEL[ I, 6 ] )
      cESTILO := AllTrim( aTEL[ I, 7 ] )
      DO CASE
      CASE Empty( cTIP )   // Say Simples
         IF Empty( cESTILO )   // Sem ou Com Picture
            @ nLININI, nCOLINI SAY &cDIZ.
         ELSE
            @ nLININI, nCOLINI SAY &cDIZ. PICT &cESTILO.
         ENDIF
      CASE cTIP = "B"  // Box
         hb_Scroll( nLININI, nCOLINI, nLINFIM, nCOLFIM )
         DO CASE
         CASE Left( cDIZ, 2 ) = "SD" .OR. cDIZ = "B_SINGLE_DOUBLE"
            hb_DispBox( nLININI, nCOLINI, nLINFIM, nCOLFIM, B_SINGLE_DOUBLE + " " )
         CASE Left( cDIZ, 2 ) = "DS" .OR. cDIZ = "B_DOUBLE_SINGLE"
            hb_DispBox( nLININI, nCOLINI, nLINFIM, nCOLFIM, B_DOUBLE_SINGLE + " " )
         CASE Left( cDIZ, 1 ) = "D" .OR. cDIZ = "B_DOUBLE"
            hb_DispBox( nLININI, nCOLINI, nLINFIM, nCOLFIM, B_DOUBLE + " " )
         CASE Left( cDIZ, 1 ) = "S" .OR. cDIZ = "B_SINGLE"
            hb_DispBox( nLININI, nCOLINI, nLINFIM, nCOLFIM, B_SINGLE + " " )
         OTHERWISE
            hb_DispBox( nLININI, nCOLINI, nLINFIM, nCOLFIM, &cDIZ. )
         ENDCASE
      CASE cTIP = "C"  // cor
         SetColor( &cDIZ )
      ENDCASE
   NEXT i
   RETU .T.


// + EOF: flib15.prg
// +
