
#include "try.ch"

#define BIF_RETURNONLYFSDIRS  1   
#define BIF_NONEWFOLDERBUTTON 512 


/* lAllowNewFolder: .T. permite criar pasta, .F. desabilita
*/
FUNCTION SelectFolder( cTitle, cInitialPath, lAllowNewFolder )
   LOCAL oShell, oFolder, cPath := ""
   LOCAL nOptions := BIF_RETURNONLYFSDIRS

   // Define o padrão se não for informado
   if valtype(lAllowNewFolder)<>"L"
       lAllowNewFolder:= .F.
   endif
   if valtype(cTitle)<>"C" .OR. EMPTY(cTitle)    
      cTitle:="Selecione uma pasta"
   endif
   if valtype(cInitialPath)<>"C" .OR. EMPTY(cInitialPath)    
      cInitialPath:= nil
   endif

   IF ! Empty( cInitialPath ) .AND. SubStr( cInitialPath, Len( cInitialPath ), 1 ) == "\"
      cInitialPath := SubStr( cInitialPath, 1, Len( cInitialPath ) - 1 )
   ENDIF   

   // Se lAllowNewFolder for .F., adicionamos a flag para desabilitar o botão
   IF !lAllowNewFolder
      nOptions += BIF_NONEWFOLDERBUTTON
   ENDIF

   TRY
      oShell := CreateObject( "Shell.Application" )
      
      // O 4º parâmetro (root) aceita caminhos absolutos no Windows moderno
      oFolder := oShell:BrowseForFolder( 0, cTitle, nOptions, cInitialPath )

      IF ValType( oFolder ) == "O" .AND. oFolder != NIL
         // Verificamos se o método Self existe antes de acessar
         IF HB_IsObject( oFolder:Self )
            cPath := oFolder:Self:Path
         ENDIF
      ENDIF
   CATCH
      cPath := ""
   END

RETURN cPath
