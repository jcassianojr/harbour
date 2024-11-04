*****************************************************************
FUNCTION MAKEDBF (cArqDic,lQUIT,lCRIA,cDRIVER)
*****************************************************************

* Cria ou recria os arquivos de base de dados de uma aplicacao

* Copyright(c) 1991 -- James Occhiogrosso

* Nota: Como o exito da operacao MAKEDBF pode afetar a integridade da
* aplicacao, envia uma mensagem de erro ao DOS se ocorrer algum erro
* que possa impedir a atualizacao para a versao correta.

# include "box.ch"
# include "dbinfo.ch"

# define f_names  1
# define f_types  2
# define f_lens   3
# define f_decs   4
# define f_ok     5

LOCAL counter := num_fields := pointer := 0
LOCAL create_dbf := dbf_exist := old_cursor :=     ;
      old_exact := .F.
LOCAL dbf_memo,memoext,temp_dbf,temp_dbt,temp_stru := ''
LOCAL dbf_stru := {}
LOCAL lMEMO
LOCAL i
LOCAL cTAG
LOCAL cCHAVEDBF
cTAG:=""
CCHAVEDBF:=""

cOLDRDD:=RDDSETDEFAULT()

nREGORI:=nREGDES:=0
memoflds := -1
IF VALTYPE(cDRIVER)#"C"
   cDRIVER:="DBFCDX"
ENDIF

PRIVATE dbf_name := dbf_text := textline := '', handle := 0,   ;
        text_row := 7, new_stru := {}
PRIVATE new_index := {}
IF VALTYPE(lQUIT)#"L"
    lQUIT:=.T.
ENDIF
IF VALTYPE(lCRIA)#"L"
    lCRIA:=.F.
ENDIF


IF VALTYPE(cArqDic)#"C"
    ERROUSO('N?o especificado arquivo dicion rio',lQUIT,cOLDRDD)
    RETU
ELSE
    * Retorna ao DOS se o arq. do dicion. de dados nao puder ser aberto.
    handle = hb_fOPEN(cArqDic)
    IF handle <= 0
        ERROUSO('N?o foi poss­vel abrir o arquivo dicion rio'+cArqDic,lQUIT,cOLDRDD)
        RETU
    ENDIF
ENDIF

* Grava a situacao do cursor e o desativa.
old_cursor = SETCURSOR(.F.)

* Apresenta a tela de instalacao de MAKEDBF.

@ 1, 0 CLEAR TO 22,79
HB_dispbox( 1, 7, 22, 70,B_DOUBLE+" ")
@ 2, 7 SAY "|         S I S T E M A  D E  A T U A L I Z A ? ? O            |"
@ 3, 7 SAY "|--------------------------------------------------------------|"
@ 4, 7 SAY "|  Processo de atualizacao do Sistema. Os arquivo de dados sao |"
@ 5, 7 SAY "|  checados e atualizados quando necess rio. Seus dados nao se |"
@ 6, 7 SAY "|  perder?o . Aguarde este processo . N?o o interrompa.        |"
@ 7, 7 SAY "|--------------------------------------------------------------|"
* Obtem primeira definicao de base de dados a partir do dicion. de dados
GETDBFDEF()

* Fica em loop enquanto houver linhas de def. de base de dados (DBFDEF).

