// +--------------------------------------------------------------------
// +    Programa  : netdbf.prg
// +    Sistema   : FTS (Full-Text Search) DBF
// +    Linguagem : Harbour
// +--------------------------------------------------------------------

#include "INKEY.CH"
#include "try.ch"
#include "fileio.ch"
#include "dbstruct.ch"
#include "dbinfo.ch"

/**
 * FtsBuscaPorArquivo: Busca física direta em DBF (FOPEN/FSEEK)
 * Filtro aCampos é aplicado através de mapeamento físico de bytes.
 */

/**
 * FtsBuscaPorArquivo: Busca física direta em DBF via FOPEN/FSEEK
 * Utiliza o cálculo estrutural nativo do DBF e suporta filtragem por colunas (aCampos).
 */
FUNCTION FtsBuscaPorArquivo( cCaminhoDbf, cTermoBusca, cRegExp, cKEYWILD, lIncluiMemos, aCampos )
    LOCAL pHandle, cRecord, nRecno, aRetu := {}, nLastRec, nHeader, nRecSize
    LOCAL cAliasTemp := "FTS_" + AllTrim( Str( HB_RandomInt( 1000, 9999 ) ) )
    LOCAL cTermoUpper, cBufferLinha
    LOCAL lTemRegex := !Empty( cRegExp )
    LOCAL lTemWild  := !Empty( cKEYWILD )
    LOCAL lFiltrar  := ( ValType( aCampos ) == "A" .AND. Len( aCampos ) > 0 )
    LOCAL aStruct, aOffsets := {}, nPos, nLen, i

    IF ValType( lIncluiMemos ) # "L"
        lIncluiMemos := .T.
    ENDIF

    IF Empty( cCaminhoDbf ) .OR. !File( cCaminhoDbf )
        RETURN aRetu
    ENDIF

    IF Empty( cTermoBusca ) .AND. !lTemRegex .AND. !lTemWild
        RETURN aRetu
    ENDIF

    // Abre a tabela temporariamente para extrair metadados e estrutura
    RddSetDefault( "DBFCDX" )
    IF !DbUseArea( .T., "DBFCDX", cCaminhoDbf, cAliasTemp, .T., .T. )
        RETURN aRetu
    ENDIF

    nLastRec  := (cAliasTemp)->( LastRec() )
    nHeader   := (cAliasTemp)->( DbInfo( DBI_GETHEADERSIZE ) )
    nRecSize  := (cAliasTemp)->( DbInfo( DBI_GETRECSIZE ) )
    aStruct   := (cAliasTemp)->( DbStruct() )

    // Mapeia os offsets de bytes de cada campo no registro físico do DBF
    nPos := 2 // O 1º byte do registro DBF é o indicador de exclusão (*)
    FOR i := 1 TO Len( aStruct )
        nLen := aStruct[ i, 3 ]
        
        // Se a filtragem estiver ativa, valida se o campo atual está no array aCampos
        IF lFiltrar
            IF AScan( aCampos, i ) > 0
                AAdd( aOffsets, { nPos, nLen } )
            ENDIF
        ELSE
            AAdd( aOffsets, { nPos, nLen } )
        ENDIF
        
        nPos += nLen
    NEXT

    (cAliasTemp)->( DbCloseArea() )

    // Abre o arquivo fisicamente em baixo nível
    pHandle := FOpen( cCaminhoDbf, FO_READ + FO_SHARED )
    IF FError() != 0 .OR. pHandle == NIL
        RETURN aRetu
    ENDIF

    cTermoUpper := Upper( AllTrim( cTermoBusca ) )

    // Varredura registro a registro usando o ponteiro físico estrutural
    FOR nRecno := 1 TO nLastRec
        FSeek( pHandle, nHeader + ( ( nRecno - 1 ) * nRecSize ), FS_SET )
        cRecord := FReadStr( pHandle, nRecSize )

        IF Empty( cRecord )
            LOOP
        ENDIF

        // Monta o buffer de texto apenas com as colunas mapeadas no offset
        IF lFiltrar
            cBufferLinha := ""
            FOR i := 1 TO Len( aOffsets )
                cBufferLinha += SubStr( cRecord, aOffsets[ i, 1 ], aOffsets[ i, 2 ] ) + " "
            NEXT
        ELSE
            cBufferLinha := cRecord
        ENDIF

        // Hierarquia de Busca Exclusiva (Wildcard > Regex > Termo básico)
        IF lTemWild
            IF hb_WildMatch( cKEYWILD, cBufferLinha )
                AAdd( aRetu, { StrZero( nRecno, 8 ) + "-" + cRecord, nRecno } )
            ENDIF
        ELSEIF lTemRegex
            IF hb_RegEx( cRegExp, cBufferLinha )
                AAdd( aRetu, { StrZero( nRecno, 8 ) + "-" + cRecord, nRecno } )
            ENDIF
        ELSEIF !Empty( cTermoBusca )
            IF cTermoUpper $ Upper( cBufferLinha )
                AAdd( aRetu, { StrZero( nRecno, 8 ) + "-" + cRecord, nRecno } )
            ENDIF
        ENDIF

    NEXT

    FClose( pHandle )

