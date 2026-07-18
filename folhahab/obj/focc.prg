// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : focc.prg
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
// :       FOCC.PRG: Rela‡„o de L¡quidos a Pagar/Bancaria/Cheques
// :      Linguagem: harbour
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: jcassiano 
// :      Copyright (c) 1997,  jcassiano  S/C Ltda.
// :  Atualizado em: 02/10/97
// :
// :*****************************************************************************


// //#INCLUDE "COMANDO.CH"
#include "BOX.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function focc()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION focc

   PARA CC, CW, CX

   IF ( CX = 3 .OR. CX = 4 ) .AND. CC = 6
      ALERTX( "Opcao Nao Disponivel" )
      RETU .F.
   ENDIF

   CTACRE := 399
   CTADEB := 999
   lVALE  := .F.
   IF CC = 9
      lVALE  := .T.
      CTACRE := 41
      CTADEB := 501
      CC     := 1  // Abrira Folha
   ENDIF
   IF CC = 10
      CTACRE   := 445
      CTADEB   := 527
      SOMAVALE := MDG( "Somado com o Vale" )
      CC       := 1  // Abrira Folha
   ENDIF
   IF CC = 3
      CTACRE := 900
      CTADEB := 0
   ENDIF

   IF CC = 6
      CTACRE := 443
      CTADEB := 530
      CC     := 1  // Abrira Folha
   ENDIF


   MDS( "Confirme Contas Credito Debito" )
   @ 24, 40 GET CTACRE PICT "999"
   @ 24, 50 GET CTADEB PICT "999"
   IF !READCUR()
      RETU .F.
   ENDIF


   DO CASE
   CASE CX = 1
      IF !MDL( 'Listar Relacao de Liquidos  a Pagar', 0 )
         RETU
      ENDIF
   CASE CX = 2
      IF !MDL( 'Listar Bancaria', 0 )
         RETU
      ENDIF
   CASE CX = 3
      IF !MDL( 'Emitir Cheques de Pagamento', 0 )
         RETU
      ENDIF
   CASE CX = 4
      CABEX( 'Gerar Arquivo Banespa' )
   CASE CX = 5
      CABEX( 'Gerar Arquivo Itau' )
   ENDCASE

// Variaveis de Trabalho
   SOMAVALE := .F.
   mDIA     := Date()
   COPIA    := 1
   ATUALIZA := 1.000000


   IF CX # 3 .AND. CX # 4 .AND. CX # 5
      MDS( 'Digite Cabe‡ario Complementar' )
      @ 24, 35 GET POS1
      READCUR()
      MDS( 'Digite o numero de copias' )
      @ 24, 40 GET COPIA PICT '##'
      READCUR()
   ELSE
      MDS( 'Confirme a Data Emissao' )
      @ 24, 40 GET mDIA
      READCUR()
   ENDIF


   MDS( 'Qual o Fator de Atualiza‡„o' )
   @ 24, 40 GET ATUALIZA PICT "99999999999.999999"
   READCUR()

   IF !ARQUSAR( CC, 1 )
      dbCloseAll()
      RETU .F.
   ENDIF
   cSELE1 := Alias()

   IF !ARQPES( CC, 1, 0 )
      dbCloseAll()
      RETU .F.
   ENDIF
   cSELE2 := Alias()
   INX    := ""
   FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES))'
   FILORD()
   IF CX = 2   // Rela‡ao Bancaria Chave Quebra Banco+chave
      DO CASE
      CASE Type( INX ) = "N"
         INX := "STR(" + INX + ")"
      CASE Type( INX ) = "D"
         INX := "DTOC(" + INX + ")"
      ENDCASE
      INX := "BANCO+" + INX
   ENDIF
   nLASTREC := LastRec()
   zei_fort( nLASTREC,,, 0 )
   ordDestroy( "temp" )
   ordCreate(, "temp", "inx" )
   ordSetFocus( "temp" )
   SET FILTER TO &FILTRO

   IF CW > 1
      IF !NETUSE( "DEPTO" )  // AREDE("DEPTO","DEPTO",1)
         dbCloseAll()
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


   IF CX # 4 .AND. CX # 5
      IMPRESSORA()
   ENDIF
   FOR W := 1 TO COPIA
      FL := 0
      IF CW = 1
         NOMSETOR := ""
         DO CASE
         CASE CX = 1
            FOCCX( ".T." )
         CASE CX = 2
            FOCBX( ".T." )
         CASE CX = 3
            FOCIX( ".T." )
         CASE CX = 4
            FOCHX( ".T." )
         CASE CX = 5
            FOCITAU( ".T." )
         ENDCASE
      ELSE
         dbSelectAr( "DEPTO" )
         dbGoTop()
         WHILE !Eof()
            NOMSETOR := NOMEC
            DEP      := DEPTO
            SET      := SETOR
            SEC      := SECAO
            DO CASE
            CASE CX = 1
               FOCCX( COMPAR )
            CASE CX = 2
               FOCBX( COMPAR )
            CASE CX = 3
               FOCIX( COMPAR )
            CASE CX = 4
               FOCHX( COMPAR )
            CASE CX = 5
               FOCITAU( COMPAR )
            ENDCASE
            dbSelectAr( "DEPTO" )
            dbSkip()
         ENDDO
      ENDIF
      IF CX # 4 .AND. CX # 5
         IMPFOL()
      ENDIF
   NEXT W
   VIDEO()
   dbCloseAll()
   IF CX # 4 .AND. CX # 5
      IMPEND()
   ENDIF
   RETU

