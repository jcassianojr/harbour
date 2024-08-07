*:*****************************************************************************
*:
*:    RECUSER.PRG: Diversos - Apuracaes - Configuracaes
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 05/12/94     12:13
*:
*:  Procs & Fncts: RECUSER()
*:
*:          Chama: CABE3()            (fun‡„o    em RECUPROC.PRG)
*:               : CABE2()            (fun‡„o    em RECUPROC.PRG)
*:               : RECUARQ1()         (fun‡„o    em RECUARQ1.PRG)
*:               : RECUDIR()          (fun‡„o    em RECUDIR.PRG)
*:               : RECUSER5()         (fun‡„o    em RECUSER5.PRG)
*:               : RECUSER6()         (fun‡„o    em RECUSER6.PRG)
*:
*:     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
*:*****************************************************************************


WHILE .T.
   CABE3("  Diversos - Apuracao  - Configuracao "+SPAC(20),19)
   MDS(HB_CWD())
   OPCAO( 09,23 , " &A Indexar os arquivos             " ,65, "  Organiza os arquivos de trabalho   ")
   OPCAO( 10,23 , " &B Alterar Configuracao Indexacao  " ,66, "  Altera configuracao de organizacao ")
   /*
   OPCAO( 11,23 , " &C Alterar Estrutura de Arquivos   " ,67, "  Altera estrutura de um arquivo  ")
   OPCAO( 12,23 , " &D Mudar diretorio de Trabalho     " ,68, "  Muda o Diretorio de trabalho  ")
   OPCAO( 13,23 , " &E Faz uma Copia de Reserva        " ,69, "  Copia um Grupo de Arquivos para disquetes  ")
   OPCAO( 14,23 , " &F Faz Copia Reserva Sequencial    " ,70, "  Copia um Grupo de Arquivos para disquetes  ")
   OPCAO( 15,23 , " &G Formatar um disquete            " ,71, "  Esta opcao formata um disqueta  ")
   OPCAO( 16,23 , " &H Mudar Data Operacional          " ,72, "  Esta opcao altera a Data de Trabalho ")
   OPCAO( 17,23 , " &I Escolher Impressora             " ,73, "  Ver Lista de Impressoras ")
   */
   OP:=MENU(,6)
   DO CASE
   CASE OP=1 ; FOY2(0,"RECURNTX")
   CASE OP=2 ; FOY2(1,"RECURNTX")
   /*
   CASE OP=3
        CABE2('Alterando estrutura de Arquivo')
        @ 08,00 CLEA
        FILTRO='*.DBF       '
      M DS('Grupo de Arquivos')
        @ 24,40 GET FILTRO
       READCUR()
       RECUARQ1(2)
   CASE OP=4 ; RECUDIR()
   CASE OP=5 ; RECUSER5(1)
   CASE OP=6 ; RECUSER6()
   CASE OP=7
        cTELA:=SAVESCREEN(00,00,24,79)
        M_DA()
        RESTSCREEN(00,00,24,79,cTELA)
   CASE OP=8
      MDS('Digite a nova data')
      @ 24,40 GET ZDATA
      READCUR()
   case OP=9
      imphp()
      */
   OTHERWISE ; RETUrn nil
   ENDCASE
ENDDO
return nil

*: FIM: RECUSER.PRG
