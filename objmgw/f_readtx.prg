// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : f_readtx.prg
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
// +    Documentado em 28-Dez-2024 as 10:42 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// ****************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function READTEXT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION READTEXT

// ****************************************************************

// Apresenta um arq. texto de qualquer tamanho em uma janela p/leitura.

// Copyright(c) 1991 -- James Occhiogrosso

#include "box.ch"
#include "inkey.ch"
#define wind_rows  (bottom - top) - 1   // window rows
#define wind_cols  (right - left) - 3   // window columns

   LOCAL counter      := 0, old_cursor := SetCursor( 0 ), old_screen := ''
   PRIVATE text_array := {}, col_offset := 1, keypress := 0
   PARAMETERS text_file, TOP, left, BOTTOM, right, start_line

// Inicializa argumentos nao especificados com parametros predefinidos.

   TOP        := IF( TOP = NIL, 0, top )
   left       := IF( left = NIL, 0, left )
   BOTTOM     := IF( BOTTOM = NIL, MaxRow(), bottom )
   right      := IF( right = NIL, MaxCol(), right )
   start_line := IF( start_line = NIL, 1, start_line )


// Se o arquivo nao puder ser aberto, encerra a funcao.
   IF ( handle := hb_FOPEN( text_file ) ) > 0

      // Grava a tela antiga e a area de texto delimitada por uma moldura.
      // old_screen = SCRNSAVE(top, left, bottom, right)
      @ TOP, left, BOTTOM, right BOX B_SINGLE + Space( 1 )
      @ TOP, LEFT + 1       SAY "Ý"
      @ TOP, RIGHT        SAY "Ý"
      @ bottom, LEFT      SAY "Ý"
      @ bottom, right     SAY "Ý"
      @ TOP + 1, RIGHT      SAY Chr( 30 )
      @ BOTTOM - 1, RIGHT SAY Chr( 31 )
      @ bottom, left + 1    SAY Chr( 17 )
      @ bottom, right - 1 SAY Chr( 16 )
      FOR x := top + 2 TO BOTTOM - 2
         @ x, right SAY "Ý"
      NEXT x
      FOR x := left + 2 TO right - 2
         @ bottom, x SAY "Ý"
      NEXT x
      // Grava o valor de final do arquivo.
      text_eof := FSeek( handle, 0, 2 )

      // Declara array de visual. como numero linhas da janela por 2 cols.
      // Colunas: 1 = ponteiro do arquivo, 2 = texto da linha
      text_array := Array( wind_rows, 2 )

      IF start_line > 1
         FOR counter := 1 TO ( start_line )
            // Move o ponteiro do arquivo para a linha especificada.
            FREADLINE( handle )
         NEXT
      ENDIF

      // Carrega o array e apresenta a janela inicial com as linhas.
      FILL_ARRAY()
      DISP_ARRAY()

      // Processa as teclas pressionadas e reapresenta o array.
      PROCESS_KEY()

      // Recupera a tela antiga e fecha o arquivo.
      // SCRNREST(old_screen)
      FClose( handle )

   ENDIF


   SetCursor( old_cursor )

   RETURN NIL


// ****************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function PROCESS_KEY()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION PROCESS_KEY

// ****************************************************************

