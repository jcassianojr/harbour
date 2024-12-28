// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mysqlrdd.prg
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
// +    Documentado em 28-Dez-2024 as 10:08 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *    MySQL RDD
 *
 * Copyright 2006 Gianluca Piemonte <info / at / areainformatica / dot / com>
 * www - http://www.harbour-project.org
 * www - http://www.xharbour.org
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
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
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

/*
 * This is an experimental RDD for xharbour/contrib/mysql interface.
 * It has been created to test the possibilities of usrrdd.
 * It doesn't support many functions and commands and many things could be optimized.
 */

#include "rddsys.ch"
#include "usrrdd.ch"
#include "fileio.ch"
#include "error.ch"
#include "dbstruct.ch"
#include "common.ch"

#define AREA_QUERY    1
#define AREA_ROW      2
#define AREA_APPEND   3

#define AREA_LEN      3

ANNOUNCE MYSQLRDD

STATIC s_aConnections := {}
STATIC oSERVER
STATIC aSTRUCAMPOS


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DBMYSQLCONNECTION()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION DBMYSQLCONNECTION( cConnString )

   LOCAL aParams

// LOCAL oServer
   LOCAL nConn
   LOCAL cHost
   LOCAL cDatabase
   LOCAL cUser
   LOCAL cPassword

   aParams := hb_ATokens( cConnString, ";" )

   ASize( aParams, 6 )

   cHost     := aParams[ 1 ]
   cDatabase := aParams[ 2 ]
   cUser     := aParams[ 3 ]
   cPassword := aParams[ 4 ]

   oServer := TMySQLServer():New( cHost, cUser, cPassword )

   IF oServer:NetErr()
      Alert( oServer:ErrorMsg() )
      RETURN 0
   ELSE
      oServer:SelectDB( cDataBase )
      AAdd( s_aConnections, oServer )
      nConn := Len( s_aConnections )
   ENDIF

   RETURN nConn


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DBMYSTRU()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION DBMYSTRU()

   RETURN aSTRUCAMPOS


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function DBMYSQLCLEARCONNECTION()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION DBMYSQLCLEARCONNECTION( nConn )

// LOCAL oServer

// oServer := s_aConnections[ nConn ]

   oServer:Destroy()

   s_aConnections[ nConn ] := nil

   RETURN SUCCESS

/*
 * non work area methods receive RDD ID as first parameter
 * Methods INIT and EXIT does not have to execute SUPER methods - these is
 * always done by low level USRRDD code
 */

// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_INIT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_INIT( nRDD )

   USRRDD_RDDDATA( nRDD )

   RETURN SUCCESS

/*
 * methods: NEW and RELEASE receive pointer to work area structure
 * not work area number. It's necessary because the can be executed
 * before work area is allocated
 * these methods does not have to execute SUPER methods - these is
 * always done by low level USRRDD code
 */

// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_NEW()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_NEW( pWA )

   USRRDD_AREADATA( pWA, Array( AREA_LEN ) )

   RETURN SUCCESS


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_OPEN()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_OPEN( nWA, aOpenInfo )

   LOCAL aField, oError, lError, cError, nResult
   LOCAL oQuery, aStruct, aFieldStruct
   LOCAL aWAData      := USRRDD_AREADATA( nWA )
   LOCAL nFIELDSCOUNT, iFIELDNUM, eTIPODECODE

   IF !Empty( oServer )
      oServer:lAllCols := .F.
      oQuery           := oServer:Query( aOpenInfo[ UR_OI_NAME ] )
      lError           := oQuery:NetErr()
      cError           := oQuery:ErrorMsg()
   ELSE
      lError := .T.
      cError := "Invalid connection handle"
   ENDIF

   IF lError
      oError             := ErrorNew()
      oError:GenCode     := EG_OPEN
      oError:SubCode     := 1000
      oError:Description := hb_langErrMsg( EG_OPEN ) + ", " + cError
      oError:FileName    := aOpenInfo[ UR_OI_NAME ]
      oError:CanDefault  := .T.
      UR_SUPER_ERROR( nWA, oError )
      RETURN FAILURE
   ELSE
      aWAData[ AREA_QUERY ] := oQuery
   ENDIF

   UR_SUPER_SETFIELDEXTENT( nWA, oQuery:nNumFields )



