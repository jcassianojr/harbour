*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    FOPTO_49.PRG
*+
*+    Functions: Function gFOPTO49()
*+               Function iFOPTO49()
*+               Function tFOPTO49()
*+
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ


//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

PADRAO( "FOPTOEVE", "FOPTOEVE", "STR(mDIA,2)+' '+STR(mMES,2)+' '+mCODIGO+' '+mDESCRICAO", "STR(mDIA,2)+STR(mMES,2)", "FOPTO_49 - Feriados", "Dia M€s Codigo Descri‡„o", ;
        { || iFOPTO49() }, { || tFOPTO49() }, { || gFOPTO49() }, { || FO_RELL( "PONTOCAD02" ) },, 2 )
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function gFOPTO49()
*+
*+    Called from ( fopto_49.prg )   1 - function fopto_482()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
function gFOPTO49

// Get nas Menvars
@  9, 13 get mDIA       pict '99'                            
@ 10, 13 get mMES       pict '99'                            
@ 11, 13 get mCODIGO                                         
@ 12, 13 get mDESCRICAO                                      
@ 13, 13 get mBCOSN     pict "!"  valid mBCOSN $ "SN "       
@ 13, 51 get mREDSN     pict "!"  valid mREDSN $ "SN "       
@ 14, 13 get mFOLSN     pict "!"  valid mFOLSN $ "SNM "       
READCUR()
return .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function iFOPTO49()
*+
*+    Called from ( fopto_49.prg )   1 - function fopto_482()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
function iFOPTO49

MDS( "Digite a Data e o Mes :" )
@ 24, 50 get mDIA         
@ 24, 60 get mMES         
READCUR()
mCHAVE := str( mDIA, 2 ) + str( mMES, 2 )
return .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function tFOPTO49()
*+
*+    Called from ( fopto_49.prg )   1 - function fopto_482()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
function tFOPTO49
HB_DISPBOX( 4, 0,23,79,B_DOUBLE+" ")
@  9,  1 say "Dia" + spac( 7 ) + ":    Dia do M€s ou Dia da Semana Conforme Tabela Abaixo"         
@ 10,  1 say "Mes" + spac( 7 ) + ":    Deixe em Branco Para dia da Semana"                         
@ 11,  1 say "Codigo    :"                                                                         
@ 12,  1 say "Descricao :"                                                                         
@ 13,  1 say "Banco Hora:   (S)im (N)„o" + spac( 8 ) + "Reducao Jornada:    (S)im (N)ao"           
@ 14,  1 say "Folga     :   (S)im (N)„o"                                                           
@ 15, 13 say "1 - Domingo"                                                                         
@ 16, 13 say "2 - Segunda"                                                                         
@ 17, 13 say "3 - Ter‡a"                                                                           
@ 18, 13 say "4 - Quarta"                                                                          
@ 19, 13 say "5 - Quinta"                                                                          
@ 20, 13 say "6 - Sexta"                                                                           
@ 21, 13 say "7 - S bado"                                                                          
return .T.

*+ EOF: FOPTO_49.PRG
