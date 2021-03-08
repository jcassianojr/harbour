*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    FOPTO_37.PRG
*+
*+    Functions: Function FOPTO37()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн


//Teclas Operacionais
////#INCLUDE "COMANDO.CH"
#INCLUDE "INKEY.CH"

CABE2( "FOPTO_37 - Analise do Ponto" )

dDATAINI := zdataini
dDATAFIM := zdatafim
cPN := "PN" + ANOMESW
cPNA:= "PN" + right(STRZERO(nANOANT,4),2) + strzero(NMESANT,2)
cPE := "PE" + ANOMESW

MDS( "Digite o Periodo ") 
@ 24, 40 get dDATAINI
@ 24, 50 get dDATAFIM
if ! READCUR()
   retu .F.
endif

FOPTO37()

PADRAO( "FOPTOATR", "FOPTOATR", "STR(mNUMERO,6)+' '+left(mNOME,25)+' '+DTOC(mDATA)+' '+mCODANL+' '+mCOD+' '+mSOD+' '+mBCOSN+' '+STR(mRENT,5,2)+' '+STR(mENT,5,2)+' '+STR(mRSAI,5,2)+' '+STR(mSAI,5,2)", "STR(mNUMERO,8)+DTOS(mDATA)+mCODANL", ;
        "Atraso/Faltas/Saida", ;
        "Numero Nome                      Data    ERR CO SO BH Entr Ent  Said  Sai", ;
        { || alltrue() }, { || alltrue() }, { || gFOPTO37() }, { || ALLTRUE() },.T., 2 )
        
IF ZFECHADO="S"   
   ALERTX("Mъs jс fechado nуo sera feito lanчamentos")
   RETURN
ENDIF     
lLAN11:=MDG("Lancar 11")
lLAN35:=MDG("Lancar 35")
lLAN24:=MDG("Lancar 24")
IF ! lLAN11.AND. ! lLAN35.AND. ! lLAN24
   RETURN
ENDIF

cPX := "PX" + ANOMESW
CHECKCRI( cPX, "FO_PDES", "STR(NUMERO,8)+DTOS(DATA)+STR(CONTA,2)" )
if ! netuse("foptoatr")
   return
endif
if ! netuse(cPX)   
   dbcloseall()
   return
endif
dbselectar(cPX)
initvars()
clrvars()
dbselectar("foptoatr")
dbgotop()
while ! eof()
   IF (CODANL="11".and.llan11).or.(CODANL="35".and.llan35).or.(CODANL="24".and.llan24)
     mNUMERO:=NUMERO
     mDATA:=DATA
     mCONTA:=1                    
     mHORAS:=HORXXX
     mOBS  :=OBSATR
     dbselectar(cPX)
     dbgotop()
     if ! dbseek(STR(mNUMERO,8)+DTOS(mDATA)+STR(mCONTA,2))
        netrecapp()
        replvars()      
     endif
   endif  
   dbselectar("foptOatr")
   dbskip()
enddo
dbcloseall()
retuRN

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function FOPTO37()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function FOPTO37

//Pegando Eventos
aEVED := {}
aEVEC := {}
aEVEB := {}
PegFeriados()


aFTB:={}
IF ! NETZAP("foptoatr")
   retu .f.
endif

if ! NETUSE("FOPTOCON")
   retu .F.
endif
if ! dbseek(nremp)
   dbgotop()
endif
ZTOL01 := TOL01
ZTOL02 := TOL02
ZTOL03 := TOL03
ZTOL04 := TOL04
ZTOL05 := TOL05
dbcloseall()

if ! netuse("foptoatr")
    retu .f.
endif
if ! NETUSE("FO_RELHR")
   dbcloseall()
   retu .F.
endif
if ! NETUSE("FOPTOHRE")
   dbcloseall()
   retu .F.
endif
if !  NETUSE(PES) 
   dbcloseall()
   retu .F.
endif
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
FILTRO := FILTRO( FILTRO )
set filter to &FILTRO
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)

if ! netuse(cPN)
   dbcloseall()
   retu .F.
endif

if ! netuse(cPNA)
   dbcloseall()
   retu .F.
endif

if ! netuse("TABFALTA")
   dbcloseall()
   retu .F.
endif

if ! NETUSE(cPE)
   dbcloseall()
   retu
endif

