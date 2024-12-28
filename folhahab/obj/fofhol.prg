// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fofhol.prg
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
// :     FOFHOL.PRG: Imprimir Hollerith
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  SOFTEC  S/C Ltda.
// :  Atualizado em: 21/07/98
// :
// :*****************************************************************************

#include "BOX.CH"
// //#INCLUDE "COMANDO.CH"

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fofhol()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fofhol

   PARA HOLP1
   PUBLIC IMPRI, IMP

   IMPHP()

   INFOR( "MESHOL", "NOME", "MESHOL", .T. )



   IF !MDL( 'Imprimir Hollerith', 0 )
      RETU
   ENDIF

   @ 07, 00 CLEA
   hb_DispBox( 8, 0, 18, 64, B_DOUBLE + " " )
   @ 10, 2 PROM "  X - Global" + SPAC( 8 ) + "(Lista Sequencialmente, sem quebras)    "
   @ 12, 2 PROM "  Y - Departamento  (Quebra a listagem a cada Departamento) "
   @ 14, 2 PROM "  Z - Setor" + SPAC( 9 ) + "(Quebra a listagem a cada Setor)" + SPAC( 8 )
   @ 16, 2 PROM "  W - Se‡„o" + SPAC( 9 ) + "(Quebra a listagem a cada Se‡„o)" + SPAC( 8 )
   MENU TO KEY
   IF KEY = 0
      RETU
   ENDIF


   NOM := SPAC( 6 )
   MDS( 'Qual Mensagens para os hollerith' )
   @ 24, 40 GET NOM
   READCUR()
   OBS1 := OBS2 := OBS3 := SPAC( 40 )
   IF netuse( "MESHOL" )
      dbGoTop()
      IF dbSeek( NOM )
         OBS1 := MES1
         OBS2 := MES2
         OBS3 := MES3
      ENDIF
      dbCloseAll()
   ENDIF

   @ 22, 0 CLEAR
   @ 22, 5  SAY 'Mensagem para o Hollerith'
   @ 22, 33 GET OBS1
   IF CC29 # 3
      @ 23, 33 GET OBS2
   ENDIF
   IF CC29 = 0
      @ 24, 33 GET OBS3
   ENDIF
   READCUR()
   @ 22, 0 CLEAR

   IF HOLP1 = 'HOLG1'
      SEPARADO := PEGRELCTA( "" )
   ENDIF


   IF !ARQUSAR( ARQ, 1 )
      RETU .F.
   ENDIF
   cSELE1 := Alias()

   IF !ARQPES( ARQ, 1, 0 )
      dbCloseAll()
      RETURN
   ENDIF
   FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES.AND.YEAR(DEMITIDO)>=ANO))'
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

   IF !ARQCTA( ARQ )
      RETU .F.
   ENDIF
   cSELE3 := Alias()

   IF KEY > 1
      IF !NETUSE( "DEPTO" )  // AREDE("DEPTO","DEPTO",1)
         dbCloseAll()
         RETU
      ENDIF
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
      SET FILTER TO &FILTRA
   ENDIF

   CTLIN := 1
   SET PRIN ON
   ?? Chr( 27 ) + 'C' + Chr( CC26 )
   SET PRIN OFF
   IMPRESSORA()
   IF KEY = 1
      NOMSETOR := ""
      FOFX( ".T." )
   ELSE
      dbSelectAr( "DEPTO" )
      dbGoTop()
      WHILE !Eof()
         NOMSETOR := NOME
         DEP      := DEPTO
         SET      := SETOR
         SEC      := SECAO
         FOFX( COMPAR )
         dbSelectAr( "DEPTO" )
         dbSkip()
      ENDDO
   ENDIF
   IMPFOL()
   VIDEO()
   SET PRIN ON
   ?? Chr( 27 ) + 'C' + Chr( 66 )
   SET PRIN OFF
   dbCloseAll()
   IMPEND()
   RETU

