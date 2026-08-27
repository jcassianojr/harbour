// +--------------------------------------------------------------------
// +
// +    Programa  : netdbf.prg
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024-2026,  jcassiano
// +
// + 1. DbGetRec() — Lê o registro atual para um Array
// + 2. DbPutRec( aRegistro ) — Grava um Array de volta no Registro
// + 3.HB_RecToStr() Converte o registro todo para string
// +--------------------------------------------------------------------

#include "INKEY.CH"
#include "try.ch"
#include "fileio.ch"
#include "dbstruct.ch"
#include "dbinfo.ch"
#include "ads.ch"

REQUEST ADSADT

#ifdef USE_PXRDD
    REQUEST PXRDD   //-20 Carrega a RDD do Paradox criada acima
#endif

// +--------------------------------------------------------------------
// +    Function netregosok()
// +--------------------------------------------------------------------
FUNCTION netregosok()

   IF !WIN_OSNETREGOK()  // Precisa direitos ADM
      IF !WIN_OSNETREGOK( .T., .T. )  // primeiro .t. para ajustar XP/W98..., o segundo ajusta no vista.
         // ALERTX('Registro do windows não ajustado !')
      ELSE
         // ALERTX('Registro windows ajustado')
      ENDIF
   ELSE
      // ALERTX('Ja Ajustado')
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function netgrvcam(cCAMPO, eVAL, lLOCK )
// +--------------------------------------------------------------------
FUNCTION netgrvcam( cCAMPO, eVAL, lLOCK )

   IF ValType( lLOCK ) <> "L"
      lLOCK := .T.
   ENDIF
   IF lLOCK
      netreclock()
   ENDIF
   field->&cCAMPO. := eVAL
   IF lLOCK
      dbUnlock()
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function netgrvd(cCAMPO, eVAL, lLOCK )
// +    grava se houver diferenca e o valor passado nao for em branco (nao zerara o campo)
// +--------------------------------------------------------------------
FUNCTION netgrvd( cCAMPO, eVAL, lLOCK )

   IF ValType( lLOCK ) <> "L"
      lLOCK := .T.
   ENDIF
   IF !Empty( eVAL ) .AND. eVAL <> &cCAMPO.
      IF lLOCK
         netreclock()
      ENDIF
      field->&cCAMPO. := eVAL
      IF lLOCK
         dbUnlock()
      ENDIF
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function netgrvz(cCAMPO, eVAL, lLOCK )
// +    grava se o banco estiver vazio e o valor nao
// +--------------------------------------------------------------------
FUNCTION netgrvz( cCAMPO, eVAL, lLOCK )

   IF ValType( lLOCK ) <> "L"
      lLOCK := .T.
   ENDIF
   IF !Empty( eVAL ) .AND. Empty( &cCAMPO. )
      IF lLOCK
         netreclock()
      ENDIF
      field->&cCAMPO. := eVAL
      IF lLOCK
         dbUnlock()
      ENDIF
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function dbSkipEx(nSKIP)
// +--------------------------------------------------------------------
FUNCTION dbSkipEx( nSKIP )

   IF ValType( nSKIP ) # "N"
      nSKIP := 1
   ENDIF
   dbSkip( nSKIP )
   IF Bof()
      dbGoTop()
   ENDIF
   IF Eof()
      dbGoBottom()
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function netrecapp()
// +--------------------------------------------------------------------
FUNCTION netrecapp()

   LOCAL nkey := 0

   dbAppend()
   WHILE NetErr()
      dbAppend()
      WaitPeriod( 100 )
      nKEY := Inkey( 1 )
      IF nKEY = K_ESC
         RETURN .F.
      ENDIF
      MDS( "Tentando Incluir Registro: " + Alias() )
   ENDDO

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function netrecdel() [Protegido contra loop infinito]
// +--------------------------------------------------------------------
FUNCTION netrecdel()

   LOCAL nKey := 0
   LOCAL nTentativas := 0

   WHILE !dbRLock( RecNo() )
      WaitPeriod( 100 )
      nKey := Inkey( 1 )
      IF nKey = K_ESC
         RETURN .F.
      ENDIF
      nTentativas++
      IF nTentativas > 50  // Aproximadamente 5 segundos tentando
         MDS( "Não foi possível travar o registro para exclusão." )
         RETURN .F.
      ENDIF
   ENDDO
   dbDelete()
   dbUnlock()

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function netreclock() [Protegido contra loop infinito]
// +--------------------------------------------------------------------
FUNCTION netreclock()

   LOCAL nKey := 0
   LOCAL nTentativas := 0

   WHILE !dbRLock( RecNo() )
      WaitPeriod( 100 )
      nKey := Inkey( 1 )
      IF nKey = K_ESC
         RETURN .F.
      ENDIF
      nTentativas++
      IF nTentativas > 50  // Aproximadamente 5 segundos tentando
         MDS( "Não foi possível travar o registro." )
         RETURN .F.
      ENDIF
   ENDDO

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function netrecunlcom()
// +--------------------------------------------------------------------
FUNCTION netrecunlcom()

   dbUnlock()
   dbCommit()

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function netpack(cARQ,lPCK)
// +--------------------------------------------------------------------
FUNCTION netpack( cARQ, lPCK )

   IF ValType( lPCK ) # "L"
      lPCK := .T.
   ENDIF
   IF lPCK
      IF !netuse( cARQ,, .F.,,,, )  // .F. nao compartilhado
         RETURN .F.
      ENDIF
      PACK
      dbCloseArea()
   ENDIF

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function netzap(cARQ, lINDEX)
// +--------------------------------------------------------------------
FUNCTION netzap( cARQ, lINDEX )

   IF ValType( lINDEX ) # "L"
      lINDEX := .T.
   ENDIF
   IF !netuse( cARQ,, .F.,,, lINDEX, )   // .F. nao compartilhado
      RETURN .F.
   ENDIF
   ZAP
   dbCloseArea()

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function NetRegCount(cARQ)
// +--------------------------------------------------------------------
FUNCTION NetRegCount( cARQ )

   LOCAL nREG
   LOCAL cALIAS := Alias()

   nREG := 0
   IF !netuse( cARQ,,,,, .F., )   // abre sem index
      IF !Empty( cALIAS )
         dbSelectAr( cALIAS )
      ENDIF
      RETURN nREG
   ENDIF
   nREG := LastRec()
   dbCloseArea()
   IF !Empty( cALIAS )
      dbSelectAr( cALIAS )
   ENDIF

   RETURN nREG


