/*
 * xHarbour default error handler and error functions:
 *    xhb_ErrorSys(), __ErrorBlock(),
 *    __MinimalErrorHandler(), xhb_ErrorNew()
 *
 * Copyright 2010 Przemyslaw Czerpak <druzus / at / priv.onet.pl>
 * Copyright 2009 Viktor Szakats (vszakats.net/harbour)
 * Copyright 1999 Antonio Linares <alinares@fivetech.com>
 * Copyright 2001-2004 Ron Pinkas <ron@profit-master.com> (TraceLog())
 * Copyright 2002 Luiz Rafael Culik <culikr@uol.com.br> (strvalue(), LogError())
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; see the file LICENSE.txt.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA (or visit https://www.gnu.org/licenses/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

#include "error.ch"
#include "fileio.ch"
#INCLUDE "COMMON.CH"

REQUEST Select, Alias, RecNo, DbFilter, DbRelation, IndexOrd, IndexKey

STATIC s_cErrorLog := "error.log"
STATIC s_lErrorLogAppend := .F.

FUNCTION xhb_ErrorLog( cErrorLog, lErrorLogAppend )

   LOCAL aValueOld := { s_cErrorLog, s_lErrorLogAppend }

   IF HB_ISSTRING( cErrorLog )
      s_cErrorLog := cErrorLog
   ENDIF
   IF HB_ISLOGICAL( lErrorLogAppend )
      s_lErrorLogAppend := lErrorLogAppend
   ENDIF

   RETURN aValueOld

FUNCTION ErrorSys
*------------------------------------------------------------------------------*

	//ErrorBlock( { | oError | DefError( oError ) } )
    ErrorBlock( {| oError | xhb_DefError( oError ) } )

RETURN


PROCEDURE xhb_ErrorSys()

   ErrorBlock( {| oError | xhb_DefError( oError ) } )

   RETURN

STATIC FUNCTION err_ModuleName( oError, n )

   RETURN iif( __objHasMsg( oError, "MODULENAME" ), oError:ModuleName, ;
      iif( n != NIL, ProcFile( n ), NIL ) )

STATIC FUNCTION err_ProcName( oError, n )

   RETURN iif( __objHasMsg( oError, "PROCNAME" ), oError:ProcName, ;
      iif( n != NIL, ProcName( n ), NIL ) )

STATIC FUNCTION err_ProcLine( oError, n )

   RETURN iif( __objHasMsg( oError, "PROCLINE" ), oError:ProcLine, ;
      iif( n != NIL, ProcLine( n ), NIL ) )

STATIC FUNCTION xhb_DefError( oError )

   LOCAL cMessage
   LOCAL cDOSError

   LOCAL aOptions
   LOCAL nChoice

   LOCAL n

   n := 0
   WHILE ! Empty( ProcName( ++n ) )
      IF ProcName( n ) == ProcName()
         n := 3
         TraceLog( "Error system failure!", err_ProcName( oError, n ), err_ProcLine( oError, n ), err_ModuleName( oError, n ), oError:description )
         Alert( "Error system failure!;Please correct error handler:;" + err_ProcName( oError, n ) + "(" + hb_ntos( err_ProcLine( oError, n ) ) +  ") in module: " + err_ModuleName( oError, n ) )
         ErrorLevel( 1 )
         QUIT
      ENDIF
   ENDDO

   // By default, division by zero results in zero
   IF oError:genCode == EG_ZERODIV
      RETURN 0
   ENDIF

   // By default, retry on RDD lock error failure */
   IF oError:genCode == EG_LOCK .AND. ;
         oError:canRetry
      // oError:tries++
      RETURN .T.
   ENDIF

   // Set NetErr() of there was a database open error
   IF oError:genCode == EG_OPEN .AND. ;
         oError:osCode == 32 .AND. ;
         oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   // Set NetErr() if there was a lock error on dbAppend()
   IF oError:genCode == EG_APPENDLOCK .AND. ;
         oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   // Making sure we display the error info!
   DO WHILE DispCount() > 0
      DispEnd()
   ENDDO

   cMessage := ErrorMessage( oError )
   IF ! Empty( oError:osCode )
      cDOSError := "(DOS Error " + hb_ntos( oError:osCode ) + ")"
   ENDIF


   IF HB_ISARRAY( oError:Args )
      cMessage += " Arguments: (" + Arguments( oError ) + ")"
   ENDIF

   // Build buttons

   IF MaxCol() > 0
      aOptions := {}

      // AAdd( aOptions, "Break" )
      AAdd( aOptions, "Quit" )

      IF oError:canRetry
         AAdd( aOptions, "Retry" )
      ENDIF

      IF oError:canDefault
         AAdd( aOptions, "Default" )
      ENDIF

      // Show alert box
      // TraceLog( cMessage )

      nChoice := 0
      DO WHILE nChoice == 0

         IF Empty( oError:osCode )
            nChoice := Alert( cMessage, aOptions )
         ELSE
            nChoice := Alert( cMessage + ";" + cDOSError, aOptions )
         ENDIF

      ENDDO

      IF ! Empty( nChoice )
         DO CASE
         CASE aOptions[ nChoice ] == "Break"
            Break( oError )
         CASE aOptions[ nChoice ] == "Retry"
            RETURN .T.
         CASE aOptions[ nChoice ] == "Default"
            RETURN .F.
         ENDCASE
      ENDIF
   ELSE
      IF Empty( oError:osCode )
         Alert( cMessage + ";" + err_ProcName( oError, 3 ) + "(" + hb_ntos( err_ProcLine( oError, 3 ) ) +  ") in module: " + err_ModuleName( oError, 3 ) )
      ELSE
         Alert( cMessage + ";" + cDOSError + ";" + err_ProcName( oError, 3 ) + "(" + hb_ntos( err_ProcLine( oError, 3 ) ) +  ") in module: " + err_ModuleName( oError, 3 ) )
      ENDIF
   ENDIF

   // "Quit" selected

   IF ! Empty( oError:osCode )
      cMessage += " " + cDOSError
   ENDIF

   ? cMessage

   ?
   ? "Error at ...:", err_ProcName( oError, 3 ) + "(" + hb_ntos( err_ProcLine( oError, 3 ) ) + ") in Module:", err_ModuleName( oError, 3 )
   n := 2
   WHILE ! Empty( ProcName( ++n ) )
      ? "Called from :", ProcName( n ) + ;
         "(" + hb_ntos( ProcLine( n ) ) + ") in Module:", ProcFile( n )
   ENDDO

   // For some strange reason, the DOS prompt gets written on the first line
   // *of* the message instead of on the first line *after* the message after
   // the program quits, unless the screen has scrolled. - dgh
   LogError( oError )

   ErrorLevel( 1 )
   ?
   QUIT

   RETURN .F.

