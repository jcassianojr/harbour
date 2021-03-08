

CABE2('Sincronizar Arquivo')
nMESINI:=1
nMESFIM:=12
@ 22,00 say "Ano  MesIni MesFim"
cANO:=STRZERO(YEAR(DATE())-1,4)
@ 23,00 GET cano
@ 24,05 GET nMESINI PICT "99"
@ 24,10 GET nMESFIM PICT "99"
READcur()
carq:="RAIS"+CANO
cARQTXT:=cARQ+".txt"
cCGCUSO:=TIRAOUT(zCGC)


IF ! netuse("fo_pes") 
   RETU
ENDIF
ordDestroy("temp")
ordcreate(,"temp","PIS+DTOS(ADMITIDO)") 
ordSetFocus("temp")



IF ! NETUSE("FORAIS") 
   DBCLOSEALL()
   RETU .F.
ENDIF
if mdg("Apagar Importacao anterior")
   delete all for ano=val(cANO)   
endif

IF ! netuse(cARQ,,.F.,,,.F.,)
   dbcloseall()
   RETU .F.
ENDIF    
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
if file(carqTXT) .and. mdg("Importar txt")
   ZAP 
   append from &carqTXT. SDF 
endif


dbselectar(cARQ)
dbgotop()
while ! eof()    
    @ 24,00 SAY SPACE(50)
    IF FIELD->TIPOREG="2" .AND. cCGCUSO=FIELD->CGC           
       mADMITIDO=CTOD(SUBSTR(ADMISSAO,1,2)+"/"+SUBSTR(ADMISSAO,3,2)+"/"+SUBSTR(ADMISSAO,5))    
       mPIS=PIS    
       cBUSCA:=mPIS+DTOS(mADMITIDO) 
       mPIS=PIS
       mNOME=NOME
       mNASC=CTOD(SUBSTR(NASCTO,1,2)+"/"+SUBSTR(NASCTO,3,2)+"/"+SUBSTR(NASCTO,5))
       mNACION=NACIO   
       mNACPAIS:=""
       IF mNACION=10
          mNACPAIS:="1058"
       ELSE
          mNACPAIS:=OBTER( "FO_TAB",,"NACI"+ALLTRIM(STR(mNACION)), "CODIG2")
       ENDIF   
       mANONASCI=CHEGADA
       MESCOLA=STRZERO(INSTRU,2)
       IF mESCOLA="10"
          mESCOLA:="11"
       ENDIF
       IF mESCOLA="11"
          mESCOLA:="12"
       ENDIF
       mCPF=CPF
       MPROFIS=IF(left(TIRAOUT(CPF),7)=PROFIS,LEFT(TIRAOUT(CPF),7),PROFIS) //CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
       MSERIE=IF(left(TIRAOUT(CPF),7)=PROFIS,SUBSTR(TIRAOUT(CPF),8),SERIE)
       mADMITIDO=CTOD(SUBSTR(ADMISSAO,1,2)+"/"+SUBSTR(ADMISSAO,3,2)+"/"+SUBSTR(ADMISSAO,5))
       mTIPO=TIPOHOR
       IF VAL(CANO)<2001
          mTIPOADM=""
       ELSE
          mTIPOADM=TIPOADM
       ENDIF
       mHRSEM=HORASMES
       mCBONEW=""              
       IF VAL(CANO)>=2004       
          mCBONEW=CBO
       ENDIF
       mRAISVINC=VINCULO
       mRAISDEM=MOTDEM
       mDEMITIDO=CTOD(SUBSTR(DATADEM,1,2)+"/"+SUBSTR(DATADEM,3,2)+"/"+CANO)
       IF VAL(CANO)<1997
          mRAISDEM="00"
          mDEMITIDO=SPACE(8)
       ENDIF
       IF VAL(CANO)<2001
          mRACS=""
          mDEFICI=""
		  Mtipodefi:=""
          mALVARA=""
          mSEXO=""
       ELSE
          mRACS=OBTER( "FO_TAB",,"RACA"+ALLTRIM(RACA),"CODIG2")
          mDEFICI=DEFICIENTE
		  Mtipodefi:=TIPODEFI
          mALVARA=ALVARA
          mSEXO=SEXO
          IF mSEXO="1"
             mSEXO="M"
          ELSE
             mSEXO="F"
          ENDIF
          IF mALVARA="1"
             mALVARA="S"
          ELSE
             mALVARA="N"
          ENDIF
       ENDIF
       DO CASE
         CASE mTIPO="1"
              Mtipo:="M"
         CASE mTIPO="2"
              Mtipo:="Q"
         CASE mTIPO="3"
              Mtipo:="S"
         CASE mTIPO="4"
              Mtipo:="D"
         CASE mTIPO="5"
              Mtipo:="H"
         CASE mTIPO="6"
              Mtipo:="T"
         CASE mTIPO="7"
              Mtipo:="O"           
      ENDCASE          
      
      dbselectar("fo_pes")
      dbgotop()
      IF dbseek(cBUSCA) //cBUSCA:=mPIS+DTOS(mADMITIDO)
         mNUMERO:=NUMERO         
         @ 24,00 SAY mNUMERO
         @ 24,10 SAY NOME
          netreclock()
          IF EMPTY(NOME)
             FIELD->NOME:=MNOME
          ENDIF
          IF EMPTY(NASC)
             FIELD->NASC:=mNAsc
          ENDIF
          IF EMPTY(anonasci)
             FIELD->anonasci:=manonasci
          ENDIF
          IF EMPTY(escRAIS)
             FIELD->escRAIS:=mescola
          ENDIF
          IF EMPTY(cpf)
             FIELD->cpf:=mcpf
          ENDIF
          IF val(profis)=0 
             FIELD->profis:=mprofis
          ENDIF
          IF val(serie)=0 
             FIELD->serie:=mserie
          ENDIF
          IF EMPTY(tipo).AND.! EMPTY(mTIPO)
             field->tipo:=mtipo
          ENDIF
          IF EMPTY(hrsem)
             FIELD->hrsem:=mhrsem
          ENDIF
          IF EMPTY(NASCPAIS ).AND.! EMPTY(mNACPAIS)
             FIELD->NASCPAIS :=mNACPAIS
          ENDIF       
          IF EMPTY(RACS).AND.! EMPTY(mRACS)
             FIELD->RACS:=MRACS
          ENDIF
          //IF (EMPTY(DEFICI) .AND. ! EMPTY(mDEFICI)) .OR. DEFICI="S" .OR. DEFICI="N"
          //   FIELD->DEFICI:=mDEFICI
          //ENDIF
		  
          if val(mDEFICI)=1 .and. val(Mtipodefi)>0		  //deficiente 1 sim 2 nao //grava tipo deficiente
		     FIELD->DEFICI:=mDEFICI
		  endif
		  
          if val(mDEFICI)=2  //deficiente 2 nao  zera campo alguns esta gravando 2 que e o tipo de deficiente e nao se e deficiente
		     FIELD->DEFICI:=""
		  endif
		  
		  
          IF EMPTY(SEXO).AND.! EMPTY(mSEXO)
             FIELD->SEXO:=mSEXO
          ENDIF
          IF MRAISDEM<>"00"
             IF EMPTY(demitido)
                FIELD->demitido:=mdemitido
             ENDIF
          ENDIF
          IF EMPTY(E1ADM).AND.! EMPTY(mTIPOADM)    
             IF mTIPOADM="1"          
               FIELD->E1ADM="S"
             ENDIF
             IF mTIPOADM="2".OR.mTIPOADM="4"                                              
                FIELD->E1ADM="N"
             ENDIF    
          ENDIF            
         DO CASE
         	CASE mraisvinc="10"  //funcionario
                 IF EMPTY(FO_PES->EVINC)
                    FO_PES->EVINC:="101"
                 ENDIF
                 IF EMPTY(FO_PES->CATEGORIA)
                    FO_PES->CATEGORIA:="01"
                 ENDIF
         	CASE mraisvinc="50" //temporario
                 IF EMPTY(FO_PES->EVINC)
                    FO_PES->EVINC:="105"
                 ENDIF
         	CASE mraisvinc="55"  //aprendiz
                 IF EMPTY(FO_PES->EVINC)
                    FO_PES->EVINC:="103"
                 ENDIF
                 IF EMPTY(FO_PES->CATEGORIA)
                    FO_PES->CATEGORIA:="07"
                 ENDIF
         	CASE mraisvinc="80"//Diretor
                IF EMPTY(FO_PES->EVINC)
                    FO_PES->EVINC:="722"
                 ENDIF
                 IF EMPTY(FO_PES->CATEGORIA)
                    FO_PES->CATEGORIA:="11"
                 ENDIF  		        
         ENDCASE          
          DBUNLOCK()
		  eBUSCA:=cANO+STR(mNUMERO,8)
          dbselectar("forais")
          dbgotop()
          if dbseek(eBUSCA)
             netreclock()
          ELSE
             netrecapp()
             FORAIS->NUMERO:=mNUMERO             
			 FORAIS->ANO   :=VAL(cANO)
          ENDIF          
          IF EMPTY(FORAIS->NOME)
             FORAIS->NOME:=mNOME
          ENDIF
          IF EMPTY(FORAIS->RAISVINC)
             FORAIS->RAISVINC:=mraisvinc
          ENDIF
          IF MRAISDEM<>"00"
             IF EMPTY(FORAIS->raisdem)
                FORAIS->raisdem:=mraisdem
             ENDIF
          ENDIF
          IF EMPTY(FORAIS->ALvara).AND.! EMPTY(mALVARA)
             FORAIS->alvara:=mALVARA
          ENDIF
          IF EMPTY(FORAIS->tipoadm).AND.! EMPTY(mTIPOADM)
             FORAIS->tipoadm:=mtipoadm
          ENDIF     
          aMESES:={"JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ"}
          FOR X=1 TO 12
              cCAMPO:='RAIZ'+aMESES[X]
              cSAL  :='SAL'+STRZERO(X,2)
              IF X>=nMESINI .AND. X<=nMESFIM
                 FORAIS->&cCAMPO.:=VAL((Carq)->&cSAL.)/100
              ENDIF   
          NEXT X
          IF VAL((Carq)->SAL13AM)>=NMESINI .AND. VAL((Carq)->SAL13AM)<=NMESFIM
             FORAIS->SAL13_1:=VAL((Carq)->SAL13A)/100
             FORAIS->MES_1  :=VAL((Carq)->SAL13AM)
          ENDIF   
          IF VAL((Carq)->SAL3BM)>=NMESINI .AND. VAL((Carq)->SAL3BM)<=NMESFIM
             FORAIS->SAL13_2:=VAL((Carq)->SAL13B)/100
             FORAIS->MES_2  :=VAL((Carq)->SAL3BM)
          ENDIF
         FORAIS->RAIZAVI:=VAL((Carq)->AVISO)/100          
         FORAIS->RAIZFER:=VAL((Carq)->RAIZFER)/100         
         FORAIS->RAIZACR:=VAL((Carq)->RAIZACR)/100         
         FORAIS->RAIZGRA:=VAL((Carq)->RAIZGRA)/100         
         FORAIS->RAIZMUL:=VAL((Carq)->RAIZMUL)/100         
         FORAIS->RAIZBCH:=VAL((Carq)->RAIZBCH)/100         
         FORAIS->MESBCH :=(Carq)->MESBCH         
         FORAIS->MESACR :=(Carq)->MESACR         
         FORAIS->MESGRA :=(Carq)->MESGRA         
         FORAIS->IBGECOD:=(Carq)->IBGECOD   
         FORAIS->CODAFA01:=(Carq)->MOTAFA01 
         FORAIS->INIAFA01:=(Carq)->DATIAFA01         
         FORAIS->FIMAFA01:=(Carq)->DATFAFA01         
         FORAIS->CODAFA02:=(Carq)->MOTAFA02         
         FORAIS->INIAFA02:=(Carq)->DATIAFA02         
         FORAIS->FIMAFA02:=(Carq)->DATFAFA02        
         FORAIS->CODAFA03:=(Carq)->MOTAFA03         
         FORAIS->INIAFA03:=(Carq)->DATIAFA03         
         FORAIS->FIMAFA03:=(Carq)->DATFAFA03        
         FORAIS->DIASAFA :=(Carq)->QTDIAS         
         aMESES:={"JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ"}
         FOR X=1 TO 12
              cCAMPO:='HOR'+aMESES[X]              
              IF X>=nMESINI .AND. X<=nMESFIM
			     IF VALTYPE((Carq)->&cCAMPO.)='N'
                    FORAIS->&cCAMPO.:=(Carq)->&cCAMPO.
			     ELSE
                    FORAIS->&cCAMPO.:=VAL((Carq)->&cCAMPO.)
                 ENDIF				 
              ENDIF   
          NEXT X
          aMESES:={"SOC1","SOC2","SIN","ASS","CON"}
          FOR X=1 TO 5
              cCAMPO:='CGC'+aMESES[X]
              cSAL  :='VAL'+aMESES[X]
              IF VAL((Carq)->&cSAL.)>0
                 FORAIS->&cSAL.:=VAL((Carq)->&cSAL.)/100
                 FORAIS->&cCAMPO.:=(Carq)->&cCAMPO.
              ENDIF   
          NEXT X 
         dbunlock()                            
      endif        
      
   ENDIF   
   dbselectar(cARQ)   
   dbskip()
   zei_fort(nLASTREC,,,1)
