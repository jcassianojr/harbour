// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_d1.prg
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
// :   FORES_D1.PRG: Transfere Dados
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/08/94     13:05
// :
// :  Procs & Fncts: FORES_D1()
// :
// :          Chama: CABE2()            (fun‡„o    em FORESP.PRG)
// :               : GRAVA2()           (fun‡„o    em FORESP.PRG)
// :
// :     Arq. Dados: CONTAS -  Cadastro de Vencimentos e Descontos
// :               : FO_PFE -  Folha de Ferias
// :               : FO_RSS -  FOLHA DE RESCISAO
// :
// :         Indice: CONTA      Por ordem de c¢digo
// :                            CODIGO
// :               : RSS        CODIGO DE TRABALHO
// :                            CONTROLE
// :
// :     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
// :*****************************************************************************



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fores_d1()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fores_d1

   PARA CC

   CABE2( 'Tranferencia de dados' )
   IF !MDG( 'Vocˆ quer realmente transferir' )
      RETU
   ENDIF
   XA := XB := XC := XD := XE := XF := 1

   IF CC = 0 .OR. CC = 1
      IF !NETUSE( "FO_PFE" )   // AREDE("FO_PFE","FO_PFE",0)
         RETU
      ENDIF
   ENDIF
   IF CC = 2 .OR. CC = 3
      IF !NETUSE( "FO_RSS" )   // AREDE("FO_RSS","FO_RSS",0)
         RETU
      ENDIF
   ENDIF
   cSELE1 := Alias()

   IF !NETUSE( FOL )   // AREDE(FOL,FOL,0)
      RETU
   ENDIF

   IF !NETUSE( "CONTAS" )  // AREDE("CONTAS","CONTAS",0)
      RETU
   ENDIF
   dbSelectAr( cSELE1 )
   FILTRO := ''
   FI     := Trim( FILTRO )
   FILTRO := FILTRO( FI )
   SET FILTER TO &FILTRO
   MDS( 'Transferindo dados Aguarde...' )

   dbSelectAr( cSELE1 )
   dbGoTop()
   WHILE !Eof()
      CTR  := NUMERO
      CTRC := CONTA
      CTRH := HORAS
      VALE := VALOR
      IF CC = 0
         IF MES = MES1
            VALE := VALORMES1
         ENDIF
         IF MES = MES2 .AND. MES1 # MES2   // Se os meses forem o mesmo referencia 1o.
            VALE := VALORMES2
         ENDIF
         IF MES # MES1 .AND. MES # MES2
            VALE := 0
         ENDIF
      ENDIF
      IF CC = 1
         VALE := IF( MES = MES1, VALOR, 0 )
      ENDIF
      IF CC = 2
         VALE := IF( MES = MES1, VALORMES1, 0 )
      ENDIF
      IF CC = 3
         VALE := IF( MES = MES2, VALORMES2, 0 )
      ENDIF
      TRANSFER := .F.
      dbSelectAr( "CONTAS" )
      dbGoTop()
      IF dbSeek( CTRC )
         IF CC = 0 .AND. TRFER = 0
            TRANSFER := .T.
         ENDIF
         IF CC = 1 .AND. TRFCO = 0
            TRANSFER := .T.
         ENDIF
         IF CC = 2 .AND. TRRES = 0
            TRANSFER := .T.
         ENDIF
         IF CC = 3 .AND. TRRES = 0
            TRANSFER := .T.
         ENDIF
      ENDIF
      IF TRANSFER .AND. VALE # 0
         dbSelectAr( FOL )
         GRAVA2( CTRC, VALE )
         &FOL.->HORAS := CTRH
      ENDIF
      dbSelectAr( cSELE1 )
      dbSkip()
   ENDDO
   dbCloseAll()
   RETU
// : FIM: FORES_D1.PRG

// + EOF: fores_d1.prg
// +
