*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\OBJ\DISK70.PRG
*+
*+    Functions: Function GravaCampo()
*+               Function GravaERRO()
*+               Function CLRVARS()
*+               Function EQUVARS()
*+               Function FREEVARS()
*+               Function INITVARS()
*+               Function REPLVARS()
*+               Function MAKEVAR()
*+               Function MAKE_EMPTY()
*+
*+    Reformatted by Click! 2.03 on Sep-13-2004 at  9:55 am
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн


//  GravaCampo Funcaao Replace otimizada
//  aCAMPO (Matriz ou Variavel) //Requer Haspas sofrer  Macro
//  aVAR   (Matriz ou Variavel) //Requer Haspas sofrer  Macro
//  cUSO   (Mensagem Auxiliar caso Haja Erro
//  Somente grava se o tipo do campo do arquivo for igual ao da varivel
//  Nao Grava se o campo do arquivo nao existir
//  Caso o campo seja caracter e a variavel nao faz as conversoes e grava
//  Caso o campo seja MEMO  e a variavel nao faz as conversoes e grava
//  Caso o campo seja numerico corta os dados caso o tamanho da varivel
//       seja maior que o campo e grava
//  Exibe uma mensagem do erro no video
//  Grava no erro.txt o ocorrido
//  Bye Bye Type Mismatch
//  Bye Bye Data Width

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+
*+    Function GravaCampo(aCAMPO, aVAR, cUSO, lLOCK, lMES, lMACRO ,lLOG)
*+
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+
function GravaCampo( aCAMPO, aVAR, cUSO, lLOCK, lMES, lMACRO ,lLOG)

local cERRO
local nHANDLE
local cTIPOV
local cTIPOC
local XCAMPO
local XPOS
local XPOSDBF
local aSTRU
local nLEN
local nDEC
local nERRO   := 0
local eTMP
local eUSO
local eVAR
local eCAMPO


if valtype( lLOG) # "L"
   lLOG := .F.
endif
if valtype( lLOCK ) # "L"
   lLOCK := .T.
endif
if valtype( lMES ) # "L"
   lMES := .T.
endif
if valtype( lMACRO ) # "L"
   lMACRO := .T.
endif
IF lLOG
   nHANLOG:=FCREATE("GRAVACAM.TXT")
ENDIF
if lLOCK
   netreclock()
endif
aSTRU := dbstruct()
if valtype( aCAMPO ) = "C" .and. valtype( aVAR ) = "C"      //nao E mantriz
   eVAR   := aVAR
   eCAMPO := aCAMPO
   aCAMPO := { eCAMPO }                 //Vira uma matriz
   aVAR   := { eVAR }
