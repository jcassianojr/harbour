*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib13.prg
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


//  Processa o Metodo Ininterrupto
//  cARQ -> Nome do Arquivo
//  bCHA -> Bloco Para Chaves Especiais
//  bALT -> Bloco que chama a Fun‡„o de Altera‡„o
//  EX: de Chamada ("MC01",,"{||fMAC(2,-1)}) 2->Alterar -1 N„o Repergunta Chave
#INCLUDE "INKEY.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function METINT()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func METINT(cARQ,bCHA,bALT)


while .T.
   if valtype(bCHA) = "B"
      eval(bCHA)
   else
      PEGBUS(cARQ,1)
   endif
   if lastkey() = K_ESC
      exit
   endif
   if !VERSEHA(cARQ,mCHAVE)
      NOVOREG(cARQ,mCHAVE)
   endif
   eval(bALT)
enddo

