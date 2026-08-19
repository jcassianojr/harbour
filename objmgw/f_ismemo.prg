// +--------------------------------------------------------------------
// +
// +    Programa  : f_ismemo.prg
// +               identificação de campos Memo e cabeçalhos de arquivos DBF
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +--------------------------------------------------------------------
// +

#include "dbinfo.ch"
#include "fileio.ch"
#include "dbstruct.ch"  // Database structure constants used when defining DBF fields (DBS_NAME, DBS_TYPE, DBS_LEN, DBS_DEC).



/* indices
.NTX   Single NATIVE  DBFNTX Nantucket Clipper / CA-Clipper / Harbour Native Harbour RDD. One key per file. Full DESCEND, FOR, UNIQUE support.
.CDX Compound NATIVE  DBFCDX FoxPro / Visual FoxPro / Harbour Multi-tag compound index. Fully supported. VFP CDX compatible.
.NSX Compound NATIVE  DBFNSX Harbour native (modern) Harbour's own compound index. Recommended for new apps. Better perf than NTX.
.NDX Single   NATIVE  DBFNDX dBASE III / FoxBASE Oldest format. Supported via DBFNDX. Functional but avoid in new projects.
.MDX Compound PARTIAL DBFMDX* dBASE IV / dBASE 5 Partial support. DBFMDX not actively maintained. Test before use.
.IDX Single   NATIVE  DBFCDX FoxPro 2.x Simple FoxPro index. DBFCDX handles read/write correctly.
.DB   —    NOT SUPP.  — Borland Paradox NOT a DBF index. Proprietary Paradox format. ODBC/BDE access only.
.DB usando PXRDD usando pxlib
.BAG compound PARTIAL SIXRDD* HiPer-Six / Six Driver HiPer-Six compound index. Requires external SIXRDD.
*/

/* memos
.DBT NATIVE dBASE III / dBASE IV / Clipper / CA-Clipper Most common legacy memo. Full support via DBFNTX and DBFCDX.
.FPT NATIVE FoxPro 2.x / Visual FoxPro Fully supported by DBFCDX. Handles MEMO, GENERAL and PICTURE fields.
.SMT PARTIAL HiPer-Six Proprietary HiPer-Six memo. Partial read via SIXRDD. Avoid.
.DBV NOT SUPP. dBASE 5 for Windows dBASE 5 memo. Not natively supported. ODBC access only. 
*/

/* drives
DBFNTX NATIVE   0x02/0x03/0x83   .NTX       .DBT     Legacy Clipper/CA-Clipper systems. Maintenance and migration.
DBFCDX NATIVE   0x30/0xF5       .CDX/.IDX  .FPT      FoxPro/VFP interop. New apps needing compound indexes. Strongly recommended.
DBFNSX NATIVE   0x03            .NSX       .DBT/.FPT Pure  Harbour native. Best choice for new Harbour applications.
DBFNDX NATIVE   0x02/0x03       .NDX       .DBT      dBASE III/FoxBASE compatibility. Avoid in modern production code.
DBFMDX PARTIAL  0x43/0x63/0x8B  .MDX       .DBT      dBASE IV MDX. Partial support. Read legacy files only, avoid index creation.
SIXRDD EXTERNAL 0xE5            .BAG/.NTX  .SMT      External HiPer-Six library. Not bundled with Harbour. Legacy-specific only.
LETO   NATIVE   any             any        any       Remote DBF over network (leto server). Works on top of DBFNTX/CDX/NSX.
SQLRDD NATIVE   —               —          —         SQL access (MySQL, PostgreSQL, SQLite, MSSQL) using xBase syntax.
*/

   /*
     3† 0x03 —.NTX Single NATIVE DBFNTX Nantucket Clipper / CA-Clipper Uses 0x03 with exclusive .NTX. DBFNTX is Harbour's native RDD for this.
      — — — .NSX Compound NATIVE DBFNSX CA-harbour / Harbour NSX Harbour native compound index. Recommended over CDX in pure Harbour environments.
    ‡ 0x03 .DBT .DB/— — NOT SUPP. — Borland Paradox NOT DBF. Paradox .DB is proprietary. Access only via ODBC/BDE/ADO.
     — — .DBT .NTX/.CDX S/Comp NATIVE NTX/CDX Harbour native DBF (self-generated) Harbour outputs 0x03 or 0x30 by default, controlled by active RD

    https://github.com/X-Sharp/XSharpPublic/blob/main/Runtime/XSharp.Rdd/Enums.prg#L105
    
    
    NATIVE Full support: reliable read, write and index maintenance via Harbour native RDD.
    PARTIAL Reading generally possible; index creation/maintenance limited or RDD-dependent.
    NOT SUPP. Proprietary/incompatible format. Access only via external ODBC/ADO/BDE.
    EXTERNAL Support via external RDD/library not included in standard Harbour.
    
   */
   
   