endif
for XCAMPO := 1 to len( aVAR )
   eVAR   := aVAR[ XCAMPO ]
   eCAMPO := aCAMPO[ XCAMPO ]
   if lMACRO
      cTIPOV := type( eVAR )
   else
      cTIPOV := valtype( eVAR )
   endif
   cTIPOC  := type( eCAMPO )
   nERRO   := 0
   nPOSDBF := 0
   for XPOS := 1 to len( aSTRU )
      if upper( alltrim( aSTRU[ XPOS, 1 ] ) ) = upper( alltrim( eCAMPO ) )
         nPOSDBF := XPOS
      endif
   next
   IF lLOG
      FWRITE(nHANLOG,&eCAMPO +" "+( lMACRO, &eVAR, eVAR )+CHR(13)+CHR(10))
   ENDIF
   if cTIPOV = cTIPOC .and. nPOSDBF > 0
      if cTIPOC = "N"
         if lMACRO
            eUSO := alltrim( str( &eVAR ) )
         else
            eUSO := alltrim( str( eVAR ) )
         endif
         nDEC    := at( ".", eUSO )     //Posicao
         nTAM    := len( eUSO )
         eTMPVAL := repl( "9", aSTRU[ nPOSDBF, 3 ] )        //Faz 9999... Conforme tam
         if aSTRU[ NPOSDBF, 4 ] > 0
            eTMPVAL += "." + repl( "9", aSTRU[ nPOSDBF, 4 ] )
         endif
         eTMPVAL := val( eTMPVAL )
         if if( lMACRO, &eVAR., eVAR ) > eTMPVAL
            nERRO := 1
            if aSTRU[ NPOSDBF, 4 ] > 0
               eUSO := right( str( round( if( lMACRO, &eVAR, eVAR ), aSTRU[ nPOSDBF, 4 ] ) ), aSTRU[ nPOSDBF, 3 ] )
            else
               eUSO := right( str( int( if( lMACRO, &eVAR, eVAR ) ) ), aSTRU[ nPOSDBF, 3 ] )
            endif
            field->&eCAMPO := val( eUSO )
         else
            field->&eCAMPO := if( lMACRO, &eVAR, eVAR )
         endif
      else
         field->&eCAMPO := if( lMACRO, &eVAR, eVAR )
      endif
   else
      nERRO := 2
   endif
   if nERRO > 0
      cERRO := "Arquivo: " + alltrim( alias() ) + chr( 13 ) + chr( 10 )
      cERRO += " Variavel: " + alltrim( STRVAL( if( lMACRO, &eVAR, eVAR ) ) ) + " Tipo: " + cTIPOV  //+" Tamanho:"+STR(LEN(&eVAR))+chr(13)+chr(10)
      cERRO += " Campo: " + eCAMPO + " Tipo: " + cTIPOC
      if nPOSDBF = 0
         cERRO += chr( 13 ) + chr( 10 ) + "Campo Arquivo Inexistente: " + eCAMPO
      endif
      if nERRO == 1
         cERRO += chr( 13 ) + chr( 10 ) + "Variavel Excede Tamanho do Campo: " + str( aSTRU[ nPOSDBF, 3 ] ) + " Decimais: " + str( aSTRU[ nPOSDBF, 4 ] )
      endif
      if lMES
         ALERTX( cERRO )
      endif
      GRAVAERRO(, cERRO )
      if valtype( cUSO ) = "C"
         GRAVAERRO(, cUSO )
      endif
      if cTIPOC = "C"
         field->&eCAMPO := STRVAL( if( lMACRO, &eVAR, eVAR ) )
      endif
      if cTIPOC = "M"
         field->&eCAMPO := STRVAL( if( lMACRO, &eVAR, eVAR ) )
      endif
   endif
next XCAMPO
IF lLOG
   Fclose(nHANLOG)
ENDIF
if lLOCK
   dbunlock()
endif
dbcommit()
return .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+
*+    Function GravaERRO(cARQ, aMES)
*+
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+
function GravaERRO( cARQ, aMES )
local X
if valtype( cARQ ) # "C"
   cARQ := "ERRO.TXT"
endif
if valtype( aMES ) # "A"                //Transforme em matriz se nao for
   aMES := { aMES }
endif
if ! HB_FILEEXISTS( cARQ )
   nhandle := fcreate( cARQ )
else
   nhandle := hb_fopen( cARQ, 1 )
   fseek( nhandle, 0, 2 )
endif
for X := 1 to len( aMES )
   fwrite( nHandle, STRVAL( aMES[ X ] ) + chr( 13 ) + chr( 10 ) )
next X
fclose( nHandle )
return .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function CLRVARS()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function CLRVARS()
local aSTRU
aSTRU := dbstruct()
for XPOS := 1 to len( aSTRU )
   field_name  := "m" + lower( aSTRU[ XPOS, 1 ] )
   &field_name := MAKEVAR( aSTRU[ XPOS, 2 ], aSTRU[ xPOS, 3 ], aSTRU[ xPOS, 4 ] )
next
return .t.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function EQUVARS()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function EQUVARS
//  Carrega dos campos da b. de dados as variaveis de memoria criadas por INITVARS.
local field_cnt    := fcount()
local counter      := 0
private field_name
//  Carrega cada uma das variaveis do campo correspondente
for counter := 1 to field_cnt
   field_name   := lower( field( counter ) )
   m&field_name := &field_name