// +--------------------------------------------------------------------
// +    Function netuse(cARQ, cDRIVER, lSHA, lREAD, lNEW, lINDEX, nTIME, lOPENCON )
// +--------------------------------------------------------------------
FUNCTION netuse( cARQ, cDRIVER, lSHA, lREAD, lNEW, lINDEX, nTIME, lOPENCON )

   LOCAL cEXT
   LOCAL cIND
   LOCAL nKEY
   LOCAL cTableExt := "", cMemoExt := "", cOrdExt := ""
   LOCAL cDbfFile
   LOCAL nPosCol
   LOCAL cDbPath, cTableName
   LOCAL cOldRdd := RddSetDefault()  // Salva a RDD padrão atual

   // Tratamento com TRY/CATCH para recuperacao de extensoes via rddInfo
   TRY
      cTableExt := hb_rddInfo( RDDI_TABLEEXT )
      cTableExt := strtran(cTableExt,".","")
   CATCH
      cTableExt := ""
   END

   IF Empty( cTableExt )
      cTableExt := "dbf"
   ENDIF

   TRY
      cMemoExt := hb_rddInfo( RDDI_MEMOEXT )
      cMemoExt := strtran(cMemoExt,".","")
   CATCH
      cMemoExt := ""
   END

   IF Empty( cMemoExt )
      cMemoExt := "fpt"
   ENDIF

   TRY
      cOrdExt := hb_rddInfo( RDDI_ORDBAGEXT )
      cOrdExt := strtran(cOrdExt,".","")
   CATCH
      cOrdExt := ""
   END

   IF Empty( cOrdExt )
      cOrdExt := "cdx"
   ENDIF

   cEXT := StrTran( Upper( cTableExt ), ".", "" )

   IF ValType( cDRIVER ) # "C" .OR. Empty( cDRIVER )
      DO CASE
        CASE cEXT == "SQLITE" .OR. "SL3" $ Upper( cTableExt )
             cDRIVER := "SL3RDD"
        CASE cEXT == "ADT"
             cDRIVER := "ADSADT"
       #ifdef USE_PXRDD
         CASE cEXT == "DB"
             cDRIVER := "PXRDD"
       #endif           
      OTHERWISE
        cDRIVER := "DBFCDX"
      ENDCASE 
   ELSE
      cDRIVER := AllTrim( cDRIVER )
   ENDIF

   // Se o driver for ADSADT, define o RddSetDefault explicitamente
   IF cDRIVER == "ADSADT"
      RddSetDefault( "ADSADT" )
   ENDIF

   IF ValType( lNEW ) # "L"
      lNEW := .T.  
   ENDIF
   IF ValType( lSHA ) # "L"
      lSHA := .T.  
   ENDIF
   IF ValType( nTIME ) # "N"
      nTIME := -1   
   ENDIF
   IF ValType( lREAD ) # "L"
      lREAD := .F.   
   ENDIF
   IF ValType( lINDEX ) # "L"
      lINDEX := .T.  
   ENDIF
   IF cDRIVER == "SL3RDD" .OR. cDRIVER == "PXRDD"
      lINDEX := .F.
   ENDIF

   // Tratamento especifico para SL3RDD dividindo por dois pontos (:) se houver
   IF cDRIVER == "SL3RDD"
      AdsSetServerType(ADS_LOCAL_SERVER)
      AdsSetFileType(ADS_ADT)
      lINDEX := .F.
      IF ValType( lOPENCON ) # "L"
         lOPENCON := .T.  
      ENDIF

      nPosCol := At( ":", cARQ )
      IF nPosCol > 0
         cDbPath    := SubStr( cARQ, 1, nPosCol - 1 )
         cTableName := SubStr( cARQ, nPosCol + 1 )
         
         IF lOPENCON
            DBSL3CONNECTION( cDbPath, .T. )
         ENDIF
         cARQ := cTableName
      ENDIF
   ELSE
      IF ValType( lOPENCON ) # "L"
         lOPENCON := .F.  
      ENDIF
   ENDIF   

   // Só inclui a extensão padrão se ela já não foi passada explicitamente no nome do arquivo
   IF Lower( Right( cARQ, Len( cTableExt ) + 1 ) ) != "." + Lower( cTableExt )
      cDbfFile := cARQ +"."+ cTableExt
   ELSE
      cDbfFile := cARQ
   ENDIF

   IF cDRIVER != "SL3RDD" .AND. !File( cDbfFile ) .AND. !File( cARQ )   
      ALERTX( "Netuse: Falta Arquivo: " + cARQ )
      RddSetDefault( cOldRdd )  // Restaura a RDD antes de sair com .F.
      RETURN .F.
   ENDIF

   WHILE .T.
      dbUseArea( lNEW, cDRIVER, cARQ,, lSHA, lREAD )
      IF !NetErr()
         EXIT
      ENDIF
      IF nTIME > 0
         nTIME := nTIME - 1
      ENDIF
      IF nTIME = 0
         RddSetDefault( cOldRdd )  // Restaura a RDD antes de sair com .F.
         RETURN .F.
      ENDIF
      IF nTIME = -2
         IF !MDG( "Deseja Retentar" )
            RddSetDefault( cOldRdd )  // Restaura a RDD antes de sair com .F.
            RETURN .F.
         ENDIF
      ENDIF
      MDS( "Nao Estou Conseguindo Abrir arquivo " + cARQ )
      WaitPeriod( 100 )
      nKEY := Inkey( 1 )
      IF nKEY = K_ESC
         RddSetDefault( cOldRdd )  // Restaura a RDD antes de sair com .F.
         RETURN .F.
      ENDIF
   ENDDO

   IF lINDEX .AND. !Empty( cOrdExt )
      cIND := cARQ + "." + cOrdExt
      IF File( cIND )
         IF cDRIVER = "DBFCDX"
            ordListAdd( cIND )
         ELSE
            dbSetIndex( cIND )
         ENDIF
      ELSE
         ALERTX( "Arquivo Indice nao encontrado : " + cIND )
      ENDIF
   ENDIF

   IF cDRIVER = "DBFCDX"
      rddInfo( RDDI_LOCKSCHEME, DB_DBFLOCK_HB32 )
   ENDIF
   IF cDRIVER = "DBFNTX"
      rddInfo( RDDI_LOCKSCHEME, DB_DBFLOCK_HB32 )
   ENDIF

   RddSetDefault( cOldRdd )  // Restaura a RDD original antes de concluir com sucesso

   RETURN .T.



