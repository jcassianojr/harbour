*+
*+   FOPTO_26.PRG - Calculo do Ponto
*+
*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ



CABE2( 'FOPTO_26 - Calculando Ponto' )
FN   := 8 / 7       //Fator do Adicional Noturno
FDIA  := 7.33
aBCO := {}
aFOR := {}
aTOL := {}

aEVED := {}
aEVEC := {}
aEVEB := {}
PegFeriados()


//IF ! MDG("Calcular o Ponto")
//   RETU
//ENDIF

aRELFXREF:={}
if ! NETUSE("PTOHOREF")
   retu .F.
endif
dbgotop()
while ! eof()
   AADD(aRELFXREF,{RELOGIO,HORINI,HORFIM})
   dbskip()
enddo
dbclosearea()


if ! NETUSE("FOPTOCON")
   retu .F.
endif
if ! dbseek(nremp)
   dbgotop()
endif
for X := 1 to 24
   cVAR := "OP" + strzero( X, 2 )
   aadd( aFOR, &cVAR )
   IF X<11
      cVAR := "TOL" + strzero( X, 2 )
      aadd( aTOL, &cVAR )   
   ENDIF
next X
//1 //ENTRADA
//2 //SAIDA REFEICAO
//3 //ENTRADA REFEICAO
//4 //SAIDA
//5 //EXTRA
//6 //ENTRADA
//7 //SAIDA
//8 //ENTRADA
//9 //SAIDA 
dbcloseall()

if ! NETUSE("FOPTOBCO",,,,,.F.,)
   retu .F.
endif
for X := 1 to 24
   cVAR := "BCO" + strzero( X, 2 )
   aadd( aBCO, &cVAR )
next X
aadd( aBCO, BCOHR )
dbcloseall()

cPN := "PN" + ANOMESW
cPT := "PT" + ANOMESW
cPD := "PD" + ANOMESW
cPE := "PE" + ANOMESW
cPX := "PX" + ANOMESW
cPA := "PA" + ANOMESW

if ! NETUSE(cPN)
   retu
endif
FILTRO := FILTRO( "" )
set filter to &FILTRO

//IF ! MDG("Iniciar Calcular do Ponto")
   //dbcloseall()
   //RETU
///ENDIF

if ! NETUSE("FO_RELHR")
   dbcloseall()
   retu
endif

if ! NETUSE("FOPTOHRE")
   dbcloseall()
   retu
endif


if ! NETUSE(PES)
   dbcloseall()
   return
endif
INITVARS()
CLRVARS()

if ! NETUSE(cPE)
   dbcloseall()
   return
endif

if ! NETUSE(cPX)
   dbcloseall()
   return 
endif

if ! NETUSE(cPA)
   dbcloseall()
   return 
endif

if ! NETUSE(if( lSECBCO, "BCOBAK", "BCOHRS" ))
   dbcloseALL()
   retu
endif
cSELE6:=ALIAS()


