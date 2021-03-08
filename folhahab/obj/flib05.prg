*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\OBJ\FLIB05.PRG
*+
*+    Functions: Function RFILORD()
*+               Function RFILTRO()
*+               Function RCAMPO()
*+               Function FILTRO()
*+               Function FILORD()
*+               Procedure DFILTRO()
*+
*+    Reformatted by Click! 2.03 on May-28-2003 at  9:11 am
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

////#INCLUDE "COMANDO.CH"
#INCLUDE "INKEY.CH"
#INCLUDE "BOX.CH"
#INCLUDE "DBINFO.CH"

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function RFILORD()
*+
*+    Called from ( flib05.prg   )   1 - function filtro()
*+                                   1 - function filord()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func RFILORD( ARQWORK, lTIPO, cFILTRO, nINDICE )

//Arqwork se nao passado pega em uso e nao fecha Lopen
//Ltipo se falso nao pergunta ordem so filtro
//Sem tipo passa ""
local cDBF    := alias()
local cINDICE := ""
lOPEN := .T.
if valtype( lTIPO ) # "L"
   lTIPO := .T.
endif
if valtype( cFILTRO ) # "C"
   cFILTRO := ""
endif
if valtype( ARQWORK ) # "C"
   lOPEN := .F.
endif
if valtype( nINDICE ) # "N"
   nINDICE := 1
endif
if lOPEN
   if ! NETUSE(ARQWORK)
      retu { "", cFILTRO }
   endif
endif
aESTRU := dbstruct()
if lOPEN
   dbclosearea()
endif
pESTRU := len( aESTRU )
dESTRU := array( pESTRU )
//Pegando os Coment rios
if EMPTY(HELPARQ)
   ALERTX("RFILORD: Variavel HelpARQ Em Branco")
   retu { indexkey(), cFILTRO }
ELSE
  if netuse(helparq) //AREDE( HELPARQ, HELPARQ, 0, .T. )
     for X := 1 to pESTRU
        dbgotop()
        if dbseek( padr( ARQWORK, 8 ) + "M" + padr( aESTRU[ X, 1 ], 9 ) )
           dESTRU[ X ] = DADO
        else
           dESTRU[ X ] = padr( aESTRU[ X, 1 ], 10 )
        endif
    next X   
    dbclosearea()
  ELSE
    for X := 1 to pESTRU
        dESTRU[ X ] = padr( aESTRU[ X, 1 ], 10 )
    next X   
  endif 