// +--------------------------------------------------------------------
// +    Function zei_fort(nLASTREC,lSAYREC,nPOS,nINC )
// +--------------------------------------------------------------------
FUNCTION zei_fort( nLASTREC, lSAYREC, nPOS, nINC )

   STATIC LD_CHA   := "|"
   STATIC nPOSZEI
   LOCAL cComplete

   IF ValType( nLASTREC ) # "N"
      nLASTREC := LastRec()
   ENDIF
   IF ValType( lSAYREC ) # "L"
      lSAYREC := .T.
   ENDIF
   IF ValType( nINC ) = "N"
      IF nINC = 0
         nPOSZEI := 0
      ELSE
         nPOSZEI += nINC
      ENDIF
      nPOS := nPOSZEI
   ENDIF
   IF nLASTREC = 0   // evita divisao por zero
      nLASTREC := 100
   ENDIF
   IF ValType( nPOS ) = "N"
      cComplete := Int( ( nPOS / nLASTREC ) * 100 )
   ELSE
      cComplete := Int( ( RecNo() / nLASTREC ) * 100 )
   ENDIF
   IF ld_cha = '|'
      ld_cha := '/'
   ELSEIF ld_cha = '/'
      ld_cha := '\'
   ELSEIF ld_cha = '\'
      ld_cha := '-'
   ELSEIF ld_cha = '-'
      ld_cha := '|'
   ENDIF
   IF lSAYREC
      IF ValType( nPOS ) = "N"
         @ MaxRow(), 38 SAY Str( nPOS, 8 ) + "/" + Str( nLASTREC, 8 )
      ELSE
         @ MaxRow(), 38 SAY Str( RecNo(), 8 ) + "/" + Str( nLASTREC, 8 )
      ENDIF
   ENDIF
   @ MaxRow(), 57                     SAY "["
   @ MaxRow(), 69                     SAY "]"
   @ MaxRow(), 58 + Int( cCOMPLETE / 10 ) SAY "#" + ld_cha
   @ MaxRow(), 71                     SAY Transform( cComplete, '999' )

   RETURN .T.