DBselectarea(cPN)
GRAPP := 1
GRAPT := lastrec()
GRAPT( 'AGUARDE CALCULANDO O PONTO ' )
dbgotop()
while !eof()
   NUM    := NUMERO
   mGRUPO := "  "
   mTURNO := " "
   lSAD   := .F.
   hSAIA  := 0

   aFOLGA :={}
   aREF   :={}
   dDATAREF1:=CTOD(SPACE(8))
   peghorfix(num)

   dbselectar(cSELE6)
   nSALDOBCO:=pegsaldobco(NUM,nANOANT,nMESANT)
   nVALBCO  :=0   
   
   
   dbselectar(pes)
   dbgotop()
   if dbseek(NUM)
      PETELA( 9 )
      EQUVARS()
   else
      CLRVARS()
   endif
   IF EMPTY(dDATAREF1)
      dDATAREF1:=mADMITIDO
   ENDIF
   lT1     := mTIPO = "1" .OR. mTIPO = "M" 
   lT5     := mTIPO = "5" .OR. mTIPO = "H" 


   DBseleCTARea(cPN)
   while NUM = NUMERO .and. !eof()
      IF EMPTY(DATA) //Evita Erro data em Branco
         DBSKIP()
         LOOP
      ENDIF
      if EMPTY(NUMERO) //Evita Erro Numero em Branco
         DBSKIP()
         LOOP
      ENDIF
      mDATA := DATA
      nDOW  := DOW(DATA)
      vEXT  := 0
      vEXTALM:=0
      vEXTNEW:=0
      vEXT2OLD := 0
      vEXT2 := 0
      vEXTVIR:= 0 //Extras Virada Noite Folga
      VBCO01:=0
      VBCO01OLD:= 0
      lBCO  := if( BCOSN = "S", .T., .F. )
      lRED  := if( REDSN = "S", .T., .F. )
      lNRED := ! lRED
      RENT    := 0
      RALS    := 0
      RALE    := 0
      RSAI    := 0
      lESCALA := .F.
      lESCFOL := .F.


      
      if empty( CODREV )                //N„o h  horario codificado
         if !empty( mGRUPO ) .and. mTURNO = "S"             //Reveza e tem escala
            lESCALA := .F.
            mESCALA := mGRUPO + dtos( DATA )
            dbselectar( cPE )
            dbgotop()
            if dbseek( mESCALA )
               lESCALA := .T.
               RENT    := CHOR( ENTREV )
               RALS    := CHOR( ALIREV )
               RALE    := CHOR( ALSREV )
               RSAI    := CHOR( SAIREV )
               IF FOLGASN="S"
                  lESCFOL := .T.
               ENDIF
            endif
            dbselectar( cPN )
         else
            if empty( aREF[ nDOW, 1 ] )
                IF aFOLGA[ nDOW ] <> "S" //Se nao for folga pega padrao
                   RENT := CHOR( aREF[ 8, 1 ] )
                   RALS := CHOR( aREF[ 8, 2 ] )
                   RALE := CHOR( aREF[ 8, 3 ] )
                   RSAI := CHOR( aREF[ 8, 4 ] )
                ENDIF
            else
                RENT := CHOR( aREF[ nDOW, 1 ] )
                RALS := CHOR( aREF[ nDOW, 2 ] )
                RALE := CHOR( aREF[ nDOW, 3 ] )
                RSAI := CHOR( aREF[ nDOW, 4 ] )
            endif
         endif
      else          //Horario Especifico do dia
         RENT := CHOR( ENTREV )
         RALS := CHOR( ALIREV )
         RALE := CHOR( ALSREV )
         RSAI := CHOR( SAIREV )
      endif


      peghorflex()


      //--------------Inicio Formulas-------------------//

      //Horas Em Decimais
      CENT  := CHOR( ENT )              //Hora entrada em decimal de hora
      CSAI  := CHOR( SAI )              //Hora saida em decimal de hora
      CALS  := CHOR( ALS )              //Hora saida almoco em decimal de hora
      CALE  := CHOR( ALE )              //Hora entrada almoco em decimal de hora

      //Variaves de Preenchimento
      lSAI  := SAI > 0   //Preencheu Saida
      lENT  := ENT > 0   //Preencheu Entrada
      lALS  := ALS > 0   //Preencheu Saida Almoco
      lALE  := ALE > 0   //Preencheu Retorno Almoco
      lCENT  := CENT >0  //Tem Horas Entrada
      lCSAI  := CSAI >0  //Tem Horas Saida
      lCALS  := CALS >0  //Tem Horas Saida Almoco
      lCALE  := CALE >0  //Tem Horas Retorno Almoco

      //Horas a Trabalhar
      HREF := RSAI - RENT
      if !empty( RSAI ) .and. !empty( RENT )       //Horas Reais Noturno
         if RSAI < RENT
            HREF := 24 -  RENT  + RSAI
         endif
      endif



      //Horas Almocos
      HREA := RALE - RALS
      RALM := RALE - RALS
      HRE1 := HREF - IF(RALS>0.AND.RALE>0,RALM,IF(RENT>0,1,0))        //Horas Referencia Menos 1 (Almoco Indicado)

      //Horas Trabalhadas
      HTAB := CSAI - CENT
      HXAB:=0
      HXMI:=0
      if !empty( SAI ) .and. !empty( ENT )  
         HXAB:=INT(SAI)-INT(ENT)-1  
         HXMI:=0         
         IF (ENT-INT(ENT))>0         
            HXMI+=ABS(.60-(ENT-INT(ENT)))         
         ELSE
            HXAB+=1
         ENDIF  
         HXMI+=(SAI-INT(SAI))                  
         IF HXMI>.60
            HXAB+=1
            HXMI-=.60
         ENDIF            
         HXAB+=HXMI                  
         IF ROUND(HXAB-INT(HXAB),2)>=0.60
            HXAB=HXAB+1-.60
         ENDIF
         HXMI:=(INT(HXAB)* 60 ) + ((HXAB-INT(HXAB))*100) 
      endif
      if !empty( SAI ) .and. !empty( ENT )   //Horas Trabalhadas Vigias
         if SAI < ENT
            HTAB := 24 - CENT + CSAI
         endif
      endif
      
      BENT  := if( abs( RENT - CENT ) < aTOL[6], RENT, CENT )
      BSAI  := if( abs( RSAI - CSAI ) < aTOL[7], RSAI, CSAI )
      BENT2 := if( abs( RENT - CENT ) < aTOL[8], RENT, CENT )
      BSAI2 := if( abs( RSAI - CSAI ) < aTOL[9], RSAI, CSAI )

      //Horas Almoco
      if lALE .and. lALS
         HALM := CALE - CALS       //Horas no almo‡o
      else
         HALM := 0
      endif

      //Horas Reais Horario - Almoco
      IF ROUND(HREA,2)>.5.OR.AT("ITAESBRA",ZEMPRESA)>0.OR.AT("IMBRIZI",ZEMPRESA)>0      //round colocado pela evitar falha
         HATB  := HREF - HREA
      ELSE
         HATB  := HREF  //horario de turno tambem desconta intervalo
      ENDIF             //pois a empresa e que paga

      //Tem algumas horas
      HT    := HTAB > 0
      NHT   := ! HT

      DIF1 := 0
      DIF2 := 0
      //Diferenca Reais Trabalhadas
      if !empty( HTAB ) .and. !empty( HREF )
         DIF1 := HTAB - HREF            //Horas Trabalhadas - Referencia
         DIF2 := HREF - HTAB            //Horas Referencias - Trabalhada
      endif
      DIF9:=DIF2
      IF RALS>0.AND.lCSAI.AND.CSAI<=RALS
         DIF9:=DIF9-RALM
      ENDIF
      IF RALE>0.AND.lCENT.AND.CENT>=RALE
         DIF9:=DIF9-RALM
      ENDIF

      //Codigos
      CO    := !empty( COD ).AND. ! empty(SOD) //Marcou algum codigo
      NCO   := empty( COD ).AND.EMPTY(SOD)     //nao marcou nenhum codigo
      SA    := COD = "SA" .OR. SOD = "SA"      //codigo=sabado
      DO    := COD = "DO" .OR. SOD = "DO"      //codigo=domingo
      FE    := COD = "FE" .OR. SOD = "FE"      //codigo=feriado
      FO    := COD = "FO" .OR. SOD = "FO"      //codigo=folga
      lFN   := COD = "FN" .OR. SOD = "FN"      //ferias
      lINJ  := COD = "AI" .or. COD = "FI" .OR. SOD = "AI"  .OR. SOD = "FI" //Atraso ou Folta Injustificada
      lFD   := COD = "FD" .or. COD = "FI" .OR. SOD = "FD"  .OR. SOD = "FI" //Faltas DSR ou Faltra Injusticada
      lFD2  := COD = "FD" .or. SOD = "FD"
      lDF   := COD = "DF" .or. SOD = "DF"      //evitar confundir dom LFD lFD2
      lFI   := COD = "FI" .or. SOD = "FI"
      lAP   := COD = "AP" .or. SOD = "AP"
      lRH   := COD = "RH" .or. SOD = "RH"
      lAM   := COD = "AM" .or. SOD = "AM"
      lAX   := COD = "AX" .OR. SOD = "AX"      //codigo=AX
      lAZ   := COD = "AZ" .OR. SOD = "AZ"      //codigo=AZ
      lA5   := COD = "A5" .OR. SOD = "A5"      //codigo=A5 aposentadoria

         IF ! EMPTY(mSITUACAO) .AND. (lENT .OR. lSAI)
            ALERTX("Funcionário em situação: "+mSITUACAO+" marcou o ponto")
         ENDIF

         IF lFN .AND. (lENT .OR. lSAI)
            ALERTX("Funcionário em Ferias FN marcou o ponto")
         ENDIF
         
      
         if SA .AND. DOW(DATA)<>7
            ALERTX( "Codigo SA sem ser sabado")            
         endif
         if DO .AND. DOW(DATA)<>1
            ALERTX(" Codigo DO sem ser domingo")            
         endif         
         IF FE .AND. ASCAN(aEVED, str( DAY(DATA), 2 ) + str( MONTH(DATA), 2 ) )=0         
            ALERTX(" Codigo FE sem feriado cadastrado ")
         ENDIF
      
      
      

      lAXZ  := lAX.OR.lAZ

      //Controle De escala
      lESC  := lESCALA
      lNESC := !lESCALA
      lTRO  := ENT > SAI                //Saida Maior que Entrada

      
      //Folga
      lFOL  := ( FO .or.( aFOLGA[ nDOW ] = "S".and.Lnesc)) .and. empty( CODREV ) .or. ( FOLSN = "S" ).OR.(lESCFOL)
      NFOL  := !lFOL
      if lESCALA
         DDSR := FO .or. do
      else
         DDSR := FE .or. FO .or. do
      endif
      DOE   := DO .OR. FE
      DNUTI := FE .or. FO .or. do .or. SA                   // Dia nao util
      DUTI  := !DNUTI                   //Dia util
      SAHT  := SA .and. HT
      SAHTFO:= SAHT.AND.lFOL //Sabado Horas e Folga

      
      //Atraso Entrada
      
      AE    := lCENT .and. CENT > RENT + aTOL[1]
      AEL   := AE .and. !lFOL
      AELJ  := AEL .and. COD # "AJ" .and. SOD # "AJ"
      DIF3  := CENT - RENT
      //td()
      IF CENT<RALE.AND.CENT>RALS.AND.lCENT.AND.RALS>0.AND.RALE>0.AND.! lTRO
         DIF3  := DIF3 - (CENT-RALS)
      ENDIF
      vDIF3 := IF(AELJ,DIF3,0)

      //Atraso Saida
      AS    := lCSAI .and. CSAI < RSAI - aTOL[4]
      ASL   := AS .and. !lFOL
      ASLJ  := ASL .and. COD # "AJ" .and. SOD # "AJ"
      DIF4  := RSAI - CSAI
      IF CSAI<RALS.AND.lCSAI.AND.RALS>0.AND.! lTRO
         DIF4 := DIF4 - RALM
      ENDIF
      vDIF4 := IF(ASLJ,DIF4,0)
      IF EXTSN="V"
         DIF4:=0
         vDIF4=0
      ENDIF

      // FUNCIONARIO ENTRA 22:00 SAI POR EXEMPLO 22:30 com horario das 22:00 as 6:00 virada
      IF VIRADA="S".AND.CSAI>0.AND.CENT>0.AND.(CSAI>CENT.AND.cSAI>RENT.AND.cSAI<24.01)
         DIF4:=(24-cSAI)+RSAI-RALM
         //DIF3:=0
         //vDIF3:=0
         AS:=.T.
         ASL   := AS .and. !lFOL
         ASLJ  := ASL .and. COD # "AJ" .and. SOD # "AJ"
         vDIF4 := IF(ASLJ,DIF4,0)
         
      ENDIF

      IF (DIF3>0.OR.DIF4>0).AND.DIF3<ATOL[1].AND.DIF4<ATOL[4] //tolerancia entra e saida nao desconta nada
         DIF3:=0
         DIF4:=0
      ENDIF       
      IF DIF3<0
         DIF3:=0
      ENDIF 
      IF DIF4<0
         DIF4:=0
      ENDIF

      // Saida Antecipada Almoco
      AALS  := lCALS .and. CALS < RALS - aTOL[2]   //saiu mais cedo para almoco
      AALSL := AALS .and. !lFOL
      AALSJ := AALS .and. COD # "AJ" .and. SOD # "AJ"
      DIF7  := RALS - CALS
      vDIF7 := IF(AALSJ,DIF7,0)

      //Retorno Atraso Almoco
      AALE  := lCALE .and. CALE + aTOL[3]  > RALE  //voltou apos o horario almoco
      AALEL := AALS .and. !lFOL
      AALEJ := AALS .and. COD # "AJ" .and. SOD # "AJ"
      DIF8  := CALE - RALE              //Retorno mais tarde Almoco
      vDIF8 := IF(AALEJ,DIF8,0)

      //Horas Extras
      EH:=.F.     //Exedeu horario para extra
      IH:=.F.     //Iniciou HoraRio para extra
      EIH:=.F.   //ent+sai horario
      DIF05:=0
      DIF06:=0
      DIF10:=0
      IF aTOL[5]>0
         IF cSAI>0.AND.RSAI>0
             EH  := CSAI - RSAI > aTOL[5]     //Exedeu horario para extra
             DIF10+=(CSAI - RSAI)
         ENDIF
         IF RENT>0.AND.CENT>0
             IH  := RENT - CENT > aTOL[5]     //Iniciou Horario para extra
             DIF10+=(RENT - CENT)
         ENDIF
      ENDIF
      IF DIF10>aTOL[5]
         EIH:=.T.
      ELSE
         DIF10:=0
      ENDIF
      IF EXTSN="V"
         EH:=.T.
      ENDIF

      //td()
      HH    := EH .or. IH               //Extra entrada ou saida
      EHH   := EH .and. !lFOL .and. HT
      IHH   := IH .and. !lFOL .and. HT
      DIF5  := CSAI - RSAI              //Excedentes Saida
      DIF6  := RENT - CENT              //Excedentes Entrada
      
      IF EHH
         IF EXTSN="V"
            DIF5  := (24 - RSAI)+CSAI
         ENDIF
      ENDIF
      vDIF5 := IF(EHH,DIF5,0)
      vDIF6 := IF(IHH,DIF6,0)
      vDIF56:= vDIF5-vDIF6

      //Adcional Noturno 7/8
      HRAN  := if( SAI > 22.15, ( SAI - 22 ) * FN, 0 ) + if( lTRO .and. lSAI, if( ENT < 22, 2.29, ( 24 - ENT ) * FN ) + if( SAI > 5, 5.71, SAI * FN ), 0 )
      IF ENT=0.01
         HRAN+=if( SAI > 5, 5.71, SAI * FN )
      ENDIF
      HRANE := if( SAI > 22.15, ( RSAI - 22 ) * FN, 0 ) + if( lTRO .and. lSAI, if( SAI > 5 .and. EH, ( 5 - RSAI ) * FN, ( RSAI - CSAI ) * FN ), 0 )
      if DOE
         HRANE := HRAN
      endif
      HRANR := HRAN - HRANE
      if HRANR > 8
         HRANR := 8
      endif
      HRANT:=CHOR(HRAN)
      IF EH.and.lTRO.and.lSAI.and.SAI > 5
         HRANT+=DIF5*FN
      ENDIF
      //HRANT := if( SAI > 22.15, ( SAI - 22 ) * FN, 0 ) + if( lTRO .and. lSAI, if( ENT < 22, 2.29, ( 24 - ENT ) * FN ) +  SAI * FN ,0)

      BENT  := if( abs( RENT - CENT ) < aTOL[6], RENT, CENT )
      BSAI  := if( abs( RSAI - CSAI ) < aTOL[7], RSAI, CSAI )
      BENT2 := if( abs( RENT - CENT ) < aTOL[8], RENT, CENT )
      BSAI2 := if( abs( RSAI - CSAI ) < aTOL[9], RSAI, CSAI )

      //Adcional Norturno 8/8
      XRAN  := if( BSAI > 22.15, ( BSAI - 22 ), 0 ) + if( lTRO .and. lSAI, if( BENT < 22, 2, ( 24 - BENT ) ) + if( BSAI > 5, 5, BSAI ), 0 )
      XRANE := if( BSAI > 22.15, ( RSAI - 22 ), 0 ) + if( lTRO .and. lSAI, if( BSAI > 5 .and. EH, ( 5 - RSAI ), ( RSAI - CSAI ) ), 0 )
      if FE .or. FO .or. SA
         XRANE := XRAN
      endif
      XRANR := XRAN - XRANE
      if XRANR > 8
         XRANR := 8
      endif


      DIF4B := RSAI - BSAI              //best Atraso Saida
      if CSAI - int( CSAI ) < .33
         DIF4B := RSAI - int( CSAI )    //best Atraso Saida BCO
         if abs( RALS - CSAI ) < 1
            DIF4B --
         endif
      endif
      BTAB  := BSAI - BENT              //Horas Trabalhadas Best
      BTAB2 := BSAI2 - BENT2            //Horas Trabalhadas Best 2
      BTAB3 := BTAB2 - if( BTAB2 > 0 .and. CSAI > RALS .and. CSAI > RALE, RALM, 0 )
      IF DDSR.AND.RALS=0.AND.RALS=0.AND.HALM>0
         BTAB3:=BTAB3-HALM //trabalhou domingo folga nao tem hora referencia descontar almoco
      ENDIF
      if !empty( BSAI ) .and. !empty( BENT )    //Horas Trabalhadas Vigias
         if BSAI < BENT
            BTAB := 24 - BENT + BSAI
            BTAB2 := 24 - BENT2 + BSAI2
            BTAB3 := BTAB2 //- if( BTAB2 > 0 .and. CSAI > RALS .and. CSAI > RALE, RALM, 0 )
         endif
      endif
      lFAL := .F.
      if ! HT .and. DUTI .and. ! lFN .and. COD # "AB"
         lFAL := .T.
      endif
      lNJUS  := NCO .or. lINJ
      lHTO   := HT .and. lFOL
      lHTN   := HT .and. NFOL
      lITA01 := COD # "FJ" .and. COD # "CH" .and. COD # "AV" .and. COD # "AT" .and. COD # "AF" .and. COD # "DF".AND.COD#"SN".AND.COD#"CS".AND.COD#"LR".AND.COD#"AP".AND.COD#"AM"
      lITA02 := ! lFN .and. NFOL .and. NHT .and. COD # "SN" .and. COD # "AT" .and. COD # "FJ" .and. COD # "AF" .and. COD # "AD" .and. COD # "AJ" .and. HREF > 0
      lITA03 := lHTN .and. COD # "AJ" .and. COD # "AD"
      lITA04 := !EHH .and. !IHH .and. BTAB > 0
      lITA05 := lITA03 .and. !EHH .and. ! FE
      lITA06 := AELJ .and. lBCO .and. ! FE
      lITA07 := lITA02 .and. ! FE
      lITA08 := lHTO .or. FE
      lITA09 := lITA07 .or. COD = "PO"
      vITA01 := BTAB3 * if( DOE, 2, 1 )
      vITA02 := if( lITA05, DIF4B, 0 ) + if( lITA06, DIF3, 0 )
      if empty( RSAI ) .and. lBCO
         DIF5 := BTAB - IF(RALS>0.AND.RALE>0,RALM,1)
      endif

      if FOLSN="V"
         vEXTVIR:=CSAI
      ENDIF
      if (EHH.OR.IHH).AND.(DIF5>aTOL[10].OR.DIF6>aTOL[10]).AND.(aTOL[10]>0)
         IF DIF5>0
            EHH=.T.
         ENDIF
         IF DIF6>0   
            IHH=.T.
         ENDIF   
      endif
      IF EHH
         vEXT += DIF5
      ENDIF
      if IHH
         vEXT += DIF6
      endif
      If EXTSN="T" //marcado para todas horas extras
         vEXT:=BTAB-HREA //HALM
      endif
      IF EXTSN="Z"
         vEXT:=0
      endif
      IF EXTSN="A"    //almoco uma hora
         vEXTALM=1
      ENDIF
      IF EXTSN="5"   //almoco meia hora
         vEXTALM=.5
      ENDIF
      IF EIH
         vEXTNEW=DIF10
      ENDIF
      IF NFOL
         vEXT2OLD:= vEXT
         vEXT2:=vEXTNEW
      ELSE
         vEXT2OLD:= BTAB3
         vEXT2:=BTAB3
      ENDIF
      VBCO01OLD:=VEXT2OLD-VITA02 //Extras - Atrasos
      VBCO01:=VEXT2-VITA02


      //Gravando Valores
      dbselectar( cPN )
      NETRECLOCK()
      for X := 1 to 24
         
         cVAR         := "CTA" + strzero( X, 2 )
         cFOR         := if( lBCO.AND.! EMPTy(aBCO[X]), aBCO[ X ], aFOR[ X ] )   //Formula Diferente Qdo Bco
         nVALOR       := if( empty( cFOR ), &cVAR, &cFOR )
         IF nVALOR>999.99
            nVALOR:=0
         ENDIF
         field->&cVAR := nVALOR
      next X
      if lBCO       //Conta Horas
         cFOR          := aBCO[ 25 ]
         nVALOR        := if( empty( cFOR ), BCOHRS, &cFOR. )
         IF nVALOR>999.99
            nVALOR:=0
         ENDIF
         FIELD->BCOHRS :=nVALOR
      else
         field->BCOHRS := 0
      endif
     
      // Horas trabalhadas     
      FIELD->HTRAB:=BTAB
      
      lSAD  := .F.
      hSAIA := 0
      if !empty( CSAI ) .and. !empty( CENT )       //Horas Trabalhadas Vigias
         if CSAI < CENT
            lSAD  := .T.
            hSAIA := CSAI
         endif
      endif
      //Creditos avulsos
      dbselectar(cPX)
      dbgotop()
      dbseek( str( NUM, 8 ) + dtos( mDATA ) )
      while NUM = NUMERO .and. mDATA = DATA .and. !eof()
         if CONTA > 0 .and. CONTA < 25
            cCTA   := "CTA" + strzero( CONTA, 2 )
            nHORAS := HORAS
            DBselectarea(cPN)
            field->&cCTA := &cCTA + nHORAS
         endif
         dbselectar(cPX)
         if CONTA = 99
            nHORAS := HORAS
            DBseleCTARea(cPN)
            field->BCOHRS := BCOHRS + nHORAS
         endif
         dbselectar(cPX)
         dbskip()
      enddo
      DBselectarea(cPN)
      netreclock()
      GRAPS()
      dbskip()
   enddo
