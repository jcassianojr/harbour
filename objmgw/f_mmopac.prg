*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MEMOPACK()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function MEMOPACK( packlist,lMES,lINFO ) //Array Arquivos se texto convert array

#include "set.ch"

local counter
local old_delete
local real_recs
local ret_value
local cARQNOME

private temp_file
cOLDRDD:=RDDSETDEFAULT()

if valtype(Packlist)="C"
   packlist:={packlist}
endif


ret_value := '0 - OK'

//  Obtem um nome exclusivo de arquivo temporario de base de dados.
temp_file := TIRAEXT(tmpfile( 'DBF' ))


for counter := 1 to len( packlist )

    cARQNOME:=packlist[ counter ]

    if ! ismemo(cARQNOME,lMES,lINFO)
       exit
    endif

    nVERSAO:=INFOTIPODBF(cARQNOME,lMES)
    //0 Sem memo 1 dbf/dbt 2 dbf/fpt

    IF ! (nVERSAO=1.OR.nVERSAO=2.or.nVERSAO=3)
      ret_value := '6 - Nao Possui Memo' + cARQNOME
      exit
    endif


    cNTXEXT:=".DBT"
    IF nVERSAO=2
       cNTXEXT:=".FPT"
    ENDIF

   //  Verifica se todos os arquivos do array especificado existem.
   if .not. HB_FILEEXISTS( cARQNOME + '.DBF' )
      ret_value := '1 - Arquivo Dados Nao Encontrado ' + cARQNOME
      exit
   endif

      if .not. HB_FILEEXISTS( cARQNOME + cNTXEXT )
      ret_value := '7 - Arquivo Memoria Nao Encontrado ' + cARQNOME+Cntxext
      exit
   endif

   //  Abre a base de dados e obtem a contagem de registros.
   IF nVERSAO=1
      RDDSETDEFAULT("DBFNTX")
   ENDIF
   IF nVERSAO=2
      RDDSETDEFAULT("DBFCDX")
   ENDIF
   IF nVERSAO=3
      RDDSETDEFAULT("DBFMDX")
   ENDIF
   
   DBUSEAREA(.T.,,cARQNOME,,.F.)
   if ! neterr()
      pack

      real_recs := lastrec()

      //  Grava o parametro deleted e desativa deleted.
      //  (Para que os registros excluidos sejam copiados.)
      old_delete := set( _SET_DELETED, .F. )

      nLASTREC:=LASTREC()
      //  Copia para o arquivo temporario e o abre.
      zei_fort( nLASTREC,,,0)
      COPY to &temp_file WHILE ZEI_FORT(nLASTREC,,,1)
      
      use &temp_file

      //  Recupera o parametro deleted original.
      set( _SET_DELETED, old_delete )

      if lastrec() = real_recs
         //  Copia com exito se a contagem de registros for a mesma.
         use
         if file( temp_file + cNTXEXT )

            //  Remove os arquivos antigos.
            ferase( cARQNOME + '.dbf' )
            ferase( cARQNOME + cNTXEXT )

            //  Verifica se eles foram removidos.
            if ( HB_FILEEXISTS( cARQNOME + '.DBF' ) .or. HB_FILEEXISTS( cARQNOME + cNTXEXT ) )
               //  Se ainda existirem, nao pode mudar seus nomes.
               ret_value := '2 - Erro Copia Reserva' + cARQNOME
               exit
            endif

            //  Troca nomes dos arqs.temporarios pelos especificados.
            frename( temp_file + '.DBF', cARQNOME + '.dbf' )
            frename( temp_file + cNTXEXT, cARQNOME + cNTXEXT )
            ferase( temp_file + '.DBF' )
            ferase( temp_file + cNTXEXT )

         else
            //  O arquivo temporario DBT nao foi encontrado.
            ret_value := '3 - Falta ' +cNTXEXT +" " + cARQNOME
            exit
         endif
      else
         //  A base de dados foi copiada de forma incorreta.
         ret_value := '4 - Checagem Numero Registros' + cARQNOME
         exit
      endif
   else
       // Arquivo Nao Pode Ser Aberto
      ret_value := '5 - Nao Pode ser Aberto Exclusivo' + cARQNOME
      exit
   endif
next
RDDSETDEFAULT(cOLDRDD)
return ret_value

*+ EOF: F_MMOPAC.PRG
