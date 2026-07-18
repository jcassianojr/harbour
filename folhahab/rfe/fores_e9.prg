// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_e9.prg
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
// +    Documentado em 27-Dez-2024 as  9:41 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +

// :*****************************************************************************
// :
// :   FORES_E9.PRG: Imprimir Resumo de Rescis„o Contratual
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :          Autor: Equipe Disk
// :      Copyright (c) 1999,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/03/99
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fores_e9()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fores_e9

   PARA CC

   IF !MDL( 'Imprimir Resumo de Rescis„o Contratual', 0 )
      RETU
   ENDIF
   CTR := VEN := DES := salh := salm := var1 := 0

   MDS( 'Digite o n£mero do funcion rio' )
   @ 24, 40 GET CTR PICT '######'
   IF !READCUR()
      RETU .F.
   ENDIF


   IF !NETUSE( PES )
      RETU
   ENDIF
   IF !NETUSE( "FIRMA" )
      dbCloseAll()
      RETU
   ENDIF
   IF !NETUSE( "BCOFGTS" )
      dbCloseAll()
      RETU
   ENDIF
   IF !NETUSE( "FO_RSS" )
      dbCloseAll()
      RETU
   ENDIF
   IF !NETUSE( "CONTAS" )
      dbCloseAll()
      RETU
   ENDIF
   dbSelectAr( PES )
   dbGoTop()
   IF !dbSeek( CTR )
      MDT( 'Funcionario nao Encontrado' )
      dbCloseAll()
      RETU
   ENDIF
   MEF := Month( DEMITIDO )

   xCAUSA := OBTER( "FO_RCAU", "", MOTIVO, "NOME" )
   dbSelectAr( "FO_RSS" )
   xVAL1 := VALCTA( CTR, 109 )
   xVAL1 += VALCTA( CTR, 905 )
   IF xVAL1 > 0 .AND. MDG( "Experiencia Termino Contrato a Termo" )
      xCAUSA := 'Termino de Contrato a Termo '
   ENDIF
   MDS( "Confirme Motivo" )
   @ 24, 20 GET xCAUSA
   READCUR()


   IMPRESSORA()
   @ PRow() + 1, 0  SAY IMPSTR( cIMPEXP ) + REPLIC( '-', 80 )
   @ PRow() + 1, 20 SAY 'TERMO DE RESCISAO DO CONTRATO DE TRABALHO'
   @ PRow() + 2, 0  SAY REPLIC( '-', 80 )
   dbSelectAr( "FIRMA" )
   dbGoTop()
   IF dbSeek( NREMP )
      @ PRow() + 1, 0 SAY 'Identificacao do Empregador:'
      @ PRow() + 1, 0 SAY RAZAO
      @ PRow() + 1, 0 SAY ENDERECO + ' - ' + BAIRRO + ' - ' + CIDADE + ' - ' + ESTADO + ' - ' + IMPSTR( cIMPCOM ) + CEP + IMPSTR( cIMPEXP )
   ENDIF
   dbSelectAr( "BCOFGTS" )
   IF dbSeek( NREMP )
      @ PRow() + 1, 0 SAY 'BCO:' + NOME + ' AG:' + NOMEAGENC + ' UF ' + UF + ' COD:' + AGENCIA
   ENDIF
   dbSelectAr( PES )
   @ PRow() + 1, 0 SAY REPLIC( '-', 80 )
   @ PRow() + 1, 0 SAY 'Identificacao do Empregado:'
   @ PRow() + 1, 0 SAY 'Nome: ' + NOME + ' CTPS: ' + IF( Left( TIRAOUT( CPF ), 7 ) = PROFIS, CPF, PROFIS + "-" + SERIE + "/" + CTPSUF ) // CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
   @ PRow() + 1, 0 SAY 'Pis: ' + PIS + ' Num: ' + Str( numero ) + ' Nascimento: ' + DToC( nasc )
   @ PRow() + 1, 0 SAY 'Admissao: ' + DToC( admitido ) + ' FGTS: ' + DToC( FGTS ) + ' Aviso Previo: ' + DToC( avisoprev ) + ' Afastamento: ' + DToC( demitido )
   SALHM( MEF )
   @ PRow() + 1, 0 SAY 'Salario: '
   @ PRow(), 10   SAY VAR1                             PICT '###,###,###.##'
   @ PRow(), 25   SAY ' Causa de Afastamento: ' + xCAUSA
   @ PRow() + 1, 0 SAY REPLIC( '-', 80 )
   @ PRow() + 1, 0 SAY 'Descriminacao das Verbas Pagas'
   @ PRow() + 1, 0 SAY 'Conta Descriminacao'
   @ PRow(), 50   SAY 'Vencimentos'
   @ PRow(), 66   SAY 'Descontos'
   dbSelectAr( "FO_RSS" )
   FILTRA := 'NUMERO=CTR.AND.(CONTA<400.OR.CONTA>501)'
   SET FILTER TO &FILTRA
   dbGoTop()
   WHILE !Eof()
      CTA := CONTA
      dbSelectAr( "CONTAS" )
      dbGoTop()
      dbSeek( CTA )
      IF Found()
         IF PRRES = 0
            mCODIGO := CODIGO
            mDESCR  := DESCR
            dbSelectAr( "FO_RSS" )
            mVALOR := IF( CC = 1, VALORMES1, VALORMES2 )
            IF mVALOR > 0
               @ PRow() + 1, 1 SAY mCODIGO
               @ PRow(), 6   SAY mDESCR
               IF HORAS # 0
                  @ PRow(), 42 SAY HORAS PICT '###.##'
               ENDIF
               IF CONTA > 501 .OR. ( CONTA > 40 .AND. CONTA < 50 )
                  @ PRow(), 62 SAY mVALOR PICT '###,###,###.##'
                  DES += mVALOR
               ELSE
                  @ PRow(), 48 SAY mVALOR PICT '###,###,###.##'
                  VEN += mVALOR
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( "FO_RSS" )
      dbSkip()
   ENDDO

   @ PRow() + 1, 0 SAY 'Conta Descriminacao'
   @ PRow(), 66   SAY 'Informativas'



   dbSelectAr( "FO_RSS" )
   FILTRA := 'NUMERO=CTR'
   SET FILTER TO &FILTRA
   dbGoTop()
   WHILE !Eof()
      CTA := CONTA
      IF CONTA > 445 .AND. CONTA < 450
         dbSelectAr( "CONTAS" )
         dbGoTop()
         dbSeek( CTA )
         IF Found()
            IF PRRES = 0
               mCODIGO := CODIGO
               mDESCR  := DESCR
               dbSelectAr( "FO_RSS" )
               mVALOR := IF( CC = 1, VALORMES1, VALORMES2 )
               IF mVALOR > 0
                  @ PRow() + 1, 1 SAY mCODIGO
                  @ PRow(), 6   SAY mDESCR
                  IF HORAS # 0
                     @ PRow(), 42 SAY HORAS PICT '###.##'
                  ENDIF
                  @ PRow(), 62 SAY mVALOR PICT '###,###,###.##'
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      dbSelectAr( "FO_RSS" )
      dbSkip()
   ENDDO

   @ PRow() + 1, 0 SAY REPLIC( '-', 80 )
   @ PRow() + 1, 6 SAY 'Totais'
   @ PRow(), 48   SAY VEN                   PICT '###,###,###.##'
   @ PRow(), 62   SAY DES                   PICT '###,###,###.##'
   @ PRow() + 1, 6 SAY 'Liquido a Receber'
   @ PRow(), 48   SAY VEN - DES             PICT '###,###,###.##'
   @ PRow() + 1, 0 SAY REPLIC( '-', 80 )
   @ PRow() + 1, 0 SAY 'Data da Homologacao'
   @ PRow(), 40   SAY 'Empregador'
   @ PRow() + 1, 0 SAY REPLIC( '-', 80 )
   @ PRow() + 1, 0 SAY 'Empregado'
   @ PRow(), 40   SAY 'Responsavel'
   @ PRow() + 1, 0 SAY REPLIC( '-', 80 )
   IMPFOL()
   VIDEO()
   dbCloseAll()
   IMPEND()
   RETU

// : FIM: FORES_E9.PRG

// + EOF: fores_e9.prg
// +
