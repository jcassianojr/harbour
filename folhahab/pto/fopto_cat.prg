*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_cat.prg Sincronizar Catraca
*+
*+
*+
*+     Sistema: FOLHA DE PAGAMENTO - MODULO PONTO
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 27-Dez-2024 as  9:33 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

#include "adordd.ch"
#include "try.ch"


function fopto_cat()
PARA cMASCARA,cMASCDEM


CABE2('FOPTO_cat -  Sincronizar Catraca ')

nUSO := FCREATE("catraca.sql")

cCONN := ProfileString("FOLHA.INI","MPOINT","SQL","")   //sqlserver

//cConn:="Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=DMPACESSO_V100;Data Source=TI_EUDORA\SQLEXPRESS"
//Provider=SQLNCLI.1;Password=senha;Persist Security Info=True;User ID=sa;Initial Catalog=DMPAcesso_V100;Data Source=dimeptarif\SQLEXPRESS

if !netuse(pes)
   retu
endif

if !netuse("FUNCAO")
   dbcloseall()
   retu
endif

try
oConn := WIN_OLECreateObject("ADODB.Connection")
with object oConn
:ConnectionString := cConn
:Open()
END   //end do with
catch oErr
ShowAdoError(oERR,oCoNn)
dbcloseall()
return
end


oRSDES                := WIN_OLECreateObject('ADODB.RecordSet')
oRSDES:CursorLocation := 3

oComm := WIN_OLECreateObject("ADODB.Command")

set century on
dbselectar("fo_pes")
DBGOTOP()
while !eof()
   nNUMERO := NUMERO
   IF nNUMERO > 0 .AND. VALTYPE(cMASCARA) = 'C'
      nNUMERO := &cMASCARA.
   ENDIF
   @ 24,00 SAY nNUMERO         
   if nnumero > 0
      petela(8)
      cRG       := ALLTRIM(RG)
      cCPF      := TiraOut(CPF)
      cPIS      := PIS
      cNOME     := alltrim(NOME)
      cFUNCAO   := ALLTRIM(OBTER("FUNCAO",,FUNCAO,"NOME"))
      mFUNCAO   := FUNCAO
      cCCUSTO   := CCUSTO
      cADMDEM   := IF(!EMPTY(ADMITIDO),DTOC(ADMITIDO),"")+" a "+IF(!EMPTY(DEMITIDO),DTOC(DEMITIDO),"")
      xNUMERO   := ALLTRIM(STR(nNUMERO))
      dADMITIDO := ADMITIDO
      dDEMITIDO := DEMITIDO

      cCOMANDO := "SELECT * FROM Pessoas WHERE PES_NUMERO="+xNUMERO

      TRY
      oRSDES:Open(cCOMANDO,oConN,adOpenDynamic,adLockOptimistic)
      CATCH oERR
      ShowADOError(oERR,oConn,cCOMANDO)
   END


   If oRSDES:EOF
      cCOMANDO := "INSERT INTO dbo.PESSOAS (pes_numero, pes_nome, pes_cpf, pes_foto, pessit_numero, est_numero, pes_RG, PES_Master, PES_FlagReentrada, PES_CampoPerso1, PES_CampoPerso2)"
      cCOMANDO += " VALUES ("+STR(nNUMERO)+", '"+cNOME+"', '"+cCPF+"', '"+STRZERO(nNUMERO,8)+".JPG',8, 9999999999, '"+cRG+"', 0, 1, '"+cFUNCAO+"', '"+ALLTRIM(STR(cCCUSTO))+"') ; "

      fwrite(nUSO,cCOMANDO+HB_OSNEWLINE())

      //         oComm:=WIN_OLECreateObject( "ADODB.Command" )
      with object oComm
      :CommandText      := cCOMANDO
      :CommandType      := adCmdText
      :ActiveConnection := oConn
      :Execute()
   end


   /*
         oRSDES:AddNew()
         oRSDES:fields("pes_numero"):value:=nNUMERO
         oRSDES:fields("pes_nome"):value:=cNOME
         oRSDES:fields("pes_cpf"):value:=cCPF
         oRSDES:fields("pes_foto"):value:=StrZero(nNUMERO, 8) + ".JPG"
         oRSDES:fields("pessit_numero"):value:=8 //liberado
         oRSDES:fields("est_numero"):value:=8 //
         oRSDES:fields("pes_RG"):value:=CRG
         oRSDES:fields("PES_Master"):value:=0
         oRSDES:fields("PES_FlagReentrada"):value:=0
         oRSDES:fields("PES_CampoPerso1"):value:=cFUNCAO
         oRSDES:fields("PES_CampoPerso2"):value:= cCCUSTO
         oRSDES:Update()
         */
