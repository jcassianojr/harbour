// +--------------------------------------------------------------------
// +
// +    Programa  : f_makedb.prg
// +
// +     Sistema:  Modulo Recursos
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +--------------------------------------------------------------------
// +

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MAKEDBF(cArqDic, lQUIT, lCRIA, cDRIVER ,cCAMINHO)
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MAKEDBF( cArqDic, lQUIT, lCRIA, cDRIVER, cCAMINHO )

// ****************************************************************

// Cria ou recria os arquivos de base de dados de uma aplicacao

// Copyright(c) 1991 -- James Occhiogrosso

// Nota: Como o exito da operacao MAKEDBF pode afetar a integridade da
// aplicacao, envia uma mensagem de erro ao DOS se ocorrer algum erro
// que possa impedir a atualizacao para a versao correta.

#include "box.ch"
#include "dbinfo.ch"

#define f_names  1
#define f_types  2
#define f_lens   3
#define f_decs   4
#define f_ok     5

   LOCAL counter    := num_fields := pointer := 0
   LOCAL create_dbf := dbf_exist := old_cursor :=   old_exact := .F.
   LOCAL dbf_memo, memoext, temp_dbf, temp_dbt, temp_stru := ''
   LOCAL dbf_stru  := {}
   LOCAL lMEMO
   LOCAL i
   LOCAL cTAG
   LOCAL cCHAVEDBF
   LOCAL aRETVAL
   PRIVATE dbf_name := dbf_text := textline := '', handle := 0,   text_row := 7, new_stru := {}  
   PRIVATE new_index := {}
//   aRETVAL:={0,"",""}
   
  
   //pega pelo infodbf implantar 
    IF ValType( cDRIVER ) # "C"
      cDRIVER := "DBFCDX"
   ENDIF

   IF ValType( lQUIT ) # "L"
      lQUIT := .T.
   ENDIF
   IF ValType( lCRIA ) # "L"
      lCRIA := .F.
   ENDIF
   
    IF ValType( cCAMINHO ) # "C"
      cCAMINHO:=""
   ENDIF 

    cTAG      := ""
   CCHAVEDBF := ""
   cOLDRDD := rddSetDefault()
   nREGORI  := nREGDES := 0
   memoflds := -1

   IF ValType( cArqDic ) # "C"
      ERROUSO( 'Nao especificado arquivo dicionario', lQUIT, cOLDRDD )
      RETU
   ELSE
      // Retorna ao DOS se o arq. do dicion. de dados nao puder ser aberto.
      handle := hb_fOPEN( cArqDic )
      IF handle <= 0
         ERROUSO( 'Nao foi possivel abrir o arquivo dicionario' + cArqDic, lQUIT, cOLDRDD )
         RETU
      ENDIF
   ENDIF

// Grava a situacao do cursor e o desativa.
   old_cursor := SetCursor( .F. )

// Apresenta a tela de instalacao de MAKEDBF.

   @  1, 0 CLEAR TO 22, 79
   hb_DispBox( 1, 7, 22, 70, B_DOUBLE + " " )
   @  2, 7 SAY "|         S I S T E M A  D E  A T U A L I Z A ? ? O            |"
   @  3, 7 SAY "|--------------------------------------------------------------|"
   @  4, 7 SAY "|  Processo de atualizacao do Sistema. Os arquivo de dados sao |"
   @  5, 7 SAY "|  checados e atualizados quando necess rio. Seus dados nao se |"
   @  6, 7 SAY "|  perder?o . Aguarde este processo . N?o o interrompa.        |"
   @  7, 7 SAY "|--------------------------------------------------------------|"
// Obtem primeira definicao de base de dados a partir do dicion. de dados
   GETDBFDEF()