// !*****************************************************************************
// !
// !         Fun‡„o: FOFX()
// !
// !    Chamado por: FOFHOL.PRG
// !
// !          Chama: SALHM()            (fun‡„o    em FOLPROC.PRG)
// !               : CABHOL             (em FOFHOL.PRG)
// !               : &HOLP1
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOFX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOFX

   PARA COMPARE

   dbSelectAr( cSELE2 )
   dbGoTop()
   WHILE !Eof()
      IF &COMPARE
         XFUNCAO := FUNCAO
         XAVE    := NUMERO
         VAR1    := SALH := SALM := 0
         BANC    := BANCO
         AGEN    := AGENCIA
         CONB    := CONTA
         DEPEN   := FOSFAMQTDE( XAVE )
         SALHM()
         CABHOL()
         PRIMA := .T.
         Y     := 1
         dbSelectAr( cSELE1 )  // Posiciona Primeiro Item do Funcionario na folha
         WHILE PRIMA
            CTX := ( XAVE * 10000 ) + Y
            dbGoTop()
            IF dbSeek( CTX )
               PRIMA := .F.
            ENDIF
            Y := Y + 1
            IF Y > 999
               PRIMA := .F.
            ENDIF
         ENDDO
         VALINPS := BASFGTS := VALFGTS := VALIRRF := 0
         CONTAR  := VALVENC := VALDESC := 0
         WHILE XAVE = NUMERO .AND. !Eof()
            CTA   := CONTA
            IMPRI := .T.
            IF ARQ # 6
               IF CONTA = 399 .OR. CONTA = 999
                  IMPRI := .F.
               ENDIF
            ENDIF
            IF ARQ # 4 .AND. ARQ # 8 .AND. ARQ # 7 .AND. ARQ # 6
               IF CTA > 120 .AND. CTA < 150
                  IMPRI := .F.
               ENDIF
               IF CTA = 910 .OR. CTA = 911 .OR. CTA = 505 .OR. CTA = 506
                  IMPRI := .F.
               ENDIF
            ENDIF
            IF ARQ # 6
               IF CONTA > 400 .AND. CONTA < 502
                  IMPRI := .F.
               ENDIF
            ENDIF
            DO &HOLP1
            IF IMPRI
               CONTAR++
               IF CONTAR > CC22
                  CTLIN++
                  @ CC19, 5  SAY 'HOLERITTE CONTINUA NO PROXIMO '
                  @ CC19, 5  SAY 'HOLERITTE CONTINUA NO PROXIMO '
                  @ CC19, 42 SAY '*************'
                  @ CC19, 56 SAY '*************'
                  @ CC18, 56 SAY '*TRANSPORTADO*'
                  CABHOL()
                  CONTAR := 1
                  @ CTLIN, 3 SAY 'ESTE HOLERITTE E CONTINUACAO DO ANTERIOR'
                  CTLIN++
               ENDIF
               @ CTLIN, CC1 SAY CTA PICT "###"
               IMP := 'C'
               IF ARQ # 6
                  IF ( CTA > 500 ) .OR. ( CTA > 40 .AND. CTA < 50 )
                     IMP := 'D'
                  ENDIF
               ENDIF
               IF ( HOLP1 = 'HOLB1' .OR. HOLP1 = 'HOLJ1' ) .AND. ( CONTA = 41 .OR. CONTA = 997 )
                  IMP := 'C'
               ENDIF
               IF HOLP1 = 'HOLB1' .AND. CONTA = 442
                  IMP := 'D'
               ENDIF
               IF HOLP1 = 'HOLI1' .AND. CONTA = 44
                  IMP := 'C'
               ENDIF
               IF HORAS # 0.00
                  @ CTLIN, CC5 SAY HORAS
               ENDIF
               IF IMP = 'C'
                  @ CTLIN, CC6 SAY VALOR PICT '###,###,###.##'
                  VALVENC += VALOR
               ELSE
                  @ CTLIN, CC7 SAY VALOR PICT '##,###,###.##'
                  VALDESC += VALOR
               ENDIF
               dbSelectAr( cSELE3 )
               dbGoTop()
               dbSeek( CTA )
               @ CTLIN, CC4 SAY impstr( Cimpcom ) + IF( Found(), PadL( DESCR, 35 ), PadL( 'CONTA NAO CADASTRADA', 35 ) ) + IMPSTR( Cimpexp )
               dbSelectAr( cSELE1 )
               CTLIN++
            ENDIF
            dbSkip()
         ENDDO
         @ CC19, CC30 SAY VALVENC PICT '###,###,###.##'
         @ CC19, CCXX SAY VALDESC PICT '###,###,###.##'
         SALDO := VALVENC - VALDESC
         @ CC19, CC1 + 1 SAY OBS1
         IF CC29 = 3
            @ CC19 + 1, CC1 + 1 SAY "Saldo Banco de Horas: " + Str( OBTER( "BCOHRS",, Str( XAVE, 8 ) + Str( ANO, 4 ) + Str( MESTRAB, 2 ), "SALDO" ) )
         ELSE
            @ CC19 + 1, CC1 + 1 SAY OBS2
         ENDIF
         IF CC29 = 1 .OR. CC29 = 3
            @ CC18, CC1 + 1  SAY 'BCO/'
            @ CC18, CC1 + 5  SAY BANC
            @ CC18, CC1 + 8  SAY '/AG./'
            @ CC18, CC1 + 13 SAY AGEN
            @ CC18, CC1 + 21 SAY '/CTA/'
            @ CC18, CC1 + 26 SAY CONB
         ENDIF
         IF CC29 = 0
            @ CC18, CC1 + 1 SAY OBS3
         ENDIF
         IF CC29 = 2   // Descri‡„o da Fun‡„o
            @ CC18, CC1 + 1 SAY OBTER( "FUNCAO",, XFUNCAO, "NOME" )
         ENDIF
         @ CC18, CC32    SAY SALDO           PICT '###,###,###.##'
         @ CC18 + 1, 0     SAY impstr( Cimpcom )
         @ CC21, CC8     SAY VAR1            PICT '###,###,###.##'
         @ CC21, CC9     SAY                 VALINPS               PICT '###,###,###.##'
         @ CC21, CC10    SAY BASFGTS         PICT '###,###,###.##'
         @ CC21, CC11    SAY VALFGTS         PICT '###,###,###.##'
         @ CC21, CC12    SAY                 VALIRRF               PICT '###,###,###.##'
         @ CC21, CC12 + 16 SAY DEPEN
         @ CC21, 1       SAY impstr( Cimpexp )
      ENDIF
      dbSelectAr( cSELE2 )
      dbSkip()
   ENDDO
   RETU ( .T. )

