*:*****************************************************************************
*:
*:    RECUGER.PRG: Menu de Geradores
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/22/94     12:24
*:
*:  Procs & Fncts: RECUGER()
*:
*:          Chama: CABE3()            (fun‡„o    em RECUPROC.PRG)
*:               : RECUGER1()         (fun‡„o    em RECUGER1.PRG)
*:               : RECUGER2()         (fun‡„o    em RECUGER2.PRG)
*:               : RECUGER3()         (fun‡„o    em RECUGER3.PRG)
*:
*:     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
*:*****************************************************************************

IMPHP()


WHILE .T.
   CABE3("  Etiquetas, Cartas, Dbf editor, Formul rios                      ",15)
   OPCAO( 09,23 , " &A Gerador de Etiquetas           " ,65, "  Etiquetas simples e configuradas.   ")
   OPCAO( 10,23 , " &B Editor  de Cartas              " ,66, "  Cria, Altera, Imprime Cartas.       ")
   OPCAO( 11,23 , " &C DBF Editor                     " ,67, "  Gera relat¢rio sobre arquivo DBF.   ")
   OP:=MENU(,6)
   SETCOLOR("W/N")
   DO CASE
   CASE OP=1 ; RECUGER1()
   CASE OP=2 ; RECUGER2()
   CASE OP=3
      TAMANHO="132"
      GRUPO='*.DBF       '
      @ 21,0 CLEAR
      @ 21,0 TO 24,79 DOUB
      @ 22,3 SAY "Grupo de Arquivos.     :" GET GRUPO
      @ 23,3 SAY "Tamanho do Formul rio. :" GET TAMANHO
      READCUR()
      GRUPO=ALLTRIM(GRUPO)
      RECUGER3(TAMANHO,GRUPO)
   OTHERWISE ; RETU
   ENDCASE
ENDDO
*: FIM: RECUGER.PRG
