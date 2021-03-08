*!*****************************************************************************
*!
*!         Fun‡„o: ZERAVARS()
*!
*!*****************************************************************************
FUNCTION ZERAVARS(ARQWORK)       
IF ! NETUSE(ARQWORK) 
   RETU .F.
ENDIF
CLRVARS()                        &&FUNCAO DA DEVELOP.LIB ZERA AS VARIAVEIS
DBCLOSEAREA()
RETU .T.


*!*****************************************************************************
*!
*!         Fun‡„o: CRIARVARS()
*!
*!*****************************************************************************
FUNC CRIARVARS(ARQWORK)                    &&ABRE UM ARQUIVO E INICIA VARIAVEIS
IF ! NETUSE(ARQWORK) 
   RETU .F.
ENDIF
INITVARS()                       &&FUNCAO DA DEVELOP.LIB INICIA VARIAVEIS
CLRVARS()                        &&FUNCAO DA DEVELOP.LIB ZERA AS VARIAVEIS
DBCLOSEAREA()
RETU .T.


*!*****************************************************************************
*!
*!         Fun‡„o: LIMPAVARS()
*!
*!*****************************************************************************
FUNC LIMPAVARS(ARQWORK)                    &&ABRE UM ARQUIVO E INICIA VARIAVEIS
IF ! NETUSE(ARQWORK) 
   RETU .F.
ENDIF
FREEVARS()
DBCLOSEAREA()
RETU .T.

*!*****************************************************************************
*!
*!         Fun‡„o: REPORVARS()
*!
*!*****************************************************************************
FUNC REPORVARS                              &&ABRE UM ARQUIVO E DA GRAVA MVARS
PARA ARQWORK,INXWORK,BUSWORK             &&PARA ARQUIVO,INDICE,CHAVE DE BUSCA
IF ! netuse(arqwork) //AREDE(ARQWORK,INXWORK,1)
   RETU
ENDIF
DBGOTOP()
IF DBSEEK(BUSWORK)
   netreclock()
   REPLVARS()
   dbunlock()
ENDIF
DBCOMMIT()
DBCLOSEAREA()
RETU .T.

*!*****************************************************************************
*!
*!         Fun‡„o: IGUALVARS()
*!
*!*****************************************************************************
FUNC IGUALVARS                              &&ABRE UM ARQUIVO E IGUAL mVARS
PARA ARQWORK,INXWORK,BUSWORK,cMES1,cMES2   &&PARA ARQUIVO,INDICE,CHAVE DE BUSCA
RETORNO=.F.
IF ! netuse(arqwork) //AREDE(ARQWORK,INXWORK,1)
   RETU
ENDIF
DBGOTOP()
IF DBSEEK(BUSWORK)
   EQUVARS()
   RETORNO=.T.
ENDIF
DBCLOSEAREA()
IF PCOUNT()=4.AND.RETORNO
   MDT(cMES1)
ENDIF
IF PCOUNT()=5.AND.! RETORNO
   MDT(cMES2)
ENDIF
RETU RETORNO



*!*****************************************************************************
*!
*!         Fun‡„o: APAGAREG()
*!
*!*****************************************************************************
FUNC APAGAREG                          &&ABRE UM ARQUIVO E MARCA DELECAO
PARA ARQWORK,INXWORK,BUSWORK            &&PARA ARQUIVO,INDICE,CHAVE DE BUSCA
IF ! MDG('Vocˆ Deseja Realmente Apagar')
   RETU .F.
ENDIF
IF ! netuse(arqwork) 
   RETU
ENDIF
DBGOTOP()
IF DBSEEK(BUSWORK)
   netrecdel()
   PCK=.T.
ENDIF
DBCOMMIT()
DBCLOSEAREA()
RETU .T.



*!*****************************************************************************
*!
*!         Fun‡„o: NOVOREG()
*!
*!*****************************************************************************
FUNC NOVOREG(ARQWORK,INDWORK,BUSWORK,FIEWORK,VARWORK)  //  &&ARQUIVO,CHAVE
RETORNO:=.F.
IF ! NETUSE(ARQWORK) 
   RETU .F.
ENDIF
DBGOTOP()
IF ! DBSEEK(BUSWORK)
   IF NETRECAPP()
      IF PCOUNT()>3
         FIELD->&FIEWORK.:=&VARWORK.
      ELSE
         REPLVARS()
      ENDIF
      RETORNO:=.T.
   ENDIF
ENDIF
netrecunlcom()
DBCLOSEAREA()
IF ! RETORNO
   MDT("Registro j  cadastrado com esta chave")
ENDIF
RETU RETORNO