/*   
   OPCAO( 4,10,"DBF&NTX   DBF NTX DBT ",78)  //N  1 DBFNTX   DBF/DBFFPT/DBFNTX
OPCAO( 5,10,"DBF&CDX   DBF CDX FPT ",67)  //C  2 DBFCDX   DBF/DBFFPT/CDXRDD
OPCAO( 6,10,"&ADSCDX   DBF CDX FPT ",65)  //A  3 ADSCDX
OPCAO( 7,10,"ADSNT&X   DBF NTX DBT ",88)  //X  4 ADSNTX
OPCAO( 8,10,"ADSVF&P   DBF CDX FPT ",80)  //P  5 ADSVFP
OPCAO( 9,10,"ADSAD&T   ADT ADI ADM ",84)  //T  6 ADSADT
OPCAO(10,10,"D&BTCDX   DBF CDX DBT ",66)  //B  7 DBTCDX   DBFCDX/DBFFPT/DBTCDX
OPCAO(11,10,"&SMTCDX   DBF CDX SMT ",83)  //S  8 DBFCDX   DBFFPT/SMTCDX
OPCAO(12,10,"&FPTCDX   DBF CDX FPT ",70)  //F  9 FPTCDX   DBFCDX/DBFFPT/FPTCDX
OPCAO(13,10,"S&IXCDX   DBF CDX FPT ",73)  //I 10 SIXCDX

OPCAO(04,35,"&DBFNSX   DBF NSX MST ",68)  //D 11 DBFNSX   DBF/DBFFPT/DBFNSX
OPCAO(05,35,"DBFB&LOB  DBF     DBV ",76)  //L 12 DBFBLOB  DBF/DBFFPT/DBFBLOB
OPCAO(06,35,"&HSCDX    DBF CDX FPT ",72)  //H 13 HSCDX    DBFCDX/HSCDX
OPCAO(07,35,"&RLCDX    DBF CDX FPT ",82)  //R 14 RLCDX    DBFCDX/RLCDX
OPCAO(08,35,"&VFPCDX   DBF CDX FPT ",86)  //V 15 VFPCDX   DBFCDX/DBFFPT/VFPCDX
OPCAO(09,35,"B&MDBFCDX DBF CXD FPT ",77)  //M 16 BMDBFCDX DBFCDX DBFFPT
OPCAO(10,35,"BMDBFNSX  DBF NSX FPT ",49)  //1 17 BMDBFNSX DBFNSX DBFFPT
OPCAO(11,35,"BMDBFNTX  DBF NTX FPT ",50)  //2 18 BMDBFNTX DBFNTX DBFFPT 
OPCAO(12,35,"DBFCDXEX  DBF CDX FPT ",51)  //2 19 Crypto   DBFCDXEX   -lbcrypt
OPCAO(13,35,"FCSVRDD   CSV         ",51)   //2 20 FCSVRDD csv
OPCAO(13,35,"JSONRDD   JSON        ",51)   //2 21 JSONRDD json RDD
*/
   
   


// +--------------------------------------------------------------------
// +
// +    Function ISMEMO(cARQ, lMES, lINFO)
// +
// +--------------------------------------------------------------------
// +
FUNCTION ISMEMO( cARQ, lMES, lINFO )

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