cPD := "PD" + ANOMESW
cPP := "PP" + ANOMESW
cPA := "PA" + ANOMESW
if ! NETUSE(cPD)
  dbcloseall()
  retuRN 0
endif
if ! NETUSE(cPP)
   dbcloseall()
   retuRN 0
endif
if ! NETUSE(cPA)
   dbcloseall()
   retuRN 0
endif
   
   
dbselectar( PES )
dbgotop()
while !eof()
   petela(5)
   mNUMERO  := NUMERO
   mPIS     := PIS
   mNOME    := NOME
   mGRUPO   := "  "
   mTURNO   := " "
   mSITUACAO:=SITUACAO
   lREVESAR := .F.
   lESCALA  := .F.
   aFOLGA   :={}
   aREF     :={}
   nSAIANT  :=0
   cCODANT  := ""
   dbselectareA( cPNA )
   dbgotop()
   IF dbseek( str( mNUMERO, 8 ) + dtos(dDATAINI-1) )
      nSAIANT  :=SAI
      cCODANT  :=COD
   endif
   if empty(nSAIANT)
      dbselectareA( cPN )
      dbgotop()
      IF dbseek( str( mNUMERO, 8 ) + dtos(dDATAINI-1) )
         nSAIANT  :=SAI
         cCODANT  :=COD
      endif
   endif
   PEGHORFIX(mNUMERO)
   dbselectar( cPN )
   dbgotop()
   dbseek( str( mNUMERO, 8 ) + dtos(dDATAINI) )
   while mNUMERO=NUMERO.AND.! EOF()
