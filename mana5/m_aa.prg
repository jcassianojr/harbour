*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_aa.prg
*+
*+
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2010, Jorge Cassiano
*+
*+
*+
*+    Documentado em 30-Ago-2011 as 10:55 am
*+
*+
*+
*+--------------------------------------------------------------------
*+


//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"

//Senhas de Acesso
sMAA001 := SENHAX("MAA001",,.F.)

//Telas de Trabalho
aMAAE01 := EDITPEG("MAA001")
aMAAT02 := TELAPEG("MAA002")
aMAAE02 := EDITPEG("MAA002")
aMAAT03 := TELAPEG("MAA003")
aMAAE03 := EDITPEG("MAA003")

PADRAO(0,1,0,"MA01","N£mero Cognome"+spac(6)+"Raz„o Social/Nome Completo",;
 "' '+STR(mNUMERO,  5)+' '+mCOGNOME+' '+SUBSTR(mNOME,1,40)+' '+mDDD+' '+mTELEFONE",;
 "MAA","MAA001",{|| gMAA()},;
 {|| PADCGC("MA01",ZIMA)})

//Get Nas Mvars


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gMAA()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func gMAA


setcolor(PAD002)
set key K_F11 to TECLAF11
TELA := 0
while .T.
   TELA += if(lastkey() = K_PGUP,- 1,1)
   TELA := if(lastkey() = K_ESC,0,TELA)
   TELA := if(lastkey() = K_CTRL_W,0,TELA)
   do case
      case TELA = 1
         MAATELA1()
      case TELA = 2
         TELASAY(aMAAT02)
         EDITSAY(aMAAE02)
      case TELA = 3
         TELASAY(aMAAT03)
         EDITSAY(aMAAE03)
      otherwise
         exit
   endcase
enddo
set key K_F11 to
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MAATELA1()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MAATELA1


TELASAY(aPADTEL)
EDITSAY(aMAAE01)
if INCLUI
   mENDERECO2 := mENDERECO
   mBAIRRO2   := mBAIRRO
   mCIDADE2   := mCIDADE
   mESTADO2   := mESTADO
   mCEP2      := mCEP
   mDDD2      := mDDD
   mTELEFONE2 := mTELEFONE
   mRAMAL2    := mRAMAL
   mCONTATO2  := mCONTATO
   mDDDFAX2   := mDDDFAX
   mTELEFAX2  := mTELEFAX
   mENDERECO3 := mENDERECO
   mBAIRRO3   := mBAIRRO
   mCIDADE3   := mCIDADE
   mESTADO3   := mESTADO
   mCEP3      := mCEP
   mDDD3      := mDDD
   mTELEFONE3 := mTELEFONE
   mRAMAL3    := mRAMAL
   mCONTATO3  := mCONTATO
   mDDDFAX3   := mDDDFAX
   mTELEFAX3  := mTELEFAX
   mCGC3      := mCGC
   mNOME3     := mNOME
   mDTCAD     := ZDATA
endif
retu .T.