enddo
dbcloseall()

FOPTO_23( FILTRO )

return


function peghorflex()
//Horarios Flexiveis
IF SOD="_A"
   RENT := CHOR( ENT )
ENDIF
IF SOD="_9"
   RENT := CHOR( ENT )
ENDIF
IF SOD="_8"
   RENT := CHOR( ENT )
ENDIF

/* 
if mdata<ctod("01/08/2010")  //sem reducao
   IF SOD="_A"
      RSAI := CHOR( ENT + 10)
   ENDIF
   IF SOD="_9"
      RSAI := CHOR( ENT + 9)
   ENDIF
   IF SOD="_8"
      RSAI := CHOR( ENT + 8)
   ENDIF
ENDIF
IF mdata<ctod("01/01/2011")  //1a reducao
   IF SOD="_A"
      RSAI := CHOR( ENT )+9.9
   ENDIF
   IF SOD="_9"
      RSAI := CHOR( ENT )+8.9
   ENDIF
   IF SOD="_8"
      RSAI := CHOR( ENT )+7.9
   ENDIF
endif
 IF mdata<ctod("01/01/2011")  //2a reducao
 IF SOD="_A"
      RSAI := CHOR( ENT )+9.8
   ENDIF
   IF SOD="_9"
      RSAI := CHOR( ENT )+8.8
   ENDIF
   IF SOD="_8"
      RSAI := CHOR( ENT )+7.8
   ENDIF
endif
 IF mdata>=ctod("01/07/2011")     //3a reducao
   IF SOD="_A"
      RSAI := CHOR( ENT )+9.7
   ENDIF
   IF SOD="_9"
      RSAI := CHOR( ENT )+8.7
   ENDIF
   IF SOD="_8"
      RSAI := CHOR( ENT )+7.7
   ENDIF
endif
*/

