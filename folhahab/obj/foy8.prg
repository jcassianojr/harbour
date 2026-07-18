// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : foy8.prg
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
// :       FOY8.PRG: Atualizando Estruturas de Arquivos
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  jcassiano  S/C Ltda.
// :  Atualizado em: 04/25/94     12:27
// :
// :  Procs & Fncts: FOY8()
// :               : MUDADBF()
// :
// :          Chama: CLSCOR()           (fun‡„o    em ?)
// :               : CABEX()            (fun‡„o    em FOLPROC.PRG)
// :               : MUDADBF()          (fun‡„o    em FOY8.PRG)
// :               : RFILORD()          (fun‡„o    em FOLPROC.PRG)
// :
// :     Arq. Dados: FIRMA
// :
// :         Indice: FIRNR      N£mero de Cadastramento
// :                            NRCLIEN
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************


// //#INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function foy8()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION foy8

   PARA cSISTEMA

   IF ValType( cSISTEMA ) # "C"
      cSISTEMA := "FOLHA"
   ENDIF

   SCR_FOY8 := SaveScreen( 00, 00, 03, 79 )
   CLSCOR()
   CABEX( "Atualizando Estruturas de Arquivos" )
// Guarda o Diretorio principal
   PATWORK := hb_cwd()
   IF cSISTEMA = "SETOR" .OR. MDG( "Deseja alterar estrutura do Diretorio Principal" )
      CLSCOR()
      MDT( 'Atualizando dbf no diretorio principal' )
      MUDADBF()
   ENDIF
   IF cSISTEMA = "SETOR"
      RETU
   ENDIF
   aNUMEMP := {}
   aCOGEMP := {}
   FILTRO  := ""
   aRETU   := RFILORD( "FIRMA", .F. )
   INX     := aRETU[ 1 ]
   FILTRO  := aRETU[ 2 ]

   IF !NETUSE( "FIRMA" )
      RETU .F.
   ENDIF
   SET FILTER TO &FILTRO
   dbGoTop()
   WHILE !Eof()
      IF cSISTEMA <> "FISCAL"
         AAdd( aNUMEMP, NRCLIEN )
      ELSE
         AAdd( aNUMEMP, NUMERO )
      ENDIF
      AAdd( aCOGEMP, COGNOME )
      dbSkip()
   ENDDO
   dbCloseAll()

   pNUMEMP := Len( aNUMEMP )
   FOR W := 1 TO pNUMEMP
      MDT( 'Atualizando dbf no diretorio da empresa : ' + aCOGEMP[ W ] )
      CLSCOR()
      // Mudar para diretorio da empresa
      // DIRCHANGE(PATWORK+'\EMP'+ANOWORK+STRZERO(aNUMEMP[W],3))
      hb_cwd( PATWORK + '\EMP' + ANOWORK + StrZero( aNUMEMP[ W ], 3 ) )
      MUDADBF()
   NEXT X
// Voltar diretorio Principal
// DIRCHANGE(PATWORK)
   hb_cwd( PATWORK )

// CRIAR DBF NAO EXISTENTES
   RestScreen( 00, 00, 03, 79, SCR_FOY8 )
   RETU

// !*****************************************************************************
// !
// !         Fun‡„o: MUDADBF()
// !
// !    Chamado por: FOY8.PRG
// !
// !               : CLSCOR()           (fun‡„o    em ?)
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MUDADBF()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MUDADBF

   MATDBF := FILENAMES( "*.DBF" )
   nARQ   := Len( MATDBF )
   IF nARQ > 0
      FOR X := 1 TO nARQ
         cARQDIC := PATWORK + "\" + TIRAEXT( MATDBF[ X ], 'DBE' )
         IF File( cARQDIC )
            MDT( "Atualizando arquivo " + MATDBF[ X ] )
            CLSCOR()
            MAKEDBF( cARQDIC )
         ENDIF
      NEXT X
   ENDIF
   RETU .T.


// + EOF: foy8.prg
// +