// [vszakats]

STATIC FUNCTION ErrorMessage( oError )

   LOCAL cMessage

   // start error message
   cMessage := iif( oError:severity > ES_WARNING, "Error", "Warning" ) + " "

   // add subsystem name if available
   IF HB_ISSTRING( oError:subsystem )
      cMessage += oError:subsystem()
   ELSE
      cMessage += "???"
   ENDIF

   // add subsystem's error code if available
   IF HB_ISNUMERIC( oError:subCode )
      cMessage += "/" + hb_ntos( oError:subCode )
   ELSE
      cMessage += "/???"
   ENDIF

   // add error description if available
   IF HB_ISSTRING( oError:description )
      cMessage += "  " + oError:description
   ENDIF

   // add either filename or operation
   DO CASE
   CASE ! Empty( oError:filename )
      cMessage += ": " + oError:filename
   CASE ! Empty( oError:operation )
      cMessage += ": " + oError:operation
   ENDCASE

   RETURN cMessage

STATIC FUNCTION LogError( oErr )

   LOCAL cScreen
   LOCAL cLogFile    := s_cErrorLog       // error log file name
   LOCAL lAppendLog  := s_lErrorLogAppend // .F. = create a new error log (default) .T. = append to a existing one.
   LOCAL nCols
   LOCAL nRows

   LOCAL nCount

   LOCAL nForLoop
   LOCAL cOutString

   LOCAL nHandle
   LOCAL nBytes

   LOCAL nHandle2   := F_ERROR
   LOCAL cLogFile2  := "_error.log"
   LOCAL cBuff      := ""
   LOCAL nRead

   nCols := MaxCol()
   IF nCols > 0
      nRows := MaxRow()
      cScreen := SaveScreen()
   ENDIF

   // Alert( "An error occured, Information will be ;written to error.log" )

   IF ! lAppendLog
      nHandle := FCreate( cLogFile, FC_NORMAL )
   ELSE
      IF ! hb_FileExists( cLogFile )
         nHandle := FCreate( cLogFile, FC_NORMAL )
      ELSE
         nHandle  := FCreate( cLogFile2, FC_NORMAL )
         nHandle2 := FOpen( cLogFile, FO_READ )
      ENDIF
   ENDIF


   IF nHandle < 3 .AND. !( Lower( cLogFile ) == "error.log" )
      // Force creating error.log in case supplied log file cannot
      // be created for any reason
      cLogFile := "error.log"
      nHandle := FCreate( cLogFile, FC_NORMAL )
   ENDIF

   IF nHandle < 3
   ELSE

      FWriteLine( nHandle, PadC( " xHarbour Error Log ", 79, "-" ) )
      FWriteLine( nHandle, "" )

      FWriteLine( nHandle, "Date...............: " + DToC( Date() )  )
      FWriteLine( nHandle, "Time...............: " + Time()          )

      FWriteLine( nHandle, "" )
      FWriteLine( nHandle, "Application name...: " + hb_CmdArgArgV() )
      FWriteLine( nHandle, "Workstation name...: " + NetName() )
      FWriteLine( nHandle, "Available memory...: " + strvalue( Memory( 0 ) )  )
      FWriteLine( nHandle, "Current disk.......: " + DiskName() )
      FWriteLine( nHandle, "Current directory..: " + CurDir() )
      FWriteLine( nHandle, "Free disk space....: " + strvalue( DiskSpace() ) )
      FWriteLine( nHandle, "" )
      FWriteLine( nHandle, "Operating system...: " + OS() )
      FWriteLine( nHandle, "xHarbour version...: " + Version() )
      FWriteLine( nHandle, "xHarbour built on..: " + hb_BuildDate() )
      FWriteLine( nHandle, "C/C++ compiler.....: " + hb_Compiler() )

      FWriteLine( nHandle, "Multi Threading....: " + iif( hb_mtvm(), "YES", "NO" ) )
      FWriteLine( nHandle, "VM Optimization....: " + strvalue( hb_VMMode() ) )

      IF hb_IsFunction( "Select" )
         FWriteLine( nHandle, "" )
         FWriteLine( nHandle, "Current Area ......:" + strvalue( Eval( hb_macroBlock( "Select()" ) ) ) )
      ENDIF

      FWriteLine( nHandle, "" )
      FWriteLine( nHandle, PadC( " Environmental Information ", 79, "-" ) )
      FWriteLine( nHandle, "" )

      FWriteLine( nHandle, "SET ALTERNATE......: " + strvalue( Set( _SET_ALTERNATE ), .T. ) )
      FWriteLine( nHandle, "SET ALTFILE........: " + strvalue( Set( _SET_ALTFILE ) ) )
      FWriteLine( nHandle, "SET AUTOPEN........: " + strvalue( Set( _SET_AUTOPEN ), .T. ) )
      FWriteLine( nHandle, "SET AUTORDER.......: " + strvalue( Set( _SET_AUTORDER ) ) )
      FWriteLine( nHandle, "SET AUTOSHARE......: " + strvalue( Set( _SET_AUTOSHARE ) ) )

