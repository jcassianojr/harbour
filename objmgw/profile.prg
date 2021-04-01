*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    PROFILE.PRG
*+
*+
*+  PUBLIC FUNCTIONS:
*+
*+  ProfileString( cINIFile, cSection, cKey, cDefault )
*+  ProfileNum( cINIFile, cSection, cKey, nDefault )
*+  ProfileDate( cINIFile, cSection, cKey, dDefault )
*+  ProfileLogical(cINIFile, cSection, cKey, lDefault )
*+  SetProfile( cINIFile, cSection, cKey, xValue )
*+
*+  ProfileString is used to read a string from the specified .INI file.
*+
*+  Eg. cSystemPath := ProfileString( "TEST.INI", "System", "Path", "." )
*+
*+
*+  ProfileNum is used to read a numeric value from the specified .INI file,
*+  including logical values (stored as 0 or 1).
*+
*+  Eg. nMaxUsers := ProfileNum( "TEST.INI", "System", "MaxUsers", 20 )
*+
*+  ProfileDate is used to read a date value from the specified .INI file.
*+  ( SetProfile stores dates in the format YYYYMMDD. )
*+
*+  Eg. dDownload := ProfileDate( "TEST.INI", "System", "LastDnld", DATE() )
*+
*+
*+  SetProfile is used to store a value of any data type except objects,
*+  code blocks & arrays in the .INI file.
*+
*+  lSuccess := SetProfile( "TEST.INI", "System", "MaxUsers", 20 )
*+
*+
*+  Place REQUEST Profile anywhere in your code, and compile with /N /W.
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+

#include "FileIO.ch"
#include "Set.ch"


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+  Function ProfileString()
*+  Parameters: cFile    - The .INI file name to be used
*+              cSection - The section from which to read
*+              cKey     - The key value for which to search
*+              cDefault - The default value if not found (optional)
*+
*+     Returns: cString - The string read from the file.
*+
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function ProfileString( cFile, cSection, cKey, cDefault )

local cString       
local nHandle       
local cBuffer       
local nFileLen      
local nSecPos       
local cSecBuf       
local nKeyPos       
local cChar         

if left( cSection, 1 ) <> "["
   cSection := "[" + cSection
endif

if right( cSection, 1 ) <> "]"
   cSection += "]"
endif

if cDefault == NIL
   cDefault := ""
endif

cString := cDefault

//
// If no extension is provided for the file, assume .INI.
//
if rat( ".", cFile ) == 0
   cFile := upper( alltrim( cFile ) ) + ".INI"
endif

nHandle := hb_fopen( cFile, FO_READ + FO_SHARED )

if nHandle > 0
   nFileLen := fseek( nHandle, 0, FS_END )

   fseek( nHandle, 0, FS_SET )

   cBuffer := space( nFileLen )

   //
   // Read in the entire file (.INI files should be less than 64K!).
   //
   if fread( nHandle, @cBuffer, nFileLen ) == nFileLen
      //
      // Determine the position in the buffer
      // of the requested section.
      //
      nSecPos := at( cSection, cBuffer )

      if nSecPos > 0
         //
         // Extract the section from the buffer.
         //
         cSecBuf := right( cBuffer, nFileLen - ( nSecPos + len( cSection ) ) -0) //-1

         if ! empty( cSecBuf )
            nSecPos := at( cKEY+"=", cSecBUF )
            if nSecPos > 0
               cSECBUF:=substr(cSECBUF,len(cKEY)+nSecPos+1)
               nSecPos := at( CHR(13)+CHR(10), cSecBUF )
               IF nSECPOS=0
                  nSecPos := at( CHR(10), cSecBUF )
               ENDIF
               if nSecPos > 0
                  cSTRING:=subStR(cSECBUF,1,nSECPOS-1)
               endif
            endif
         endif
      endif
   endif
   fclose( nHandle )
endif

return cString

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function ProfileNum()
*+
*+  This function reads a number from the specified .INI file.
*+
*+  Parameters: cFile    - The .INI file name to be used
*+              cSection - The section from which to read
*+              cKey     - The key value for which to search
*+              nDefault - The default value if not found (optional)
*+
*+     Returns: nValue - The numeric value read from the file.
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function ProfileNum( cFile, cSection, cKey, nDefault )

local cValue       
local cDefault     
local nValue       

if nDefault == NIL
   nDefault := 0
endif

nValue   := nDefault
cDefault := alltrim( str( nDefault ) )

cValue := ProfileString( cFile, cSection, cKey, cDefault )

if !empty( cValue )
   nValue := val( cValue )
endif

return nValue

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function ProfileDate()
*
*+  This function reads a date from the specified .INI file.
*+
*+  Parameters: cFile    - The .INI file name to be used
*+              cSection - The section from which to read
*+              cKey     - The key value for which to search
*+              dDefault - The default date if not found (optional)
*+
*+     Returns: dDate - The date value read from the file.
*
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function ProfileDate( cFile, cSection, cKey, dDefault )

local cDateFmt     
local cValue       
local cDefault     
local dDate        

if valtype( dDefault ) <> "D"
   dDefault := ctod( "" )
endif

dDate    := dDefault
cDefault := alltrim( dtos( dDefault ) )

cValue := ProfileString( cFile, cSection, cKey, cDefault )