IF mdata>=ctod("01/01/2012")  //4a reducao
   IF SOD="_A"
      RSAI := CHOR( ENT )+9.6
   ENDIF
   IF SOD="_9"
      RSAI := CHOR( ENT )+8.6
   ENDIF
   IF SOD="_8"
      RSAI := CHOR( ENT )+7.6
   ENDIF
endif
return .t.


FUNCTION BCOEXTRA(nVALOR)
nVALBCO:=0
IF VALTYPE(nVALOR)<>'N'
   RETURN 0
ENDIF
IF nSALDOBCO=0
   RETURN nVALOR
ENDIF
IF nVALOR=0
   RETURN nVALOR
ENDIF
IF nSALDOBCO>0
   RETURN nVALOR
ENDIF
nSALDOPOS:=nSALDOBCO*-1

DO CASE
   CASE nSALDOPOS>=nVALOR        
        nSALDOBCO :=ROUND(nSALDOBCO,2)+ROUND(nVALOR,2)
        nVALBCO   :=nVALOR
        lBCO      :=.T.
        nVALOR    :=0
   CASE nVALOR   >nSALDOPOS
        nVALOR   :=nVALOR-nSALDOPOS
        nVALBCO  :=nSALDOPOS
        nSALDOBCO:=0   
        lBCO      :=.T.
END CASE
RETURN nVALOR