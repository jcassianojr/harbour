
#include "hbclass.ch"
#include "inkey.ch"

function editarq( cfile )


//Verificando tamanho do arquivo
if Filesize( cfile ) > 64000
   ALERTX( 'Arquivo Muito Grande para ediao' )
   return .F.
endif

//
PRIV GETLIST:={}

//Criando Arquivo Back inicial
if file( cfile )
   pospto := at( ".", cfile )
   bak    := substr( cfile, 1, pospto - 1 ) + '.bak'
   fileCOPY(cfile,bak)
endif

if ( empty( cfile ) )
   cfile := "semnome"
elseif ( rat( ".", cfile ) <= rat( "\", cfile ) )
   cfile += ".TXT"
end

oEditor := HBEditor():New( MemoRead(cFILE), 0, 0, MaxRow(), MaxCol(), .T. )
   
   

//   oEditor:SetColor( "W/B,N/BG" )
   oEditor:Display()
   
   while ( nKey := Inkey( 0 ) ) != K_ESC
      oEditor:Edit( nKey )
      oEditor:Display()
   end

return nil