/*
    aStruct := oQuery:aFieldStruct //Struct()
   FOR EACH aFieldStruct IN aStruct

       //posicao dbs_name<>YSQL_FS_NAME e outras sao divergentes  usando oquery>field ja compativerl harbour
       //o tipo e  numerico necessario conversao para tipo C N D M ...

       aField := ARRAY( UR_FI_SIZE )
       aField[ UR_FI_NAME ]    := aFieldStruct[ DBS_NAME ]  //MYSQL_FS_NAME  FieldName( nNum )
       aField[ UR_FI_TYPE ]    := aFieldStruct[ DBS_TYPE ]   //FieldType( nNum )  MYSQL_FS_TYPE
       aField[ UR_FI_TYPEEXT ] := 0
       aField[ UR_FI_LEN ]     := aFieldStruct[ DBS_LEN ]   //MYSQL_FS_LENGTH FieldLen( nNum )
       aField[ UR_FI_DEC ]     := aFieldStruct[ DBS_DEC ]   //MYSQL_FS_DECIMALS  FieldDec(nnum)
       UR_SUPER_ADDFIELD( nWA, aField )

   NEXT
   */

   nFIELDSCOUNT := oQuery:nNumFields
   aSTRUCAMPOS  := {}
// usando oquery>field ja compativerl dbf fieldtype
// posicao difere uf_fi dbs_
/*
   #define UR_FI_SIZE            5
   #define UR_FI_NAME            1      DBS_NAME
   #define UR_FI_TYPE            2      DBS_TYPE
   #define UR_FI_TYPEEXT         3
   #define UR_FI_LEN             4      DBS_LEN
   #define UR_FI_DEC             5      DBS_DEC
   #define DBS_NAME        1
   #define DBS_TYPE        2
   #define DBS_LEN         3
   #define DBS_DEC         4


#ifndef HB_FT_NONE
#define HB_FT_NONE            0
#define HB_FT_STRING          1      "C"
#define HB_FT_LOGICAL         2      "L"
#define HB_FT_DATE            3      "D"
#define HB_FT_LONG            4      "N"
#define HB_FT_FLOAT           5      "F"
#define HB_FT_INTEGER         6      "I"
#define HB_FT_DOUBLE          7      "B"
#define HB_FT_TIME            8      "T"
#define HB_FT_TIMESTAMP       9      "@"
#define HB_FT_MODTIME         10     "="
#define HB_FT_ROWVER          11     "^"
#define HB_FT_AUTOINC         12     "+"
#define HB_FT_CURRENCY        13     "Y"
#define HB_FT_CURDOUBLE       14     "Z"
#define HB_FT_VARLENGTH       15     "Q"
#define HB_FT_MEMO            16     "M"
#define HB_FT_ANY             17     "V"
#define HB_FT_IMAGE           18     "P"
#define HB_FT_BLOB            19     "W"
#define HB_FT_OLE             20     "G"
#endif
*/

   FOR iFIELDNUM := 1 TO nFIELDSCOUNT
      eTIPODECODE := hb_Decode( oQUERY:FieldType( iFIELDNUM ), "C", HB_FT_STRING, "L", HB_FT_LOGICAL, "M", HB_FT_MEMO, "D", HB_FT_DATE, "N", iif( oQUERY:FieldDec( iFIELDNUM ) > 0, HB_FT_DOUBLE, HB_FT_INTEGER ) )
      // aField[ UR_FI_TYPE ]    := hb_Decode( aFieldStruct[ DBS_TYPE ], "C", HB_FT_STRING, "L", HB_FT_LOGICAL, "M", HB_FT_MEMO, "D", HB_FT_DATE, "N", iif( aFieldStruct[ DBS_DEC ] > 0, HB_FT_DOUBLE, HB_FT_INTEGER ) )
      // aField[ UR_FI_TYPE ]    := hb_Decode( oQUERY:FieldType( iFIELDNUM ) , "C", HB_FT_STRING, "L", HB_FT_LOGICAL, "M", HB_FT_MEMO, "D", HB_FT_DATE, "N", iif( aFieldStruct[ DBS_DEC ] > 0, HB_FT_DOUBLE, HB_FT_INTEGER ) )
      IF Empty( eTIPODECODE )
         eTIPODECODE := FT_STRING
      ENDIF

      aField                  := Array( UR_FI_SIZE )
      aField[ UR_FI_NAME ]    := oQUERY:FieldName( iFIELDNUM )
      aField[ UR_FI_TYPE ]    := eTIPODECODE   // oQUERY:FieldType( iFIELDNUM )
      aField[ UR_FI_TYPEEXT ] := 0
      aField[ UR_FI_LEN ]     := oQUERY:FieldLen( iFIELDNUM )
      aField[ UR_FI_DEC ]     := oQUERY:FieldDec( iFIELDNUM )
      UR_SUPER_ADDFIELD( nWA, aField )
      AAdd( aSTRUCAMPOS, { oQUERY:FieldName( iFIELDNUM ), oQUERY:FieldType( iFIELDNUM ), oQUERY:FieldLen( iFIELDNUM ), oQUERY:FieldDec( iFIELDNUM ), eTIPODECODE } )  // grava tambem na static pegar via funcao DBMYSTRU()
   NEXT iFIELDNUM