// +--------------------------------------------------------------------
// +
// +    Function INFOTIPODBF(filename, lMES)
// +
// +--------------------------------------------------------------------
// +
FUNCTION INFOTIPODBF( filename, lMES )

   LOCAL cbuffer := ' ', nhandle, ret_value, cMES, cDRIVERPAD, aRETVAL, cEXTMEMO, nbuffer
   LOCAL cEXTTABLE, cEXTINDEX // <-- NOVAS VARIÁVEIS ADICIONADAS
   LOCAL cextensao 
   LOCAL nPxVersion

   IF ValType( lMES ) # "L"
      lMES := .F.
   ENDIF
   
   nbuffer    := 0
   cDRIVERPAD := ""
   cEXTMEMO   := ""
   cEXTTABLE  := "" // <-- INICIALIZA VAZIO 
   cEXTINDEX  := "" // <-- INICIALIZA VAZIO
   
   // Array agora com 6 posicoes
   aRETVAL    := { 0, "", "", "", "", "" } 

   ret_value  := 0 
   cMES       := "Parece Nao Ser DBF"
   
   IF !File( filename )
      aRETVAL[4] := "Arquivo nao encontrado"
      RETURN aRETVAL
   ENDIF

   nHANDLE := hb_FOPEN( filename, 0 ) // FO_READ
   IF nHANDLE == -1
      aRETVAL[4] := "Erro ao abrir arquivo"
      RETURN aRETVAL
   ENDIF
   
   cextensao := lower( hb_fnameext( filename ) )

   IF FError() = 0 .AND. FRead( nHANDLE, @cBUFFER, 1 ) = 1

      nbuffer := Asc( cBUFFER )
      
      DO CASE
      CASE nbuffer =  142   // dBASE IV SQL table
         cMES      := "dBASE IV  SQL table"
         ret_value := 142
         cEXTTABLE := "DBF"
         cEXTINDEX := "MDX"
      CASE nbuffer =  048   // Visual FoxPro DBC
         cMES      := "Visual FoxPro DBC"
         ret_value := 048
         cDRIVERPAD:= "DBFCDX"
         cEXTMEMO  := "FPT"
         cEXTTABLE := "DBF"
         cEXTINDEX := "CDX"
      CASE nbuffer =  123   // dBASE IV with memo
         cMES      := "dBASE IV com memo"
         ret_value := 123
         cEXTTABLE := "DBF"
         cEXTINDEX := "MDX"
      CASE nbuffer = 005    // dBASE V w/o memo file
         cMES      := "dbase V  Sem memo"
         ret_value := 005
         cEXTTABLE := "DBF"
         cEXTINDEX := "MDX"
      CASE nbuffer =  004   // dBASE IV or IV w/o memo file
         cMES      := "dbase IV  Sem memo"
         ret_value := 004
         cEXTTABLE := "DBF"
         cEXTINDEX := "MDX"
      CASE nbuffer =  139   // dBASE IV w. memo
         cMES      := "dbase IV  com memo"
         cDRIVERPAD:= "DBFMDX"
         cEXTMEMO  := "DBT"
         ret_value := 139
         cEXTTABLE := "DBF"
         cEXTINDEX := "MDX"
      CASE nbuffer =  245   // FoxPro w. memo file
         cMES      := "Foxpro  com memo"
         ret_value := 245
         cDRIVERPAD:= "DBFCDX"
         cEXTMEMO  := "FPT"
         cEXTTABLE := "DBF"
         cEXTINDEX := "CDX"
      CASE nbuffer =  131   // dBASE III+ with memo file
         cMES      := "FoxBASE+ / dBASE III com memo"
         ret_value := 131
         cDRIVERPAD:= "DBFCDX" // ou DBFNTX conforme o legado
         cEXTMEMO  := "DBT"
         cEXTTABLE := "DBF"
         cEXTINDEX := "CDX"
      CASE nbuffer = 003    // dBASE III w/o memo file
         cMES      := "FoxBASE+ / dBASE III sem memo"
         ret_value := 003
         cDRIVERPAD:= "DBFCDX" 
         cEXTTABLE := "DBF"
         cEXTINDEX := "CDX"
      CASE nbuffer =  002   // FoxBASE original
         cMES      := "FoxBase"
         ret_value := 2
         cDRIVERPAD:= "DBFNTX"
         cEXTTABLE := "DBF"
         cEXTINDEX := "NTX"
      CASE nbuffer =  007   // VO
         cMES      := "VO"
         ret_value := 7
         cEXTTABLE := "DBF"
         cEXTINDEX := "NTX"
      CASE nbuffer =  019   // Flagship
         cMES      := "Flagship"
         ret_value := 019
         cEXTTABLE := "DBF"
      CASE nbuffer =  035   // Flagship248
         cMES      := "Flagship248"
         ret_value := 035
         cEXTTABLE := "DBF"
      CASE nbuffer =  049   // Visual FoxPro (autoincrement)
         cMES      := "VisualFoxProAutoIncrement"
         ret_value := 049
         cDRIVERPAD:= "DBFNTX"
         cEXTTABLE := "DBF"
         cEXTINDEX := "NTX"
      CASE nbuffer =  050   // Visual FoxPro (VARCHAR/VARBINARY)
         cMES      := "VisualFoxProVarChar"
         ret_value := 050
         cDRIVERPAD:= "DBFCDX"
         cEXTTABLE := "DBF"
         cEXTINDEX := "CDX"
      CASE nbuffer =  051   // Flagship248WithDBV
         cMES      := "Flagship248WithDBV"
         ret_value := 051
         cEXTTABLE := "DBF"
      CASE nbuffer =  067   // dBASE IV SQL table (no memo)
         cMES      := "dBase4SQLTableNoMemo"
         ret_value := 067
         cDRIVERPAD:= "DBFMDX"
         cEXTTABLE := "DBF"
         cEXTINDEX := "MDX"
      CASE nbuffer = 099    // dBASE IV SQL system files
         cMES      := "dBase4SQLSystemNoMemo"
         ret_value := 099
         cDRIVERPAD:= "DBFMDX"
         cEXTTABLE := "DBF"
         cEXTINDEX := "MDX"
      CASE nbuffer =  135   // VOWithMemo
         cMES      := "VOWithMemo"
         ret_value := 135
         cEXTTABLE := "DBF"
      CASE nbuffer =  203   // dBASE IV SQL table (with memo)
         cMES      := "dBase4SQLTableWithMemo"
         ret_value := 203
         cDRIVERPAD:= "DBFMDX"
         cEXTTABLE := "DBF"
         cEXTINDEX := "MDX"
      CASE nbuffer =  229   // HiPer-Six / Six Driver
         cMES      := "Six With SMT"
         ret_value := 229
         cDRIVERPAD:= "SMTCDX"
         cEXTTABLE := "DBF"
         cEXTINDEX := "CDX"
      CASE nbuffer =  251   // FoxBASE (variant)
         cMES      := "FoxBASE"
         cDRIVERPAD:= "DBFNTX"
         ret_value := 251
         cEXTTABLE := "DBF"
         cEXTINDEX := "NTX"
         
      OTHERWISE //tenta expandido
          FSeek( nHANDLE, 0, FS_SET )
          cBuffer:=SPACE(32)
          IF FRead( nHANDLE, @cBuffer, 32 ) == 32
             DO CASE
                // --- DBMS (Extensoes ficam em branco) ---
                CASE Left( cBuffer, 15 ) == "SQLite format 3"
                    cMES      := "Arquivo SQLite"
                    ret_value := 999 
                    cDRIVERPAD:= "SL3RDD"
                CASE "DUCK" $  cBuffer .and. cextensao=".db" 
                     cMES      := "DuckDB Database"
                     ret_value := 998 
                     cDRIVERPAD:= "DUCKDBRDD"   
                CASE "Standard ACE DB" $  cBuffer .and. cextensao=".mdb" 
                     cMES      := "Arquivo access MDB"
                     ret_value := 997 
                     cDRIVERPAD:= "MDB"  
                CASE "Standard ACE DB" $  cBuffer .and. cextensao=".accdb" 
                     cMES      := "Arquivo access accdb"
                     ret_value := 997 
                     cDRIVERPAD:= "ACCDB"       
                CASE "Standard Jet DB" $  cBuffer .and. cextensao=".mdb" 
                     cMES      := "Arquivo access MDB"
                     ret_value := 995 
                     cDRIVERPAD:= "MDB"            
                CASE SubStr(cBuffer, 17, 2) == Chr(0) + Chr(32) .and. (cextensao=".fdb" .or. cextensao=".gdb" .or. cextensao=".ib" )
                     cMES      := "Firebird Database"
                     ret_value := 994
                     cDRIVERPAD:= "FB5RDD"
                     
                // --- ADVANTAGE TABLE ---
                CASE "Advantage Table" $ cBuffer .or. cextensao == ".adt"
                     cMES      := "Advantage Table (ADT)"
                     ret_value := 993
                     cDRIVERPAD:= "ADSADT"
                     cEXTMEMO  := "ADM"    
                     cEXTTABLE := "ADT"
                     cEXTINDEX := "ADI"
                     
                // --- NOVA IDENTIFICAÇÃO PARADOX ---
                CASE cextensao == ".db" .AND. Bin2W( SubStr( cBuffer, 1, 2 ) ) > 0 .AND. Bin2W( SubStr( cBuffer, 5, 2 ) ) >= 1024
                     cMES      := "Paradox Database"
                     ret_value := 59 
                     cDRIVERPAD:= "PXRDD"
                     cEXTTABLE := "DB"
                     cEXTINDEX := ""    // Paradox prop. usa outras libs, s/ idx nativo
                     
                     // Leitura adicional para obter a versão do Paradox
                     FSeek( nHANDLE, 57, FS_SET ) 
                     cBuffer := Space( 1 )
                     IF FRead( nHANDLE, @cBuffer, 1 ) == 1
                        nPxVersion := Asc( cBuffer )
                        cMES := "Paradox Database (Version: " + AllTrim( Str( nPxVersion ) ) + ")"
                     ENDIF        
                     
                ENDCASE
          ENDIF       
      ENDCASE
   ELSE
      ret_value := -2   // Nao Pode Ser Verificado
      cMES      := "Nao Pode Ser Verificado"
   ENDIF

   FClose( nHANDLE )
   
   IF Lmes
      ALERTX( Cmes )
   ENDIF
   
   // --- NOVO RETORNO COM 6 ELEMENTOS ---
   aRETVAL := { ret_value, cDRIVERPAD, cEXTMEMO, cMES, cEXTTABLE, cEXTINDEX }
   RETURN aRETVAL   
   
   // DBF file format constants used when navigating the binary header.
