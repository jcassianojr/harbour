*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib08.prg
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



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MPAGAR()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func MPAGAR(cCOND,nVALOR,dDATA,lGRAVA,dENTREGA)


local aRETU   := array(3,10)
local aDIA
local aPOR
local aCAI    := {}
local X
local cSEMANA
local cDATA
local nDATAS  := 0
local lCAI
if valtype(lGRAVA) # "L"
   lGRAVA := .F.
endif
for X := 1 to 10
   aRETU[ 1, X ] := ctod("  /  /  ")
   aRETU[ 2, X ] := 0.00
   aRETU[ 3, X ] := ""
next X
if empty(nVALOR)
   ALERTX("N„o h  valor para distribuir pagamentos")
   retu aRETU
endif
if empty(dDATA)
   ALERTX("N„o h  DATA para distribuir pagamentos")
   retu aRETU
endif
if !USEREDE("MJ01",1,1)
   retu aRETU
endif
dbgotop()
IF dbseek(cCOND)
   aDIA           := {DIA1,DIA2,DIA3,DIA4,DIA5,DIA6,DIA7,DIA8,DIA9,DIA10}
   aPOR           := {POR1,POR2,POR3,POR4,POR5,POR6,POR7,POR8,POR9,POR10}
   aRETU[ 3, 1 ]  := TPC01
   aRETU[ 3, 2 ]  := TPC02
   aRETU[ 3, 3 ]  := TPC03
   aRETU[ 3, 4 ]  := TPC04
   aRETU[ 3, 5 ]  := TPC05
   aRETU[ 3, 6 ]  := TPC06
   aRETU[ 3, 7 ]  := TPC07
   aRETU[ 3, 8 ]  := TPC08
   aRETU[ 3, 9 ]  := TPC09
   aRETU[ 3, 10 ] := TPC10
   if !empty(CAI1)
      aadd(aCAI,CAI1)
   endif
   if !empty(CAI2)
      aadd(aCAI,CAI2)
   endif
   if !empty(CAI3)
      aadd(aCAI,CAI3)
   endif
   if !empty(CAI4)
      aadd(aCAI,CAI4)
   endif
   cSEMANA := SEMANA
   cDATA   := DATA
else
   dbclosearea()
   ALERTX("Condi‡„o de Pagamento n„o Encontrada")
   retu aRETU
endif
dbclosearea()
if cDATA = "E" .AND. VALTYPE(dENTREGA) = "D"
   IF !EMPTY(dENTREGA)
      dDATA := dENTREGA - 1
   ENDIF
ENDIF
if cDATA = "S" .and. dow(dDATA) = 2   //Se ‚ Segunda e fora semana requer +1
   dDATA ++   //Ajusta case abaixo
endif   //Pois caindo na segunda n„o somava uma semana
do case
   case cDATA = "A"
      dDATA --  //Subtrai 1 dia para ajustar soma de datas
   case cDATA = "L"   //Emiss„o nao subtrair um nada pois precisa mais 1
   case cDATA = "D"   //Fora Dezena
      while day(dDATA) # 11 .and. day(dDATA) # 21 .and. day(dDATA) # 1
         dDATA ++
      enddo
      dDATA --  //Subtrai 1 dia para ajustar soma de datas
   case cDATA = "Q"   //Fora Quinzena
      while day(dDATA) # 16 .and. day(dDATA) # 1
         dDATA ++
      enddo
      dDATA --  //Subtrai 1 dia para ajustar soma de datas
   case cDATA = "M"   //Fora Mˆs
      while day(dDATA) # 1
         dDATA ++
      enddo
      dDATA --  //Subtrai 1 dia para ajustar soma de datas
   case cDATA = "U"   //Dias Uteis
      while dow(dDATA) = 7 .or. dow(dDATA) = 1
         dDATA ++
      enddo
      dDATA --  //Subtrai 1 dia para ajustar soma de datas
   case cDATA = "S"   //Fora Semana
      while dow(dDATA) # 2
         dDATA ++
      enddo
      dDATA --  //Subtrai 1 dia para ajustar soma de datas
endcase

for X := 1 to 10
   if !empty(aDIA[X])
      nDATAS ++
   endif
next X
if empty(aPOR[1])
   mPER := 100 / nDATAS
   for X := 1 to 10
      if !empty(aDIA[X])
         aPOR[ X ] := mPER
      endif
   next X
