#include "hbwin.ch"
#include "fileio.ch"

PROCEDURE Main()
    LOCAL cFileName := "C:\Windows\System32\kernel32.dll"
    LOCAL nInfoSize, pInfo, cInfo
    LOCAL nTranslate, pTranslate
    LOCAL cSubBlock, pValue, nValueLen
    LOCAL cCompanyName, cFileDescription, cFileVersion, cProductName, cProductVersion

    // Get the size of the version information
    nInfoSize := GetFileVersionInfoSize(cFileName, 0)
   
    IF nInfoSize == 0
        ? "Failed to get version info size."
        RETURN
    ENDIF

    // Allocate memory for the version information
    pInfo := hb_xgrab(nInfoSize)

    // Get the version information
    IF !GetFileVersionInfo(cFileName, 0, nInfoSize, pInfo)
        ? "Failed to get version info."
        hb_xfree(pInfo)
        RETURN
    ENDIF

    // Get the translation info
    IF !VerQueryValue(pInfo, "\VarFileInfo\Translation", @pTranslate, @nTranslate)
        ? "Failed to get translation info."
        hb_xfree(pInfo)
        RETURN
    ENDIF

    // Create the sub block string based on the language and code page
    cSubBlock := "\StringFileInfo\" + ;
                 hb_NumToHex(hb_BPeek(pTranslate, 1), 4) + ;
                 hb_NumToHex(hb_BPeek(pTranslate, 3), 4) + "\"

    // Retrieve various version information strings
    cCompanyName := GetVersionString(pInfo, cSubBlock + "CompanyName")
    cFileDescription := GetVersionString(pInfo, cSubBlock + "FileDescription")
    cFileVersion := GetVersionString(pInfo, cSubBlock + "FileVersion")
    cProductName := GetVersionString(pInfo, cSubBlock + "ProductName")
    cProductVersion := GetVersionString(pInfo, cSubBlock + "ProductVersion")

    // Display the retrieved information
    ? "Company Name:", cCompanyName
    ? "File Description:", cFileDescription
    ? "File Version:", cFileVersion
    ? "Product Name:", cProductName
    ? "Product Version:", cProductVersion

    // Free the allocated memory
    hb_xfree(pInfo)

RETURN

FUNCTION GetVersionString(pInfo, cSubBlock)
    LOCAL pValue, nValueLen, cValue := ""

    IF VerQueryValue(pInfo, cSubBlock, @pValue, @nValueLen)
        cValue := hb_BSubStr(pValue, 1, nValueLen - 1)
    ENDIF

RETURN cValue