enddo
dbcloseall()

         //FORAIS->RAIZJAN:=VAL((Carq)->SAL01)/100
         //FORAIS->RAIZFEV:=VAL((Carq)->SAL02)/100
         //FORAIS->RAIZMAR:=VAL((Carq)->SAL03)/100
         //FORAIS->RAIZABR:=VAL((Carq)->SAL04)/100
         //FORAIS->RAIZMAI:=VAL((Carq)->SAL05)/100
         //FORAIS->RAIZJUN:=VAL((Carq)->SAL06)/100
         //FORAIS->RAIZJUL:=VAL((Carq)->SAL07)/100
         //FORAIS->RAIZAGO:=VAL((Carq)->SAL08)/100
         //FORAIS->RAIZSET:=VAL((Carq)->SAL09)/100
         //FORAIS->RAIZOUT:=VAL((Carq)->SAL10)/100
         //FORAIS->RAIZNOV:=VAL((Carq)->SAL11)/100
         //FORAIS->RAIZDEZ:=VAL((Carq)->SAL12)/100         
//         FORAIS->HORJAN :=(Carq)->HORJAN         
//         FORAIS->HORFEV :=(Carq)->HORFEV         
//         FORAIS->HORMAR :=(Carq)->HORMAR   
//         FORAIS->HORABR :=(Carq)->HORABR   
//         FORAIS->HORMAI :=(Carq)->HORMAI   
//         FORAIS->HORJUN :=(Carq)->HORJUN   
//         FORAIS->HORJUL :=(Carq)->HORJUL   
//         FORAIS->HORAGO :=(Carq)->HORAGO   
//         FORAIS->HORSET :=(Carq)->HORSET   
//         FORAIS->HOROUT :=(Carq)->HOROUT   
//         FORAIS->HORNOV :=(Carq)->HORNOV   
//         FORAIS->HORDEZ :=(Carq)->HORDEZ   
//         FORAIS->CGCSOC1 :=(Carq)->CGCSOC1  
//         FORAIS->VALSOC1 :=VAL((Carq)->VALSOC1)/100                
//         FORAIS->CGCSOC2 :=(Carq)->CGCSOC2  
//         FORAIS->VALSOC2 :=VAL((Carq)->VALSOC2)/100                    
//         FORAIS->CGCSIN  :=(Carq)->CGCSIN   
//         FORAIS->VALSIN  :=VAL((Carq)->VALSIN)/100                     
//         FORAIS->CGCASS  :=(Carq)->CGCASS   
//         FORAIS->VALASS  :=VAL((Carq)->VALASS)/100                     
//         FORAIS->CGCCON  :=(Carq)->CGCCON   
//         FORAIS->VALCON  :=VAL((Carq)->VALCON)/100            
