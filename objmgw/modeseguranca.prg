#define PROV_RSA_FULL       1
#define CRYPT_VERIFYCONTEXT 4026531840 // 0xF0000000
#define CALG_MD5            32771
#define CALG_RC2            26114

STATIC cChaveMestra := "Diretoria@Segura#2026!bancos"

FUNCTION parametrosLerDados()
    LOCAL oStdIn
    LOCAL cBuffer := SPACE(1024)
    LOCAL cDadosRecebidos := ""
    LOCAL nBytesLidos := 0

    // Captura o objeto da entrada padrão
    oStdIn := hb_GetStdIn()

    IF oStdIn != NIL
        // CORREÇÃO: Mudado para DO WHILE e a atribuição inline protegida por parênteses externos
        DO WHILE ( nBytesLidos := oStdIn:Read( @cBuffer, 1024 ) ) > 0
            
            cDadosRecebidos += SUBSTR( cBuffer, 1, nBytesLidos )
            cBuffer := SPACE(1024) // Limpa o buffer para a próxima rodada
            
        ENDDO // CORREÇÃO: Mudado de ENDWHILE para ENDDO
    ENDIF

RETURN cDadosRecebidos

FUNCTION ParametrosEnviarDados( cCaminhoDestino, cDados )
    LOCAL phProcess, nStdIn, nStdOut, nStdErr
    
    // Abre o processo destino capturando os handles de stream
    phProcess := hb_processOpen( cCaminhoDestino, @nStdIn, @nStdOut, @nStdErr )
    
    IF phProcess != NIL
        // Escreve os dados diretamente no pipe de entrada do destino
        FWRITE( nStdIn, cDados )
        
        // Fecha o handle de escrita indicando fim do envio
        FCLOSE( nStdIn )
        FCLOSE( nStdOut )
        FCLOSE( nStdErr )
        
        // Aguarda a finalização do processo para limpar a memória
        hb_processValue( phProcess )
    ENDIF
RETURN NIL


// Retorna o caminho do arquivo config.dat
FUNCTION CaminhoArquivoCofre()
LOCAL cCaminho := hb_DirBase()
RETURN cCaminho + "config.dat"

// --- FUNÇÃO PARA DESCRIPTOGRAFAR ---
FUNCTION LerDoCofre( cSecaoBanco, cChave, cPADRAO )
LOCAL hIni, cBufferHex := "", cBufferBin := ""
LOCAL hProv := 0, hHash := 0, hKey := 0
LOCAL nLen, i, cResult := ""

IF VALTYPE(cPADRAO)<>"C"
   cPADRAO:=""
ENDIF

// 1. Lê o arquivo estruturado usando a função nativa do Harbour
IF File( CaminhoArquivoCofre() )
    hIni := hb_IniRead( CaminhoArquivoCofre() )
    IF hb_HHasKey( hIni, cSecaoBanco ) .AND. hb_HHasKey( hIni[ cSecaoBanco ], cChave )
        cBufferHex := hIni[ cSecaoBanco ][ cChave ]
    ENDIF
ENDIF

IF Empty( cBufferHex )
    RETURN ""
ENDIF

// 2. Converte a string Hexadecimal de volta para caracteres binários
FOR i := 1 TO Len( cBufferHex ) STEP 2
    cBufferBin += Chr( hb_HexToNum( SubStr( cBufferHex, i, 2 ) ) )
NEXT
nLen := Len( cBufferBin )

// 3. Inicializa o contexto chamando a API do Windows diretamente
IF WIN_CryptAcquireContext( @hProv, NIL, NIL, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT )
    
    // Cria o Hash MD5 para derivar a chave baseada na senha mestra
    IF WIN_CryptCreateHash( hProv, CALG_MD5, 0, 0, @hHash )
        WIN_CryptHashData( hHash, cChaveMestra, Len( cChaveMestra ), 0 )
        
        // Deriva a chave RC2
        IF WIN_CryptDeriveKey( hProv, CALG_RC2, hHash, 0, @hKey )
            
            // Executa a descriptografia nativa do Windows no buffer
            IF WIN_CryptDecrypt( hKey, 0, .T., 0, @cBufferBin, @nLen )
                cResult := Left( cBufferBin, nLen )
            ENDIF
            
            WIN_CryptDestroyKey( hKey )
        ENDIF
        WIN_CryptDestroyHash( hHash )
    ENDIF
    WIN_CryptReleaseContext( hProv, 0 )
ENDIF
IF EMPTY(cResult)
   cResult:=cPADRAO
ENDIF

RETURN AllTrim( cResult )

// --- FUNÇÃO PARA GRAVAR NO COFRE ---
FUNCTION GravarNoCofre( cSecaoBanco, cChave, cValor )
LOCAL hIni := {=>}, hProv := 0, hHash := 0, hKey := 0
LOCAL cBuffer, nLen, nBufLen, cHex := "", i
LOCAL lSucesso := .F.

