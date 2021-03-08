*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib12.prg
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


//  cTAB   ->Codigo da Tabela
//  cSUBTAB->Sub Codigo da Tabela
//  dDATA  ->Data da Tabela
//  mVAL   ->Nome da Variavel que Recebera o Valor Obtido
//  nVAL   ->Valor Para Convers„o
//  mCON   ->Nome da Variavel que Recebera o Valor Convertido
//  nCAS   ->Casas de Arredondamento
//  nROW, nCOL, cPIC  -> Posi‡„o para Exibir o Valor
//  nROW2,nCOL2,cPIC2 -> Posi‡„o para Exibir o Valor Convertido


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CONVTAB()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CONVTAB(cTAB,cSUBTAB,dDATA,mVAL,nVAL,mCON,nCAS,nROW,nCOL,cPIC,nROW2,nCOL2,cPIC2)


local nVALOBI := nVALCON := 0
if empty(cTAB) .or. empty(dDATA)
   retu .T.
endif
cTAB := padr(cTAB,12)
if valtype(cSUBTAB) # "C"
   cSUBTAB := space(12)
endif
nVALOBI := OBTER("MD02",cTAB+cSUBTAB+dtos(dDATA),"VALOR")
if !empty(nVALOBI)
   if valtype(mVAL) = "C"
      &mVAL. := nVALOBI
   endif
   if valtype(nVAL) = "N"
      if valtype(nCAS) # "N"
         nCAS := 2
      endif
      nVALCON := round(nVAL / nVALOBI,nCAS)
   endif
   if valtype(mCON) = "C"
      &mCON. := nVALCON
   endif
   if valtype(nROW) = "N" .and. valtype(nCOL) = "N"
      if valtype(cPIC) = "C"
         @ nROW,nCOL say nVALOBI pict cPIC        
      else
         @ nROW,nCOL say nVALOBI         
      endif
   endif
   if valtype(nROW2) = "N" .and. valtype(nCOL2) = "N" .and. !empty(nVALCON)
      if valtype(cPIC2) = "C"
         @ nROW2,nCOL2 say &mCON. pict cPIC2        
      else
         @ nROW2,nCOL2 say &mCON.         
      endif
   endif
endif
retu .T.

