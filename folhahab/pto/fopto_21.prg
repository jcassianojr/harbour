*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
*+
*+    Source Module => C:\CLIPPER\FOLHA\PTO\FOPTO_21.PRG
*+
*+    Reformatted by Click! 2.03 on May-6-2000 at  9:11 pm
*+
*+　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　


*Carnaval      CalcPascoa(aaaa)- 47
*QuartaCinzas  CalcPascoa(aaaa)- 46
*SextaSanta    CalcPascoa(aaaa)- 2
*CorpusChristi CalcPascoa(aaaa)+ 60
*Pascoa        calcpascoa(aaaa)
*ConfrUniv     01/01/aaaa
*AnivSaoPaulo  25/01/aaaa
*Tiradentes    21/04/aaaa
*DiaTrabalho   01/05/aaaa
*IndepBrasil   07/09/aaaa
*NossaSra      12/10/aaaa
*Finados       02/11/aaaa
*ProcRepublica 15/11/aaaa
*Natal         25/12/aaaa

CABE2( 'FOPTO_21 - Iniciando o mEs' )


if !MDG( 'Voce tem certeza' )
   retu .F.
endif

//FO21CRI("PE","FOPTOREV", "GRUPO+DTOS(DATA)" ) //ja cria na fopto_43
fopto_43()

dINI := zdataini
dFIM := zdatafim
MDS( 'Digite o Periodo ' )
@ 24, 40 get dINI
@ 24, 50 get dFIM
if !READCUR()
   retu .F.
endif
nMES := month( dFIM )
nANO := year( dFIM )
MDS( 'Confirme a Competencia' )
@ 24, 40 get nMES
@ 24, 50 get nANO
if !READCUR()
   retu .F.
endif
cMESANO:=SUBSTR(STRZERO(nANO,4),3,2)+STRZERO(nMES,2)

//Serao Usados Arede
cPN := "PN" + cMESANO
cPE := "PE" + cMESANO


