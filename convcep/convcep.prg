
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*+
*+    Source Module => d:\TROUXE\CONVCEP.PRG
*+
*+¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
*
*
* arquivos do correio na maioria tem header e footer por isso
* e deletado o primeiro e ultima na importacaoCE
#INCLUDE "INKEY.CH"
#include "tshead.ch"


REQUEST HB_CODEPAGE_PTISO
REQUEST HB_LANG_PT
REQUEST DBFCDX

function main()



MVINFOConfTela("convcep - atualizador de cep")

netregosok()

HB_IDLESTATE()
Set( _SET_CODEPAGE, "PTISO")   
HB_LANGSELECT('PT') 
rddsetdefault( "DBFCDX" )
Set( _SET_OPTIMIZE, .t.)
Set( _SET_DELETED, .t.)
Set( _SET_SOFTSEEK, .t.)
__SetCentury( .t. )
Set( _SET_EPOCH, year( date() ) - 60 )
Set( _SET_DATEFORMAT, "dd/mm/yyyy" )
SetCursor(.t.)

if mdg("Importar jason country")
  JasonCountry()
endif
          
aUF    := { "AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", ;
            "MA", "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", ;
            "RJ", "RN", "RO", "RR", "RS", "SC", "SE", "SP", "TO" ,"EX","XX"}

aIBGE:= { "12", "27", "13", "16", "29", "23", "53", "32", "52", ;
          "21", "31", "50", "51", "15", "25", "26", "22", "41", ;
          "33", "24", "11", "14", "43", "42", "28", "35", "17" ,"99","99"} //ex xx 99.99999 padrao speds alguns no lugar de 54
            
			
Lmunicipios:=.f.
if file("municipios.dbf") .and. file("md10imp.dbf") .and. MsgYesNo("importar municipios/sped")
   use md10imp new exclusive
   ZAP
   append from municipios   
   dbclosearea()
   Lmunicipios:=.t.
endif

lpgcn:=.f.
if file("pgcn.dbf") .and. file("md10imp.dbf") .and. MsgYesNo("importar pgcn ddd dados.gov") 
   //pesquisar anatel ddd na dados.gov
   //Codigo IBGE;UF;MUNICiPIO;CoDIGO_NACIONAL 
   //CODIBGE;UF;NOME;DDD
   //psapad trocar cabecario acima
   //remover acentos
   //fixar ansi e delimitador linha dos
   // trocar '' para espaco e ' para nada (ajustar nome com 'd''aqua' ou semelantes
   use md10imp new exclusive
   ZAP
   append from pgcn
   dbclosearea()
   lpgcn:=.t.
endif

/* CE_F anatel  https://sistemas.anatel.gov.br/areaarea/N_Download/Tela.asp?varMod=Publico&SISQSmodulo=7179
1 Sigla UF                            char 02
02 Sigla CNL                           char 04
03 Codigo CNL                          char 05
04 Nome da Localidade                  char 50
05 Nome do Municipio                   char 50
06 Cod. da Area Tarifacao              char 05   2 primeiros digitos DDD  CE_F dois campos ddd 2 CODARTAR 3 
07 Prefixo                             char 07
08 Prestadora                          char 30
09 Num. da Faixa Inicial               char 04
10 Num. da Faixa Final                 char 04
11 Latitude                            char 08 (*)
12 Hemisferio                          char 05
13 Longitude                           char 08 (*)
14 Sigla CNL da Área Local             char 04

OBSERVAÇÕES:                                               
1) Os campos marcados com (*), Latitude e Longitude foram
   alterados para o formato GGMMSSCC, 
   onde:
   GG = Grau,
   MM = Minuto,
   SS = Segundo e
   CC = Centésimos de Segundo
*/

lCE_F:=.f.
if file("ce_f.txt") .and. file("CE_F.dbf") .and. file("md10imp.dbf") .and. MsgYesNo("importar CE_F anatel")
   nLASTREC:=0
   if MsgYesNo("importar CE_F.txt para ce_f.dbf")
     use ce_f new exclusive
     nLASTREC:=FLINECOUNT("ce_f.txt")
     zei_fort( nLASTREC,,,0)
     append from ce_f.txt SDF WHILE zei_fort(nLASTREC,,,1)
     dbclosearea()
   ENDIF  
   
   if MsgYesNo("importar CE_F.DBF para MD10IMP.dbf")   
     zei_fort( nLASTREC,,,0) 
     use md10imp new exclusive
     ZAP
     append from CE_F  WHILE zei_fort(nLASTREC,,,1)
     dbclosearea()
   ENDIF   
   lCE_F:=.t.
endif

