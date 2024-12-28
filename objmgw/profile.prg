// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : profile.prg
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
// +    Documentado em 28-Dez-2024 as 10:42 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    PROFILE.PRG
// +
// +
// +  PUBLIC FUNCTIONS:
// +
// +  ProfileString( cINIFile, cSection, cKey, cDefault )
// +  ProfileNum( cINIFile, cSection, cKey, nDefault )
// +  ProfileDate( cINIFile, cSection, cKey, dDefault )
// +  ProfileLogical(cINIFile, cSection, cKey, lDefault )
// +  SetProfile( cINIFile, cSection, cKey, xValue )
// +
// +  ProfileString is used to read a string from the specified .INI file.
// +
// +  Eg. cSystemPath := ProfileString( "TEST.INI", "System", "Path", "." )
// +
// +
// +  ProfileNum is used to read a numeric value from the specified .INI file,
// +  including logical values (stored as 0 or 1).
// +
// +  Eg. nMaxUsers := ProfileNum( "TEST.INI", "System", "MaxUsers", 20 )
// +
// +  ProfileDate is used to read a date value from the specified .INI file.
// +  ( SetProfile stores dates in the format YYYYMMDD. )
// +
// +  Eg. dDownload := ProfileDate( "TEST.INI", "System", "LastDnld", DATE() )
// +
// +
// +  SetProfile is used to store a value of any data type except objects,
// +  code blocks & arrays in the .INI file.
// +
// +  lSuccess := SetProfile( "TEST.INI", "System", "MaxUsers", 20 )
// +
// +
// +  Place REQUEST Profile anywhere in your code, and compile with /N /W.
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

#include "FileIO.ch"
#include "Set.ch"


// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +  Function ProfileString()
// +  Parameters: cFile    - The .INI file name to be used
// +              cSection - The section from which to read
// +              cKey     - The key value for which to search
// +              cDefault - The default value if not found (optional)
// +
// +     Returns: cString - The string read from the file.
// +
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ProfileString()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ProfileString( cFile, cSection, cKey, cDefault )

   LOCAL cString
   LOCAL nHandle
   LOCAL cBuffer
   LOCAL nFileLen
   LOCAL nSecPos
   LOCAL cSecBuf
   LOCAL nKeyPos
   LOCAL cChar

   IF Left( cSection, 1 ) <> "["
      cSection := "[" + cSection
   ENDIF

   IF Right( cSection, 1 ) <> "]"
      cSection += "]"
   ENDIF

   IF cDefault == NIL
      cDefault := ""
   ENDIF

   cString := cDefault