DO WHILE .NOT. EMPTY(dbf_name)

   * Reinicializa as variaveis de controle do loop.
   create_dbf = .F.
   dbf_exist = .F.

   * Verifica a existencia da base de dados.
   IF file(dbf_name + '.dbf')
      * B. dados existe. Ativa sinaliz. e abre b. dados p/uso exclusivo.
      dbf_exist = .T.
      IF ! netuse(dbf_name,cDRIVER,.F.,.F.,.T.,.F.,30) //BREDE(DBF_NAME,0,.T.,.T.)
		  SetCursor(.t.)
          if Lquit
             QUIT
          else
            retu
          endif
      ENDIF

      * Carrega as estruturas de arquivo para o array dbf_stru.
      dbf_stru = DBSTRUCT()
      num_fields = LEN(dbf_stru)


      * Inclui e inicializa uma dimensao logica p/situacao dos campos.
      FOR counter = 1 TO num_fields
         ASIZE(dbf_stru[counter], 5)
         dbf_stru[counter][5] = .F.
      NEXT

      * Abre e carrega arquivo temporario com definicoes de campo.
      LOADSTRU()


      * Ativa EXACT e verifica os campos em relacao ao dicion. de dados.
      old_exact = SET(_SET_EXACT, .T.)

      IF LEN(new_stru) != num_fields
         * A base e o dicionario de dados possuem numeros
         * diferentes de campos. Ativa o sinalizador de criacao.
         create_dbf = .T.
      ELSE
         * Testa todos os campos em relacao a definicoes do dicionario
         FOR counter = 1 TO num_fields

            IF dbf_stru[counter][f_names] == ;
                  TRIM(new_stru[counter][f_names])
                  * Nomes de campo iguais.
                  * Verifica tipo e tamanho.

                  IF  new_stru[counter][f_types] <> dbf_stru[counter][f_types]
                      IF reccount()>0
                         ERROUSO('Campo tipo '+TRIM(new_stru[counter][f_names])+  ;
                               ' no arquivo ' + dbf_name + ' trocado. Nao e possivel continuar. ',lQUIT,cOLDRDD)
                         RETUrn
                      ENDIF   
                  ELSEIF new_stru[counter][f_lens]  !=     ;
                         dbf_stru[counter][f_lens]  .OR.   ;
                         new_stru[counter][f_decs]  !=     ;
                         dbf_stru[counter][f_decs]

                         * A definicao do dicionario nao e' igual `a da
                         * base de dados. Ativa sinalizador de criacao.
                         create_dbf = .T.

                  ELSE
                      * Sinalizador verificou campo no array f_ok.
                      dbf_stru[counter][f_ok] = .T.
                  ENDIF

            ELSE
                  * Nome de campo alterado. Ativa sinaliz. de criacao.
                  create_dbf = .T.

            ENDIF
         NEXT
      ENDIF

      * Recupera as condicoes de entrada de EXACT.
      SET(_SET_EXACT, old_exact)

      * Verifica array de sinalizadores. Falso indica que o campo
      * existe na b. dados, mas nao no dicion. dados (Campo foi excluido).

      IF ! create_dbf
          * Localiza exclusoes se sinaliz. de criacao nao estiver ativo.
          FOR counter = 1 TO num_fields
              IF ! dbf_stru[counter][f_ok]
                  * Um campo foi excluido. Ativa sinalizador de criacao
                  create_dbf = .T.
              ENDIF
          NEXT
      ENDIF

   ELSE
       * Base de dados nao existe. Ativa sinalizador para recria-la.
       LOADSTRU()
       create_dbf = .T.
   ENDIF

   //Guarda o Numero de Registro
   nREGORI:=RECNO()
   DBCLOSEAREA()

  
   * Testa os sinalizadores e recria a base de dados, se necessario.
   IF dbf_exist .AND. (create_dbf .OR. lCRIA)

        * Existe uma base de dados antiga. Cria copias de seguranca.
        * Remove todas as copias de seguranca antigas, se houver.

        * Localiza na base de dados nomes de memo definidos.

        lMEMO:=ISMEMO(dbf_name,.f.,.f.)
        memoflds = INFOTIPODBF(dbf_name,.F.)
        memoext=""
        if memoflds=131
           memoext= ".DBT"
           RDDSETDEFAULT("DBFNTX")
        endif
        if memoflds=245
           memoext= ".FPT"
           cDRIVER="DBFCDX"
           RDDSETDEFAULT("DBFCDX")
        endif
        if memoflds=139 //Na memo pack tratara driver sem uso
           memoext= ".DBT"
           cDRIVER="DBFCDX"
           RDDSETDEFAULT("DBFMDX")
        endif
        if memoflds=229
           memoext= ".SMT"
           cDRIVER="SMTCDX"
           RDDSETDEFAULT("SMTCDX")
        endif

		if empty(memoext)
		   memoext:=hb_rddInfo( RDDI_MEMOEXT)
		endif
		

        dbf_memo:=dbf_name+MEMOEXT


        * Troca nome dos arquivos da base de dados antiga pelo da copia.
        IF lMEMO .AND. .NOT. file(dbf_memo) //memoflds>0
           ERROUSO('Memo Arquivo ' + dbf_MEMO +" ausente.",lQUIT,cOLDRDD)
           RETU
        ENDIF
        temp_dbf:=TMPFILE("DBF")
        FILECOPY(dbf_name+".DBF",temp_dbf)
        IF lMEMO //memoflds>0
           temp_dbt:=STRTRAN(temp_dbf,".DBF",MEMOEXT)
           FILECOPY(dbf_memo,temp_dbt)
        ENDIF


        IF .NOT. file(temp_dbf) .OR.  (lmemo .AND. ! file(temp_dbt)) //memoflds>0
             ERROUSO('Arquivos de reservas nao podem ser criados ' + dbf_name,lQUIT,cOLDRDD)
             RETURN 
        ENDIF

        FERASE(dbf_name+".DBF")
        IF lMEMO //memoflds>0
           FERASE(dbf_memo)
        ENDIF

         IF  file(dbf_name+".DBF") .OR. (lMEMO .AND.  file(dbf_memo)) //memoflds>0
             FERASE(temp_dbf)
             FERASE(temp_dbt)
             ERROUSO('Arquivos originais ainda existentes ',lQUIT,cOLDRDD)
             RETU
        ENDIF


   ENDIF
   

   IF create_dbf .OR.lCRIA

        * Move a tela para cima se estiver na linha inferior da janela.
        IF text_row = 21
           SCROLL(8, 9, 22, 68, 1)
        ELSE
            text_row = text_row + 1
        ENDIF

        * Apresenta texto associado (balanceamento da linha de texto).
        @ text_row, 7 SAY 'н' + ' ' + SUBSTR(dbf_text, 1, 60)
        @ text_row, 70 SAY 'н'

        * Cria novamente o arq. da b.dados a partir do arq. de estrutura.
        DBCREATE(dbf_name, new_stru)



        * Se base de dados existir, copia todos os registros da copia.
        IF dbf_exist
            IF ! netuse(dbf_name,cDRIVER,.F.,.F.,.T.,.F.,30) //BREDE(DBF_NAME,0,.T.,.T.)
				SetCursor(.t.)
                IF lQUIT
                    QUIT
                ELSE
                    RETU
                ENDIF
            ENDIF

            nLASTREC:=NetRegCount(temp_dbf)
            zei_fort( nLASTREC,,,0)
            APPEND FROM &temp_dbf while zei_fort(nLASTREC,,,1)

            nREGDES:=RECNO()
            pack
            
            
            dbclosearea()


            //Todos Registro Importados
            IF nREGORI=nREGDES
               FERASE(temp_dbf)
               FERASE(temp_dbt)
            ENDIF
            IF memoflds>0
               MEMOPACK(dbf_name)
            ENDIF

        ENDIF


   ENDIF
   
    //cria indices se nao existir 
            IF ! FILE(dbf_name+hb_rddInfo( RDDI_ORDBAGEXT))
                IF netuse(dbf_name,cDRIVER,.F.,.F.,.T.,.F.,30) 
                    altd()
                    IF LEN(new_index)>0
                        FOR I= 1 TO LEN(new_index)
                            cTAG:=new_index[i][1]
                             cCHAVEDBF:=new_index[i][2]
                            index on &cCHAVEDBF tag &cTAG to &dbf_name
                        NEXT I
                    endif
                    dbclosearea()
                else
                    altd()    
                endif
            ENDIF
   

   * Obtem prox. linha de def. da base de dados a partir do dicion. dados.
   GETDBFDEF()

