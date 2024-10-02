*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\OBJ\DISKLIB.PRG
*+
*+    Functions: NOTEP()
*+                AGEN()
*+               Function LOGOTIPO()
*+               Function FIM()
*+               QUADRO()
*+               Function NEXTREC()
*+               Function PREVREC()
*+               Function DELEREC()
*+               Function MD()
*+               Function MDT()
*+               Function MUDADATA()
*+               Function OBSSAY()
*+               Function OBSGET()
*+
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

////#INCLUDE "COMANDO.CH"
#INCLUDE "INKEY.CH"
#INCLUDE "BOX.CH"

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    NOTEP()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
FUNCTION NOTEP
PRIV mNOME := SPACE(10),GETLLIST := {}
PRIV mOBS1 := mOBS2 := mOBS3 := mOBS4 := mOBS5 := mOBS6 := mOBS7 := mOBS8 := SPACE(60)
aAMBNOT := SALVAA()
PADRAO("NOTA","NOTA","mNOME+' '+mOBS1","mNOME","Cadastro de Anotacoes","Anotacao",;
       {|| PEGCHAVE("mNOME",SPACE(10),"Codigo")},"MDG001","MDG001",{|| FO_RELL("ANOTACOES") },,4)
RESTAA(aAMBNOT)
return .t.

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    AGEN()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
FUNCTION AGEN 
PRIV mCDDATA := CTOD("  /  /  "),GETLLIST := {}
PRIV mOBS1   := mOBS2 := mOBS3 := mOBS4 := mOBS5 := mOBS6 := mOBS7 := mOBS8 := SPACE(60)
aAMBAGE := SALVAA()
PADRAO("AGENDA","AGENDA","DTOC(mCDDATA)+' '+mOBS1","mCDDATA","Cadastro de Compromissos","Compromisso",;
       {|| PEGCHAVE("mCDDATA",date(),"Data:")},"MDF001","MDF001",{|| FO_RELL("AGENDA") },,4)
RESTAA(aAMBAGE)
return .t.


*+--------------------------------------------------------------------
*+
*+    Function TELE()
*+
*+--------------------------------------------------------------------
FUNCTION TELE
PRIV mNOME := SPACE(15),mESPECIF := SPACE(35),mTELEF := SPACE(14),;
 mFAX := SPACE(14),GETLIST := {}
aAMBTEL := SALVAA()
PADRAO("TELEMEMO","TELEMEMO","mNOME+' '+mTELEF","mNOME","Cadastro de Telefones","Nome Telefone",;
      {|| PEGCHAVE("mNOME",SPACE(10),"Codigo:")},"MDE001","MDE001",{|| FO_RELL("TELEMEMO") },,4)
RESTAA(aAMBTEL)

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function LOGOTIPO()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
function LOGOTIPO( TITULO )               
ANT := setcolor()
setcolor( "W/N" )
clear
setcolor( "+W/R" )
@ 00, 00 clea to 02, 79
@ 01, 00 say padc( TITULO, 80 )
@ 21, 00 clea to 23, 79
setcolor( ANT )
retu .T.

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function FIM()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
function FIM( TITULO )  //ENCERRA O PROGRAMA
setcolor( "+W/BR,N/W" )
clear
HB_DISPBOX( 20, 25, 22, 53, B_DOUBLE+" ")
setcolor( "W/N" )
@ 00, 00 say TITULO
quit
return  .T. 

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    QUADRO()
*+
*+    Called from ( disklib.prg  )   1 - notep()
*+                                   1 - agen()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
function QUADRO( TITULO )                   //(MOLDURA PARA TECLAS ESPECIAIS)
setcolor( "+W/B" )
HB_DISPBOX( 04, 07, 18, 71, B_DOUBLE+" ")
@ 06, 09 say TITULO
@ 07, 09 say "------------------------------------------------------------"
@ 16, 09 say "------------------------------------------------------------"
return

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function NEXTREC()
*+
*+    Called from ( disklib.prg  )   1 - function delerec()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
function NEXTREC        //DA UM DBSKIP(E VERIFICA SE NAO E FINAL DE ARQUIVO
dbskipex()
if eof()
   MDT( ' --------- Vocˆ est  no fim do arquivo ! -------- ' )
endif
return  .T. 

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function PREVREC()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
function PREVREC        //DA UM DBSKIP()-1 E VERIFICA SE NAO E COMECO DE ARQUIVO
dbskipex(-1)
if bof()
   MDT( ' -------- Voce esta no comeco do arquivo ! ------- ' )