//      dIAX := DATA
      mDATA := DATA
      nDOW  := DOW(DATA)
      IF DATA>=dDATAINI.and.data<=dDATAFIM 
          lESC:=.F.
          aMSGERRO:={}
          RENT    := 0
          RALS    := 0
          RALE    := 0
          RSAI    := 0
          lESCALA := .F.
          lESCFOL := .F.
          if !empty( mGRUPO ) .and. mTURNO = "S"          //Reveza e tem escala
             mESCALA := mGRUPO + dtos( DATA )
             dbselectar( cPE )
             dbgotop()
             if dbseek( mESCALA )
                RENT :=  ENTREV
                RALS :=  ALIREV
                RALE :=  ALSREV
                RSAI :=  SAIREV
                lESCALA := .T.
                IF FOLGASN="S"
                   lESCFOL := .T.
                ENDIF
             else
                lESC:=.T.
                AADD(aMSGERRO,{"FE","Falta Escala",0})
             endif
          else                                          //Horario Fixo
             nDOW  := DOW(DATA)
             if empty( aREF[ nDOW, 1 ] ) //tOdos dia da semana mesmo horario
                 RENT := aREF[ 8, 1 ]
                 RALS := aREF[ 8, 2 ]
                 RALE := aREF[ 8, 3 ]
                 RSAI := aREF[ 8, 4 ]
              else                        //dia da semana com outro horario
                 RENT := aREF[ ndow, 1 ]
                 RALS := aREF[ ndow, 2 ]
                 RALE := aREF[ ndow, 3 ]
                 RSAI := aREF[ ndow, 4 ]
              endif
          endif
          dbselectar( cPN )
          
          peghorflex()
          
          lNESC := !lESCALA
          DO    := COD = "DO" .OR. SOD = "DO"      //codigo=domingo
          lFOL  := ( COD="FO" .or.( aFOLGA[ nDOW ] = "S".and.Lnesc)) .and. empty( CODREV ) .or. ( FOLSN = "S" ).OR.(lESCFOL)
    
    
          lLISTA:=.T.
          IF ENT<=(IF(ENTREV>0,ENTREV,RENT)+ ZTOL01) //entrou no trabalhar no normal ou correcao de horario
             lLISTA:=.F.
          ENDIF
    
          lSAI:=.F.
          IF (sai- ZTOL04)<(IF(SAIREV>0,SAIREV,RSAI)).AND.! lFOL.AND.ENT>0.AND.SAI>0  //Saiu antes do horario
             AADD(aMSGERRO,{"SA","Saida Antecipada",0})
             lSAI:=.T.
          ENDIF
    
          IF COD="DO".OR.SOD="DO".AND.EMPTY(ENT).AND.EMPTY(RENT) //domingo
             lLISTA:=.F.
          ENDIF
          IF COD="SA".OR.SOD="SA".AND.EMPTY(ENT).AND.EMPTY(RENT) //sabado
             lLISTA:=.F.
          ENDIF
          IF COD="FO".OR.SOD="FO".AND.EMPTY(ENT).AND.EMPTY(RENT) //folga
             lLISTA:=.F.
          ENDIF
          IF COD="FN".OR.SOD="FN".AND.EMPTY(ENT) //ferias
             lLISTA:=.F.
          ENDIF
          IF COD="AF".OR.SOD="AF".AND.EMPTY(ENT) //Afastado
             lLISTA:=.F.
          ENDIF
          IF COD="FE".OR.SOD="FE".AND.EMPTY(ENT) //feriado
             lLISTA:=.F.
          ENDIF
          IF COD="BH".OR.SOD="BH".AND.EMPTY(ENT) //banco de horas
             lLISTA:=.F.
          ENDIF
          IF COD="RH".OR.SOD="RH".AND.EMPTY(ENT) //reducao de horario
             lLISTA:=.F.                         //sem jornada
          ENDIF
          
          //Nao Listas Saida
          IF COD="DO".OR.SOD="DO".AND.EMPTY(SAI).AND.EMPTY(RSAI) //domingo
             lSAI:=.F.
          ENDIF
          IF COD="SA".OR.SOD="SA".AND.EMPTY(SAI).AND.EMPTY(RSAI) //sabado
             lSAI:=.F.
          ENDIF
          IF COD="FO".OR.SOD="FO".AND.EMPTY(SAI).AND.EMPTY(RSAI) //folga
             lSAI:=.F.
          ENDIF
          IF COD="FN".OR.SOD="FN".AND.EMPTY(SAI) //ferias
             lSAI:=.F.
          ENDIF
          IF COD="AF".OR.SOD="AF".AND.EMPTY(SAI) //Afastado
             lSAI:=.F.
          ENDIF
          IF COD="FE".OR.SOD="FE".AND.EMPTY(SAI) //feriado
             lSAI:=.F.
          ENDIF
          IF COD="BH".OR.SOD="BH".AND.EMPTY(SAI) //banco de horas
             lSAI:=.F.
          ENDIF
          IF COD="RH".OR.SOD="RH".AND.EMPTY(SAI) //reducao de jornada
             lSAI:=.F.
          ENDIF
    
    
         lEXT:=.F.
         EH:=.F.     //Exedeu horario para extra
         IH:=.F.     //Iniciou HoraRio para extra
         IF ZTOL05>0
           IF SAI>0.AND.RSAI>0
              EH  := CHOR(SAI) - CHOR(RSAI) > ZTOL05     //Exedeu horario para extra
              nEXTRA:=CHOR(SAI) - CHOR(RSAI)
              IF EH .and.! lFOL
                 IF nEXTRA>2
                    AADD(aMSGERRO,{"EJ","Excedeu Jornada > 2 horas",0})
                 ELSE
                    AADD(aMSGERRO,{"EJ","Excedeu Jornada",0})
                 ENDIF                 
              ENDIF
           ENDIF
           IF RENT>0.AND.ENT>0
              IH  := CHOR(RENT) - CHOR(ENT) > ZTOL05     //Iniciou Horaio para extra
              nEXTRA:= CHOR(RENT) - CHOR(ENT)
              IF IH.and.! lFOL
                 IF nEXTRA>2
                    AADD(aMSGERRO,{"IA","Iniciou antecipadamente > 2 horas",0})
                 ELSE 
                    AADD(aMSGERRO,{"IA","Iniciou antecipadamente",0})
                 ENDIF   
              ENDIF
           ENDIF
         ENDIF
         IF EXTSN="T"
            EH:=.T.
         ENDIF
         IF EH.OR.IH
            lEXT:=.T.
         ENDIF
    
         if !empty( ALE ) .and. empty( ALS )
             AADD(aMSGERRO,{"ER","Entrada sem Saida Intervalo Refeicao",0})
         endif
         if !empty( ALS ) .and. empty( ALE )
            AADD(aMSGERRO,{"SR","Saida sem Entrada Intervalo Refeicao",0})
         endif
         if !empty( ENT ) .and. empty( SAI )
            AADD(aMSGERRO,{"ES","Entrada Sem Saida",0})
         endif
         if !empty( SAI ) .and. empty( ENT )
            AADD(aMSGERRO,{"SE","Saida Sem Entrada",0})
         endif
         
          IF ! EMPTY(mSITUACAO) .AND. (!empty( ENT ) .OR. !empty( SAI ) )
            AADD(aMSGERRO,{"SI","Funcionario em situacao: "+mSITUACAO+" marcou o ponto",0})            
         ENDIF

         IF (COD="FN".OR.SOD="FN") .AND. (!empty( ENT ) .OR. !empty( SAI ) )
            AADD(aMSGERRO,{"FN","Funcionario em Ferias FN marcou o ponto",0})            
         ENDIF
         
         
         
         
         if (COD="SA" .OR. SOD="SA").AND. nDOW<>7
            AADD(aMSGERRO,{"S?","Codigo SA sem ser sabado",0})
         endif

         if (COD="DO" .OR. SOD="DO") .AND. nDOW<>1
            AADD(aMSGERRO,{"D?","Codigo DO sem ser domingo",0})
         endif
         
          IF (COD="FE" .OR. SOD="FE") .AND. ASCAN(aEVED, str( DAY(mDATA), 2 ) + str( MONTH(mDATA), 2 ) )=0
            AADD(aMSGERRO,{"F?","Codigo FE sem feriado cadastrado",0})
         ENDIF
         
    
          nHORA11:=0
          IF ! EMPTY(nSAIANT).AND.! EMPTY(ENT).AND.ENT<=SAI //.AND.! lFOL
             nHORA11:=24-CHOR(nSAIANT)
             nHORA11+=CHOR(ENT)
             IF nHORA11<11
                cMSGERRO:="Saida:"+STR(nSAIANT,5,2)+" Retorno:"+STR(ENT,5,2)+" com menos de 11 horas Diferenca="+STR(11-nHORA11,5,2)
                AADD(aMSGERRO,{"11",cMSGERRO,11-nHORA11})
             ENDIF
          ENDIF

          nHORA24:=0
          IF ! EMPTY(nSAIANT).AND.! EMPTY(ENT).AND.ENT<=SAI.AND.cCODANT="DO" //.AND.! lFOL
             nHORA24:=24-CHOR(nSAIANT)
             nHORA24+=CHOR(ENT)
             IF nHORA24<24
                cMSGERRO:="Saida:"+STR(nSAIANT,5,2)+" Retorno:"+STR(ENT,5,2)+" com menos de 24 horas DE Folga="+STR(24-nHORA24,5,2)
                AADD(aMSGERRO,{"24",cMSGERRO,24-nHORA24})
             ENDIF
          ENDIF
          
          

          IF ENT>0.AND.SAI>0.AND.(COD="FE".or.SOD="FE")
             nEXTRA:= CHOR(ENT) - CHOR(SAI)
             IF nEXTRA>8
                AADD(aMSGERRO,{"EF","Extra no Feridado >8 horas",0})
             ELSE
                AADD(aMSGERRO,{"EF","Extra no Feridado",0})
             ENDIF   
          ENDIF   
    
    
          IF lFOL.AND.ENT>0.AND.SAI>0.AND.(COD="DO".or.COD="SA".OR.COD="FO")
             nEXTRA:= CHOR(ENT) - CHOR(SAI)
             IF nEXTRA>8
                AADD(aMSGERRO,{"FT","Folga Trabalhada >8 Horas",0})
             ELSE
                AADD(aMSGERRO,{"FT","Folga Trabalhada",0})
             ENDIF   
             mDT:=mDATA
             IF DOW(mDT)=1
                mDT++
             ENDIF
             IF DOW(mDT)=7
                mDT+=2
             ENDIF
             IF ASCAN(aFTB,STR(mNUMERO,8)+DTOS(mDT))=0                
                AADD(aFTB,STR(mNUMERO,8)+DTOS(mDT))
             ENDIF   
          ENDIF
          
          nPASSAGENS:=VERPASSAGENS(mNUMERO,DATA,.f.,.F.,mPIS)
          IF nPASSAGENS>1 .AND. INT(nPASSAGENS/2)<>nPASSAGENS/2
             AADD(aMSGERRO,{"PI","Passagens impares Favor descartar desnecessarias",0})
          ENDIF
          dbselectar( cPN )
    
          IF len(aMSGERRO)>0
               aVAL:={RSAI,SAI,RENT,ENT,COD,SOD,DATA,BCOSN}
               //      1    2    3   4   5   6   7    8
               for i:=1 to len(aMSGERRO)
                 dbselectar("foptoatr")
                 netrecapp()
                 foptoatr->numero:=mNUMERO
                 foptoatr->nome:=mNOME
                 foptoatr->data:=AvaL[7]
                 foptoatr->ent:=aVAL[4]
                 foptoatr->rent:=AVAL[3]
                 foptoatr->rsai:=aVAL[1]
                 foptoatr->sai:=AVAL[2]
                 foptoatr->COD:=aVAL[5]
                 foptoatr->SOD:=AVAL[6]
                 foptoatr->bcosn:=aval[8]
                 foptoatr->codanl:=aMSGERRO[I,1]
                 foptoatr->obsatr:=aMSGERRO[I,2]
                 foptoatr->HORXXX:=aMSGERRO[I,3]
              next
          ENDIF
      endif      
      dbselectar(cPN)
      nSAIANT  :=SAI
      cCODANT  :=COD
      dbskip()
  enddo     
  dbselectar( PES )
  dbskip()