// +--------------------------------------------------------------------
// +    Function sdvpegpos(Pstring,aCAMPOS, PnCampo,lCONV,eCONV)
// +--------------------------------------------------------------------
FUNCTION sdvpegpos( Pstring, aCAMPOS, PnCampo, lCONV, eCONV )

   LOCAL eRETU

   eRetu := SubStr( Pstring, aCAMPOS[ PnCampo, 5 ], aCAMPOS[ PnCampo, 3 ] )
   IF ValType( lCONV ) # "L"
      lCONV := .F.
   ENDIF
   IF ValType( eCONV ) # "C"
      eCONV := aCAMPOS[ PnCampo, 6 ]
   ENDIF
   IF lCONV
      IF !Empty( eCONV )
         DO CASE
         CASE eCONV = "DMY/2" .OR. eCONV = "DMY/4"
            eRETU := SubStr( eRETU, 1, 2 ) + "/" + SubStr( eRETU, 3, 2 ) + "/" + SubStr( eRETU, 5 )
         ENDCASE
      ELSE
         DO CASE
         CASE aCAMPOS[ PnCampo,  2 ] = "SD"
            eRETU := SToD( eRETU )
         CASE aCAMPOS[ PnCampo,  2 ] = "D"
            eRETU := CToD( eRETU )
         CASE aCAMPOS[ PnCampo,  2 ] = "L"
            eRETU := StrLogic( eRETU )
         CASE aCAMPOS[ PnCampo,  2 ] = "N"
            eRETU := Val( eRETU )
            IF aCAMPOS[ PnCampo,  4 ] > 0
               eRETU := eRETU / ( 10 ^ aCAMPOS[ PnCampo, 4 ] )
            ENDIF
         ENDCASE
      ENDIF
   ENDIF

   RETURN eRETU


