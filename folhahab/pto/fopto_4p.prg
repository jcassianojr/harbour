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
@  3,  1 say "Usuario    Validade Equivalencia"
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
@  4, 21 get mEQUIVALE
@  6,  1 get mSENHA
@  6, 12 get mARQFON   PICT "9999999"
@  6, 20 get mFOLHANO PICT "9999999"
@  8, 10 get mEMAIL_USU
@  8, 33 get mEMAIL_SEN
@  9, 10 get mEMAIL_CTA
@ 10, 10 get mEMAIL_POR
@ 10, 15 get mEMAIL_SER
READCUR()
//cria antes do encode
IF ! EMPTY(mUSUARIO ) .AND ! EMPTY(mSENHA )
    mCHAVEH:=StrToHex(hb_SHA256(upper(ALLTRIM( mUSUARIO ))+upper(alltrim( mSENHA )), .t. ))
ENDIF
mUSUARIO  := XENCODE( mUSUARIO )
mEQUIVALE := XENCODE( mEQUIVALE )
mSENHA    := XENCODE( mSENHA )
mVALIDADE := XENCODE( strtran( dtoc( mVALIDADE ), '/', '' ) )
mCHAVE    := mUSUARIO
return .T.

*+ EOF: FOPTO_4P.PRG
