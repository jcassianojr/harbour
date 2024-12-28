*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_4s.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 27-Dez-2024 as  9:33 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+


//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"

cBH := if(lSECBCO,"BK","BH")+ANOMESW  //ANOWORK + strzero( MES, 2 )
CHECKCRI(cBH,"BCOREQ","REQUISI")
cPT := "PT"+ANOMESW   //ANOWORK + strzero( MES, 2 )

nbMES := MES
nbANO := ANOUSO
cDATA := "01/"+strzero(nbmes,2)+"/"+strzero(nbano,4)
cREFD := strzero(nbano,4)+strzero(nbmes,2)

//sele 2
if !NETUSE(cBH)   //AREDE( cBH, cBH, 0 )                //pack
   dbcloseall()
   retu
endif
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
DBEVAL({|| netrecdel()},{|| IMP = cREFD},{|| zei_fort(nLASTREC,,,1)})
dbclosearea()
netpACK(cBH)

//sele 1
if !NETUSE(cPT)   //AREDE( cPT, cPT, 1 )
   dbcloseall()
   retu
endif
//sele 2
if !NETUSE(cBH)   //AREDE( cBH, cBH, 1 )
   dbcloseall()
   retu
endif
dbselectar(cBH)
dbgobottom()
nREQUISI := REQUISI
dbselectar(cPT)
dbgotop()
while !eof()
   mNUMERO := NUMERO
   mHORAS  := BCOHRS
   if mHORAS # 0
      nREQUISI ++
      dbselectar(cBH)
      netrecapp()
      field->REQUISI := nREQUISI
      field->NUMERO  := mNUMERO
      field->DATA    := ctod(cDATA)
      field->IMP     := cREFD
      field->TIPO    := if(mHORAS > 0,"C","D")
      field->HORAS   := abs(mHORAS)
   endif
   dbselectar(cPT)
   dbskip()
enddo
dbcloseall()
FOPTO4Q01()   //Ajusta Saldos


*+ EOF: fopto_4s.prg
*+