// Processa as teclas para movimentacao da janela.

   LOCAL buffer := Space( 512 ), line_end := line_num := pointer := 0

   DO WHILE keypress != K_ESC

      // Se a tecla for valida, e' processada.

      IF keypress = K_UP .OR. keypress = K_DOWN .OR. ;
            keypress = K_HOME .OR. keypress = K_END .OR. ;
            keypress = K_PGUP .OR. keypress = K_PGDN .OR. ;
            keypress = K_LEFT .OR. keypress = K_RIGHT .OR. ;
            keypress = K_CTRL_LEFT .OR. keypress = K_CTRL_RIGHT ;
            .OR. keypress = K_ENTER

         // Move 1 linha ou 1 tela para cima.
         IF keypress = K_UP .OR. keypress = K_PGUP

            IF text_array[ 1,  1 ] != 0   // Inicio do arquivo

               // Move ponteiro do arquivo p/ a linha superior do array
               pointer := FSeek( handle, text_array[ 1, 1 ], 0 )

               // Guarda ponteiro do arquivo (linha ou janela de tela)
               pointer := REWIND( handle, IF( keypress = K_UP, ;
                  1, wind_rows ), pointer )

               // E recarrega o array.
               FILL_ARRAY()
            ENDIF

            // Move 1 linha ou 1 tela para baixo.
         ELSEIF keypress = K_DOWN .OR. keypress = K_PGDN

            // Verifica se esta' no final do arquivo.
            IF FSeek( handle, 0, 1 ) != text_eof

               // Se nao for EOF nem BOF, recarrega o array.
               IF keypress = K_DOWN
                  // Move ponteiro p/ segundo elem. do array.
                  FSeek( handle, text_array[ 2,  1 ], 0 )
               ENDIF

               FILL_ARRAY()
            ENDIF

            // Move para o inicio do arquivo.
         ELSEIF keypress = K_HOME
            pointer := FSeek( handle, 0, 0 )
            FILL_ARRAY()

            // Move para o final do arquivo.
         ELSEIF keypress = K_END
            pointer := FSeek( handle, 0, 2 )
            // Move o ponteiro uma janela de tela para tras.
            pointer := REWIND( handle, wind_rows, pointer )
            FILL_ARRAY()

            // Move a janela 1 coluna `a direita.
         ELSEIF keypress = K_RIGHT
            col_offset := IF( col_offset < 512, ++col_offset, 512 )

            // Move a janela 1 coluna `a esquerda.
         ELSEIF keypress = K_LEFT
            col_offset := IF( col_offset > 1, --col_offset, 1 )

            // Move a janela 8 colunas `a direita.
         ELSEIF keypress = K_CTRL_RIGHT
            col_offset := IF( col_offset < 512, col_offset + 8, 512 )

            // Move a janela 8 colunas `a esquerda.
         ELSEIF keypress = K_CTRL_LEFT
            col_offset := IF( col_offset > 8, col_offset - 8, 1 )

            // Reinicializa o desloc. da janela p/ primeira coluna.
         ELSEIF keypress = K_ENTER
            col_offset := 1

         ENDIF

         // Reapresenta o array.
         keypress := DISP_ARRAY()

      ELSE
         // Se a tecla nao for valida, obtem outra.
         keypress := 0
         WHILE keypress = 0
            keypress := hotinkey()
            keypress := lermouse( keypress )
            IF MOUSE_B = 2
               DO CASE
               CASE MOUSE_Y = TOP .AND. MOUSE_X = LEFT + 1
                  keypress := K_ESC
               CASE MOUSE_Y = TOP .AND. MOUSE_X = RIGHT
                  keypress := K_HOME
               CASE MOUSE_Y = BOTTOM .AND. MOUSE_X = left
                  keypress := K_ENTER
               CASE MOUSE_Y = BOTTOM .AND. MOUSE_X = right
                  keypress := K_END
               CASE MOUSE_Y = TOP + 1 .AND. MOUSE_X = Right
                  keypress := K_UP
               CASE MOUSE_Y = BOTTOM - 1 .AND. MOUSE_X = Right
                  keypress := K_DOWN
               CASE MOUSE_Y = BOTTOM .AND. MOUSE_X = left + 1
                  keypress := K_LEFT
               CASE MOUSE_Y = BOTTOM .AND. MOUSE_X = right - 1
                  keypress := K_RIGHT
               OTHERWISE
                  FOR x := top + 2 TO BOTTOM - 2
                     IF MOUSE_X = RIGHT .AND. MOUSE_Y = X
                        IF MOUSE_Y < Int( ( BOTTOM - TOP - 4 ) / 2 ) + top
                           keypress := K_PGUP
                        ELSE
                           keypress := K_PGDN
                        ENDIF
                     ENDIF
                  NEXT x
                  FOR x := left + 2 TO right - 2
                     IF MOUSE_Y = BOTTOM .AND. MOUSE_X = x
                        IF MOUSE_X < Int( ( right - left - 4 ) / 2 ) + left
                           keypress := K_CTRL_LEFT
                        ELSE
                           keypress := K_CTRL_RIGHT
                        ENDIF
                     ENDIF
                  NEXT x
               ENDCASE
            ENDIF
         ENDDO
      ENDIF
   ENDDO

   RETURN NIL


