// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fores_ex.prg
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
// :   FORES_EX.PRG: Dados B sicos para Formul rios de F‚rias
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/08/94     13:11
// :
// :*****************************************************************************

// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function fores_ex()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION fores_ex

   PARA OPX

   DO CASE
   CASE OPX = 1
      TITULO := 'Imprimir Aviso de Ferias'
   CASE OPX = 2
      TITULO := 'Imprimir Solicitacao de Abono'
   CASE OPX = 3
      TITULO := 'Imprimir Recibo de Ferias'
   CASE OPX = 4
      TITULO := 'Imprimir Recibo de Abono de Ferias'
   CASE OPX = 5
      TITULO := 'Imprimir Recibo de Complemento de Ferias'
   CASE OPX = 6
      TITULO := 'Imprimir Recibo de Complemento de Abono'
   ENDCASE
   IF !MDL( TITULO, 0 )
      RETU
   ENDIF
   MDS( 'Carregando dados da Empresa' )
   IF !NETUSE( "FIRMA" )
      RETU
   ENDIF
   dbGoTop()
   IF dbSeek( NREMP )
      ENDER1 := ENDERECO
      BAI1   := BAIRRO
      CID1   := CIDADE
      EST1   := ESTADO
   ELSE
      ENDER1 := BAI1 := CID1 := EST1 := ''
   ENDIF
   dbCloseArea()

   CTR     := 0
   COP     := 1
   DADATAX := Date()

   MDS( 'Quantas C¢pias' )
   @ 24, 30 GET COP PICT '####'
   IF !READCUR()
      RETU .F.
   ENDIF


   MDS( 'Digite o n£mero do Funcion rio' )
   @ 24, 40 GET CTR PICT '######'
   IF !READCUR()
      RETU .F.
   ENDIF

   MDS( 'Digite o P‚riodo Aquisitivo' )
   @ 24, 40 GET DADATAX
   IF !READCUR()
      RETU .F.
   ENDIF

   IF MDG( "Imprimir Quatro Digitos para o Ano" )
      SET CENTURY ON
   ENDIF


   IF !NETUSE( PES )   // AREDE(PES,PES,1)
      RETU
   ENDIF
   dbGoTop()
   IF !dbSeek( CTR )
      MDT( 'Funcionario ao encontrado' )
      dbCloseAll()
      RETU
   ENDIF
   PETELA( 8 )


   CTRA := ( ( ( ( ( CTR * 10000 ) + Year( DADATAX ) ) * 100 ) + Month( DADATAX ) ) * 100 ) + Day( DADATAX )
   IF !NETUSE( "FO_FER" )  // AREDE("FO_FER","FO_FER",1)
      RETU
   ENDIF
   dbGoTop()
   IF !dbSeek( CTRA )
      MDT( 'Per¡odo Aquisitivo n„o encontrado' )
      dbCloseAll()
      RETU
   ENDIF
   FORESRT()
   FORESRS()

   DO CASE
   CASE OPX < 5
      MEF := Month( GOZOU1DE )
   CASE OPX = 5
      MEF := Month( COMPDATAI )
   CASE OPX = 6
      MEF := Month( COMPABOI )
   ENDCASE
   IF OPX = 1
      FORES_EA()
      dbCloseAll()
      RETU
   ENDIF
   IF OPX = 2
      FORES_EB()
      dbCloseAll()
      RETU
   ENDIF

   IF !NETUSE( "FO_PFE" )  // AREDE("FO_PFE","FO_PFE",1)
      RETU
   ENDIF
   FILTRA := 'NUMERO=CTR'
   SET FILTER TO &FILTRA

   IF !NETUSE( "CONTAS" )  // AREDE("CONTAS","CONTAS",1)
      RETU
   ENDIF
   IF OPX = 3
      FILTRO := 'PRFER=0'
      SET FILTER TO &FILTRO
   ENDIF
   IF OPX = 5
      FILTRO := 'PRFCO=0'
      SET FILTER TO &FILTRO
   ENDIF
   dbSelectAr( "FO_FER" )
   DO CASE
   CASE OPX = 3 .OR. OPX = 5
      FORES_EC()
   CASE OPX = 4
      FORES_ED( 0 )
   CASE OPX = 6
      FORES_ED( 1 )
   ENDCASE
   dbCloseAll()
   RETU

// : FIM: FORES_EX.PRG

// + EOF: fores_ex.prg
// +