if (file("md10imp.dbf") .and. (lpgcn .or. Lmunicipios .or. lCE_F .or. MsgYesNo( "Importar Cidades md10imp.dbf" )))
   nUSO := fcreate( "MD10IMP.TXT" )
   use md10imp new shared
   netuse("cidconv")
   netuse("MD10")
   dbselectar("md10imp")
   dbgotop()
   while ! eof()   
	    mNOME     := md10imp->nome        
        mUF       := md10imp->uf
        mNOME     := tratanome( mNOME,.T.,.T. )     
        mDDD      := md10imp->DDD
        mCODIBGE  := md10imp->CODIBGE        

    //    mCODTSE   := md10imp->CODTSE     mesmo codigo codirrf
        mCODBACEN := md10imp->CODBACEN       
        mCODIRRF  := md10imp->CODIRRF
        
        mINICEP   := md10imp->INICEP
        mFIMCEP   := md10imp->FIMCEP    
        
        mAREA     := md10imp->AREA
        mNOMTEL     := md10imp->NOMTEL
        mCODTEL     := md10imp->CODTEL
        
        mlatitude   := md10imp->latitude
        mlongitude  := md10imp->longitude
        mhemisferio := md10imp->hemisferio
        
        mCENTROI:=  md10imp->CENTROI //"POINT(-46.3739271518483 -23.5609457306696)"
        IF ! EMPTY(mCENTROI)
            mCENTROI:=STRTRAN(mCENTROI,"POINT","")
            mCENTROI:=STRTRAN(mCENTROI,"(","")
            mCENTROI:=STRTRAN(mCENTROI,")","")

            nPOSGEO:=AT(" ",mCENTROI)   
            IF nPOSGEO>0
               mLATITUDE  := SUBSTR(mCENTROI,nPOSGEO+1)  //23
               mLONGITUDE := SUBSTR(mCENTROI,1,nPOSGEO-1) //46
            ENDIF
        ENDIF

        
        
        IF ! EMPTY(mUF) .AND. aSCAN(aIBGE,mUF)>0 //A uf esta com codigo e nao com a sigla
            mUF:=CODUF(mUF,"UF")
        ENDIF
        IF EMPTY(mUF) .AND. ! EMPTY(mCODIBGE) .AND.  aSCAN(aIBGE,LEFT(mCODIBGE,2))>0 //pega uf pelo ibge
		   mUF:=CODUF(mCODIBGE,"UF")
		endif
		@ MAXROW(),00 SAY mUF+" "+mNOME
        lACHEI:=.F.
        IF ! lACHEI .and. ! empty(mUF) .and. ! empty(mNOME)
           dbselectar("md10")
           dbsetorder(1)   //nome
           dbgotop()
           if dbseek(mUF+mNOME)
              netreclock()
              lACHEI:=.T.
           endif
        ENDIF   
        IF ! lACHEI .and. ! empty(mUF) .and. ! empty(mNOME)
           mNOME:=pegcidconv(mUF,mNOME) //nome convertido
           dbselectar("md10")
           dbsetorder(1)
           dbgotop()
           if dbseek(mUF+mNOME)
              netreclock()
              lACHEI:=.T.
           endif
        ENDIF   
        IF ! lACHEI .and. ! empty(mCODIbGE)            
           dbselectar("md10")
           dbsetorder(3)
           dbgotop()
           if dbseek(mCODIBGE)
              netreclock()
              lACHEI:=.T.
		   else 
              dbappend()		   
			  lACHEI:=.T.
              md10->NOME     := mNOME
              md10->UF       := mUF
              md10->CodIBGE := mCODIBGE
           endif
        ENDIF   
        IF lACHEI
           if ! empty(mDDD)  .AND. EMPTY(md10->DDD)           
               md10->DDD := mDDD
           endif   
           if ! empty(mCODIBGE)   .AND. EMPTY(md10->CODIBGE)           
               md10->CODIBGE := mCODIBGE
           endif 
                      
           if ! empty(mCODIRRF)   .AND. EMPTY(md10->CODIRRF)           
               md10->CODIRRF := mCODIRRF
           endif  
     //      if ! empty(mCODTSE)   .AND. EMPTY(md10->CODTSE)       mesmo codigo codirrf     
     //          md10->CODTSE := mCODTSE
      //     endif              
           if ! empty(mCODBACEN)   .AND. EMPTY(md10->CODBACEN)           
               md10->CODBACEN := mCODBACEN
           endif                        
           if ! empty(mINICEP)   .AND. VAL(md10->INICEP)=0
               md10->INICEP := mINICEP
           endif   
           if ! empty(mFIMCEP)   .AND. VAL(md10->FIMCEP)=0
               md10->FIMCEP := mFIMCEP
           endif  
           if ! emptY(mINICEP) .and. ! empty(mFIMCEP) 
              IF VAL(mINICEP)=VAL(md10->INICEP) .and. VAL(md10->INICEP)=VAL(md10->FIMCEP)
                 IF VAL(mFIMCEP)>VAL(md10->FIMCEP)
                    md10->FIMCEP := mFIMCEP
                    fwrite( nUSO, "CODIBGE: "+MCodiBGE + " " + MUF + " " + MNOME + "Faixa:= "+ mINICEP + "-"+ mFIMCEP +HB_OSNEWLINE() )
                 ENDIF
              ENDIF
           endif
           if ! empty(mNOMTEL)   .AND. VAL(md10->NOMTEL)=0
               md10->NOMTEL := mNOMTEL
           endif
            if ! empty(mCODTEL)   .AND. VAL(md10->CODTEL)=0
               md10->CODTEL := mCODTEL
           endif
            if ! empty(mLATITUDE)   .AND. VAL(md10->LATITUDE)=0
               md10->LATITUDE := LATITUDE
           endif
            if ! empty(mLONGITUDE)   .AND. VAL(md10->LONGITUDE)=0
               md10->LONGITUDE :=LONGITUDE
           endif
             if ! empty(mHEMISFERIO)   .AND. VAL(md10->HEMISFERIO)=0
               md10->HEMISFERIO :=HEMISFERIO
           endif        
           if  mAREA>0   .AND. md10->AREA=0
               md10->AREA := mAREA
           endif 
           dbunlock()
        ELSE
           fwrite( nUSO, "CODIBGE: "+MCodiBGE + " " + MUF + " " + MNOME +HB_OSNEWLINE() )
        ENDIF          
        dbselectar("md10imp")
        dbskip()  
    enddo         
    dbcloseall()
    FCLOSE(nUSO)
