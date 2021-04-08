#include "try.ch"
#include "box.ch"

//Win_PrintDlgDC() dialogo impressora nativo
/* win_PrintDlgDC( [@<cDevice>], [<nFromPage>], [<nToPage>], [<nCopies>] )
 *                --> <hDC>
 */
 /* win_GetOpenFileName( [[@]<nFlags>], [<cTitle>], [<cInitDir>], [<cDefExt>], ;
 *                      [<acFilter>], [[@]<nFilterIndex>], [<nBufferSize>], [<cDefName>] )
 *    --> <cFilePath> | <cPath> + e"\0" + <cFile1> [ + e"\0" + <cFileN> ] | ""
 *
 */
/* win_GetSaveFileName( [[@]<nFlags>], [<cTitle>], [<cInitDir>], [<cDefExt>], ;
 *                      [<acFilter>], [[@]<nFilterIndex>], [<nBufferSize>], [<cDefName>] )
 *    --> <cFilePath> | <cPath> + e"\0" + <cFile1> [ + e"\0" + <cFileN> ] | ""
 *
 */
/* win_PrintDlgDC( [@<cDevice>], [<nFromPage>], [<nToPage>], [<nCopies>] )
 *                --> <hDC>
 */



function hb_fopen(cARQ)
return fopen(carq)

*+๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐
*+
*+    Function alltrue()
*+
*+๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐๐
*+
FUNCTION alltrue()
   RETURN .t.


*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
*+    Function clscor()
*+
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
function clscor()
SetColor( "" )

*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
*+    Function video()
*+
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
function video()
Set( _SET_DEVICE, "SCREEN" ) //set device to screen

*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
*+    Function impressora()
*+
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
function impressora()
Set( _SET_DEVICE, "PRINTER" ) //set device to print

*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
*+    Function clsrow()
*+
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
function clsrow(nROW)
@ nROW, 0 CLEAR TO nROW, MAXCOL()
              
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
*+    Function clsbox()
*+
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
function clsbox(nROWINI,nCOLINI,nROWFIM,nCOLFIM)
HB_dispbox(nROWINI , nCOLINI, nROWFIM, nCOLFIM, space(8))

//@ nROWINI, nCOLINI CLEAR TO nROWFIM, nCOLFIM

*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
*+    Function NNETWHOAMI()
*+
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
function NNETWHOAMI()
LOCAL cUSER
cUSER:=HB_USERNAME()
IF EMPTY(cUSER)
   cUSER:=upper(GetEnv( "username" ))
   if empty(cUSER)
      cUSER:="USUARIO"
   endif
endif   
RETUrn cUSER

*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
*+    Function MDG()
*+
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
function MDG( cMES, nOPT )
RETURN MsgYesNo( cMES )


*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
*+    Function MDS()
*+
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
function MDS( cMES )
local OLDCOR := setcolor()
SetColor("") // set color to
@ maxrow(), 0 say padr( cMES, 80 )
setcolor( OLDCOR )
return .T.


*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
*+    Function Hotinkey(waittime)
*+
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+

FUNCTION Hotinkey(waittime)
  LOCAL key, cblock

  DO CASE

     /* if no WAITTIME passed, go straight through */
     CASE pcount() == 0
        key := inkey()

     /* dig this... if you pass inkey(NIL), it is identical to INKEY(0)!
        therefore, I allow you to pass FT_SINKEY(NIL) -- hence this mild bit
        of convolution */

     CASE waittime == NIL .AND. Pcount() == 1
        key := inkey(0)

     OTHERWISE
        key := inkey(waittime)

  ENDCASE

  cblock := Setkey(key)

  IF cblock != NIL

     // run the code block associated with this key and pass it the
     // name of the previous procedure and the previous line number

     Eval(cblock, Procname(1), Procline(1), NIL)

  ENDIF

RETURN key


*+ํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํ
*+
*+    Function SALVAA()
*+
*+ํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํ
*+
function SALVAA

aRETU := { setcursor(), ;
           row(), col(), ;
           savescreen( 00, 00, maxrow(), maxcol() ), ;
           setcolor(), ;
           alias() }
return aRETU

*+ํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํ
*+
*+    Function RESTAA()
*+
*+ํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํํ
*+
function RESTAA( aAMB )

setcursor( aAMB[ 1 ] )
setpos( aAMB[ 2 ], aAMB[ 3 ] )
restscreen( 00, 00, maxrow(), maxcol(), aAMB[ 4 ] )
setcolor( aAMB[ 5 ] )
if !empty( aAMB[ 6 ] )
   dbselectar( aAMB[ 6 ] )
endif
return .T.

****************************************
FUNCTION CheckEmail( cEmail )
*
* Purpose: validate an email addres for syntax
*