//
// If no extension is provided for the file, assume .INI.
//
   IF RAt( ".", cFile ) == 0
      cFile := Upper( AllTrim( cFile ) ) + ".INI"
   ENDIF

   nHandle := FOpen( cFile, FO_READ + FO_SHARED )

   IF nHandle > 0
      nFileLen := FSeek( nHandle, 0, FS_END )

      FSeek( nHandle, 0, FS_SET )

      cBuffer := Space( nFileLen )

      //
      // Read in the entire file (.INI files should be less than 64K!).
      //
      IF FRead( nHandle, @cBuffer, nFileLen ) == nFileLen
         //
         // Determine the position in the buffer
         // of the requested section.
         //
         nSecPos := At( cSection, cBuffer )

         IF nSecPos > 0
            //
            // Extract the section from the buffer.
            //
            cSecBuf := Right( cBuffer, nFileLen - ( nSecPos + Len( cSection ) ) - 0 )   // -1

            IF !Empty( cSecBuf )
               nSecPos := At( cKEY + "=", cSecBUF )
               IF nSecPos > 0
                  cSECBUF := SubStr( cSECBUF, Len( cKEY ) + nSecPos + 1 )
                  nSecPos := At( Chr( 13 ) + Chr( 10 ), cSecBUF )
                  IF nSECPOS = 0
                     nSecPos := At( Chr( 10 ), cSecBUF )
                  ENDIF
                  IF nSecPos > 0
                     cSTRING := SubStr( cSECBUF, 1, nSECPOS - 1 )
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      FClose( nHandle )
   ENDIF

   RETURN cString

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function ProfileNum()
// +
// +  This function reads a number from the specified .INI file.
// +
// +  Parameters: cFile    - The .INI file name to be used
// +              cSection - The section from which to read
// +              cKey     - The key value for which to search
// +              nDefault - The default value if not found (optional)
// +
// +     Returns: nValue - The numeric value read from the file.
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ProfileNum()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ProfileNum( cFile, cSection, cKey, nDefault )

   LOCAL cValue
   LOCAL cDefault
   LOCAL nValue

   IF nDefault == NIL
      nDefault := 0
   ENDIF

   nValue   := nDefault
   cDefault := AllTrim( Str( nDefault ) )

   cValue := ProfileString( cFile, cSection, cKey, cDefault )

   IF !Empty( cValue )
      nValue := Val( cValue )
   ENDIF

   RETURN nValue

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function ProfileDate()
//
// +  This function reads a date from the specified .INI file.
// +
// +  Parameters: cFile    - The .INI file name to be used
// +              cSection - The section from which to read
// +              cKey     - The key value for which to search
// +              dDefault - The default date if not found (optional)
// +
// +     Returns: dDate - The date value read from the file.
//
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ProfileDate()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ProfileDate( cFile, cSection, cKey, dDefault )

   LOCAL cDateFmt
   LOCAL cValue
   LOCAL cDefault
   LOCAL dDate

   IF ValType( dDefault ) <> "D"
      dDefault := CToD( "" )
   ENDIF

   dDate    := dDefault
   cDefault := AllTrim( DToS( dDefault ) )

   cValue := ProfileString( cFile, cSection, cKey, cDefault )

   IF !Empty( cValue )
      //
      // Try just converting the date as is.
      //
      dDate := CToD( cValue )

      IF Empty( dDate )
         //
         // If that doesn't work, convert
         // using a standard date format.
         //
         cDateFmt := Set( _SET_DATEFORMAT, "mm/dd/yy" )

         dDate := CToD( SubStr( cValue, 5, 2 ) + "/" + Right( cValue, 2 ) + ;
            "/" + Left( cValue, 4 ) )

         Set( _SET_DATEFORMAT, cDateFmt )
      ENDIF
   ENDIF

   RETURN dDate

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function SetProfile()
// +  This function writes a value to the .INI file specified.
// +
// +  Parameters: cFile    - The .INI file name to be used
// +              cSection - The section for which to search
// +              cKey     - The key value for which to search
// +              xValue   - The new value to be written
// +
// +     Returns: .T. if successful, .F. otherwise.
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function SetProfile()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION SetProfile( cFile, cSection, cKey, xValue )

   LOCAL lRetCode
   LOCAL cType
   LOCAL cOldValue
   LOCAL cNewValue
   LOCAL nHandle
   LOCAL cBuffer
   LOCAL nFileLen
   LOCAL nSecStart
   LOCAL nSecEnd
   LOCAL nSecLen
   LOCAL cSecBuf
   LOCAL nKeyStart
   LOCAL nKeyEnd
   LOCAL nKeyLen
   LOCAL lProceed
   LOCAL cChar

   IF Left( cSection, 1 ) <> "["
      cSection := "[" + cSection
   ENDIF

   IF Right( cSection, 1 ) <> "]"
      cSection += "]"
   ENDIF