// !*****************************************************************************
// !
// !       HOLA1
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function HOLA1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION HOLA1

   DO CASE
   CASE CONTA = 420
      VALINPS := VALOR
   CASE CONTA = 425
      BASFGTS := VALOR
   CASE CONTA = 426
      VALFGTS := VALOR
   CASE CONTA = 401
      VALIRRF := VALOR
   ENDCASE
   RETU


// !*****************************************************************************
// !
// !       HOLB1
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function HOLB1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION HOLB1

   IMPRI := .F.
   IF CONTA = 41 .OR. CONTA = 501 .OR. CONTA = 442 .OR. CONTA = 997
      IMPRI := .T.
   ENDIF
   IF CONTA = 403
      VALIRRF := VALOR
   ENDIF
   RETU



// !*****************************************************************************
// !
// !       HOLD1
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function HOLD1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION HOLD1

// 1a.Parcela
   DO CASE
   CASE CONTA = 464
      VALINPS := VALOR
   CASE CONTA = 465
      BASFGTS := VALOR
   CASE CONTA = 426
      VALFGTS := VALOR
   CASE CONTA = 463
      VALIRRF := VALOR
   CASE CONTA = 490
      AVOS := VALOR
   ENDCASE
// 2a.Parcela
   DO CASE
   CASE CONTA = 468
      VALINPS := VALOR
   CASE CONTA = 469
      BASFGTS := VALOR
   CASE CONTA = 426
      VALFGTS := VALOR
   CASE CONTA = 467
      VALIRRF := VALOR
   CASE CONTA = 490
      AVOS := VALOR
   ENDCASE
   RETU

