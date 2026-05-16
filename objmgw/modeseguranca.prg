#include "hbwin.ch"

#define PROV_RSA_FULL       1
#define CRYPT_VERIFYCONTEXT 4026531840 // 0xF0000000
#define CALG_MD5            32771
#define CALG_RC2            26114

STATIC cChaveMestra := "Diretoria@Segura#2026!bancos"

// Retorna o caminho do arquivo config.dat
FUNCTION CaminhoArquivoCofre()
LOCAL cCaminho := hb_DirBase()
RETURN cCaminho + "config.dat"

// --- FUNÇÃO PARA DESCRIPTOGRAFAR (CryptoAPI no Harbour) ---
FUNCTION LerDoCofre( cSecaoBanco, cChave )
LOCAL cBufferHex, cBufferBin := ""
LOCAL hProv := 0, hHash := 0, hKey := 0
LOCAL nLen, i, cByte, cResult := ""

// 1. Lê o valor em Hexadecimal mascarado do arquivo .dat usando a API do Windows
cBufferHex := GetPvProfString( cSecaoBanco, cChave, "", CaminhoArquivoCofre() )

IF Empty( cBufferHex )
    RETURN ""
ENDIF

// 2. Converte a string Hexadecimal de volta para caracteres binários
FOR i := 1 TO Len( cBufferHex ) STEP 2
    cBufferBin += Chr( hb_HexToNum( SubStr( cBufferHex, i, 2 ) ) )
NEXT
nLen := Len( cBufferBin )

// 3. Inicializa o contexto da CryptoAPI do Windows de forma idêntica ao VB6
IF wapi_CryptAcquireContext( @hProv, NIL, NIL, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT )
    
    // Cria o Hash MD5 para derivar a chave baseada na senha mestra
    IF wapi_CryptCreateHash( hProv, CALG_MD5, 0, 0, @hHash )
        wapi_CryptHashData( hHash, cChaveMestra )
        
        // Deriva a chave RC2
        IF wapi_CryptDeriveKey( hProv, CALG_RC2, hHash, 0, @hKey )
            
            // Executa a descriptografia nativa do Windows no buffer
            IF wapi_CryptDecrypt( hKey, 0, .T., 0, @cBufferBin, @nLen )
                cResult := Left( cBufferBin, nLen )
            ENDIF
            
            wapi_CryptDestroyKey( hKey )
        ENDIF
        wapi_CryptDestroyHash( hHash )
    ENDIF
    wapi_CryptReleaseContext( hProv, 0 )
ENDIF

RETURN AllTrim( cResult )

// --- FUNÇÃO PARA GRAVAR NO COFRE (Caso precise criar registros pelo Harbour) ---
FUNCTION GravarNoCofre( cSecaoBanco, cChave, cValor )
LOCAL hProv := 0, hHash := 0, hKey := 0
LOCAL cBuffer, nLen, nBufLen, cHex := "", i
LOCAL lSucesso := .F.

IF wapi_CryptAcquireContext( @hProv, NIL, NIL, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT )
    IF wapi_CryptCreateHash( hProv, CALG_MD5, 0, 0, @hHash )
        wapi_CryptHashData( hHash, cChaveMestra )
        IF wapi_CryptDeriveKey( hProv, CALG_RC2, hHash, 0, @hKey )
            
            nLen    := Len( cValor )
            nBufLen := ( Int( nLen / 8 ) + 1 ) * 8
            cBuffer := cValor + Space( nBufLen - nLen )
            
            IF wapi_CryptEncrypt( hKey, 0, .T., 0, @cBuffer, @nLen, nBufLen )
                FOR i := 1 TO nLen
                    cHex += hb_NumToHex( Asc( SubStr( cBuffer, i, 1 ) ), 2 )
                NEXT
                // Grava no arquivo estruturado .dat
                WritePvProfString( cSecaoBanco, cChave, cHex, CaminhoArquivoCofre() )
                lSucesso := .T.
            ENDIF
            wapi_DestroyKey( hKey )
        ENDIF
        wapi_CryptDestroyHash( hHash )
    ENDIF
    wapi_CryptReleaseContext( hProv, 0 )
ENDIF
RETURN lSucesso

// --- FUNÇÃO PARA EXCLUIR ---
FUNCTION ExcluirBanco( cSecaoBanco )
RETURN WritePvProfString( cSecaoBanco, NIL, NIL, CaminhoArquivoCofre() )