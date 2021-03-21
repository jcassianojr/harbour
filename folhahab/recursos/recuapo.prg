*:*****************************************************************************
*:
*:    RECUAPO.PRG: Arquivos utilitarios,Telemeno,Agenda,Bloco de Anotacoes
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/28/94     11:12
*:
*:     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
*:****************************************************************************


WHILE .T.
   cabe3("  Arquivos, Utilitarios, Telememo, Agenda, Bloco de Anotacoes     ",20)
   OPCAO( 09,23 , " &A Gerenciador de arquivos         " ,65, "  Gerenciador de arquivos  ")
   OPCAO( 10,23 , " &B Utilitarios diversos            " ,66, "  Calculo de datas, outros  ")
   OPCAO( 11,23 , " &C Telememo (Agenda de Telefones)  " ,67, "  Cadastro de telefones  ")
   OPCAO( 12,23 , " &D Agenda                          " ,68, "  Cadastro da agenda  ")
   OPCAO( 13,23 , " &E Bloco de Anotacoes.             " ,69, "  Cadastro de Anotacoes  ")
   OPCAO( 14,23 , " &F Informacoes Sobre o sistema     " ,70, "  Informa dados basicos do sistema  ")
   OPCAO( 15,23 , " &G Tabela de Caracteres ASCII      " ,71, "  Exibe Tabela com os Caracteres ASCII  ")
   OPCAO( 16,23 , " &H Executar um comando do DOS      " ,72, "  Executar um comando do DOS  ")
   OPCAO( 17,23 , " &I Sair para o DOS                 " ,73, "  Sair temporariamente para o DOS  ")
   OPCAO( 18,23 , " &J Editar Config.SYS               " ,74, "  Editar Config.sys  ")
   OPCAO( 19,23 , " &K Editar Autoexec.bat             " ,75, "  Editar Autoexec.bat ")
   OP:=MENU(,6)
   DO CASE
       CASE OP=1 ; recuapo1()
       CASE OP=2 ; recuapo2()
       CASE OP=3 
		   PADRAO("TELEMEMO","TELEMEMO","mNOME+' '+mTELEF","mNOME","Cadastro de Telefones","Nome Telefone",;
					{|| PEGCHAVE("mNOME",SPACE(10),"Codigo:")},"MDE001","MDE001",{|| FO_RELL("TELEMEMO") },,4)
	   CASE OP=4
             PADRAO("AGENDA","AGENDA","DTOC(mCDDATA)+' '+mOBS1","mCDDATA","Cadastro de Compromissos","Compromisso",;
               {|| PEGCHAVE("mCDDATA",date(),"Data:")},"MDF001","MDF001",{|| FO_RELL("AGENDA") },,4)
       CASE OP=5
           PADRAO("NOTA","NOTA","mNOME+' '+mOBS1","mNOME","Cadastro de Anotacoes","Anotacao",;
                {|| PEGCHAVE("mNOME",SPACE(10),"Codigo")},"MDG001","MDG001",{|| FO_RELL("ANOTACOES") },,4)
       CASE OP=6 ; M_DN()
       CASE OP=7 ; M_DL()
	   
       CASE OP=8
           SETCURSOR(1)
           COMANDO := SPAC(80)
			MDS('Qual o comando desejado:')
			@ 24,40 GET COMANDO PICT "@S35"        
			READCUR()
			IF ! EMPTY(COMANDO)
				aSALVO:=SALVAA()
				SETCOLOR(COR("MDI002"))
				hb_run(COMANDO)
				MDS("Tecle algo para Continuar")
				INKEY(0)
				RESTAA(aSALVO)
			ENDIF
	   	
       CASE OP=9
	   
          IF  HB_FILEEXISTS(GetEnv("COMSPEC"))
				aSALVO:=SALVAA()
				CLS
				MDT('Nao existe o "+GetEnv("COMSPEC"+", ou saida negada.')
				MDT('Digite exit para retornar ao programa')
				hb_run( GetEnv( "COMSPEC" ))
				RESTAA(ASALVO)
			ENDIF
	  		
       CASE OP = 10   ; EDITARQ("\CONFIG.SYS")
       CASE OP = 11   ; EDITARQ("\AUTOEXEC.BAT")
	   OTHERWISE 
	       RETURN
   ENDCASE
ENDDO
*: FIM: RECUAPO.PRG