// Using symbolic names avoids hard-coded offsets and improves maintainability.
#define FIELD_ENTRY_SIZE  32   // Size in bytes of a single DBF field descriptor.
#define FIELD_NAME_SIZE   11   // Maximum field name length stored in the descriptor (including null terminator).

/*
 * FUNCTION: GetHeaderInfo
 *
 * Purpose:
 *    Reads and interprets the binary header of a DBF file using Harbour's
 *    low-level file I/O functions. The function extracts general database
 *    information together with the complete field structure and returns it
 *    in a format suitable for presentation by the custom AChoice() dialog.
 *
 * Parameters:
 *    database (Character)
 *       Name or path of the DBF file. The ".DBF" extension is appended
 *       automatically when omitted.
 *
 * Returns:
 *    Array
 *       An array of { Value, Description } pairs containing header
 *       information and field definitions. An empty array is returned
 *       if the file cannot be opened.
 *
 * Side Effects:
 *    - Opens the specified DBF file in read-only mode.
 *    - Displays informational dialogs when errors or invalid header
 *      values are detected.
 *    - Closes the file handle before returning.
 *
 * Notes:
 *    This implementation accesses the DBF file directly instead of using
 *    RDD functions, making it suitable for inspecting the physical file
 *    format independently of the active database driver.
 */