endif
return ( .T. )

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function DELEREC()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
function DELEREC        //CONFIRMA E MARCA UM REGISTRO COMO DELETADO
if MDG( 'Confirma exclus„o ?' )
   netrecdel()
   PCK := .T.
else
   recall
endif
NEXTREC()
return .T.

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function MD()
*+
*+    Called from ( disklib.prg  )   1 - function mds()
*+                                   1 - function mdt()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
function MD             //TELA PARA AS MENSAGENS
@ MAXROW(), 00
return  .T. 


*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function MDT()
*+
*+    Called from ( disklib.prg  )   1 - function nextrec()
*+                                   1 - function prevrec()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
function MDT(cMSG)            //EXIBE MENSAGEM POR UM TEMPO
hb_Alert(cMSG, , , 1 ) 
return  .t. 

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function MUDADATA()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
funcTION MUDADATA

MDS( 'Digite a Data Operacional' )
@ 24, 30 say digadata( DXDIA, 3, 3, 2, "," )
@ 24, 70 get DXDIA
READCUR()
ANO := year( DXDIA )
retu .T.

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function OBSSAY()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
function OBSSAY( LIN )  // AUXILIAR DE TRABALHO

setcolor( "+N/W" )
@ LIN, 09     say OBS1
@ LIN + 1, 09 say OBS2
@ LIN + 2, 09 say OBS3
@ LIN + 3, 09 say OBS4
@ LIN + 4, 09 say OBS5
@ LIN + 5, 09 say OBS6
@ LIN + 6, 09 say OBS7
@ LIN + 7, 09 say OBS8
setcolor( "W/N" )
return  .T. 

*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
*+    Function OBSGET()
*+
*+    Called from ( disklib.prg  )   1 - notep()
*+                                   1 - agen()
*+
*+||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*+
function OBSGET( LIN )  //AUXILIAR DE TRABALHO

setcolor( "+GR/B" )
@ LIN, 09     get OBS1
@ LIN + 1, 09 get OBS2
@ LIN + 2, 09 get OBS3
@ LIN + 3, 09 get OBS4
@ LIN + 4, 09 get OBS5
@ LIN + 5, 09 get OBS6
@ LIN + 6, 09 get OBS7
@ LIN + 7, 09 get OBS8
READCUR()
setcolor( "W/N" )
return  .T. 

FUNCTION FOYD
IF ! NETUSE(PES) 
   DBCLOSEALL()
   RETU .F.
ENDIF
DBGOTOP()
WHILE ! EOF()
   PETELA(8)
   netreclock()
   CorrigeFo_pes()
   DBunlock()   
   DBSKIP()
ENDDO
dbcloseall()
RETURN 

