*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    FOPTO_12.PRG
*+
*+    Functions: Function FIXENTSAI()
*+               Function FOPTO12GRV()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн


function fopto_12
PARA DCORTE,DCORTF,cFILTRO

CABE2( 'FOPTO_12 - Transferir Relogio para Ponto' )

lPER:=.F.
IF VALTYPE(DCORTE)#"D".AND.VALTYPE(DCORTF)#"D"
   lPER:=.T.
   DCORTE := zdataini
   DCORTF := zdatafim
   if !MDG( 'Voce tem certeza' )
      retu
   endif
   MDS( 'Digite o periodo ' )
   @ 24, 40 get DCORTE
   @ 24, 60 get DCORTF
   if !READCUR()
      retu .F.
   endif
ENDIF

IF lPER
   if MDG( "Lancar Correcoes" )
      FOPTO_2I()
      lPER:=.F.
   else
      lPER:=.T.
   endif
ELSE
    FOPTO_2I(.F.)
ENDIF



cPE := "PE" + ANOMESW
cPN := "PN" + ANOMESW
cPD := "PD" + ANOMESW


MDS( 'Aguarde Estou Transferindo Dados' )
if ! netuse(cPD)
   retu
endif
IF VALTYPE(cFILTRO)="C"
  FILTRO := cFILTRO
ELSE
  FILTRO := FILTRO( "" )
ENDIF
set filter to &FILTRO
if ! NETUSE(cPN)
   dbcloseall()
   retu
endif
if ! NETUSE("FO_RELHR")
   dbcloseall()
   retu
endif
if ! NETUSE(cPE)
   dbcloseall()
   retu
endif
if ! NETUSE(PES)
   dbcloseall()
   retu
endif
if ! netuse("FOPTOHRE")
   dbcloseall()
   retu
ENDIF

if ! netuse("escalpad")
   dbcloseall()
   retu .f.
endif


@ 24,00 say space(80)
dbselectar(Cpd)
GRAPP := 1
GRAPT := lastrec()
GRAPT( 'AGUARDE TRANSFERINDO DADOS ' )
dbgotop()

while !eof()
   if DATA >= DCORTE .and. DATA <= DCORTF
      mGRUPO  := "  "
      mTURNO  := " "
      mCODREV := " "