else
   cCOMANDO := ''
   if empty(fixstr(oRSDES:fields("pes_email") :value)) .AND. !EMPTY(EMAIL)
      cCOMANDO += "UPDATE dbo.PESSOAS SET pes_email = '"+alltrim(email)+"' WHERE PES_NUMERO = "+STR(nNUMERO)+" AND (PES_EMAIL='' OR PES_EMAIL IS null) ;"
      cCOMANDO += HB_OSNEWLINE()
   endif

   if empty(fixstr(oRSDES:fields("PES_CampoPerso1") :value)) .AND. !EMPTY(CFUNCAO)
      cCOMANDO += "UPDATE dbo.PESSOAS SET PES_CampoPerso1 = '"+CFUNCAO+"' WHERE PES_NUMERO = "+STR(nNUMERO)+" AND (PES_CampoPerso1='' OR PES_CampoPerso1 IS null) ;"
      cCOMANDO += HB_OSNEWLINE()
   endif

   if empty(fixstr(oRSDES:fields("PES_CampoPerso2") :value)) .AND. !EMPTY(cCCUSTO)
      cCOMANDO += "UPDATE dbo.PESSOAS SET PES_CampoPerso2 = '"+ALLTRIM(STR(cCCUSTO))+"' WHERE PES_NUMERO = "+STR(nNUMERO)+" AND (PES_CampoPerso2='' OR PES_CampoPerso2 IS null) ;"
      cCOMANDO += HB_OSNEWLINE()
   endif


   //sera gravado nos campos data inicial e final
   //if empty(fixstr(oRSDES:fields("PES_CampoPerso3"):value)) .AND. ! EMPTY(cADMDEM)
   //  cCOMANDO+="UPDATE dbo.PESSOAS SET PES_CampoPerso3 = '"+ALLTRIM(cADMDEM)+"' WHERE PES_NUMERO = "+STR(nNUMERO)+" AND (PES_CampoPerso3='' OR PES_CampoPerso3 IS null) ;"
   //	cCOMANDO+=HB_OSNEWLINE()
   //endif


   //fazer demitido diferenciado pois os filtros podem ter demitido
   //if empty(fixstr(oRSDES:fields("PES_CampoPerso3"):value)) .AND. ! EMPTY(cADMDEM)
   //  cCOMANDO+="UPDATE dbo.PESSOAS SET PES_CampoPerso3 = '"+ALLTRIM(cADMDEM)+"' WHERE PES_NUMERO = "+STR(nNUMERO)+" AND (PES_CampoPerso3='' OR PES_CampoPerso3 IS null) ;"
   //	cCOMANDO+=HB_OSNEWLINE()
   //endif


   if empty(fixstr(oRSDES:fields("pes_cpf") :value)) .AND. !EMPTY(ccpf)
      cCOMANDO += "UPDATE dbo.PESSOAS SET pes_cpf = '"+ccpf+"' WHERE PES_NUMERO = "+STR(nNUMERO)+" AND (PES_cpf='' OR PES_cpf IS null) ;"
      cCOMANDO += HB_OSNEWLINE()
   endif

   if empty(fixstr(oRSDES:fields("pes_pis") :value)) .AND. !EMPTY(cpis)
      cCOMANDO += "UPDATE dbo.PESSOAS SET pes_pis = "+cpis+" WHERE PES_NUMERO = "+STR(nNUMERO)+" AND (PES_pis='' OR PES_pis IS null) ;"
      cCOMANDO += HB_OSNEWLINE()
   endif

   cRGBANCO := fixstr(oRSDES:fields("pes_rg") :value)
   if EMPTY(cRGBANCO) .AND. !EMPTY(crg)
      cCOMANDO += "UPDATE dbo.PESSOAS SET pes_rg = '"+crg+"' WHERE PES_NUMERO = "+STR(nNUMERO)+" AND (PES_rg='' OR PES_rg IS null) ;"
      cCOMANDO += HB_OSNEWLINE()
   endif

   if AT('-',cRGBANCO) = 0 .AND. !EMPTY(crg)
      cCOMANDO += "UPDATE dbo.PESSOAS SET pes_rg = '"+crg+"' WHERE PES_NUMERO = "+STR(nNUMERO)+" ;"
      cCOMANDO += HB_OSNEWLINE()
   endif

   if AT('.',cRGBANCO) = 0 .AND. !EMPTY(crg)
      cCOMANDO += "UPDATE dbo.PESSOAS SET pes_rg = '"+crg+"' WHERE PES_NUMERO = "+STR(nNUMERO)+" ;"
      cCOMANDO += HB_OSNEWLINE()
   endif

   //IF 0001.JPG
   //'"+STRZERO(nNUMERO,8)+".JPG'
   cFOTO := alltrim(fixstr(oRSDES:fields("pes_foto") :value))
   if SUBSTR(cFOTO,5,1) = "." .or. cFOTO = 'Nao_Disponivel.jpg' .OR. EMPTY(cFOTO)
      cCOMANDO += "UPDATE dbo.PESSOAS SET pes_foto = '"+STRZERO(nNUMERO,8)+".JPG'  WHERE PES_NUMERO = "+STR(nNUMERO)+" ;"
      cCOMANDO += HB_OSNEWLINE()
   endif



   if !empty(cCOMANDO)
      Fwrite(nUSO,cCOMANDO)
      with object oComm
      :CommandText      := cCOMANDO
      :CommandType      := adCmdText
      :ActiveConnection := oConn
      :Execute()
   end
