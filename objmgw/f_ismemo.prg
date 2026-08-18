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

   LOCAL cbuffer := ' ', nhandle, ret_value, cMES, cDRIVERPAD,aRETVAL,cEXTMEMO,nbuffer
   LOCAL cextensao 
   LOCAL nPxVersion

   //IF At( ".", filename ) = 0
    //  filename := Trim( filename ) + ".DBF"
   //ENDIF
   
   
   // removendo pode ser dbf adt db fdb gdb ib mdb accdb
  // filename:=hb_FNameExtSet( filename, ".dbf" )
   
   
   IF ValType( lMES ) # "L"
      lMES := .F.
   ENDIF
   
   nbuffer:=0
   cDRIVERPAD:=""
   cEXTMEMO:=""
   aRETVAL:={0,"","",""}

//
// Retorna 0 Se Nao For DBF
//
   ret_value := 0  // Unknown:=0 ou -2 se nao  conseguir abrir o arquivo
   cMES      := "Parece Nao Ser DBF"
   
   
   IF !File( filename )
      aRETVAL[4] := "Arquivo nao encontrado"
      RETURN aRETVAL
   ENDIF

   nHANDLE := hb_FOPEN( filename, 0 ) // FO_READ
   IF nHANDLE == -1
      aRETVAL[4] := "Erro ao abrir arquivo"
      RETURN aRETVAL
   ENDIF
   
   
    cextensao :=lower(hb_fnameext(filename))