// +--------------------------------------------------------------------
// +    Function sdvarrpos(aDBF,lESP)
// +--------------------------------------------------------------------
FUNCTION sdvarrpos( aDBF, lESP )

   LOCAL nFIELDS, nPOS, aRETU, X

   nFIELDS := Len( aDBF )
   IF ValType( lESP ) # "L"
      lESP := .F.
   ENDIF
   aRETU := {}
   nPOS  := 1
   FOR X := 1 TO nFIELDS
      AAdd( aRETU, { aDBF[ X,  1 ], aDBF[ X,  2 ], aDBF[ X,  3 ], ADBF[ X,  4 ], nPOS, "" } )
      nPOS += aDBF[ X, 3 ] + IF( lESP, 1, 0 )
   NEXT X

   RETURN aRETU


// +--------------------------------------------------------------------
// +    Function sdvarrcam(LINHA,aDBF,lCONV)
// +--------------------------------------------------------------------
FUNCTION sdvarrcam( cLINHA, aDBF, lCONV )

   LOCAL X, aRETU, nFIELDS

   nFIELDS := Len( aDBF )
   aRETU   := {}
   FOR X := 1 TO nFIELDS
      AAdd( aRETU, sdvpegpos( cLINHA, aDBF, X, lCONV ) )
   NEXT X

   RETURN aRETU
   
/**
 * Função FTS em Harbour abrindo o DBF diretamente pelo caminho (FOPEN/FSEEK)
 * 
 * Parâmetros:
 *  - cCaminhoDbf : Caminho completo ou relativo do arquivo .dbf
 *  - cTermoBusca : Termo textual a ser buscado (obrigatório)
 *  - cRegExp     : Expressão regular opcional para validação avançada (opcional)
 * 
 * Retorno:
 *  - Array com os recnos encontrados: { { string_formatada, recno }, ... }
 *  aResultados := FtsBuscaPorArquivo( "clientes.dbf", "HARBOUR", ".*@email\.com.*" )
 */
FUNCTION FtsBuscaPorArquivo( cCaminhoDbf, cTermoBusca, cRegExp )
    LOCAL pHandle
    LOCAL cRecord
    LOCAL nRecno
    LOCAL aRetu := {}
    LOCAL nLastRec
    LOCAL nHeader, nRecSize
    LOCAL cAliasTemp := "FTS_" + AllTrim( Str( HB_RandomInt( 1000, 9999 ) ) )
    LOCAL cTermoUpper
    LOCAL lTemRegex := !Empty( cRegExp )

    IF Empty( cCaminhoDbf ) .OR. !File( cCaminhoDbf )
        RETURN aRetu
    ENDIF

    IF Empty( cTermoBusca ) .AND. !lTemRegex
        RETURN aRetu
    ENDIF

    // Abre a tabela temporariamente apenas para extrair metadados estruturais (Header, RecSize, LastRec)
    // de forma segura sem precisar calcular manualmente os bytes do cabeçalho do DBF.
    RddSetDefault( "DBFCDX" )
    IF !DbUseArea( .T., "DBFCDX", cCaminhoDbf, cAliasTemp, .T., .T. )
        RETURN aRetu
    ENDIF

    nLastRec  := (cAliasTemp)->( LastRec() )
   nHeader   := (cAliasTemp)->( DbInfo( DBI_GETHEADERSIZE ) )
    nRecSize  := (cAliasTemp)->( DbInfo( DBI_GETRECSIZE ) )
    
    // Fecha o alias estrutural, pois agora faremos a leitura via baixo nível (FOPEN)
    (cAliasTemp)->( DbCloseArea() )

    // Abre o arquivo fisicamente em modo de leitura compartilhada de baixo nível
    pHandle := FOpen( cCaminhoDbf, FO_READ + FO_SHARED )
    
    IF FError() != 0 .OR. pHandle == NIL
        RETURN aRetu
    ENDIF

    cTermoUpper := Upper( AllTrim( cTermoBusca ) )

    // Varredura registro a registro usando o ponteiro físico do arquivo
    FOR nRecno := 1 TO nLastRec
        
        // Posiciona o ponteiro do arquivo exatamente no início do registro atual
        FSeek( pHandle, nHeader + ( ( nRecno - 1 ) * nRecSize ), FS_SET )
        
        // Lê os bytes brutos do registro
        cRecord := FReadStr( pHandle, nRecSize )

        IF Empty( cRecord )
            LOOP
        ENDIF

        // 1º Filtro: Verifica o termo textual básico (se informado)
        IF !Empty( cTermoBusca )
            IF !( cTermoUpper $ Upper( cRecord ) )
                LOOP // Se não achou o termo, pula para o próximo
            ENDIF
        ENDIF

        // 2º Filtro: Se houver Regex, valida o padrão na string do registro
        IF lTemRegex
            // hb_RegEx valida a expressão regular contra o registro bruto
            IF !hb_RegEx( cRegExp, cRecord )
                LOOP // Se não bateu com a regex, pula
            ENDIF
        ENDIF

        // Se passou por todas as validações, adiciona ao array de retorno
        // Formato: { "RECNO_FORMATADO-CONTEUDO", numero_do_recno }
        AAdd( aRetu, { StrZero( nRecno, 8 ) + "-" + cRecord, nRecno } )

    NEXT

    // Fecha o handle de baixo nível do arquivo
    FClose( pHandle )

