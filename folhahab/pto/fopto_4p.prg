*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    FOPTO_4P.PRG
*+
*+    Functions: Function iFOPTO4P()
*+               Function tFOPTO4P()
*+               Function gFOPTO4P()
*+
*+    23/12/2022 incluindo hash
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн


#INCLUDE "INKEY.CH"
#INCLUDE "BOX.CH"

if ZUSER <> "SUPERVISOR".and. ZUSER <> "SOFTEC"            //So troca Senha
   ALERTX( "Acesso Permitido Somente Para o Supervisor" )
   retu .F.
endif

PADRAO( "MUSER", "MUSER", "' '+mUSUARIO+' '+mVALIDADE+' '+mEQUIVALE", "mUSUARIO", "FOPTO_4P - Cadastro de Usuarios", "Usuario    Validade Equivalencia", ;
        { || iFOPTO4P() }, { || tFOPTO4P() }, { || gFOPTO4P() },,, 2 )
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function iFOPTO4P()
*+
*+    Called from ( fopto_4p.prg )   1 - function gfopto4o()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function iFOPTO4P

mUSUARIO := space( 10 )
MDS( "Digite o Usuario" )
@ 24, 40 get mUSUARIO
READCUR()
mUSUARIO := XENCODE( mUSUARIO )
mCHAVE   := mUSUARIO
return .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function tFOPTO4P()
*+
*+    Called from ( fopto_4p.prg )   1 - function gfopto4o()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function tFOPTO4P

HB_dispbox( 2, 0, 23, 79,B_DOUBLE+" ")
@  3,  1 say "Usuario    Validade   Equivalencia"
@  5,  1 say "Senha" + spac( 6 ) + "Fonte Letra No Folha"
return .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function gFOPTO4P()
*+
*+    Called from ( fopto_4p.prg )   1 - function gfopto4o()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function gFOPTO4P

mUSUARIO  := padr( XDECODE( mUSUARIO ), 10 )
mEQUIVALE := padr( XDECODE( mEQUIVALE ), 10 )
mSENHA    := padr( XDECODE( mSENHA ), 8 )
mVALIDADE := XDECDAT( mVALIDADE )
// Get nas Menvars
@  4,  1 get mUSUARIO
@  4, 12 get mVALIDADE
@  4, 23 get mEQUIVALE
@  6,  1 get mSENHA    valid ALLTRUE(CheckPass(mSENHA,.t.)) // //remover alltrue apos complemento harbour,vo,vb,xsharp permitir minusculas numeros e acentos
@  6, 12 get mARQFON   PICT "9999999"
@  6, 20 get mFOLHANO PICT "9999999"
//@  8, 10 get mEMAIL_USU
//@  8, 33 get mEMAIL_SEN
//@  9, 10 get mEMAIL_CTA
//@ 10, 10 get mEMAIL_POR
//@ 10, 15 get mEMAIL_SER
READCUR()


//cria antes do encode
aVALOR:=ENCODEVAL(mUSUARIO)
mPOSTEL01:=aVALOR[1]
mPOSTEL02:=aVALOR[2]
mPOSTEL03:=aVALOR[3]
mPOSTEL04:=aVALOR[4]
mPOSTEL05:=aVALOR[5]
mPOSTEL06:=aVALOR[6]
mPOSTEL07:=aVALOR[7]
mPOSTEL08:=aVALOR[8]
mPOSTEL09:=aVALOR[9]
mPOSTEL10:=aVALOR[10]


ALERTX(DECODEVAL(aVALOR))

aVALOR:=ENCODEVAL(mSENHA)
mPOSTEL11:=aVALOR[1]
mPOSTEL12:=aVALOR[2]
mPOSTEL13:=aVALOR[3]
mPOSTEL14:=aVALOR[4]
mPOSTEL15:=aVALOR[5]
mPOSTEL16:=aVALOR[6]
mPOSTEL17:=aVALOR[7]
mPOSTEL18:=aVALOR[8]


ALERTX(DECODEVAL(aVALOR))



IF ! EMPTY(mUSUARIO ) .AND. ! EMPTY(mSENHA )
    mCHAVEH:=StrToHex(hb_SHA256(upper(ALLTRIM( mUSUARIO ))+alltrim( mSENHA ), .t. ))
  //  mSENHA :=""  //apagar apos complemento harbour,vo,vb,xsharp permitir minusculas numeros e acentos
ENDIF
mUSUARIO  := XENCODE( mUSUARIO )
mEQUIVALE := XENCODE( mEQUIVALE )
ALTD()
mSENHA    := XENCODE( mSENHA ,.F. )   //sem upper
mVALIDADE := XENCODE( strtran( dtoc( mVALIDADE ), '/', '' ) )
mCHAVE    := mUSUARIO

ALERT(DECODE(mSENHA))
return .T.


function CheckPass(Ctexto,lMES)
LOCAL nI,lMAIS,lMINUS,lDIG,lSYMBOL
lMAIS   := .F.
lMINUS  := .F.
lDIG    := .F.
lSYMBOL := .F.
IF VALTYPE(lMES)#"L"
    lMES:=.T.
ENDIF
IF lEN(aLLTRIM(cTEXTO))<8
   IF lMES
      ALERTX("Minimo 8 Caracteres")
   ENDIF
   RETURN .F.
ENDIF

FOR nI = 1 TO LEN(cTexto)
	IF SUBStr ( cTEXTO, nI, 1 ) $ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
       lMAIS :=.T.
    ENDIF
  	IF SUBStr ( cTEXTO, nI, 1 ) $ 'abcdefghijklmnopqrstuvwxyz'
       lMINUS :=.T.
    ENDIF
    IF SUBStr ( cTEXTO, nI, 1 ) $ '0123456789'
       lDIG :=.T.
    ENDIF
    IF SUBStr ( cTEXTO, nI, 1 ) $ '-+_!@#$%^&*., ?'
       lSYMBOL :=.T.
    ENDIF  
NEXT
IF lMAIS .AND. lMINUS .AND. lDIG .AND. lSYMBOL
   RETURN .T.
ELSE
  if ! lMAIS .AND. lMES
     alertx(" Sem uma maiuscula")
   ENDIF
   if ! lMinus  .AND. lMES
     alertx(" Sem uma minuscula")
   ENDIF 
    if ! lDIG  .AND. lMES
     alertx(" Sem um numero")
   ENDIF 
    if ! lSYMBOL  .AND. lMES
     alertx(" Sem um simbulo -+_!@#$%^&*., ?")
   ENDIF
ENDIF
RETURN .F.

/*
FUNCTION ENCODEVAL (in_string)
LOCAL counter , next_char , aCHAVE
aCHAVE := array( 10 )
afill( aCHAVE, 0 )
IF empty(in_string)
   return aCHAVE
endif
FOR counter = 1 TO LEN(in_string)
    next_char = SUBSTR(in_string, counter * -1, 1)
    nCHAR:= (ASC(next_char) + 30) * 2
    aCHAVE[counter]:=nchar
NEXT
RETURN aCHAVE

FUNCTION DECODEVAL(aVALOR)
LOCAL in_string,nVALOR,counter,nLEN
in_string:=""
nLEN :=len(aVALOR)
FOR counter = 1 to len(aVALOR)
    IF aVALOR[counter]>0
       nVALOR := aVALOR[nLEN-counter+1]
       nVALOR := nVALOR /2
       nVALOR := nVALOR - 30
       in_string = in_string  + CHR(nVALOR)
    ENDIF
NEXT
RETURN in_string
*/

*+ EOF: FOPTO_4P.PRG