ENDDO WHILE .NOT. EMPTY(dbf_name)

* fecha o arquivo de texto /Inclusao Jorge
IF HANDLE#0
   FCLOSE(HANDLE)
ENDIF

SETCURSOR(old_cursor)

RDDSETDEFAULT(cOLDRDD)

RETURN .T.


STATIC FUNCTION ERROUSO(cMES,lQUIT,cOLDRDD)
?? CHR(7)
ALERTX(cMES)
IF lQUIT
   QUIT
ELSE
   RDDSETDEFAULT(cOLDRDD)
ENDIF
RETU .T.

*****************************************************************
STATIC FUNCTION GETDBFDEF
*****************************************************************

* Localiza e carrega proxima linha de def. da base de dados (DBFDEF).

* Obtem a proxima linha de definicao a partir do dicionario de dados.
NEXTLINE()

* Localiza na linha o codigo de definicao da base de dados.

IF UPPER(SUBSTR(textline, 1, 6)) = 'DBFDEF'
    * Se for uma linha valida de definicao da base de dados, retira
    * identificador de codigo DBFDEF.

    textline = LTRIM(SUBSTR(textline, 7))
    dbf_name = PARSE(@textline)
    dbf_text = textline
    new_stru = {}
    new_index ={}

ELSE
    * Do contrario, define dbf_name como uma cadeia vazia e
    * nao altera a linha de texto.
    dbf_name = ''
ENDIF

RETURN ''



*****************************************************************
STATIC FUNCTION NEXTLINE
*****************************************************************

* Obtem a proxima linha de instrucao do arquivo de definicoes.