RETURN aRetu   
   
/**
 * Função de FTS (Full-Text Search) para DBF em Harbour
 * 
 * Parâmetros:
 *  - cArquivoDbf : Caminho do arquivo .dbf
 *  - cTermoBusca : Termo textual a ser buscado (obrigatório)
 *  - cRegExp     : Expressão regular opcional para refinar a busca
 * 
 * Retorno:
 *  - Array com os RECNO() encontrados
 */
FUNCTION FtsBuscaDbf( cArquivoDbf, cTermoBusca, cRegExp )
    LOCAL cAlias := "FTS_ALIAS_" + AllTrim( Str( HB_RandomInt( 1000, 9999 ) ) )
    LOCAL aRecnos := {}
    LOCAL cRegistroStr
    LOCAL cTermoUpper
    LOCAL lTemRegex := !Empty( cRegExp )

    // Valida se o arquivo existe
    IF !File( cArquivoDbf )
        RETURN aRecnos
    ENDIF

    // Abre a tabela em modo compartilhado e somente leitura para segurança
    IF !DbUseArea( .T., "DBFCDX", cArquivoDbf, cAlias, .T., .T. )
        RETURN aRecnos
    ENDIF

    // Pré-processamentos para ganho de performance no loop
    cTermoUpper := Upper( AllTrim( cTermoBusca ) )

    (cAlias)->( DbGoTop() )

    WHILE !(cAlias)->( EoF() )
        // Converte o registro inteiro em string
        cRegistroStr := (cAlias)->(RecToStr() )

        // 1º Passo: Verifica se o termo textual existe (caso o termo não esteja vazio)
        IF Empty( cTermoBusca ) .OR. ( cTermoUpper $ Upper( cRegistroStr ) )
            
            // 2º Passo: Se houver Regex, valida o padrão na string do registro
            IF lTemRegex
                // hb_RegEx aceita a regex e a string alvo (case-sensitive por padrão, 
                // use hb_RegExCase se quiser ignorar case na regex)
                IF hb_RegEx( cRegExp, cRegistroStr )
                    AAdd( aRecnos, (cAlias)->( RecNo() ) )
                ENDIF
            ELSE
                // Se passou no termo e não tem regex, adiciona o recno
                AAdd( aRecnos, (cAlias)->( RecNo() ) )
            ENDIF

        ENDIF

        (cAlias)->( DbSkip() )
    ENDDO

    // Fecha a área de trabalho aberta internamente
    (cAlias)->( DbCloseArea() )

RETURN aRecnos

FUNCTION FilterFtsBusca(cTermoBusca, cRegExp )
IF EMPTY(cRegExp)
   cExprFiltro := '{ || "' + cTermoBusca + '" $ Upper(RecToStr()) }'
ELSE
   cExprFiltro := '{ || "' + cTermoBusca + '" $ Upper(RecToStr()) .AND. hb_RegEx("' + cRegex + '", RecToStr()) }'

