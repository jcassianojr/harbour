*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_3H.PRG
*+
*+
*+    Reformatted by Click! 2.03 on Jun-25-2003 at  5:17 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

////#INCLUDE "COMANDO.CH"

if !MDL( 'FOPTO_3H - Passagens Funcionario/Hora por dia' )
   retu
endif
CTLIN := 80
cPA   := PARQDIO()

if ! NETUSE("FIRMA") 
   retu
endif
dbgotop()
dbseek( NREMP )


if ! NETUSE(PES) 
   dbcloseall()
   retu
endif
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES))'
FILTRO := FILTRO( FILTRO )
if !empty( FILTRO )
   set filter to &FILTRO
endif


//sele 3
if ! NETUSE(cPA) 
   dbcloseall()
   retu
endif
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
Ordcreate(,"temp","DATA")
ordSetFocus("temp")


IMPRESSORA()
dbselectar(cPA) //sele 3
dbgotop()
while !eof()
   REF := 0
   dbselectar( cPA )
   mDATA := DATA
   while mDATA = DATA .and. !eof()
      if CTLIN > 55
         dbselectar( "FIRMA" )
         @  0,  0 say repl( '=', 79 )
         @  1,  0 say "FOLHA DE PONTO - " + alltrim( RAZAO )
         @  1, 56 say "CGC:" + CGC
         @  2,  0 say "End: " + ENDERECO + " - " + BAIRRO + " - " + CIDADE + " - " + ESTADO
         @  3,  0 say "Funcionario"
         @  3, 50 say "Hora"
         @  4,  0 say repl( '-', 79 )
         CTLIN := 5
         dbselectar( cPA )
      endif
      mNUMERO := NUMERO
      mHORA   := HORA
      dbselectar( PES )
      dbgotop()
      dbseek( mNUMERO )
      if found()
         @ CTLIN,  0 say mNUMERO
         @ CTLIN, 10 say NOME
         @ CTLIN, 50 say mHORA
         CTLIN ++
         dbselectar( cPA )
         REF ++
      endif
      dbselectar( cPA )
      dbskip()
   enddo
   if REF > 0
      @ CTLIN,  0 say repl( '-', 79 )
      CTLIN ++
      @ CTLIN, 00 say "Total Dia:"
      @ CTLIN, 12 say mDATA
      @ CTLIN, 50 say str( REF )
      CTLIN ++
      @ CTLIN,  0 say repl( '=', 79 )
      CTLIN ++
   endif
enddo
if CTLIN # 80
   IMPFOL()
endif
dbcloseall()
IMPEND()
retu

*+ EOF: FOPTO_3H.PRG