/* Call SUPER OPEN to finish allocating work area (f.e.: alias settings) */
   nResult := UR_SUPER_OPEN( nWA, aOpenInfo )

   RETURN nResult


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_CLOSE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_CLOSE( nWA )

   LOCAL aWAData := USRRDD_AREADATA( nWA )

   aWAData[ AREA_QUERY ]:Close()

   RETURN UR_SUPER_CLOSE( nWA )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_GETVALUE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_GETVALUE( nWA, nField, xValue )

   LOCAL aWAData := USRRDD_AREADATA( nWA )

   IF !Empty( aWAData[ AREA_ROW ] )
      xValue := aWAData[ AREA_ROW ]:FieldGet( nField )
   ELSE
      xValue := aWAData[ AREA_QUERY ]:FieldGet( nField )
   ENDIF

   RETURN SUCCESS


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_PUTVALUE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_PUTVALUE( nWA, nField, xValue )

   LOCAL aWAData := USRRDD_AREADATA( nWA )

   IF Empty( aWAData[ AREA_ROW ] )
      aWAData[ AREA_ROW ] := aWAData[ AREA_QUERY ]:GetRow()
   ENDIF

   aWAData[ AREA_ROW ]:FieldPut( nField, xValue )

   RETURN SUCCESS


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_SKIP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_SKIP( nWA, nRecords )

   LOCAL aWAData := USRRDD_AREADATA( nWA )

   IF !Empty( aWAData[ AREA_ROW ] )
      MYSQL_FLUSH( nWA )
   ENDIF

   aWAData[ AREA_QUERY ]:Skip( nRecords )

   RETURN SUCCESS


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_GOTOP()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_GOTOP( nWA )

   RETURN MYSQL_GOTO( nWA, 1 )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_GOBOTTOM()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_GOBOTTOM( nWA )

   RETURN MYSQL_GOTO( nWA, - 1 )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_GOTOID()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_GOTOID( nWA, nRecord )

   RETURN MYSQL_GOTO( nWA, nRecord )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_GOTO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_GOTO( nWA, nRecord )

   LOCAL aWAData := USRRDD_AREADATA( nWA )

   IF ( ValType( nRecord ) != "N" )  // IF added to prevent error
      nRecord := 0
   ENDIF

   IF !Empty( aWAData[ AREA_ROW ] )
      MYSQL_FLUSH( nWA )
   ENDIF

   IF nRecord < 0
      nRecord := aWAData[ AREA_QUERY ]:LastRec()
   ELSEIF nRecord == 0
      nRecord := aWAData[ AREA_QUERY ]:RecNo()
   ENDIF

   aWAData[ AREA_QUERY ]:Goto( nRecord )

   RETURN SUCCESS


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_RECCOUNT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_RECCOUNT( nWA, nRecords )

   LOCAL aWAData := USRRDD_AREADATA( nWA )

   nRecords := aWAData[ AREA_QUERY ]:LastRec()

   RETURN SUCCESS


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_BOF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_BOF( nWA, lBof )

   LOCAL aWAData := USRRDD_AREADATA( nWA )

   lBof := aWAData[ AREA_QUERY ]:Bof()

   RETURN SUCCESS


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_EOF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_EOF( nWA, lEof )

   LOCAL aWAData := USRRDD_AREADATA( nWA )

   lEof := aWAData[ AREA_QUERY ]:Eof()

   RETURN SUCCESS


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_RECID()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_RECID( nWA, nRecNo )

   LOCAL aWAData := USRRDD_AREADATA( nWA )

   nRecno := aWAData[ AREA_QUERY ]:RecNo()

   RETURN SUCCESS


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_DELETED()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_DELETED( nWA, lDeleted )

   ( nWA )
   lDeleted := .F.

   RETURN SUCCESS


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_FLUSH()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_FLUSH( nWA )

   LOCAL oError
   LOCAL aWAData := USRRDD_AREADATA( nWA )
   LOCAL nRecno

   IF aWAData[ AREA_ROW ] != nil
      IF !Empty( aWAData[ AREA_APPEND ] )
         aWAData[ AREA_QUERY ]:Append( aWAData[ AREA_ROW ] )
      ELSE
         nRecno := aWAData[ AREA_QUERY ] :nRecNo
         aWAData[ AREA_QUERY ]:Update( aWAData[ AREA_ROW ] )
      ENDIF

      IF aWAData[ AREA_QUERY ] :lError
         oError             := ErrorNew()
         oError:GenCode     := EG_DATATYPE
         oError:SubCode     := 3000
         oError:Description := hb_langErrMsg( EG_DATATYPE ) + ", " + aWAData[ AREA_QUERY ]:ErrorMsg()
         UR_SUPER_ERROR( nWA, oError )
         RETURN FAILURE
      ENDIF

   /*
 * The :Refresh() below costs a lot in term of performance.
 * It redo the select to include inserts and updates.
 * It is the only solution I've found so far to simulate dbf behaviour
 */
      aWAData[ AREA_QUERY ]:Refresh( .T., .F. )

      IF !Empty( aWAData[ AREA_APPEND ] )
         aWAData[ AREA_APPEND ] := .F.
         nRecno                 := aWAData[ AREA_QUERY ]:LastRec()
      ENDIF

      aWAData[ AREA_ROW ] := nil

      MYSQL_GOTO( nWA, nRecno )

   ENDIF

   RETURN SUCCESS


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_APPEND()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_APPEND( nWA, nRecords )

   LOCAL aWAData := USRRDD_AREADATA( nWA )

   ( nRecords )
   aWAData[ AREA_ROW ] := aWAData[ AREA_QUERY ]:GetBlankRow()

   aWAData[ AREA_APPEND ] := .T.

   RETURN SUCCESS


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function MYSQL_DELETE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION MYSQL_DELETE( nWA )

   LOCAL oError
   LOCAL aWAData := USRRDD_AREADATA( nWA )

   aWAData[ AREA_ROW ] := aWAData[ AREA_QUERY ]:GetRow()

   aWAData[ AREA_QUERY ]:Delete( aWAData[ AREA_ROW ] )

   IF aWAData[ AREA_QUERY ] :lError
      oError             := ErrorNew()
      oError:GenCode     := EG_DATATYPE
      oError:SubCode     := 2000
      oError:Description := hb_langErrMsg( EG_DATATYPE ) + ", " + aWAData[ AREA_QUERY ]:ErrorMsg()
      UR_SUPER_ERROR( nWA, oError )
      RETURN FAILURE
   ENDIF

   aWAData[ AREA_ROW ] := nil

   RETURN SUCCESS