#ifdef __XHARBOUR__
      FWriteLine( nHandle, "SET BACKGROUNDTASKS: " + strvalue( Set( _SET_BACKGROUNDTASKS ), .T. ) )
      FWriteLine( nHandle, "SET BACKGROUNDTICK.: " + strvalue( Set( _SET_BACKGROUNDTICK ), .T. ) )
#endif
      FWriteLine( nHandle, "SET BELL...........: " + strvalue( Set( _SET_BELL ), .T. ) )
      FWriteLine( nHandle, "SET BLINK..........: " + strvalue( SetBlink() ) )

      FWriteLine( nHandle, "SET CANCEL.........: " + strvalue( Set( _SET_CANCEL ), .T. ) )
      FWriteLine( nHandle, "SET CENTURY........: " + strvalue( __SetCentury(), .T. ) )
      FWriteLine( nHandle, "SET COLOR..........: " + strvalue( Set( _SET_COLOR ) ) )
      FWriteLine( nHandle, "SET CONFIRM........: " + strvalue( Set( _SET_CONFIRM ), .T. ) )
      FWriteLine( nHandle, "SET CONSOLE........: " + strvalue( Set( _SET_CONSOLE ), .T. ) )
      FWriteLine( nHandle, "SET COUNT..........: " + strvalue( Set( _SET_COUNT ) ) )
      FWriteLine( nHandle, "SET CURSOR.........: " + strvalue( Set( _SET_CURSOR ) ) )

      FWriteLine( nHandle, "SET DATE FORMAT....: " + strvalue( Set( _SET_DATEFORMAT ) ) )
      FWriteLine( nHandle, "SET DBFLOCKSCHEME..: " + strvalue( Set( _SET_DBFLOCKSCHEME ) ) )
      FWriteLine( nHandle, "SET DEBUG..........: " + strvalue( Set( _SET_DEBUG ), .T. ) )
      FWriteLine( nHandle, "SET DECIMALS.......: " + strvalue( Set( _SET_DECIMALS ) ) )
      FWriteLine( nHandle, "SET DEFAULT........: " + strvalue( Set( _SET_DEFAULT ) ) )
      FWriteLine( nHandle, "SET DEFEXTENSIONS..: " + strvalue( Set( _SET_DEFEXTENSIONS ), .T. ) )
      FWriteLine( nHandle, "SET DELETED........: " + strvalue( Set( _SET_DELETED ), .T. ) )
      FWriteLine( nHandle, "SET DELIMCHARS.....: " + strvalue( Set( _SET_DELIMCHARS ) ) )
      FWriteLine( nHandle, "SET DELIMETERS.....: " + strvalue( Set( _SET_DELIMITERS ), .T. ) )
      FWriteLine( nHandle, "SET DEVICE.........: " + strvalue( Set( _SET_DEVICE ) ) )
      FWriteLine( nHandle, "SET DIRCASE........: " + strvalue( Set( _SET_DIRCASE ) ) )
      FWriteLine( nHandle, "SET DIRSEPARATOR...: " + strvalue( Set( _SET_DIRSEPARATOR ) ) )

      FWriteLine( nHandle, "SET EOL............: " + strvalue( Asc( Set( _SET_EOL ) ) ) )
      FWriteLine( nHandle, "SET EPOCH..........: " + strvalue( Set( _SET_EPOCH ) ) )
      FWriteLine( nHandle, "SET ERRORLOG.......: " + strvalue( cLogFile ) + "," + strvalue( lAppendLog ) )
