*****************************************************************
FUNCTION READTEXT
*****************************************************************

* Apresenta um arq. texto de qualquer tamanho em uma janela p/leitura.

* Copyright(c) 1991 -- James Occhiogrosso

# include "box.ch"
# include "inkey.ch"
# define wind_rows  (bottom - top) - 1   // window rows
# define wind_cols  (right - left) - 3   // window columns

LOCAL counter := 0, old_cursor := SETCURSOR(0), old_screen := ''
PRIVATE text_array := {}, col_offset := 1, keypress := 0
PARAMETERS text_file, top, left, bottom, right, start_line

* Inicializa argumentos nao especificados com parametros predefinidos.

top = IF(top = NIL, 0, top)
left = IF(left = NIL, 0, left)
bottom = IF(bottom = NIL, MAXROW(), bottom)
right = IF(right = NIL, MAXCOL(), right)
start_line = IF(start_line = NIL, 1, start_line)


* Se o arquivo nao puder ser aberto, encerra a funcao.
IF (handle := hb_FOPEN(text_file)) > 0

    * Grava a tela antiga e a area de texto delimitada por uma moldura.
//    old_screen = SCRNSAVE(top, left, bottom, right)
    @ top, left, bottom, right BOX B_SINGLE + SPACE(1)
    @ TOP,LEFT+1   SAY "Ý"
    @ TOP,RIGHT    SAY "Ý"
    @ bottom,LEFT  SAY "Ý"
    @ bottom,right SAY "Ý"
    @ TOP+1 ,RIGHT SAY chr(30)
    @ bottom-1 ,RIGHT SAY chr(31)
    @ bottom,left+1 SAY CHR(17)
    @ bottom,right-1 say chr(16)
    for x=top+2 to bottom-2
        @ x,right say "Ý"
    next x
    for x=left+2 to right-2
        @ bottom,x say "Ý"
    next x
    * Grava o valor de final do arquivo.
    text_eof = FSEEK(handle, 0, 2)

    * Declara array de visual. como numero linhas da janela por 2 cols.
    * Colunas: 1 = ponteiro do arquivo, 2 = texto da linha
    text_array := array(wind_rows,2)

    IF start_line > 1
        FOR counter = 1 TO (start_line)
            * Move o ponteiro do arquivo para a linha especificada.
            FREADLINE(handle)
        NEXT
    ENDIF

    * Carrega o array e apresenta a janela inicial com as linhas.
    FILL_ARRAY()
    DISP_ARRAY()

    * Processa as teclas pressionadas e reapresenta o array.
    PROCESS_KEY()

    * Recupera a tela antiga e fecha o arquivo.
//    SCRNREST(old_screen)
    FCLOSE(handle)

ENDIF


SETCURSOR(old_cursor)
RETURN NIL


*****************************************************************
STATIC FUNCTION PROCESS_KEY
*****************************************************************

* Processa as teclas para movimentacao da janela.

LOCAL buffer := SPACE(512), line_end := line_num := pointer := 0

DO WHILE keypress != K_ESC

    * Se a tecla for valida, e' processada.

    IF  keypress = K_UP        .OR. keypress = K_DOWN  .OR. ;
        keypress = K_HOME      .OR. keypress = K_END   .OR. ;
        keypress = K_PGUP      .OR. keypress = K_PGDN  .OR. ;
        keypress = K_LEFT      .OR. keypress = K_RIGHT .OR. ;
        keypress = K_CTRL_LEFT .OR. keypress = K_CTRL_RIGHT ;
        .OR. keypress = K_ENTER

        * Move 1 linha ou 1 tela para cima.
        IF keypress = K_UP .OR. keypress = K_PGUP

             IF text_array[1][1] != 0  // Inicio do arquivo

                 * Move ponteiro do arquivo p/ a linha superior do array
                 pointer = FSEEK(handle, text_array[1][1], 0)

                 * Guarda ponteiro do arquivo (linha ou janela de tela)
                 pointer = REWIND(handle, IF(keypress = K_UP, ;
                           1, wind_rows), pointer)

                 * E recarrega o array.
                 FILL_ARRAY()
             ENDIF

        * Move 1 linha ou 1 tela para baixo.
        ELSEIF keypress = K_DOWN .OR. keypress = K_PGDN

             * Verifica se esta' no final do arquivo.
             IF FSEEK(handle,0,1) != text_eof

                 * Se nao for EOF nem BOF, recarrega o array.
                 IF keypress = K_DOWN
                     * Move ponteiro p/ segundo elem. do array.
                     FSEEK(handle, text_array[2][1], 0)
                 ENDIF

                 FILL_ARRAY()
             ENDIF

        * Move para o inicio do arquivo.
        ELSEIF keypress = K_HOME
             pointer = FSEEK(handle,0,0)
             FILL_ARRAY()

        * Move para o final do arquivo.
        ELSEIF keypress = K_END
             pointer = FSEEK(handle,0,2)
             * Move o ponteiro uma janela de tela para tras.
             pointer = REWIND(handle, wind_rows, pointer)
             FILL_ARRAY()

        * Move a janela 1 coluna `a direita.
        ELSEIF keypress = K_RIGHT
             col_offset := IF(col_offset < 512,++col_offset, 512)

        * Move a janela 1 coluna `a esquerda.
        ELSEIF keypress = K_LEFT
             col_offset := IF(col_offset > 1, --col_offset, 1)

        * Move a janela 8 colunas `a direita.
        ELSEIF keypress = K_CTRL_RIGHT
             col_offset := IF(col_offset < 512,col_offset+8, 512)

        * Move a janela 8 colunas `a esquerda.
        ELSEIF keypress = K_CTRL_LEFT
             col_offset := IF(col_offset > 8, col_offset-8, 1)

        * Reinicializa o desloc. da janela p/ primeira coluna.
        ELSEIF keypress = K_ENTER
             col_offset := 1

        ENDIF

        * Reapresenta o array.
        keypress = DISP_ARRAY()

    ELSE
        * Se a tecla nao for valida, obtem outra.
        keypress:=0
        WHILE keypress=0
           keypress:=hotinkey()
           keypress:=lermouse(keypress)
           IF MOUSE_B=2
              DO CASE
                 CASE MOUSE_Y=TOP     .AND.MOUSE_X=LEFT+1  ; keypress:=K_ESC
                 CASE MOUSE_Y=TOP     .AND.MOUSE_X=RIGHT   ; keypress:=K_HOME
                 CASE MOUSE_Y=bottom  .and.MOUSE_X=left    ; keypress:=K_ENTER
                 CASE MOUSE_Y=bottom  .and.MOUSE_X=right   ; keypress:=K_END
                 CASE MOUSE_Y=top   +1.and.MOUSE_X=Right   ; keypress:=K_UP
                 CASE MOUSE_Y=bottom-1.and.MOUSE_X=Right   ; keypress:=K_DOWN
                 CASE MOUSE_Y=bottom  .and.MOUSE_X=left+1  ; keypress:=K_LEFT
                 CASE MOUSE_Y=bottom  .and.MOUSE_X=right-1 ; keypress:=K_RIGHT
                 OTHERWISE
                     for x=top+2 to bottom-2
                         IF MOUSE_X=RIGHT.AND.MOUSE_Y=X
                            IF MOUSE_Y<INT((bottom-top-4)/2)+top
                               keypress:=K_PGUP
                            ELSE
                               keypress:=K_PGDN
                            ENDIF
                         ENDIF
                     next x
                     for x=left+2 to right-2
                         IF MOUSE_Y=bottom.AND.MOUSE_X=x
                            IF MOUSE_X<INT((right-left-4)/2)+left
                               keypress:=K_CTRL_LEFT
                            ELSE
                               keypress:=K_CTRL_RIGHT
                            ENDIF
                         ENDIF
                     next x
              ENDCASE
           ENDIF
        ENDDO
    ENDIF
