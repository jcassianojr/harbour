// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foia.prg
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
// +    Documentado em 27-Dez-2024 as  9:46 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :       FOIA.PRG: Listar Resumo configurado
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/25/94     12:13
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foia()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foia

   PARA CC

   IF !MDL( 'Listar Resumo configurado', 0 )
      RETU
   ENDIF

   POS1 := SPAC( 40 )
   MDS( 'Digite Cabe‡ario Complemeuntar' )
   @ 24, 35 GET POS1
   IF !READCUR()
      RETU .F.
   ENDIF



   DO CASE
   CASE NRSEN = "DiReT"
      MASS := '  PAGAMENTO  DE  PRO-LABORE '
   CASE NRSEN = "AUTON"
      MASS := '  PAGAMENTO  DE  AUTONOMOS  '
   OTHERWISE
      MASS := 'FOLHA DE PAGAMENTO SIMPLES  '
   ENDCASE

   aTIT := Array( 10 )
   aVAL := Array( 10 )
   aTOT := Array( 10 )
   AFill( aTIT, "" )
   AFill( AVAL, 0 )
   AFill( aTOT, 0 )


   MDS( "Carregando Titulos" )
   IF !NETUSE( "TILRES",,,,, .F., )   // BREDE("TILRES",1)
      dbCloseAll()
      RETU
   ENDIF
   dbGoTop()
   FOR X := 1 TO 10
      aTIT[ X ] := TITULO
      dbSkip()
   NEXT X
   dbCloseArea()


   IF !ARQUSAR( CC, 1, 0 )
      dbCloseAll()
      RETU .F.
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "numero" )
   ordSetFocus( "temp" )

// TROCAR DBSEEK NUMERO*10000
// AREDE(ARQACU,INDACU,1)
// Montar Matriz das Contas RES>0.AND.RES<11
// Trocas seek mconta por Ascan

   cSELE1 := Alias()

   IF !ARQPES( CC, 1, 0 )
      dbCloseAll()
      RETU .F.
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

   cSELE2 := Alias()

   IF !ARQCTA( CC, 1, 1 )
      dbCloseAll()
      RETU
   ENDIF
   cSELE3 := Alias()



   CTLIN := 80
   FL    := 0

   IMPRESSORA()
   dbSelectAr( cSELE2 )
   dbGoTop()
   WHILE !Eof()
      mNUMERO := NUMERO
      AFill( aVAL, 0 )
      dbSelectAr( cSELE1 )
      dbGoTop()
      dbSeek( mNUMERO )
      WHILE mNUMERO = NUMERO .AND. !Eof()
         mCONTA := CONTA
         mVALOR := VALOR
         dbSelectAr( cSELE3 )
         dbGoTop()
         IF dbSeek( mCONTA )
            IF RES > 0 .AND. RES < 11
               aVAL[ RES ] += mVALOR
               aTOT[ RES ] += mVALOR
            ENDIF
         ENDIF
         dbSelectAr( cSELE1 )
         dbSkip()
      ENDDO
      IF CTLIN > 58
         FL++
         @  1, 0   SAY IMPSTR( cIMPEXP )
         @  1, 1   SAY IMPCHR( cIMPTIT )
         @  1, 18  SAY MSG2
         @  2, 120 SAY 'FL.'
         @  2, 124 SAY FL              PICT '##'
         @  3, 2   SAY POS1
         @  3, 110 SAY 'DATA =>'
         @  3, 118 SAY DXDIA
         @  4, 1   SAY REPL( '-', 132 )
         @  5, 1   SAY IMPCHR( cIMPTIT )
         XANO := Year( DXDIA )
         XANO := Str( XANO, 4 )
         @  5, 18 SAY MMES + '/' + XANO
         @  6, 1  SAY REPL( '-', 132 ) + IMPSTR( cIMPCOM )
         @  7, 1  SAY 'DEPTO'
         @  7, 7  SAY 'SETOR'
         @  7, 13 SAY 'SECAO'
         @  7, 19 SAY 'CHAPA'
         @  7, 25 SAY 'REGISTRO'
         @  7, 34 SAY 'NOME DO FUNCIONARIO'
         COL := 80
         FOR W := 1 TO 10
            @  7, COL SAY aTIT[ W ]
            COL += 15
         NEXT W
         @  8, 0 SAY IMPSTR( cIMPEXP ) + REPL( '-', 130 ) + IMPSTR( cIMPCOM )
         CTLIN := 9
      ENDIF
      nTOT := 0
      FOR W := 1 TO 10
         nTOT += aVAL[ W ]
      NEXT W
      IF nTOT > 0
         dbSelectAr( cSELE2 )
         @ CTLIN, 2  SAY DEPTO
         @ CTLIN, 8  SAY SETOR
         @ CTLIN, 14 SAY SECAO
         @ CTLIN, 20 SAY CHAPA
         @ CTLIN, 26 SAY NUMERO
         @ CTLIN, 33 SAY NOME
         SALH := SALM := VAR1 := 0
         SALHM()
         @ CTLIN, 66 SAY SALM PICT '@E 99,999,999.99'
         COL := 80
         FOR W := 1 TO 10
            @ CTLIN, COL SAY aVAL[ W ] PICT '@E 99,999,999.99'
            COL += 15
         NEXT W
         CTLIN++
      ENDIF
      dbSelectAr( cSELE2 )
      dbSkip()
   ENDDO


   @ CTLIN, 0 SAY IMPSTR( cIMPEXP ) + REPL( '-', 131 ) + IMPSTR( cIMPCOM )
   CTLIN++
   @ CTLIN, 1 SAY 'TOTAL GERAL DAS CONTAS ==> '
   COL := 80
   FOR X := 1 TO 10
      @ CTLIN, COL SAY aTOT[ X ] PICT '##,###,###.##'
      COL += 15
   NEXT
   CTLIN++
   @ CTLIN, 0 SAY IMPSTR( cIMPEXP ) + REPL( '-', 131 ) + IMPSTR( cIMPCOM )

   IMPFOL()
   VIDEO()
   IMPEND()
   RETU

// : FIM: FOIA.PRG

// + EOF: foia.prg
// +