RETURN aRetu

/**
 * FtsBuscaDbf: Busca por registro via Alias lógico
 */
FUNCTION FtsBuscaDbf( cArquivoDbf, cTermoBusca, cRegExp, cKEYWILD, lIncluiMemos, aCampos )
    LOCAL cAlias := "FTS_ALIAS_" + AllTrim( Str( HB_RandomInt( 1000, 9999 ) ) )
    LOCAL aRecnos := {}, cRegistroStr, cTermoUpper
    LOCAL lTemRegex := !Empty( cRegExp )
    LOCAL lTemWild  := !Empty( cKEYWILD )

    IF ValType( lIncluiMemos ) # "L"
        lIncluiMemos := .T.
    ENDIF

    IF Empty( cTermoBusca ) .AND. !lTemRegex .AND. !lTemWild
        RETURN aRecnos
    ENDIF

    IF !File( cArquivoDbf ) 
        RETURN aRecnos 
    ENDIF

    IF !DbUseArea( .T., "DBFCDX", cArquivoDbf, cAlias, .T., .T. )
        RETURN aRecnos
    ENDIF

    cTermoUpper := Upper( AllTrim( cTermoBusca ) )
    (cAlias)->( DbGoTop() )

    WHILE !(cAlias)->( EoF() )
        // RecToStr agora processa a omissão dos campos diretamente
        cRegistroStr := (cAlias)->( RecToStr( lIncluiMemos, aCampos ) )

        // Hierarquia de Busca Exclusiva
        IF lTemWild
            IF hb_WildMatch( cKEYWILD, cRegistroStr )
                AAdd( aRecnos, (cAlias)->( RecNo() ) )
            ENDIF
        ELSEIF lTemRegex
            IF hb_RegEx( cRegExp, cRegistroStr )
                AAdd( aRecnos, (cAlias)->( RecNo() ) )
            ENDIF
        ELSEIF !Empty( cTermoBusca )
            IF cTermoUpper $ Upper( cRegistroStr )
                AAdd( aRecnos, (cAlias)->( RecNo() ) )
            ENDIF
        ENDIF

        (cAlias)->( DbSkip() )
    ENDDO

    (cAlias)->( DbCloseArea() )

RETURN aRecnos


/**
 * ftshsx: Wrapper motor nativo HiPer-SEEK (.hsx)
 */