ENDDO

RETURN NIL


*****************************************************************
STATIC FUNCTION FILL_ARRAY
*****************************************************************

* Carrega o array de visualizacao c/ o ponteiro e o texto de cada linha.

LOCAL counter := 1

FOR counter = 1 TO (wind_rows)
     text_array[counter][1] := FSEEK(handle, 0, 1)
     text_array[counter][2] := FREADLINE(handle)
     IF FSEEK(handle, 0, 1) >= text_eof ; EXIT ; ENDIF
NEXT

* Se for EOF, preenche o balanceamento do array com valores ficticios.
IF counter++ < wind_rows
    FOR counter = counter TO wind_rows
        text_array[counter][1] := text_eof
        text_array[counter][2] := ''
    NEXT
ENDIF

RETURN NIL

*****************************************************************
STATIC FUNCTION DISP_ARRAY
*****************************************************************

* Mostra array. Retorna imediatamente se uma tecla nao for pressionada.
LOCAL counter := 1, disp_string

* Apaga o buffer do teclado e a area da janela.

CLEAR TYPEAHEAD
@ top+1, left+2 CLEAR TO bottom-1, right-2

* Mostra linhas da janela ate' terminar ou uma tecla ser pressionada.
DO WHILE (keypress := INKEY()) = 0 .AND. counter <= wind_rows
    * Apresenta a cadeia e incrementa o contador de linhas.
    @ (top + counter), left + 2 SAY ;
            RANGEREPL(CHR(0),CHR(31),SUBSTR(text_array[counter][2], col_offset, wind_cols),"")
    counter++

ENDDO

RETURN keypress


*****************************************************************
STATIC FUNCTION REWIND (handle, num_lines, pointer)
*****************************************************************

* Move o ponteiro do arquivo para tras do numero de linhas especificado.

LOCAL buffer := SPACE(512), first_line := .F.,  line_end := 0

DO WHILE num_lines > 0

    * Apaga o buffer.
    buffer := SPACE(512)

    IF pointer >= 514
        * Move o ponteiro 514 bytes para tras.
        FSEEK(handle, -514, 1)

        * Preenche buffer sem retorno de carro/avanco de linha (CR/LF).
        FREAD(handle, @buffer, 512)

    ELSE
        * Move o ponteiro para BOF e carrega texto restante.
        FSEEK(handle, -pointer, 1)
        FREAD(handle, @buffer, pointer-2)

        * Ativa sinaliz. primeira linha se nao ha' CR/LF no buffer.
        buffer = TRIM(buffer)
        first_line := IF(AT(CHR(13)+CHR(10), buffer) > 0,.F.,.T.)
    ENDIF

    * Verifica a existencia de um CR/LF anterior.
    DO WHILE (line_end := RAT(CHR(13)+CHR(10), buffer)) > 0 ;
              .AND. num_lines > 0

        * Move o ponteiro para o final da linha anterior.
        pointer = FSEEK(handle, -(LEN(buffer)-(line_end-1)), 1)

        * Retira linha do buffer e decrementa numero restante.
        buffer = SUBSTR(buffer, 1, line_end - 1)
        num_lines--
    ENDDO

    IF ! first_line
       * Move ponteiro para inicio da proxima linha (salta CR/LF)
       pointer = FSEEK(handle, 2, 1)
    ELSE
       * Reinicializa ponteiro para BOF e encerra operacao.
       FSEEK(handle, 0, 0)
       EXIT
    ENDIF
    

ENDDO

RETURN pointer