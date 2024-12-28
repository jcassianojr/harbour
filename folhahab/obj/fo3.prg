// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo3.prg
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
// +    Documentado em 27-Dez-2024 as  9:44 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


// //#INCLUDE "COMANDO.CH"

PRIV HELPDBF
HELPDBF := "FO3"
WHILE .T.
CABEX( "Menu Cadastro de Funcoes" )
@ 05, 04 PROM "1 - Funcoes                     "
@ 06, 04 PROM "2 - Faixas                      "
@ 07, 04 PROM "3 - CBOs                        "
@ 08, 04 PROM "4 - CBOs Novos                  "
@ 09, 04 PROM "5 - CBOs Descritivos            "
@ 10, 04 PROM "6 - Areas                       "
@ 11, 04 PROM "7 - Cursos                      "
@ 12, 04 PROM "8 - Escolas                     "
@ 13, 04 PROM "9 - Treinamentos                "
@ 14, 04 PROM "0 - Listas                      "
@ 15, 04 PROM "A - Relatorio Requisitos Funcao "
MENU TO OPCAO
DO CASE
CASE OPCAO = 1
FO3A( 0 )
CASE OPCAO = 2
FO3B( 0 )
CASE OPCAO = 3
FO3C( "FO_CBO" )
CASE OPCAO = 4
FO3C( "FO_CBON" )
CASE OPCAO = 5
FO3C( "FO_CBOD" )
CASE OPCAO = 6
caRQmp05 := PEGCAMINI( "MP05" ) + "MP05"
PADRAO( cARQMP05, cARQMP05, "' '+mCODIGO+' '+mDESCRI", "mCODIGO", "Cadastro de Areas da Empresa", "Area", ;
            {|| PEGCHAVE( "mCODIGO", Space( 2 ), "Area:" ) }, "MAP501", "MAP501", {|| FO_FOR( "GRUPO='MP05'" ) } )
CASE OPCAO = 7
FO3E( 0 )
CASE OPCAO = 8
FO3F( 0 )
CASE OPCAO = 9
FO3G( 0 )
CASE OPCAO = 10
FO_FOR( "GRUPO='FUNCAO'" )
CASE OPCAO = 11
FO3H( 0 )
OTHERWISE
RETU
ENDCASE
ENDDO


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FO3H()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION FO3H

   caRQmp05 := PEGCAMINI( "MP05" ) + "MP05"
   MES01    := MES02 := MES03 := MES04 := MES05 := Space( 70 )
   CABEX( "Relatorio Requisitos Funcoes" )
   @ 10, 01 SAY "Mensagens"
   @ 11, 01 GET MES01
   @ 12, 01 GET MES02
   @ 13, 01 GET MES03
   @ 14, 01 GET MES04
   @ 15, 01 GET MES05
   IF !READCUR()
      RETU .F.
   ENDIF
   IF !CHECKIMP( 0 )
      RETU .F.
   ENDIF
   AN := cIMPNEG
   DN := cIMPNER

   IF !NETUSE( "FUNCAO" )
      RETU .F.
   ENDIF
   FILTRO := ''
   INX    := ""
   FILORD( .T. )
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   IF ValType( INX ) = "N"
      dbSetOrder( INX )
   ELSE
      ordDestroy( "temp" )
      ordCreate(, "temp", inx )
      ordSetFocus( "temp" )
   ENDIF
   SET FILTER TO &FILTRO

   dbGoTop()
   IMPRESSORA()
   WHILE !Eof()
      @ PRow() + 1, 0  SAY AN + ACENTO( "FUNCAO: " ) + Str( CODIGO ) + " - " + NOME + DN
      @ PRow() + 1, 0  SAY AN + ACENTO( "èREA: " + AREA + " - " + OBTER( cARQMP05, cARMP05, AREA, "DESCRI" ) ) + DN
      @ PRow() + 2, 0  SAY AN + ACENTO( "DESCRICAO DETALHADA" ) + DN
      @ PRow() + 1, 0  SAY MES01
      @ PRow() + 1, 0  SAY MES02
      @ PRow() + 1, 0  SAY MES03
      @ PRow() + 1, 0  SAY MES04
      @ PRow() + 1, 0  SAY MES05
      @ PRow() + 1, 0  SAY DES01
      @ PRow() + 1, 0  SAY DES02
      @ PRow() + 1, 0  SAY DES03
      @ PRow() + 1, 0  SAY DES04
      @ PRow() + 1, 0  SAY DES05
      @ PRow() + 1, 0  SAY DES06
      @ PRow() + 1, 0  SAY DES07
      @ PRow() + 1, 0  SAY DES08
      @ PRow() + 1, 0  SAY DES09
      @ PRow() + 1, 0  SAY DES10
      @ PRow() + 2, 0  SAY AN + ACENTO( "REQUISITOS BèASICOS NECESSèARIOS" ) + DN
      @ PRow() + 1, 0  SAY REQ01
      @ PRow() + 1, 0  SAY REQ02
      @ PRow() + 1, 0  SAY REQ03
      @ PRow() + 1, 0  SAY REQ04
      @ PRow() + 1, 0  SAY REQ05
      @ PRow() + 1, 0  SAY REQ06
      @ PRow() + 1, 0  SAY REQ07
      @ PRow() + 1, 0  SAY REQ08
      @ PRow() + 1, 0  SAY REQ09
      @ PRow() + 1, 0  SAY REQ10
      @ PRow() + 2, 0  SAY AN + ACENTO( "REQUISITOS DESEJèAVEIS" ) + DN
      @ PRow() + 1, 0  SAY RED01
      @ PRow() + 1, 0  SAY RED02
      @ PRow() + 1, 0  SAY RED03
      @ PRow() + 1, 0  SAY RED04
      @ PRow() + 1, 0  SAY RED05
      @ PRow() + 1, 0  SAY RED06
      @ PRow() + 1, 0  SAY RED07
      @ PRow() + 1, 0  SAY RED08
      @ PRow() + 1, 0  SAY RED09
      @ PRow() + 1, 0  SAY RED10
      @ PRow() + 1, 0  SAY repl( "-", 80 )
      @ PRow() + 1, 0  SAY ACENTO( "Elaboracao" )
      @ PRow() + 0, 26 SAY ACENTO( "Aprovacao" )
      @ PRow() + 0, 52 SAY ACENTO( "Homologacao" )
      @ PRow() + 1, 0  SAY "REH/"
      @ PRow() + 0, 52 SAY "DIR/"
      @ PRow() + 1, 0  SAY "Data:"
      @ PRow() + 0, 26 SAY "Data"
      @ PRow() + 0, 52 SAY "Data:"
      IMPFOL()
      dbSkip()
   ENDDO
   VIDEO()
   dbCloseAll()
   IMPEND()

   RETURN .T.


// + EOF: fo3.prg
// +
