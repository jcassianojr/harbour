*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    FOPTOP
*+
*+    Functions: CABE2()
*+               CABEX()
*+               CABEC()
*+               RODAP()
*+               CABE3()
*+               MDL()
*+               iNCIDE()
*+               GRAVA1()
*+               GRAVA()
*+               GRAVA2()
*+               PEGCX()
*+               **calc01()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function CABE2()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function CABE2( TITULO )                  
setcolor( "N/W" )
@ 02, 25 clea to 02, 80
@ 02, 25 say " н " + TITULO
setcolor( "W/N,N/W" )
@ 03, 00 clea
return  .T. 

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function CABEX()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function CABEX( cTITULO )
CABE2( cTITULO )


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function CABEC()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function CABEC( TITULO, TITULO2, nCOL, TITULO3, cSETOR )    

if valtype( nCOL ) # "N"
   nCOL := 50
endif
if valtype( TITULO2 ) # "C"
   TITULO2 := ""
endif
if valtype( TITULO3 ) # "C"
   TITULO3 := 'Funcionario'
endif
@  0,  0   say repl( "=", 80 )
@  1,  6   say alltrim( ZEMPRESA ) + " " + ACENTO( TITULO )
@  2,  0   say "Referencia: " + dtoc( DIAX ) + " Impressao: " + dtoc( date() ) + " - " + time() + "  Pag: " + str( pag, 4 )
@  3,  0   say repl( "=", 80 )
@  4,  0   say ACENTO( TITULO3 )
@  5, nCOL say ACENTO( TITULO2 )
if valtype( cSETOR ) = "C"
   @  6,  0 say cSETOR
   @  7,  0 say repl( "-", 80 )
else
   @  6,  0 say repl( "-", 80 )
endif
PAG ++
return  .T. 

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+     RODAP()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function RODAP     

@ prow() + 1, 0  say repl( "-", 80 )
@ prow() + 2, 40 say repl( "-", 35 )
@ prow() + 1, 45 say 'Assinatura do RH'
IMPFOL()
return .t.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function CABE3()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function CABE3( TITULO, QT )        

setcolor( "W/N,N/W" )
@ 02, 00 clea to 03, 79
@ 04, 00 clea
setcolor( "N/W" )
@ 02, 00 clea to 02, 79
@ 02, 00 say "  " + TITULO
setcolor( "+GR/BG" )
HB_DISPBOX( 3, 0,QT,79,B_DOUBLE+" ")
return  .T. 

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MDL()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function MDL( TITULO )  
CABE2( TITULO )
@ 19, 00 to 21, 79 DOUB
@ 20, 03 say 'LIGUE A IMPRESSORA !! ,Ajuste o papel'
return CHECKIMP( 0 )

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    INCIDE()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function INCIDE         
XA := FATOR
XB := TIPO
XC := TRIBUTINPS
XD := TRIBUTIRR
XE := TRIB_FGTS
XF := VALOR
return .t.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    GRAVA1()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function GRAVA1         
netreclock()
&FOL.->VALOR      := VALE
&FOL.->FATOR      := XA
&FOL.->TIPO       := XB
&FOL.->TRIBUTINPS := XC
&FOL.->TRIBUTIRR  := XD
&FOL.->TRIB_FGTS  := XE
&FOL.->VALORBASE  := XF
return .t.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    GRAVA()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function GRAVA          
&FOL.->NUMERO   := CTR
&FOL.->CONTA    := CTR1
&FOL.->CONTROLE := CTA
return .t.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function GRAVA2()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function GRAVA2       

para CTR1
sele 3
dbgotop()
if dbseek( CTR1 )
   INCIDE()
endif
CTA := ( CTR * 10000 ) + CTR1
sele 2
dbgotop()
if !dbseek( CTA )
   netrecapp()
   GRAVA()
endif
GRAVA1()
return  .T. 




*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function PEGCX()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function PEGCX( cTIPO )

local aCODCTA := array( 24 )
if valtype( cTIPO ) # "C"
   cTIPO := "C"
endif
afill( aCODCTA, 0 )
if ! netuse("FOPTOCON") 
   return aCODCTA
endif
if ! dbseek(nremp)
   dbgotop()