enddo
for i=1 to len(aFTB)
    nHORAS:=0
    mNUMERO:=0    
    dbselectar(cPN)
    dbgotop()
    if dbseek(aFTB[i])  //segunda
       mNUMERO:=NUMERO
       mDATA  :=DATA 
       if ent>0
          nHORAS+=CHOR(ENT)
       else 
          Nhoras+=24   
       endif
       dbskip(-1)      //domingo   
       if numero=mNUMERO.and.ent<=sai
          if ent=0.or.sai=0
             Nhoras+=24
          else      
              if ent>0
                 nHORAS+=CHOR(ENT)
              endif 
              IF sai>0
                 nHORAS+=24-CHOR(SAI)   
              endif
          endif
       endif
       dbskip(-1)
       lSAB:=numero=mNUMERO.and.COD="SA"
       if numero=mNUMERO.and.COD="SA".and.ent<=sai //sabado folga          
          if ent=0.or.sai=0
             Nhoras+=24
          else      
              if ent>0
                 nHORAS+=CHOR(ENT)
              endif 
              IF sai>0
                 nHORAS+=24-CHOR(SAI)   
              endif
          endif
       endif
       if numero=mNUMERO.and.COD<>"SA".and.ent<=sai //sabado trabalhado so saida          
          if ent=0.or.sai=0
             Nhoras+=24
          else      
             IF sai>0
                nHORAS+=24-CHOR(SAI)   
             endif
          endif
       endif
       IF lSAB //Folga no sabado pego saida da sexta       
          dbskip(-1)      //domingo   
          if numero=mNUMERO.and.ent<=sai
             if ent=0.or.sai=0
                Nhoras+=24
             else      
                IF sai>0
                   nHORAS+=24-CHOR(SAI)   
                endif
             endif
          endif
       endif
    endif
    if nHORAS<35.AND.mNUMERO>0
       mNOME:=""
       dbselectar(pes)
       dbgotop()
       if dbseek(mNUMERO)
          mNOME:=NOME
       endif   
       dbselectar("foptoatr")
       netrecapp()
       foptoatr->numero:=mNUMERO
       foptoatr->nome:=mNOME
       foptoatr->data:=mDATA
       foptoatr->codanl:="35"
       foptoatr->obsatr:="Folga Inferior a 35"
       foptoatr->HORXXX:=35-nhoras
    endif
    dbselectar(cPN)
