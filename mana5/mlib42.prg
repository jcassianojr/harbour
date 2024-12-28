// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib42.prg
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
// #INCLUDE "MEMOGET.CH"
// #INCLUDE "FILEGET.CH"
#include "box.ch"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function EDITPEG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION EDITPEG( cCOD, cARQ )

   LOCAL Ltem  := .F.
   LOCAL aRETU := {}

   IF ValType( cARQ ) # "C"
      cARQ := "MANGET"
   ENDIF
   IF !USEREDE( cARQ, 1, 1 )
      RETU aRETU
   ENDIF
   dbGoTop()
   dbSeek( cCOD )
   WHILE CODIGO = cCOD .AND. !Eof()
      AAdd( aRETU, { TIP, LININI, COLINI, LINFIM, COLFIM, AllTrim( CAMPO ), AllTrim( ESTILO ), AllTrim( MENSAGEM ), AllTrim( CONDICAO ), AllTrim( PRECOND ) } )
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
// +    Function EDITSAY()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC EDITSAY( aGET, nMES )

   LOCAL i
   LOCAL cTIP
   LOCAL nLININI
   LOCAL nCOLINI
   LOCAL nLINFIM
   LOCAL nCOLFIM
   LOCAL cESTILO
   PRIV cDIZ     := ""
   PRIV v_pic    := "@S18"

   IF ValType( aGET ) = "C"  // Recebeu o Codigo do layout e nao a matriz
      aGET := EDITPEG( aGET )  // Pega o relatorio
   ENDIF
   IF ValType( nMES ) # "N"
      Set( _SET_MESSAGE, 24, .T. )
   ELSE
      Set( _SET_MESSAGE, nMES, .T. )
   ENDIF
   IF Empty( aGET )
      ALERTX( "Layout de Edi��o Vazio" )
      RETU .F.
   ENDIF
   @ 24, 0 clea
   FOR i := 1 TO Len( aGET )
      cTIP    := aGET[ I, 1 ]
      nLININI := aGET[ I, 2 ]
      nCOLINI := aGET[ I, 3 ]
      nLINFIM := aGET[ I, 4 ]
      nCOLFIM := aGET[ I, 5 ]
      IF nLININI == 97
         nLININI := nROW
      ENDIF
      IF nLINFIM == 97
         nLINFIM := nROW
      ENDIF
      IF nLININI == 98
         nLININI := Row()
      ENDIF
      IF nLINFIM == 98
         nLINFIM := Row()
      ENDIF
      IF nLININI == 99
         nLININI := 24
      ENDIF
      IF nLINFIM == 99
         nLINFIM := 24
      ENDIF
      cDIZ      := aGET[ I, 6 ]
      cESTILO   := aGET[ I, 7 ]
      cMENSAGEM := aGET[ I, 8 ]
      cVALIDAR  := aGET[ I, 9 ]
      cPREVAL   := aGET[ I, 10 ]
      DO CASE
      CASE cTIP = "T"
         TELASAY( AllTrim( cDIZ ) )
         // case cTIP = "M"
         // @ nLININI,nCOLINI get &cDIZ. MEMO COORD {9,2,16,77}
      CASE cTIP = "R"
         READCUR()
      CASE cTIP = "2"
         cDIZ2 := cDIZ
         IF ZLANC = 0
            @ nLININI, nCOLINI GET &cDIZ. PICT ZPICCC VALID CHECKCC( cDIZ2 )
         ELSE
            @ nLININI, nCOLINI GET &cDIZ. VALID CHECKCC( cDIZ2 )
         ENDIF
      CASE cTIP = "1"
         @ nLININI, nCOLINI GET &cDIZ. PICT( v_pic ) WHEN {| oGet | CNPJCPFPICT( oGet, mPESSOA, nLININI, nCOLINI ) } VALID CNPJCPFVAL( &cDIZ., mPESSOA )
      /*
         do case
            case mPESSOA = "J"
               @ nLININI,nCOLINI get &cDIZ. valid VALCGC(&cDIZ.) pict "99.999.999/9999-99"
            case mPESSOA = "F"
               @ nLININI,nCOLINI get &cDIZ. valid VALCPF(&cDIZ.) pict "999.999.999-99"
            case mPESSOA = "C"    //CEI //CNO
               @ nLININI,nCOLINI get &cDIZ. valid VALCEI(&cDIZ.)
            otherwise
               @ nLININI,nCOLINI get &cDIZ.
         endcase
         */
      CASE cTIP = "S"  // Say Simples
         IF Empty( cESTILO )   // Sem ou Com Picture
            @ nLININI, nCOLINI SAY &cDIZ.
         ELSE
            @ nLININI, nCOLINI SAY &cDIZ. PICT &cESTILO.
         ENDIF
      CASE Empty( cTIP )   // GET
         IF Empty( cESTILO )   // Sem Picture
            DO CASE
            CASE Empty( cVALIDAR ) .AND. Empty( cPREVAL )
               @ nLININI, nCOLINI GET &cDIZ.
            CASE !Empty( cVALIDAR ) .AND. !Empty( cPREVAL )
               @ nLININI, nCOLINI GET &cDIZ. VALID &cVALIDAR WHEN &cPREVAL
            CASE !Empty( cVALIDAR ) .AND. Empty( cPREVAL )
               @ nLININI, nCOLINI GET &cDIZ. VALID &cVALIDAR
            CASE Empty( cVALIDAR ) .AND. !Empty( cPREVAL )
               @ nLININI, nCOLINI GET &cDIZ. WHEN &cPREVAL
            ENDCASE
         ELSE  // Com Picture
            DO CASE
            CASE Empty( cVALIDAR ) .AND. Empty( cPREVAL )
               @ nLININI, nCOLINI GET &cDIZ. PICT &cESTILO.
            CASE !Empty( cVALIDAR ) .AND. !Empty( cPREVAL )
               @ nLININI, nCOLINI GET &cDIZ. VALID &cVALIDAR WHEN &cPREVAL PICT &cESTILO.
            CASE !Empty( cVALIDAR ) .AND. Empty( cPREVAL )
               @ nLININI, nCOLINI GET &cDIZ. VALID &cVALIDAR PICT &cESTILO.
            CASE Empty( cVALIDAR ) .AND. !Empty( cPREVAL )
               @ nLININI, nCOLINI GET &cDIZ. WHEN &cPREVAL PICT &cESTILO.
            ENDCASE
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
   READCUR()

   RETURN .T.


// + EOF: mlib42.prg
// +