endif

if MsgYesNo( "Ajustar Arquivo Checagem 5 Digitos MD10->MD11" )
   netuse("MD10")
   netuse("MD11")
   dbselectar( "MD10" )
   dbgotop()
   while !eof()
      @ 24, 70 say recno()
      mCEPINI := left( INICEP, 5 )
      mCEPFIM := left( FIMCEP, 5 )
      if !empty( mCEPINI )
         dbselectar( "MD11" )
         mCEPINI := val( mCEPINI )
         mCEPFIM := val( mCEPFIM )
         for X := mCEPINI to mCEPFIM
            cCHAVE := strzero( X, 5 )
            @ 24, 60 say cCHAVE
            dbgotop()
            if !dbseek( cCHAVE )
               netrecapp()
               field->CEP := cCHAVE
            endif
         next X
      endif
      dbselectar( "MD10" )
      dbskip()
   enddo
   dbcloseall()
endif


IF MsgYesNo("Ajustar tipos de rua")
   lAPAGAMIL:=MsgYesNo("Apagar ceps menores que 10000") //Agiliza processo recomendado para novas importacao pois pode tre trazido ceps errados
   lAPAGASEMRUA:=MsgYesNo("Apagar ceps sem nome de rua e bairro") //alguns ceps como prefeitura posto caixa postal nao tem rua mas tem bairro
   aTIT:={}
   aCOD:={}
   netuse("mdtip")
   dbgotop()
   while ! eof()
      aadd(aTIT,ALLTRIM(NOME))
      aadd(aCOD,ALLTRIM(CODIGO))
      dbskip()
   enddo   
   dbclosearea()
   mArquivo := 'C*.dbf'
   mListaArq := Directory(mArquivo,"D")
   nFIMARQ:=LEN(mListaArq)   
   For i := 1 to nfimARQ
      cFILECEP:=lower(mListaArq[i,1])
      cFILECEP:=strtran(cFILECEP,".dbf","")
      @ 24,00 SAY SPACE(80)
	  
	   //01/02/2021 06:26 cria o arquivo de indexes caso ele nao exista
	   IF ! File(cFILECEP+".CDX") .and.  FILE(cFILECEP+".DBF")
           NETUSE(cFILECEP,,,,,.F.,)
 		   nLASTREC:=LASTREC()
           zei_fort( nLASTREC,,,0)
           index on RUA tag &cFILECEP.1 EVAL ZEI_FORT(nLASTREC,,,1)
           index on CEP tag &cFILECEP.2 EVAL ZEI_FORT(nLASTREC,,,1)
           DBCLOSEAREA()
       ENDIF
	  
      IF cFILECEP<>"ceprua" .AND. cFILECEP<>"cepbai" .AND. cFILECEP<>"cidconv" .AND. NETUSE(cFILECEP) //nao considerar arquivos que nao de rua
         nLASTREC:=LASTREC()
         zei_fort( nLASTREC,,,0)
		 if lAPAGAMIL
			DBEVAL({|| netrecdel()},{|| val(cep)<10000}, {|| zei_fort(nLASTREC,,,1)})
			zei_fort( nLASTREC,,,0) //zera pois e exibito novamente
		 ENDIF	
         dbsetorder(0) //deixa sem ordencao pois o nome sofre replace e um dos indices
         @ 23,00 SAY cFILECEP+" "+str(i)+"/"+str(nfimARQ)
         dbgotop()
         while ! eof()      
            //@ 24,09 SAY RECNO() PICT "99999"
            @ 24,00 SAY LEFT(RUA,30)
			zei_fort(nLASTREC,,,1)
            NETRECLOCK()
            IF UPPER(RUA)<>RUA
               FIELD->RUA:=UPPER(RUA)
            ENDIF
            nPOS:=AT("LADO IMPAR",RUA)
            IF nPOS>0
			   FIELD->PARID="I"
			   FIELD->RUA:=STRTRAN(RUA,"LADO IMPAR","")
			ENDIF
            nPOS:=AT("LADO PAR",RUA)
            IF nPOS>0
			   FIELD->PARID="P"
			   FIELD->RUA:=STRTRAN(RUA,"LADO PAR","")
			ENDIF
			
			nPOS:=AT("LADO ESQUERDO",RUA)
            IF nPOS>0
			   	IF EMPTY(FIELD->PARID)
				   FIELD->PARID="E"
			    ENDIF
			   FIELD->RUA:=STRTRAN(RUA,"LADO ESQUERDO","")
			ENDIF

			nPOS:=AT("LADO DIREITO",RUA)
            IF nPOS>0
			   IF EMPTY(FIELD->PARID)
				   FIELD->PARID="D"
			    ENDIF
			   FIELD->RUA:=STRTRAN(RUA,"LADO DIREITO","")
			ENDIF
			
            nPOS:=AT("LADO IMP",RUA)
            IF nPOS>0
			   FIELD->PARID="I"
			   FIELD->RUA:=STRTRAN(RUA,"LADO IMPAR","")
			ENDIF

			IF RIGHT(ALLTRIM(RUA),3)="- D"
				FIELD->RUA:=STRTRAN(RUA,"- D","")
				IF EMPTY(FIELD->PARID)
				   FIELD->PARID="D"
			    ENDIF
			ENDIF

			IF RIGHT(ALLTRIM(RUA),3)="- E"
				FIELD->RUA:=STRTRAN(RUA,"- E","")
				IF EMPTY(FIELD->PARID)
				   FIELD->PARID="E"
			    ENDIF
			ENDIF
		
		    //31/01/2021 22:00 ajustar rua que ficam com espaco traco " -"  no final
			IF RIGHT(ALLTRIM(RUA),2)=" -"
				FIELD->RUA:=SUBSTR(RUA,1,LEN(ALLTRIM(RUA))-2)
			ENDIF
	
			if at("AO FIM",RUA)>0 
		     field->NFIM:=99999
			 FIELD->RUA:=STRTRAN(RUA,"AO FIM","")
            endif	
			
			//FLORENCA SEIS   DE 7700/7701 A 8099/8100 trata quando a observacao veio junto com o nome da rua
			if at(" DE ",RUA)>0 .and. at(" A ",RUA)>0 .and. at("/",RUA)>0 .and. at("CAIXA POSTAL",RUA)=0
			   cOBS:=FIELD->RUA
			   nPOS:=at("DE ",cOBS)
			   nvalini:=0
			   NVALFIM:=0
			   CINI:=""
			   CFIM:=""
			   IF nPOS>0			   
			      cINI:=SUBSTR(cOBS,nPOS+3) //7700/7701 A 8099/8100 separa a parde de 
				  FIELD->RUA:=SUBSTR(cOBS,1,nPOS-2) //FLORENCA SEIS grava somente a rua
				  cOBS:=SUBSTR(cOBS,nPOS+3) //7700/7701 A 8099/8100 se for lado para o impar pega o para para o inicial que e menor
			      nPOS:=at("/",cINI) // quando nao e separado para ou impar nao tem o traco
			      IF nPOS>0				     
			         cINI:=SUBSTR(cINI,1,nPOS-1) //7700
					 nVALINI:=VAL(cINI)
			      ENDIF
				  nPOS:=at(" A ",cOBS)
				  IF nPOS>0 ////7700/7701 A 8099/8100 separa a parde A
					 cFIM:=SUBSTR(cOBS,nPOS+3) //8099/8100
				  ENDIF
				  nPOS:=at("/",cFIM)
			      IF nPOS>0				     
			         cFIM:=SUBSTR(cFIM,1,nPOS-1) //8099
					 nVALFIM:=VAL(cFIM)
			      ENDIF
				  if Nvalini>0 .and. NVALFIM>0
				     FIELD->NINI:=Nvalini
					 FIELD->NFIM:=NvalFIM
				  ENDIF
			   ENDIF
			endif
			
	
		    if at(" DE ",RUA)>0 .and. at(" ATE ",RUA)>0 .and. at("/",RUA)>0 .and. at("CAIXA POSTAL",RUA)=0
			   cOBS:=FIELD->RUA
			   nPOS:=at("DE ",cOBS)
			   nvalini:=0
			   NVALFIM:=0
			   CINI:=""
			   CFIM:=""
			   IF nPOS>0			   
			      cINI:=SUBSTR(cOBS,nPOS+3) //7700/7701 A 8099/8100 separa a parde de 
				  FIELD->RUA:=SUBSTR(cOBS,1,nPOS-2) //FLORENCA SEIS grava somente a rua
				  cOBS:=SUBSTR(cOBS,nPOS+3) //7700/7701 A 8099/8100 se for lado para o impar pega o para para o inicial que e menor
			      nPOS:=at("/",cINI) // quando nao e separado para ou impar nao tem o traco
			      IF nPOS>0				     
			         cINI:=SUBSTR(cINI,1,nPOS-1) //7700
					 nVALINI:=VAL(cINI)
			      ENDIF
				  nPOS:=at(" ATE ",cOBS)
				  IF nPOS>0 ////7700/7701 A 8099/8100 separa a parde A
					 cFIM:=SUBSTR(cOBS,nPOS+3) //8099/8100
				  ENDIF
				  nPOS:=at("/",cFIM)
			      IF nPOS>0				     
			         cFIM:=SUBSTR(cFIM,1,nPOS-1) //8099
					 nVALFIM:=VAL(cFIM)
			      ENDIF
				  if Nvalini>0 .and. NVALFIM>0
				     FIELD->NINI:=Nvalini
					 FIELD->NFIM:=NvalFIM
				  ENDIF
			   ENDIF
			endif
		    //PARQUE   ATE 481
		    if at(" DE ",RUA)=0 .and. at(" ATE ",RUA)>0 .and. at("/",RUA)=0 .and. at("CAIXA POSTAL",RUA)=0
			   cOBS:=FIELD->RUA
			   nPOS:=at(" ATE ",cOBS)
			   nvalini:=0
			   NVALFIM:=0
			   CINI:=""
			   CFIM:=""
			   IF nPOS>0
			      FIELD->RUA:=SUBSTR(cOBS,1,nPOS-1)
				  cFIM:=SUBSTR(cOBS,nPOS+5)
				  nVALFIM:=VAL(cFIM)
			   ENDIF 
			   if Nvalini=0 .and. NVALFIM>0
				  FIELD->NFIM:=NvalFIM
			    ENDIF
			endif

		   // PARQUE   DE 1003 A 1531
			if at(" DE ",RUA)>0 .and. at(" A ",RUA)>0 .and. at("/",RUA)=0 .and. at("CAIXA POSTAL",RUA)=0
			   cOBS:=FIELD->RUA
			   nPOS:=at(" DE ",cOBS)
			   nvalini:=0
			   NVALFIM:=0
			   CINI:=""
			   CFIM:=""
			   IF nPOS>0			   
				  FIELD->RUA:=SUBSTR(cOBS,1,nPOS-1) // PARQUE 
				  cOBS:=SUBSTR(cOBS,nPOS+4) //1003 A 1531
				  nPOS:=at(" A ",cOBS)
				  IF nPOS>0 
				     cINI:=SUBSTR(cOBS,1,nPOS-1) 
					 cFIM:=SUBSTR(cOBS,nPOS+3) 
					 nVALINI:=VAL(cINI)
					 nVALFIM:=VAL(cFIM)
				  ENDIF
				  if Nvalini>0 .and. NVALFIM>0
				     FIELD->NINI:=Nvalini
					 FIELD->NFIM:=NvalFIM
				  ENDIF
			   ENDIF
			endif
	
			//PARQUE   ATE 481/1233
		    if at(" DE ",RUA)=0 .and. at(" ATE ",RUA)>0 .and. at("/",RUA)>0 .and. at("CAIXA POSTAL",RUA)=0
			   cOBS:=FIELD->RUA
			   nPOS:=at(" ATE ",cOBS)
			   nvalini:=0
			   NVALFIM:=0
			   CINI:=""
			   CFIM:=""
			   IF nPOS>0
			      FIELD->RUA:=SUBSTR(cOBS,1,nPOS-1)
				  cobs:=SUBSTR(cOBS,nPOS+5)
				  nPOS:=at("/",cOBS)
				  IF nPOS>0
				     cFIM:=SUBSTR(COBS,nPOS+1)
					 nVALFIM:=VAL(cFIM)
				  ENDIF
			   ENDIF 
			   if Nvalini=0 .and. NVALFIM>0
				  FIELD->NFIM:=NvalFIM
			    ENDIF
			endif	

			
			
			
			
			 
			
            nPOS:=AT(" ",RUA) //nao processa se so tiver uma palavra sem necessidade de verificar
            IF nPOS>0
               cTIPO:=ALLTRIM(LEFT(RUA,nPOS-1)) //pega a primeira palavra para verifica se e um tipo
               cRUA   :=ALLTRIM(SUBSTR(RUA,nPOS+1))
               @ 24,00 Say LEFT(cRUA,30)
               @ 24,31 SAY cTIPO
               IF LEN(cRUA)>0 .AND. len(cTIPO)>2               
                 IF ASCAN(aTIT,cTIPO)>0                 
                    FIELD->RUA:=cRUA
                    FIELD->TIPO:=cTIPO                      
                 ENDIF
               ENDIF  
               IF LEN(cRUA)>1 .AND. len(cTIPO)<3 .AND. ! EMPTY(cTIPO)
                 nPOSCOD:=ASCAN(aCOD,cTIPO)
                 IF nPOSCOD>0                    
                    FIELD->RUA:=cRUA
                    FIELD->TIPO:=aTIT[nPOSCOD]                    
                 ENDIF
               ENDIF 
            ENDIF
            IF EMPTY(TIPO)
               nPOS:=RAT(" ",ALLTRIM(RUA))
               IF nPOS>0
                  cTIPO  :=ALLTRIM(SUBSTR(RUA,nPOS+1))
                  cRUA   :=ALLTRIM(SUBSTR(RUA,1,nPOS-1))
                  @ 24,50 Say LEFT(cRUA,19)
                  @ 24,70 SAY cTIPO
                  IF LEN(cRUA)>0 .AND. len(cTIPO)>2               
                    IF ASCAN(aTIT,cTIPO)>0
                       FIELD->RUA:=cRUA
                       FIELD->TIPO:=cTIPO  
                    ENDIF
                  ENDIF  
               ENDIF
            ENDIF
            cTIPO:=ALLTRIM(TIPO)
            IF len(cTIPO)<3.AND.! EMPTY(cTIPO)
               nPOSCOD:=ASCAN(aCOD,cTIPO)
               IF nPOSCOD>0                  
                  FIELD->TIPO:=aTIT[nPOSCOD]                  
               ENDIF
            ENDIF 
			nPOS:=AT(" ", ALLTRIM(FIELD->RUA)) //checar se só o tipo esta na rua e exemplo rua="AVENIDA" deixando em rua em  branco para próxima importação ajustar 
            IF nPOS=0
                Nposcod = ASCAN(aCOD,alLtrim(FIELD->RUA))
				if Nposcod>0 .AND. ALLTRIM(FIELD->RUA)=ALLTRIM(Acod[nPOSCOD])
                   FIELD->RUA:=""
                   FIELD->TIPO:=Atit[nPOSCOD]
				   cRUA:=""
                ENDIF
				 Nposcod = ASCAN(aTIT,alLtrim(FIELD->RUA))
				if Nposcod>0 .AND. ALLTRIM(FIELD->RUA)=ALLTRIM(ATIT[nPOSCOD])
                   FIELD->RUA:=""
                   FIELD->TIPO:=Atit[nPOSCOD]
				   cRUA:=""
                ENDIF
			ENDIF
			
			//TIPO = RUA deixando em rua em  branco para próxima importação ajustar
			IF ALLTRIM(FIELD->RUA)=ALLTRIM(FIELD->TIPO)
			   FIELD->RUA:=""
			ENDIF
			
            nPOS:=AT(",",FIELD->RUA)
            IF nPOS>0 .and. nPOS>3
			   FIELD->RUA:=SUBSTR(FIELD->RUA,1,nPOS-1)
            ENDIF
			
            nPOS:=AT("(",FIELD->RUA)
            IF nPOS>0 .and. nPOS>3
			   FIELD->RUA:=SUBSTR(FIELD->RUA,1,nPOS-1)
            ENDIF


            nPOS:=AT(" S/N",FIELD->RUA)
            IF nPOS>0 .and. nPOS>3
			   FIELD->RUA:=SUBSTR(FIELD->RUA,1,nPOS-1)
            ENDIF
            
            nPOS:=AT(LOWER("ull,"),FIELD->RUA)
            IF nPOS>0
			   FIELD->RUA:=""
            ENDIF
			
			//28/01/2021 11:08 checa se e um tipo valido se nao e limpa
			 IF ! empty(field->tipo)
				if ASCAN(aTIT,alltrim(field->tipo))=0 .and. ASCAN(acod,alltrim(field->tipo))=0
				   FIELD->TIPO:=""
				 endif
			ENDIF
			
			//31/01/201 21:59 opcao para apagar ceps com rua em branco
			if lAPAGASEMRUA .and. empty(field->rua) .and. empty(field->chvbai) //alguns ceps como prefeitura posto caixa postal nao tem rua mas tem bairro
			   dbdelete()
			endif
            DBUNLOCK()
            dbskip()
         enddo
         dbclosearea()
		 if lAPAGAMIL .or. lAPAGASEMRUA
			NETPACK(cFILECEP)
		ENDIF	
      endif
   next i
