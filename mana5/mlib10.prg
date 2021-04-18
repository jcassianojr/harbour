*+--------------------------------------------------------------------
*+
*+    Programa  : mlib10.prg
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2010, Jorge Cassiano
*+
*+    Documentado em 30-Ago-2011 as 10:55 am
*+
*+--------------------------------------------------------------------
*+


#INCLUDE "INKEY.CH"


*+--------------------------------------------------------------------
*+
*+    Function VERUF()
*+
*+--------------------------------------------------------------------
*+
*+
function VERUF(eCEP,eUF,eCID)

LOCAL X
LOCAL lCONT := .T.
LOCAL cCEP
if &eUF. = "XX"  .OR.  &eUF. = "EX" .or. &eUF. = "??" //Nao Checa Exterior
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
*+    Function VERDDD()
*+
*+--------------------------------------------------------------------
*+
*+
function VERDDD(cVAR)
if empty(ZDDD)
   retu .T.
endif
&cVAR. := ZDDD
return .F.

*+--------------------------------------------------------------------
*+
*+    Function VERCEP()
*+
*+--------------------------------------------------------------------
*+
function VERCEP(cVAR)
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
return .T.


*+--------------------------------------------------------------------
*+
*+    Function VERKM()
*+
*+--------------------------------------------------------------------
*+
function VERKM(cVAR)
if empty(ZKM)
   retu .T.
endif
&cVAR. := ZKM
return .F.


*+--------------------------------------------------------------------
*+
*+    Function CHECK5CEP(cCEP,eRUA,eBAI,eTIP,lMES)
*+
*+--------------------------------------------------------------------
*+
function CHECK5CEP(cCEP,eRUA,eBAI,eTIP,lMES)

local cCEP8  := TIRAOUT(cCEP) //left(cCEP,5)+right(cCEP,3) 12345-123 OU 1234578
local nCHVBA
IF VALTYPE(lMES)<>"L"
    lMES:=.T.
ENDIF

if empty(ZRUA) .AND. lMES //nao tem ceps por rua
   VERSEHA("MD11",left(cCEP,5),,"'Verifique 5 digitos cep'",.T.)
else
   if VERSEHA(ZRUA,cCEP8,"ALLTRIM(TIPO)+' '+ALLTRIM(RUA)","'Cep da Rua nao Cadastrado '+ZRUA",lMES,2) //,.T.,2)
      if valtype(eRUA) = "C" .AND. ! EMPTY(eRUA)
         if empty(&eRUA)
            if valtype(eTIP) = "C"  .AND. ! EMPTY(eTIP) .and. empty(&eTIP)
               &eRUA := padr(OBTER(ZRUA,cCEP8,"ALLTRIM(RUA)",2),40)
               &eTIP := padr(OBTER(ZRUA,cCEP8,"ALLTRIM(TIPO)",2),40)
            else
               &eRUA := padr(OBTER(ZRUA,cCEP8,"ALLTRIM(TIPO)+' '+ALLTRIM(RUA)",2),40)
            endif
         endif
      endif
      if valtype(eTIP) = "C" .AND. ! EMPTY(eTIP)
        IF empty(&eTIP)
           &eTIP := padr(OBTER(ZRUA,cCEP8,"ALLTRIM(TIPO)",2),40)
         ENDIF  
      ENDIF
      if valtype(eBAI) = "C" .AND. ! EMPTY(eBAI)
         if empty(&eBAI)
            nCHVBA := OBTER(ZRUA,cCEP8,"CHVBAI",2)
            &eBAI := padr(OBTER("CEPBAI",nCHVBA,"BAI_NO"),30)
         endif
      endif
   endif
endif
if ! empty(ZCEPFIM)  .AND. lMES
   cCEP := left(cCEP,5)
   if cCEP < left(ZCEP,5) .or. cCEP > left(ZCEPFIM,5)
      ALERTX("Fora da Faixa Ceps da Cidade de "+ZCEP+" a "+ZCEPFIM)
   endif
endif
return .T.

