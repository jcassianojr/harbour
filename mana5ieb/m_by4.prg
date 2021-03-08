*+께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께
*+
*+    Source Module => J:\ITAESBRA\M_BY4.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
*+
*+께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께께

//#INCLUDE "COMANDO.CH"
MDI( " Historico do Estoque " )
cTIPO := "S"
@ 22, 00 say "(P)roduto (M)at.Prima (C)omponentes (S)ub Produto (O)outros/Consumiveis"
@ 23, 00 say "Horas (E)Equipamento (H)omem (T)erceiros"
@ 24, 40 get cTIPO                                                                     valid cTIPO $ "SPCMOT" pict "!"
if !READCUR()
   retu .F.
endif
lFEC := .F.
if MDG( "M늮 Fechado" )
   cFEC := MESANO()
   lFEC := .T.
endif
cARQ  := ESTQARQ( cTIPO, if( lFEC, 2, 0 ) )
cARQ2 := ESTQARQ( cTIPO, 1 )

FILTRO := ''
FILTRO := RFILORD( cARQ2, .F. )

if !CHECKIMP( 0 )
   retu .F.
endif
cAE := IMP( "AE" )
//cAE := IMP( "AE" )
//cAC := IMP( "AC" )
cAE := aCHR[2]
cAC := aCHR[1]


if !USEMULT( { { cARQ2, 1, 1 }, { cARQ, 1, 2 } } )
   retu .F.
endif

IMPRESSORA()
dbselectar( cARQ2 )
set filter to &FILTRO
dbgotop()
while !eof()
   CTLIN      := 80
   mCODIGO    := CODIGO
   mNOME      := NOME
   mAPLICACAO := ""
   nENT       := nSAI := nULT := 0
   if cTIPO $ "TCS"
      mAPLICACAO := APLICACAO
   endif
   dbselectar( cARQ )
   dbgotop()
   dbseek( alltrim( mCODIGO ) )
   while alltrim( mCODIGO ) = alltrim( CODIGO ) .and. !eof()
      if CTLIN > 50
         @  0,  0 say cAE + "Historico da Movimentacao"
         @  1,  0 say "M_BY4"
         @  1, 60 say time()
         @  1, 70 say ZDATA
         @  2,  0 say cAE + mCODIGO + " " + mNOME
         if !empty( mAPLICACAO )
            @  3, 00 say "Aplicacao: " + mAPLICACAO
         endif
         @  4,  0 say "Codigo"
         @  4, 25 say "Numero"
         @  4, 34 say "Data"
         @  4, 43 say "Rastro"
         @  4, 50 say "Anterior"
         @  4, 63 say "Entrada"
         @  4, 76 say "Saida"
         @  4, 89 say "Atual"
         @  5, 00 say repl( "-", 100 )
         CTLIN := 6
      endif
      @ CTLIN,  0 say Codigo
      @ CTLIN, 25 say Numero
      @ CTLIN, 34 say DATA
      @ CTLIN, 43 say Rastro
      @ CTLIN, 50 say ESTQXXX pict "9999999"
      if ESTQYYY > ESTQXXX
         @ CTLIN, 63 say QTDE pict "9999999"
         nENT += QTDE
      endif
      if ESTQYYY < ESTQXXX
         @ CTLIN, 76 say QTDE pict "9999999"
         nSAI += QTDE
      endif
      @ CTLIN, 89 say ESTQYYY pict "9999999"
      nULT := ESTQYYY
      CTLIN ++
      dbskip()
   enddo
   if nENT > 0 .or. nSAI > 0
      @ CTLIN,  0 say "Total"
      @ CTLIN, 63 say nENT    pict "9999999"
      @ CTLIN, 76 say nSAI    pict "9999999"
      @ CTLIN, 89 say nULT    pict "9999999"
   endif
   dbselectar( cARQ2 )
   dbskip()
enddo
VIDEO()
dbcloseall()
IMPEND()

*+ EOF: M_BY4.PRG