// ****************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function FILL_ARRAY()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION FILL_ARRAY

// ****************************************************************

// Carrega o array de visualizacao c/ o ponteiro e o texto de cada linha.

   LOCAL counter := 1

   FOR counter := 1 TO ( wind_rows )
      text_array[ counter, 1 ] := FSeek( handle, 0, 1 )
      text_array[ counter, 2 ] := FREADLINE( handle )
      IF FSeek( handle, 0, 1 ) >= text_eof
         EXIT
      ENDIF
   NEXT

// Se for EOF, preenche o balanceamento do array com valores ficticios.
   IF counter++ < wind_rows
      FOR counter := counter TO wind_rows
         text_array[ counter, 1 ] := text_eof
         text_array[ counter, 2 ] := ''
      NEXT
   ENDIF

   RETURN NIL

// ****************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function DISP_ARRAY()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION DISP_ARRAY

// ****************************************************************

// Mostra array. Retorna imediatamente se uma tecla nao for pressionada.
   LOCAL counter := 1, disp_string

// Apaga o buffer do teclado e a area da janela.

   CLEAR TYPEAHEAD
   @ top + 1, left + 2 CLEAR TO BOTTOM - 1, right - 2

// Mostra linhas da janela ate' terminar ou uma tecla ser pressionada.
   DO WHILE ( keypress := Inkey() ) = 0 .AND. counter <= wind_rows
      // Apresenta a cadeia e incrementa o contador de linhas.
      @ ( TOP + counter ), left + 2 SAY ;
         RANGEREPL( Chr( 0 ), Chr( 31 ), SubStr( text_array[ counter,  2 ], col_offset, wind_cols ), "" )
      counter++

   ENDDO

   RETURN keypress



// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function REWIND()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION REWIND( handle, num_lines, pointer )

// ****************************************************************

// Move o ponteiro do arquivo para tras do numero de linhas especificado.

   LOCAL buffer := Space( 512 ), first_line := .F., line_end := 0

   DO WHILE num_lines > 0

      // Apaga o buffer.
      buffer := Space( 512 )

      IF pointer >= 514
         // Move o ponteiro 514 bytes para tras.
         FSeek( handle, - 514, 1 )

         // Preenche buffer sem retorno de carro/avanco de linha (CR/LF).
         FRead( handle, @buffer, 512 )

      ELSE
         // Move o ponteiro para BOF e carrega texto restante.
         FSeek( handle, - pointer, 1 )
         FRead( handle, @buffer, pointer - 2 )

         // Ativa sinaliz. primeira linha se nao ha' CR/LF no buffer.
         buffer     := Trim( buffer )
         first_line := IF( At( Chr( 13 ) + Chr( 10 ), buffer ) > 0, .F., .T. )
      ENDIF

      // Verifica a existencia de um CR/LF anterior.
      DO WHILE ( line_end := RAt( Chr( 13 ) + Chr( 10 ), buffer ) ) > 0 ;
            .AND. num_lines > 0

         // Move o ponteiro para o final da linha anterior.
         pointer := FSeek( handle, - ( Len( buffer ) - ( line_end - 1 ) ), 1 )

         // Retira linha do buffer e decrementa numero restante.
         buffer := SubStr( buffer, 1, line_end - 1 )
         num_lines--
      ENDDO

      IF !first_line
         // Move ponteiro para inicio da proxima linha (salta CR/LF)
         pointer := FSeek( handle, 2, 1 )
      ELSE
         // Reinicializa ponteiro para BOF e encerra operacao.
         FSeek( handle, 0, 0 )
         EXIT
      ENDIF


   ENDDO

   RETURN pointer

// + EOF: f_readtx.prg
// +