endif



IF MsgYesNo("Cruzar md10xmd10NAO")
   netuse("MD10")
   netuse("MD10NAO")
   dbselectar( "md10nao" )
    while ! eof()
        mNOME:=NOME
        mUF  :=UF
        lTEM:=.F.
        aCAMPOS:={"DDD","CODIBGE","CODTEL","NOMTEL","LATITUDE","LONGITUDE","HEMISFERIO"}
        aDADOS:={DDD,CODIBGE,CODTEL,NOMTEL,LATITUDE,LONGITUDE,HEMISFERIO}
        dbselectar("md10")
        if dbseek(mUF+mNOME)
           lTEM:=.T.
           netreclock()
           for x=1 to len(aCAMPOS)
               cCAMPO:=ACAMPOS[X]
               IF EMPTY(&cCAMPO.).AND.! EMPTY(aDADOS[X])                    
                  MD10->&cCAMPO.:=aDADOS[X]                    
               ENDIF
           next x
           dbunlock()
        endif        
        dbselectar( "md10nao" )
        IF lTEM
           netrecdel()
        ENDIF
        dbskip()
    enddo
   dbcloseall()
ENDIF

if MsgYesNo( "Gerar Log Duplicidades/Ajustes" )
   nAJUSTE:=35
   @ 24,00 SAY "Fator Checagem"
   @ 24,20 GET nAJUSTE
   READ
   nUSO := fcreate( "CONVCEP.TXT" )
   netuse("MD10")
   dbgotop()
   while !eof()
      @ 24, 00 say UF + NOME
      mNOME := alltrim( NOME )
      cANTERIOR:=INICEP+" "+UF + " " + NOME + HB_OSNEWLINE()
      cCEPANT:=INICEP
      dbskip()
      if !eof()
         if left(mNOME,nAJUSTE) = left(alltrim( NOME ),nAJUSTE)
               fwrite( nUSO, "CEP: 1_"+cANTERIOR)
               fwrite( nUSO, "CEP: 2_"+INICEP+" "+UF + " " + NOME + HB_OSNEWLINE())
               fwrite( nUSO ,""+HB_OSNEWLINE())
               if MsgYesNo("Apagar "+LEFT(cANTERIOR,40)+" "+UF+" "+NOME)
                  netrecdel()
               endif
         endif
      endif
   enddo


   //codibge
   dbsetorder( 3 )
   dbgotop()
   while !eof()
      @ 24, 00 say UF + NOME
      nSEQ := Codibge
      nRECOLD:=RECNO()
      IF ! EMPTY(CODIBGE)
         cUFCOD:=CODUF(CODIBGE,"UF")
         IF cUFCOD<>UF //Checagem 2 digitos inicial da codibge do estado
            fwrite( nUSO, "CodIBGE <> UF : "+Codibge + " " + UF +"<>"+cUFCOD + " " + NOME + +HB_OSNEWLINE())
         ENDIF
      ENDIF
      dbskip()
      if !eof()
         if nSEQ = CodIBGE
            if UF <> "XX" .and. ! empty(codibge)  //ibge duplicado
               fwrite( nUSO, "CODIBGE: "+CodiBGE + " " + UF + " " + NOME + +HB_OSNEWLINE() )
            endif
         endif
      endif
	  
   enddo
   

   //codirrf
   dbsetorder( 4 )
   dbgotop()
   while !eof()
      @ 24, 00 say UF + NOME
      nSEQ := Codirrf
      dbskip()
      if !eof()
         if nSEQ = Codirrf
            if UF <> "XX" .and. ! empty(codirrf) //irrf duplicado
               fwrite( nUSO, "IRRF: "+Codirrf + " " + UF + " " + NOME + +HB_OSNEWLINE() )
            endif
         endif
      endif
   enddo

   //ajustando ceps
   dbgotop()
   while !eof()
      @ 24, 00 say UF + NOME
      if empty( INICEP )
         netgrvcam("INICEP",repl( "0", 8 ))
      endif
      if empty( FIMCEP )
         netgrvcam("FIMCEP",repl( "0", 8 ))
      endif
	  if ! empty(hemisferio)
	     if hemisferio="N" .OR.  hemisferio="S"
		 else
		    netgrvcam("hemisferio","")
		 endif
	  endif
      dbskip()
   enddo
   dbclosearea()
   
   
   
   fclose( nUSO )
