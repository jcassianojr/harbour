////#INCLUDE "COMANDO.CH"
#include "adordd.ch"
#include "try.ch"


para nTIPO
LOCAL oRs, oErr
local cConnStr

CABE2( 'FOPTO_15 - Importar Catraca Portaria/Refeitorio ' )

set century on

DCORTE := zdataini
DCORTF := zdatafim
cTIPOCRE  :="N"
MDS( 'Periodo e Tipo (C)redencial (N)umero' )
@ 24, 40 get DCORTE
@ 24, 50 get DCORTF
@ 24, 60 get cTIPOCRE VALID cTIPOCRE $ "CN"
if !READCUR()
   retu .F.
endif


//   nFUNINI:=334
//   nFUNFIM:=334
IF nTIPO=1 //Acesso portaria
   nEQUIP :=nEQUIP:=pegequip("ATIVO<>'N' .AND. TIPO='A'")
   cPUSO := "PP" + ANOMESW
   CHECKCRI( cPUSO, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
ENDIF
IF nTIPO=2  //Refeitorio
   nEQUIP :=nEQUIP:=pegequip("ATIVO<>'N' .AND. TIPO='R'")
   cPUSO := "PA" + ANOMESW
   CHECKCRI( cPUSO, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
ENDIF


IF ! NETUSE(cPUSO)
   RETU .T.
ENDIF


cCONNSTR:=ProfileString( "FOLHA.INI", "MPOINT", "CONECCAO", "" )
oCon := WIN_OLECreateObject("ADODB.Connection")
oCon:ConnectionString := cConnStr


IF cTIPOCRE="C"
  Csql:="SELECT convert(VARCHAR(8),CRED_NUMERO) AS NUMERO,"
ELSE
  Csql:="SELECT convert(VARCHAR(8),PES_NUMERO) AS NUMERO,"
ENDIF  
csql+="       convert(varchar,MOV_DATAHORA,103) AS DATA,"
csql+="       convert(varchar,mov_datahora,108) AS hora,"
csql+="       convert(VARCHAR(4),EQPI_NUMERO) AS RELOGIO,"
csql+="       mov_entradasaida "
csql+=" FROM Log_Credencial"
csql+=" WHERE MOV_DataHora>=convert(datetime, '"+dtoc(DCORTE)+"', 103)"
csql+="   AND MOV_DataHora<=convert(datetime, '"+dtoc(DCORTF+1)+"', 103)"
cSQL+=" AND EQPI_NUMERO="+str(nEQUIP)

    @ 24,00 SAY "Connectando:"+cConnStr

    TRY
        oCon:Open()
    CATCH oErr
        ShowAdoError(oERR,oCon)
        dbcloseall()
        RETURN NIL
    END TRY



    @ 05,02 say "Numero   :"
    @ 06,02 say "Data/hora:"
    @ 07,02 say "Relogio  :"

    @ 24,00 SAY "Carregando Registros:"
    oRs := WIN_OLECreateObject('ADODB.RecordSet')
    oRs:CursorLocation := 3
    TRY
      oRs:Open(cSQL, oCon, 1, 3)
    CATCH oERR
      ShowAdoError(oERR,oCon,cSQL)      
      dbcloseall()
      RETURN NIL
    END

    while ! ors:eof
       nNUMERO :=Val(ors:fields("NUMERO"):value)	
       dDATA   :=CToD(ors:fields("data"):value)
       nHORA   :=CTOHORA(ors:fields("hora"):value)
       cRELOGIO:=ors:fields("relogio"):value

       @ 05,15 SAY nNUMERO
       @ 06,15 SAY dtoc(dDATA)+":"+STR(NHORA,5,2)
       @ 07,15 SAY cRELOGIO
       
       cTIPOM:=ors:fields("mov_entradasaida"):value 
       DO CASE
           CASE cTIPOM=1
                cTIPOM:="E"
           CASE cTIPOM=2
                cTIPOM:="S"
           CASE cTIPOM=3
                cTIPOM:="A"
      ENDCASE


       dbselectar(cPUSO)
       dbgotop()
       IF ! DBSEEK(Str(nNUMERO,8)+DToS(dDATA)+Str(nHORA,5,2))
          netrecapp()
          field->NUMERO:=nNUMERO
          field->DATA:=dDATA
          field->HORA:=nHORA
          field->relogio:=cRELOGIO
          field->tipom:=cTIPOM
       endif
       ors:movenext()
    enddo


    oRs:Close()
    oCon:close()
    dbcloseall()
    trocapro(cPUSO,dcorte,dcortf)

    RETURN NIL



FUNCTION ShowAdoError(oERR,oCon,cMESSAGE)
LOCAL   nAdoErrors   := 0
LOCAL   oAdoErr
LOCAL   cERRO

      nAdoErrors   :=  oCon:Errors:Count()
      IF nAdoErrors > 0
         oAdoErr      := oCon:Errors(nAdoErrors-1)
         cERRO:= oAdoErr:Description + HB_OsNewLine() + oAdoErr:Source 
         cERRO+= oCon:ConnectionString   + HB_OsNewLine()
         cERRO+= HB_VALTOEXP(oCon:Provider)   + HB_OsNewLine()
         cERRO+= HB_VALTOEXP(oCon:State)   + HB_OsNewLine()
      ELSE
         cERRO:= 'Outros Erros'
      ENDIF
      IF VALTYPE(cMESSAGE)="C"
         cERRO+=HB_OsNewLine()+ cMESSAGE
         hb_memowrit("showadoercmd"+ArqLogDataHora("log"),cMESSAGE)      
      ENDIF
      cERRO+=HB_OsNewLine()+oErr:Operation + " " + oErr:Description
      hb_memowrit("showadoerror"+ArqLogDataHora("log"),cERRO)
      ALERTX(cERRO)
RETURN nil