// Fica em loop enquanto houver linhas de def. de base de dados (DBFDEF).

   WHILE ! Empty( dbf_name )

      // Reinicializa as variaveis de controle do loop.
      create_dbf := .F.
      dbf_exist  := .F.

      // Verifica a existencia da base de dados.
      IF File( cCaminho+dbf_name + '.dbf' )
         // B. dados existe. Ativa sinaliz. e abre b. dados p/uso exclusivo.
         dbf_exist := .T.
         
         IF !netuse( cCaminho+dbf_name, cDRIVER, .F., .F., .T., .F., 30 )   
            SetCursor( .T. )
            IF Lquit
               QUIT
            ELSE
               RETU
            ENDIF
         ENDIF

         // Carrega as estruturas de arquivo para o array dbf_stru.
         dbf_stru   := dbStruct()
         num_fields := Len( dbf_stru )


         // Inclui e inicializa uma dimensao logica p/situacao dos campos.
         FOR counter := 1 TO num_fields
            ASize( dbf_stru[ counter ], 5 )
            dbf_stru[ counter,  5 ] = .F.
         NEXT

         // Abre e carrega arquivo temporario com definicoes de campo.
         LOADSTRU()


         // Ativa EXACT e verifica os campos em relacao ao dicion. de dados.
         old_exact := Set( _SET_EXACT, .T. )

         IF Len( new_stru ) != num_fields
            // A base e o dicionario de dados possuem numeros
            // diferentes de campos. Ativa o sinalizador de criacao.
            create_dbf := .T.
         ELSE
            // Testa todos os campos em relacao a definicoes do dicionario
            FOR counter := 1 TO num_fields

               IF dbf_stru[ counter,  f_names ] == ;
                     Trim( new_stru[ counter,  f_names ] )
                  // Nomes de campo iguais.
                  // Verifica tipo e tamanho.

                  IF new_stru[ counter,  f_types ] <> dbf_stru[ counter,  f_types ]
                     IF RecCount() > 0
                        ERROUSO( 'Campo tipo ' + Trim( new_stru[ counter,  f_names ] ) + ;
                           ' no arquivo ' + dbf_name + ' trocado. Nao e possivel continuar. ', lQUIT, cOLDRDD )
                        RETURN
                     ENDIF
                  ELSEIF new_stru[ counter,  f_lens ] != ;
                        dbf_stru[ counter,  f_lens ] .OR. ;
                        new_stru[ counter,  f_decs ] != ;
                        dbf_stru[ counter,  f_decs ]

                     // A definicao do dicionario nao e' igual `a da
                     // base de dados. Ativa sinalizador de criacao.
                     create_dbf := .T.

                  ELSE
                     // Sinalizador verificou campo no array f_ok.
                     dbf_stru[ counter,  f_ok ] = .T.
                  ENDIF

               ELSE
                  // Nome de campo alterado. Ativa sinaliz. de criacao.
                  create_dbf := .T.

               ENDIF
            NEXT
         ENDIF

         // Recupera as condicoes de entrada de EXACT.
         Set( _SET_EXACT, old_exact )

         // Verifica array de sinalizadores. Falso indica que o campo
         // existe na b. dados, mas nao no dicion. dados (Campo foi excluido).

         IF !create_dbf
            // Localiza exclusoes se sinaliz. de criacao nao estiver ativo.
            FOR counter := 1 TO num_fields
               IF !dbf_stru[ counter,  f_ok ]
                  // Um campo foi excluido. Ativa sinalizador de criacao
                  create_dbf := .T.
               ENDIF
            NEXT
         ENDIF
         
         // Guarda o Numero de Registro
         nREGORI := RecNo()
         dbCloseArea()


      ELSE
         // Base de dados nao existe. Ativa sinalizador para recria-la.
         LOADSTRU()
         create_dbf := .T.
      ENDIF

      
      // Testa os sinalizadores e recria a base de dados, se necessario.
      IF dbf_exist .AND. ( create_dbf .OR. lCRIA )

         // Existe uma base de dados antiga. Cria copias de seguranca.
         // Remove todas as copias de seguranca antigas, se houver.

         // Localiza na base de dados nomes de memo definidos.

         lMEMO    := ISMEMO( cCaminho+dbf_name, .F., .F. )
         //memoflds := INFOTIPODBF( cCaminho+dbf_name, .F. )
         aRETVAL:= INFOTIPODBF( cCaminho+dbf_name, .F. )
         memoflds := aRETVAL[1]
         memoext  := ""
         IF memoflds = 131
            memoext := ".DBT"
            cDRIVER := "DBFNTX"
            rddSetDefault(cDRIVER )
         ENDIF
         IF memoflds = 245
            memoext := ".FPT"
            cDRIVER := "DBFCDX"
            rddSetDefault( cDRIVER )
         ENDIF
         IF memoflds = 139   // Na memo pack tratara driver sem uso
            memoext := ".DBT"
            cDRIVER := "DBFCDX"
            rddSetDefault( cDRIVER )
         ENDIF
         IF memoflds = 229
            memoext := ".SMT"
            cDRIVER := "SMTCDX"
            rddSetDefault( cDRIVER )
         ENDIF

         IF Empty( memoext )
            memoext := hb_rddInfo( RDDI_MEMOEXT )
         ENDIF


         dbf_memo := cCaminho+dbf_name + MEMOEXT


         // Troca nome dos arquivos da base de dados antiga pelo da copia.
         IF lMEMO .AND. !File( dbf_memo )  // memoflds>0
            ERROUSO( 'Memo Arquivo ' + dbf_MEMO + " ausente.", lQUIT, cOLDRDD )
            RETU
         ENDIF
         temp_dbf := TMPFILE( "DBF" )
         FILECOPY( cCaminho+dbf_name + ".DBF", temp_dbf )
         IF lMEMO  // memoflds>0
            temp_dbt := StrTran( temp_dbf, ".DBF", MEMOEXT )
            FILECOPY( dbf_memo, temp_dbt )
         ENDIF


         IF !File( temp_dbf ) .OR. ( lmemo .AND. !File( temp_dbt ) )   // memoflds>0
            ERROUSO( 'Arquivos de reservas nao podem ser criados ' + dbf_name, lQUIT, cOLDRDD )
            RETURN
         ENDIF

         FErase( cCaminho+dbf_name + ".DBF" )
         IF lMEMO  // memoflds>0
            FErase( dbf_memo )
         ENDIF

         IF File( cCaminho+dbf_name + ".DBF" ) .OR. ( lMEMO .AND. File( dbf_memo ) )  // memoflds>0
            FErase( temp_dbf )
            FErase( temp_dbt )
            ERROUSO( 'Arquivos originais ainda existentes ', lQUIT, cOLDRDD )
            RETU
         ENDIF


      ENDIF


      IF create_dbf .OR. lCRIA

         // Move a tela para cima se estiver na linha inferior da janela.
         IF text_row = 21
            Scroll( 8, 9, 22, 68, 1 )
         ELSE
            text_row := text_row + 1
         ENDIF

         // Apresenta texto associado (balanceamento da linha de texto).
         @ text_row, 7  SAY 'í' + ' ' + SubStr( dbf_text, 1, 60 )
         @ text_row, 70 SAY 'í'

         // Cria novamente o arq. da b.dados a partir do arq. de estrutura.
         dbCreate( cCaminho+dbf_name, new_stru )



         // Se base de dados existir, copia todos os registros da copia.
         IF dbf_exist
            IF !netuse( cCaminho+dbf_name, cDRIVER, .F., .F., .T., .F., 30 )  
               SetCursor( .T. )
               IF lQUIT
                  QUIT
               ELSE
                  RETU
               ENDIF
            ENDIF

            nLASTREC := NetRegCount( temp_dbf )
            zei_fort( nLASTREC,,, 0 )
            APPEND FROM &temp_dbf WHILE zei_fort( nLASTREC,,, 1 )

            nREGDES := RecNo()
            PACK


            dbCloseArea()


            // Todos Registro Importados
            IF nREGORI = nREGDES
               FErase( temp_dbf )
               FErase( temp_dbt )
            ENDIF
            IF memoflds > 0
               MEMOPACK( cCaminho+dbf_name )
            ENDIF

         ENDIF


      ENDIF

      // cria indices se nao existir
      IF !File( cCaminho+dbf_name + hb_rddInfo( RDDI_ORDBAGEXT ) )
         IF netuse( cCaminho+dbf_name, cDRIVER, .F., .F., .T., .F., 30 )
            AltD()
            IF Len( new_index ) > 0
               FOR I := 1 TO Len( new_index )
                  cTAG      := new_index[ i, 1 ]
                  cCHAVEDBF := new_index[ i, 2 ]
                  cCAMINDEX :=cCaminho+dbf_name
                  ordCondSet(,,,,,, RecNo(),,,,,,,,,,,,, ) 
                  //
                  ordCreate( cCAMINDEX, cTAG, cCHAVEDBF, {|| &cCHAVEDBF}, )
                 // OrdCreate( <cIndexFile>, <cIndexName> , <cIndexExpr>, <bIndexExpr>, <lUnique> ) -> NIL
                  //INDEX ON &cCHAVEDBF TAG &cTAG TO &cCAMINDEX
               NEXT I
            ENDIF
            dbCloseArea()
         ELSE
            AltD()
         ENDIF
      ENDIF


      // Obtem prox. linha de def. da base de dados a partir do dicion. dados.
      GETDBFDEF()

   ENDDO //WHILE !Empty( dbf_name )