FUNCTIOn CorrigeFo_pes()
   FIELD->CNUMERO:=STRZERO(NUMERO,8)
   FIELD->DEPSETSEC:=DEPTO*1000000+SETOR*1000+SECAO
   field->cpf:=formatacpf(CPF)
   field->RG:=formatarg(RG)
   FIELD->ENDER:=CorrigeEndereco("ENDER","ENDNUM","ENDCOMPL","ENDTIP")
   IF NASCPAIS="1058" 
      FIELD -> ANONASCI := 0
   ENDIF   
   FIELD->PROFIS:=STRZERO(VAL(PROFIS),7)
   FIELD->SERIE:=STRZERO(VAL(SERIE),5)
   IF EMPTY(FGTS)
      FIELD->FGTS:=admitido
   ENDIF 
   IF EMPTY(DEFICI)
      FIELD->DEFICI:="0"
   ENDIF
   IF DEFICI="N"
      FIELD->DEFICI:="0"
   ENDIF  
   IF DEFICI="S" //colocar codigo _ para forcar codigo valido 1/6
      FIELD->DEFICI:="_"
   ENDIF  
   DO CASE
      CASE FIELD->OCOFGTS="0" .OR. FIELD->OCOFGTS="1" .OR. FIELD->OCOFGTS="5" .OR. EMPTY(FIELD->OCOFGTS)
           FIELD->EOCO:="1"      //nao exposto
     	CASE FIELD->OCOFGTS="4" .OR. FIELD->OCOFGTS="8"
      		FIELD->EOCO:="2"      //25 anos
     	CASE FIELD->OCOFGTS="3" .OR. FIELD->OCOFGTS="7"
      		FIELD->EOCO:="3"     //20 anos
     	CASE FIELD->OCOFGTS="2" .OR. FIELD->OCOFGTS="6"
      	  FIELD->EOCO:="4"     //15 anos
   ENDCASE
   IF EMPTY(FIELD->EIADM)
      FIELD->EIADM:="1"  //1 Normal 2 ação fiscal 3 ação judicial
   ENDIF
   IF EMPTY(FIELD->EREGI)
      FIELD->EREGI:="CLT" //CLT RJV RJP
   ENDIF
   IF EMPTY(FIELD->EPREV)
      FIELD->EPREV:="RGPS" //RGPS RPPS RPE
   ENDIF
   IF EMPTY(FIELD->ELTRA)
      FIELD->ELTRA:="1" //1 Urbano //2rural   
   ENDIF
   IF EMPTY(FIELD->RGTIP)
      FIELD->RGTIP:="RG"
   ENDIF
   IF EMPTY(FIELD->ETJOR)
      FIELD->ETJOR:="1" //padrao horario clt
   ENDIF
   IF EMPTY(FIELD->ETCOR)
      FIELD->ETCOR:="1"  //contrato indetermindo
   ENDIF
   
   IF EMPTY("EVINC")
      DO CASE
         CASE FIELD->CATEGORIA="01" //Funcionario rais=10
              FIELD->EVINC:="101"
         CASE FIELD->CATEGORIA="07" //aprendiz rais=55
              FIELD->EVINC:="103"
         CASE FIELD->CATEGORIA="11" //diretor rais=80
              FIELD->EVINC:="722"              
      ENDCASE
      //rais 50=temporarios evinc="105"
   ENDIF
   
	IF EMPTY("CATEGORIA")
		  DO CASE
			 CASE FIELD->EVINC="101"
				   FIELD->CATEGORIA:="01" //Funcionario rais=10			  
			 CASE FIELD->EVINC="103"		 
				  FIELD->CATEGORIA:="07" //aprendiz rais=55
			 CASE FIELD->EVINC="722"              
				  FIELD->CATEGORIA:="11" //diretor rais=80
		  ENDCASE
		  //rais 50=temporarios evinc="105"
	ENDIF   
   
   
    IF Empty(FIELD->TIPFGTS) .AND. ! EMPTY(FIELD->CATEGORIA) .AND. ! EMPTY(FIELD->E1ADM)
	      cPREF:="9"
	      IF FIELD->CATEGORIA="07"
	       	  cPREF:="3"       	
	       ENDIF
	       IF FIELD->CATEGORIA="11"
	       	  cPREF:="1"       		       	  
	       ENDIF
	       IF ! Empty(FIELD->dattransf)
	       	  cPREF+="C"       		       	  
	       ELSE
              IF FIELD->E1ADM="N"
              	 cPREF+="B"       		       	  
              ELSE	
              	 cPREF+="A"       		       	                
              ENDIF	  
	       ENDIF	
	      FIELD->TIPFGTS:=cPREF
 	   ENDIF 
   DO CASE
      CASE TIPO="1"
           FIELD->TIPO:="M"
      CASE TIPO="2"
           FIELD->TIPO:="Q"
      CASE TIPO="3"
           FIELD->TIPO:="S"
      CASE TIPO="4"
           FIELD->TIPO:="D"
      CASE TIPO="5"
           FIELD->TIPO:="H"
      CASE TIPO="6"
           FIELD->TIPO:="T"
      CASE TIPO="7"
           FIELD->TIPO:="O"           
   ENDCASE
   
   IF EMPTY(FIELD->RACS)
      cRACA:=OBTER("FO_RAIS",,"NUMERO","RACA",,,,,, "" )     
      cRACS:=""            
      DO CASE
         CASE cRACA="1"
              cRACS:="5"
         CASE cRACA="2"
              cRACS:="1"
         CASE cRACA="4"
              cRACS:="2"
         CASE cRACA="6"
              cRACS:="3"
         CASE cRACA="8"
              cRACS:="4"
         CASE cRACA="9"
              cRACS:="9"        
      ENDCASE
      IF ! EMPTY(cRACS)
        FIELD->RACS:=cRACS 
      ENDIF  
   ENDIF
   
RETURN .T.