endif

EndIf
oRSDES:Close()


cCOMANDO := "SELECT * FROM credenciais WHERE CRED_Numero='"+xNUMERO+"'"

TRY
oRSDES:Open(cCOMANDO,oConN,adOpenDynamic,adLockOptimistic)
CATCH oERR
ShowADOError(oERR,oConn,cCOMANDO)
END
If oRSDES:EOF
   cCOMANDO := "INSERT INTO dbo.credenciais (CRED_NUMERO,cred_AreaNoMomento ,crti_numero)"
   cCOMANDO += " VALUES ("+xNUMERO+",0,1) ;"

   fwrite(nUSO,cCOMANDO+HB_OSNEWLINE())

   //         oComm:=WIN_OLECreateObject( "ADODB.Command" )
   with object oComm
   :CommandText      := cCOMANDO
   :CommandType      := adCmdText
   :ActiveConnection := oConn
   :Execute()
end

//         oRSDES:AddNew()
//         oRSDES:fields("cred_numero"):value:=xNUMERO
//         oRSDES:fields("cred_AreaNoMomento"):value:=0
//         oRSDES:fields("crti_numero"):value:=1
//         oRSDES:Update()
EndIf
oRSDES:Close()



cCOMANDO := "SELECT * FROM cred_Pessoas WHERE PES_NUMERO="+xNUMERO
TRY
oRSDES:Open(cCOMANDO,oConN,adOpenDynamic,adLockOptimistic)
CATCH oERR
ShowADOError(oERR,oConn,cCOMANDO)
END

If oRSDES:EOF
   cCOMANDO := "INSERT INTO dbo.CRED_PESSOAS (CRED_NUMERO, PES_NUMERO, CRPES_DATAENTRADA, CRPES_DATASAIDA)"
   cCOMANDO += " VALUES ('"+xNUMERO+"',"+xNUMERO+", cast('"+dtos(dADMITIDO)+"' as datetime), CAST ('30501231' AS DATETIME));"
   fwrite(nUSO,cCOMANDO+HB_OSNEWLINE())

   //         oComm:=WIN_OLECreateObject( "ADODB.Command" )
   with object oComm
   :CommandText      := cCOMANDO
   :CommandType      := adCmdText
   :ActiveConnection := oConn
   :Execute()
