*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : manemp.prg Cadastro de Empresas
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



PADRAO(0,1,0,"MANEMP","No.   Nome da Empresa"+spac(26)+"DDD   Telefone",;
 "' '+STR(mNUMERO,  5)+' '+mNOME+' '+mDDD+' '+mTELEFONE","MAZ",,{|| gMAZ()})


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gMAZ()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC gMAZ

EDITSAY("MAZ001")
TELASAY("MAZ002")
EDITSAY("MAZ002")
TELASAY("MAZ003")
EDITSAY("MAZ003")
ZREDUZ   := mREDUZIDO
ZPOSI    := mPOSI
ZLANC    := mLANC
ZBATE    := mBATE
ZNIV     := {mNIVEL1,mNIVEL2,mNIVEL3,mNIVEL4,mNIVEL5,mNIVEL6,mNIVEL7,mNIVEL8,mNIVEL9}
ZEMPRESA := mNOME
IF ZNIV[1] = 0
   ZPICCC := "XXXXXXXXXXX"
   ZTAMCC := 11
ELSE
   ZPICCC := "@R "
   FOR X := 1 TO 9
      IF ZNIV[X] > 0
         IF X # 1
            ZPICCC += "."
         ENDIF
         ZPICCC += REPL("9",ZNIV[X])
      ENDIF
   NEXT X
   ZTAMCC := LEN(ZPICCC) - 3
ENDIF
RETU .T.


