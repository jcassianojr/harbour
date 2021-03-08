*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_4Q.PRG
*+
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн


//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

cBH := if( lSECBCO, "BK", "BH" ) + ANOMESW 

CHECKCRI( cBH, "BCOREQ", "REQUISI" )

PADRAO( cBH, cBH, "' '+STR(mREQUISI,8)+' '+STR(mNUMERO,8)+' '+DTOC(mDATA)+' '+STR(mHORAS,6,2)+' '+mTIPO+' '+IF(EMPTY(mIMP),' ','*')", "mREQUISI", ;
        "FOPTO_4Q - Requisicao de Horas", ;
        "Requisi  Numero   Data     Horas T", ;
        {|| PEGCHAVE("mREQUISI",ULTIMOREG(cBH,"REQUISI",.T.),"Requisao:")}, { || tFOPTO4Q() }, { || gFOPTO4Q() }, { || ALLTRUE() },, 2,,,zTIPVID  )

FOPTO4Q01()

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function FOPTO4Q01()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func FOPTO4Q01

if MDG( "Zerar Saldo da Competencia - Recomendado" )
   FOPTO4Q02( MES, ANOUSO )
endif
aRES  := {}
aFUN  := {}
nrMES := MES
nbMES := MES
nbANO := ANOUSO
nbMES --
if nbMES = 0
   nbMES := 12
   nbANO --
endif

MDS( "Calculando Creditos Debitos" )
while ! NETUSE(cBH) 
enddo
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","numero")
ordSetFocus("temp")
//zei_fort(nLASTREC,,,1)

dbgotop()
while !eof()
   @ 24, 60 say NUMERO         
   mNUMERO := NUMERO
   nCRE    := 0
   nDEB    := 0
   nDIACRE := 0
   nDIADEB := 0
   while mNUMERO = NUMERO .and. !eof()
      if TIPO = "D"
         nDEB    += HORAS
         nDIADEB += DIAS
      else
         nCRE    += HORAS
         nDIACRE += DIAS
      endif
      dbskip()
   enddo
   aadd( aFUN, mNUMERO )
   aadd( aRES, { mNUMERO, nCRE, nDEB, 0, .T., nDIACRE, nDIADEB, 0 } )
enddo
dbclosearea()

MDS( "Aguarde Lancando Saldo" )         //Nao Teve requisicao mas tem saldo
while !  NETUSE(if( lSECBCO, "BCOBAK", "BCOHRS" )) 
enddo
dbgotop()
while !eof()
   @ 24, 60 say NUMERO         
   nPOS := ascan( aFUN, NUMERO )
   if nPOS = 0
      aadd( aFUN, NUMERO )
      aadd( aRES, { NUMERO, 0, 0, 0, .F., 0, 0, 0 } )
   endif
   dbskip()
enddo
for W := 1 to len( aRES )
   @ 24, 40 say aRES[ W, 1 ]         
   eCHAVE := str( aRES[ W, 1 ], 8 ) + str( nbANO, 4 ) + str( nBMES, 2 )
   dbgotop()
   if dbseek( eCHAVE )                  //Saldo Anterior
      aRES[ W, 4 ] := SALDO
      aRES[ W, 8 ] := DIASAL
   endif
   eCHAVE := str( aRES[ W, 1 ], 8 ) + str( ANOUSO, 4 ) + str( nrMES, 2 )
   dbgotop()
   if !dbseek( eCHAVE )
      netrecapp()
      field->NUMERO := aRES[ W, 1 ]
      field->ANO    := ANOUSO
      field->MES    := nrMES
   else
      netreclock()
   endif
   field->CREDITO := aRES[ W, 2 ]
   field->DEBITO  := aRES[ W, 3 ]
   field->SALANT  := aRES[ W, 4 ]
   field->SALDO   := SALANT + CREDITO - DEBITO
   field->DIACRE  := aRES[ W, 6 ]
   field->DIADEB  := aRES[ W, 7 ]
   field->DIAANT  := aRES[ W, 8 ]
   field->DIASAL  := DIAANT + DIACRE - DIADEB
   dbunlock()
next W
dbclosearea()
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function FOPTO4Q02()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func FOPTO4Q02( nMES, nANO )            //Apagar Periodo Bco Horas

if valtype( nMES ) # "N" .or. valtype( nANO ) # "N"
   nMES := MES
   nANO := ANOUSO
   MDS( 'Confirme a Competecia' )
   @ 24, 40 get nMES         
   @ 24, 50 get nANO         
   if !READCUR()
      retu .F.
   endif
endif
while ! netuse(if( lSECBCO, "BCOBAK", "BCOHRS" )) 
enddo
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
DBEVAL({|| netrecdel()},{|| ANO=nANO.AND.MES=nMES}, {|| zei_fort(nLASTREC,,,1)})
dbclosearea()
NETPACK(if( lSECBCO, "BCOBAK", "BCOHRS"))


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function gFOPTO4Q()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func gFOPTO4Q

@  6,  2 say mREQUISI picture '99999999'         
@  6, 11 get mNUMERO  picture '99999999'         
@  6, 20 get mDATA                               
@  6, 29 get mHORAS   picture '999.99'           
@  6, 36 get mDIAS    picture '999.99'           
@  6, 45 get mTIPO    valid mTIPO $ "CD "        
@  8,  2 get mOBS                                
READCUR()
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function tFOPTO4Q()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func tFOPTO4Q

HB_dispbox( 4, 0, 23, 79, B_DOUBLE+" ")
@  5,  2 say "Requisi  Numero   Data     Horas  Dias  T  C-Credito"         
@  6, 50 say "D-Debito"                                                     
@  7,  2 say "Obs:"                                                         
retu .T.

*+ EOF: FOPTO_4Q.PRG