endif
for X := 1 to 10
   if !empty(aDIA[X]) .and. !empty(aPOR[X])
      aRETU[ 1, X ] := dDATA+aDIA[X]
      aRETU[ 2, X ] := round(nVALOR * aPOR[X] / 100,2)
   endif
next X
//Corrige Nao Preenchimento 1§Data
IF EMPTY(aRETU[1,1])
   aRETU[ 1, 1 ] := dDATA
ENDIF
//Corrige Nao Preenchimento 1§%
IF EMPTY(aRETU[2,1])
   aRETU[ 2, 1 ] := nVALOR
ENDIF
//Exclui Final de Semana
for X := 1 to 10
   if dow(aRETU[1,X]) # 0
      do case
         case cSEMANA = 9   //Segunda/Terca/Quarta 2/3/4
            while dow(aRETU[1,X]) < 2 .or. dow(aRETU[1,X]) > 4
               aRETU[1,X] ++
            enddo
         case cSEMANA = 8   //Dias Uteils
            if dow(aRETU[1,X]) = 7
               aRETU[1,X] += 2
            endif
            if dow(aRETU[1,X]) = 1
               aRETU[1,X] ++
            endif
         case cSEMANA = 7   //Sabado
            while dow(aRETU[1,X]) # 7
               aRETU[1,X] ++
            enddo
         case cSEMANA = 6   //Sexta
            while dow(aRETU[1,X]) # 6
               aRETU[1,X] ++
            enddo
         case cSEMANA = 5   //Quinta
            while dow(aRETU[1,X]) # 5
               aRETU[1,X] ++
            enddo
         case cSEMANA = 4   //Quarta
            while dow(aRETU[1,X]) # 4
               aRETU[1,X] ++
            enddo
         case cSEMANA = 3   //Terca
            while dow(aRETU[1,X]) # 3
               aRETU[1,X] ++
            enddo
         case cSEMANA = 2   //Segunda
            while dow(aRETU[1,X]) # 2
               aRETU[1,X] ++
            enddo
         case cSEMANA = 1   //Domingo
            while dow(aRETU[1,X]) # 1
               aRETU[1,X] ++
            enddo
      endcase
   endif
next X
if len(aCAI) > 0
   for X := 1 to 10
      if dow(aRETU[1,X]) # 0
         while .T.
            lCAI := .F.
            for Y := 1 to len(aCAI)
               IF aCAI[Y] = 99  //Ultimo Dia do Mes
                  if day(aRETU[1,X]) = 1  //1§ Dia Mes Seguinte
                     aRETU[1,X] --  //Tira um Para ultimo mes anterior
                     lCAI := .T.
                  endif
               ELSE
                  if day(aRETU[1,X]) = aCAI[Y]
                     lCAI := .T.
                  endif
               ENDIF
            next Y
            if lCAI
               exit
            else
               aRETU[1,X] ++
            endif
         enddo
      endif
   next X
endif
if lGRAVA
   mDAT01 := aRETU[1,1]
   mDAT02 := aRETU[1,2]
   mDAT03 := aRETU[1,3]
   mDAT04 := aRETU[1,4]
   mDAT05 := aRETU[1,5]
   mDAT06 := aRETU[1,6]
   mDAT07 := aRETU[1,7]
   mDAT08 := aRETU[1,8]
   mDAT09 := aRETU[1,9]
   mDAT10 := aRETU[1,10]

   mVAL01 := aRETU[2,1]
   mVAL02 := aRETU[2,2]
   mVAL03 := aRETU[2,3]
   mVAL04 := aRETU[2,4]
   mVAL05 := aRETU[2,5]
   mVAL06 := aRETU[2,6]
   mVAL07 := aRETU[2,7]
   mVAL08 := aRETU[2,8]
   mVAL09 := aRETU[2,9]
   mVAL10 := aRETU[2,10]

   mTPC01 := aRETU[3,1]
   mTPC02 := aRETU[3,2]
   mTPC03 := aRETU[3,3]
   mTPC04 := aRETU[3,4]
   mTPC05 := aRETU[3,5]
   mTPC06 := aRETU[3,6]
   mTPC07 := aRETU[3,7]
   mTPC08 := aRETU[3,8]
   mTPC09 := aRETU[3,9]
   mTPC10 := aRETU[3,10]

endif
retu aRETU