#ifdef __XHARBOUR__
      FWriteLine( nHandle, "SET ERRORLOOP......: " + strvalue( Set( _SET_ERRORLOOP ) ) )
#endif
      FWriteLine( nHandle, "SET ESCAPE.........: " + strvalue( Set( _SET_ESCAPE ), .T. ) )
      FWriteLine( nHandle, "SET EVENTMASK......: " + strvalue( Set( _SET_EVENTMASK ) ) )
      FWriteLine( nHandle, "SET EXACT..........: " + strvalue( Set( _SET_EXACT ), .T. ) )
      FWriteLine( nHandle, "SET EXCLUSIVE......: " + strvalue( Set( _SET_EXCLUSIVE ), .T. ) )
      FWriteLine( nHandle, "SET EXIT...........: " + strvalue( Set( _SET_EXIT ), .T. ) )
      FWriteLine( nHandle, "SET EXTRA..........: " + strvalue( Set( _SET_EXTRA ), .T. ) )
      FWriteLine( nHandle, "SET EXTRAFILE......: " + strvalue( Set( _SET_EXTRAFILE ) ) )

      FWriteLine( nHandle, "SET FILECASE.......: " + strvalue( Set( _SET_FILECASE ) ) )
      FWriteLine( nHandle, "SET FIXED..........: " + strvalue( Set( _SET_FIXED ), .T. ) )
      FWriteLine( nHandle, "SET FORCEOPT.......: " + strvalue( Set( _SET_FORCEOPT ), .T. ) )

      FWriteLine( nHandle, "SET HARDCOMMIT.....: " + strvalue( Set( _SET_HARDCOMMIT ), .T. ) )

      FWriteLine( nHandle, "SET IDLEREPEAT.....: " + strvalue( Set( _SET_IDLEREPEAT ), .T. ) )
      FWriteLine( nHandle, "SET INSERT.........: " + strvalue( Set( _SET_INSERT ), .T. ) )
      FWriteLine( nHandle, "SET INTENSITY......: " + strvalue( Set( _SET_INTENSITY ), .T. ) )

      FWriteLine( nHandle, "SET LANGUAGE.......: " + strvalue( Set( _SET_LANGUAGE ) ) )

      FWriteLine( nHandle, "SET MARGIN.........: " + strvalue( Set( _SET_MARGIN ) ) )
      FWriteLine( nHandle, "SET MBLOCKSIZE.....: " + strvalue( Set( _SET_MBLOCKSIZE ) ) )
      FWriteLine( nHandle, "SET MCENTER........: " + strvalue( Set( _SET_MCENTER ), .T. ) )
      FWriteLine( nHandle, "SET MESSAGE........: " + strvalue( Set( _SET_MESSAGE ) ) )
      FWriteLine( nHandle, "SET MFILEEXT.......: " + strvalue( Set( _SET_MFILEEXT ) ) )

      FWriteLine( nHandle, "SET OPTIMIZE.......: " + strvalue( Set( _SET_OPTIMIZE ), .T. ) )
#ifdef __XHARBOUR__
      FWriteLine( nHandle, "SET OUTPUTSAFETY...: " + strvalue( Set( _SET_OUTPUTSAFETY ), .T. ) )