endif

IF MsgYesNo("Reindexar Arquivos Ruas")
   FOR X=1 TO 10000
       cARQRUA := "C" + strzero( X, 6 )
       @ 24,00 SAY cARQRUA
       IF file(cARQRUA+".DBF")
          NETPACK(cARQRUA)
          IF FERASE(cARQRUA+".CDX")=0 .OR. ! FILE(cARQRUA+".CDX")
             NETUSE(cARQRUA,,,,,.F.,)
             nLASTREC:=LASTREC()
             zei_fort( nLASTREC,,,0)
             index on RUA tag &cARQRUA.1 EVAL ZEI_FORT(nLASTREC,,,1)
             index on CEP tag &cARQRUA.2 EVAL ZEI_FORT(nLASTREC,,,1)
             DBCLOSEAREA()
          ENDIF
       ENDIF
   NEXT
ENDIF

IF MsgYesNo("Contar Cidades")
   @ 24, 00 say padr( "Importando cidades" )
   NETUSE("MD10")
   NETUSE("MD05")
   DBSELECTAR("MD10")
   DBGOTOP()
   WHILE ! EOF()
      nQTDECID:=0
      cUF = UF
      WHILE cUF=UF.AND.! EOF() //todos agora na MD1O sao M com codigo ibge 
             nQTDECID++
          @ 24,00 SAY UF+" "+NOME
          /* rodado apenas para ajuste 
          IF LEN(ALLTRIM(MD10->CODIRRF))=4 .AND. LEN(ALLTRIM(MD10->CODTSE))=5
             netreclock()
             MD10->CODIRRF:=MD10->CODTSE
             DBUNLOCK()
          ENDIF
          */
          DBSKIP()
      ENDDO
      DBSELECTAR("MD05")
      DBGOTOP()
      IF DBSEEK(cUF)
         netgrvcam("QTDECID",nQTDECID)
      ENDIF
      DBSELECTAR("MD10")
   ENDDO
   DBCLOSEALL()
