// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : flib13.prg
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
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function LISTARUE()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC LISTARUE( bREL, bGER )

   PRIV NUMDEP := 0, aFUE := {}

   CLSROW( 8 )
   hb_DispBox( 08, 00, 18, 64, B_DOUBLE + " " )
   OPCAO( 10, 2, " &A - Global       (Lista Sequencialmente, sem quebras)    ", 65 )
   OPCAO( 12, 2, " &B - Departamento (Quebra a listagem a cada Departamento) ", 66 )
   OPCAO( 14, 2, " &C - Setor        (Quebra a listagem a cada Setor)        ", 67 )
   OPCAO( 16, 2, " &D - Secao        (Quebra a listagem a cada Secao)        ", 68 )
   OPCAO( 17, 2, " &E - Sequencia Indicada Funcionarios                      ", 69 )
   KEY := MENU(, 0 )

   IF KEY = 0
      RETU
   ENDIF

   IF KEY > 1 .AND. KEY < 5
      DO CASE
      CASE KEY = 2
         FILTRA := 'SETOR=0.AND.SECAO=0'
         COMPAR := 'DEP=DEPTO'
      CASE KEY = 3
         FILTRA := 'SETOR#0.AND.SECAO=0'
         COMPAR := 'DEP=DEPTO.AND.SET=SETOR'
      CASE KEY = 4
         FILTRA := 'SETOR#0.AND.SECAO#0'
         COMPAR := 'DEP=DEPTO.AND.SET=SETOR.AND.SEC=SECAO'
      ENDCASE
      MDNOM := {}
      MDDEP := {}
      MDSET := {}
      MDSEC := {}
      IF !netuse( "DEPTO" )
         dbCloseAll()
         RETURN .F.
      ENDIF
      SET FILTER TO &FILTRA
      dbGoTop()
      IF Eof()
         dbCloseAll()
         MDT( 'Verifique o Cadastro de Departamentos' )
         RETURN .F.
      ENDIF
      WHILE !Eof()
         AAdd( MDNOM, NOME )
         AAdd( MDDEP, DEPTO )
         AAdd( MDSET, SETOR )
         AAdd( MDSEC, SECAO )
         dbSkip()
      ENDDO
      dbCloseArea()
      NUMDEP := Len( MDNOM )
   ENDIF
   IF KEY = 5
      nNUMERO := 0
      @ 24, 00 SAY "Funcionario No."
      @ 24, 60 SAY "Esc ou 0 para encerrar"
      WHILE .T.
         @ 24, 20 GET nNUMERO
         IF !READCUR()
            EXIT
         ENDIF
         IF Empty( nNUMERO )
            EXIT
         ENDIF
         AAdd( aFUE, nNUMERO )
      ENDDO
   ENDIF



   FL := 0
   IMPRESSORA()
   DO CASE
   CASE KEY = 1
      NOMSETOR := ""
      Eval( bREL, ".T." )
   CASE KEY = 5
      NOMSETOR := ""
      Eval( bREL, "ASCAN(aFUE,NUMERO)>0" )
   OTHERWISE
      FOR X := 1 TO NUMDEP
         NOMSETOR := MDNOM[ X ]
         DEP      := MDDEP[ X ]
         SET      := MDSET[ X ]
         SEC      := MDSEC[ X ]
         Eval( bREL, COMPAR )
      NEXT X
   ENDCASE
   dbCloseAll()
   IF ValType( bGER ) = "B"
      Eval( bGER )
   ENDIF
   VIDEO()
   IMPEND()

   RETURN .T.

// + EOF: flib13.prg
// +
