// :*****************************************************************************
// :
// :   RECUGER1.PRG: ETIQUETA
// :      Linguagem: Clipper 5.x
// :        Sistema: RECURSOS
// :          Autor: jcassiano
// :      Copyright (c) 2024,  jcassiano
// :
// :   & Fncts: RECUGER1()
// :               : CAD1()
// :               : TELATIP
// :
// :          Chama: CABE2()            (fun‡„o    em RECUPROC.PRG)
// :               : RECUETI1()         (funcao    em RECUETI1.PRG)
// :               : RECUETI2()         (funcao    em RECUETI2.PRG)
// :
// :*****************************************************************************


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function RECUGER1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION RECUGER1()

   IMPHP()


   memvar->AQ   := Chr( 27 ) + Chr( 71 )
   memvar->DQ   := Chr( 27 ) + Chr( 72 )
   memvar->AE   := memvar->cIMPTIT
   memvar->AC   := memvar->cIMPCOM
   memvar->DC   := memvar->cIMPEXP
   memvar->AI   := Chr( 27 ) + Chr( 52 )
   memvar->DI   := Chr( 27 ) + Chr( 53 )
   memvar->AN   := memvar->cIMPNEG
   memvar->DN   := memvar->cIMPNER
   memvar->AX   := Chr( 27 ) + Chr( 83 ) + Chr( 00 )
   memvar->AD   := Chr( 27 ) + Chr( 83 ) + Chr( 01 )
   memvar->DXD  := Chr( 27 ) + Chr( 84 )
   memvar->AS   := Chr( 27 ) + Chr( 45 ) + Chr( 00 )
   memvar->DS   := Chr( 27 ) + Chr( 45 ) + Chr( 01 )
   memvar->AEC  := Chr( 27 ) + Chr( 87 ) + Chr( 00 )
   memvar->DEC  := Chr( 27 ) + Chr( 87 ) + Chr( 01 )
   memvar->AIE  := Chr( 27 ) + Chr( 52 ) + Chr( 27 ) + Chr( 87 ) + Chr( 01 )
   memvar->DIE  := Chr( 27 ) + Chr( 53 ) + Chr( 27 ) + Chr( 87 ) + Chr( 00 )
   memvar->AIC  := Chr( 27 ) + Chr( 91 ) + Chr( 50 ) + Chr( 27 ) + Chr( 52 )
   memvar->DIC  := Chr( 27 ) + Chr( 91 ) + Chr( 48 ) + Chr( 27 ) + Chr( 53 )
   memvar->ACA  := Chr( 27 ) + Chr( 91 ) + Chr( 50 )
   memvar->ACB  := Chr( 27 ) + Chr( 91 ) + Chr( 51 )
   memvar->ACC  := Chr( 27 ) + Chr( 91 ) + Chr( 52 )
   memvar->ACD  := Chr( 27 ) + Chr( 91 ) + Chr( 53 )
   memvar->DCE  := Chr( 27 ) + Chr( 91 ) + Chr( 48 )
   memvar->ZMES := MMES( Month( memvar->ZDATA ) )
   memvar->ZDIA := DToC( memvar->ZDATA )
   memvar->ZANO := StrZero( Year( memvar->ZDATA ), 4 )
   memvar->ZRSM := REPL( "-", 132 )
   memvar->ZRDM := REPL( "=", 132 )
   memvar->ZRSS := REPL( "-", 80 )
   memvar->ZRDS := REPL( "=", 80 )


   DO WHILE .T.
      SetColor( "W/N" )
      @ 08, 00 CLEA
      cabe2( 'Gerador de Etiquetas' )
      SetColor( "W/G" )
      @ 08, 30 CLEAR TO 11, 49
      @ 08, 30 TO 11, 49 DOUB
      OPCAO( 09, 32, '    &Simples     ', 83 )
      OPCAO( 10, 32, '  &Configurada   ', 67 )
      memvar->OPCAO := MENU(, 0 )
      SetColor( "W/N" )
      DO CASE
      CASE memvar->OPCAO = 1
         RECUETI1()
      CASE memvar->OPCAO = 2
         RECUETI2()
      OTHERWISE
         dbCloseAll()
         RETURN .T.
      ENDCASE
   ENDDO

   RETURN .T.

// !*****************************************************************************
// !
// !         Funcao: CAD1()
// !
// !    Chamado por: CAD()              (funcao    em RECUETI1.PRG, chamado  no Dbedit())
// !               : LISTA              ( em RECUETI2.PRG)
// !
// !*****************************************************************************

FUNC CAD1

   PARA MODO
   memvar->KEY := LastKey()

   DO CASE
   CASE memvar->MODO < 4
      RETU ( 1 )
   CASE memvar->KEY = 7
      memvar->COR := SetColor()
      SetColor( "W/N" )
      IF MDG( 'Deseja mesmo apagar?' )
         NETRECDEL()
         memvar->PCK1 := .T.
      ENDIF
      SetColor( memvar->COR )
      RETU ( 2 )
   CASE memvar->KEY = 22
      memvar->nALTURA  := 0
      memvar->nLARGURA := 0
      memvar->nCOLUNAS := 0
      @ Row(), 51      GET NALTURA  VALID memvar->NALTURA < 9 .AND. !Empty( memvar->NALTURA )
      @ Row(), Col() + 1 GET NLARGURA VALID memvar->NLARGURA > 4 .AND. !Empty( memvar->NLARGURA )
      @ Row(), Col() + 1 GET NCOLUNAS VALID memvar->NCOLUNAS < 11 .AND. !Empty( memvar->NCOLUNAS )
      READCUR()
      IF memvar->NALTURA = 0 .OR. memvar->NLARGURA = 0 .OR. memvar->NCOLUNAS = 0
         RETU ( 2 )
      ELSE
         NETRECapp()
         FIELD->ALTURA  := memvar->nALTURA
         FIELD->LARGURA := memvar->nLARGURA
         FIELD->COLUNAS := memvar->nCOLUNAS
      ENDIF
      RETU ( 1 )
   CASE memvar->KEY = 13
      memvar->ALT     := FIELD->ALTURA
      memvar->LAR     := FIELD->LARGURA
      memvar->COL     := FIELD->COLUNAS
      memvar->IMPRIME := .T.
      RETU ( 0 )
   CASE memvar->KEY = 27
      RETU ( 0 )
   ENDCASE
   RETU ( 1 )


// !*****************************************************************************
// !
// !       TELATIP
// !
// !    Chamado por: CAD()              (funcao    em RECUETI1.PRG, chamado  no Dbedit())
// !               : LISTA              (  em RECUETI2.PRG)
// !
// !*****************************************************************************

FUNCTION TELATIP

   SetColor( "W/G" )
   @ 08, 49 CLEAR TO 16, 64
   @ 08, 49 TO 16, 64 DOUB
   @ 17, 49 CLEA TO 21, 72
   @ 17, 49 TO 21, 72 DOUB
   @ 18, 50 SAY "Lin = No. de Linhas   "
   @ 19, 50 SAY "Col = No. de Colunas  "
   @ 20, 50 SAY "Car = No. de Carreiras"
   @ 08, 51 SAY 'Lin'
   @ 08, 55 SAY 'Col'
   @ 08, 59 SAY 'Car'

   RETURN .T.
// : FIM: RECUGER1.PRG

// + EOF: recuger1.prg
// +