next i

dbcloseall()
return .t.

funcTION gFOPTO37
IF ZFECHADO="S"
   ALERTX("MES JA FECHADO")
   retuRN .f.
ENDIF
cTMP:=" "
CLSBOX( 03, 0, 24, 79 )

verpassagens(mNUMERO,mDATA,.T.,.T.)
nSALDO:=pegsaldobco(mNUMERO,nANOANT,nMESANT,.t.)

@ 04,01 SAY mNUMERO
@ 04,15 SAY mNOME
@ 06,01 SAY mDATA
@ 06,10 SAY mENT
@ 06,16 SAY mRENT
@ 06,30 SAY mSAI
@ 06,36 SAY mRSAI
@ 06,47 SAY mCODANL
@ 06,50 SAY mCOD
@ 06,53 SAY mSOD
@ 07,00 SAY mOBSATR
@ 08,30 say "Banco"
@ 08,36 SAY mBCOSN
@ 08,49 say  STRZERO(nMESANT,2) + "/" + strZERO( nANOANT,4)
@ 08,57 say  nSALDO  pict "9999.99"


@ 23,00 SAY "(O)ocorrencia|Horario(A)vulso|Correcao(H)orario|(E)mail|(C)reditosAvulsos (D)escarte"
@ 24,78 GET cTMP  PICT "@!" VALID cTMP $ "OAHEC "
readcur()


