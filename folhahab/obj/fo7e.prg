// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fo7e.prg
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
// +    Documentado em 27-Dez-2024 as  9:45 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :       FO7E.PRG: Cadastro Simples de Funcion rios
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/07/94     15:19
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fo7e()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fo7e

   PARA CC

   IF !MDL( 'Cadastro Simples Funcionarios', 0 )
      RETU
   ENDIF

   POS1 := SPAC( 40 )
   MDS( 'Digite Cabe‡ario Complementar' )
   @ 24, 35 GET POS1
   IF !READCUR()
      RETU .F.
   ENDIF

   IF !NETUSE( pes )
      dbCloseAll()
      RETU
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

   IF !NETUSE( "FUNCAO" )
      dbCloseAll()
      RETU .F.
   ENDIF

   IF !NETUSE( "DEPTO" )
      dbCloseAll()
      RETU .F.
   ENDIF

   DO CASE
   CASE CC = 1
      FILTRA := 'SETOR=0.AND.SECAO=0'
      COMPAR := 'DEP=DEPTO'
   CASE CC = 2
      FILTRA := 'SETOR#0.AND.SECAO=0'
      COMPAR := 'DEP=DEPTO.AND.SET=SETOR'
   CASE CC = 3
      FILTRA := 'SETOR#0.AND.SECAO#0'
      COMPAR := 'DEP=DEPTO.AND.SET=SETOR.AND.SEC=SECAO'
   ENDCASE
   SET FILTER TO &FILTRA



   CTLIN := 80
   dbSelectAr( "DEPTO" )
   dbGoTop()
   WHILE !Eof()
      VIDEO()
      DEP := DEPTO
      SET := SETOR
      SEC := SECAO
      NOM := NOME
      @ 12, 0  SAY DEPTO
      @ 12, 10 SAY SETOR
      @ 12, 20 SAY SECAO
      @ 12, 30 SAY NOME
      PULAR := QTFUN := FL := SALTOT := 0
      IMPRESSORA()
      dbSelectAr( PES )
      dbGoTop()
      WHILE !Eof()
         VIDEO()
         PETELA( 8 )
         IMPRESSORA()
         IF &COMPAR
            IF CTLIN > 50
               @  1, 0   SAY IF( IM1 = 'A', IMPstr( Cimpcom ), impstr( Cimpexp ) )
               @  2, 10  SAY IMPCHR( cIMPTIT ) + MSG2
               @  3, 10  SAY IMPCHR( cIMPTIT ) + 'CADASTRO SIMPLES DE FUNCIONARIOS'
               @  4, 0   SAY POS1
               @  4, 100 SAY Time()
               @  4, 110 SAY Date()
               @  4, 120 SAY 'FL. ' + StrZero( FL, 4 )
               @  5, 0   SAY REPL( '-', 132 )
               CTLIN := 6
               PULAR := 0
            ENDIF
            IF PULAR = 0
               CTLIN++
               @ CTLIN, 0 SAY REPL( '=', 132 )
               CTLIN++
               @ CTLIN, 2 SAY NOM
               CTLIN++
               @ CTLIN, 0 SAY REPL( '-', 132 )
               CTLIN++
               @ CTLIN, 1   SAY 'DEPTO'
               @ CTLIN, 7   SAY 'SETOR'
               @ CTLIN, 13  SAY 'SECAO'
               @ CTLIN, 19  SAY 'CHAPA'
               @ CTLIN, 25  SAY 'REGISTRO'
               @ CTLIN, 34  SAY 'NOME'
               @ CTLIN, 64  SAY 'ADMITIDO'
               @ CTLIN, 73  SAY 'TIPO'
               @ CTLIN, 80  SAY 'FUNCAO'
               @ CTLIN, 107 SAY 'SALARIO'
               @ CTLIN, 127 SAY 'AO MES '
               CTLIN++
               CCOL  := 14
               PULAR := 1
               @ CTLIN, 0 SAY REPL( '-', 132 )
               CTLIN++
            ENDIF
            @ CTLIN, 2  SAY DEPTO
            @ CTLIN, 8  SAY SETOR
            @ CTLIN, 14 SAY SECAO
            @ CTLIN, 20 SAY CHAPA
            @ CTLIN, 26 SAY NUMERO
            @ CTLIN, 33 SAY NOME
            @ CTLIN, 64 SAY ADMITIDO
            @ CTLIN, 74 SAY TIPO
            @ CTLIN, 76 SAY FUNCAO
            @ CTLIN, 80 SAY '-' + OBTER( "FUNCAO",, FUNCAO, "FNOME" )
            dbSelectAr( PES )
            SALH := SALM := VAR1 := 0
            SALHM()
            @ CTLIN, 101 SAY VAR1 PICT '###,###,###.##'
            @ CTLIN, 119 SAY SALM PICTURE '###,###,###.##'
            SALTOT := SALTOT + SALM
            QTFUN++
            CTLIN++
         ENDIF
         dbSkip()
      ENDDO
      IF QTFUN # 0
         CTLIN++
         @ CTLIN, 20 SAY 'Quantidade de Funcionarios --> '
         @ CTLIN, 53 SAY QTFUN                             PICTURE '###'
         @ CTLIN, 99 SAY SALTOT                            PICT '#,###,###,###.##'
      ENDIF
      dbSelectAr( "DEPTO" )
      dbSkip()
   ENDDO
   IF CTLIN # 80
      IMPFOL()
   ENDIF
   dbCloseAll()
   VIDEO()
   IMPEND()
   dbCloseAll()
   RETU

// : FIM: FO7E.PRG

// + EOF: fo7e.prg
// +