*!*****************************************************************************
*!
*!         Funcao: PETELA()
*!
*!
*!*****************************************************************************
FUNCtion PETELA(COL)
@ COL,0 CLEAR TO COL+2,79
@ COL,00   SAY "+-DEPTO-++-SETOR-++-SECAO-++-CHAPA-++REGISTRO++--NOME DO FUNCIONARIO-----------+"
@ COL+1,00 SAY "|       ||       ||       ||       ||        ||                                |"
@ COL+2,00 SAY "+-------++-------++-------++-------++--------++--------------------------------+"
@ COL+1,02 SAY DEPTO
@ COL+1,12 SAY SETOR
@ COL+1,21 SAY SECAO
@ COL+1,30 SAY CHAPA
@ COL+1,39 SAY NUMERO
@ COL+1,48 SAY NOME
RETURN .T.

*!*****************************************************************************
*!
*!         Funcao: PEGVALTAB(cTAB,nMES,nANO)
*!  ASSMED,ASSODO,FOPTOALM,TABARRE,TABTROCO
*!
*!*****************************************************************************
FUNC PEGVALTAB(cTAB,nMES,nANO)
LOCAL aRETU:={}
LOCAL lRETU:=.F.
IF VALTYPE(nMES)#"L"
   nMES:=MESTRAB
ENDIF
IF VALTYPE(nANO)#"L"
   nANO:=ANOUSO
ENDIF
aRETU:={0,0,0,0,0}
IF ! NETUSE(cTAB)
   RETU aRETU
ENDIF
DBGOTOP()
IF DBSEEK(STR(nANO,4)+STR(nMES,2))  //Tenta ano mes
   aRETU:={DESCT,DESCTB,DESCTC,DESCTD,DESCTE}
   lRETU:=.T.
ELSE
   IF DBSEEK(STR(0,4)+STR(nMES,2))  //so mes
      aRETU:={DESCT,DESCTB,DESCTC,DESCTD,DESCTE}
      lRETU:=.T.
   ENDIF
ENDIF
DBCLOSEAREA()
IF ! lRETU
   ALERTX("Nao Encontrado Valores tabela: "+cTAB)
ENDIF
RETU aRETU

*!*****************************************************************************
*!
*!         Funcao: PEGVALTIP(cTIPVAL,aVAL)
*!  ASSMED,ASSODO,FOPTOALM,TABARRE,TABTROCO
*!
*!*****************************************************************************
FUNC PEGVALTIP(cTIPVAL,aVAL)
LOCAL nVALOR:=0
IF ! EMPTY(cTIPVAL).AND.cTIPVAL#'N'
   DO CASE
      CASE cTIPVAL="E" ; nVALOR=aVAL[5]
      CASE cTIPVAL="D" ; nVALOR=aVAL[4]
      CASE cTIPVAL="C" ; nVALOR=aVAL[3]
      CASE cTIPVAL="B" ; nVALOR=aVAL[2]
      OTHERWISE        ; nVALOR=aVAL[1] //A ou S
   ENDCASE
ENDIF
RETU nVALOR
   
*!*****************************************************************************
*!
*!         Fun‡„o: PEGFOLMES()
*!
*!*****************************************************************************

FUNCTION PEGFOLMES()   
CONTINUA=.T.
WHILE CONTINUA
   @ 7,0 CLEAR
   @ 09,14 SAY "+-----------------------------------------------------+"
   @ 10,14 SAY "|         ESCOLHA O MES QUE DESEJA TRABALHAR:         |"
   @ 11,14 SAY "|-----------------------------------------------------|"
   @ 12,14 SAY "|"+SPAC(53)+"|"
   @ 13,14 SAY "|"+SPAC(53)+"|"
   @ 14,14 SAY "|"+SPAC(53)+"|"
   @ 15,14 SAY "|"+SPAC(53)+"|"
   @ 16,14 SAY "+-----------------------------------------------------+"
   OPCAO(12,16,' Janeiro   ',74)
   OPCAO(13,16,' Fevereiro ',70)
   OPCAO(14,16,' Marco     ',77)
   OPCAO(15,16,' Abril     ',65)
   OPCAO(12,35,' 5-maio    ',73)
   OPCAO(13,35,' 6-junho   ',78)
   OPCAO(14,35,' 7-julho   ',76)
   OPCAO(15,35,' 8-agosto  ',71)
   OPCAO(12,53,' Setembro  ',83)
   OPCAO(13,53,' Outubro   ',79)
   OPCAO(14,53,' Novembro  ',86)
   OPCAO(15,53,' Dezembro  ',68)
   OP:=MENU(MONTH(DATE()),0)
   IF OP>0
      IF MDG('Confirme: '+Mmes(OP))
         CONTINUA=.F.
      ENDIF
   ENDIF   
