*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²
*+
*+    Source Module => C:\DEVELOP\OBJ\DISK63.PRG
*+
*+    Functions: Function PEGAPASS()
*+
*+    Reformatted by Click! 2.03 on Sep-13-2004 at  9:54 am
*+
*+²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

#INCLUDE "INKEY.CH"

*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
*+    Function PEGAPASS()
*+
*+    Called from ( lock.prg     )   1 - function acesso()
*+
*+±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*+
function PEGAPASS( PW_ROW, PW_COL, PW_LEN, PW_COR, ECHO_CHAR, p_upcase, p_echochar )

local f_str
local f_i
local f_key
local f_c
local f_mrow
local f_mcol

//Guarda a Cor Atual
OLD_COLOR := setcolor()

// Seleciona a Cor Desejada Se Passada
if valtype( PW_COR ) = "C"
   setcolor( PW_COR )
endif

//Checa o Tamanho Maximo da String
PW_LEN := if( valtype( PW_LEN ) = 'N', PW_LEN, 80 )

//Posiciona Para Receber Caracter
if valtype( PW_ROW ) = "N" .and. valtype( PW_COL ) = "N"
   @ PW_ROW, PW_COL say ""         
endif

//Coloca o Caracter Padrao de Eco Se n„o Passado
if valtype( ECHO_CHAR ) # "C"
   ECHO_CHAR := "*"
endif

p_upcase   := if( valtype( p_upcase ) = 'L', p_upcase, .F. )
p_echochar := if( valtype( p_echochar ) = 'L', p_echochar, .F. )

//Zera a String e a Posi‡„o
f_str := ''
f_i   := 1

do while f_i <= PW_LEN                  //Fica em loop at‚ atingir o tamanho
   f_key := inkey( 0 )                  //Aguarda uma Tecla

   do case
   case f_key > 31 .and. f_key < 127    //Checa Caracter Valido
      f_c   := if( p_upcase, upper( chr( f_key ) ), chr( f_key ) )              //Converte em Maisculas
      f_str += f_c  //Soma o caracter a cadeia
      f_i ++        //Soma o contador
      @ row(), col() say if( p_echochar, f_c, ECHO_CHAR ) //Mostra o caracter o o echo         

      // Pressiona Backspace/seta esquerda. Move o cursor e ajusta £ltimo car
   case ( f_key = K_BS .or. f_key = K_LEFT ) .and. f_i > 1  //Retorno n„o sendo a primeira
      f_mrow := if( col() = 0, row() - 1, row() )           //Ajusta a Posi‡„o
      f_mcol := if( col() = 0, 79, col() - 1 )
      @ f_mrow, f_mcol say ' ' //Limpa posicao video anterior         
      @ f_mrow, f_mcol say '' //Retona o Cursos                       
      f_i --        //Desconta o contador
      f_str := if( f_i = 1, '', substr( f_str, 1, f_i - 1 ) )                   //Na 1¦posi‡„o coloca a string nula ou peda‡o

   case f_key = K_ENTER .or. f_key = K_PGUP .or. f_key = K_PGDN                 //Enter Encerra
      exit
   case f_key = K_ESC                   //Esc   Encerra
      f_str := ''   //Zera a String Antes
      exit
   endcase
enddo

// Reinicializa a cor
setcolor( OLD_COLOR )

return f_str



function CheckPass(Ctexto,lMES)
LOCAL nI,lMAIS,lMINUS,lDIG,lSYMBOL
lMAIS   := .F.
lMINUS  := .F.
lDIG    := .F.
lSYMBOL := .F.
IF VALTYPE(lMES)#"L"
    lMES:=.T.
ENDIF
IF lEN(aLLTRIM(cTEXTO))<8
   IF lMES
      ALERTX("Minimo 8 Caracteres")
   ENDIF
   RETURN .F.
ENDIF

FOR nI = 1 TO LEN(cTexto)
	IF SUBStr ( cTEXTO, nI, 1 ) $ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
       lMAIS :=.T.
    ENDIF
  	IF SUBStr ( cTEXTO, nI, 1 ) $ 'abcdefghijklmnopqrstuvwxyz'
       lMINUS :=.T.
    ENDIF
    IF SUBStr ( cTEXTO, nI, 1 ) $ '0123456789'
       lDIG :=.T.
    ENDIF
    IF SUBStr ( cTEXTO, nI, 1 ) $ '-+_!@#$%^&*., ?'
       lSYMBOL :=.T.
    ENDIF  
NEXT
IF lMAIS .AND. lMINUS .AND. lDIG .AND. lSYMBOL
   RETURN .T.
ELSE
  if ! lMAIS .AND. lMES
     alertx(" Sem uma maiuscula")
   ENDIF
   if ! lMinus  .AND. lMES
     alertx(" Sem uma minuscula")
   ENDIF 
    if ! lDIG  .AND. lMES
     alertx(" Sem um numero")
   ENDIF 
    if ! lSYMBOL  .AND. lMES
     alertx(" Sem um simbulo -+_!@#$%^&*., ?")
   ENDIF
ENDIF
RETURN .F.


*+ EOF: DISK63.PRG