ENDIF
IF MsgYesNo("Atualizar cidirrf")
   @ 24, 00 say padr( "atualizando cidirrf" )
   NETUSE("MD10")
   NETUSE("CIDIRRF")
   DBSELECTAR("MD10")
   DBGOTOP()
   WHILE ! EOF()
      cCODCID:=LEFT(MD10->CODIRRF,4)
      cCODIRRF:=MD10->CODIRRF
      cCODIBGE:=MD10->CODIBGE
      cNOMECID:=MD10->NOME
      DBSELECTAR("CIDIRRF")
      DBGOTOP()
      IF ! DBSEEK(cCODCID)
         netrecapp()
         CIDIRRF->CODCID:=cCODCID
      ELSE
         netreclock()
      ENDIF
      IF EMPTY(CIDIRRF->CODIRRF)
         CIDIRRF->CODIRRF:=cCODIRRF
      ENDIF
      IF EMPTY(CIDIRRF->CODIBGE)
         CIDIRRF->CODIBGE:=cCODIBGE
      ENDIF
      IF EMPTY(CIDIRRF->NOMECID)
         CIDIRRF->NOMECID:=cNOMECID
      ENDIF      
      dbunlock()
      DBSELECTAR("MD10")
      DBSKIP()
   ENDDO
   DBCLOSEALL()