FUNCTION GetHeaderInfo( database, cTIPOINFO )
   LOCAL aRet := {}
   LOCAL nHandle, dbfhead, h1, h2, h3, h4
   LOCAL dbftype, headrecs, headsize, recsize, nof
   LOCAL fieldlist, nField, nPos, cFieldName, cType, cWidth, nWidth, nDec, cDec
   LOCAL cErrorString
   LOCAL aErrors := {}
   LOCAL cFieldType, nFieldLen
   LOCAL nFileLen, nCalcLen, cTerminator
    
   IF !'.DBF' $ Upper( database )
      database += '.DBF'
   ENDIF
   
   IF VALTYPE(cTIPOINFO) <> "C"
      cTIPOINFO := "F"
   ENDIF

   IF ( nHandle := FOpen( database, FO_READ ) ) == -1
      ALERT( 'Cannot open file ' + Upper( database ) + ' for reading!' )
      RETURN aRet
   ENDIF

   dbfhead := Space( 4 )
   FRead( nHandle, @dbfhead, 4 )

   h1 := FT_BYT2HEX( SubStr( dbfhead, 1, 1 ) )
   dbftype := h1

   h2 := FT_BYT2HEX( SubStr( dbfhead, 2, 1 ) )
   h3 := FT_BYT2HEX( SubStr( dbfhead, 3, 1 ) )
   h4 := FT_BYT2HEX( SubStr( dbfhead, 4, 1 ) )

   IF hex2dec( h3 ) > 12 .OR. hex2dec( h4 ) > 31
      ALERT( 'Date damage in header!' )
   ENDIF

   AAdd( aRet, { '0x' + dbftype, 'Type of file' } )

   AAdd( aRet, { StrZero( hex2dec( h4 ), 2 ) + '.' + StrZero( hex2dec( h3 ), 2 ) + '.' + ;
                 StrZero( hex2dec( h2 ) - If( hex2dec( h2 ) > 100, 100, 0 ), 2 ), ;
                 'Last update (DD.MM.YY)' } )

   headrecs := Space( 4 )
   FSeek( nHandle, 4, FS_SET )
   FRead( nHandle, @headrecs, 4 )

   h1 := FT_BYT2HEX( SubStr( headrecs, 1, 1 ) )
   h2 := FT_BYT2HEX( SubStr( headrecs, 2, 1 ) )
   h3 := FT_BYT2HEX( SubStr( headrecs, 3, 1 ) )
   h4 := FT_BYT2HEX( SubStr( headrecs, 4, 1 ) )
   headrecs := Int( hex2dec( h1 ) + 256 * hex2dec( h2 ) + ( 256 ** 2 ) * hex2dec( h3 ) + ( 256 ** 3 ) * hex2dec( h4 ) )

   AAdd( aRet, { headrecs, 'Number of records' } )

   headsize := Space( 2 )
   FRead( nHandle, @headsize, 2 )
   h1 := FT_BYT2HEX( SubStr( headsize, 1, 1 ) )
   h2 := FT_BYT2HEX( SubStr( headsize, 2, 1 ) )
   headsize := hex2dec( h1 ) + 256 * hex2dec( h2 )

   AAdd( aRet, { headsize, 'Header size' } )

   recsize := Space( 2 )
   FRead( nHandle, @recsize, 2 )
   h1 := FT_BYT2HEX( SubStr( recsize, 1, 1 ) )
   h2 := FT_BYT2HEX( SubStr( recsize, 2, 1 ) )
   recsize := hex2dec( h1 ) + 256 * hex2dec( h2 )

   AAdd( aRet, { recsize, 'Record size' } )

   nof := Int( headsize / FIELD_ENTRY_SIZE ) - 1

   AAdd( aRet, { nof, 'Fields count' } )

   // Validação física integrada do VO incorporada ao Harbour
