// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foca1.prg
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
// :      FOCA1.PRG: Imprimir Relacao do Vale
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/94     11:37
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foca1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foca1

   PARA CC, CD, CB, MSAA, CW

   IF !MDL( MSAA, 0 )
      RETU
   ENDIF
   POS1 := SPAC( 40 )
   MDS( 'Digite Cabe‡ario Complementar' )
   @ 24, 35 GET POS1
   READCUR()

   IF !NETUSE( pes )
      dbCloseAll()
      RETU
   ENDIF
   FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES))'
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


   IF !netuse( fol )
      dbCloseAll()
      RETU
   ENDIF

   IF CW > 1
      IF !netuse( "DEPTO" )
         RETU
      ENDIF
      DO CASE
      CASE CW = 2
         FILTRA := 'SETOR=0.AND.SECAO=0'
         COMPAR := 'DEP=DEPTO'
      CASE CW = 3
         FILTRA := 'SETOR#0.AND.SECAO=0'
         COMPAR := 'DEP=DEPTO.AND.SET=SETOR'
      CASE CW = 4
         FILTRA := 'SETOR#0.AND.SECAO#0'
         COMPAR := 'DEP=DEPTO.AND.SET=SETOR.AND.SEC=SECAO'
      ENDCASE
      SET FILTER TO &FILTRA
   ENDIF


   IMPRESSORA()
   IF CW = 1
      NOMSETOR := ""
      FOCAX( ".T." )
   ELSE
      dbSelectAr( "DEPTO" )
      dbGoTop()
      WHILE !Eof()
         NOMSETOR := NOMEC
         DEP      := DEPTO
         SET      := SETOR
         SEC      := SECAO
         FOCAX( COMPAR )
         dbSelectAr( "DEPTO" )
         dbSkip()
      ENDDO
   ENDIF
   dbCloseAll()
   IMPFOL()
   VIDEO()
   IMPEND()
   RETU

// !*****************************************************************************
// !
// !         Fun‡„o: FOCAX()
// !
// !    Chamado por: FOCA1.PRG
// !
// !          Chama: VALCTA()           (fun‡„o    em FOLPROC.PRG)
// !               : SALHM()            (fun‡„o    em FOLPROC.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOCAX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOCAX

   PARA COMPARE

   TOTALIZA := .F.
   CTLIN    := 80
   TOTCRE   := TOTDEB := TOTBAS := TOTLIQ := TOTSAL := FL := 0
   dbSelectAr( PES )
   dbGoTop()
   WHILE !Eof()
      IF &COMPARE
         TOTALIZA := .T.
         CTR      := NUMERO
         IF CTLIN > 55
            IF CTLIN # 80
               @ PRow() + 1, 0 SAY REPL( '-', 132 )
            ENDIF
            FL++
            @  1, 0   SAY IF( IM1 = 'A', IMPSTR( cIMPCOM ), IMPSTR( cIMPEXP ) )
            @  2, 20  SAY IMPCHR( cIMPTIT ) + MSG2
            @  3, 05  SAY IMPCHR( cIMPTIT ) + 'RELATORIO DE ' + MSAA + ' ' + MMES + '/' + StrZero( ANO, 4 ) + ' ' + NOMSETOR
            @  5, 0   SAY POS1
            @  5, 100 SAY Time()
            @  5, 110 SAY Date()
            @  5, 120 SAY 'FL. ' + StrZero( FL, 4 )
            @  6, 0   SAY REPL( '-', 132 )
            @  7, 0   SAY "DEP  SET SEC Num.  Nome" + SPAC( 28 ) + "Salario" + SPAC( 7 ) + "T Base IRRF"
            @  7, 84  SAY "Valor Vale" + SPAC( 7 ) + "IRRF+PENSAO" + SPAC( 7 ) + "Liquido"
            @  8, 0   SAY REPL( '-', 132 )
            CTLIN := 9
         ENDIF
         dbSelectAr( FOL )
         CRE := VALCTA( CTR, CC )
         DEB := VALCTA( CTR, CD )
         BAS := VALCTA( CTR, CB )
         IF CC = 41
            CRE += VALCTA( CTR, 997 )
            DEB += VALCTA( CTR, 442 )
         ENDIF
         LIQ := CRE - DEB
         dbSelectAr( PES )
         IF LIQ # 0
            VAR1 := SALH := SALM := 0
            SALHM()
            @ CTLIN, 0   SAY DEPTO
            @ CTLIN, 5   SAY SETOR
            @ CTLIN, 9   SAY SECAO
            @ CTLIN, 13  SAY NUMERO
            @ CTLIN, 19  SAY NOME
            @ CTLIN, 51  SAY SALM   PICT "######,###.##"
            @ CTLIN, 65  SAY TIPO
            @ CTLIN, 67  SAY BAS    PICT "######,###.##"
            @ CTLIN, 84  SAY CRE    PICT "######,###.##"
            @ CTLIN, 101 SAY DEB    PICT "######,###.##"
            @ CTLIN, 119 SAY LIQ    PICT "######,###.##"
            TOTBAS += BAS
            TOTCRE += CRE
            TOTDEB += DEB
            TOTSAL += SALM
            TOTLIQ += LIQ
            CTLIN++
         ENDIF
      ENDIF
      dbSelectAr( PES )
      dbSkip()
   ENDDO
   IF TOTALIZA
      @ PRow() + 1, 0  SAY REPL( '-', 132 )
      @ PRow() + 1, 48 SAY TOTSAL        PICT "#,###,###,###.##"
      @ PRow(), 64    SAY TOTBAS        PICT "#,###,###,###.##"
      @ PRow(), 81    SAY TOTCRE        PICT "#,###,###,###.##"
      @ PRow(), 98    SAY TOTDEB        PICT "#,###,###,###.##"
      @ PRow(), 116   SAY TOTLIQ        PICT "#,###,###,###.##"
      @ PRow() + 1, 0  SAY REPL( '-', 132 )
   ENDIF
   RETU ( .T. )
// : FIM: FOCA1.PRG

// + EOF: foca1.prg
// +
