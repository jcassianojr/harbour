*:*****************************************************************************
*:
*:       FOYA.PRG: Atualizando Arquivos de Trabalho
*:
*:*****************************************************************************


MDS('Aguarde Atualizando tabelas')
for x=1 to 8
   do case
      case x=1
         cARQTXT:="CBO2002Grandegrupo.csv"   
         cARQCBO:="FO_CBOG"
      case x=2
         cARQTXT:="CBO2002SubGrupoPrincipal.csv"   
         cARQCBO:="FO_CBOG"
      case x=3
         cARQTXT:="CBO2002SubGrupo.csv"   
         cARQCBO:="FO_CBOG"
      case x=4
         cARQTXT:="CBO2002Familia.csv"   
         cARQCBO:="FO_CBOG"   
      case x=5
         cARQTXT:="CBO2002ocupacao.csv"   
         cARQCBO:="FO_CBON"
      case x=6
         cARQTXT:="CBO2002sinonimo.csv"   
         cARQCBO:="FO_CBOD"
      case x=7
         cARQTXT:="aci_cbo.data"      
         cARQCBO:="FO_CBON"
      case x=8
         cARQTXT:="aci_atividade_economica.data"      
         cARQCBO:="FO_CNAE2"		 
   endcase  
   IF FILE(cARQtxt).AND.NETUSE(cARQCBO)      
      MDS(cARQTXT)
      nFile := HB_FUse(cARQTXT)
      nLASTREC:=hb_flastrec()
      zei_fort( nLASTREC,,,0)
      hb_fgotop()
      DO WHILE .NOT. HB_FEof()
         cLINHA:=HB_FREADLN()  
         MDS(padr(cLINHA,40))
         cCODIGO:='0'
         nINSTR :=0
		 cNOME:=''
		 if x<7
            aVALOR  :=HB_ATokens(cLINHA,";")
            cCODIGO:=aVALOR[1]
            cNOME  :=aVALOR[2]			
		 endif
         IF x=7
            aVALOR  :=HB_ATokens(cLINHA,",")
            cCODIGO:=aVALOR[1]
            cNOME  :=aVALOR[2]
            nINSTR :=val(aVALOR[3])
         ENDIF
         IF x=8
            aVALOR  :=HB_ATokens(cLINHA,",")
            cCODIGO:=aVALOR[1]
            cNOME  :=aVALOR[2]
         ENDIF
         if val(cCODIGO)>0 //alguns sao descritivos e nao codigos
            dbgotop()
            if ! dbseek(cCODIGO)
               netrecapp()
               field->codigo:=cCODIGO
            else   
               dbrlock()
            endif
			IF cARQCBO<>"FO_CNAE2"
				IF EMPTY(field->nome) .AND. ! EMPTY(cNOME)
					field->nome  :=cnome            
				ENDIF
			ENDIF	
			IF cARQCBO="FO_CNAE2"
				IF EMPTY(field->descricao) .AND. ! EMPTY(cNOME)
					field->descricao  :=cnome            
				ENDIF
			ENDIF	
            IF cARQCBO<>"FO_CBOG" .AND.  cARQCBO<>"FO_CBOD" .AND. cARQCBO<>"FO_CNAE2"
               IF EMPTY(field->cagedesco) .AND. nINSTR>0
                  field->cagedesco:=nINSTR
               ENDIF
            ENDIF   
            dbunlock()
         endif   
         zei_fort(nLASTREC,,,1)
         HB_FSkip(1)
      ENDDO
      HB_FUse()
      dbcloseall()
      filedelete(Carqtxt)
   ENDIF
next x


ATUALIZA("NEWREL1","NOME+STR(SEQ)"         ,"DISKREL1",,.T.)
ATUALIZA("NEWRELA","CODIGO"                ,"DISKRELA",,.T.)
ATUALIZA("NEWRELM","NOME"                  ,"DISKRELM",,.T.)
ATUALIZA("NEWRELS","NOME"                  ,"DISKRELS",,.T.)
ATUALIZA("NEWMES" ,"NOME"                  ,"MESHOL",,.T.)
ATUALIZA("NEWTAB" ,"TABELA+CODIGO"         ,"FO_TAB",,.T.)
// ATUALIZA("NEWCNAE","CODIGO"                ,"FO_CNAE",,.T.)
ATUALIZA("NEWCNAE2","CODIGO"               ,"FO_CNAE2",,.T.)
ATUALIZA("NEWCNAEV","CNAE2"               ,"CNAECNV",,.T.)
// ATUALIZA("NEWCBO" ,"CODIGO"                ,"FO_CBO",,.T.)
ATUALIZA("NEWCBON","CODIGO"                ,"FO_CBON",,.T.)
ATUALIZA("NEWCBOD","CODIGO"                ,"FO_CBOD",,.T.)
// ATUALIZA("NEWCBOV","CBOOLD"                ,"CBOCNV",,.T.)
ATUALIZA("NEWREL2","CODIGO"                ,"REL2","REL2",.T.)
ATUALIZA("NEWMAN" ,"ARQUIVO"               ,"FOLHAMAN",,.T.)
ATUALIZA("NEWOPT" ,"ITEMENU+STR(POSICAO,2)","FOLOPT",,.T.)
ATUALIZA("NEWTEL" ,"CODIGO+STR(SEQ)"       ,"FOLTEL",,.T.)
ATUALIZA("NEWGET" ,"CODIGO+STR(SEQ)"       ,"FOLGET",,.T.)
ATUALIZA("NEWNATJ" ,"CODIGO"               ,"raisnatj",,.T.)
ATUALIZA("NEWUNID" ,"CODIGO"               ,"unid",,.T.)
ATUALIZA("NEWDEPTO" ,"CONTROLE"            ,"depto",,.T.)
ATUALIZA("NEWMD11" ,"CEP"                  ,"MD11",,.T.)
ATUALIZA("NEWUFDDD" ,"UF+DDD"              ,"MDUFDDD",,.T.)
ATUALIZA("NEWPAISES" ,"ISO3166A"           ,PEGCAMINI("PAISES")+"PAISES",,.T.)
IF ATUALIZA("NEWHLP" ,"DBF+CAMPO"          ,"FOLREL",,.T.)
   FERASE("NEWHLP.DBT")
   FERASE("NEWHLP.FPT")
ENDIF
*: FIM: FOYA.PRG