ENDIF   
DBSETFILTER( &(cExprFiltro), cExprFiltro )

   
FUNCTION RecToStr()
    LOCAL cStr := ""
    LOCAL i
    
    FOR i := 1 TO FCount()
        // Converte qualquer tipo de dado (String, Número, Data, Lógico) para texto
        cStr += hb_ValToStr( FieldGet( i ) ) + " "
    NEXT
    
RETURN cStr   

/*
 * ftshsx: Wrapper function usando o motor nativo HiPer-SEEK (.hsx) do Harbour
 * 
 * Parâmetros:
 *  - cDbfFile   : Caminho do arquivo .dbf
 *  - cTermoBusca: Termo textual a ser buscado
 *  - cKeyExpr   : Expressão de chave (opcional: se vazia, indexa a linha inteira de campos)
 *  - lRecriar   : Se .T. (padrão), apaga e recria o .hsx para evitar dados antigos/misturados
 * 
 * Retorno:
 *  - Array com os recnos encontrados: { recno1, recno2, ... }
 */
FUNCTION ftshsx( cDbfFile, cTermoBusca, cKeyExpr, lRecriar )
   LOCAL hs
   LOCAL nRec
   LOCAL aRetu := {}
   LOCAL cHsxPath
   LOCAL cRddAnterior
   LOCAL xExprIndex := NIL
   LOCAL cAliasTemp
   LOCAL i

   // 1. Guarda o RDD atual e define o padrão para RMDBFCDX
   cRddAnterior := rddDefault()
   rddSetDefault( "RMDBFCDX" )

   // Define o valor padrão de lRecriar como .T.
   IF ValType( lRecriar ) # "L"
      lRecriar := .T.
   ENDIF

   // Validações básicas
   IF Empty( cDbfFile ) .OR. !File( cDbfFile )
      rddSetDefault( cRddAnterior )
      RETURN aRetu
   ENDIF

   cHsxPath := cDbfFile + ".hsx"

   // Se solicitado recriar e o índice já existir, apaga-o
   IF lRecriar .AND. File( cHsxPath )
      FErase( cHsxPath )
   ENDIF

   // 2. Define a expressão de índice (Se não informada, cria o CodeBlock unificando todos os campos)
   IF !Empty( cKeyExpr )
      xExprIndex := cKeyExpr
   ELSE
      // Se não passou expressão, abrimos temporariamente para estruturar o CodeBlock de linha inteira
      cAliasTemp := "FTS_EXPR_" + AllTrim( Str( HB_RandomInt( 1000, 9999 ) ) )
      IF DbUseArea( .T., "DBFCDX", cDbfFile, cAliasTemp, .T., .T. )
         
         // Cria dinamicamente um CodeBlock que simula a união de todos os campos (RecToStr)
         xExprIndex := { || 
            Local cStr := "", _i
            For _i := 1 TO FCount()
               cStr += hb_ValToStr( FieldGet( _i ) ) + " "
            Next
            Return cStr
         }

         (cAliasTemp)->( DbCloseArea() )
      ENDIF
   ENDIF

   // 3. Abre ou Cria o índice HiPer-SEEK usando a chave avaliada (String ou CodeBlock)
   IF File( cHsxPath )
      hs := hs_Open( cDbfFile, , 2 ) // Abre em modo compartilhado/leitura
   ELSE
      // Passa a expressão (seja string ou o codeblock gerado) para o hs_Index nativo
      hs := hs_Index( cDbfFile, xExprIndex, 2, 2, , .T., 3 )
   ENDIF

   IF hs < 0
      rddSetDefault( cRddAnterior )
      RETURN aRetu
   ENDIF

   // 4. Configura o termo de busca no motor HSX e executa
   IF hs_Set( hs, cTermoBusca ) >= 0
      WHILE ( nRec := hs_Next( hs ) ) > 0
         IF hs_Verify( hs ) > 0
            AAdd( aRetu, nRec )
         ENDIF
      ENDDO
   ENDIF

   // 5. Fecha o manipulador do índice
   hs_Close( hs )

   // 6. Restaura o RDD original
   rddSetDefault( cRddAnterior )

RETURN aRetu

// + EOF: netdbf.prg