*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_3K.PRG
*+
*+    Functions: Function FOPTO3K()
*+
*+
*+    Reformatted by Click! 2.03 on Jun-25-2003 at  5:17 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

////#INCLUDE "COMANDO.CH"
function fopto_3k
para nTipo
cARQ:="XXXX"
IF nTIPO=1 //Atuais
   carq:=IF(lSECBCO,"BCOBAK","BCOHRS")
ENDIF
IF nTIPO=2 //Arquivados
   carq:=IF(lSECBCO,"BCODEK","BCODEM")
ENDIF


if !MDL( 'FOPTO_3K - Listagem Saldo Banco Horas' )
   retu
endif

cTIPLIS := "A"
cTIPREL := "D"
MDS( "(H)oras (D)ias (A)mbos" )
@ 24, 40 get cTIPLIS valid cTIPLIS $ "HDA" pict "!"
if !READCUR()
   retu .F.
endif

MDS( "(D)etalhado (S)aldos" )
@ 24, 40 get cTIPREL valid cTIPREL $ "DS" pict "!"
if !READCUR()
   retu .F.
endif

if ! NETUSE(pes) 
   dbcloseall()
   retu
endif
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
INX    := ""
FILORD(.T.)
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
if valtype(INX)="N"
   dbsetorder(INX)
ELSE
   ordDestroy("temp")
   ordcreate(,"temp",inx)
   ordSetFocus("temp")
ENDIF   
set filter to &FILTRO



if ! NETUSE(carQ ) //!AREDE(cARQ,cARQ,1 )
   dbcloseall()
   retu
endif
FILTRA := ''
FILTRA := FILTRO( FILTRA )
set filter to &FILTRA

nTOTHOR:=0
nTOTDIA:=0
CTLINOLD:=0
CTLIN := 80
LISTARUE( { | X | FOPTO3K( X ) } ,{|| FO3KTOT()})


retu

func FO3KTOT
CTLIN:=CTLINOLD
CTLIN++
@  CTLIN,  0 say repl( "-", if( cTIPREL = "S", 80, 132 ) )
CTLIN++
@ CTLIN,0 SAY "Total Geral"
if cTIPLIS = "A" .or. cTIPLIS = "H"
   @ CTLIN, 60 say nTOTHOR pict "@E 999999.99"
endif
if cTIPLIS = "A" .or. cTIPLIS = "D"
   @ CTLIN, 70 say nTOTDIA pict "@E 999999.99"
endif
RETU


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function FOPTO3K()
*+
*+    Called from ( fopto_3k.prg )   1 - function fopto3j()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func FOPTO3K

para COMPARE
DBSELECTAR(PES)
dbgotop()
while !eof()
   if &COMPARE
      mNUMERO := NUMERO
      mNOME   := NOME
      if CTLIN > 55
         @  0,  0 say if( cTIPREL = "D", IMPSTR( cIMPCOM ), "" ) + "Saldo Banco Horas/Dias"
         @  1,  0 say "Funcionario"
         @  1, 50 say "Mes"
         @  1, 54 say "Ano"
         if cTIPREL = "D"
            @  1, 60 say "Anterior"
            @  1, 70 say "Credito"
            @  1, 80 say "Debito"
            @  1, 90 say "Saldo"
         else
            @  1, 64 say "Horas"
            @  1, 74 say "Dias"
         endif
         @  2,  0 say NOMSETOR
         @  3,  0 say repl( "=", if( cTIPREL = "S", 80, 132 ) )
         CTLIN := 4
      endif
      nTOTFUNHOR:=0
      nTOTFUNDIA:=0 
      DBSELECTAR(cARQ)
      dbgotop()
      dbseek( str( mNUMERO, 8 ) )
      while mNUMERO = NUMERO .and. !eof()
         @ CTLIN,  0 say mNUMERO
         @ CTLIN,  9 say left( mNOME, 38 )
         @ CTLIN, 49 say MES
         @ CTLIN, 52 say ANO
         if ( cTIPLIS = "A" .or. cTIPLIS = "H" ) .and. cTIPREL = "D"
            @ CTLIN, 57 say "Hrs"
            @ CTLIN, 60 say SALANT  pict "@E 99,999.99"
            @ CTLIN, 70 say CREDITO pict "@E 99,999.99"
            @ CTLIN, 80 say DEBITO  pict "@E 99,999.99"
            @ CTLIN, 90 say SALDO   pict "@E 99,999.99"
            CTLIN ++
         endif
         if ( cTIPLIS = "A" .or. cTIPLIS = "D" ) .and. cTIPREL = "D"
            @ CTLIN, 57 say "Dia"
            @ CTLIN, 60 say DIAANT pict "@E 99,999.99"
            @ CTLIN, 70 say DIACRE pict "@E 99,999.99"
            @ CTLIN, 80 say DIADEB pict "@E 99,999.99"
            @ CTLIN, 90 say DIASAL pict "@E 99,999.99"
            CTLIN ++
         endif
         if cTIPREL = "S"
            if cTIPLIS = "A" .or. cTIPLIS = "H"
               @ CTLIN, 59 say SALDO pict "@E 999,999.99"
            endif
            if cTIPLIS = "A" .or. cTIPLIS = "D"
               @ CTLIN, 69 say DIASAL pict "@E 999,999.99"
            endif
            CTLIN ++
         endif
         nTOTFUNHOR:=SALDO  //pega o ultimo saldo
         nTOTFUNDIA:=DIASAL  //pega o ultimo saldo
         dbskip()
      enddo
      nTOTHOR+=nTOTFUNHOR
      nTOTDIA+=nTOTFUNDIA
   endif
   DBSELECTAR(PES)
   dbskip()
enddo
CTLINOLD:=CTLIN
CTLIN := 80

*+ EOF: FOPTO_3K.PRG