end

EndIf
oRSDES:Close()
endif



IF VALTYPE(cMASCDEM) = 'C' .and. !empty(demitido)
   nNUMERO   := &cMASCDEM.
   xNUMERO   := ALLTRIM(STR(nNUMERO))
   dADMITIDO := ADMITIDO
   dDEMITIDO := DEMITIDO

   @ 24,00 SAY nNUMERO         
   if nnumero > 0
      petela(8)
      if !empty(admitido)
         cCOMANDO := "UPDATE dbo.CRED_PESSOAS  SET CRPES_DATAENTRADA          =cast('"+dtos(ADMITIDO)+"' as datetime)  WHERE PES_NUMERO = "+STR(nNUMERO)+" AND (CRPES_DATAENTRADA='' OR CRPES_DATAENTRADA IS null)  ;"
         cCOMANDO += HB_OSNEWLINE()
         cCOMANDO += "UPDATE dbo.CREDENCIAIS  SET CRED_DTVALIDINICIAL=cast('"+dtos(ADMITIDO)+"' as datetime)  WHERE CRED_NUMERO = '"+alltrim(STR(nNUMERO))+"' AND (CRED_DTVALIDINICIAL='' OR  CRED_DTVALIDINICIAL IS null)  ;"
         cCOMANDO += HB_OSNEWLINE()
         cCOMANDO += "UPDATE dbo.PESSOAS      SET PES_DTSITINICIAL       =cast('"+dtos(ADMITIDO)+"' as datetime)  WHERE PES_NUMERO = "+STR(nNUMERO)+" AND (PES_DTSITINICIAL='' OR  PES_DTSITINICIAL IS null)  ;"
         cCOMANDO += HB_OSNEWLINE()
         fwrite(nUSO,cCOMANDO)


         with object oComm
         :CommandText      := cCOMANDO
         :CommandType      := adCmdText
         :ActiveConnection := oConn
         :Execute()
      end


   endif
   if !empty(DEMITIDO)
      cCOMANDO := "UPDATE dbo.CRED_PESSOAS   SET CRPES_DATASAIDA          =cast('"+dtos(DEMITIDO)+"' as datetime)   WHERE PES_NUMERO = "+STR(nNUMERO)+" AND (CRPES_DATASAIDA='' OR CRPES_DATASAIDA IS null OR CRPES_DATASAIDA =CAST ('30501231' AS DATETIME) )  ;"
      cCOMANDO += HB_OSNEWLINE()
      cCOMANDO += "UPDATE dbo.CREDENCIAIS  SET CRED_DTVALIDFINAL=cast('"+dtos(DEMITIDO)+"' as datetime)   WHERE CRED_NUMERO = '"+alltrim(STR(nNUMERO))+"' AND (CRED_DTVALIDFINAL='' OR  CRED_DTVALIDFINAL IS null)  ;"
      cCOMANDO += HB_OSNEWLINE()
      cCOMANDO += "UPDATE dbo.PESSOAS      SET PES_DTSITFINAL      =cast('"+dtos(DEMITIDO)+"' as datetime) 	  WHERE PES_NUMERO = "+STR(nNUMERO)+" AND (PES_DTSITFINAL='' OR  PES_DTSITFINAL IS null)  ;"
      cCOMANDO += HB_OSNEWLINE()
      fwrite(nUSO,cCOMANDO)


      with object oComm
      :CommandText      := cCOMANDO
      :CommandType      := adCmdText
      :ActiveConnection := oConn
      :Execute()
   end

endif
ENDIF
ENDIF


dbselectar("fo_pes")
dbskip()
enddo

oConn:Close()
oConn := NIL
dbcloseall()
fclose(nuso)

return NIL


*+ EOF: fopto_cat.prg
*+
