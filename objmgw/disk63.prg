// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : disk63.prg
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
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


#include "INKEY.CH"


// +--------------------------------------------------------------------
// +
// +    Function PEGAPASS()
// +
// +--------------------------------------------------------------------
// +
FUNCTION PEGAPASS( PW_ROW, PW_COL, PW_LEN, PW_COR, ECHO_CHAR, p_upcase, p_echochar )

   LOCAL OLD_COLOR 
   LOCAL f_str := "", f_i := 1, f_key, f_c


   LOCAL f_mrow
   LOCAL f_mcol

// Guarda a Cor Atual
   OLD_COLOR := SetColor()

// Seleciona a Cor Desejada Se Passada
   IF ValType( PW_COR ) = "C"
      SetColor( PW_COR )
   ENDIF
   
   PW_ROW := if( ValType( PW_ROW ) = 'N', PW_ROW, maxrow() )
   PW_COL := if( ValType( PW_COL ) = 'N', PW_COL, 1 )

// Checa o Tamanho Maximo da String
   PW_LEN := if( ValType( PW_LEN ) = 'N', PW_LEN, 80 )

// Posiciona Para Receber Caracter
   IF ValType( PW_ROW ) = "N" .AND. ValType( PW_COL ) = "N"
      @ PW_ROW, PW_COL SAY ""
   ENDIF

// Coloca o Caracter Padrao de Eco Se n„o Passado
   IF ValType( ECHO_CHAR ) # "C"
      ECHO_CHAR := "*"
   ENDIF

   p_upcase   := if( ValType( p_upcase ) = 'L', p_upcase, .F. )
   p_echochar := if( ValType( p_echochar ) = 'L', p_echochar, .F. )

// Zera a String e a Posi‡„o
   f_str := ''
   f_i   := 1

   DO WHILE f_i <= PW_LEN  // Fica em loop at‚ atingir o tamanho
      f_key := Inkey( 0 )  // Aguarda uma Tecla

      DO CASE
      CASE f_key > 31 .AND. f_key < 127  // Checa Caracter Valido
         f_c   := if( p_upcase, Upper( Chr( f_key ) ), Chr( f_key ) )  // Converte em Maisculas
         f_str += f_c  // Soma o caracter a cadeia
         f_i++// Soma o contador
         @ Row(), Col() SAY if( p_echochar, f_c, ECHO_CHAR ) // Mostra o caracter o o echo

         // Pressiona Backspace/seta esquerda. Move o cursor e ajusta £ltimo car
      CASE ( f_key = K_BS .OR. f_key = K_LEFT ) .AND. f_i > 1  // Retorno n„o sendo a primeira
         f_mrow := if( Col() = 0, Row() - 1, Row() )   // Ajusta a Posi‡„o
         f_mcol := if( Col() = 0, 79, Col() - 1 )
         @ f_mrow, f_mcol SAY ' ' // Limpa posicao video anterior
         @ f_mrow, f_mcol SAY '' // Retona o Cursos
         f_i--// Desconta o contador
         f_str := if( f_i = 1, '', SubStr( f_str, 1, f_i - 1 ) )   // Na 1¦posi‡„o coloca a string nula ou peda‡o

      CASE f_key = K_ENTER .OR. f_key = K_PGUP .OR. f_key = K_PGDN   // Enter Encerra
         EXIT
      CASE f_key = K_ESC   // Esc   Encerra
         f_str := ''   // Zera a String Antes
         EXIT
      ENDCASE
   ENDDO

// Reinicializa a cor
   SetColor( OLD_COLOR )

   RETURN f_str




// +--------------------------------------------------------------------
// +
// +    Function CheckPass()
// +
// +--------------------------------------------------------------------
// +
FUNCTION CheckPass( Ctexto, lMES )

   LOCAL nI, lMAIS, lMINUS, lDIG, lSYMBOL

   lMAIS   := .F.
   lMINUS  := .F.
   lDIG    := .F.
   lSYMBOL := .F.
   IF ValType( lMES ) # "L"
      lMES := .T.
   ENDIF
   IF Len( AllTrim( cTEXTO ) ) < 8
      IF lMES
         ALERTX( "Minimo 8 Caracteres" )
      ENDIF
      RETURN .F.
   ENDIF

   FOR nI := 1 TO Len( cTexto )
      IF SubStr( cTEXTO, nI, 1 ) $ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
         lMAIS := .T.
      ENDIF
      IF SubStr( cTEXTO, nI, 1 ) $ 'abcdefghijklmnopqrstuvwxyz'
         lMINUS := .T.
      ENDIF
      IF SubStr( cTEXTO, nI, 1 ) $ '0123456789'
         lDIG := .T.
      ENDIF
      IF SubStr( cTEXTO, nI, 1 ) $ '-+_!@#$%^&*., ?'
         lSYMBOL := .T.
      ENDIF
   NEXT
   IF lMAIS .AND. lMINUS .AND. lDIG .AND. lSYMBOL
      RETURN .T.
   ELSE
      IF !lMAIS .AND. lMES
         alertx( " Sem uma maiuscula" )
      ENDIF
      IF !lMinus .AND. lMES
         alertx( " Sem uma minuscula" )
      ENDIF
      IF !lDIG .AND. lMES
         alertx( " Sem um numero" )
      ENDIF
      IF !lSYMBOL .AND. lMES
         alertx( " Sem um simbulo -+_!@#$%^&*., ?" )
      ENDIF
   ENDIF

   RETURN .F.

// + EOF: disk63.prg
// +