// Substituir o cálculo com ftell por FSeek relativo
   FSeek( nHandle, 0, FS_END )
   nFileLen := FSeek( nHandle, 0, FS_RELATIVE )
   nCalcLen := ( recsize * headrecs ) + headsize + 1
   IF Abs( nCalcLen - nFileLen ) > 1
      AAdd( aErrors, { "File length error - header size:" + AllTrim(Str(nFileLen)) + " actual size:" + AllTrim(Str(nCalcLen)), "" } )
   ENDIF

   cTerminator := Space( 1 )
   FSeek( nHandle, ( nof * 32 ) + 32, FS_SET )
   FRead( nHandle, @cTerminator, 1 )
   IF FT_BYT2HEX( cTerminator ) <> "0D"
      AAdd( aErrors, { "Header terminator not 0Dh Value:" + FT_BYT2HEX( cTerminator ), "" } )
   ENDIF

   fieldlist := {}

   FOR nField := 1 TO nof
      nPos := nField * FIELD_ENTRY_SIZE
      FSeek( nHandle, nPos, FS_SET )

      cFieldName := Space( FIELD_NAME_SIZE )
      FRead( nHandle, @cFieldName, FIELD_NAME_SIZE )
      cFieldName := RTrim( StrTran( cFieldName, Chr( 0 ), ' ' ) )

      cType := Space( 1 )
      FRead( nHandle, @cType, 1 )

      FSeek( nHandle, 4, FS_RELATIVE )

      IF cType == 'C'
         cWidth := Space( 2 )
         FRead( nHandle, @cWidth, 2 )
         h1 := FT_BYT2HEX( SubStr( cWidth, 1, 1 ) )
         h2 := FT_BYT2HEX( SubStr( cWidth, 2, 1 ) )
         nWidth := hex2dec( h1 ) + 256 * hex2dec( h2 )
         nDec := 0
      ELSE
         cWidth := Space( 1 )
         FRead( nHandle, @cWidth, 1 )
         nWidth := hex2dec( FT_BYT2HEX( cWidth ) )
         cDec := Space( 1 )
         FRead( nHandle, @cDec, 1 )
         nDec := hex2dec( FT_BYT2HEX( cDec ) )
      ENDIF

      AAdd( fieldlist, { cFieldName, cType, nWidth, nDec } )
      
      cFieldType := cType
      nFieldLen  := nWidth
      
      cErrorString := "Field No: " + AllTrim(Str(nField))	;
					+ " Name: " + cFieldName	;
					+ " Type: " + cFieldType 	;
					+ " Length: " + AllTrim(Str(nFieldLen)) ;
					+ " Dec: " + AllTrim(Str(nDec))
      
      IF nFieldLen == 0
    		AAdd(aErrors, {"Field error - invalid length Field must have length > 0 ", cErrorString})
    	ELSEIF cFieldType == "L"
    		IF nFieldLen <> 1
    			AAdd(aErrors, {"Field error - invalid length LOGIC must be length 1", cErrorString})			
    		ENDIF
    	ELSEIF cFieldType == "D"
    		IF nFieldLen <> 8
    			AAdd(aErrors, {"Field error - invalid length - DATE must be length 8", cErrorString})			
    		ENDIF
    	ELSEIF cFieldType == "M"
    		IF nFieldLen <> 10
    			AAdd(aErrors, {"Field error - invalid length - MEMO must be length 10", cErrorString})			
    		ENDIF
    	ELSEIF cFieldType == "O"
    		IF nFieldLen <> 10
    			AAdd(aErrors, {"Field error - invalid length - OLE must be length 10", cErrorString})			
    		ENDIF
    	ELSEIF cFieldType == "N" .or. cFieldType == "F"
    		IF nFieldLen > 19
    			AAdd(aErrors, {"Field error - invalid length - NUMERIC must have length not greater than 19", cErrorString})			
    		ELSEIF nDec > nFieldLen
    			AAdd(aErrors, {"Field error - invalid decimals - DECIMALS must not be greater than FIELD length", cErrorString})			
    		ENDIF
    	ELSEIF cFieldType == "C"
    		IF nFieldLen > 64*1024	
    			AAdd(aErrors, {"Field error - invalid length - CHAR must not be greater than 64k ", cErrorString})
    		ENDIF
    	ELSE
    		AAdd(aErrors, {"Field error - invalid Data Type ", cErrorString})
    	ENDIF
   NEXT

   FClose( nHandle )

   AAdd( aRet, { '', 'Fields structure' } )

   IF cTIPOINFO = "F" 
      AEval( fieldlist, {|x, i| AAdd( aRet, { x[1] + " - " + x[2] + "(" + hb_ntos( x[3] ) + "," + hb_ntos( x[4] ) + ")", hb_ntos( i ) } ) } )
   ENDIF   
   
   IF cTIPOINFO = "E" 
      aRet := fieldlist
   ENDIF
  
   IF cTIPOINFO = "V" 
      aRet := aErrors
   ENDIF
   