ENDIF
IF MsgYesNo("Atualizar prcid")
   @ 24, 00 say padr( "atualizando prcid" )
   NETUSE("MD10")
   NETUSE("prcid")
   DBSETORDER(2)
   DBSELECTAR("MD10")
   DBGOTOP()
   WHILE ! EOF()
       IF MD10->UF="PR"
          cCODIRRF:=MD10->CODIRRF
          cCODIBGE:=MD10->CODIBGE
          cNOMECID:=alltrim(MD10->NOME)
          DBSELECTAR("prcid")
          DBGOTOP()
          IF ! DBSEEK(cNOMECID)
             netrecapp()
             prcid->MUNICIPIO:=cNOMECID
          ELSE
             netreclock()
          ENDIF
          IF EMPTY(prcid->CODIRRF)
             prcid->CODIRRF:=cCODIRRF
          ENDIF
          IF EMPTY(prcid->CODIBGE)
             prcid->CODIBGE:=cCODIBGE
          ENDIF
          dbunlock()
      ENDIF   
      DBSELECTAR("MD10")
      DBSKIP()
   ENDDO
   DBCLOSEALL()
ENDIF

return nil


function JasonCountry()

local kk
kk:=1   
 
netuse("PAISES")   
dbsetorder(2) //ISO3166B BRA
   