#endif

      FWriteLine( nHandle, "SET PATH...........: " + strvalue( Set( _SET_PATH ) ) )
      FWriteLine( nHandle, "SET PRINTER........: " + strvalue( Set( _SET_PRINTER ), .T. ) )
#ifdef __XHARBOUR__
      FWriteLine( nHandle, "SET PRINTERJOB.....: " + strvalue( Set( _SET_PRINTERJOB ) ) )
#endif
      FWriteLine( nHandle, "SET PRINTFILE......: " + strvalue( Set( _SET_PRINTFILE ) ) )

      FWriteLine( nHandle, "SET SCOREBOARD.....: " + strvalue( Set( _SET_SCOREBOARD ), .T. ) )
      FWriteLine( nHandle, "SET SCROLLBREAK....: " + strvalue( Set( _SET_SCROLLBREAK ), .T. ) )
      FWriteLine( nHandle, "SET SOFTSEEK.......: " + strvalue( Set( _SET_SOFTSEEK ), .T. ) )
      FWriteLine( nHandle, "SET STRICTREAD.....: " + strvalue( Set( _SET_STRICTREAD ), .T. ) )

#ifdef __XHARBOUR__
      FWriteLine( nHandle, "SET TRACE..........: " + strvalue( Set( _SET_TRACE ), .T. ) )
      FWriteLine( nHandle, "SET TRACEFILE......: " + strvalue( Set( _SET_TRACEFILE ) ) )
      FWriteLine( nHandle, "SET TRACESTACK.....: " + strvalue( Set( _SET_TRACESTACK ) ) )
#endif
      FWriteLine( nHandle, "SET TRIMFILENAME...: " + strvalue( Set( _SET_TRIMFILENAME ) ) )

      FWriteLine( nHandle, "SET TYPEAHEAD......: " + strvalue( Set( _SET_TYPEAHEAD ) ) )

      FWriteLine( nHandle, "SET UNIQUE.........: " + strvalue( Set( _SET_UNIQUE ), .T. ) )

      FWriteLine( nHandle, "SET VIDEOMODE......: " + strvalue( Set( _SET_VIDEOMODE ) ) )

      FWriteLine( nHandle, "SET WRAP...........: " + strvalue( Set( _SET_WRAP ), .T. ) )


      FWriteLine( nHandle, "" )

      IF nCols > 0
         FWriteLine( nHandle, PadC( "Detailed Work Area Items", nCols, "-" ) )
      ELSE
         FWriteLine( nHandle, "Detailed Work Area Items " )
      ENDIF
      FWriteLine( nHandle, "" )

      hb_WAEval( {||
         IF hb_IsFunction( "Select" )
            FWriteLine( nHandle, "Work Area No ......: " + strvalue( Do( "Select" ) ) )
         ENDIF
         IF hb_IsFunction( "Alias" )
            FWriteLine( nHandle, "Alias .............: " + Do( "Alias" ) )
         ENDIF
         IF hb_IsFunction( "RecNo" )
            FWriteLine( nHandle, "Current Recno .....: " + strvalue( Do( "RecNo" ) ) )
         ENDIF
         IF hb_IsFunction( "dbFilter" )
            FWriteLine( nHandle, "Current Filter ....: " + Do( "dbFilter" ) )
         ENDIF
         IF hb_IsFunction( "dbRelation" )
            FWriteLine( nHandle, "Relation Exp. .....: " + Do( "dbRelation" ) )
         ENDIF
         IF hb_IsFunction( "IndexOrd" )
            FWriteLine( nHandle, "Index Order .......: " + strvalue( Do( "IndexOrd" ) ) )
         ENDIF
         IF hb_IsFunction( "IndexKey" )
            FWriteLine( nHandle, "Active Key ........: " + strvalue( Eval( hb_macroBlock( "IndexKey( 0 )" ) ) ) )
         ENDIF
         FWriteLine( nHandle, "" )
         RETURN .T.
         } )

      FWriteLine( nHandle, "" )
      IF nCols > 0
         FWriteLine( nHandle, PadC( " Internal Error Handling Information  ", nCols, "-" ) )
      ELSE
         FWriteLine( nHandle, " Internal Error Handling Information  " )
      ENDIF
      FWriteLine( nHandle, "" )
      FWriteLine( nHandle, "Subsystem Call ....: " + oErr:subsystem() )
      FWriteLine( nHandle, "System Code .......: " + strvalue( oErr:suBcode() ) )
      FWriteLine( nHandle, "Default Status ....: " + strvalue( oErr:candefault() ) )
      FWriteLine( nHandle, "Description .......: " + oErr:description() )
      FWriteLine( nHandle, "Operation .........: " + oErr:operation() )
      FWriteLine( nHandle, "Arguments .........: " + Arguments( oErr ) )
      FWriteLine( nHandle, "Involved File .....: " + oErr:filename() )
      FWriteLine( nHandle, "Dos Error Code ....: " + strvalue( oErr:oscode() ) )
      FWriteLine( nHandle, "                   : " + PS_OS_ERR( oErr:oscode() ) )