RETURN aRet 
 
 

// Lookup table used for hexadecimal conversions.
// Character positions correspond directly to hexadecimal digit values.
#define HEXTABLE "0123456789ABCDEF"

/*
 * FUNCTION: HEX2DEC
 *
 * Purpose:
 *    Converts a hexadecimal string into its decimal numeric equivalent.
 *    The function processes each hexadecimal digit manually, making it
 *    independent of external conversion routines and suitable for decoding
 *    binary values extracted from DBF headers.
 *
 * Parameters:
 *    cHexNum (Character)
 *       Hexadecimal string consisting of characters 0-9 and A-F.
 *       Both uppercase and lowercase input are accepted.
 *
 * Returns:
 *    Numeric
 *       Decimal representation of the supplied hexadecimal value.
 *
 * Side Effects:
 *    None.
 *
 * Notes:
 *    The conversion is performed using positional notation, multiplying
 *    each hexadecimal digit by the appropriate power of sixteen.
 */
FUNCTION HEX2DEC( cHexNum )

   // Loop counter, accumulated decimal value, and current hexadecimal
   // positional multiplier.
   LOCAL n, nDec := 0, nHexPower := 1

   // Process digits from right to left, exactly as manual base conversion
   // is performed in positional numeral systems.
   FOR n := Len( cHexNum ) TO 1 STEP -1

      // Convert the current hexadecimal digit into its numeric value and
      // accumulate its contribution to the final decimal result.
      nDec += ( At( Upper( SubStr( cHexNum, n, 1 ) ), HEXTABLE ) - 1 ) * nHexPower

      // Advance to the next hexadecimal position.
      nHexPower *= 16

   NEXT

