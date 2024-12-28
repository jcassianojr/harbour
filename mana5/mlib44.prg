// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib44.prg
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

//
// chamar aplicativos externos use #
// exemplo #edit
//


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function AUTOMENU()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC AUTOMENU( cDESC, cITEM, nMES, cARQMENU )

   PRIV aMENUPROMPTS := {}
   PRIV aITEM        := {}
   PRIV W
   PRIV KEY

   IF ValType( nMES ) # "N"
      nMES := 0
   ENDIF
   IF ValType( cARQMENU ) # "C"
      cARQMENU := "MANOPT"
   ENDIF

   IF USEREDE( cARQMENU, 1, 1 )
      dbGoTop()
      dbSeek( cITEM )
      WHILE ITEMENU = cITEM .AND. !Eof()
         IF POSICAO > 0 .AND. POSICAO < 34
            AAdd( aITEM, { LINHA, COLUNA, Left( DESCP, 25 ), TECLA, DESCM, AllTrim( EXECUTAR ) } )
         ENDIF
         dbSkip()
      ENDDO
      dbCloseArea()
   ENDIF
   IF Empty( aITEM )
      ALERTX( "Menu de Acesso " + cITEM + " Vazio" )
      RETU
   ENDIF

   WHILE .T.
      MDI( cDESC )
      SetColor( ZCOR008 )
      FOR W := 1 TO Len( aITEM )
         OPCAO( aITEM[ W, 1 ], aITEM[ W, 2 ], aITEM[ W, 3 ], aITEM[ W, 4 ], aITEM[ W, 5 ] )
      NEXT W
      KEY := menu( 1, nMES )
      IF KEY = 0
         RETU
      ENDIF
      IF KEY > 0
         DO CASE
         CASE cARQMENU = "MANSUB"
            IF !PEGACS( "S", cITEM + StrZero( KEY, 3 ) + ZUSER, .T., cITEM + " " + Str( KEY ) + " Voce n„o tem acesso, Verifique com o Supervisor" )
               LOOP
            ENDIF
         OTHERWISE
            IF !ENTMNU( cITEM, KEY )
               LOOP
            ENDIF
         ENDCASE
         cVAR := AllTrim( aITEM[ KEY, 6 ] )
         IF Left( cVAR, 1 ) = "#"
            cVAR := SubStr( cVAR, 2 )
            hb_run( cVAR )
         ELSE
            IF Empty( cVAR )
               ALERTX( "NÆo Disponivel/NÆo Configurada" )
               LOOP
            ELSE
               cVAR := &( "{||" + cVAR + "}" )
               Eval( cVAR )
            ENDIF
         ENDIF
      ENDIF
   ENDDO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MENUFEC()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MENUFEC

   PARA cARQ
   PRIV cSTR
   PRIV aITEM := { "", "", "", "", "", "", "" }

   PEGACAMPO( "MANFEC", "cARQ", { "STRDES", "OPER01", "OPER02", "OPER03", "OPER04", "OPER05", "OPER06", "OPER07" }, ;
      { "cSTR", "aITEM[1]", "aITEM[2]", "aITEM[3]", "aITEM[4]", "aITEM[5]", "aITEM[6]", "aITEM[7]" } )
   WHILE .T.
      MDI( " Ý ",,, cARQ )
      SetColor( ZCOR008 )
      OPCAO( 03, 04, " &A - Atual        ", 65 )
      OPCAO( 04, 04, " &B - Baixados     ", 66 )
      OPCAO( 05, 04, " &C - Mˆs Fechado  ", 67 )
      OPCAO( 06, 04, " &D - Fechar o Mˆs ", 68 )
      OPCAO( 07, 04, " &E - Acumulado    ", 69 )
      OPCAO( 08, 04, " &F - Acumular     ", 70 )
      OPCAO( 09, 04, " &G - Volta Baixa  ", 71 )
      KEY := menu( 1, 0 )
      IF KEY = 0
         RETU
      ENDIF
      IF KEY > 0
         IF !PEGACS( "F", Str( KEY, 1 ) + cARQ + ZUSER, .T., cARQ + " Fechamento - Voce n„o tem acesso, Verifique com o Supervisor" )
            LOOP
         ENDIF
         gravalog( Str( KEY ), "MNF", cARQ )
         cVAR := AllTrim( aITEM[ KEY ] )
         IF Empty( cVAR )
            ALERTX( "NÆo Disponivel/NÆo Configurada" )
            LOOP
         ELSE
            cVAR := &( "{||" + cVAR + "}" )
            Eval( cVAR )
         ENDIF
      ENDIF
   ENDDO



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ENTMNU()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC ENTMNU( cKEY, nPOS )

   IF nPOS <= 0
      RETU .F.
   ENDIF
   IF !ZSUPER
      IF !VERSEHA( "MUSERM", USERMCRI( ZUSER, cKEY, nPOS ) )
         ALERTX( cKEY + " " + Str( nPOS ) + "Voce n„o tem acesso, Verifique com o Supervisor" )
         RETU .F.
      ENDIF
   ENDIF
   gravalog( cKEY, "MNU", Str( nPOS ) )
   RETU .T.


// + EOF: mlib44.prg
// +
