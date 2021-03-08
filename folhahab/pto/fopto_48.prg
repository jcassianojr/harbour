*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\CLIPPER\FOLHA\PTO\FOPTO_48.PRG
*+
*+    Functions: Function iFOPTO48()
*+               Function gFOPTO48()
*+               Function tFOPTO48()
*+               Function FOPTO_482()
*+
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн


//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"


mHORA2:=0

cPX := "PX" + ANOMESW 


CHECKCRI( cPX, "FO_PDES", "STR(NUMERO,8)+DTOS(DATA)+STR(CONTA,2)" )

PADRAO( cPX, cPX, "' '+STR(mNUMERO,8)+' '+DTOC(mDATA)+' '+STR(mCONTA,2)+' '+STR(mHORAS,6,2)+' '+mOBS", "STR(mNUMERO,8)+DTOS(mDATA)+STR(mCONTA,2)", ;
        "FOPTO_48 - Creditos Avulsos", ;
        "Numero   Data     CT Horas  Obs", ;
        { || iFOPTO48() }, { || tFOPTO48() }, { || gFOPTO48() }, { || ALLTRUE() },, 2,,,zTIPVID  )
return .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function iFOPTO48()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function iFOPTO48

MDS( "Digite o Numero e a data e Conta" )
@ 24, 40 get mNUMERO     valid ! empty(mNUMERO)    
@ 24, 50 get mDATA       valid ! empty(mDATA)
@ 24, 60 get mCONTA      PICT "99" valid ! empty(mCONTA)
READCUR()
mCHAVE := str( mNUMERO, 8 ) + dtos( mDATA ) + str( mCONTA,2 )
return .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function gFOPTO48()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function gFOPTO48

@  5,  1 say mNUMERO picture '99999999'
@  5, 10 say mDATA
@  5, 19 get mCONTA  picture '99' valid ! empty(mCONTA)      
@  5, 22 get mHORAS  picture '999.99' VALID g48A() 
@  5, 29 get mHORA2  picture '999.99' VALID g48B()
@  5, 36 get mOBS    VALID ! EMPTY(mOBS)
READCUR()
return .T.


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function g48A()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
function g48A()
if mHORA2=0
   mHORA2:=bhor(mHORAS) 
   @  5, 29 SAY mHORA2  picture '999.99' 
endif
return .t.

**+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function g48B()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
function g48B()
if mHORAS=0
   mHORAS:=Chor(mHORA2) 
   @  5, 22 SAY mHORAS  picture '999.99'    
endif
return .t.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function tFOPTO48()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function tFOPTO48
HB_dispbox( 3, 0, 23, 79, B_DOUBLE+" ")
@  4,  1 say "Numero   Data     CT Horas Cnv     Obs"
return .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function FOPTO_482()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function FOPTO_482

CABE2( "Lancamento Grupo Creditos Avulso" )
cPX := "PX" + ANOMESW 

CHECKCRI( cPX, "FO_PDES", "STR(NUMERO,8)+DTOS(DATA)+STR(CONTA,2)" )
CRIARVARS( cPX )
@ 23, 00
@ 24, 00
@ 24, 10 say "Data     CT Horas  Obs"
@ 24, 10 get mDATA
@ 24, 19 get mCONTA                   picture '99'    valid ! empty(mCONTA)
@ 24, 22 get mHORAS                   picture '999.99'  valid ! empty(mHORAS)
@ 24, 29 get mOBS                     valid ! empty(mOBS)
if !READCUR()
   return .F.
endif


if ! NETUSE(PES) 
   return
endif
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
FILTRO := FILTRO( FILTRO )
set filter to &FILTRO

if ! NETUSE(cPX) 
   dbcloseall()
   retu
endif
dbselectar(pes)
dbgotop()
while !eof()
   mNUMERO := NUMERO
   dbselectar(cPX)
   dbgotop()
   IF ! dbseek( str( mNUMERO, 8 ) + dtos( mDATA ) + str( mCONTA,2 ) )
      netrecapp()
   endif
   REPLVARS()
   dbselectar(pes)
   dbskip()
enddo
dbcloseall()
return .T.

*+ EOF: FOPTO_48.PRG