// fecha o arquivo de texto /Inclusao Jorge
   IF HANDLE # 0
      FClose( HANDLE )
   ENDIF

   SetCursor( old_cursor )

   rddSetDefault( cOLDRDD )

   RETURN .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function ERROUSO()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION ERROUSO( cMES, lQUIT, cOLDRDD )

   ?? Chr( 7 )
   ALERTX( cMES )
   IF lQUIT
      QUIT
   ELSE
      rddSetDefault( cOLDRDD )
   ENDIF
   RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function GETDBFDEF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

STATIC FUNCTION GETDBFDEF

// ****************************************************************

// Localiza e carrega proxima linha de def. da base de dados (DBFDEF).

// Obtem a proxima linha de definicao a partir do dicionario de dados.
   NEXTLINE()

// Localiza na linha o codigo de definicao da base de dados.

   IF Upper( SubStr( textline, 1, 6 ) ) = 'DBFDEF'
      // Se for uma linha valida de definicao da base de dados, retira
      // identificador de codigo DBFDEF.

      textline  := LTrim( SubStr( textline, 7 ) )
      dbf_name  := PARSE( @textline )
      dbf_text  := textline
      new_stru  := {}
      new_index := {}

   ELSE
      // Do contrario, define dbf_name como uma cadeia vazia e
      // nao altera a linha de texto.
      dbf_name := ''
   ENDIF

   RETURN ''



// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function NEXTLINE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION NEXTLINE


// Obtem a proxima linha de instrucao do arquivo de definicoes.

// Verifica o primeiro caracter da linha
   textline := '*'
   DO WHILE ( SubStr( textline, 1, 1 ) $ '*#' .OR. Empty( textline ) ) ;
         .AND. Upper( SubStr( textline, 1, 7 ) ) != 'ENDFILE'

      // Se nao for uma linha de comentario ou em branco, salta-a.
      textline := LTrim( FREADLINE( handle ) )

   ENDDO

   RETURN NIL



// +--------------------------------------------------------------------
// +
// +
// +
// +    Static Function LOADSTRU()
// +     arrega as definicoes da base de dados para o array de estruturas.
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
STATIC FUNCTION LOADSTRU

   LOCAL fld_dec   := fld_len := fld_name := fld_type := MESSAGE := ''
   LOCAL cTAG
   LOCAL cCHAVEDBF
   LOCAL cCHAVESQL

   cTAG      := ""
   cCHAVEDBF := ""
   cCHAVESQL := ""

// Apaga o novo array de estruturas.
   new_stru := {}

// Obtem a proxima linha de instrucao do arquivo de definicoes.
   NEXTLINE()

// Fica em loop ate' carregar o final do codigo de definicoes.
   DO WHILE Upper( SubStr( textline, 1, 6 ) ) != 'ENDDEF'

      // Obtem e verifica as definicoes de campo do dicionario de dados.

      fld_name := Upper( PARSE( @textline ) )  // Obtem nome campo
      fld_type := Upper( PARSE( @textline ) )  // Obtem tipo campo
      fld_len  := PARSE( @textline )   // Obtem tamanho campo
      fld_dec  := PARSE( @textline )   // Obtem casas decimais campo

      IF Empty( fld_name ) .OR. Len( fld_name ) > 10
         MESSAGE := 'Campo Nome'

      ELSEIF Empty( fld_type ) .OR. Len( fld_type ) > 1 ;
            .OR. !( fld_type ) $ 'CDNLM'
         MESSAGE := 'Campo Tipo'

      ELSEIF Empty( fld_len ) .OR. !Val( fld_len ) >= 0 ;
            .OR. Val( fld_len ) > 999
         MESSAGE := 'Campo Tamanho'

      ELSEIF Empty( fld_dec ) .OR. !Val( fld_dec ) >= 0 ;
            .OR. Val( fld_dec ) > 999
         MESSAGE := 'Campo decimais'

      ENDIF

      IF !Empty( message )
         ALERTX( MESSAGE + ' erro no dicionario de dados ..... ' + fld_name )
         ERROUSO( 'Texto linha = ' + SubStr( textline, 1, 60 ), lQUIT, cOLDRDD )
         RETU
      ELSE
         // Carrega cada definicao de campo para o array de estruturas.
         AAdd( new_stru, { fld_name, fld_type, ;
            Val( fld_len ), Val( fld_dec ) } )
      ENDIF

      // Obtem a proxima linha de instrucao do arquivo de definicoes.
      NEXTLINE()

   ENDDO

   IF Upper( SubStr( textline, 1, 6 ) ) = 'ENDDEF'
      NEXTLINE()
   ENDIF

   IF Upper( SubStr( textline, 1, 8 ) ) = "DEFINDEX"
      NEXTLINE()
      WHILE Upper( SubStr( textline, 1, 8 ) ) != 'ENDINDEX'
         // Obtem e verifica as definicoes de campo do dicionario de dados.
         cTAG      := Upper( PARSE( @textline ) )
         cCHAVEDBF := Upper( PARSE( @textline ) )
         cCHAVESQL := Upper( PARSE( @textline ) )
         AltD()
         // Carrega cada definicao de campo para o array de indices
         AAdd( new_index, { cTAG, cCHAVEDBF, cCHAVESQL } )
         NEXTLINE()
      ENDDO
   ENDIF


// Move o ponteiro para o inicio do arquivo.
   IF !Empty( Alias() )
      dbGoTop()
   ENDIF

   RETURN NIL



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function parse()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION parse( string )

// Extrai de uma cadeia uma palavra delimitada por espacos.
   LOCAL space_char
   LOCAL ret_string
// Remove os espacos `a esquerda.
   string := LTrim( string )
// Obtem a posicao do primeiro caracter de espaco em branco.
   space_char := At( ' ', string )
   IF space_char = 0
      // Se nao ha' brancos, retorna balanceamento da linha e apaga cadeia
      ret_string := string
      string     := ''
   ELSE
      // Retorna todos os caracteres ate' o proximo espaco em branco.
      ret_string := SubStr( string, 1, space_char - 1 )
      // Retira da cadeia a palavra removida.
      string := LTrim( SubStr( string, space_char ) )
   ENDIF

   RETURN ret_string

// + EOF: f_makedb.prg