RETURN nDec


/*
 * FUNCTION: FT_BYT2HEX
 *
 * Purpose:
 *    Converts a single byte into its two-character hexadecimal
 *    representation. This helper is primarily used while decoding
 *    binary DBF header values read from disk.
 *
 * Parameters:
 *    cByte (Character)
 *       Single-byte character to convert.
 *
 *    plusH (Logical)
 *       Optional flag indicating whether to append the traditional
 *       "h" hexadecimal suffix.
 *
 * Returns:
 *    Character
 *       Two-character hexadecimal string, optionally followed by "h".
 *       Returns NIL if the supplied value is not of character type.
 *
 * Side Effects:
 *    None.
 */
FUNCTION FT_BYT2HEX( cByte, plusH )

   // Stores the formatted hexadecimal representation.
   LOCAL xHexString

   // Default to the conventional two-character hexadecimal format.
   IF VALTYPE(plusH)<>"L"
      plusH := .F.
   ENDIF
   // Perform the conversion only for character values representing
   // a single binary byte.
   IF ValType( cByte ) == "C"

      // Split the byte into its high and low nibbles and translate each
      // nibble into its hexadecimal character using the lookup table.
      xHexString := SubStr( HEXTABLE, Int( Asc( cByte ) / 16 ) + 1, 1 ) + ;
                    SubStr( HEXTABLE, Int( Asc( cByte ) % 16 ) + 1, 1 ) + ;
                    iif( plusH, "h", '' )

   ENDIF

RETURN xHexString


   

// + EOF: f_ismemo.prg
// +
