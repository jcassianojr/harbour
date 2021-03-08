*:*****************************************************************************
*:
*:       Programa: M_DN.PRG - Informacoes do Sistema
*:
*:        Sistema: Manager Versao 5  Cl-52E,RATM
*:          Autor: Equipe Softec Sistemas
*:      Copyright (c) 1995, Softec Sistemas S/C Ltda.
*:  Atualizado em: 21/09/95     10:25
*:
*:  Procs & Fncts: M_DN()
*:
*:          Chama: MDI()              (function  in ?)
*:               : MDS()              (function  in ?)
*:               : COR()              (function  in ?)
*:               : OSVER()            (function  in CA-TOOLS)
*:               : DISKTOTAL()        (function  in CA-TOOLS)
*:               : DISKNAME()         (function  in CA-TOOLS)
*:               : HOTINKEY()         (function  in ?)
*:               : LERMOUSE()         (function  in ?)
*:
*: Outros Arquivos: TEMP.TMP
*:                  VOL.SIS
*:
*:     Documentado 21/09/95 at 20:02                SNAP!  vers„o 5.02
*:*****************************************************************************


#INCLUDE "INKEY.CH"
#include "Fileio.ch"
LOCAL cVolumeName, nSerial, nMaxComponentLenght, nFileSystemFlags, cFileSystemName
//Help de Contexto
PRIV HELPDBF:="MDN"


// Desenha a Tela
MDI(" Configuracao Basica do Sistema")


cDRIVE:=hb_CURDRIVE()
W1=HB_DiskSpace( cDrive, HB_DISK_FREE ) //DISKFREE()
hb_memowrit('TEMP.TMP'," ")
W2=HB_DiskSpace( cDrive, HB_DISK_FREE ) //DISKFREE()
WCLUSTER=W1-W2
DELETEFILE("TEMP.TMP")
//! VOL >VOL.SIS
//cVOL:=hb_memoread("VOL.SIS")
//DELETEFILE("VOL.SIS")


cWINDOWS:=""
DO CASE
  CASE win_osIs2000()
      cWINDOWS:="2000"
    CASE win_osIsXP()
      cWINDOWS:="XP"   
    CASE win_osIs2003()
      cWINDOWS:="2003"   
    CASE win_osIsVista()
      cWINDOWS:="Vista"   
    CASE win_osIs7()
      cWINDOWS:="Windows 7"   
    CASE win_osIs8()
      cWINDOWS:="Windows 8"   
    CASE win_osIs81() 
       cWINDOWS:= "Windows 81"     
    CASE win_osIs10()
       cWINDOWS:= "Windows 10"     
    CASE  win_osIs95()
      cWINDOWS:="95"      
    CASE win_osIs98()
      cWINDOWS:="98"
    CASE win_osIs9x()
      cWINDOWS:="9x"   
    CASE win_osIsME()
      cWINDOWS:="ME"   
    CASE win_osIsNT()
      cWINDOWS:="NT"   
    CASE win_osIsNT351()
      cWINDOWS:="NT351"   
    CASE win_osIsNT4()
      cWINDOWS:="NT4"    
    CASE win_osIsTSClient()
      cWINDOWS:="TSClient"   

ENDCASE

TELASAY("MDN001")
SETCOLOR(COR("MDN002"))
@  4, 27 SAY TRANS(MEMORY(0),"@E 999,999,999")+' Kbytes livres'
@  5, 27 SAY TRANS(MEMORY(1),"@E 999,999,999")+' Kbytes livres'
@  6, 27 SAY TRANS(MEMORY(2),"@E 999,999,999")+' Kbytes livres'
@  7, 27 SAY OS() //OS_VER()
@  8, 27 say hb_ValToExp( win_osVersionInfo() )
@  9, 27 SAY TRANS(HB_DiskSpace( cDrive, HB_DISK_TOTAL ) ,"@E 999,999,999,999")+' bytes livres'
@ 10, 27 SAY TRANS(HB_DiskSpace( cDrive, HB_DISK_FREE ),"@E 999,999,999,999")+' bytes livres'
@ 11, 27 SAY TRANS(WCLUSTER,"@E 999,999")+' Bytes'
@ 12, 27 SAY DISKNAME()+':'
@ 13, 27 SAY '\'+curdir()
@ 14, 27 SAY GETE("CLIPPER")
@ 15, 27 SAY GETE("PATH")  
@ 16, 27 SAY GETE("COMSPEC")
IF wapi_GetVolumeInformation( "C:\", @cVolumeName, @nSerial, @nMaxComponentLenght, @nFileSystemFlags, @cFileSystemName )
   @ 17, 11  SAY cVolumeName
   @ 17, col()+1  SAY nSerial
   @ 17, col()+1  SAY nMaxComponentLenght
   @ 17, col()+1  SAY nFileSystemFlags
   @ 17, col()+1  SAY cFileSystemName
ENDIF
@ 18,27 SAY cWINDOWS
@ 18,COL()+1 SAY "Versao     " + win_regRead( "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\CurrentVersion" )
@ 18,col()+1 say "Compilação " + win_regRead( "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\CurrentBuild" )
KEY:=0
WHILE KEY=0
   KEY:=HOTINKEY()
   KEY:=LERMOUSE(kEY)
   IF MOUSE_Y=1.AND.MOUSE_B=2.AND.MOUSE_X<4
      nKEY=K_ESC
   ENDIF
ENDDO




*: FIM: M_DN.PRG
