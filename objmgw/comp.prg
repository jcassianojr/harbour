*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : comp.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 28-Dez-2024 as 10:41 am
*+
*+
*+
*+--------------------------------------------------------------------
*+

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




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function hb_fopen()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function hb_fopen(cARQ)

return fopen(carq)


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function alltrue()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION alltrue()

RETURN .t.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function clscor()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function clscor()

SetColor("")


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function video()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function video()

Set(_SET_DEVICE,"SCREEN")   //set device to screen


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function impressora()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function impressora()

Set(_SET_DEVICE,"PRINTER")  //set device to print


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function clsrow()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function clsrow(nROW)

@ nROW,0 CLEAR TO nROW,MAXCOL()


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function clsbox()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function clsbox(nROWINI,nCOLINI,nROWFIM,nCOLFIM)

HB_dispbox(nROWINI,nCOLINI,nROWFIM,nCOLFIM,space(8))

//@ nROWINI, nCOLINI CLEAR TO nROWFIM, nCOLFIM


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function NNETWHOAMI()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function NNETWHOAMI()

LOCAL cUSER
cUSER := HB_USERNAME()
IF EMPTY(cUSER)
   cUSER := upper(GetEnv("username"))
   if empty(cUSER)
      cUSER := "USUARIO"
   endif
endif
RETUrn cUSER


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MDG()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function MDG(cMES,nOPT)

RETURN MsgYesNo(cMES)



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MDS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function MDS(cMES)

local OLDCOR := setcolor()
SetColor("")  // set color to
@ maxrow(), 0 say padr(cMES,80)         
setcolor(OLDCOR)
return .T.




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function Hotinkey()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION Hotinkey(waittime)

LOCAL key,cblock

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

   Eval(cblock,Procname(1),Procline(1),NIL)

ENDIF

RETURN key



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function SALVAA()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function SALVAA


aRETU := {setcursor(),;
 row(),col(),;
 savescreen(00,00,maxrow(),maxcol()),;
 setcolor(),;
 alias()}
return aRETU


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function RESTAA()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function RESTAA(aAMB)


setcursor(aAMB[1])
setpos(aAMB[2],aAMB[3])
restscreen(00,00,maxrow(),maxcol(),aAMB[4])
setcolor(aAMB[5])
if !empty(aAMB[6])
   dbselectar(aAMB[6])
endif
return .T.

// ***************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CheckEmail()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION CheckEmail(cEmail)

//
//  Purpose: validate an email addres for syntax
//

