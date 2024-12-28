// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_dn.prg
// +
// +
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +
// +
// +
// +    Documentado em 28-Dez-2024 as  9:57 am
// +
// +
// +
// +--------------------------------------------------------------------
// +



#include "INKEY.CH"
#include "Fileio.ch"

// Help de Contexto
PRIV HELPDBF := "MDN"


// Desenha a Tela
MDI( "аж Configuracao Basica do Sistema" )
MDS( "Voce esta vendo a configuracao basica do sistema" )

cDRIVE := hb_CurDrive()
W1     := hb_DiskSpace( cDrive, HB_DISK_FREE )   // DISKFREE()
hb_MemoWrit( 'TEMP.TMP', " " )
W2       := hb_DiskSpace( cDrive, HB_DISK_FREE )   // DISKFREE()
WCLUSTER := W1 - W2
DELETEFILE( "TEMP.TMP" )
! VOL > VOL.SIS
cVOL := hb_MemoRead( "VOL.SIS" )
DELETEFILE( "VOL.SIS" )

cWINDOWS := ""
DO CASE
CASE win_osIs2000()
cWINDOWS := "2000"
CASE win_osIsXP()
cWINDOWS := "XP"
CASE win_osIs2003()
cWINDOWS := "2003"
CASE win_osIsVista()
cWINDOWS := "Vista"
CASE win_osIs7()
cWINDOWS := "Windows 7"
CASE win_osIs8()
cWINDOWS := "Windows 8"
// ? "81"          , CASE win_osIs81()
// cWINDOWS:= "Windows 81"
// ? "10"          , CASE win_osIs10()
// cWINDOWS:= "Windows 10"


CASE win_osIs95()
cWINDOWS := "95"
CASE win_osIs98()
cWINDOWS := "98"
CASE win_osIs9x()
cWINDOWS := "9x"
CASE win_osIsME()
cWINDOWS := "ME"
CASE win_osIsNT()
cWINDOWS := "NT"
CASE win_osIsNT351()
cWINDOWS := "NT351"
CASE win_osIsNT4()
cWINDOWS := "NT4"
CASE win_osIsTSClient()
cWINDOWS := "TSClient"

ENDCASE

TELASAY( "MDN001" )

y := 0
FOR X := 1 TO MLCount( cVOL )
IF !Empty( MemoLine( cVOL,, X ) )
@ 17 + Y, 11 SAY AllTrim( MemoLine( cVOL,, X ) )
Y++
ENDIF
NEXT X
KEY := 0
WHILE KEY = 0
KEY := HOTINKEY()
KEY := LERMOUSE( kEY )
IF MOUSE_Y = 1 .AND. MOUSE_B = 2 .AND. MOUSE_X < 4
nKEY := K_ESC
ENDIF
ENDDO
RETU .T.


/*
   procedure Main

      CLS
      ? 'Version Info '
      AEval( WIN_OSVERSIONINFO(),  { |x| QQOut(x) } )
      wait
      ?
      ? 'NT         ' , WIN_OSISNT()          , OS_ISWINNT()             , HB_OSISWINNT()
      ? 'NT351      ' , WIN_OSISNT351()       , OS_ISWINNT351()          , '*'
      ? 'N4         ' , WIN_OSISNT4()         , OS_ISWINNT4()            , '*'
      ? '2000 UPPER ' , WIN_OSIS2000ORUPPER() , OS_ISWIN2000_OR_LATER()  , '*'
      ? '2000       ' , WIN_OSIS2000()        , OS_ISWIN2000()           , HB_OSISWIN2K()
      ? 'XP         ' , WIN_OSISXP()          , OS_ISWINXP()             , '*'
      ? '2003       ' , WIN_OSIS2003()        , OS_ISWIN2003()           , '*'
      ? 'VISTA      ' , WIN_OSISVISTA()       , OS_ISWINVISTA()          , '*'
      ? 'VISTA UPPER' , WIN_OSISVISTAORUPPER(), OS_ISWINVISTA_OR_LATER() , HB_OSISWINVISTA()
      ? '7          ' , WIN_OSIS7()           , OS_ISWIN7()              , '*'
      ? '9X         ' , WIN_OSIS9X()          , OS_ISWIN9X()             , HB_OSISWIN9X()
      ? '95         ' , WIN_OSIS95()          , OS_ISWIN95()             , '*'
      ? '98         ' , WIN_OSIS98()          , OS_ISWIN98()             , '*'
      ? 'ME         ' , WIN_OSISME()          , OS_ISWINME()             , '*'
      ? '64 BIT     ' , '*'                   , '*'                      , HB_OSIS64BIT()
      ? 'CE         ' , '*'                   , '*'                      , HB_OSISWINCE()
      //?
      //? HB_OSCPU()
      //? HB_VERSION()
      //? HB_BUILDDATE()
      //? HB_COMPILER()
      //? HB_PCODEVER()
      //?
      //VolSerial()
      wait
   RETURN
*/




// + EOF: m_dn.prg
// +
