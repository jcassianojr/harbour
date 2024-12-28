// :*****************************************************************************
// :
// :   RECUMENU.PRG: Menu Principal Recurso
// :      Linguagem: Clipper 5.x
// :        Sistema: RECURSOS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/28/94     11:31
// :
// :  Procs & Fncts: RECUMENU()
// :
// :          Chama: RECUGER()          (fun‡„o    em RECUGER.PRG)
// :               : RECUAPO()          (fun‡„o    em RECUAPO.PRG)
// :               : RECUSER()          (fun‡„o    em RECUSER.PRG)
// :
// :     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
// :*****************************************************************************

#INCLUDE "BOX.CH"

/*
g_oMenuBar := WvgSetAppWindow():menuBar()

oMenu12 := WvgMenu():new( g_oMenuBar, , .t. ):create()
oMenu12:caption := "Recursos"

oMenu12:AddItem( "1 - alert1 "  , {|| alert("1") } )          //execModulos("0.1")
oMenu12:AddItem( "2 - alert2 "  , {|| alert("2") } )         

g_oMenuBar:addItem( { oMenu12, "Recursos" } )


//return (oMenu12)
*/



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function RECUMENU()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION RECUMENU()

PUBLIC DADO
memvar->DXDIA := DATE()
Set(_SET_MESSAGE,6,.T.)
WHILE .T.
   SETCOLOR("+W/BR, N/W")
   @ 00,00 CLEA
   HB_dispbox(0,0,07,79,B_DOUBLE+" ")
   SETCOLOR("W/R")
   HB_dispbox(8,21,10,58,B_DOUBLE+" ")
   SETCOLOR("W/N")
   @ 13,01 CLEA TO 19,77
   @ 09,27 SAY "M E N U   P R I N C I P A L"         
   HB_dispbox(12,1,20,78,B_DOUBLE+" ")
   @ 13,05 SAY STRTRAN("######   #######    #####  ##  ##   ######    ####     #####    ####","#",CHR(254))          
   @ 14,05 SAY STRTRAN(" ##  ##   ##   #   ##  ##  ##  ##    ##  ##  ##  ##   ##   ##  ##  ##","#",CHR(254))         
   @ 15,05 SAY STRTRAN(" ##  ##   ##      ##       ##  ##    ##  ##  ##       ##   ##  ##","#",CHR(254))             
   @ 16,05 SAY STRTRAN(" #####    ####    ##       ##  ##    #####    ####    ##   ##   ####","#",CHR(254))          
   @ 17,05 SAY STRTRAN(" ####     ##      ##       ##  ##    ####        ##   ##   ##      ##","#",CHR(254))         
   @ 18,05 SAY STRTRAN(" ##  ##   ##   #   ##  ##  ##  ##    ##  ##  ##  ##   ##   ##  ##  ##","#",CHR(254))         
   @ 19,05 SAY STRTRAN("###  ##  #######    ####    ####    ###  ##   ####     #####    #### ","#",CHR(254))         
   SETCOLOR("+W/BR, N/W")
   OPCAO(02,04," Gerador de &Etiquetas  ",69,"  Etiquetas simples e configuradas.   ")
   OPCAO(03,04," Editor  de &Cartas     ",67,"  Cria, Altera, Imprime Cartas.       ")
   OPCAO(04,04," Calculos de &Datas     ",68,"  Cria, Altera, Imprime Cartas.       ")
   OPCAO(02,30," &Indexar os arquivos    ",73,"  Organiza os arquivos de trabalho   ")
   OPCAO(03,30," Con&Figuracao Indexacao ",70,"  Altera configuracao de organizacao ")
   //OPCAO( 04,04 , "   &Geradores  "    ,71,"  Etiquetas, Cartas, Dbf editor, Formul rios                      ")
   //OPCAO( 04,21 , "     &Apoio    "    ,65,"  Arquivos, Utilit rios, Telememo, Agenda, Bloco de Anota‡”es     ")
   //OPCAO( 04,37 , " &Servicos gerais  ",83, "              Diversos - Apuracoes - Configuracoes                ")
   //OPCAO( 04,58 , " &Encerrar "        ,69, "                Encerra as atividades no sistema                  ")
   memvar->OPCAO := MENU(,6)
   SETCOLOR("+W/BR")
   DO CASE
   CASE memvar->OPCAO = 1   //RECUGER()
      rECUGER1()
   CASE memvar->OPCAO = 2   //RECUAPO()
      rECUGER2()
   CASE memvar->OPCAO = 3   //RECUSER()
      recuapo2()
   CASE memvar->OPCAO = 4 
      FOY2(0,"RECURNTX")
   CASE memvar->OPCAO = 5 
      FOY2(1,"RECURNTX")
   OTHERWISE
      IF MDG('Deseja Realmente Sair do Programa')
         FIM('')
      ENDIF
   ENDCASE
ENDDO
RETURN .T.

// : FIM: RECUMENU.PRG


