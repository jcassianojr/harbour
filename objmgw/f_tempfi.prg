// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : f_tempfi.prg
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

// ****************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function TMPFILE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION TMPFILE( extension, path )

// ****************************************************************

// Cria um nome de arquivo temporario exclusivo no disco selecionado.

// Copyright(c) 1991 - James Occhiogrosso


   LOCAL temp_ext, file_name, counter, handle

   file_name := ''

// Se nenhum caminho for especificado, usa unidade e diretorio atuais.
   IF PATH = NIL
      PATH := ''

      // Se o caminho for especificado sem barra invertida ('\'), a inclui.
   ELSEIF SubStr( PATH, - 1, 1 ) != '\'
      PATH := PATH + '\'

   ENDIF


   IF extension = NIL
      // Se a extensao nao for especificada, usa TMP.
      extension := 'TMP'
   ELSE
      // Ajusta a extensao ate' 3 caracteres (maximo permitido pelo DOS).
      extension := SubStr( Upper( extension ), 1, 3 )
   ENDIF


   FOR counter := 1 TO 9999

      // Cria um nome de arquivo exclusivo no formato TEMPnnnn.EXT
      IF Empty( extension )
         file_name := PATH + 'TEMP' + PadL( counter, 4, '0' ) + '.'
      ELSE
         file_name := PATH + 'TEMP' + PadL( counter, 4, '0' ) + ;
            '.' + extension
      ENDIF

      // Verifica se o nome de arquivo criado ja' existe.
      IF !File( file_name )
         EXIT
      ENDIF
   NEXT

   IF counter >= 9999
      // Se nao for encontrado um nome exclusivo, retorna uma cadeia nula
      file_name := ''

   ELSE
      // Ha' um nome de arquivo exclusivo. Cria e fecha o arquivo.
      handle    := FCreate( file_name )
      file_name := IF( FClose( handle ), file_name, '' )

   ENDIF

   RETURN ( file_name )

// + EOF: f_tempfi.prg
// +