endif
do case
case cTIPO = "T"
   aCODCTA := { TR01, TR02, TR03, TR04, TR05, TR06, TR07, TR08, ;
                TR09, TR10, TR11, TR12, TR13, TR14, TR15, TR16, ;
                TR17, TR18, TR19, TR20, TR21, TR22, TR23, TR24 }
case cTIPO = "I"
   aCODCTA := { VI01, VI02, VI03, VI04, VI05, VI06, VI07, VI08, ;
                VI09, VI10, VI11, VI12, VI13, VI14, VI15, VI16, ;
                VI17, VI18, VI19, VI20, VI21, VI22, VI23, VI24 }
case cTIPO = "F"
   aCODCTA := { FS01, FS02, FS03, FS04, FS05, FS06, FS07, FS08, ;
                FS09, FS10, FS11, FS12, FS13, FS14, FS15, FS16, ; 
                FS17, FS18, FS19, FS20, FS21, FS22, FS23, FS24 }
otherwise
   aCODCTA := { CX01, CX02, CX03, CX04, CX05, CX06, CX07, CX08, ;
                CX09, CX10, CX11, CX12, CX13, CX14, CX15, CX16, ;
                CX17, CX18, CX19, CX20, CX21, CX22, CX23, CX24 }
endcase
dbcloseall()
return aCODCTA

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function AHOR()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function AHOR
para QTHOR
QT1 := int( QTHOR )
QT2 := QTHOR - QT1
do case
case QT2 < .25
   QT3 := 0
case QT2 >= .25 .and. QT2 < .75
   QT3 := .5
case QT2 >= .75
   QT3 := 1
endcase
return  QT1 + QT3 



*+func cacl01(nVAL,nFAT)
*+IF VALTYPE(nFAT)#"N"
*+   nFAT:=1
*+ENDIF
*+//if nVAL<0.01 faltas atrasos sao negativos
*+//   RETU 0
*+//ENDIF
*+retu IF(nVAL>nFAT,nFAT+((nVAL-nFAT)*1.5),nVAL)

*+ EOF: FOPTOP.PRG

*+­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­
*+
*+    Function pegcompete
*+
*+­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­
*+
function pegcompete(lFECHA)
if ! NETUSE("FOPTOCOM")
   return .F.
endif
dbgotop()
if ! dbseek(STR(ANOUSO,4)+STR(MESTRAB,2)+STR(NREMP,8))
   netrecapp()
   field->mes:=mestrab
   field->ano:=anouso
   field->empresa:=Nremp
   field->dataini:=date()
   field->datafim:=date()+30
else
   netreclock()
endif
IF VALTYPE(lFECHA)="L"
   IF lFECHA
      field->fechado:="S"
   ELSE
      field->fechado:="N"
   ENDIF   
ENDIF
IF EMPTY(MESEXT)
   FIELD->MESEXT:=LEFT(CMES(DATAINI),3)+"/"+STRZERO(YEAR(DATAINI),4)
ENDIF
MDS("Periodo")
IF FIELD->FECHADO="S"
   MDT("COMPETENCIA JA FECHADA")
   ZTIPVID:="V"
ELSE
   @ maxrow(),20 GET DATAINI
   @ maxrow(),30 GET DATAFIM VALID DATAFIM>=DATAINI
   @ maxrow(),40 GET MESEXT
   READCUR()
   dbunlock()
   ZTIPVID:="T"
ENDIF
ZDATAINI:=DATAINI
ZDATAFIM:=DATAFIM
ZFECHADO:=FECHADO
dbgotop()
while ! eof()
   if FIELD->FECHADO<>"S" .AND. (FIELD->ANO<ANOUSO .OR. (FIELD->ANO=ANOUSO .AND. FIELD->MES<(MESTRAB-2)))
      netreclock()
      netgrvcam("FECHADO","S")
      dbunlock()
   endif   
   dbskip()
enddo
dbcloseall()

cPD := "PD" + ANOMESW
cPP := "PP" + ANOMESW
cPA := "PA" + ANOMESW

//testa criacao relogio evitar erros
CHECKCRI( cPD, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
//testa criacao portaria evitar erros
CHECKCRI( cPP, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
//testa criacao refeitorio evitar erros
CHECKCRI( cPA, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )

return
