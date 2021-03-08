FUNCTION ShowAdoError(oERR,oCon,cMESSAGE,lMES)
LOCAL   nAdoErrors   := 0
LOCAL   oAdoErr
LOCAL   cERRO
IF VALTYPE(lMES)<>"L"
   lMES:=.T.
ENDIF

      cERRO:=NNETWHOAMI() + HB_OsNewLine()
      nAdoErrors   :=  oCon:Errors:Count()
      IF nAdoErrors > 0
         oAdoErr      := oCon:Errors(nAdoErrors-1)
         cERRO+= oAdoErr:Description + HB_OsNewLine() + oAdoErr:Source 
         cERRO+= oCon:ConnectionString   + HB_OsNewLine()
         cERRO+= HB_VALTOEXP(oCon:Provider)   + HB_OsNewLine()
         cERRO+= HB_VALTOEXP(oCon:State)   + HB_OsNewLine()
      ELSE
         cERRO+= 'Outros Erros' + HB_OsNewLine()
      ENDIF
      IF VALTYPE(cMESSAGE)="C"
         cERRO+=HB_OsNewLine()+ cMESSAGE
         hb_memowrit("showadoercmd"+ArqLogDataHora("log"),cMESSAGE)      
      ENDIF
      cERRO+=HB_OsNewLine()+oErr:Operation + " " + oErr:Description
      hb_memowrit("showadoerror"+ArqLogDataHora("log"),cERRO)
      IF lMES
         ALERTX(cERRO)
      ENDIF   
RETURN nil


