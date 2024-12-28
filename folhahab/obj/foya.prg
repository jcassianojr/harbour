*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foya.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 27-Dez-2024 as  9:46 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :       FOYA.PRG: Atualizando Arquivos de Trabalho
// :
// :*****************************************************************************


MDS('Aguarde Atualizando tabelas')
//os arquivos do aci vem com delimitador linux chr 10 pspad,notepad... trocar para limitador linha dos chr(13)+chr(10)
//cbo http://www.mtecbo.gov.br/cbosite/pages/downloads.jsf
//incluir CBO2002PerfilOcupacional,csv
//https://caged.maisemprego.mte.gov.br/portalcaged/paginas/TL_downloads.xhtml
for x := 1 to 10
   do case
   case x = 1
      cARQTXT := "CBO2002Grandegrupo.csv"
      cARQCBO := "FO_CBOG"
   case x = 2
      cARQTXT := "CBO2002SubGrupoPrincipal.csv"
      cARQCBO := "FO_CBOG"
   case x = 3
      cARQTXT := "CBO2002SubGrupo.csv"
      cARQCBO := "FO_CBOG"
   case x = 4
      cARQTXT := "CBO2002Familia.csv"
      cARQCBO := "FO_CBOG"
   case x = 5
      cARQTXT := "CBO2002ocupacao.csv"
      cARQCBO := "FO_CBON"
   case x = 6
      cARQTXT := "CBO2002sinonimo.csv"
      cARQCBO := "FO_CBOD"
   case x = 7
      cARQTXT := "aci_cbo.data"
      cARQCBO := "FO_CBON"
   case x = 8
      cARQTXT := "aci_atividade_economica.data"
      cARQCBO := "FO_CNAE2"
   case x = 9
      cARQTXT  := "aci_cep.data"
      cARQCEP5 := PEGCAMINI("MD11")+"MD11"
      cARQCBO  := "aci_cep"
   case x = 10
      cARQTXT := "aci_ddd.data"
      cARQCBO := PEGCAMINI("MDUFDDD")+"MDUFDDD"
   endcase
   IF FILE(cARQtxt) .AND. NETUSE(cARQCBO)
      IF X = 9
         NETUSE(cARQCEP5)
      ENDIF
      MDS(cARQTXT)


      nLASTREC := FLINECOUNT(cARQTXT)
      zei_fort(nLASTREC,,,0)

      cDELIM := FDELIM(cARQTXT,1024)  //acha o delimitador chr(13)+chr(10) dos ou chr(10) linux usado abaixo no freadline
      nFILE  := FOPEN(cARQTXT)  //abre o arquivo


      DO WHILE .T.

         cLINHA := FREADLINE(nFILE,1024,.T.,cDELIM)   //FREADLINE (handle, line_len,lremchrexp,cDELI)


         IF cLINHA = '__FINAL__'  //freadline retorna __FINAL__   quando nao e mais linhas
            EXIT
         ENDIF


         MDS(padr(cLINHA,40))
         cCODIGO := '0'
         nINSTR  := 0
         cNOME   := ''
         cDDD    := ""
         cUF     := ""
         cCEP    := ""
         if x < 7
            aVALOR  := HB_ATokens(cLINHA,";")
            cCODIGO := aVALOR[1]
            cNOME   := TIRACE(aVALOR[2])
         endif
         IF x = 7
            aVALOR  := HB_ATokens(cLINHA,",")
            cCODIGO := aVALOR[1]
            cNOME   := aVALOR[2]
            nINSTR  := val(aVALOR[3])
         ENDIF
         IF x = 8
            aVALOR  := HB_ATokens(cLINHA,",")
            cCODIGO := aVALOR[1]
            cNOME   := aVALOR[2]
         ENDIF
         IF x = 9
            cCODIGO := cLINHA   //cCODIGO:=LEFT(cCEP,5) //usado no seek
            cCEP    := cCODIGO
            cCEP5   := LEFT(cCEP,5)
         ENDIF
         IF x = 10
            aVALOR  := HB_ATokens(cLINHA,",")
            cCODIGO := aVALOR[1]  //68,AC o ddd e o primeiro campo a uf o segundo
            cNOME   := aVALOR[2]
            cDDD    := cCODIGO
            cUF     := cNOME
            cCODIGO := cUF+cDDD   //usado no seek
         ENDIF

         cNOME := TIRACE(cNOME)

         if val(cCODIGO) > 0 .or. x = 10  //alguns sao descritivos e nao codigos
            dbgotop()
            if !dbseek(cCODIGO)
               netrecapp()
               if x <> 9 .and. x <> 10
                  field->codigo := cCODIGO
               endif
               if x = 9
                  field->cep := cCEP
                  dbselectar("md11")
                  dbgotop()
                  if !dbseek(cCEP5)
                     netrecapp()
                     field->cep := cCEP
                  endif
                  dbselectar("aci_cep")
               endif
               if x = 10
                  field->DDD := cDDD
                  field->uf  := Cuf
               endif
            else
               dbrlock()
            endif
            IF cARQCBO <> "FO_CNAE2" .and. x <> 9 .and. x <> 10
               IF EMPTY(field->nome) .AND. !EMPTY(cNOME)
                  field->nome := cnome
               ENDIF
            ENDIF
            IF cARQCBO = "FO_CNAE2"
               IF EMPTY(field->descricao) .AND. !EMPTY(cNOME)
                  field->descricao := cnome
               ENDIF
            ENDIF
            IF cARQCBO <> "FO_CBOG" .AND. cARQCBO <> "FO_CBOD" .AND. cARQCBO <> "FO_CNAE2" .and. x <> 9 .and. x <> 10
               IF EMPTY(field->cagedesco) .AND. nINSTR > 0
                  field->cagedesco := nINSTR
               ENDIF
            ENDIF
            dbunlock()
         endif

         zei_fort(nLASTREC,,,1)
      ENDDO
      fclose(nFILE)   //fecha o arquivo
      dbcloseall()
      //  filedelete(Carqtxt)
      hb_FileDelete(Carqtxt)
   ENDIF
