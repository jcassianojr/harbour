*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => C:\DEVELOP\CLIPPER\DBU\DBUGER.PRG
*+
*+    Functions: Function geradbf()
*+               Function SDF_CAB()
*+               Function DLM_CAB()
*+               Function DEF_CAB()
*+               Function CRIADEF()
*+               Function CRIADBF()
*+
*+    Reformatted by Click! 2.03 on Jun-27-2003 at  6:24 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ


*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function geradbf()
*+
*+    Called from ( dbu.prg      )   3 -
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func geradbf

para nTIPO          //Recebi Privado uso subfun‡”es
priv FILENAME := space( 20 )
do case
case nTIPO = 7
   aWORK := directory( "*.SDF" )
case nTIPO = 8
   aWORK := directory( "*.DLM" )
case nTIPO = 9
   aWORK := directory( "*.DBE" )
otherwise
   retu .F.
endcase
aNOMES := {}
aeval( aWORK, { | X | aadd( aNOMES, X[ 1 ] ) } )
if empty( aNOMES )
   aadd( aNOMES, space( 20 ) )
endif
do case
case nTIPO = 7
   FILEBOX( ".SDF", "aNOMES", "SDF_CAB", "CRIADBF", .F., 8 )
case nTIPO = 8
   FILEBOX( ".DLM", "aNOMES", "DLM_CAB", "CRIADBF", .F., 8 )
case nTIPO = 9
   FILEBOX( ".DEF", "aNOMES", "DEF_CAB", "CRIADEF", .F., 8 )
endcase
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function SDF_CAB()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func SDF_CAB

para sysparam
return box_title( M->sysparam, "Abrindo Construtor SDF..." )

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function DLM_CAB()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func DLM_CAB

para sysparam
return box_title( M->sysparam, "Abrindo Construtor DLM..." )

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function DEF_CAB()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func DEF_CAB

para sysparam
return box_title( M->sysparam, "Abrindo Reconstrutor DBE..." )

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function CRIADEF()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func CRIADEF

local TELA := savescreen( 0, 0, 24, 79 )
MAKEDBF( M->FILENAME,,,RDDNOME(TIPODBF))
restscreen( 0, 0, 24, 79, TELA )
retu .T.

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function CRIADBF()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func CRIADBF

dbf_name := substr( M->FILENAME, 1, at( ".", M->FILENAME ) - 1 )
if file( DBF_NAME + ".DBF" )
   if rsvp( "J  Existe o Arquivo Sobrepor " + dbf_name + ".DBF (S/N)" ) = "N"
      retu .T.
   endif
   ferase( DBF_NAME + ".DBF" )
endif
nhandle := hb_fopen( M->FILENAME )
if nHANDLE <= 0
   ALERTX( "Nao Foi Possivel Abrir Arquivo Constrututor" )
endif
PRIMEIRA := ""
MESSAGE  := ""
aESTRU   := {}
textline := ltrim( FREADLINE( nhandle ) )
while PRIMEIRA # TEXTLINE
   if nTIPO = 8     //Delimitado Troca Virgula Por Espa‡os
      TEXTLINE := strtran( TEXTLINE, ",", " " )
   endif
   if !empty( TEXTLINE )
      fld_name := upper( parse( @textline ) )               // Obtem nome campo
      fld_type := upper( parse( @textline ) )               // Obtem tipo campo
      fld_len  := parse( @textline )    // Obtem tamanho campo
      fld_dec  := parse( @textline )    // Obtem casas decimais campo
      if empty( fld_name ) .or. len( fld_name ) > 10
         message := 'Campo Nome'
      elseif empty( fld_type ) .or. len( fld_type ) > 1 ;
                       .or. .not. ( fld_type ) $ 'CDNLM'
         message := 'Campo Tipo'
      elseif empty( fld_len ) .or. .not. val( fld_len ) >= 0 ;
                       .or. val( fld_len ) > 999
         message := 'Campo Tamanho'

      elseif empty( fld_dec ) .or. .not. val( fld_dec ) >= 0 ;
                       .or. val( fld_dec ) > 999
         message := 'Campo decimais'
      endif
      if !empty( message )
         exit
      endif
      aadd( aESTRU, { fld_name, fld_type, val( fld_len ), val( fld_dec ) } )
   endif
   textline := ltrim( FREADLINE( nhandle ) )
enddo
if !empty( message )
   ALERTX( "Erro Estrutura de Construcao " + message )
   retu .F.
endif
fclose( nHANDLE )
dbcreate( dbf_name, aESTRU )
retu .T.

*+ EOF: DBUGER.PRG
