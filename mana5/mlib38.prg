// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : mlib38.prg
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
// +    Documentado em 28-Dez-2024 as  9:58 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


#require "hbsqlit3"
#include "INKEY.CH"



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FIXAR()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FIXAR( P01, lINDEX )

   LOCAL cDBF := Alias()
   LOCAL res  := .F.

   IF ValType( lINDEX ) # "L"
      lINDEX := .T.
   ENDIF
   WHILE .T.
      IF USEREDE( P01, 0, if( lINDEX, 99, 0 ) )
         MDS( "Reorganizando arquivo, por favor aguarde..." + P01 )
         PACK
         dbGoTop()
         dbCloseArea()
         RES := .T.
         EXIT
      ELSE
         MDS( "Tentando reorganizar arquivo ... (F2 desiste)" )
         KEY := Inkey( 2 )
         IF KEY = K_F2 .OR. KEY = K_ESC
            GRAVALOG( "Funcao Fixar - Usado Esc" )
            EXIT
         ENDIF
      ENDIF
   ENDDO
   dbCloseArea()
   IF !Empty( cDBF )
      dbSelectAr( cDBF )
   ENDIF

   RETURN RES



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function GRAVALOG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION GRAVALOG

   PARA cERRO, cOPR, cARQ  // recebe os parametros aqui para ter scopo privadas
   LOCAL cDBF      := Alias()
   LOCAL cARQVAZIO := ""
   LOCAL cCAMERRO  := ""
   LOCAL csql      := ""
   LOCAL oDB

   IF ValType( cERRO ) = "U"
      cERRO := ""
   ENDIF
   IF ValType( cOPR ) = "U"
      cOPR := ""
   ENDIF
   IF ValType( cARQ ) = "U"
      cDBF := Alias()
   ENDIF
   IF cARQ = "MANARQ" .OR. cARQ = "MANARQ1" .OR. Left( cARQ, 5 ) = "MUSER"  // nao grava para evitar loop infinito
      RETURN .T.
   ENDIF
   IF zTIPERRO = "DBF" .AND. cARQ = zARQERRO
      RETURN .T.
   ENDIF


   IF Empty( zTIPERRO )
      cARQVAZIO := Lower( ProfileString( "MANA5.INI", "PATH", "LOG", "MANERR.DBF" ) )
      DO CASE
      CASE At( ".sqlite", carqvazio ) > 0
         zTIPERRO := "SQLITE"
      CASE At( ".mdb", carqvazio ) > 0
         zTIPERRO := "MDB"
      OTHERWISE
         zTIPERRO := "DBF"
      ENDCASE
   ENDIF


   IF Empty( ZARQERRO )
      cARQVAZIO := ProfileString( "MANA5.INI", "PATH", "LOG", "" )
      cCAMERRO  := ProfileString( "MANA5.INI", "PATH", "LOGCAM", hb_cwd() + "\LOG" )
      ZARQERRO  := cCAMERRO + "log" + StrZero( zANO, 4, 0 ) + StrZero( zmes, 2, 0 ) + "." + Lower( zTIPERRO )
      IF zTIPERRO = "SQLITE" .OR. zTIPERRO = "MDB"
         IF ! File( ZARQERRO )
            filecopy( cARQVAZIO, ZARQERRO )
         ENDIF
      ENDIF
      IF zTIPERRO = "DBF"
         ZARQERRO := "ER" + StrZero( Day( ZDATA ), 2 ) + StrZero( Month( ZDATA ), 2 ) + SubStr( StrZero( Year( ZDATA ), 4 ), 3, 2 )
         CHECKARQ( "MANERR", ZARQERR,,, ZDIRP + "LOG\", Year( ZDATA ), Month( ZDATA ) )  // mantendo caminho original mudar para logcam posteriormente checar inclusao manarq
      ENDIF
   ENDIF


   cARQ  := AllTrim( cARQ )
   cARQ  := StrTran( cARQ, " ", "" )
   cERRO := AllTrim( STRVAL( cERRO ) )
   cERRO := StrTran( cERRO, " ", "" )

   DO CASE
   CASE zTIPERRO = "SQLITE"
      oDB := sqlite3_open( ZARQERRO, .F. )
      IF oDB == Nil
      ELSE

         cSQL := "INSERT INTO manerr ( usuario,  data, hora, erro, opr, arquivo  )  VALUES ("
         cSQL := cSQL + "'" + ZUSER + "',"
         cSQL := cSQL + " current_timestamp,"
         cSQL := cSQL + "'" + Left( Time(), 5 ) + "',"
         cSQL := cSQL + "'" + Cerro + "',"
         cSQL := cSQL + "'" + Copr + "',"
         cSQL := cSQL + "'" + Carq + "'"
         cSQL := cSQL + " );"


         sqlite3_exec( odb, csql )
         IF sqlite3_errcode( odb ) > 0   // error
            Alert( sqlite3_errmsg( odb ) + " Query is : " + csql )
            // return .f.
         ENDIF
      ENDIF
      // MDB implantacao futura usando dbf por enquanto
   CASE zTIPERRO = "DBF" .OR. zTIPERRO = "MDB"
      GRAVALAY( { { "USUARIO", "DATA", "HORA", "ERRO", "ARQUIVO", "OPR" }, { "ZUSER", "DATE()", "LEFT(TIME(),5)", "cERRO", "cARQ", "cOPR" } }, ZARQERR,, .T.,, .T., )

   ENDCASE

// retorna area
   IF !Empty( cDBF )
      dbSelectAr( cDBF )
   ENDIF

   RETURN .T.


/*
*+--------------------------------------------------------------------
*+
*+
*+
*+
*+
*+
*+
*+    Function pegdiaerro()
*+
*+
*+
*+
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
*+
*+
*+
*+
func pegdiaerro

mDATA := ZDATA
@ 24,00 GET mDATA
READCUR()
retu "ER"+strzero(day(mDATA),2)+strzero(month(mDATA),2)+substr(strzero(year(mDATA),4),3,2)
*/

// + EOF: mlib38.prg
// +
