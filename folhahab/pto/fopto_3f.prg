*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    FOPTO_3F
*+
*+    Functions: FOPTO3F()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

////#INCLUDE "COMANDO.CH"

if !MDL( 'FOPTO_3F - Listagem Totais' )    
   retu
endif
 
PAG  := 1
DIAX := date()
aTOT := array( 24 )
afill( aTOT, 0 )

cTIP:="C"
cSIN:="S"
cFUN:="S"
@ 15,00 SAY  "(C)ompetencia (A)anual (S)emanal"
@ 16,00 SAY  "Sintetico   (S/N)"
@ 17,00 SAY  "Funcionario (S/N)"
@ 15,40 GET cTIP PICT "!" VALID c $ "CAS"
@ 15,40 GET cSIN PICT "!" VALID c $ "SN"
@ 15,40 GET cFUN PICT "!" VALID c $ "SN"
IF ! READCUR()
   RETU .F.
ENDIF

lSINT := cSIN="S"
lFUNC := cFUN="S"

cPT  := "PT" + ANOMESW
if cTIP="A"
   cPT := "FO_PTT"
endif
IF cTIP="S"
   cPT := cPT:="PS"+ANOMESW 
ENDIF

priv mMES
priv mANO
mMES := MESTRAB
mANO := ANOUSO

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


if ! NETUSE(cPT) 
   dbcloseall()
   retu
endif

LISTARUE( { | X | FOPTO3F( X ) } )

retu

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function FOPTO3F()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func FOPTO3F

para COMPARE
dbselectar( PES )
dbgotop()
while !eof()
   if &COMPARE
      VIDEO()
      PETELA( 6 )
      mNUMERO := NUMERO
      mNOME   := NOME
      dbselectar( cPT )
      dbgotop()
      if cTIP="C" 
         dbseek( mNUMERO )
      else
         dbseek( str( mNUMERO, 8 ) )
      endif
      while mNUMERO = NUMERO .and. !eof()
         aCTA := { CTA01, CTA02, CTA03, CTA04, CTA05, CTA06, CTA07, CTA08, ;
                   CTA09, CTA10, CTA11, CTA12, CTA13, CTA14, CTA15, CTA16, ;
                   CTA17, CTA18, CTA19, CTA20, CTA21, CTA22, CTA23, CTA24 }
         COL := 25
         if lFUNC
            IMPRESSORA()
            if prow() > 50 .or. PAG = 1
               CABEC( 'Relacao Totais',,,, NOMSETOR )
               @ prow() + 1, 0 say IMPSTR( cIMPCOM )
               for X := 1 to 16
                  @ prow(), 21 + X * 7 say strzero( X, 3 )
               next X
            endif
            if cTIP="C"
               @ prow() + 1, 0 say IMPSTR( cIMPCOM )
               @ prow(), 0     say str( mNUMERO, 8 ) + '-' + left( mNOME, 15 )
            else
               @ prow() + 1, 0 say IMPSTR( cIMPCOM )
               @ prow(), 0     say str( mNUMERO, 8 )
               IF cTIP="A"
                  @ prow(), 9     say str( MES )
                  @ prow(), 12    say str( ANO )
               ELSE
                  @ prow(), 9     say SEMINI
                  @ prow(), 12    say SEMFIM
               ENDIF   
            endif
            for X := 1 to 16
               if !empty( aCTA[ X ] )
                  @ prow(), 18 + ( X * 7 ) say aCTA[ X ] pict '###.##'
               endif
            next X
         endif
         for X := 1 to 16
            if !empty( aCTA[ X ] )
               aTOT[ X ] += aCTA[ X ]
            endif
         next X
         dbselectar( cpt )
         dbskip()
      enddo
   endif
   dbselectar( PES )
   dbskip()
enddo

if lSINT
   IMPRESSORA()
   if PAG > 1
      @ prow() + 2, 0 say repl( '=', 132 )
   else
      CABEC( 'Relacao Totais',,, "", NOMSETOR )
      @ prow() + 1, 0 say IMPSTR( cIMPCOM )
      @ prow() + 1, 0 say repl( '-', 132 )
   endif
   @ prow() + 1, 0 say "Totais"
   for X := 1 to 8
      @ prow(), 16 + X * 12 say strzero( X, 3 )
   next X
   @ prow() + 1, 0 say ""
   for X := 1 to 8
      if !empty( aTOT[ X ] )
         @ prow(), 08 + X * 12 say aTOT[ X ] pict '@E 9999,999.99'
      endif
   next X
   @ prow() + 1, 0 say repl( ".", 132 )
   @ prow() + 1, 0 say ""
   for X := 9 to 16
      @ prow(), 16 + ( ( X - 8 ) * 12 ) say strzero( X, 3 )
   next X
   @ prow() + 1, 0 say ""
   for X := 9 to 16
      if !empty( aTOT[ X ] )
         @ prow(), 08 + ( ( X - 8 ) * 12 ) say aTOT[ X ] pict '@E 9999,999.99'
      endif
   next X
endif
if PAG > 1
   IMPFOL()
endif

*+ EOF: FOPTO_3F.PRG