// Se nao ocorrer erro na abertura, carrega o primeiro byte.
   IF FError() = 0 .AND. FRead( nHANDLE, @cBUFFER, 1 ) = 1

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
    
    // Verifica a existencia do codigo do memo no cBUFFER.
      
      nbuffer:=Asc(cBUFFER)
      
      DO CASE
         //cBUFFER = Chr( 142 )--->>nbuffer=142  usando nbuffer assim nao precisa usar chr em todos os cases
      CASE nbuffer =  142   // 8Eh(142) dBASE IV w. SQL table
         cMES      := "dBASE IV  SQL table"
         ret_value := 142
      CASE nbuffer =  048    // VisualFoxPro:=0x30 -->30h(048) Visual FoxPro w. DBC
         //48 0x30 .FPT .CDX Compound NATIVE DBFCDX Visual FoxPro (standard) Full support via DBFCDX. FPT memo VFP-compatible.
         cMES      := "Visual FoxPro DBC"
         ret_value := 048
         cDRIVERPAD:="DBFCDX"
         cEXTMEMO:="FPT"
      CASE nbuffer =  123   // dBase4WithMemo_:=0x7b -->7Bh(123) dBASE IV with memo
         cMES      := "dBASE IV com memo"
         ret_value := 123
      CASE nbuffer = 005    // dBase5 :=5 -->05h(005)dBASE V w/o memo file
         cMES      := "dbase V  Sem memo"
         ret_value := 005
      CASE nbuffer =  004   // dBase4 :=4 -->04h(004)dBASE IV or IV w/o memo file
         cMES      := "dbase IV  Sem memo"
         ret_value := 004
      CASE nbuffer =  139    // dBase4WithMemo:=0x8b -->8Bh(139) dBASE IV w. memo  DBF/MDX DBFMDX (DBT-MEMO)
           //139 0x8B .DBT .MDX Compound PARTIAL DBFMDX* dBASE IV (with memo) DBT memo dBASE IV. MDX partial support only.
         cMES      := "dbase IV  com memo"
         cDRIVERPAD:="DBFMDX"
         cEXTMEMO:="DBT"
         ret_value := 139
      CASE nbuffer =  245    // FoxPro2WithMemo:=0xf5 -->F5h(245) FoxPro w. memo file  DBF/CDX-IDX DBFCDX ADSCDX (FPT-MEMO)
         //245 0xF5 .FPT .CDX/.IDX Compound NATIVE DBFCDX FoxPro 2.x (with memo) FoxPro 2.x FPT memo. Fully compatible via DBFCDX.
         cMES      := "Foxpro  com memo"
         ret_value := 245
         cDRIVERPAD:="DBFCDX"
         cEXTMEMO:="FPT"
      CASE nbuffer =  131    // FoxBaseDBase3WithMemo:=0x83 -->83h(131) dBASE III+ with memo file DBF/NTX DBFNTX ADSNTX COMIX (DBT-MEMO) * Tambem pode ser comix  DBF/NTX       COMIX (DBT-MEMO)
         //131 0x83 .DBT .NDX/.NTX Single NATIVE DBFNTX dBASE III Plus / FoxBASE+ (with memo) DBT memo dBASE III. Full support. Typical Clipper migration format.
         cMES      := "FoxBASE+ / dBASE III com memo"
         ret_value := 131
         cDRIVERPAD:="DBFCDX" //"DBFNTX"
         cEXTMEMO:="DBT"
      CASE nbuffer = 003   // FoxBaseDBase3NoMemo:=3 -->03h(003) dBASE III w/o memo file  DBF/NTX/CDX FORTESS DBFNTX DBFCDX DBFMDX COMIX ADSCDX ADSNTX
         //3 0x03 — .NDX/.NTX Single NATIVE DBFNTX dBASE III Plus / FoxBASE+ (no memo) Most common legacy Clipper format. Full read/write/index support.
         cMES      := "FoxBASE+ / dBASE III sem memo"
         ret_value := 003
         cDRIVERPAD:= "DBFCDX" //"DBFNTX"
      CASE nbuffer =  002    // FoxBase:=2                           -->02h(002)
         //2 0x02 — .NDX/.NTX Single NATIVE DBFNTX FoxBASE original No memo. Compatible with Clipper and CA-Clipper.
         cMES      := "FoxBase"
         ret_value := 2
         cDRIVERPAD:="DBFNTX"
      CASE nbuffer =  007    // VO :=7        -->07h(007)
         cMES      := "VO"
         ret_value := 7
      CASE nbuffer =  019    // Flagship := 0x13      -->13h(
         cMES      := "Flagship"
         ret_value := 019
      CASE nbuffer =  035    // Flagship248 := 0x23     -->23h(
         cMES      := "Flagship248"
         ret_value := 035
      CASE nbuffer =  049    // VisualFoxProAutoIncrement:=0x31  -->31h(
         //49  0x31 .FPT .CDX Compound NATIVE DBFCDX Visual FoxPro (autoincrement) Autoincrement field read OK; write needs attention.
         cMES      := "VisualFoxProAutoIncrement"
         ret_value := 049
         cDRIVERPAD:="DBFNTX"
      CASE nbuffer =  050    // VisualFoxProVarChar :=0x32   -->32h(
        //50 0x32 .FPT .CDX Compound PARTIAL  DBFCDX Visual FoxPro (VARCHAR/VARBINARY) VARCHAR/VARBINARY read as Character. No variable-length native support.
         cMES      := "VisualFoxProVarChar"
         ret_value := 050
         cDRIVERPAD:="DBFCDX"
      CASE nbuffer =  051    // Flagship248WithDBV := 0x33   -->33h(
         cMES      := "Flagship248WithDBV"
         ret_value := 051
      CASE nbuffer =  067    // dBase4SQLTableNoMemo:=0x43   -->43h(
        // 67 0x43 — .MDX Compound PARTIAL DBFMDX* dBASE IV SQL table (no memo) DBFMDX available but limited. MDX not a native Harbour RDD.
         cMES      := "dBase4SQLTableNoMemo"
         ret_value := 067
         cDRIVERPAD:="DBFMDX"
      CASE nbuffer = 099    // dBase4SQLSystemNoMemo:=0x63   -->63h(
         //99 0x63 — .MDX Compound PARTIAL DBFMDX* dBASE IV SQL system files Partial read only. Avoid in production.
         cMES      := "dBase4SQLSystemNoMemo"
         ret_value := 099
         cDRIVERPAD:="DBFMDX"
      CASE nbuffer =  135    // VOWithMemo := 0x87     -->87h(
         cMES      := "VOWithMemo"
         ret_value := 135
      CASE nbuffer =  203    // dBase4SQLTableWithMemo:=0xcb   -->cbh(
         //203 0xCB .DBT .MDX Compound PARTIAL DBFMDX* dBASE IV SQL table (with memo) Same as 0x8B with SQL flag. Rare in practice.
         cMES      := "dBase4SQLTableWithMemo"
         ret_value := 203
         cDRIVERPAD:="DBFMDX"
      CASE nbuffer =  229    // ClipperSixWithSMT:=0xe5    -->e5h(
          //229 0xE5 .SMT .NTX Single PARTIAL SIXRDD* HiPer-Six / Six Driver Proprietary SMT memo. Requires SIXRDD. Avoid in new apps.
         cMES      := "Six With SMT"   // rddSetDefault( "SMTCDX" ) rddSetDefault( "SIXCDX" )
         ret_value := 229
         cDRIVERPAD:="SMTCDX"
      CASE nbuffer =  251    // FoxBASE_:=0xfb      -->fbh(
        //251 0xFB — .NDX/.NTX Single NATIVE DBFNTX FoxBASE (variant) FoxBASE variant. No memo. Identical to 0x02/0x03.
         cMES      := "FoxBASE"
         cDRIVERPAD:="DBFNTX"
         ret_value := 251
     CASE nbuffer = 59  .and. cextensao=".db"  // 3Bh(59) Paradox Database
         cMES      := "Paradox Database"
         ret_value := 59
         cDRIVERPAD:= "PXRDD"    
         
         // --- Leitura adicional para obter a versão do Paradox (px_fileversion) ---
         // No formato Paradox, a versão costuma ocupar 1 byte ou inteiro curto 
         // dependendo da estrutura do header. Vamos ler na posição específica.
         FSeek( nHANDLE, 39, FS_SET ) // Exemplo de offset comum para versão do header Paradox
         cBuffer := Space( 1 )
         IF FRead( nHANDLE, @cBuffer, 1 ) == 1
            // Se quiser guardar ou anexar a informação na descrição/retorno:
            nPxVersion := Asc( cBuffer )
            cMES := "Paradox Database (Version: " + AllTrim( Str( nPxVersion ) ) + ")"
         ENDIF
         
         
      OTHERWISE //tenta expandido
          FSeek( nHANDLE, 0, FS_SET )
          cBuffer:=SPACE(20)
          IF FRead( nHANDLE, @cBuffer, 20 ) == 20
             DO CASE
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
                CASE SubStr(cBuffer, 17, 2) == Chr(0) + Chr(32)  .and. (cextensao=".fdb" .or. cextensao=".gdb" .or. cextensao=".ib" )
                     cMES      := "Firebird Database"
                     ret_value := 994
                    cDRIVERPAD:= "FB5RDD"
                CASE "Advantage Table" $ cBuffer .or. cextensao == ".adt"
                     cMES      := "Advantage Table (ADT)"
                     ret_value := 993
                     cDRIVERPAD:= "ADSADT"
                     cEXTMEMO  := "ADM"    
                ENDCASE
          ENDIF       
      ENDCASE
   ELSE
      ret_value := -2   // Nao Pode Ser Verificado
      cMES      := "Nao Pode Ser Verificado"
   ENDIF
// Apaga tudo e encerra a funcao.
   FClose( nHANDLE )
   
   
   IF Lmes
      ALERTX( Cmes )
   ENDIF
   aRETVAL:={ret_value,cDRIVERPAD,cEXTMEMO,cMES}
   RETURN  aRETVAL // ret_value 
   
   
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