// !*****************************************************************************
// !
// !         Fun‡„o: FOCCX()
// !
// !    Chamado por: FOCC.PRG
// !
// !          Chama: VALCTA()           (fun‡„o    em FOLPROC.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOCCX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOCCX

   PARA COMPARE

   TOTAL    := 0
   CTLIN    := 80
   TOTALIZA := .F.
   dbSelectAr( cSELE2 )
   dbGoTop()
   WHILE !Eof()
      IF &COMPARE
         TOTALIZA := .T.
         IF CTLIN > 55
            IF CTLIN # 80
               IF TOTALIZA .AND. TOTAL > 0
                  @ PRow() + 1, 0  SAY REPL( '-', 132 )
                  @ PRow() + 1, 21 SAY 'VALOR A SER PAGO (PAGAMENTO LIQUIDO)--> '
                  @ PRow(), 64    SAY TOTAL                                      PICTURE '@E 999,999,999,999.99'
                  @ PRow() + 1, 0  SAY REPL( '-', 132 )
               ENDIF
            ENDIF
            FL++
            @  1, 0   SAY IF( IM1 = 'A', IMPSTR( cIMPCOM ), IMPSTR( cIMPEXP ) )
            @  2, 20  SAY IMPCHR( cIMPTIT ) + MSG2
            @  3, 5   SAY IMPCHR( cIMPTIT ) + 'PAGAMENTO EXECUTADO SIMPLES'
            @  4, 0   SAY IMPCHR( cIMPTIT ) + NOMSETOR
            @  5, 0   SAY POS1
            @  5, 100 SAY Time()
            @  5, 110 SAY DXDIA
            @  5, 120 SAY 'FL. ' + StrZero( FL, 4 )
            @  6, 0   SAY REPL( '-', 132 )
            @  7, 1   SAY 'DEPTO'
            @  7, 7   SAY 'SETOR'
            @  7, 13  SAY ACENTO( 'SE€ŽO' )
            @  7, 19  SAY 'CHAPA'
            @  7, 25  SAY 'REGISTRO'
            @  7, 34  SAY 'NOME'
            @  7, 65  SAY 'VALOR A PAGAR'
            @  8, 0   SAY REPL( '-', 132 )
            CTLIN := 9
         ENDIF
         NUM := NUMERO
         dbSelectAr( cSELE1 )
         LIQ := VALCTA( NUM, CTACRE ) - VALCTA( NUM, CTADEB )
         LIQ := LIQ + IF( lVALE, VALCTA( NUM, 997 ) - VALCTA( NUM, 442 ), 0 )
         LIQ := IF( ATUALIZA # 1, Round( LIQ * ATUALIZA, 2 ), LIQ )
         dbSelectAr( cSELE2 )
         IF LIQ # 0
            @ CTLIN, 2  SAY DEPTO
            @ CTLIN, 8  SAY SETOR
            @ CTLIN, 14 SAY SECAO
            @ CTLIN, 20 SAY CHAPA
            @ CTLIN, 26 SAY NUMERO
            @ CTLIN, 33 SAY NOME
            @ CTLIN, 64 SAY LIQ    PICT '@E 999,999,999,999.99'
            TOTAL += LIQ
            CTLIN++
         ENDIF
      ENDIF
      dbSelectAr( cSELE2 )
      dbSkip()
   ENDDO
   IF TOTALIZA .AND. TOTAL > 0
      @ PRow() + 1, 0  SAY REPL( '-', 132 )
      @ PRow() + 1, 21 SAY 'VALOR A SER PAGO (PAGAMENTO LIQUIDO)--> '
      @ PRow(), 64    SAY TOTAL                                      PICTURE '@E 999,999,999,999.99'
      @ PRow() + 1, 0  SAY REPL( '-', 132 )
   ENDIF
   RETU ( .T. )


// !*****************************************************************************
// !
// !         Fun‡„o: FOCBX()
// !
// !    Chamado por: FOCC.PRG
// !
// !          Chama: VALCTA()           (fun‡„o    em FOLPROC.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOCBX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOCBX

   PARA COMPARE

   CTLIN    := 80
   TOTAL    := 0
   TOTALIZA := .F.
   dbSelectAr( cSELE2 )
   dbGoTop()
   xBANCO := BANCO
   WHILE !Eof()
      IF Empty( BANCO )
         dbSkip()
         LOOP
      ENDIF
      IF &COMPARE
         IF BANCO # xBANCO
            CTLIN  := 99
            xBANCO := BANCO
         ENDIF
         TOTALIZA := .T.
         IF CTLIN > 60 .OR. CTLIN = 99
            IF CTLIN # 80
               IF TOTALIZA .AND. TOTAL > 0
                  @ PRow() + 1, 0  SAY REPL( '-', 132 )
                  @ PRow() + 1, 31 SAY 'VALOR A SER DEBITADO EM NOSSA CONTA CORRENTE--> '
                  @ PRow(), 93    SAY TOTAL                                              PICTURE '@E 999,999,999,999.99'
                  @ PRow() + 1, 0  SAY REPL( '-', 132 )
                  IF CTLIN = 99
                     TOTAL := 0
                     // TOTALIZA:=.F.
                     FL := 0
                  ENDIF
               ENDIF
            ENDIF
            FL++
            @  1, 0   SAY IF( IM1 = 'A', IMPSTR( cIMPCOM ), IMPSTR( cIMPEXP ) )
            @  2, 20  SAY IMPCHR( cIMPTIT ) + MSG2
            @  3, 5   SAY IMPCHR( cIMPTIT ) + ACENTO( 'RELA€ŽO PARA DEP•SITOS EM CONTA CORRENTE ' )
            @  4, 0   SAY IMPCHR( cIMPTIT ) + NOMSETOR
            @  5, 0   SAY POS1
            @  5, 100 SAY Time()
            @  5, 110 SAY DXDIA
            @  5, 120 SAY 'FL. ' + StrZero( FL, 4 )
            @  6, 0   SAY REPL( '-', 132 )
            @  7, 1   SAY 'DEPTO'
            @  7, 7   SAY 'SETOR'
            @  7, 13  SAY ACENTO( 'SE€ŽO' )
            @  7, 19  SAY 'CHAPA'
            @  7, 25  SAY 'REGISTRO'
            @  7, 34  SAY 'NOME'
            @  7, 65  SAY 'BCO'
            @  7, 69  SAY 'AGENCIA'
            @  7, 77  SAY ACENTO( 'N—MERO CONTA' )
            @  7, 91  SAY 'VALOR DEPOSITADO'
            @  8, 0   SAY REPL( '-', 132 )
            CTLIN := 9
         ENDIF
         NUM := NUMERO
         dbSelectAr( cSELE1 )
         LIQ := VALCTA( NUM, CTACRE ) - VALCTA( NUM, CTADEB )
         LIQ += IF( lVALE .OR. SOMAVALE, VALCTA( NUM, 997 ) - VALCTA( NUM, 442 ), 0 )
         IF SOMAVALE
            LIQ += VALCTA( NUM, 41 ) - VALCTA( NUM, 501 )
         ENDIF
         LIQ := IF( ATUALIZA # 1, Round( LIQ * ATUALIZA, 2 ), LIQ )
         dbSelectAr( cSELE2 )
         IF LIQ > 0
            @ CTLIN, 2  SAY DEPTO
            @ CTLIN, 8  SAY SETOR
            @ CTLIN, 14 SAY SECAO
            @ CTLIN, 20 SAY CHAPA
            @ CTLIN, 26 SAY NUMERO
            @ CTLIN, 33 SAY NOME
            @ CTLIN, 65 SAY BANCO
            @ CTLIN, 69 SAY AGENCIA
            @ CTLIN, 78 SAY CONTA
            @ CTLIN, 93 SAY LIQ     PICT '@E 999,999,999,999.99'
            CTLIN++
            TOTAL += LIQ
         ENDIF
      ENDIF
      dbSelectAr( cSELE2 )
      dbSkip()
   ENDDO
   IF TOTALIZA .AND. TOTAL > 0
      @ PRow() + 1, 0  SAY REPL( '-', 132 )
      @ PRow() + 1, 31 SAY 'VALOR A SER DEBITADO EM NOSSA CONTA CORRENTE--> '
      @ PRow(), 93    SAY TOTAL                                              PICTURE '@E 999,999,999,999.99'
      @ PRow() + 1, 0  SAY REPL( '-', 132 )
   ENDIF
   RETU ( .T. )

// !*****************************************************************************
// !
// !         Fun‡„o: FOCIX()
// !
// !    Chamado por: FOCC.PRG
// !
// !          Chama: VALCTA()           (fun‡„o    em FOLPROC.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOCIX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOCIX

   PARA COMPARE

   dbSelectAr( cSELE2 )
   dbGoTop()
   WHILE !Eof()
      IF &COMPARE
         NUM := NUMERO
         dbSelectAr( cSELE1 )
         LIQ := VALCTA( NUM, CTACRE ) - VALCTA( NUM, CTADEB )
         LIQ := LIQ + IF( lVALE, VALCTA( NUM, 997 ) - VALCTA( NUM, 442 ), 0 )
         LIQ := IF( ATUALIZA # 1, Round( LIQ * ATUALIZA, 2 ), LIQ )
         dbSelectAr( cSELE2 )
         IF LIQ > 0
            @ PRow(), 50    SAY LIQ                               PICT "@E 9,999,999,999.99"
            @ PRow() + 2, 14 SAY EXT( LIQ, 1, 55, 65, 0 )
            @ PRow() + 1, 2  SAY EXT( LIQ, 2, 55, 65, 0 )
            @ PRow() + 2, 4  SAY NOME
            @ PRow() + 2, 26 SAY Trim( CID1 ) + ", " + Str( Day( mDIA ), 2 )
            @ PRow(), 48    SAY MMES( Month( mDIA ) )
            @ PRow(), 65    SAY SubStr( StrZero( Year( mDIA ), 4 ), 3, 4 )
            @ PRow() + 11, 0  SAY ""
         ENDIF
      ENDIF
      dbSelectAr( cSELE2 )
      dbSkip()
   ENDDO
   RETU ( .T. )

// !*****************************************************************************
// !
// !         Fun‡„o: FOCHX()
// !
// !    Chamado por: FOCC.PRG
// !
// !          Chama: VALCTA()           (fun‡„o    em FOLPROC.PRG)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOCHX()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOCHX

   PARA COMPARE

   cARQNOME := "BANESPA.TXT" + Space( 20 )
   cCODEMP  := Space( 4 )
   cNOMEMP  := TIRACX( MSG2, 30 )
   cLITER   := PadR( "CREDITOS EM C/C", 14 )
   cNOMEBCO := PadR( "BANESPA S/A", 15 )
   cDENSID  := 1600
   cCODLAN  := Space( 25 )
   cCODSER  := "001"
   cREFEXT  := "021"
   cSINAL   := "C"
   cCGC     := CGC1
   dLANC    := mDIA

   hb_DispBox( 5, 0, 23, 79, B_DOUBLE + " " )
   @  6, 2  SAY "Arquivo" + spac( 12 ) + ":"
   @  7, 2  SAY "Codigo da Empresa  :"
   @  8, 2  SAY "Nome da Emprea     :"
   @  9, 2  SAY "Literal Servi‡o    :"
   @ 10, 2  SAY "Nome do Banco" + spac( 6 ) + ":"
   @ 11, 2  SAY "Data Grava‡„o" + spac( 6 ) + ":"
   @ 12, 2  SAY "Data Lan‡amento    :"
   @ 13, 2  SAY "Densidade" + spac( 10 ) + ":"
   @ 14, 2  SAY "Identidade Empresa :"
   @ 15, 2  SAY "Codigo do Servico  :"
   @ 16, 2  SAY "Referencia Extrato :"
   @ 17, 2  SAY "Identidade Sinal   :     (C/D)"
   @ 18, 2  SAY "CGC Empresa" + spac( 8 ) + ":"
   @  6, 23 GET cARQNOME
   @  7, 23 GET cCODEMP
   @  8, 23 GET cNOMEMP
   @  9, 23 GET cLITER
   @ 10, 23 GET cNOMEBCO
   @ 11, 23 GET mDIA
   @ 12, 23 GET dLANC
   @ 13, 23 GET cDENSID                          PICT "99999"
   @ 14, 23 GET cCODLAN
   @ 15, 23 GET cCODSER
   @ 16, 23 GET cREFEXT
   @ 17, 23 GET cSINAL
   @ 18, 23 GET cCGC
   READCUR()


   cDENSID := StrZero( cDENSID, 5 )
   mDIA    := DToC( mDIA )
   mDIA    := StrTran( mDIA, "/", "" )
   dLANC   := DToC( dLANC )
   dLANC   := StrTran( dLANC, "/", "" )
   cCGC    := TIRACX( cCGC,,, "" )
   SEQ     := 1
   CRE     := 0
   nHANDLE := FCreate( AllTrim( cARQNOME ) )
   IF FError() # 0
      ALERTX( "Erro na Cria‡„o do Arquivo" )
      RETU
   ENDIF

// Gravando Header de Arquivo
   FWrite( nHANDLE, "0" )
   FWrite( nHANDLE, "1" )
   FWrite( nHANDLE, "REMESSA" )
   FWrite( nHANDLE, "03" )
   FWrite( nHANDLE, cLITER )
   FWrite( nHANDLE, cCODEMP )
   FWrite( nHANDLE, Space( 17 ) )
   FWrite( nHANDLE, cNOMEMP )
   FWrite( nHANDLE, "033" )
   FWrite( nHANDLE, cNOMEBCO )
   FWrite( nHANDLE, mDIA )
   FWrite( nHANDLE, cDENSID )
   FWrite( nHANDLE, "BPI" )
   FWrite( nHANDLE, "01" )
   FWrite( nHANDLE, Space( 84 ) )
   FWrite( nHANDLE, StrZero( SEQ, 6 ) )
   FWrite( nHANDLE, hb_osNewLine() )
   SEQ++
   CRE++
   CTLIN    := 80
   TOTAL    := 0
   TOTALIZA := .F.
   dbSelectAr( cSELE2 )
   dbGoTop()
   WHILE !Eof()
      PETELA( 08 )
      IF BANCO # "033"   // Checar Codigo Banco
         dbSkip()
         LOOP
      ENDIF
      IF !VALCPF( CPF )  // Checar CPF
         dbSkip()
         LOOP
      ENDIF
      IF !CHECKCTA( BANCO, AGENCIA, CONTA )  // Checar Conta
         dbSkip()
         LOOP
      ENDIF
      IF &COMPARE
         NUM      := NUMERO
         cNOME    := TIRACX( NOME, 40 )
         cCONTA   := TIRACX( CONTA,,, "" )
         cAGENCIA := TIRACX( AGENCIA,,, "" )
         cAGENCIA := Right( cAGENCIA, 3 )
         cAGENCTA := cAGENCIA + cCONTA
         dbSelectAr( cSELE1 )
         LIQ := VALCTA( NUM, CTACRE ) - VALCTA( NUM, CTADEB )
         LIQ += IF( lVALE .OR. SOMAVALE, VALCTA( NUM, 997 ) - VALCTA( NUM, 442 ), 0 )
         IF SOMAVALE
            LIQ += VALCTA( NUM, 41 ) - VALCTA( NUM, 501 )
         ENDIF
         LIQ := IF( ATUALIZA # 1, Round( LIQ * ATUALIZA, 2 ), LIQ )
         dbSelectAr( cSELE2 )
         IF LIQ > 0
            cLIQ := StrZero( LIQ, 14, 2 )
            cLIQ := StrTran( cLIQ, ".", "" )
            // Gravando Registro
            FWrite( nHANDLE, "1" )
            FWrite( nHANDLE, "02" )
            FWrite( nHANDLE, PadR( cCGC, 14 ) )
            FWrite( nHANDLE, cCODEMP )
            FWrite( nHANDLE, Space( 16 ) )
            FWrite( nHANDLE, PadR( cCODLAN, 25 ) )
            FWrite( nHANDLE, cAGENCTA )
            FWrite( nHANDLE, Space( 8 ) )
            FWrite( nHANDLE, cNOME )
            FWrite( nHANDLE, dLANC )
            FWrite( nHANDLE, cLIQ )
            FWrite( nHANDLE, cCODSER )
            FWrite( nHANDLE, cREFEXT )
            FWrite( nHANDLE, Space( 3 ) )
            FWrite( nHANDLE, cSINAL )
            FWrite( nHANDLE, Space( 3 ) )
            FWrite( nHANDLE, StrZero( NUM, 14 ) )
            FWrite( nHANDLE, Space( 26 ) )
            FWrite( nHANDLE, StrZero( SEQ, 6 ) )
            FWrite( nHANDLE, hb_osNewLine() )
            SEQ++
            CRE++
            TOTAL += LIQ
         ENDIF
      ENDIF
      dbSelectAr( cSELE2 )
      dbSkip()
   ENDDO
   TOTAL := StrZero( TOTAL, 16, 2 )
   TOTAL := StrTran( TOTAL, ".", "" )
// Gravando trailler
   FWrite( nHANDLE, "9" )
   FWrite( nHANDLE, Space( 149 ) )
   FWrite( nHANDLE, StrZero( 0, 6 ) )
   FWrite( nHANDLE, StrZero( 0, 15 ) )
   FWrite( nHANDLE, StrZero( CRE, 6 ) )
   FWrite( nHANDLE, TOTAL )
   FWrite( nHANDLE, Space( 2 ) )
   FWrite( nHANDLE, StrZero( SEQ, 6 ) )
   FWrite( nHANDLE, hb_osNewLine() )
   FWrite( nHANDLE, Chr( 26 ) )
   FClose( nHANDLE )



   IF MDG( "Deseja Ver o Arquivo" )
      VERTXT( cARQNOME )
   ENDIF
   IF MDG( "Deseja imprimir o Arquivo" )
      imparq( cARQNOME,,,,,,, 200, )
   ENDIF


   RETU ( .T. )




// +--------------------------------------------------------------------
// +
// +
// +
// +    Function FOCITAU()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC FOCITAU

   PARA COMPARE

   cARQNOME := "ITAU.TXT" + Space( 20 )
   cCGC     := TIRACX( CGC1, 14,, "" )
   cNOMEMP  := TIRACX( MSG2, 30 )
   cPESSOA  := ZPESSOA
   SET CENTURY ON
   cDATA   := TIRACX( Date(), 8,, "" )
   mDATAPG := TIRACX( Date(), 8,, "" )
   SET CENTURY OFF
   cTIME    := TIRACX( Time(), 6,, "" )
   nAGENCIA := 0
   nCONTA   := 0
   nDAC     := 0
   mCEP     := StrTran( CEP1, "-", "" )
   mCIDADE  := TIRACX( CID1, 20,, "" )
   mESTADO  := EST1


   IF !NETUSE( "BCOFGTS" )
      RETU .F.
   ENDIF
   dbGoTop()
   IF !dbSeek( NREMP )
      dbCloseAll()
      ALERTX( "Falta Cadastro Detalhes Empresa" )
      RETU
   ENDIF
   mEND := TIRACX( ENDERECO, 30,, "" )
   mNUM := StrZero( Val( NUMEROEMP ), 5 )
   mCOM := TIRACX( COMPLEMEN, 15,, "" )
   dbCloseArea()


   hb_DispBox( 5, 0, 23, 79, B_DOUBLE + " " )
   @  6, 2  SAY "Arquivo           :"
   @  7, 2  SAY "CGC Empresa       :"
   @  8, 2  SAY "Agencia Conta     :"
   @  9, 2  SAY "Nome da Empresa   :"
   @ 10, 2  SAY "Data Hora Gera‡Æo :"
   @ 11, 2  SAY "Endereco N§ Comp  :"
   @ 12, 2  SAY "UF Cidade  CEP    :"
   @ 13, 2  SAY "Data Prv. Pagmto. :"
   @  6, 23 GET cARQNOME
   @  7, 23 GET cPESSOA
   @  7, 25 GET cCGC
   @  8, 23 GET nAGENCIA              PICT "99999"
   @  8, 30 GET nCONTA                PICT "999999999999"
   @  8, 45 GET nDAC                  PICT "9"
   @  9, 23 GET cNOMEMP
   @ 10, 23 GET cDATA
   @ 10, 33 GET cTIME
   @ 11, 23 GET mEND
   @ 11, 54 GET mNUM
   @ 11, 60 GET mCOM
   @ 12, 23 GET mESTADO               PICTURE "!!"                        VALID CHECKTAB( PadR( "UF", 4 ) + PadR( mESTADO, 5 ), 24, 0, "Estado N„o Cadastrado" )
   @ 12, 26 GET mCIDADE               VALID CHECKCID( mESTADO, mCIDADE, .T. )
   @ 12, 47 GET mCEP                  VALID CHKUFCEP( mCEP, mESTADO )
   @ 13, 23 GET mDATAPG
   READCUR()
   nHANDLE := FCreate( AllTrim( cARQNOME ) )
   IF FError() # 0
      ALERTX( "Erro na Cria‡„o do Arquivo" )
      RETU
   ENDIF


// Header Arquivo
   FWrite( nHANDLE, "341" )
   FWrite( nHANDLE, "0000" )
   FWrite( nHANDLE, "0" )
   FWrite( nHANDLE, Space( 6 ) )
   FWrite( nHANDLE, "040" )
   FWrite( nHANDLE, IF( cPESSOA = "J", "2", "1" ) )
   FWrite( nHANDLE, cCGC )
   FWrite( nHANDLE, Space( 20 ) )
   FWrite( nHANDLE, StrZero( nAGENCIA, 5 ) )
   FWrite( nHANDLE, " " )
   FWrite( nHANDLE, StrZero( nCONTA, 12 ) )
   FWrite( nHANDLE, " " )
   FWrite( nHANDLE, StrZero( nDAC, 1 ) )
   FWrite( nHANDLE, cNOMEMP )
   FWrite( nHANDLE, PadR( "BCO ITAU SA", 30 ) )
   FWrite( nHANDLE, Space( 10 ) )
   FWrite( nHANDLE, "1" )   // Remessa
   FWrite( nHANDLE, cDATA )
   FWrite( nHANDLE, cTIME )
   FWrite( nHANDLE, REPL( "0", 9 ) )
   FWrite( nHANDLE, REPL( "0", 5 ) )
   FWrite( nHANDLE, Space( 69 ) )
   FWrite( nHANDLE, hb_osNewLine() )

// Header Lote
   FWrite( nHANDLE, "341" )
   FWrite( nHANDLE, "0001" )  // Lote
   FWrite( nHANDLE, "1" )
   FWrite( nHANDLE, "C" )
   FWrite( nHANDLE, "30" )
   FWrite( nHANDLE, "01" )  // Credito
   FWrite( nHANDLE, "030" )
   FWrite( nHANDLE, " " )
   FWrite( nHANDLE, IF( cPESSOA = "J", "2", "1" ) )
   FWrite( nHANDLE, cCGC )
   FWrite( nHANDLE, Space( 20 ) )
   FWrite( nHANDLE, StrZero( nAGENCIA, 5 ) )
   FWrite( nHANDLE, " " )
   FWrite( nHANDLE, StrZero( nCONTA, 12 ) )
   FWrite( nHANDLE, " " )
   FWrite( nHANDLE, StrZero( nDAC, 1 ) )
   FWrite( nHANDLE, cNOMEMP )
   FWrite( nHANDLE, Space( 30 ) )
   FWrite( nHANDLE, Space( 10 ) )
   FWrite( nHANDLE, mEND )
   FWrite( nHANDLE, mNUM )
   FWrite( nHANDLE, mCOM )
   FWrite( nHANDLE, mCIDADE )
   FWrite( nHANDLE, mCEP )
   FWrite( nHANDLE, mESTADO )
   FWrite( nHANDLE, Space( 8 ) )
   FWrite( nHANDLE, Space( 10 ) )
   FWrite( nHANDLE, hb_osNewLine() )

   nSEQ := 0
   nVAL := 0
   dbSelectAr( cSELE2 )
   dbGoTop()
   WHILE !Eof()
      PETELA( 08 )
      IF BANCO # "341"   // Checar Codigo Banco
         dbSkip()
         LOOP
      ENDIF
      // IF ! VALCPF(CPF) //Checar CPF
      // DBSKIP()
      // LOOP
      // ENDIF
      IF !CHECKCTA( BANCO, AGENCIA, CONTA )  // Checar Conta
         dbSkip()
         LOOP
      ENDIF
      IF &COMPARE
         NUM    := NUMERO
         cNOME  := TIRACX( NOME, 30 )
         cCONTA := "0"
         cDAC   := "0"
         nPOS   := At( "-", CONTA )
         IF nPOS > 0
            cCONTA := Left( CONTA, nPOS - 1 )
            cDAC   := SubStr( CONTA, nPOS + 1, 1 )
         ENDIF
         dbSelectAr( cSELE1 )
         LIQ := VALCTA( NUM, CTACRE ) - VALCTA( NUM, CTADEB )
         LIQ += IF( lVALE .OR. SOMAVALE, VALCTA( NUM, 997 ) - VALCTA( NUM, 442 ), 0 )
         IF SOMAVALE
            LIQ += VALCTA( NUM, 41 ) - VALCTA( NUM, 501 )
         ENDIF
         LIQ := IF( ATUALIZA # 1, Round( LIQ * ATUALIZA, 2 ), LIQ )
         dbSelectAr( cSELE2 )
         IF LIQ > 0 .AND. Val( cCONTA ) # 0
            nSEQ++
            nVAL += LIQ
            cLIQ := StrZero( LIQ, 16, 2 )  // 15+2+1"."
            cLIQ := StrTran( cLIQ, ".", "" )
            FWrite( nHANDLE, "341" )
            FWrite( nHANDLE, "0001" )   // Lote
            FWrite( nHANDLE, "3" )
            FWrite( nHANDLE, StrZero( nSEQ, 5 ) )
            FWrite( nHANDLE, "A" )
            FWrite( nHANDLE, "000" )  // iNCLUSAO
            FWrite( nHANDLE, "000" )
            FWrite( nHANDLE, "341" )
            FWrite( nHANDLE, StrZero( Val( AGENCIA ), 5 ) )
            FWrite( nHANDLE, " " )
            FWrite( nHANDLE, StrZero( Val( cCONTA ), 12 ) )
            FWrite( nHANDLE, " " )
            FWrite( nHANDLE, cDAC )
            FWrite( nHANDLE, cNOME )
            FWrite( nHANDLE, Space( 20 ) )
            FWrite( nHANDLE, mDATAPG )
            FWrite( nHANDLE, "009" )  // Real
            FWrite( nHANDLE, REPL( "0", 15 ) )
            FWrite( nHANDLE, cLIQ )
            FWrite( nHANDLE, Space( 15 ) )
            FWrite( nHANDLE, Space( 5 ) )
            FWrite( nHANDLE, REPL( "0", 8 ) )
            FWrite( nHANDLE, REPL( "0", 15 ) )
            FWrite( nHANDLE, Space( 18 ) )
            FWrite( nHANDLE, Space( 2 ) )
            FWrite( nHANDLE, REPL( "0", 6 ) )
            FWrite( nHANDLE, REPL( "0", 14 ) )
            FWrite( nHANDLE, Space( 12 ) )
            FWrite( nHANDLE, "0" )  // Nao Emite Aviso
            FWrite( nHANDLE, Space( 10 ) )
            FWrite( nHANDLE, hb_osNewLine() )
         ENDIF
      ENDIF
      dbSelectAr( cSELE2 )
      dbSkip()
   ENDDO





// Header Lote
   cVAL := StrZero( nVAL, 19, 2 )  // 16+2+1"."=19
   cVAL := StrTran( cVAL, ".", "" )
   FWrite( nHANDLE, "341" )
   FWrite( nHANDLE, "0001" )  // Lote
   FWrite( nHANDLE, "5" )
   FWrite( nHANDLE, Space( 9 ) )
   FWrite( nHANDLE, StrZero( nSEQ + 2, 6 ) )
   FWrite( nHANDLE, cVAL )
   FWrite( nHANDLE, REPL( "0", 18 ) )
   FWrite( nHANDLE, Space( 171 ) )
   FWrite( nHANDLE, Space( 10 ) )
   FWrite( nHANDLE, hb_osNewLine() )

// Header Arquivo
   FWrite( nHANDLE, "341" )
   FWrite( nHANDLE, "9999" )  // Lote
   FWrite( nHANDLE, "9" )
   FWrite( nHANDLE, Space( 9 ) )
   FWrite( nHANDLE, "000001" )  // Lote
   FWrite( nHANDLE, StrZero( nSEQ + 4, 6 ) )
   FWrite( nHANDLE, Space( 211 ) )
   FWrite( nHANDLE, hb_osNewLine() )

   FWrite( nHANDLE, Chr( 26 ) )
   FClose( nHANDLE )


   IF MDG( "Deseja Ver o Arquivo" )
      VERTXT( cARQNOME )
   ENDIF
   IF MDG( "Deseja imprimir o Arquivo" )
      imparq( cARQNOME,,,,,,, 240, )
   ENDIF

   RETU .T.


// : FIM: FOCC.PRG

// + EOF: focc.prg
// +