//      NUM     := NUMERO         //Numero que passou
      mNUMERO := NUMERO         //Numero que passou ou Corrigido quando provisorio
      mDATA   := DATA
      mPIS    := PIS
      HOR     := 0
      HOR1    := 0
      nALMI   := 0
      nALMF   := 0
      nFALI   := 0
      nFALS   := 0
      RENT    := 0
      RSAI    := 0
      RALS    := 0
      RALE    := 0
      aHORAS  := {}
      
      @ 24, 00 SAY SPACE(80)
      @ 24, 00 say mNUMERO
      @ 24, 10 say mDATA
      @ 24, 20 say mPIS
      
            
      IF ! EMPTY(mPIS)
         dbselectar(PES)
         dbsetorder(4)
         dbgotop()
         IF dbseek(mPIS)           
            lNUMERO:=.F.
            while mPIS=PIS .AND. ! EOF() //verifica readmissao transferencia
               IF NUMERO=mNUMERO
                  lNUMERO:=.T.
                  EXIT
               endif   
               dbskip()
            enddo         
            IF ! lNUMERO
               mNUMERO:=0
            ENDIF
            IF NUMERO<>mNUMERO
               dbselectar( cPD ) // salta caso nao haja o funcionario
               dbskip()
               loop            
            ENDIF
         else
            dbselectar( cPD ) // salta caso nao haja o funcionario
            dbskip()
            loop
         ENDIF
         dbsetorder(1)
      ENDIF


      // ******************* Salta caso nao haja o funcionario
      dbselectar( PES )
      dbgotop()
      dbsetorder(1)
      if ! dbseek( mNUMERO )
         dbselectar( cPD )
         while NUMERO = mNUMERO .and. !eof() //NUMERO=NUM
            dbskip()
         enddo
         loop
      endif
      
      
      
      
      dbselectar( cPD )
      while NUMERO = mNUMERO .and. DATA = mDATA  .and. !eof()
         @ 24, 30 SAY RECNO()
         IF EMPTY(mPIS) .OR. PIS=mPIS         
            if HORA > 0.and.TIPOM<>"D"
               nHORA := HORA
               aadd( aHORAS, nHORA )
               if empty( HOR )
                  HOR := nHORA
               else
                  HOR1 := nHORA
               endif
            endif
         ELSE
            dbskip()
            LOOP         
         ENDIF   
         GRAPS()
         dbskip()
      enddo

      for K := 1 to 5
         if HOR + ( 0.01 * K ) = HOR1
            HOR1 := 0
         endif
      next K

      aTEMPHOR := aHORAS                //Retira Marcacoes Seguidas 5 minutos
      aHORAS   := {}
      for J := 1 to len( aTEMPHOR )
         nTHORA := aTEMPHOR[ J ]
         lTEM1  := .T.
         for K := 1 to 5
            if ascan( aTEMPHOR, nTHORA - ( 0.01 * K ) ) > 0
               lTEM1 := .F.
            endif
         next K
         if lTEM1
            aadd( aHORAS, aTEMPHOR[ J ] )
         endif
      next

      // ********************* Pega o Horario Basico do Funcionario
      aFOLGA  := {}
      aREF    := {}
      mMARALM := "S"
      mHORREF := ""
      peghorfix(mNUMERO)

      lESCALA := .F.
      lSAINOT := .F.
      lVIRADA := .F.
      lFERIADO:= .F.
      lTROCA  := .F.

      if !empty( mGRUPO ) .and. mTURNO = "S"                //Reveza e tem escala
         mESCALA := mGRUPO + dtos( mDATA )
         mSEQESC := 0
         dbselectar( cPE )
         dbgotop()
         if dbseek( mESCALA )
            lESCALA := .T.
            RENT    := CHOR( ENTREV )
            RALS    := CHOR( ALIREV )
            RALE    := CHOR( ALSREV )
            RSAI    := CHOR( SAIREV )
            mCODREV := CODREV
            mSEQESC := SEQ
         endif

         //Dia Seguinte verificar dia anterior
         mESCALA := mGRUPO + dtos( mDATA - 1 )
         dbselectar( cPE )
         dbgotop()
         if dbseek( mESCALA )
            if SAIREV < ENTREV
               lSAINOT := .T.
            ENDIF
         ELSE
            mSEQESC--     //1 dia do mes com DO pega sequencia da escala
            dbselectar("ESCALPAD")
            dbgotop()
            IF DBSEEK(mGRUPO+STR(mSEQESC,2))
               if SAIREV < ENTREV
                  lSAINOT := .T.
               endif
            endif
         endif
         dbselectar( cPN )

      else
         if empty( aREF[ dow( mDATA ), 1 ] )
            RENT := CHOR( aREF[ 8, 1 ] )
            RALS := CHOR( aREF[ 8, 2 ] )
            RALE := CHOR( aREF[ 8, 3 ] )
            RSAI := CHOR( aREF[ 8, 4 ] )
         else
            RENT := CHOR( aREF[ dow( mDATA ), 1 ] )
            RALS := CHOR( aREF[ dow( mDATA ), 2 ] )
            RALE := CHOR( aREF[ dow( mDATA ), 3 ] )
            RSAI := CHOR( aREF[ dow( mDATA ), 4 ] )
         endif
         if aFOLGA[ dow( mDATA ) ] = "S" .and. RENT > RSAI
            lSAINOT := .T.
         endif
         if aFOLGA[ dow( mDATA ) ] = "V" //Virada Noite/Dia
            lVIRADA := .T.
         endif
      endif

      // ****************************************
      CODOLD := ""
      mFOLSN := " "
      dbselectar( cPN )                 //Abre Arquivo de Ponto
      dbgotop()
      if dbseek( str( mNUMERO, 8 ) + dtos( mDATA ) )
         if  ! empty( CODREV )                     //Verifica se nAo h  horario especial no dia
             RENT    := CHOR( ENTREV )
             RALS    := CHOR( ALIREV )
             RALE    := CHOR( ALSREV )
             RSAI    := CHOR( SAIREV )
             mCODREV := CODREV
         endif
         CODOLD  := COD
         mFOLSN  := FOLSN
      endif
      IF (COD="FE".OR.SOD="FE").AND.RENT > RSAI
         lFERIADO:=.T.
      ENDIF
      IF VIRADA="S"
         lTROCA:=.T.
      ENDIF

      // ****************************************
      dbselectar( cPN )                 //Verifica  se nAo horario especial no dia anterior
      dbgotop()
      IF dbseek( str( mNUMERO, 8 ) + dtos( mDATA - 1 ) )
         if !empty( CODREV )                     //Verifica se nao h  horario especial no dia
            if ( aFOLGA[ dow( mDATA ) ] = "S".or.mFOLSN="S" .or. CODOLD = "FJ" ) .and. CHOR( ENTREV ) > CHOR( SAIREV )
               lSAINOT := .T.              //anterior ajusta saida noturno se hoje for folga
            endif
         ENDIF
         IF lFERIADO
            netreclock()
            FIELD->FOLSN:="V"
            DBUNLOCK()
         ENDIF
         IF (COD="FJ".or.COD="FD".or.COD="FI").AND.lSAINOT   //Falta e Falta Injustificada
            lSAINOT:=.F.
         ENDIF
         IF COD="FN".or.(COD="FE".and.ent=0) //retorno de ferias
            lSAINOT:=.F.
         ENDIF
         IF VIRADA="N"
            lSAINOT:=.F.
         ENDIF
      endif

      //Ajusta para Inversao de horarios Vigias//Turno Noturnos
      IF RENT > RSAI
         lTROCA := .T.
      ENDIF

      calchor1(1)

      IF ! empty( HOR ) .and. lVIRADA //trabalhou a noite saiu manha e voltou a tarde
         mONTEM =mDATA -1
         FOPTO12GRV( str( mNUMERO, 8 ) + dtos( mONTEM ), "SAI", "HOR" )
         IF LEN(aHORAS)>1
            HOR:=aHORAS[2]
         ENDIF
         IF len(aHORAS)>2
            HOR1:=aHORAS[3]
         ENDIF
         //Ahoras(1) e a saida da noite anterior
         calchor1(2)
      ENDIF

      //Evita duplicacoes de horarios
      IF HOR1=HOR
         HOR1:=0
      ENDIF

      do case

          case lTROCA .and. !empty( HOR1 ) .and. !empty( HOR ) .and. HOR1 > HOR
             FOPTO12GRV( str( mNUMERO, 8 ) + dtos( mDATA ), "ENT", "HOR1" )
             mDATA --
             nDIFF := abs( aHORAS[ 1 ] - RSAI )
             for Z := 2 to len( aHORAS )
                if abs( aHORAS[ Z ] - RSAI ) < nDIFF
                   nDIFF := abs( aHORAS[ Z ] - RSAI )
                   HOR   := aHORAS[ Z ]
                endif
             next
             FOPTO12GRV( str( mNUMERO, 8 ) + dtos( mDATA ), "SAI", "HOR" )

          case empty( HOR1 ) .and. !empty( HOR ) .and. lTROCA .and. !lSAINOT
             FOPTO12GRV( str( mNUMERO, 8 ) + dtos( mDATA ), "ENT", "HOR" )

          case !empty( HOR ) .and. empty( HOR1 ) .and. lSAINOT
             mDATA --
             FOPTO12GRV( str( mNUMERO, 8 ) + dtos( mDATA ), "SAI", "HOR" )


          otherwise
             BUSCA := str( mNUMERO, 8 ) + dtos( mDATA )
             dbgotop()
             if dbseek( BUSCA )
                netreclock()
                if !empty( HOR1 )
                   if HOR < HOR1
                      field->ENT := HOR
                      field->SAI := HOR1
                   else
                      field->ENT := HOR1
                      field->SAI := HOR
                   endif
                else
                   nHREN := 0
                   nHRSA := 0
                   nFHRE := 0
                   nFHRS := 0
                   if !empty( aHORAS ) .and. !empty( RENT ) .and. !empty( RSAI )
                      for j := 1 to len( aHORAS )
                         nCALCI := abs( RENT - aHORAS[ J ] )
                         nCALCS := abs( RSAI - aHORAS[ J ] )
                         if ( empty( nFHRE ) .or. nFHRE > nCALCI ) .and. !empty( nHREN )
                            if nCALCI = 0
                               nCALCI := .01                    //Fixa 1 para nao errar no reprocesso
                            endif
                            nFHRE := nCALCI
                            nHREN := aHORAS[ J ]
                         endif
                         if empty( nFHRS ) .or. nFHRS > nCALCS
                            nFHRS := nCALCS
                            nHRSA := aHORAS[ J ]
                         endif
                      next J
                      field->ENT := nHREN
                      field->SAI := nHRSA
                   else
                      field->ENT := HOR
                   endif
                endif
                FIXENTSAI()
                dbunlock()
             endif
      endcase

      //Calcula o Almoco
      if !empty( aHORAS ) .and. !empty( RALS ) .and. !empty( RALE )
         for j := 1 to len( aHORAS )
            nCALCI := abs( RALS - aHORAS[ J ] - .25 )       //Referencia 15 minutos depois
            nCALCS := abs( RALE - aHORAS[ J ] )
            if ( empty( nFALI ) .or. nFALI > nCALCI ) .and. aHORAS[ J ] # ENT
               if nCALCI = 0
                  nCALCI := .01         //Fixa 1 para nao errar no reprocesso
               endif
               nFALI := nCALCI
               nALMI := aHORAS[ J ]
            endif
            if ( empty( nFALS ) .or. nFALS > nCALCS ) .and. aHORAS[ J ] # SAI .and. aHORAS[ J ] # ENT
               nFALS := nCALCS
               nALMF := aHORAS[ J ]
            endif
         next J
         if nALMF = nALMI .or. empty( nALMI )               //Horarios Coincidente tenta o anterior
            nPOSA := ascan( aHORAS, nALMF )
            nPOSA --                    //Pegar Horario Seguinte
            if nPOSA >= 2               //1a. Sempre entrada
               nTEMPH := aHORAS[ nPOSA ]
               if nTEMPH # SAI .and. nTEMPH # ENT .and. nTEMPH <> nALMI
                  nALMI := nTEMPH
               endif
            endif
         endif
         if nALMF = nALMI .or. empty( nALMF )               //Horarios Coincidente tenta o seguinte
            nPOSA := ascan( aHORAS, nALMI )
            nPOSA ++                    //Pegar Horario Seguinte
            if nPOSA <= len( aHORAS )
               nTEMPH := aHORAS[ nPOSA ]
               if nTEMPH # SAI .and. nTEMPH # ENT .and. nTEMPH <> nALMF
                  nALMF := nTEMPH
               endif
            endif
         endif

      endif

      //Diversas marcacoes do cartao em menos de cinco minutos
      lGRVALM:=.T.
      IF nALMI # ENT .and. nALMI # SAI
         lGRVALM:=.F.
      ENDIF
      IF ENT>0.AND.nALMI>0.AND.ABS(ENT-nALMI)>5
         lGRVALM:=.F.
      ENDIF
      IF ENT>0.AND.nALMF>0.AND.ABS(ENT-nALMF)>5
         lGRVALM:=.F.
      ENDIF
      IF SAI>0.AND.nALMI>0.AND.ABS(SAI-nALMI)>5
         lGRVALM:=.F.
      ENDIF
      IF SAI>0.AND.nALMF>0.AND.ABS(SAI-nALMF)>5
         lGRVALM:=.F.
      ENDIF



      netreclock()
      if !empty( nALMI ) .and. !empty( RALS ) .and. lGRVALM .and. abs( nALMI - RALS ) < 2
         field->ALS := nALMI
      else
         field->ALS := 0
      endif
      if !empty( nALMF ) .and. !empty( RALE ) .and. lGRVALM .and. abs( nALMF - RALE ) < 2
         field->ALE := nALMF
      else
         field->ALE := 0
      endif
      if !lTROCA
         if empty( SAI ) .and. !empty( ENT )
            if abs( RENT - ENT ) > abs( RSAI - SAI )
               field->SAI := ENT
               field->ENT := 0
            endif
         endif
         if empty( ENT ) .and. !empty( SAI )
            if abs( RENT - ENT ) < abs( RSAI - SAI )
               field->ENT := SAI
               field->SAI := 0
            endif
         endif
      endif
      if mMARALM = "N"
         field->ALS := 0
         field->ALE := 0
      endif
      dbunlock()
      dbselectar( cPD )
   else             //Fora data de Corte
      dbselectar( cPD )
      dbskip()
   endif
