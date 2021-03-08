*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib10.prg
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


#INCLUDE "INKEY.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function VERUF()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func VERUF(eCEP,eUF,eCID)

LOCAL X
LOCAL lCONT := .T.
LOCAL cCEP
if &eUF. = "XX"   //Nao Checa Exterior
   ZRUA    := ""
   ZDDD    := ""
   ZCEP    := ""
   ZCEPFIM := ""
   ZKM     := 0
   ZRUA    := ""
   RETU .T.
ENDIF
if empty(left(&eCEP.,5))
   priv GETLIST := {}
   MDS("Digite o Cep")
   @ 24,40 get &eCEP picture "99999-999"        
   read
endif
if !empty(&eCEP.) .and. (empty(&eUF) .or. empty(&eCID))
   if USEREDE("MD10",1,2)
      lCONT := .T.
      X     := 5
      WHILE lCONT
         cCEP := left(&eCEP.,X)
         dbgotop()
         if dbseek(cCEP)
            if cCEP >= LEFT(INICEP,X) .and. cCEP <= LEFT(FIMCEP,X)
               &eUF  := UF
               &eCID := NOME
               lCONT := .F.
            endif
         else
            dbskip(- 1)
            if cCEP >= LEFT(INICEP,X) .and. cCEP <= LEFT(FIMCEP,X)
               &eUF  := UF
               &eCID := NOME
               lCONT := .F.
            endif
         endif
         X --
         IF x = 0
            lCONT := .F.
         ENDIF
      ENDDO
      dbclosearea()
   ENDIF
ENDIF
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function VERDDD()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func VERDDD(cVAR)


if empty(ZDDD)
   retu .T.
endif
&cVAR. := ZDDD
retu .F.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function VERCEP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func VERCEP(cVAR)


local cCEP
cCEP := &cVAR.
if !empty(ZCEP) .and. empty(ZCEPFIM)
   cCEP := ZCEP+right(cCEP,3)
endif
cCEP  := strtran(cCEP," ","0")
cCEP  := strtran(cCEP,"-","")
cCEP  := strzero(val(cCEP),8)
cCEP  := left(cCEP,5)+"-"+right(cCEP,3)
&cVAR := cCEP
if !empty(ZCEP) .and. empty(ZCEPFIM)
   keyboard repl(chr(K_RIGHT),5)
endif
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function VERKM()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func VERKM(cVAR)


if empty(ZKM)
   retu .T.
endif
&cVAR. := ZKM
retu .F.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CHECK5CEP()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func CHECK5CEP(cCEP,eRUA,eBAI,eTIP)

local cCEP8  := left(cCEP,5)+right(cCEP,3)
local nCHVBA
if empty(ZRUA)  //nao tem ceps por rua
   VERSEHA("MD11",left(cCEP,5),,"'Verifique 5 digitos cep'",.T.)
else
   //   if VERSEHA( ZRUA, cCEP8, "ALLTRIM(TIPO)+' '+ALLTRIM(TITULO)+' '+ALLTRIM(RUA)+' '+ALLTRIM(BAI)", "'Cep da Rua n„o Cadastrado '+ZRUA", .T., 2 )
   if VERSEHA(ZRUA,cCEP8,"ALLTRIM(TIPO)+' '+ALLTRIM(RUA)","'Cep da Rua n„o Cadastrado '+ZRUA",.T.,2)
      if valtype(eRUA) = "C"
         if empty(&eRUA)
            if valtype(eTIP) = "C" .and. empty(&eTIP)
               //               &eRUA := padr( OBTER( ZRUA, cCEP8, "ALLTRIM(TITULO)+' '+ALLTRIM(RUA)", 2 ), 40 )
               &eRUA := padr(OBTER(ZRUA,cCEP8,"ALLTRIM(RUA)",2),40)
               &eTIP := padr(OBTER(ZRUA,cCEP8,"ALLTRIM(TIPO)",2),40)
            else
               //               &eRUA := padr( OBTER( ZRUA, cCEP8, "ALLTRIM(TIPO)+' '+ALLTRIM(TITULO)+' '+ALLTRIM(RUA)", 2 ), 40 )
               &eRUA := padr(OBTER(ZRUA,cCEP8,"ALLTRIM(TIPO)+' '+ALLTRIM(RUA)",2),40)
            endif
         endif
      endif
      if valtype(eBAI) = "C"
         if empty(&eBAI)
            nCHVBA := OBTER(ZRUA,cCEP8,"CHVBAI",2)
            //            &eBAI := padr( OBTER("CEPBAI",nCHVBA, "BAI_NO_ABR"), 30 )
            &eBAI := padr(OBTER("CEPBAI",nCHVBA,"BAI_NO"),30)
         endif
      endif
   endif
endif
if !empty(ZCEPFIM)
   cCEP := left(cCEP,5)
   if cCEP < left(ZCEP,5) .or. cCEP > left(ZCEPFIM,5)
      ALERTX("Fora da Faixa Ceps da Cidade de "+ZCEP+" a "+ZCEPFIM)
   endif
endif
retu .T.