ENDDO
RETU OP   


*!*****************************************************************************
*!
*!         Fun‡„o: PEGFOLSEN()
*!
*!*****************************************************************************

FUNCTION PEGFOLSEN(lDIR)
IF VALTYPE(lDIR)#"L"
   lDIR:=.T.
ENDIF   
  WHILE CONSEN
      NRSEN = SPAC(5)
      MDS('DIGITE A SUA SENHA EMPRESA')
      setcolor( "G/G,G/G" )
      @ 24,57 GET NRSEN
      READCUR()
      setcolor( "W/N,N/W" )
 //   IF NRSEN='HELPS'
//         OP_SENHA='MENTOR'
//    ENDIF
      IF NRSEN = 'DISKC'.OR.NRSEN=MSG3
         CONSEN = .F.
      ELSE
         IF NRSEN = 'DiReT'
            IF ! lDIR
               ALERTX( "Nao Processa Diretores" )            
            ELSE
              CONSEN = .F.
            ENDIF
         ENDIF
      ENDIF
   ENDDO
return NRSEN   


*!*****************************************************************************
*!
*!         Fun‡„o: PEGFOLPAT()
*!
*!*****************************************************************************

FUNCTION PEGFOLPAT()
   //Verifica o ano Se nao e' 00 (ano atual)
   if file( HB_CWD()+ 'EMP' + ANOWORK + strzero( NREMP, 3 ) + "\FO_PES.DBF" )
      ZDIRE := HB_CWD() + 'EMP' + ANOWORK + strzero( NREMP, 3 )+"\"
   else
      ZDIRE := HB_CWD()+ 'EMP' + strzero( NREMP, 5 )+"\"
      if ! HB_FILEEXISTS( ZDIRE + "FO_PES.DBF" )
         ALERTX( "Falta Arquivo de Funcionarios" )
         NREMP := 0
         return .f.
       endif
   endif
   ZDIRN := HB_CWD() +'E' +  strzero( ANOUSO, 4 )+"\"
   makedir(ZDIRE)
   makedir(ZDIRN)

   cPATH:=ZDIRE+";"+ZDIRN
   Set( _SET_PATH, cPATH)
   //ser path to &cPath.
   //ZDIRE+= "\"
   //ZDIRN+= "\"
RETURN .T.


*!*****************************************************************************
*!
*!         Fun‡„o: SALHM()
*!
*!*****************************************************************************
FUNCTION SALHM(XXMES,XXANO,lOPEN)                                 &&CALCULA SALARIO MES E HORA
LOCAL cALIAS,xNUMERO,XSAL,VAR1
IF VALTYPE(lOPEN)<>"L"
   lOPEN:=.T.
ENDIF
xNUMERO:=NUMERO
cALIAS:=dbselectar()
if lOPEN
   if ! netuse("fo_sal")
      salh:=0
      salm:=0
      return 0
   endif
endif
XXMES=IF(valtype(XXMES)="N" .AND. XXMES#0,XXMES,MESTRAB)
XXANO=IF(valtype(XXANO)="N" .AND. XXANO#0,XXANO,ANOUSO)
XSAL='SAL'+SUBSTR(MMES(XXMES),1,3)
dbselectar("fo_sal")   
dbgotop()
if dbseek(str(xNUMERO,8)+STR(XXANO,4))
   VAR1:=&XSAL.
else
   netrecapp()
   field->numero:=xNUMERO
   field->ano   :=xxano
   dbunlock()
   var1:=0   
endif
IF lOPEN
   dbselectar("fo_sal")
   dbClosearea()
ENDIF
if ! empty(cALIAS)
   dbselectar(cALIAS)
endif
DO CASE
   CASE TIPO = '1' .OR. TIPO="M" ; SALH=(VAR1/MESHORA) ; SALM=VAR1
   CASE TIPO = '5' .OR. TIPO="H" ; SALH=VAR1           ; SALM=VAR1*MESHORA
ENDCASE
RETURN SALM


*+ EOF: DISKLIB.PRG

