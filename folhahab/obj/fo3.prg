*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\FOLHA\OBJ\FO3.PRG
*+
*+    Functions: Function FO3H()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

////#INCLUDE "COMANDO.CH"

priv HELPDBF
HELPDBF := "FO3"
while .T.
   CABEX( "Menu Cadastro de Funcoes" )
   @ 05, 04 prom "1 - Funcoes                     "
   @ 06, 04 prom "2 - Faixas                      "
   @ 07, 04 prom "3 - CBOs                        "
   @ 08, 04 prom "4 - CBOs Novos                  "
   @ 09, 04 prom "5 - CBOs Descritivos            "  
   @ 10, 04 prom "6 - Areas                       "
   @ 11, 04 prom "7 - Cursos                      "
   @ 12, 04 prom "8 - Escolas                     "
   @ 13, 04 prom "9 - Treinamentos                "
   @ 14, 04 prom "0 - Listas                      "
   @ 15, 04 prom "A - Relatorio Requisitos Funcao "
   menu to OPCAO
   do case
   case OPCAO = 1
      FO3A( 0 )
   case OPCAO = 2
      FO3B( 0 )
   case OPCAO = 3
      FO3C( "FO_CBO" )
   case OPCAO = 4
      FO3C( "FO_CBON" )
   case OPCAO = 5
      FO3C( "FO_CBOD" )
   case OPCAO = 6
       caRQmp05:=PEGCAMINI("MP05")+"MP05"
       PADRAO(cARQMP05,cARQMP05,"' '+mCODIGO+' '+mDESCRI","mCODIGO","Cadastro de Areas da Empresa","Area",;
              {|| PEGCHAVE("mCODIGO",SPACE(2),"Area:")},"MAP501","MAP501",{|| FO_FOR("GRUPO='MP05'")})
   case OPCAO = 7
      FO3E( 0 )
   case OPCAO = 8
      FO3F( 0 )
   case OPCAO = 9
      FO3G( 0 )
   case OPCAO = 10
      FO_FOR( "GRUPO='FUNCAO'" )
   case OPCAO = 11
      FO3H( 0 )
   otherwise
      retu
   endcase
enddo

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function FO3H()     //Relatorio Requisitos de funcoes
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
function FO3H
caRQmp05:=PEGCAMINI("MP05")+"MP05"
MES01 := MES02 := MES03 := MES04 := MES05 := space( 70 )
CABEX( "Relatorio Requisitos Funcoes" )
@ 10, 01 say "Mensagens"
@ 11, 01 get MES01
@ 12, 01 get MES02
@ 13, 01 get MES03
@ 14, 01 get MES04
@ 15, 01 get MES05
if !READCUR()
   retu .F.
endif
if !CHECKIMP( 0 )
   retu .F.
endif
AN := cIMPNEG 
DN := cIMPNER

if ! NETUSE("FUNCAO")  
   retu .F.
endif
FILTRO=''
INX    := ""
FILORD(.T.)
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
if valtype(INX)="N"
   dbsetorder(INX)
ELSE
   ordDestroy("temp")
   ordcreate(,"temp",inx)
   ordSetFocus("temp")
ENDIF   
set filter to &FILTRO

dbgotop()
IMPRESSORA()
while !eof()
   @ prow() + 1, 0  say AN + ACENTO( "FUNCAO: " ) + str( CODIGO ) + " - " + NOME + DN
   @ prow() + 1, 0  say AN + ACENTO( "ЏREA: " + AREA + " - " + OBTER( cARQMP05, cARMP05, AREA, "DESCRI" ) ) + DN
   @ prow() + 2, 0  say AN + ACENTO( "DESCRICAO DETALHADA" ) + DN
   @ prow() + 1, 0  say MES01
   @ prow() + 1, 0  say MES02
   @ prow() + 1, 0  say MES03
   @ prow() + 1, 0  say MES04
   @ prow() + 1, 0  say MES05
   @ prow() + 1, 0  say DES01
   @ prow() + 1, 0  say DES02
   @ prow() + 1, 0  say DES03
   @ prow() + 1, 0  say DES04
   @ prow() + 1, 0  say DES05
   @ prow() + 1, 0  say DES06
   @ prow() + 1, 0  say DES07
   @ prow() + 1, 0  say DES08
   @ prow() + 1, 0  say DES09
   @ prow() + 1, 0  say DES10
   @ prow() + 2, 0  say AN + ACENTO( "REQUISITOS BЏASICOS NECESSЏARIOS" ) + DN
   @ prow() + 1, 0  say REQ01
   @ prow() + 1, 0  say REQ02
   @ prow() + 1, 0  say REQ03
   @ prow() + 1, 0  say REQ04
   @ prow() + 1, 0  say REQ05
   @ prow() + 1, 0  say REQ06
   @ prow() + 1, 0  say REQ07
   @ prow() + 1, 0  say REQ08
   @ prow() + 1, 0  say REQ09
   @ prow() + 1, 0  say REQ10
   @ prow() + 2, 0  say AN + ACENTO( "REQUISITOS DESEJЏAVEIS" ) + DN
   @ prow() + 1, 0  say RED01
   @ prow() + 1, 0  say RED02
   @ prow() + 1, 0  say RED03
   @ prow() + 1, 0  say RED04
   @ prow() + 1, 0  say RED05
   @ prow() + 1, 0  say RED06
   @ prow() + 1, 0  say RED07
   @ prow() + 1, 0  say RED08
   @ prow() + 1, 0  say RED09
   @ prow() + 1, 0  say RED10
   @ prow() + 1, 0  say repl( "-", 80 )
   @ prow() + 1, 0  say ACENTO( "Elaboracao" )
   @ prow() + 0, 26 say ACENTO( "Aprovacao" )
   @ prow() + 0, 52 say ACENTO( "Homologacao" )
   @ prow() + 1, 0  say "REH/"
   @ prow() + 0, 52 say "DIR/"
   @ prow() + 1, 0  say "Data:"
   @ prow() + 0, 26 say "Data"
   @ prow() + 0, 52 say "Data:"
   IMPFOL()
   dbskip()
enddo
VIDEO()
dbcloseall()
IMPEND()
return .T.

*+ EOF: FO3.PRG
