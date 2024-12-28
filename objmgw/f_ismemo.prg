// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : f_ismemo.prg
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
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

#include "dbinfo.ch"
// ****************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ISMEMO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ISMEMO( cARQ, lMES, lINFO )

// ****************************************************************
   LOCAL cMES, lRETU, i
   IF ValType( lMES ) # "L"
      lMES := .F.
   ENDIF
   IF ValType( lINFO ) # "L"
      lINFO := .T.
   ENDIF

   lRETU := .F.
   cMES  := "Parece Nao Ser DBF"
   IF NETUSE( cARQ,,,,, .F., )
      // FUNCTION ShortTableHasMemoField()Return Ascan( dbStruct(), {|x| x[ 2] == 'M'}) != 0
      IF AScan( dbStruct(), {| x | x[ 2 ] == 'M' } ) != 0
         lRETU := .T.
      ENDIF
      // for i:=1 to FCount()
      // if FieldType( i ) == "M"
      // lRETU:=.T.
      // exit
      // endif
      // NEXT
      dbCloseArea()
   ELSE
      cMES := "Nao foi possivel abrir: "
   ENDIF
   IF lINFO
      Infotipodbf( cARQ, lMES )
   ELSE
      IF Lmes
         ALERTX( cMES + ": " + cARQ )
      ENDIF
   ENDIF

   RETURN lRETU


// ****************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function INFOTIPODBF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION INFOTIPODBF( filename, lMES )

// ****************************************************************
   LOCAL buffer := ' ', handle, ret_value, cMES

   IF At( ".", filename ) = 0
      filename := Trim( filename ) + ".DBF"
   ENDIF
   IF ValType( lMES ) # "L"
      lMES := .F.
   ENDIF

//
// Retorna 0 Se Nao For DBF
//
   ret_value := 0  // Unknown:=0 ou -2 se nao conseguir abrir o arquivo
   cMES      := "Parece Nao Ser DBF"

   handle := hb_FOPEN( filename, 0 )


