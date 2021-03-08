*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
*+
*+    Source Module => C:\CLIPPER\FOLHA\OBJ\FOIF1.PRG
*+
*+    Reformatted by Click! 2.03 on May-12-2001 at  3:05 pm
*+
*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ

////#INCLUDE "COMANDO.CH"

CABEX( "Escolha o Grupo a listar" )
VAL    := array( 12 )
aRETU:=RFILORD("FO_FFE",.F.)
INX:=aRETU[1]
FILTRO:=aRETU[2]


CABEX( "Escolha o Grupo de Contas listar" )
MDS( "Ande com as setas e Tecle enter na desejada" )
@  7,  1 prom " 1 - Todas as Contas" + spac( 20 )
@  8,  1 prom " 2 - S¢ as Contas de Cr‚dito" + spac( 12 )
@  9,  1 prom " 3 - S¢ as Contas de Bases de Calculo   "
@ 10,  1 prom " 4 - S¢ as Contas de D‚bitos" + spac( 12 )
@ 11,  1 prom " 5 - S¢ as Contas de Cr‚dito + D‚bitos  "
@ 12,  1 prom " 6 - S¢ as Contas de Bases   + D‚bitos  "
@ 13,  1 prom " 7 - S¢ as Contas de Cr‚dito + Bases    "
@ 14,  1 prom " 8 - Sequencia de Contas" + spac( 16 )
@ 15,  1 prom " 9 - Pr‚ Selecionada" + spac( 20 )
menu to KEY
if KEY = 0
   retu .F.
endif

if KEY = 8
   SEPARADO := PEGRELCTA("")
endif

if KEY = 9
   mSELFEE := " "
   MDS( "Qual Sele‡„o" )
   @ 24, 40 get mSELFEE
   if !READCUR()
      retu .F.
   endif
endif

HORIMP := MDG( "Deseja Imprimir tamb‚m o acumulado de Horas" )

CABEX( "Carregando defini‡”es das Contas" )
aCTA01 := {}        //NUMERO
aCTA02 := {}        //DESCRICAO
aCTA03 := {}        //TIPO
if ! NETUSE("CONTAS") 
   retu .F.
endif
GRAPP := 1
GRAPT := lastrec()
GRAPT( "Carregando Dados do Plano de Contas" )
dbgotop()
while !eof()
   INC := .F.
   do case
   case KEY = 1
      INC := .T.
   case KEY = 2
      if CODIGO < 400 .and. ( CODIGO > 40 .and. CODIGO < 50 )
         INC := .T.
      endif
   case KEY = 3
      if CODIGO > 400 .and. CODIGO < 502
         INC := .T.
      endif
   case KEY = 4
      if CODIGO > 501 .or. ( CODIGO > 40 .and. CODIGO < 50 )
         INC := .T.
      endif
   case KEY = 5
      if CODIGO < 400 .or. CODIGO > 501 .and. ( CODIGO > 40 .and. CODIGO < 50 )
         INC := .T.
      endif
   case KEY = 6
      if CODIGO > 399 .or. ( CODIGO > 40 .and. CODIGO < 50 )
         INC := .T.
      endif
   case KEY = 7
      if CODIGO < 502 .and. ( CODIGO > 40 .and. CODIGO < 50 )
         INC := .T.
      endif
   case KEY = 8
      if ascan( SEPARADO, CODIGO ) # 0
         INC := .T.
      endif
   case KEY = 9
      if mSELFEE = SELFFE
         INC := .T.
      endif
   endcase
   if INC
      aadd( aCTA01, CODIGO )
      aadd( aCTA02, left( DESCR, 30 ) )
      aadd( aCTA03, TIPO )
   endif
   GRAPS()
   dbskip()
enddo
dbcloseall()

if !CHECKIMP( 0 )
   retu .F.
endif

FL  := 0
LIN := 80
if ! netuse("FO_FFE") //AREDE( "FO_FFE", "FO_FFE", 0 )
   retu .F.
endif
set filter to &FILTRO
IMPRESSORA()
dbgotop()
while !eof()
   FL ++
   if LIN > 60
      @  1,  1  say IMPCHR( 18 )
      @  2, 20  say IMPCHR( 14 ) + MSG2
      @  3, 20  say IMPCHR( 14 ) + 'FICHA FINANCEIRA EMPRESA ( ANUAL )'
      @  4, 100 say time()
      @  4, 110 say DXDIA
      @  4, 120 say 'FL. ' + strzero( FL, 4 )
      @  5,  0  say repl( "-", 132 )
      @  6,  0  say IMPCHR( 15 ) + 'CTA'
      @  6,  5  say 'Nome Conta '
      for X := 1 to 12
         COL := 23 + ( X * 14 )
         @  6, COL say padl( MMES( X ), 14 )
      next X
      @  6, 208 say 'Total   Ano'
      @  7,  0  say IMPCHR( 18 ) + repl( "-", 132 ) + IMPCHR( 15 )
      LIN := 8
   endif
   mCONTA := CONTA
   MPOS   := ascan( aCTA01, mCONTA )
   if MPOS # 0
      @ LIN,  0 say mCONTA         pict "###"
      @ LIN,  4 say aCTA02[ mPOS ]
      HOR  := if( aCTA03[ mPOS ] = 1 .or. aCTA03[ mPOS ] = 3, .T., .F. )
      TVAL := 0.00
      afill( VAL, 0 )
      while CONTA = mCONTA .and. !eof()
         COL := MES * 14 + 22
         if HOR .and. HORIMP
            @ LIN, COL say HORAS pict '###,###,###.##'
            TVAL += HORAS
         endif
         VAL[ MES ] = VALOR
         dbskip()
      enddo
      if HOR .and. HORIMP
         @ LIN, 208 say TVAL pict '#########.##'
         LIN ++
         TVAL := 0.00
      endif
      for X := 1 to 12
         if VAL[ X ] # 0
            COL := X * 14 + 22
            @ LIN, COL say VAL[ X ] pict '###########.##'
            TVAL += VAL[ X ]
         endif
      next X
      @ LIN, 208 say TVAL pict '#########.##'
      LIN ++
   else
      while mCONTA = CONTA .and. !eof()
         dbskip()
      enddo
   endif
enddo
dbcloseall()
VIDEO()
IMPEND()
retu

*+ EOF: FOIF1.PRG