#ifdef __XHARBOUR__
#ifdef HB_THREAD_SUPPORT
      FWriteLine( nHandle, "Running threads ...: " + strvalue( oErr:RunningThreads() ) )
      FWriteLine( nHandle, "VM thread ID ......: " + strvalue( oErr:VmThreadId() ) )
      FWriteLine( nHandle, "OS thread ID ......: " + strvalue( oErr:OsThreadId() ) )
#endif
#endif

      FWriteLine( nHandle, "" )
      FWriteLine( nHandle, " Trace Through:" )
      FWriteLine( nHandle, "----------------" )

      FWriteLine( nHandle, PadR( err_ProcName( oErr, 3 ), 21 ) + " : " + Transform( err_ProcLine( oErr, 3 ), "999,999" ) + " in Module: " + err_ModuleName( oErr, 3 ) )

      nCount := 3
      WHILE ! Empty( ProcName( ++nCount ) )
         FWriteLine( nHandle, PadR( ProcName( nCount ), 21 ) + " : " + Transform( ProcLine( nCount ), "999,999" ) + " in Module: " + ProcFile( nCount ) )
      ENDDO

      FWriteLine( nHandle, "" )
      FWriteLine( nHandle, "" )

      IF HB_ISSTRING( cScreen )
         FWriteLine( nHandle, PadC( " Video Screen Dump ", nCols, "#" ) )
         FWriteLine( nHandle, "" )
         FWriteLine( nHandle, "+" + Replicate( "-", nCols + 1 ) + "+" )
         FOR nCount := 0 TO nRows
            cOutString := ""
            FOR nForLoop := 0 TO nCols
               cOutString += __XSaveGetChar( cScreen, nCount * ( nCols + 1 ) + nForLoop )
            NEXT
            FWriteLine( nHandle, "|" + cOutString + "|" )
         NEXT
         FWriteLine( nHandle, "+" + Replicate( "-", nCols + 1 ) + "+" )
         FWriteLine( nHandle, "" )
         FWriteLine( nHandle, "" )
      ELSE
         FWriteLine( nHandle, " Video Screen Dump not available" )
      ENDIF

#if 0
      /* NOTE: Adapted from hb_mvSave() source in Harbour RTL. [vszakats] */
      LOCAL nScope, nCount, tmp, cName, xValue

      FWriteLine( nHandle, PadC( " Available Memory Variables ", nCols, "+" ) )
      FWriteLine( nHandle, "" )

      FOR EACH nScope IN { HB_MV_PUBLIC, HB_MV_PRIVATE }
         nCount := __mvDbgInfo( nScope )
         FOR tmp := 1 TO nCount
            xValue := __mvDbgInfo( nScope, tmp, @cName )
            IF ValType( xValue ) $ "CNDTL"
               FWriteLine( nHandle, "      " + cName + " TYPE " + ValType( xValue ) + " " + hb_CStr( xValue ) )
            ENDIF
         NEXT
      NEXT
#endif

      IF lAppendLog .AND. nHandle2 != F_ERROR

         nBytes := FSeek( nHandle2, 0, FS_END )

         cBuff := Space( 10 )
         FSeek( nHandle2, 0, FS_SET )

         WHILE nBytes > 0
            nRead := FRead( nHandle2, @cBuff, hb_BLen( cBuff ) )
            FWrite( nHandle, cBuff, nRead )
            nBytes -= nRead
            cBuff := Space( 10 )
         ENDDO

         FClose( nHandle2 )
         FClose( nHandle )

         FErase( cLogFile )
         FRename( cLogFile2, cLogFile )
      ELSE
         FClose( nHandle )
      ENDIF

   ENDIF

   RETURN .F.

STATIC FUNCTION strvalue( c, l )

   LOCAL cr := ""

   __defaultNIL( @l, .F. )

   SWITCH ValType( c )
   CASE "C"
      cr := c
      EXIT
   CASE "N"
      cr := hb_ntos( c )
      EXIT
   CASE "M"
      cr := c
      EXIT
   CASE "D"
      cr := DToC( c )
      EXIT
   CASE "L"
      cr := iif( l, iif( c, "On", "Off" ), iif( c, ".T.", ".F." ) )
      EXIT
   ENDSWITCH

   RETURN Upper( cr )

STATIC PROCEDURE FWriteLine( nh, c )

   FWrite( nh, c + hb_eol() )
   // hb_OutDebug( c + hb_eol() )

   RETURN