LOCAL lReturn := .f.
LOCAL cRegEx := "^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$"
LOCAL aCHAR  := {"@","/","?",".","-","=","+","<",">",";","'","[","]","\","|","`","~","!","#","$","%","^","&","*","(",")","_"}
LOCAL X

ZNERRO:=0
ZERRO:=""
cEMAIL:=ALLTRIM(cEMAIL)    

IF EMPTY(cEMAIL)
   ZNERRO:=1
   ZERRO:="Email Nao Preenchido"
ENDIF
    //lReturn := ( cAddress LIKE cRegEx ) .or. empty(cAddress)
    lRETURN:=HB_REGEXLIKE( cRegEx, cEMail ) .or. empty(cEMAIL)

if at("@",cEMAIL)=0    
   ZNERRO:=2
   ZERRO:="Email sem @"
   lReturn := .f.
endif

if NUMat("@",cEMAIL)>1
   ZNERRO:=3
   ZERRO:="Email com mais de 1 @"
   lReturn := .f.
endif

FOR X=1 TO LEN(aCHAR)  
   if LEFT(cEMAIL,1)=aCHAR[X]
      ZNERRO:=4      
      ZERRO:="Email sem Iniciando com "+Achar[x]
      lReturn := .f.
      exit
   endif  
   if right(cEMAIL,1)=aCHAR[X]
      ZNERRO:=5
      ZERRO:="Email sem encerrando com "+Achar[x]
      lReturn := .f.
      exit
   endif   
NEXT     

if at(".",right(cEMAIL,4))=0    
   ZNERRO:=6
   ZERRO:="tem que ter ponto . nos 4 ultimos digitos"
   lReturn := .f.
endif
    

RETURN  lReturn 
* 



*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
*+    Function rmacro()
*+
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
function rmacro(eBLOCO,ePAD,lMES)
IF VALTYPE(lMES)#"L"
   lMES:=.F.
ENDIF
IF VALTYPE(ePAD)#"U"
   eRETU:=ePAD
ENDIF   
TRY
    eRETU:=eVAL(eBLOCO)   
CATCH oERROR
    IF lMES
       ALERT(HB_VALTOEXP(eBLOCO))
    ENDIF   
END
RETURN eRETU


*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
*+    Function arqlogdatahora()
*+
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+

function ArqLogDataHora(cEXT)
IF VALTYPE(cEXT)<>"C"
   cEXT:=".log"
ELSE
   cEXT:="."+cEXT
ENDIF
return dtos(date())+strtran(time(),":","")+cEXT

//	? len( GetDrvMapLetter( "\\lenovo-pc\_drive_e" ) )
//	? len( GetDrvMapLetter() )
//  len( GetDrvMapLetter( "\\lenovo-pc\g" ) )


*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
*+    Function GetDrvMapLetter( strLocalDrive )
*+
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
function GetDrvMapLetter( strLocalDrive ) // UNC path
   local aGetDrvMapLetter := {}
    local objNetwork := TOLEAuto():New( "WScript.Network" )
    local objDrives   := objNetwork:EnumNetworkDrives()
    local i := 0
    If objDrives:Count > 0
        do while i < objDrives:Count
             if !empty( strLocalDrive )
                if upper( objDrives:Item(i+1) ) = upper( strLocalDrive )
                   aGetDrvMapLetter := { objDrives:Item(i), objDrives:Item(i+1) }
               exit
                endIf
             else
                aadd( aGetDrvMapLetter, { objDrives:Item(i), objDrives:Item(i+1) } )
             endif
             i=i+2
        enddo   
    EndIf 
    return aGetDrvMapLetter

*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
*+    Function msgyesno()
*+
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+

FUNCTION MsgYesNo( cText )

   LOCAL lValue

   lValue := wapi_MessageBox( wvgSetAppWindow():hWnd, cText, "Confirmacao", WIN_MB_YESNO + WIN_MB_ICONQUESTION + WIN_MB_DEFBUTTON2 )  == 6 //6=WIN_IDYES

   RETURN lValue

*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
*+    Function msgexclamation()
*+
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+

FUNCTION MsgExclamation( cText )

   wapi_MessageBox( wvgSetAppWindow():hWnd, cText, "Atencao", WIN_MB_ICONASTERISK )

   RETURN NIL

*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
*+    Function msgwarning()
*+
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+

FUNCTION MsgWarning( cText )

   wapi_MessageBox( wvgSetAppWindow():hWnd, cText, "Atencao", WIN_MB_ICONEXCLAMATION )

   RETURN NIL

*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+
*+    Function msgstop()
*+
*+ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
*+

FUNCTION MsgStop( cText )

   wapi_MessageBox( wvgSetAppWindow():hWnd, cText, "Atencao", WIN_MB_ICONHAND )

   RETURN NIL


FUNCTION ALERTX(cTEXT,cTIPO)
IF VALTYPE(cTIPO)<>"C"
   cTIPO:="E"
ENDIF
cTIPO:=UPPER(cTIPO)
DO CASE 
   CASE cTIPO="E"
		MsgExclamation( cText )
   CASE cTIPO="W"
		MsgWarning( cText )
   CASE cTIPO="S"
		MsgStop( cText )
  OTHERWISE
		MsgExclamation( cText )
ENDCASE


//Win_PrintDlgDC() dialogo impressora nativo
/* win_PrintDlgDC( [@<cDevice>], [<nFromPage>], [<nToPage>], [<nCopies>] )
 *                --> <hDC>
 */

FUNCTION shellexecprint(cARQUIVO)
LOCAL cPrn,ncop := 1
Win_PrintDlgDC( @cPrn,,,ncop)
IF !( EMPTY( cPrn ) )
    wapi_ShellExecute( 0, "print",cARQUIVO, cPrn , 0, 0 )
ENDIF
RETURN

