*!*****************************************************************************
*!
*!         Fun‡„o: ULTIMOREG() ABRE ARQUIVO PEGA ULTIMO REGISTRO CAMPO
*!
*!   Parametros  : PARAMETRO ARQUIVO,CAMPO,lSOMA
*!       
*!*****************************************************************************
FUNCtion ULTIMOREG(ARQWORK,FIEWORK,lSOMA)
if valtype( lSOMA ) # "L"
   lSOMA := .F.
endif
IF ! NETUSE(ARQWORK) 
   RETU 
ENDIF
DBGOBOTTOM()
RETORNO=&FIEWORK.
DBCLOSEALL()
IF lSOMA.AND.VALTYPE(RETORNO)="N"
   RETORNO++
ENDIF
RETU RETORNO



//{|| PEGCHAVE("m",ULTIMOREG(cARQ,cCAMPO,.T.),":")}