STATIC FUNCTION Arguments( oErr )

   LOCAL xArg, cArguments := ""

   IF HB_ISARRAY( oErr:Args )
      FOR EACH xArg IN oErr:Args
         cArguments += " [" + Str( xArg:__EnumIndex(), 2 ) + "] = Type: " + ValType( xArg )

         IF xArg != NIL
            cArguments +=  " Val: " + hb_CStr( xArg )
         ENDIF
      NEXT
   ENDIF

   RETURN cArguments

FUNCTION __ErrorBlock()

   RETURN {| e | __MinimalErrorHandler( e ) }

PROCEDURE __MinimalErrorHandler( oError )

   LOCAL cError
   LOCAL xData

   cError := "Error"
   IF HB_ISNUMERIC( oError:SubCode )
      cError += ": " + hb_ntos( oError:SubCode )
   ENDIF
   cError += "!" + hb_eol()

   IF HB_ISSTRING( oError:Operation )
      cError += "Operation: " + oError:Operation + hb_eol()
   ENDIF
   IF HB_ISSTRING( oError:Description )
      cError += "Description: " + oError:Description + hb_eol()
   ENDIF
   IF HB_ISSTRING( xData := err_ModuleName( oError ) )
      cError += "Source: " + xData + hb_eol()
   ENDIF
   IF HB_ISSTRING( xData := err_ProcName( oError ) )
      cError += "Procedure: " + xData + hb_eol()
   ENDIF
   IF HB_ISNUMERIC( xData := err_ProcLine( oError ) )
      cError += "Line: " + hb_ntos( xData ) + hb_eol()
   ENDIF

   OutStd( cError )

   QUIT

   RETURN
   
   
   *+¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
*+
*+    Function PS_OS_ERR()
*+
*+    Called from ( errorsys.prg )   1 - static function deferror()
*+
*+¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
*+
function PS_OS_ERR( Arg1 )

