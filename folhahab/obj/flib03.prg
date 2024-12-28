// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : flib03.prg
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

// !*****************************************************************************
// !
// !         Fun‡„o: ZERAVARS()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ZERAVARS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ZERAVARS( ARQWORK )

   IF !NETUSE( ARQWORK )
      RETU .F.
   ENDIF
   CLRVARS()   // FUNCAO DA DEVELOP.LIB ZERA AS VARIAVEIS
   dbCloseArea()
   RETU .T.


// !*****************************************************************************
// !
// !         Fun‡„o: CRIARVARS()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function CRIARVARS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC CRIARVARS( ARQWORK )   // ABRE UM ARQUIVO E INICIA VARIAVEIS

   IF !NETUSE( ARQWORK )
      RETU .F.
   ENDIF
   INITVARS()  // FUNCAO DA DEVELOP.LIB INICIA VARIAVEIS
   CLRVARS()   // FUNCAO DA DEVELOP.LIB ZERA AS VARIAVEIS
   dbCloseArea()
   RETU .T.


// !*****************************************************************************
// !
// !         Fun‡„o: LIMPAVARS()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function LIMPAVARS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC LIMPAVARS( ARQWORK )   // ABRE UM ARQUIVO E INICIA VARIAVEIS

   IF !NETUSE( ARQWORK )
      RETU .F.
   ENDIF
   FREEVARS()
   dbCloseArea()
   RETU .T.

// !*****************************************************************************
// !
// !         Fun‡„o: REPORVARS()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function REPORVARS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC REPORVARS  // ABRE UM ARQUIVO E DA GRAVA MVARS

   PARA ARQWORK, INXWORK, BUSWORK  // PARA ARQUIVO,INDICE,CHAVE DE BUSCA

   IF !netuse( arqwork )   // AREDE(ARQWORK,INXWORK,1)
      RETU
   ENDIF
   dbGoTop()
   IF dbSeek( BUSWORK )
      netreclock()
      REPLVARS()
      dbUnlock()
   ENDIF
   dbCommit()
   dbCloseArea()
   RETU .T.

// !*****************************************************************************
// !
// !         Fun‡„o: IGUALVARS()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function IGUALVARS()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC IGUALVARS  // ABRE UM ARQUIVO E IGUAL mVARS

   PARA ARQWORK, INXWORK, BUSWORK, cMES1, cMES2  // PARA ARQUIVO,INDICE,CHAVE DE BUSCA

   RETORNO := .F.
   IF !netuse( arqwork )   // AREDE(ARQWORK,INXWORK,1)
      RETU
   ENDIF
   dbGoTop()
   IF dbSeek( BUSWORK )
      EQUVARS()
      RETORNO := .T.
   ENDIF
   dbCloseArea()
   IF PCount() = 4 .AND. RETORNO
      MDT( cMES1 )
   ENDIF
   IF PCount() = 5 .AND. !RETORNO
      MDT( cMES2 )
   ENDIF
   RETU RETORNO



// !*****************************************************************************
// !
// !         Fun‡„o: APAGAREG()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function APAGAREG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC APAGAREG   // ABRE UM ARQUIVO E MARCA DELECAO

   PARA ARQWORK, INXWORK, BUSWORK  // PARA ARQUIVO,INDICE,CHAVE DE BUSCA

   IF !MDG( 'Vocˆ Deseja Realmente Apagar' )
      RETU .F.
   ENDIF
   IF !netuse( arqwork )
      RETU
   ENDIF
   dbGoTop()
   IF dbSeek( BUSWORK )
      netrecdel()
      PCK := .T.
   ENDIF
   dbCommit()
   dbCloseArea()
   RETU .T.



// !*****************************************************************************
// !
// !         Fun‡„o: NOVOREG()
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function NOVOREG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC NOVOREG( ARQWORK, INDWORK, BUSWORK, FIEWORK, VARWORK )   // &&ARQUIVO,CHAVE

   RETORNO := .F.
   IF !NETUSE( ARQWORK )
      RETU .F.
   ENDIF
   dbGoTop()
   IF !dbSeek( BUSWORK )
      IF NETRECAPP()
         IF PCount() > 3
            FIELD->&FIEWORK. := &VARWORK.
         ELSE
            REPLVARS()
         ENDIF
         RETORNO := .T.
      ENDIF
   ENDIF
   netrecunlcom()
   dbCloseArea()
   IF !RETORNO
      MDT( "Registro j  cadastrado com esta chave" )
   ENDIF
   RETU RETORNO




// + EOF: flib03.prg
// +