* Verifica o primeiro caracter da linha
textline = '*'
DO WHILE (SUBSTR(textline, 1, 1) $ '*#' .OR. EMPTY(textline))  ;
        .AND. UPPER(SUBSTR(textline, 1, 7)) != 'ENDFILE'

     * Se nao for uma linha de comentario ou em branco, salta-a.
    textline = LTRIM(FREADLINE(handle))

ENDDO
RETURN NIL


*****************************************************************
STATIC FUNCTION LOADSTRU
*****************************************************************

* Carrega as definicoes da base de dados para o array de estruturas.

LOCAL fld_dec := fld_len := fld_name := fld_type := message := ''
LOCAL cTAG
LOCAL cCHAVEDBF
LOCAL cCHAVESQL

cTAG:=""
cCHAVEDBF:=""
cCHAVESQL:=""

* Apaga o novo array de estruturas.
new_stru := {}

* Obtem a proxima linha de instrucao do arquivo de definicoes.
NEXTLINE()

* Fica em loop ate' carregar o final do codigo de definicoes.
DO WHILE UPPER(SUBSTR(textline, 1, 6)) != 'ENDDEF'

    * Obtem e verifica as definicoes de campo do dicionario de dados.

    fld_name = UPPER(PARSE(@textline))     && Obtem nome campo
    fld_type = UPPER(PARSE(@textline))     && Obtem tipo campo
    fld_len  = PARSE(@textline)            && Obtem tamanho campo
    fld_dec  = PARSE(@textline)            && Obtem casas decimais campo

    IF EMPTY(fld_name) .OR. LEN(fld_name) > 10
         message = 'Campo Nome'

    ELSEIF EMPTY(fld_type) .OR. LEN(fld_type) > 1  ;
                           .OR. .NOT. (fld_type) $ 'CDNLM'
         message = 'Campo Tipo'

    ELSEIF EMPTY(fld_len) .OR. .NOT. VAL(fld_len) >= 0 ;
                          .OR. VAL(fld_len) > 999
         message = 'Campo Tamanho'

    ELSEIF EMPTY(fld_dec) .OR. .NOT. VAL(fld_dec) >= 0 ;
                          .OR. VAL(fld_dec) > 999
         message = 'Campo decimais'

    ENDIF

    IF .NOT. EMPTY(message)
        ALERTX(message + ' erro no dicionario de dados ..... ' + fld_name)
        ERROUSO('Texto linha = ' + SUBSTR(textline,1,60),lQUIT,cOLDRDD)
        RETU
    ELSE
        * Carrega cada definicao de campo para o array de estruturas.
        AADD(new_stru, { fld_name, fld_type,  ;
                         VAL(fld_len), VAL(fld_dec) } )
    ENDIF

    * Obtem a proxima linha de instrucao do arquivo de definicoes.
    NEXTLINE()

ENDDO

IF UPPER(SUBSTR(textline, 1, 6)) = 'ENDDEF'
   NEXTLINE()
ENDIF

IF UPPER(SUBSTR(textline, 1, 8))="DEFINDEX"
    NEXTLINE()
    WHILE UPPER(SUBSTR(textline, 1, 8)) != 'ENDINDEX'
        * Obtem e verifica as definicoes de campo do dicionario de dados.
        cTAG = UPPER(PARSE(@textline))     
        cCHAVEDBF = UPPER(PARSE(@textline))     
        cCHAVESQL = UPPER(PARSE(@textline))          
        ALTD()
            * Carrega cada definicao de campo para o array de indices
        AADD(new_index,{cTAG,cCHAVEDBF,cCHAVESQL})        
        NEXTLINE()
   ENDDO
ENDIF


* Move o ponteiro para o inicio do arquivo.
IF ! EMPTY(ALIAS())
   DBGOTOP()
ENDIF
RETURN NIL


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function parse()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function parse( string )

//  Extrai de uma cadeia uma palavra delimitada por espacos.
local space_char
local ret_string
//  Remove os espacos `a esquerda.
string := ltrim( string )
//  Obtem a posicao do primeiro caracter de espaco em branco.
space_char := at( ' ', string )
if space_char = 0
   //  Se nao ha' brancos, retorna balanceamento da linha e apaga cadeia
   ret_string := string
   string     := ''
else
   //  Retorna todos os caracteres ate' o proximo espaco em branco.
   ret_string := substr( string, 1, space_char - 1 )
   //  Retira da cadeia a palavra removida.
   string := ltrim( substr( string, space_char ) )
endif
return ret_string