// !*****************************************************************************
// !
// !       HOLG1
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function HOLG1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION HOLG1

   IMPRI := .F.
   FOR X := 1 TO 15
      IF CONTA = SEPARADO[ X ]
         IMPRI := .T.
      ENDIF
   NEXT
   RETU


// !*****************************************************************************
// !
// !       HOLH1
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function HOLH1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION HOLH1

   RETU


// !*****************************************************************************
// !
// !       HOLI1
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function HOLI1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION HOLI1

   IMPRI := .F.
   IF CONTA = 445 .OR. CONTA = 527
      IMPRI := .T.
   ENDIF
   IF CONTA = 409
      VALIRRF := VALOR
   ENDIF
   RETU


// !*****************************************************************************
// !
// !       HOLJ1
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function HOLJ1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION HOLJ1

   IMPRI := .F.
   IF CONTA = 41 .OR. CONTA = 501 .OR. CONTA = 442 .OR. CONTA = 997
      IMPRI := .T.
   ENDIF
   IF CONTA = 445 .OR. CONTA = 527
      IMPRI := .T.
   ENDIF
   IF CONTA = 403
      VALIRRF := VALOR
   ENDIF
   RETU


// !*****************************************************************************
// !
// !      CABHOL
// !
// !    Chamado por: FOFX()             (fun‡„o    em FOFHOL.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CABHOL()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNCTION CABHOL

   dbSelectAr( cSELE2 )
   CTLIN := 1
   CTLIN := CTLIN + CC25
   DO CASE
   CASE CC20 = 1
      @ CTLIN, 1    SAY IMPCHR( cIMPTIT )
      @ CTLIN, CC13 SAY MSG2
      CTLIN++
      @ CTLIN, CC28 SAY CGC
   CASE CC20 = 2
      @ CTLIN, 1    SAY ""
      @ CTLIN, CC13 SAY ""
      CTLIN++
      @ CTLIN, CC28 SAY ""
   OTHERWISE
      @ CTLIN, CC13 SAY MSG2
      CTLIN++
      @ CTLIN, CC28 SAY CGC
   ENDCASE
   IF CC20 # 2
      @ CTLIN, CC27    SAY MMES PICT '#########'
      @ CTLIN, CC27 + 9  SAY '/'
      @ CTLIN, CC27 + 10 SAY ANO  PICT '####'
   ENDIF
   CTLIN := CTLIN + CC24
   @ CTLIN, CC14 SAY NUMERO
   @ CTLIN, CC2  SAY NOME
   @ CTLIN, CC15 SAY OBTER( "FUNCAO",, XFUNCAO, "CBONEW" ) // CBONEW
   @ CTLIN, CC3  SAY DEPTO
   @ CTLIN, CC16 SAY SETOR
   @ CTLIN, CC17 SAY SECAO
   IF CC20 # 2
      CTLIN := CTLIN + CC23
   ELSE
      CTLIN++
      @ CTLIN, CC27    SAY MMES PICT '#########'
      @ CTLIN, CC27 + 9  SAY '/'
      @ CTLIN, CC27 + 10 SAY ANO  PICT '####'
      CTLIN := CTLIN + CC23 - 1
   ENDIF
   dbSelectAr( cSELE1 )

   RETURN
// : FIM: FOFHOL.PRG

// + EOF: fofhol.prg
// +
