// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_4s.prg
// +
// +
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +
// +
// +
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


// Teclas Operacionais
#include "INKEY.CH"
// //#INCLUDE "COMANDO.CH"

cBH := if( lSECBCO, "BK", "BH" ) + ANOMESW  // ANOWORK + strzero( MES, 2 )
CHECKCRI( cBH, "BCOREQ", "REQUISI" )
cPT := "PT" + ANOMESW   // ANOWORK + strzero( MES, 2 )

nbMES := MES
nbANO := ANOUSO
cDATA := "01/" + StrZero( nbmes, 2 ) + "/" + StrZero( nbano, 4 )
cREFD := StrZero( nbano, 4 ) + StrZero( nbmes, 2 )

// sele 2
IF !NETUSE( cBH )   // AREDE( cBH, cBH, 0 )                //pack
dbCloseAll()
RETU
ENDIF
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| IMP = cREFD }, {|| zei_fort( nLASTREC,,, 1 ) } )
dbCloseArea()
netpACK( cBH )

// sele 1
IF !NETUSE( cPT )   // AREDE( cPT, cPT, 1 )
dbCloseAll()
RETU
ENDIF
// sele 2
IF !NETUSE( cBH )   // AREDE( cBH, cBH, 1 )
dbCloseAll()
RETU
ENDIF
dbSelectAr( cBH )
dbGoBottom()
nREQUISI := REQUISI
dbSelectAr( cPT )
dbGoTop()
WHILE !Eof()
mNUMERO := NUMERO
mHORAS  := BCOHRS
IF mHORAS # 0
nREQUISI++
dbSelectAr( cBH )
netrecapp()
field->REQUISI := nREQUISI
field->NUMERO  := mNUMERO
field->DATA    := CToD( cDATA )
field->IMP     := cREFD
field->TIPO    := if( mHORAS > 0, "C", "D" )
field->HORAS   := Abs( mHORAS )
ENDIF
dbSelectAr( cPT )
dbSkip()
ENDDO
dbCloseAll()
FOPTO4Q01()   // Ajusta Saldos


// + EOF: fopto_4s.prg
// +