FUNCTION ftshsx( cDbfFile, cTermoBusca, cKeyExpr, cRegExp, cKEYWILD, lIncluiMemos, aCampos, lRecriar )
   LOCAL hs, nRec, aRetu := {}, cHsxPath, cRddAnterior, xExprIndex := NIL
   LOCAL cAliasTemp, cRegistroStr
   LOCAL lTemRegex := !Empty( cRegExp )
   LOCAL lTemWild  := !Empty( cKEYWILD )

   IF ValType( lIncluiMemos ) # "L"
       lIncluiMemos := .T.
   ENDIF
   IF ValType( lRecriar ) # "L"
      lRecriar := .T.
   ENDIF

   IF Empty( cTermoBusca ) .AND. !lTemRegex .AND. !lTemWild
       RETURN aRetu
   ENDIF

   cRddAnterior := rddDefault() 
   rddSetDefault( "RMDBFCDX" ) 

   IF Empty( cDbfFile ) .OR. !File( cDbfFile )
      rddSetDefault( cRddAnterior )
      RETURN aRetu
   ENDIF

   cHsxPath := cDbfFile + ".hsx"

   IF lRecriar .AND. File( cHsxPath )
      FErase( cHsxPath )
   ENDIF

   IF !Empty( cKeyExpr )
      xExprIndex := cKeyExpr
   ELSE
      cAliasTemp := "FTS_EXPR_" + AllTrim( Str( HB_RandomInt( 1000, 9999 ) ) )
      IF DbUseArea( .T., "DBFCDX", cDbfFile, cAliasTemp, .T., .T. )
         // O bloco de indexação respeita os campos restritos
         xExprIndex := { || (cAliasTemp)->( RecToStr( lIncluiMemos, aCampos ) ) }
         (cAliasTemp)->( DbCloseArea() )
      ENDIF
   ENDIF

   IF File( cHsxPath )
      hs := hs_Open( cDbfFile, , 2 ) 
   ELSE
      hs := hs_Index( cDbfFile, xExprIndex, 2, 2, , .T., 3 )
   ENDIF

   IF hs < 0
      rddSetDefault( cRddAnterior )
      RETURN aRetu
   ENDIF

   IF hs_Set( hs, cTermoBusca ) >= 0 
      
      IF lTemRegex .OR. lTemWild
         cAliasTemp := "FTS_VAL_" + AllTrim( Str( HB_RandomInt( 1000, 9999 ) ) ) 
         DbUseArea( .T., "DBFCDX", cDbfFile, cAliasTemp, .T., .T. ) 
      ENDIF

      WHILE ( nRec := hs_Next( hs ) ) > 0 
         IF hs_Verify( hs ) > 0 
            IF lTemWild .OR. lTemRegex
               (cAliasTemp)->( DbGoto( nRec ) )
               cRegistroStr := (cAliasTemp)->( RecToStr( lIncluiMemos, aCampos ) )
               
               IF lTemWild
                   IF hb_WildMatch( cKEYWILD, cRegistroStr )
                       AAdd( aRetu, nRec ) 
                   ENDIF
               ELSEIF lTemRegex
                   IF hb_RegEx( cRegExp, cRegistroStr )
                       AAdd( aRetu, nRec ) 
                   ENDIF
               ENDIF
            ELSE
               AAdd( aRetu, nRec ) 
            ENDIF
         ENDIF
      ENDDO
      
      IF lTemRegex .OR. lTemWild
         (cAliasTemp)->( DbCloseArea() )
      ENDIF
   ENDIF

   hs_Close( hs ) 
   rddSetDefault( cRddAnterior ) 

RETURN aRetu 


/**
 * Converte os campos de um registro atual para String respeitando o filtro aCampos
 */
FUNCTION RecToStr( lIncluiMemos, aCampos )
    LOCAL cStr := ""
    LOCAL i, xValor
    LOCAL lFiltrar := ( ValType( aCampos ) == "A" .AND. Len( aCampos ) > 0 )
    
    IF ValType( lIncluiMemos ) # "L"
        lIncluiMemos := .T.
    ENDIF

    FOR i := 1 TO FCount()
        // Se aCampos foi passado, ignora colunas que não estão na lista
        IF lFiltrar .AND. AScan( aCampos, i ) == 0
            LOOP
        ENDIF

        xValor := FieldGet( i )
        IF !lIncluiMemos .AND. ValType( xValor ) == "M"
            LOOP
        ENDIF
        
        cStr += hb_ValToStr( xValor ) + " "
    NEXT
    
RETURN cStr


/**
 * Cria macro filtro
 */
FUNCTION FilterFtsBusca( cTermoBusca, cRegExp, cKEYWILD )
    LOCAL cExprFiltro

    IF !Empty( cKEYWILD )
        cExprFiltro := '{ || hb_WildMatch("' + cKEYWILD + '", RecToStr()) }'
    ELSEIF !Empty( cRegExp )
        cExprFiltro := '{ || hb_RegEx("' + cRegExp + '", RecToStr()) }'
    ELSE
        cExprFiltro := '{ || "' + cTermoBusca + '" $ Upper(RecToStr()) }'
    ENDIF   
    
    DBSETFILTER( &(cExprFiltro), cExprFiltro )
RETURN NIL