enddo
dbcloseall()

IF lPER
ELSE
//    FOPTO_2I(.F.)  acima para lancar aftderr e inclusoes cPM
    FOPTO_2J(.F.)
    FOPTO_2H(.F.)
ENDIF
retu

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function FIXENTSAI()
*+
*+    Called from ( fopto_12.prg )   2 - function fopto1101()
*+                                   1 - function fopto12grv()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func FIXENTSAI

if !empty( ENT ) .and. !empty( SAI ) .and. !lTROCA .and. !lSAINOT
   if abs( SAI - ENT ) < .15
      field->SAI := 0
   endif
   if abs( ENT - SAI ) < .15
      field->SAI := 0
   endif
endif
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function FOPTO12GRV()
*+
*+    Called from ( fopto_12.prg )  10 - function fopto1101()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func FOPTO12GRV( eBUSCA, cCAM, cVAL )

dbgotop()
if dbseek( eBUSCA )
   netreclock()
   field->&cCAM. := &cVAL.
   FIXENTSAI()
   dbunlock()
endif

func calchor1(nINICIO)
if !empty( RENT ) .and. !empty( RSAI ) .and. !empty( aHORAS ) .and. !lTROCA
   nHREN := 0
   nHRSA := 0
   nFHRE := 0
   nFHRS := 0
   for j := nINICIO to len( aHORAS )
      nCALCI := abs( RENT - aHORAS[ J ] )
      nCALCS := abs( RSAI - aHORAS[ J ] )
      if ( empty( nFHRE ) .or. nFHRE > nCALCI ) .and. !empty( nHREN )
         if nCALCI = 0
            nCALCI := .01         //Fixa 1 para nao errar no reprocesso
         endif
         nFHRE := nCALCI
         nHREN := aHORAS[ J ]
      endif
      if empty( nFHRS ) .or. nFHRS > nCALCS
         nFHRS := nCALCS
         nHRSA := aHORAS[ J ]
      endif
   next J
   if !empty( nHREN )
      HOR := nHREN
   endif
   if !empty( nHRSA ) .and. HOR1 < nHRSA
      HOR1 := nHRSA
   endif
endif

*+ EOF: FOPTO_12.PRG