// Se nao ocorrer erro na abertura, carrega o primeiro byte.
   IF FError() = 0 .AND. FRead( handle, @buffer, 1 ) = 1

   /*
 https://github.com/X-Sharp/XSharpPublic/blob/main/Runtime/XSharp.Rdd/Enums.prg#L105
        MEMBER Flagship248WithDBV := 0x33 51
        MEMBER VOWithMemo := 0x87   135
        MEMBER dBase4SQLTableWithMemo:=0xcb  203

     //melhorias para escolher
  OPCAO( 14, 24, "D&BTCDX DBF CDX MEMO=DBT", 66 ) //B 7 rddSetDefault( "DBTCDX" ) ou "DBFNTX"
  OPCAO( 16, 24, "&FPTCDX DBF CDX MEMO=FPT", 70 ) //F 9 rddSetDefault( "FPTCDX" ) ou "DBFCDX"

    + added new RDD DBFBLOB compatible with CL5.3 DBFBLOB
      It operates on memo files only (.dbv) without tables (.dbf)

    */
      // Verifica a existencia do codigo do memo no buffer.
      DO CASE
      CASE buffer = Chr( 142 )   // 8Eh(142) dBASE IV w. SQL table
         cMES      := "dBASE IV  SQL table"
         ret_value := 142
      CASE buffer = Chr( 048 )   // VisualFoxPro:=0x30 -->30h(048) Visual FoxPro w. DBC
         cMES      := "Visual FoxPro DBC"
         ret_value := 048
      CASE buffer = Chr( 123 )   // dBase4WithMemo_:=0x7b -->7Bh(123) dBASE IV with memo
         cMES      := "dBASE IV com memo"
         ret_value := 123
      CASE buffer = Chr( 005 )   // dBase5 :=5 -->05h(005)dBASE V w/o memo file
         cMES      := "dbase V  Sem memo"
         ret_value := 005
      CASE buffer = Chr( 004 )   // dBase4 :=4 -->04h(004)dBASE IV or IV w/o memo file
         cMES      := "dbase IV  Sem memo"
         ret_value := 004
      CASE buffer = Chr( 139 )   // dBase4WithMemo:=0x8b -->8Bh(139) dBASE IV w. memo  DBF/MDX DBFMDX (DBT-MEMO)
         cMES      := "dbase IV  com memo"
         ret_value := 139
      CASE buffer = Chr( 245 )   // FoxPro2WithMemo:=0xf5 -->F5h(245) FoxPro w. memo file  DBF/CDX-IDX DBFCDX ADSCDX (FPT-MEMO)
         cMES      := "Foxpro  com memo"
         ret_value := 245
      CASE buffer = Chr( 131 )   // FoxBaseDBase3WithMemo:=0x83 -->83h(131) dBASE III+ with memo file DBF/NTX DBFNTX ADSNTX COMIX (DBT-MEMO) * Tambem pode ser comix  DBF/NTX       COMIX (DBT-MEMO)
         cMES      := "dBASE III com memo"
         ret_value := 131
      CASE buffer = Chr( 003 )   // FoxBaseDBase3NoMemo:=3 -->03h(003) dBASE III w/o memo file  DBF/NTX/CDX FORTESS DBFNTX DBFCDX DBFMDX COMIX ADSCDX ADSNTX
         cMES      := "dBASE III sem memo"
         ret_value := 003
      CASE buffer = Chr( 002 )   // FoxBase:=2                           -->02h(002)
         cMES      := "FoxBase"
         ret_value := 2
      CASE buffer = Chr( 007 )   // VO :=7        -->07h(007)
         cMES      := "VO"
         ret_value := 7
      CASE buffer = Chr( 019 )   // Flagship := 0x13      -->13h(
         cMES      := "Flagship"
         ret_value := 019
      CASE buffer = Chr( 035 )   // Flagship248 := 0x23     -->23h(
         cMES      := "Flagship248"
         ret_value := 035
      CASE buffer = Chr( 049 )   // VisualFoxProAutoIncrement:=0x31  -->31h(
         cMES      := "VisualFoxProAutoIncrement"
         ret_value := 049
      CASE buffer = Chr( 050 )   // VisualFoxProVarChar :=0x32   -->32h(
         cMES      := "VisualFoxProVarChar"
         ret_value := 050
      CASE buffer = Chr( 051 )   // Flagship248WithDBV := 0x33   -->33h(
         cMES      := "Flagship248WithDBV"
         ret_value := 051
      CASE buffer = Chr( 067 )   // dBase4SQLTableNoMemo:=0x43   -->43h(
         cMES      := "dBase4SQLTableNoMemo"
         ret_value := 067
      CASE buffer = Chr( 099 )   // dBase4SQLSystemNoMemo:=0x63   -->63h(
         cMES      := "dBase4SQLSystemNoMemo"
         ret_value := 099
      CASE buffer = Chr( 135 )   // VOWithMemo := 0x87     -->87h(
         cMES      := "VOWithMemo"
         ret_value := 135
      CASE buffer = Chr( 203 )   // dBase4SQLTableWithMemo:=0xcb   -->cbh(
         cMES      := "dBase4SQLTableWithMemo"
         ret_value := 203
      CASE buffer = Chr( 229 )   // ClipperSixWithSMT:=0xe5    -->e5h(
         cMES      := "Six With SMT"   // rddSetDefault( "SMTCDX" ) rddSetDefault( "SIXCDX" )
         ret_value := 229
      CASE buffer = Chr( 251 )   // FoxBASE_:=0xfb      -->fbh(
         cMES      := "FoxBASE"
         ret_value := 251


      ENDCASE
   ELSE
      ret_value := -2   // Nao Pode Ser Verificado
      cMES      := "Nao Pode Ser Verificado"
   ENDIF
// Apaga tudo e encerra a funcao.
   FClose( handle )
   IF Lmes
      ALERTX( Cmes )
   ENDIF

   RETURN ( ret_value )

// + EOF: f_ismemo.prg
// +