next
return .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function FREEVARS()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function FREEVARS
//  Libera as variaveis criadas por INITVARS.
local counter      := 0
local field_cnt    := fcount()
private field_name
//  Libera cada uma das variaveis de campo.
for counter := 1 to field_cnt
   field_name := lower( field( counter ) )
   release m&field_name
next
return .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function INITVARS()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function INITVARS
//  Cria variaveis de memoria para cada campo da base de dados ativa.
//  Atencao: Esta rotina declara uma variavel de memoria PUBLICA para
//  cada campo da base de dados selecionada. Libera as variaveis,
//  chamando FREEVARS quando voce nao precisa mais delas.
local field_cnt    := fcount()
local counter      := 0
private field_name
//  Obtem o numero de campos.
field_cnt := fcount()
//  Declara uma variavel publica para cada campo.
for counter := 1 to field_cnt
   field_name := lower( field( counter ) )
   public m&field_name
next
return .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function REPLVARS(lCHECK)
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function REPLVARS( lCHECK,lVAZIO )
//  Substitui o registro pelo valor das variaveis de memoria.
local field_cnt    := fcount()
local counter      := 0
local aCAM
local aDAD
private field_name
if valtype( lCHECK ) # "L"
   lCHECK := .T.
endif
if valtype( lVAZIO ) # "L"
   lVAZIO := .F.
endif

//  Obtem o numero de campos.
field_cnt := fcount()
if lCHECK           //Com Checagem chama gravacampo
   //  Substitui cada um dos campos pelas variaveis a eles associadas.
   aCAM := {}
   aVAR := {}
   for counter := 1 to field_cnt
      field_name := lower( field( counter ) )
	  IF .not. lVAZIO .or. (empty(field->&field_name) .and. ! empty(m&field_name))
		 aadd( Acam, field_name )
         aadd( AVAR, "m" + field_name )
	  ENDIF	 
   next
   gravacampo( aCAM, aVAR,,, )   //GravaCampo(aCAMPO, aVAR, cUSO, lLOCK, lMES, lMACRO ,lLOG)
else                //Sem checagem
   for counter := 1 to field_cnt
      field_name         := lower( field( counter ) )
	  IF .not. lVAZIO .or. (empty(field->&field_name) .and. ! empty(m&field_name))
         field->&field_name := m&field_name
	  endif	 
   next
endif
return .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MAKEVAR()
*+
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function MAKEVAR( cTIPO, nLEN, nDEC )
local eRETU
eRETU := NIL
if valtype( nLEN ) # "N"
   nLEN := 1
endif
if valtype( nDEC ) # "N"
   nDEC := 0
endif
do case
	case cTIPO = "C" .or. cTIPO = "M"
	   eRETU := spac( nLEN )
	case cTIPO = "D"
	   eRETU := ctod( "  /  /  " )
	case cTIPO = "L"
	   eRETU := .F.
	case cTIPO = "N"
	   eRETU := val( str( 0, nLEN, nDEC ) )
endcase
return eRETU

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MAKE_EMPTY()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function MAKE_EMPTY( eCAMPO )
local eRETU
local aSTRU
local xPOSDBF
local xPOS
eRETU := NIL
if !empty( alias() )
   aSTRU   := dbstruct()
   nPOSDBF := 0
   for XPOS := 1 to len( aSTRU )
      if upper( alltrim( aSTRU[ XPOS, 1 ] ) ) = upper( alltrim( eCAMPO ) )
         nPOSDBF := XPOS
      endif
   next
   if nPOSDBF > 0
      eRETU := MAKEVAR( aSTRU[ nPOSDBF, 2 ], aSTRU[ nPOSDBF, 3 ], aSTRU[ nPOSDBF, 4 ] )
   endif
endif
retu eRETU

*+ EOF: DISK70.PRG