ENDIF
if lTIPO
   //Escolhendo Ordem
   ORD_SCR := savescreen( 00, 00, 24, 79 )
   setcolor( "+GR/N" )
   HB_dispbox( 8, 0, 24, 79, B_DOUBLE+" ")
   setcolor( "+N/GR" )
   HB_DISPBOX( 8, 45, 10, 76, B_DOUBLE+" ")
   @ 09, 46 say "Escolha a ordem da Listagem"
   setcolor( "+W/BG" )
   HB_DISPBOX( 12, 45, 21, 76, B_DOUBLE+" ")
   @ 13, 46 say "Ande com as setas:"
   @ 15, 46 say " Quando a op‡„o desejada"
   @ 16, 46 say " estiver em destaque"
   @ 17, 46 say "    tecle enter."
   setcolor( "W/N" )
   defa := 1
   set key K_ESC to NOBREAK
   nINDICE := RCAMPO( nINDICE )
   set key K_ESC to
   cINDICE := if( nINDICE # 0, aESTRU[ nINDICE, 1 ], aESTRU[ 1, 1 ] )           //Defa Pos Achoice
   restscreen( 00, 00, 24, 79, ORD_SCR )
endif
cFILTRO := RFILTRO( cFILTRO )
if !empty( cDBF )
   dbselectar(cDBF)
endif
retu { cINDICE, cFILTRO }

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function RFILTRO()
*+
*+    Called from ( flib05.prg   )   1 - function rfilord()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func RFILTRO( cFILTRO, DEFA )           //Filtro Inicial,Posi‡ao Inicial Achoice

if valtype( cFILTRO ) # "C"
   cFILTRO := ""
endif
if valtype( DEFA ) # "N"
   defa := 1
endif
save screen
setcolor( "+GR/N" )
HB_dispbox( 8, 0, 24, 79, B_DOUBLE+" " )
setcolor( "+N/GR" )
HB_DISPBOX( 8, 45, 10, 76, B_DOUBLE+" ")
@  9, 46 say "Escolha o grupo de dados"
setcolor( "+GR/BG" )
HB_DISPBOX( 12, 45, 21, 76, B_DOUBLE+" ")
@ 13, 46 say "Ande com as setas:"
@ 15, 46 say "Quando op‡„o desejada estiver"
@ 16, 46 say "em destaque tecle enter."
@ 17, 46 say "Forne‡a o  grupo de dados "
@ 18, 46 say "dando os limites iniciais e"
@ 19, 46 say "finais do grupo."
@ 20, 46 say "Tecle ESC para encerrar."
setcolor( "W/N,N/W" )
while .T.
   DFILTRO( cFILTRO )
   defa := RCAMPO( DEFA )
   if defa = 0
      exit
   endif
   XCTR1 := XCTR2 := MAKEVAR( aESTRU[ DEFA, 2 ], aESTRU[ DEFA, 3 ], aESTRU[ DEFA, 4 ] )
   XCTR3 := "E"
   XCTR5 := ">="
   TELAG := savescreen( 08, 16, 24, 79 )
   @ 08, 16 clea to 24, 79
   HB_dispbox( 08, 17, 23, 79, B_DOUBLE+" ")
   @ 09, 20 say "Forne‡a os Limites inicial e Final do(a)"
   @ 10, 20 say dESTRU[ DEFA ]
   @ 11, 17 say '+' + repl( '-', 61 ) + 'Э'
   @ 12, 20 say 'Do '
   @ 13, 17 say '+' + repl( '-', 61 ) + 'Э'
   @ 14, 20 say 'Ao '
   @ 15, 17 say '+' + repl( '-', 61 ) + 'Э'
   @ 16, 20 say '(E) (O)u (B)ranco (M)anual'
   @ 17, 20 say "Opera‡ao: >= <= <> > <"
   set key K_ESC to NOBREAK
   @ 12, 23 get XCTR1
   @ 14, 23 get XCTR2
   @ 16, 50 get XCTR3 valid XCTR3 $ "EOBM"
   @ 17, 50 get XCTR5 valid trim( XCTR5 ) $ "<>=" .or. XCTR5 = ">=" .or. XCTR5 = "<=" .or. xCTR5 = "<>"
   READCUR()
   IF XCTR3="M"
      cFILTRO:=cFILTRO+SPACE(80)
      MDS("")
      @ 24,00 GET cFILTRO pict "@S78"
      READCUR()
      cFILTRO:=ALLTRIM(cFILTRO)
   ENDIF
   set key K_ESC to
   restscreen( 08, 16, 24, 79, TELAG )
   do case
   case aESTRU[ DEFA, 2 ] = "C"
      XCTR1A := '"' + alltrim( XCTR1 ) + '"'
      XCTR2A := '"' + alltrim( XCTR2 ) + '"'
   case aESTRU[ DEFA, 2 ] = "D"
      XCTR1A := 'CTOD(' + '"' + dtoc( XCTR1 ) + '"' + ')'
      XCTR2A := 'CTOD(' + '"' + dtoc( XCTR2 ) + '"' + ')'
   case aESTRU[ DEFA, 2 ] = "N"
      XCTR1A := alltrim( str( XCTR1, aESTRU[ DEFA, 3 ], aESTRU[ DEFA, 4 ] ) )
      XCTR2A := alltrim( str( XCTR2, aESTRU[ DEFA, 3 ], aESTRU[ DEFA, 4 ] ) )
   endcase
   if !empty( XCTR1 ) .or. !empty( XCTR2 ) .or. XCTR3 = "B"
      XCTR4 := ".AND."
      if XCTR3 = "O"
         XCTR4 := ".OR."
      endif
      if !empty( XCTR2 )
         XCTR6 := "<="
         if XCTR5 = "> "
            XCTR6 := "<"
         endif
         cFILTRO += if( empty( cFILTRO ), "", XCTR4 ) + "(" + alltrim( aESTRU[ DEFA, 1 ] ) + XCTR5 + XCTR1A + '.AND.' + alltrim( aESTRU[ DEFA, 1 ] ) + XCTR6 + XCTR2A + ")"
      else
         cFILTRO += if( empty( cFILTRO ), "", XCTR4 ) + "(" + alltrim( aESTRU[ DEFA, 1 ] ) + XCTR5 + XCTR1A + ")"
      endif
   endif
enddo
rest screen
set key K_ALT_F to
set key K_ALT_G to
retu cFILTRO

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function RCAMPO()
*+
*+    Called from ( flib05.prg   )   1 - function rfilord()
*+                                   1 - function rfiltro()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func RCAMPO

@ 08, 00 clear to min( pESTRU + 9, 21 ), 43
@ 08, 00 to min( pESTRU + 9, 21 ), 43 DOUB
retu achoice( 09, 02, min( pESTRU + 9, 20 ), 41, dESTRU )

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function FILTRO()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
funcTION FILTRO( cFILTRO, nDEFA )
aRETU := RFILORD(, .F., cFILTRO, nDEFA )
return aRETU[ 2 ]

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function FILORD()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
function FILORD(lINDEX)
IF VALTYPE(lINDEX)<>"L"
   lINDEX:=.F.
ENDIF
IF lINDEX
   nIndexes  :=  dbORDERINFO( DBOI_ORDERCOUNT )
   aNtxNames  := {}
   FOR i = 1 TO nIndexes
       AAdd( aNtxNames ,  dbORDERINFO( DBOI_NAME , ,  i )+" - "+dbORDERINFO( DBOI_EXPRESSION , ,  i ) )
   NEXT
   IF nIndexes>1
      nRESP := ACHOICE(6,6, 16,74,aNTXNAMES)
      if lastkey()=13
         INX:=nRESP        
         FILTRO := FILTRO(FILTRO)
         //ALERTX(STR(INX))
         // ALERTX(FILTRO)
         RETURN
      endif
   ENDIF
ENDIF
aRETU  := RFILORD(, .T., FILTRO )       //Filtro e variavel padrao
INX    := aRETU[ 1 ]                  //inx variavel padrao
FILTRO := aRETU[ 2 ]
RETURN


*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Procedure DFILTRO()
*+
*+    Called from ( flib05.prg   )   1 - function rfiltro()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
proc DFILTRO( TFILTRO )

TFILTRO := strtran( TFILTRO, ".AND.", " E " )
TFILTRO := strtran( TFILTRO, ".OR.", " OU " )
TFILTRO := strtran( TFILTRO, "MONTH", "MES" )
TFILTRO := strtran( TFILTRO, "YEAR", "ANO" )
TFILTRO := strtran( TFILTRO, "EMPTY", "SEM" )
TFILTRO := strtran( TFILTRO, "DTOC", "DIA" )
TFILTRO := strtran( TFILTRO, "!", " NAO " )
MDS( TFILTRO )
retu TFILTRO

*+ EOF: FLIB05.PRG