FO21CRI("PN","FO_PON", "STR(NUMERO,8)+DTOS(DATA)" )
FO21CRI("PT","FO_POT", "NUMERO")
FO21CRI("PD","FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
FO21CRI("PA","FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
FO21CRI("PP","FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
FO21CRI("PO","FO_POCO", "STR(NUMERO,8)+DTOS(OCOINI)" )
FO21CRI("PM","FO_PMAN", "STR(NUMERO,8)+DTOS(DATOCO)+TIPOCO" )
FO21CRI("PH","FO_PHOR", "STR(NUMERO,8)+DTOS(OCOINI)" )
FO21CRI("PX","FO_PDES", "STR(NUMERO,8)+DTOS(DATA)+STR(CONTA,2)" )
FO21CRI("PS","FO_POS", "STR(NUMERO,8)+DTOS(SEMFIM)" )
FO21CRI("BK","BCOREQ", "REQUISI" )
FO21CRI("BH","BCOREQ", "REQUISI" )


//Pegando Eventos
aEVED := {}
aEVEC := {}
aEVEB := {}
PegFeriados()


//Feriados Moveis
FOR I=1 TO 4
    DO CASE 
       CASE I=1
            cTEXTO:="Carnaval"
            nPASSO:=-47
       CASE I=2
            cTEXTO:="Sexta Santa"
            nPASSO:=-2
       CASE I=3
            cTEXTO:="Corpus Christi"
            nPASSO:=60          
       CASE I=4
            cTEXTO:="Pascoa"
            nPASSO:=0
    ENDCASE 
    dFERMOV:=CalcPascoa(nANO)+nPASSO
    IF dFERMOV>=dINI.AND.dFERMOV<=dFIM
       IF MDG("Gravar Feriado "+cTEXTO)
         @ 24,00 SAY "Confirme data "+cTEXTO
         @ 24,30 GET dFERMOV
         READCUR()
         aadd( aEVED, str( DAY(dFERMOV), 2 ) + str( MONTH(dFERMOV), 2 ) )
         aadd( aEVEC, "FE" )
         aadd( aEVEB, { " "," "," " } )
       ENDIF   
    ENDIF
NEXT X        


if ! NETUSE(PES)
   retu
endif

/*
FILTRO := "admitido>=ctod('01/08/2009')"
set filter to &FILTRO
dbgotop()
while ! eof()
    PETELA( 8 )
    VALPIS(PIS)
    dbskip()
enddo
*/

FILTRO := FILTRO( '(EMPTY(DEMITIDO).OR.DEMITIDO<=dfim).and.! empty(PIS)' )
set filter to &FILTRO
dbgotop()

if ! netuse(cPN)
   dbcloseall()
   retu
endif

if ! NETUSE("FO_RELHR")
   dbcloseall()
   retu .T.
endif

if ! NETUSE("FOPTOHRE")
   dbcloseall()
   retu .T.
endif


if ! netuse(cPE)
   dbcloseall()
   retu
endif

dbselectar(pes)
dbgotop()
while !eof()
   PETELA( 8 )   
   VALPIS(PIS,.T.,.F.,FIELD->EVINC)   
   NUM     := NUMERO
   mBANCO  := " "
   mCODADC := "  "
   nINI    := dINI


   if nINI < ADMITIDO                   //Inicia A partir da data admiss?o
      nINI := ADMITIDO
   endif
   if ! EMPTY(DATTRANSF)                //Inicia a partir da data transferencia
      if nINI < DATTRANSF
         nINI := DATTRANSF
      endif
   endif
   nFIM := dFIM
   if ! empty( DEMITIDO )                //Encerra na data de demiss?o
      if DEMITIDO < nFIM
         nFIM := DEMITIDO
      endif
   endif

   aFOLGA  := {}
   aNHOR   := {}
   aREF    := {}
   mGRUPO  := ""
   mTURNO  := ""
   mALMOCO := ""
   mMARMES := ""
   mHORREF := ""
   mHORARIO:= 0
   peghorfix(num)

   if mMARMES <> "N"
      dbselectar(cPN) //sele 2
      for X := nINI to nFIM
          @ 24,00 say "Data:"+dtoc(x)
         cCOD := " "
         nEVE := ascan( aEVED, str( day( X ), 2 ) + str( month( X ), 2 ) ) //Checa Dia/Mes
         if nEVE = 0
            nEVE := ascan( aEVED, str( dow( X ), 2 ) + str( 0, 2 ) ) //Checa Dia da Semana
         endif
         lFOLGA   := .F.
         lDOMINGO := .F.
         lSABADO  := .F.
         lCODBH   := .F.
         if ! empty( mGRUPO ) .and. mTURNO = "S"
            dbselectar( cPE )
            dbgotop()
            if dbseek( mGRUPO + dtos( X ) )
               if CODREV = "FO"
                  lFOLGA := .T.
               endif
               if CODREV = "DO"
                  lDOMINGO := .T.
               endif
               if CODREV = "SA"
                  lSABADO := .T.
               endif
               if CODREV = "BH"
                  lCODBH :=.T.
               endif
               mCODADC:=CODADC
               mBANCO :=BCOSN
               mHORARIO:=HORARIO
            endif
         endif
         if ! empty(mHORREF).AND.mTURNO="N"
             nDOW  := DOW(X)
             if  aREF[ nDOW, 1 ] >0
                IF aFOLGA[ nDOW ] <> "S" //Se nao for folga pega padrao
                   mHORARIO:=aNHOR[nDOW]
                ENDIF
             else
                mHORARIO:=aNHOR[8]
             endif
         endif         
         dbselectar(cPN)
         dbgotop()
         if ! dbseek( str( NUM, 8 ) + dtos( X ) )
            netrecapp()
            field->NUMERO   := NUM
            field->DATA     := X
         else
            netreclock()
         endif
         IF EMPTY(COD)
            if nEVE > 0
               if empty( mGRUPO ) .or. mTURNO # "S" .or. AEVEC[ nEVE ] = "FE"
                  IF AEVEC[ nEVE ]<>"DO".AND.AEVEC[ nEVE ]<>"SA"
                     field->COD := AEVEC[ nEVE ]
                  ELSE
                     IF aFOLGA[DOW(X)]="S" //so se for folga marca
                        field->COD := AEVEC[ nEVE ] //Sabado e Domingo
                     ENDIF
                  ENDIF
               endif
               if AEVEB[ nEVE, 1 ] = "S"
                  field->BCOSN :=  "S"
               endif
               if AEVEB[ nEVE, 2 ] = "S"
                  field->REDSN :=  "S"
               endif
               if AEVEB[ nEVE, 3 ] = "S"
                  field->FOLSN := "S"
               endif
            else
               field->ALMOCO := mALMOCO
            endif
            if lFOLGA
               FOPTO21CS("FO")
               field->FOLSN  := "S"
            endif
            if lDOMINGO
               FOPTO21CS("DO")
            endif
            if lSABADO
               FOPTO21CS("SA")
            endif
            if lCODBH
               FOPTO21CS("BH")
            endif
            IF ! EMPTY(mCODADC)
               FOPTO21CS(mCODADC)
            ENDIF
            IF ! EMPTY(mBANCO)
               field->BCOSN :=  mBANCO
            ENDIF
         ENDIF
         if cod="FE" .or. Cod="FO" .or. COD="SA" .or. COD="DO" .or. COD="BH" //gravados acima pela fopot21cs
         else
            field->HORARIO:=mHORARIO
         endif
         dbcommit()
         DBUNLOCK()
      next X
   endif
   dbselectar(pes)
   dbskip()
enddo
dbcloseall()


FOY2( 0 ,"FOPTONTX","E")
pegcompete()
return

FUNCTION FOPTO21CS(cCOD)
if COD="FE"
   field->SOD="FE"
ENDIF
DO CASE
   CASE cCOD="SA" .AND. DOW(DATA)<>7
        ALERTX( "Codigo SA sem ser sabado")            
   CASE cCOD="DO" .AND. DOW(DATA)<>1
        ALERTX(" Codigo DO sem ser domingo")            
   CASE cCOD="FE" .AND. ASCAN(aEVED, str( DAY(DATA), 2 ) + str( MONTH(DATA), 2 ) )=0         
        ALERTX(" Codigo FE sem feriado cadastrado ")
   OTHERWISE
      field->COD    := cCOD   
ENDCASE
IF cCOD="SA"
ELSE
   field->ALMOCO := " "
ENDIF   
retuRN

FUNCTION FO21CRI(cARQ,cREF,eCHAVE)
cARQ:=cARQ+cMESANO
CHECKCRI( cARQ, cREF,eCHAVE)
return


FUNCTION FT_EASTER (nYear)
  local nGold, nCent, nCorx, nCorz, nSunday, nEpact, nMoon,;
        nMonth := 0, nDay := 0

  IF VALTYPE (nYear) == "C"
     nYear := VAL(nYear)
  ENDIF

  IF VALTYPE (nYear) == "D"
     nYear := YEAR(nYear)
  ENDIF

  IF VALTYPE (nYear) == "N"
     IF nYear > 1582

        * <<nGold>> is Golden number of the year in the 19 year Metonic cycle
        nGold := nYear % 19 + 1

        * <<nCent>> is Century
        nCent := INT (nYear / 100) + 1

        * Corrections:
        * <<nCorx>> is the no. of years in which leap-year was dropped in order
        * to keep step with the sun
        nCorx := INT ((3 * nCent) / 4 - 12)

        * <<nCorz>> is a special correction to synchronize Easter with the moon's
        * orbit.
        nCorz := INT ((8 * nCent + 5) / 25 - 5)

        * <<nSunday>> Find Sunday
        nSunday := INT ((5 * nYear) / 4 - nCorx - 10)

        * Set Epact <<nEpact>> (specifies occurance of a full moon)
        nEpact := INT ((11 * nGold + 20 + nCorz - nCorx) % 30)

        IF nEpact < 0
           nEpact += 30
        ENDIF

        IF ((nEpact == 25) .AND. (nGold > 11)) .OR. (nEpact == 24)
           ++nEpact
        ENDIF

        * Find full moon - the <<nMoon>>th of MARCH is a "calendar" full moon
        nMoon := 44 - nEpact

        IF nMoon < 21
           nMoon += 30
        ENDIF

        * Advance to Sunday
        nMoon := INT (nMoon + 7 - ((nSunday + nMoon) % 7))

        * Get Month and Day
        IF nMoon > 31
           nMonth := 4
           nDay := nMoon - 31
        ELSE
           nMonth := 3
           nDay := nMoon
        ENDIF
     ENDIF
  ELSE
     nYear := 0
  ENDIF

RETURN StoD( Str( nYear,4) + PadL( nMonth, 2, "0" ) + PadL( Int( nDay ), 2, "0" ) )


Function CalcPascoa(AAno)
return FT_EASTER (AAno)

Function PegFeriados()
if ! NETUSE("FOPTOEVE")
   retu .F.
endif
dbgotop()
while !eof()
   aadd( aEVED, str( DIA, 2 ) + str( MES, 2 ) )
   aadd( aEVEC, CODIGO )
   aadd( aEVEB, { BCOSN, REDSN, FOLSN } )
   dbskip()
enddo
dbcloseall()
return .T.





*+ EOF: FOPTO_21.PRG