//
// If no extension is provided for the file, assume .INI.
//
   IF RAt( ".", cFile ) == 0
      cFile := Upper( AllTrim( cFile ) ) + ".INI"
   ENDIF

   lProceed := .F.
   nSecLen  := 0
   cType    := ValType( xValue )

   DO CASE
   CASE cType == "C"
      cNewValue := xValue

   CASE cType == "N"
      cNewValue := AllTrim( Str( xValue ) )

   CASE cType == "L"
      cNewValue := if( xValue, "1", "0" )

   CASE cType == "D"
      cNewValue := DToS( xValue )

   OTHERWISE
      cNewValue := ""

   ENDCASE

   nHandle := FOpen( cFile, FO_READ + FO_EXCLUSIVE )

   IF FError() == 2
      nHandle := FCreate( cFile, 0 )
   ENDIF

   IF nHandle > 0
      nFileLen := FSeek( nHandle, 0, FS_END )

      FSeek( nHandle, 0, FS_SET )

      cBuffer := Space( nFileLen )

      //
      // Read in the entire file (.INI files should be less than 64K!).
      //
      IF FRead( nHandle, @cBuffer, nFileLen ) == nFileLen
         //
         // Determine the position in the buffer
         // of the requested section.
         //
         nSecStart := At( cSection, cBuffer )

         IF nSecStart > 0
            nSecStart += Len( cSection ) + 2   // Length of cSection + CR/LF

            //
            // Extract the section from the buffer.
            //
            cSecBuf := Right( cBuffer, nFileLen - nSecStart + 1 )

            IF !Empty( cSecBuf )
               //
               // Get the position of the end of the section...
               //
               nSecEnd := At( "[", cSecBuf )

               //
               // ...and extract the section!
               //
               IF nSecEnd > 0
                  cSecBuf := Left( cSecBuf, nSecEnd - 1 )
               ENDIF

               nSecLen := Len( cSecBuf )

               //
               // Now find the key within the section.
               //
               nKeyStart := At( cKey, cSecBuf )

               IF nKeyStart > 0
                  //
                  // Load the return string with the value
                  // until a carriage return is found.
                  //
                  nKeyStart += Len( cKey ) + 1
                  nKeyEnd   := nKeyStart

                  cOldValue := cChar := ""

                  DO WHILE cChar <> Chr( 13 )
                     cChar := SubStr( cSecBuf, nKeyEnd, 1 )

                     IF cChar <> Chr( 13 )
                        cOldValue += cChar

                        ++nKeyEnd
                     ENDIF
                  ENDDO

                  //
                  // Change the old value to the new one.
                  //
                  nKeyLen := Len( cOldValue )
                  cSecBuf := Stuff( cSecBuf, nKeyStart, nKeyLen, cNewValue )

                  lProceed := .T.
               ELSE
                  //
                  // The key was not found - add it now!
                  //
                  // cSecBuf := HB_OsNewLine() + cKey + "=" + cNewValue + HB_OsNewLine()

                  cSecBuf := cKey + "=" + cNewValue + hb_osNewLine() + cSecBuf

                  lProceed := .T.
               ENDIF
            ENDIF
         ELSE
            //
            // The section was not found - add it now!
            //
            // cSecBuf := HB_OsNewLine() + cSection + HB_OsNewLine() + cKey + "=" + ;
            // cNewValue + HB_OsNewLine()

            cSecBuf := cSection + hb_osNewLine() + cKey + "=" + cNewValue + ;
               hb_osNewLine() + hb_osNewLine()

            lProceed := .T.
         ENDIF
      ENDIF

      IF lProceed
         //
         // Update the buffer with the new section.
         //
         IF nSecStart == 0
            nSecStart := Len( cBuffer )
         ENDIF

         cBuffer := Stuff( cBuffer, nSecStart, nSecLen, cSecBuf )

         //
         // troca existing .INI file.
         //
         FClose( nHandle )

         nHandle := FCreate( cFile, 0 )

         IF FWrite( nHandle, cBuffer ) == Len( cBuffer )
            lRetCode := .T.
         ENDIF
      ENDIF

      FClose( nHandle )
   ENDIF

   RETURN lRetCode


// +№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№
// +
// +    Function ProfileLogical()
// +
// +№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ProfileLogical()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ProfileLogical( cINIFile, cSection, cKey, lDefault )

   LOCAL cVAL

   cVAL := ProfileString( cINIFile, cSection, cKey, lDefault )

   RETURN StrLogic( cVAL, lDEFAULT )

// + EOF: profile.prg
// +