IF WIN_CryptAcquireContext( @hProv, NIL, NIL, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT )
    IF WIN_CryptCreateHash( hProv, CALG_MD5, 0, 0, @hHash )
        WIN_CryptHashData( hHash, cChaveMestra, Len( cChaveMestra ), 0 )
        IF WIN_CryptDeriveKey( hProv, CALG_RC2, hHash, 0, @hKey )
            
            nLen    := Len( cValor )
            nBufLen := ( Int( nLen / 8 ) + 1 ) * 8
            cBuffer := cValor + Space( nBufLen - nLen )
            
            IF WIN_CryptEncrypt( hKey, 0, .T., 0, @cBuffer, @nLen, nBufLen )
                FOR i := 1 TO nLen
                    cHex += hb_NumToHex( Asc( SubStr( cBuffer, i, 1 ) ), 2 )
                NEXT
                
                // Grava usando hash nativo do Harbour
                IF File( CaminhoArquivoCofre() )
                    hIni := hb_IniRead( CaminhoArquivoCofre() )
                ENDIF
                IF !hb_HHasKey( hIni, cSecaoBanco )
                    hIni[ cSecaoBanco ] := {=>}
                ENDIF
                hIni[ cSecaoBanco ][ cChave ] := cHex
                hb_IniWrite( CaminhoArquivoCofre(), hIni )
                
                lSucesso := .T.
            ENDIF
            WIN_CryptDestroyKey( hKey )
        ENDIF
        WIN_CryptDestroyHash( hHash )
    ENDIF
    WIN_CryptReleaseContext( hProv, 0 )
ENDIF
RETURN lSucesso

FUNCTION ExcluirBanco( cSecaoBanco )
LOCAL hIni := {=>}
IF File( CaminhoArquivoCofre() )
    hIni := hb_IniRead( CaminhoArquivoCofre() )
    IF hb_HHasKey( hIni, cSecaoBanco )
        hb_HDel( hIni, cSecaoBanco )
        hb_IniWrite( CaminhoArquivoCofre(), hIni )
        RETURN .T.
    ENDIF
ENDIF
RETURN .F.


// ============================================================================
// PONTE EM C NATIVO PARA O COMPILADOR (Revisada e Fechada Corretamente)
// ============================================================================
#pragma BEGINDUMP

#include <windows.h>
#include <wincrypt.h>
#include "hbapi.h"

HB_FUNC( WIN_CRYPTACQUIRECONTEXT )
{
    HCRYPTPROV hProv = 0;
    BOOL bRet = CryptAcquireContextA(
        &hProv,
        hb_parc(2) == NULL ? NULL : hb_parc(2),
        hb_parc(3) == NULL ? NULL : hb_parc(3),
        hb_parnl(4),
        hb_parnl(5)
    );
    hb_stornl( (LONG) hProv, 1 );
    hb_retl( bRet );
}

HB_FUNC( WIN_CRYPTCREATEHASH )
{
    HCRYPTHASH hHash = 0;
    BOOL bRet = CryptCreateHash( (HCRYPTPROV) hb_parnl(1), hb_parnl(2), (HCRYPTKEY) hb_parnl(3), hb_parnl(4), &hHash );
    hb_stornl( (LONG) hHash, 5 );
    hb_retl( bRet );
}

HB_FUNC( WIN_CRYPTHASHDATA )
{
    hb_retl( CryptHashData( (HCRYPTHASH) hb_parnl(1), (BYTE *) hb_parc(2), hb_parnl(3), hb_parnl(4) ) );
}

HB_FUNC( WIN_CRYPTDERIVEKEY )
{
    HCRYPTKEY hKey = 0;
    BOOL bRet = CryptDeriveKey( (HCRYPTPROV) hb_parnl(1), hb_parnl(2), (HCRYPTHASH) hb_parnl(3), hb_parnl(4), &hKey );
    hb_stornl( (LONG) hKey, 5 );
    hb_retl( bRet );
}

HB_FUNC( WIN_CRYPTDECRYPT )
{
    DWORD dwLen = (DWORD) hb_parnl(6);
    BYTE * pData = (BYTE *) hb_parc(5);
    BOOL bRet = CryptDecrypt( (HCRYPTKEY) hb_parnl(1), (HCRYPTHASH) hb_parnl(2), hb_parl(3), hb_parnl(4), pData, &dwLen );
    hb_stornl( (LONG) dwLen, 6 );
    hb_retl( bRet );
}

HB_FUNC( WIN_CRYPTENCRYPT )
{
    DWORD dwLen = (DWORD) hb_parnl(6);
    DWORD dwBufLen = (DWORD) hb_parnl(7);
    BYTE * pData = (BYTE *) hb_parc(5);
    BOOL bRet = CryptEncrypt( (HCRYPTKEY) hb_parnl(1), (HCRYPTHASH) hb_parnl(2), hb_parl(3), hb_parnl(4), pData, &dwLen, dwBufLen );
    hb_stornl( (LONG) dwLen, 6 );
    hb_retl( bRet );
}

HB_FUNC( WIN_CRYPTDESTROYKEY )
{
    hb_retl( CryptDestroyKey( (HCRYPTKEY) hb_parnl(1) ) );
}

HB_FUNC( WIN_CRYPTDESTROYHASH )
{
    hb_retl( CryptDestroyHash( (HCRYPTHASH) hb_parnl(1) ) );
}

HB_FUNC( WIN_CRYPTRELEASECONTEXT )
{
    hb_retl( CryptReleaseContext( (HCRYPTPROV) hb_parnl(1), hb_parnl(2) ) );
}

#pragma ENDDUMP