mArquivo := '*.json'
mListaArq := Directory(mArquivo,"D")
nFIMARQ:=LEN(mListaArq)   

For kk = 1 to nFIMARQ
     cFILECEP:=lower(mListaArq[kk,1])
     cXMl:=memoread(cFILECEP)
     
     
    cPOPULACAO  :=pegnodojason(cXMl,'"population":')
    cAREA       :=pegnodojason(cXMl,'"area":')
    cREGION     :=pegnodojason(cXMl,'"region":')
    cCONTINENT  :=pegnodojason(cXMl,'"subregion":')
    cMOEDA      :=pegnodojason(cXMl,'"currencies":')
    cISO3166A    :=pegnodojason(cXMl,'"alpha2":')
    cISO3166B    :=pegnodojason(cXMl,'"alpha3":')
    cddd        :=pegnodojason(cXMl,'"callingCodes":')
    cNOME       :=TRATANOME(pegnodojason(cXMl,'"nativeName":'),.F.,.T.,.T.)
    cnomeINT    :=TRATANOME(pegnodojason(cXMl,'"name":'),.F.,.T.,.T.)
    ccapital    :=TRATANOME(pegnodojason(cXMl,'"capital":'),.F.,.T.,.T.)
    cDOMINIO    :=pegnodojason(cXMl,'"tld":')
    
    dbselectar("paises")
    dbgotop()
    if ! dbseek(cISO3166B)
       netrecapp()
       field->ISO3166B:=cISO3166B
       field->UF:="XX"
    else
       netreclock()   
    endif
    netgrvz("NOMEINT",cNOMEINT,.f.)
    netgrvz("DDD",cDDD,.f.)
    netgrvz("NOME",cNOME,.f.)
    netgrvz("AREA",val(cAREA),.f.)
    netgrvz("CONTINENT",cCONTINENT,.f.)
    netgrvz("ISO3166A",cISO3166A,.f.)
    netgrvz("capital",ccapital,.f.)
    netgrvz("URLPAIS",cDOMINIO,.f.)
    netgrvz("CONTREGIAO",cREGION,.f.)
    netgrvz("MOEDA",cMOEDA,.f.)
    
    dbunlocK()
    ferase(cFILECEP)
next kk
return .t.  

function pegnodojason(cTEXTO,cNODO) //difeRente pegnodojason webcep pois aqui o nodo pode ter listas entre []
LOCAL nPOSNODO
nPOSNODO:=AT(cNODO, cTEXTO)
IF nPOSNODO>0
  cTEXTO        := SUBSTR( cTEXTO , nPOSNODO +  LEN(cNODO) ) // LEN(cNODO)+1
  DO CASE
    CASE SUBSTR(cTEXTO,1,1)='"'
       cTEXTO        := SUBSTR(cTEXTO,2) //"BRA"
       CTEXTO        := SUBSTR( cTEXTO ,1, AT( '"'   , cTEXTO)  -1 )
    CASE SUBSTR(cTEXTO,1,1)='['
       cTEXTO        := SUBSTR(cTEXTO,3) //"[BRL]"
       CTEXTO        := SUBSTR( cTEXTO ,1, AT( ']'   , cTEXTO)  -2 )
    CASE SUBSTR(cTEXTO,1,1) $   '0123456789'
       cTEXTO        := SUBSTR(cTEXTO ,1, AT(",",cTEXTO) -1)
  ENDCASE
ENDIF  
nPOSNODO:=AT( '",',cTEXTO)
IF nPOSNODO>0 //nodos com mais de um exemplo dominio pega o primeiro
   cTEXTO:=SUBSTR(cTEXTO,1,nPOSNODO-1)
ENDIF
IF AT("{",cTEXTO)>0 //zera nodos invalidos
   cTEXTO:=""
ENDIF
RETURN cTEXTO

function help
retu .t.

function cidconvinc()
LOCAL cALIAS,lRETU:=.F.
cALIAS:=ALIAS()
dbselectar("cidconv")
dbgotop()
if ! dbseek(mUF+mNOME)
   netrecapp()
   FIELD->ESTADO:=mUF         
   FIELD->CIDORI:=mNOME         
   FIELD->ESTDES:=mUF         
   FIELD->CIDDES:=mCIDDES
   lRETU:=.T.
ENDIF
DBSELECTAR(cALIAS)
RETURN lRETU


*+ EOF: CONVCEP.PRG