next x


ATUALIZA("NEWREL1","NOME+STR(SEQ)","DISKREL1",,.T.)
ATUALIZA("NEWRELA","CODIGO","DISKRELA",,.T.)
ATUALIZA("NEWRELM","NOME","DISKRELM",,.T.)
ATUALIZA("NEWRELS","NOME","DISKRELS",,.T.)
ATUALIZA("NEWMES","NOME","MESHOL",,.T.)
ATUALIZA("NEWTAB","TABELA+CODIGO","FO_TAB",,.T.)
// ATUALIZA("NEWCNAE","CODIGO"                ,"FO_CNAE",,.T.)
ATUALIZA("NEWCNAE2","CODIGO","FO_CNAE2",,.T.)
ATUALIZA("NEWCNAEV","CNAE2","CNAECNV",,.T.)
// ATUALIZA("NEWCBO" ,"CODIGO"                ,"FO_CBO",,.T.)
ATUALIZA("NEWCBON","CODIGO","FO_CBON",,.T.)
ATUALIZA("NEWCBOD","CODIGO","FO_CBOD",,.T.)
// ATUALIZA("NEWCBOV","CBOOLD"                ,"CBOCNV",,.T.)
ATUALIZA("NEWREL2","CODIGO","REL2","REL2",.T.)
ATUALIZA("NEWMAN","ARQUIVO","FOLHAMAN",,.T.)
ATUALIZA("NEWOPT","ITEMENU+STR(POSICAO,2)","FOLOPT",,.T.)
ATUALIZA("NEWTEL","CODIGO+STR(SEQ)","FOLTEL",,.T.)
ATUALIZA("NEWGET","CODIGO+STR(SEQ)","FOLGET",,.T.)
ATUALIZA("NEWNATJ","CODIGO","raisnatj",,.T.)
ATUALIZA("NEWUNID","CODIGO","unid",,.T.)
ATUALIZA("NEWDEPTO","CONTROLE","depto",,.T.)
ATUALIZA("NEWMD11","CEP","MD11",,.T.)
ATUALIZA("NEWUFDDD","UF+DDD","MDUFDDD",,.T.)
ATUALIZA("NEWPAISES","ISO3166A",PEGCAMINI("PAISES")+"PAISES",,.T.)
IF ATUALIZA("NEWHLP","DBF+CAMPO","FOLREL",,.T.)
   FERASE("NEWHLP.DBT")
   FERASE("NEWHLP.FPT")
ENDIF
// : FIM: FOYA.PRG

*+ EOF: foya.prg
*+
