// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : f_mmopac.prg
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
// +    Documentado em 28-Dez-2024 as 10:41 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
// +
// +    Function MEMOPACK()
// +
// +нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

// +
#include "set.ch"
#include "dbinfo.ch"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MEMOPACK()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION MEMOPACK( packlist, lMES, lINFO, cUSORDD )  // Array Arquivos se texto convert array

   LOCAL counter
   LOCAL old_delete
   LOCAL real_recs
   LOCAL ret_value
   LOCAL cARQNOME
   LOCAL aRETVAL 
   PRIVATE temp_file
   
   //aRETVAL:={0,"",""}

   cOLDRDD := rddSetDefault()

   IF ValType( Packlist ) = "C"
      packlist := { packlist }   // 'funcao trabalha com matriz de arquivos se passar um arquivo cria a matriz com somente ele
   ENDIF


   ret_value := '0 - OK'

// Obtem um nome exclusivo de arquivo temporario de base de dados.
   temp_file := TIRAEXT( tmpfile( 'DBF' ) )


   FOR counter := 1 TO Len( packlist )

      cARQNOME := packlist[ counter ]

      IF !ISMEMO( cARQNOME, lMES, lINFO )  // varre a estrutura para ver ser se tem algum campo memo na f_ismemo
         EXIT
      ENDIF

      //nVERSAO := INFOTIPODBF( cARQNOME, lMES )  // traz o tipo pelo reader na f_ismemo
      
      aRETVAL:= INFOTIPODBF( cCaminho+dbf_name, .F. )
      nVERSAO := aRETVAL[1]

      IF !( nVERSAO = 131 .OR. nVERSAO = 245 .OR. nVERSAO = 139 )
         ret_value := '6 - Nao Possui Memo' + cARQNOME
         EXIT
      ENDIF

      IF Empty( cUSORDD )
         //cNTXEXT := ".DBT"   // rddSetDefault("DBTCDX")
         cNTXEXT := aRETVAL[1]
         //remover ifs versao futura com testes na infodbftipo retornando corretamente 
         IF nVERSAO = 139 .OR. nVERSAO = 132
            cNTXEXT := ".DBT"  // rddSetDefault( "DBFNTX )
         ENDIF
         IF nVERSAO = 245 .OR. nVERSAO = 48
            cNTXEXT := ".FPT"  // rddSetDefault( "FPTCDX" )
         ENDIF
         IF nVERSAO = 229
            cNTXEXT := ".SMT"  // rddSetDefault( "SMTCDX" )
         ENDIF
      ELSE
         cNTXEXT := hb_rddInfo( RDDI_MEMOEXT )   // a extensao do rdiinfo memo do destino vem com parametro
      ENDIF

      // Verifica se todos os arquivos do array especificado existem.
      IF !hb_FileExists( cARQNOME + '.DBF' )
         ret_value := '1 - Arquivo Dados Nao Encontrado ' + cARQNOME
         EXIT
      ENDIF

      IF !hb_FileExists( cARQNOME + cNTXEXT )
         ret_value := '7 - Arquivo Memoria Nao Encontrado ' + cARQNOME + Cntxext
         EXIT
      ENDIF

      // Abre a base de dados e obtem a contagem de registros.
      IF Empty( cUSORDD )
        cUSORDD := aRETVAL[2]
         //remover ifs versao futura com testes na infodbftipo retornando corretamente 
         
         
         IF memoflds = 131 .or. nVERSAO = 48
            rddSetDefault( cUSORDD )
         ENDIF
         IF memoflds = 245
            rddSetDefault( ccUSORDD  )
         ENDIF
         IF memoflds = 229
            rddSetDefault( cUSORDD  )
         ENDIF
         
         IF nVERSAO = 139
            ret_value := '8 - driver DBFMDX nao mais disponivel '
            EXIT
            // RDDSETDEFAULT("DBFMDX")
         ENDIF


      ELSE
         rddSetDefault( cUSORDD )
      ENDIF




      dbUseArea( .T.,, cARQNOME,, .F. )
      IF !NetErr()
         PACK

         real_recs := LastRec()

         // Grava o parametro deleted e desativa deleted.
         // (Para que os registros excluidos sejam copiados.)
         old_delete := Set( _SET_DELETED, .F. )

         nLASTREC := LastRec()
         // Copia para o arquivo temporario e o abre.
         zei_fort( nLASTREC,,, 0 )
         COPY TO &temp_file WHILE ZEI_FORT( nLASTREC,,, 1 )

         USE &temp_file
         //DBUseArea( <lNewArea> , <cDriver> , <cName>, <xcAlias> , <lShared> , <lReadOnly>,<cCodePage>,<nConnection> ) -> lSuccess         
         dbUseArea( .F.,, temp_file,, .F., .F. )


         // Recupera o parametro deleted original.
         Set( _SET_DELETED, old_delete )

         IF LastRec() = real_recs
            // Copia com exito se a contagem de registros for a mesma.
            dbCloseArea() //USE
            IF File( temp_file + cNTXEXT )

               // Remove os arquivos antigos.
               FErase( cARQNOME + '.dbf' )
               FErase( cARQNOME + cNTXEXT )

               // Verifica se eles foram removidos.
               IF ( hb_FileExists( cARQNOME + '.DBF' ) .OR. hb_FileExists( cARQNOME + cNTXEXT ) )
                  // Se ainda existirem, nao pode mudar seus nomes.
                  ret_value := '2 - Erro Copia Reserva' + cARQNOME
                  EXIT
               ENDIF

               // Troca nomes dos arqs.temporarios pelos especificados.
               FRename( temp_file + '.DBF', cARQNOME + '.dbf' )
               FRename( temp_file + cNTXEXT, cARQNOME + cNTXEXT )
               FErase( temp_file + '.DBF' )
               FErase( temp_file + cNTXEXT )

            ELSE
               // O arquivo temporario DBT nao foi encontrado.
               ret_value := '3 - Falta ' + cNTXEXT + " " + cARQNOME
               EXIT
            ENDIF
         ELSE
            // A base de dados foi copiada de forma incorreta.
            ret_value := '4 - Checagem Numero Registros' + cARQNOME
            EXIT
         ENDIF
      ELSE
         // Arquivo Nao Pode Ser Aberto
         ret_value := '5 - Nao Pode ser Aberto Exclusivo' + cARQNOME
         EXIT
      ENDIF
   NEXT
   rddSetDefault( cOLDRDD )

   RETURN ret_value

// + EOF: F_MMOPAC.PRG

// + EOF: f_mmopac.prg
// +