do case
	case Arg1 == 1
	   return "Numero Invalido da Funcao"
	case Arg1 == 2
	   return "Arquivo nao Encontrado"
	case Arg1 == 3
	   return "Caminho nao Encontrado"
	case Arg1 == 4
	   return "Muitos Arquivos Abertos"
	case Arg1 == 5
	   return "Acesso Negado"
	case Arg1 == 6
	   return "Referencia Arquivo Invalido"
	case Arg1 == 7
	   return "Blocos Memorias Destruidos"
	case Arg1 == 8
	   return "Memoria Insuficiente"
	case Arg1 == 9
	   return "Erro de Memoria Invalido"
	case Arg1 == 10
	   return "Ambiente Invalido"
	case Arg1 == 11
	   return "Formato Invalido"
	case Arg1 == 12
	   return "Acesso de Codigo Invalido"
	case Arg1 == 13
	   return "Data Invalida"
	case Arg1 == 14
	   return "Reservado"
	case Arg1 == 15
	   return "Drive Invalido"
	case Arg1 == 16
	   return "Tentando Remover diretorio Atual"
	case Arg1 == 17
	   return "Nao e o mesmo Dispositivo"
	case Arg1 == 18
	   return "Sem mais Arquivos"
	case Arg1 == 19
	   return "Tentanod Escrever disquete-Travada"
	case Arg1 == 20
	   return "Unidade Desconhecido"
	case Arg1 == 21
	   return "Unidade nao Preparada"
	case Arg1 == 22
	   return "Comando Desconhecido"
	case Arg1 == 23
	   return "Data erro (CRC)"
	case Arg1 == 24
	   return "Erro no Tamanho Estrutura"
	case Arg1 == 25
	   return "Erro de Busca"
	case Arg1 == 26
	   return "Media Desconhecido"
	case Arg1 == 27
	   return "Setor nao Encontrado"
	case Arg1 == 28
	   return "Impressora sem Papel"
	case Arg1 == 29
	   return "Erro de Escrita"
	case Arg1 == 30
	   return "Erro de Leitura"
	case Arg1 == 31
	   return "Falha Geral"
	case Arg1 == 32
	   return "Violacao de Compartilhamento"
	case Arg1 == 33
	   return "Violacao de Travamento"
	case Arg1 == 34
	   return "Mudanca de Disco Errada"
	case Arg1 == 35
	   return "FCB nao disponivel"
	case Arg1 == 36
	   return "Estouro do buffer de compartilhamento"
	case Arg1 >= 37 .and. Arg1 <= 49
	   return "Reservado"
	case Arg1 == 50
	   return "Requisicao a Rede Nao Suportada"
	case Arg1 == 51
	   return "Computador Remoto nao respondendo"
	case Arg1 == 52
	   return "Nome Duplicado na Rede"
	case Arg1 == 53
	   return "Nao Encontrado nome na Rede"
	case Arg1 == 54
	   return "Rede Ocupada"
	case Arg1 == 55
	   return "Dispositivo da rede nao mais disponivel"
	case Arg1 == 56
	   return "Comando da Rede BIOS execedeu limite"
	case Arg1 == 57
	   return "Erro no Adaptador da Rede"
	case Arg1 == 58
	   return "Resposta Incorreta da Rede"
	case Arg1 == 59
	   return "Erro Inesperado na Rede"
	case Arg1 == 60
	   return "Adaptador Remotor Imcompativel"
	case Arg1 == 61
	   return "File Impressora Cheia"
	case Arg1 == 62
	   return "Sem espaco para imprimir o arquivo"
	case Arg1 == 63
	   return "Arquivo Impressora deletado (sem espaco suficiente)"
	case Arg1 == 64
	   return "Nome da Rede deletedo"
	case Arg1 == 65
	   return "Acesso Negado"
	case Arg1 == 66
	   return "Dispositivo da Rede Incorreto"
	case Arg1 == 67
	   return "Nao encontrado nome da Rede"
	case Arg1 == 68
	   return "Nome da Rede excede Limites"
	case Arg1 == 69
	   return "Sessao da rede BIOS excedeu"
	case Arg1 == 70
	   return "Pausa Temporaria"
	case Arg1 == 71
	   return "Requisicao a Rede nao aceita"
	case Arg1 == 72
	   return "Impressao ou Disco redirecao "
	case Arg1 >= 73 .and. Arg1 <= 79
	   return "Reservado"
	case Arg1 == 80
	   return "Arquivo ja Existente"
	case Arg1 == 81
	   return "Reservado"
	case Arg1 == 82
	   return "Nao pode ser criada entrada do diretorio"
	case Arg1 == 83
	   return "Falha na INT 24H"
	case Arg1 == 84
	   return "Muitas redicionamentos"
	case Arg1 == 85
	   return "Redicionamento"
	case Arg1 == 86
	   return "Senha Invalida"
	case Arg1 == 87
	   return "Parametro Invalido"
	case Arg1 == 88
	   return "Falha no Dispositivo da Rede" 
	case   arg1 == 89
		return"NENHUM ERRO OCORRIDO!"
	case  arg1 == 90
	   return "erro de sistema."
	case  arg1 == 91
		   return "Temporizador da tabela do serviço de transbordo."
	case  arg1 == 92 
		   return "Temporizador serviço tabela duplicar."
	case  arg1 == 93 
		   return "Nenhum item para trabalhar."
	case  arg1 == 95 
		   return "chamada de sistema interrompida."
	case  arg1 == 99
		   return "Dispositivo em uso."
	case  arg1 ==100
		   return "usuário / sistema de limite de abertura do semáforo atingido."
	case  arg1 ==101
		   return "Exclusivo semáforo já possuía."
	case  arg1 ==102
		   return "DosCloseSem encontrada conjunto de semáforos."
	case  arg1 ==103
		   return "Há muitas solicitações de semáforos exclusivos."
	case  arg1 ==104
		   return "Operação inválida em tempo de interrupção."
	case  arg1 ==105
		   return "proprietário do semáforo anterior encerrado sem libertar semáforo."
	case arg1 ==106 
		   return "limite de Semaphore excedido."
	case  arg1 ==107 
		   return "Insira o disco rígido B na unidade A."
	case arg1 ==108 
		   return "Unidade bloqueado por outro processo."
	case  arg1 ==109
		   return "Escreva no tubo com nenhum leitor."
	case  arg1 ==110
		   return "Open / Create falhou devido a ordem explícita falhar."
	case  arg1 ==111
		   return "Tampão passado para chamada de sistema muito pequeno para armazenar dados de retorno."
	case  arg1 ==112
		   return "Não há espaço suficiente no disco. Disco Cheio. Chame o Tecnico."
	case arg1 ==113
		   return "Não é possível alocar uma outra estrutura de pesquisa e manusear."
	case   arg1 ==114
		   return "Alvo punho em DosDupHandle inválido."
	case  arg1 ==115
		   return "Usuário inválido endereço virtual."
	case  arg1 ==116
		   return "Erro na gravação de exibição ou o teclado ler."
	case  arg1 ==117
		   return "Categoria de DevIOCtl não definido."
	case  arg1 ==118
		   return "valor inválido passado para verificar bandeira."
	case  arg1 ==119
		   return "Nível quatro motorista não foi encontrado."
	case  arg1 ==120
		   return "Função Chamada inválida."   
endcase
return "<Outros>"