LOCAL lReturn := .f.
LOCAL cRegEx  := "^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$"
LOCAL aCHAR   := {"@","/","?",".","-","=","+","<",">",";","'","[","]","\","|","`","~","!","#","$","%","^","&","*","(",")","_"}
LOCAL X

ZNERRO := 0
ZERRO  := ""
cEMAIL := ALLTRIM(cEMAIL)

IF EMPTY(cEMAIL)
   ZNERRO := 1
   ZERRO  := "Email Nao Preenchido"
ENDIF

//lReturn := ( cAddress LIKE cRegEx ) .or. empty(cAddress)
IF HB_REGEXLIKE(cRegEx,cEMail) .or. empty(cEMAIL)
   lReturn := .T.
ELSE
   ZNERRO  := 7
   ZERRO   := "erro na nomenclatura geralmente teste@teste.com "
   lReturn := .f.
ENDIF

if at("@",cEMAIL) = 0
   ZNERRO  := 2
   ZERRO   := "Email sem @"
   lReturn := .f.
endif

if NUMat("@",cEMAIL) > 1
   ZNERRO  := 3
   ZERRO   := "Email com mais de 1 @"
   lReturn := .f.
endif

FOR X := 1 TO LEN(aCHAR)
   if LEFT(cEMAIL,1) = aCHAR[X]
      ZNERRO  := 4
      ZERRO   := "Email sem Iniciando com "+Achar[x]
      lReturn := .f.
      exit
   endif
   if right(cEMAIL,1) = aCHAR[X]
      ZNERRO  := 5
      ZERRO   := "Email sem encerrando com "+Achar[x]
      lReturn := .f.
      exit
   endif
NEXT

if at(".",right(cEMAIL,4)) = 0 .and. at(".",right(cEMAIL,3)) = 0  // .com .ti dominius com 3 ou 2 digitos
   ZNERRO  := 6
   ZERRO   := "tem que ter ponto . nos 3 ou 4 ultimos digitos"
   lReturn := .f.
endif


RETURN lReturn
//




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function rmacro()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function rmacro(eBLOCO,ePAD,lMES)

IF VALTYPE(lMES) # "L"
   lMES := .F.
ENDIF
IF VALTYPE(ePAD) # "U"
   eRETU := ePAD
ENDIF
TRY
eRETU := eVAL(eBLOCO)
CATCH oERROR
IF lMES
   ALERT(HB_VALTOEXP(eBLOCO))
ENDIF
END
RETURN eRETU




*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ArqLogDataHora()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function ArqLogDataHora(cEXT)

IF VALTYPE(cEXT) <> "C"
   cEXT := ".log"
ELSE
   cEXT := "."+cEXT
ENDIF
return dtos(date())+strtran(time(),":","")+cEXT

//	? len( GetDrvMapLetter( "\\lenovo-pc\_drive_e" ) )
//	? len( GetDrvMapLetter() )
//  len( GetDrvMapLetter( "\\lenovo-pc\g" ) )



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function GetDrvMapLetter()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function GetDrvMapLetter(strLocalDrive)   // UNC path

local aGetDrvMapLetter := {}
local objNetwork       := TOLEAuto():New("WScript.Network")
local objDrives        := objNetwork:EnumNetworkDrives()
local i                := 0
If objDrives:Count > 0
   do while i < objDrives:Count
      if !empty(strLocalDrive)
         if upper(objDrives:Item(i+1)) = upper(strLocalDrive)
            aGetDrvMapLetter := {objDrives:Item(i),objDrives:Item(i+1)}
            exit
         endIf
      else
         aadd(aGetDrvMapLetter,{objDrives:Item(i),objDrives:Item(i+1)})
      endif
      i := i+2
   enddo
EndIf
return aGetDrvMapLetter



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MsgYesNo()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION MsgYesNo(cText)


LOCAL lValue

lValue := wapi_MessageBox(wvgSetAppWindow() :hWnd,cText,"Confirmacao",WIN_MB_YESNO+WIN_MB_ICONQUESTION+WIN_MB_DEFBUTTON2) == 6  //6=WIN_IDYES

RETURN lValue



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MsgExclamation()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION MsgExclamation(cText)


wapi_MessageBox(wvgSetAppWindow() :hWnd,cText,"Atencao",WIN_MB_ICONASTERISK)

RETURN NIL



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MsgWarning()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION MsgWarning(cText)


wapi_MessageBox(wvgSetAppWindow() :hWnd,cText,"Atencao",WIN_MB_ICONEXCLAMATION)

RETURN NIL



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MsgStop()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION MsgStop(cText)


wapi_MessageBox(wvgSetAppWindow() :hWnd,cText,"Atencao",WIN_MB_ICONHAND)

RETURN NIL



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ALERTX()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION ALERTX(cTEXT,cTIPO)

IF VALTYPE(cTIPO) <> "C"
   cTIPO := "E"
ENDIF
cTIPO := UPPER(cTIPO)
DO CASE
CASE cTIPO = "E"
   MsgExclamation(cText)
CASE cTIPO = "W"
   MsgWarning(cText)
CASE cTIPO = "S"
   MsgStop(cText)
OTHERWISE
   MsgExclamation(cText)
ENDCASE


//Win_PrintDlgDC() dialogo impressora nativo
/* win_PrintDlgDC( [@<cDevice>], [<nFromPage>], [<nToPage>], [<nCopies>] )
 *                --> <hDC>
 */


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function shellexecprint()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION shellexecprint(cARQUIVO)

LOCAL cPrn,ncop := 1
Win_PrintDlgDC(@cPrn,,,ncop)
IF !(EMPTY(cPrn))
   wapi_ShellExecute(0,"print",cARQUIVO,cPrn,0,0)
   // hwnd,   lpOperation,  lpFile,   lpParameters,   lpDirectory,    nShowCmd
ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function shellexecopen()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION ShellExecuteOpen( cFileName, cParameters, cPath, nShow )

   wapi_ShellExecute( Nil, "open", cFileName, cParameters, cPath, hb_DefaultValue( nShow, 1 ) )
   // hwnd,   lpOperation,  lpFile,   lpParameters,   lpDirectory,    nShowCmd
    //#define WIN_SW_SHOWNORMAL   1
   RETURN Nil




FUNCTION ArraytoTexto( a, cDelim )  //usado filetoemial flib08 app thunder (outros usos futuros)
LOCAL cRet := ""
AEval( a, {|e| cRet := cRet + e + cDelim } )
RETURN hb_strShrink( cRet )

FUNCTION WaitProcess( cProcess )   //usado filetoemial flib08 app thunder  (outros usos futuros)
LOCAL hProcess := hb_ProcessOpen( cProcess )
   IF ! ( hProcess == -1 )
      DO WHILE hb_ProcessValue( hProcess, .T. ) == 0
          hb_IdleSleep( 0.1 )
      ENDDO
      hb_ProcessClose( hProcess, .T. )
   ENDIF
   RETURN NIL

*+ EOF: comp.prg
*+