if !empty( cValue )
   //
   // Try just converting the date as is.
   //
   dDate := ctod( cValue )

   if empty( dDate )
      //
      // If that doesn't work, convert
      // using a standard date format.
      //
      cDateFmt := set( _SET_DATEFORMAT, "mm/dd/yy" )

      dDate := ctod( substr( cValue, 5, 2 ) + "/" + right( cValue, 2 ) + ;
                     "/" + left( cValue, 4 ) )

      set( _SET_DATEFORMAT, cDateFmt )
   endif
endif

return dDate

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function SetProfile()
*+  This function writes a value to the .INI file specified.
*+
*+  Parameters: cFile    - The .INI file name to be used
*+              cSection - The section for which to search
*+              cKey     - The key value for which to search
*+              xValue   - The new value to be written
*+
*+     Returns: .T. if successful, .F. otherwise.
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function SetProfile( cFile, cSection, cKey, xValue )

local lRetCode      
local cType         
local cOldValue    
local cNewValue     
local nHandle       
local cBuffer       
local nFileLen     
local nSecStart     
local nSecEnd       
local nSecLen       
local cSecBuf       
local nKeyStart     
local nKeyEnd       
local nKeyLen       
local lProceed      
local cChar         

if left( cSection, 1 ) <> "["
   cSection := "[" + cSection
endif

if right( cSection, 1 ) <> "]"
   cSection += "]"
endif

//
// If no extension is provided for the file, assume .INI.
//
if rat( ".", cFile ) == 0
   cFile := upper( alltrim( cFile ) ) + ".INI"
endif

lProceed := .F.
nSecLen  := 0
cType    := valtype( xValue )

do case
case cType == "C"
   cNewValue := xValue

case cType == "N"
   cNewValue := alltrim( str( xValue ) )

case cType == "L"
   cNewValue := if( xValue, "1", "0" )

case cType == "D"
   cNewValue := dtos( xValue )

otherwise
   cNewValue := ""

endcase

nHandle := hb_fopen( cFile, FO_READ + FO_EXCLUSIVE )

if ferror() == 2
   nHandle := fcreate( cFile, 0 )
endif

if nHandle > 0
   nFileLen := fseek( nHandle, 0, FS_END )

   fseek( nHandle, 0, FS_SET )

   cBuffer := space( nFileLen )

   //
   // Read in the entire file (.INI files should be less than 64K!).
   //
   if fread( nHandle, @cBuffer, nFileLen ) == nFileLen
      //
      // Determine the position in the buffer
      // of the requested section.
      //
      nSecStart := at( cSection, cBuffer )

      if nSecStart > 0
         nSecStart += len( cSection ) + 2                   // Length of cSection + CR/LF

         //
         // Extract the section from the buffer.
         //
         cSecBuf := right( cBuffer, nFileLen - nSecStart + 1 )

         if !empty( cSecBuf )
            //
            // Get the position of the end of the section...
            //
            nSecEnd := at( "[", cSecBuf )

            //
            // ...and extract the section!
            //
            if nSecEnd > 0
               cSecBuf := left( cSecBuf, nSecEnd - 1 )
            endif

            nSecLen := len( cSecBuf )

            //
            // Now find the key within the section.
            //
            nKeyStart := at( cKey, cSecBuf )

            if nKeyStart > 0
               //
               // Load the return string with the value
               // until a carriage return is found.
               //
               nKeyStart += len( cKey ) + 1
               nKeyEnd   := nKeyStart

               cOldValue := cChar := ""

               do while cChar <> chr( 13 )
                  cChar := substr( cSecBuf, nKeyEnd, 1 )

                  if cChar <> chr( 13 )
                     cOldValue += cChar

                     ++ nKeyEnd
                  endif
               enddo

               //
               // Change the old value to the new one.
               //
               nKeyLen := len( cOldValue )
               cSecBuf := stuff( cSecBuf, nKeyStart, nKeyLen, cNewValue )

               lProceed := .T.
            else
               //
               // The key was not found - add it now!
               //
               //cSecBuf := HB_OsNewLine() + cKey + "=" + cNewValue + HB_OsNewLine()

               cSecBuf := cKey + "=" + cNewValue + HB_OsNewLine() + cSecBuf

               lProceed := .T.
            endif
         endif
      else
         //
         // The section was not found - add it now!
         //
         //cSecBuf := HB_OsNewLine() + cSection + HB_OsNewLine() + cKey + "=" + ;
         //               cNewValue + HB_OsNewLine()

         cSecBuf := cSection + HB_OsNewLine() + cKey + "=" + cNewValue + ;
                    HB_OsNewLine() + HB_OsNewLine()

         lProceed := .T.
      endif
   endif

   if lProceed
      //
      // Update the buffer with the new section.
      //
      if nSecStart == 0
         nSecStart := len( cBuffer )
      endif

      cBuffer := stuff( cBuffer, nSecStart, nSecLen, cSecBuf )

      //
      // troca existing .INI file.
      //
      fclose( nHandle )

      nHandle := fcreate( cFile, 0 )

      if fwrite( nHandle, cBuffer ) == len( cBuffer )
         lRetCode := .T.
      endif
   endif

   fclose( nHandle )
endif

return lRetCode


*+№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№
*+
*+    Function ProfileLogical()
*+
*+№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№
*+
FUNCTION ProfileLogical(cINIFile, cSection, cKey, lDefault )
LOCAL cVAL
cVAL:=ProfileString( cINIFile, cSection, cKey, lDefault )
RETURN StrLogic(cVAL,lDEFAULT)