aOLD:={mNUMERO,mNOME,mDATA,mENT,mRENT,mSAI,mRSAI,mCOD,mSOD,mBCOSN,mHORXXX,mOBSATR}
//         1      2    3      4    5    6    7     8    9    10       11     12
DO CASE
   CASE cTMP="O"
       cPO := "PO" + ANOMESW
       CHECKCRI( cPO, "FO_POCO", "STR(NUMERO,8)+DTOS(OCOINI)" )
       CRIARVARS(cPO)
       mNUMERO:=aOLD[1]
       mOCOINI:=aOLD[3]
       tFOPTO4t()
       gFOPTO4t()
       NOVOREG(cPO,cPO,str( mNUMERO, 8 ) + dtos( mOCOINI ))
   CASE cTMP="A"
       cPM := "PM" + ANOMESW
       CHECKCRI( cPM, "FO_PMAN", "STR(NUMERO,8)+DTOS(DATOCO)+TIPOCO" )
       CRIARVARS(cPM)
       mNUMERO:=aOLD[1]
       mDATOCO:=aOLD[3]
       mTIPOCO:="T"
       tFOPTO4m()
       gFOPTO4m()
       NOVOREG(cPM,cPM,str( mNUMERO, 8 ) + dtos( mDATOCO ) + mTIPOCO)
   CASE cTMP="H"
       cPH := "PH" + ANOMESW
       CHECKCRI( cPH, "FO_PHOR", "STR(NUMERO,8)+DTOS(OCOINI)" )
       CRIARVARS(cPH)
       mNUMERO:=aOLD[1]
       mOCOINI:=aOLD[3]
       tFOPTO4L()
       gFOPTO4L()
       NOVOREG(cPH,cPH,str( mNUMERO, 8 ) + dtos( mOCOINI ))
   CASE cTMP="C"
       cPX := "PX" + ANOMESW
       CHECKCRI( cPX, "FO_PDES", "STR(NUMERO,8)+DTOS(DATA)+STR(CONTA,2)" )
       CRIARVARS(cPX)
       mNUMERO:=aOLD[1]
       mDATA:=aOLD[3]
       mCONTA:=1
       mHORAS:=aOLD[11]
       mOBS  :=aOLD[12]
       tFOPTO48()
       gFOPTO48()
       NOVOREG(cPX,cPX,str( mNUMERO, 8 ) + dtos( mDATA ) + str( mCONTA,2 ))       
   CASE cTMP="D"       
       CRIARVARS("AFDTERR")       
       mNUMERO:=aOLD[1]
       mDATA:=aOLD[3]
       mHORAS:=0.00 //aqui pode ser qualquer horario do dia a descartar
       iAFDTERR() //uso o include para pegar a data       
       TELASAY("AFDTER")
       EDITSAY("AFDTER")
       NOVOREG("AFDTERR","AFDTERR", (mNUMero, 8 ) + dtos( mDATA ) + str( mHORA, 5, 2 ))       
       gAFDTERR() //grava pd com TIPOM='D'              
   CASE cTMP="E"
       cASSUNTO:=PADR("Ponto:"+DTOC(mDATA)+" "+str( mNUMERO, 8 )+" "+mNOME,60)
       cCORPOMSG:=PADR(mOBSATR,60)
       FILETOEMAIL(,cASSUNTO,cCORPOMSG)
   OTHERWISE
       RETURN .T.
END CASE
mNUMERO:=aOLD[1]
mNOME:=aOLD[2]
mDATA:=aOLD[3]
mENT:=aOLD[4]
mRENT:=aOLD[5]
mSAI:=aOLD[6]
mRSAI:=aOLD[7]
mCOD:=aOLD[8]
mSOD:=aOLD[9]
mBCOSN:=aOLD[10]
mHORXXX:=aOLD[11]
mOBSATR:=aOLD[12]
RETURN .T.

*+ EOF: FOPTO_37.PRG
