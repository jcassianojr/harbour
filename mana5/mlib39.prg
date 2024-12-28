// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib39.prg
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

#include "box.ch"



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

   LOCAL lTEM  := .F.
   LOCAL aRETU := {}

   IF ValType( cARQ ) # "C"
      cARQ := "MANTEL"
   ENDIF
   IF !USEREDE( cARQ, 1, 1 )
      RETU aRETU
   ENDIF
   dbGoTop()
   dbSeek( cCOD )
   WHILE CODIGO = cCOD .AND. !Eof()
      AAdd( aRETU, { TIP, LININI, COLINI, LINFIM, COLFIM, DIZER, ESTILO } )
      dbSkip()
      lTEM := .T.
   ENDDO
   dbCloseArea()
   IF !lTEM
      // ALERTX("Nao Encontrei layout Tela: "+cCOD)
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

   LOCAL i
   LOCAL cTIP
   LOCAL nLININI
   LOCAL nCOLINI
   LOCAL nLINFIM
   LOCAL nCOLFIM
   LOCAL cESTILO
   PRIV cDIZ     := ""

   IF ValType( aTEL ) = "C"  // Recebeu o Codigo do layout e nao a matriz
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
      IF nCOLINI = -1
         nCOLINI := Col() + 1
      ENDIF
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
         DO CASE
         CASE Left( cDIZ, 2 ) = "SD" .OR. cDIZ = "B_SINGLE_DOUBLE"
            hb_DispBox( nLININI, nCOLINI, nLINFIM, nCOLFIM, B_SINGLE_DOUBLE )
         CASE Left( cDIZ, 2 ) = "DS" .OR. cDIZ = "B_DOUBLE_SINGLE"
            hb_DispBox( nLININI, nCOLINI, nLINFIM, nCOLFIM, B_DOUBLE_SINGLE )
         CASE Left( cDIZ, 1 ) = "D" .OR. cDIZ = "B_DOUBLE"
            hb_DispBox( nLININI, nCOLINI, nLINFIM, nCOLFIM, B_DOUBLE )
         CASE Left( cDIZ, 1 ) = "S" .OR. cDIZ = "B_SINGLE"
            hb_DispBox( nLININI, nCOLINI, nLINFIM, nCOLFIM, B_SINGLE )
         OTHERWISE
            hb_DispBox( nLININI, nCOLINI, nLINFIM, nCOLFIM, &cDIZ. )
         ENDCASE
      CASE cTIP = "C"  // cor
         SetColor( &cDIZ )
      ENDCASE
   NEXT i

   RETURN .T.


// + EOF: mlib39.prg
// +