/*
 * This function have to exist in all RDD and then name have to be in
 * format: <RDDNAME>_GETFUNCTABLE
 */

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MYSQLRDD_GETFUNCTABLE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MYSQLRDD_GETFUNCTABLE( pFuncCount, pFuncTable, pSuperTable, nRddID )

   LOCAL cSuperRDD := NIL /* NO SUPER RDD */
   LOCAL aMyFunc[ UR_METHODCOUNT ]

   aMyFunc[ UR_INIT ]     := ( @MYSQL_INIT() )
   aMyFunc[ UR_NEW ]      := ( @MYSQL_NEW() )
   aMyFunc[ UR_OPEN ]     := ( @MYSQL_OPEN() )
   aMyFunc[ UR_GETVALUE ] := ( @MYSQL_GETVALUE() )
   aMyFunc[ UR_PUTVALUE ] := ( @MYSQL_PUTVALUE() )
   aMyFunc[ UR_SKIP ]     := ( @MYSQL_SKIP() )
   aMyFunc[ UR_GOTO ]     := ( @MYSQL_GOTO() )
   aMyFunc[ UR_GOTOID ]   := ( @MYSQL_GOTOID() )
   aMyFunc[ UR_GOTOP ]    := ( @MYSQL_GOTOP() )
   aMyFunc[ UR_GOBOTTOM ] := ( @MYSQL_GOBOTTOM() )
   aMyFunc[ UR_RECNO ]    := ( @MYSQL_RECID() )
   aMyFunc[ UR_RECCOUNT ] := ( @MYSQL_RECCOUNT() )
   aMyFunc[ UR_RECID ]    := ( @MYSQL_RECID() )
   aMyFunc[ UR_BOF ]      := ( @MYSQL_BOF() )
   aMyFunc[ UR_EOF ]      := ( @MYSQL_EOF() )
   aMyFunc[ UR_DELETED ]  := ( @MYSQL_DELETED() )
   aMyFunc[ UR_FLUSH ]    := ( @MYSQL_FLUSH() )
   aMyFunc[ UR_APPEND ]   := ( @MYSQL_APPEND() )
   aMyFunc[ UR_DELETE ]   := ( @MYSQL_DELETE() )
   aMyFunc[ UR_CLOSE ]    := ( @MYSQL_CLOSE() )

   RETURN USRRDD_GETFUNCTABLE( pFuncCount, pFuncTable, pSuperTable, nRddID, ;
      cSuperRDD, aMyFunc )


// +--------------------------------------------------------------------
// +
// +
// +
// +    Init Procedure MYSQL_INIT()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
INIT PROC MYSQL_INIT()

   rddRegister( "MYSQLRDD", RDT_FULL )

   RETURN

// + EOF: mysqlrdd.prg
// +
