*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => J:\ITAESBRA\M_A2.PRG
*+
*+    Functions: Function MA26()
*+               Function Ma2lanhor()
*+               Function MA2MEDSEQ()
*+               Function MA2MEDSEQC()
*+               Function MA2CALLED()
*+               Function MA2MEDPRG()
*+               Function MA2CHKPRG()
*+               Function MAS2CHKARQ()
*+               Function MA2PLTINV()
*+               Function MA2PLT01()
*+
*+    Reformatted by Click! 2.03 on May-29-2003 at  3:16 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MA26()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MA26

dDATA := ZDATA
MDS( "Qual Data" )
@ 24, 40 get dDATA
if !READCUR()
   retu .F.
endif
CRIARVARS( "MS04BX" )
if !USEREDE( "CRM", 1, 2 )
   dbcloseall()
   retu .F.
endif
dbselectar( "CRM" )
dbgotop()
dbseek( dDATA )
while dDATA = DATA .and. !eof()
   if TIPOE = "T"
      lGRAVOU := .F.
      for X := 1 to 2
         xCODIGO    := padr( PRODUTO, 24 )
         xNRNOTAINI := val( PEDIDO )
         xNRNOTASAI := if( X = 1, NRNOTA, NRNOTB )
         xDATASAI   := DATA
         xTOTKGSAI  := if( X = 1, QTDEA, QTDEB )
         xCRM       := CRM
         do case
         case CRM->GRAVOU = "S"
            ALERTX( "Crm: " + str( xCRM ) + " Ja Gravado" )
         case empty( xCODIGO )
            ALERTX( "Crm: " + str( xCRM ) + " sem Codigo Produto" )
         case empty( xNRNOTASAI )
            ALERTX( "Crm: " + str( xCRM ) + " sem numero nota entrada" )
         case empty( xNRNOTAINI )
            ALERTX( "Crm: " + str( xCRM ) + " sem numero nota(PEDIDO)" )
         case empty( xDATASAI )
            ALERTX( "Crm: " + str( xCRM ) + " sem data" )
         case empty( xTOTKGSAI )
            ALERTX( "Crm: " + str( xCRM ) + " sem quantidade" )
         otherwise
            if IGUALVARS( "MS04", xCODIGO + str( xNRNOTAINI, 8 ) )
               mDATASAI   := xDATASAI
               mNRNOTAINI := xNRNOTAINI
               mNRNOTASAI := xNRNOTASAI
               mTOTKGSAI  := xTOTKGSAI
               mTOTKGEST  := mTOTKGANT - mTOTKGSAI
               mCRM       := xCRM
               BAIXAREM( "MS04", "MS04BX", mCODIGO + str( mNRNOTAINI ) )
               lGRAVOU := .T.
            else
               ALERTX( "No Encontrei Nota: " + str( xNRNOTAINI, 8 ) + " Codigo " + xCODIGO )
            endif
         endcase
      next X
      if lGRAVOU
         dbselectar( "CRM" )
         netgrvcam("GRAVOU","S")
      endif
   endif
   dbselectar( "CRM" )
   dbskip()
enddo
dbcloseall()

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function Ma2lanhor()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func Ma2lanhor

nHORAS := 0.00
MDI( "Lanar Horas" )
MDS( "Digite Quantidade Horas" )
@ 24, 40 get nHORAS
if !READCUR()
   retu .F.
endif
FILTRO := ''
FILTRO := RFILORD( "MS01", .F. )
if !USEREDE( "MS01", 1, 0 )
   retu .F.
endif
if !empty( FILTRO )
   set filter to &FILTRO
endif
dbgotop()
while !eof()
   netgrvcam("PCPRGHOR",nHORAS)
   dbskip()
enddo
dbclosearea()

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MA2MEDSEQ()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MA2MEDSEQ

MDI( " н Apurar Media Sequencia" )
if !MDG( "As ApuraЦo Desempenho EstЦo OK" )
   retu .F.
endif
cMEDIA := "M"
@ 24, 00 say "(M)edia (1)Aux1 (2)Aux2 (I)nt"
@ 24, 50 get cMEDIA
if !READCUR()
   retu .F.
endif
aPER   := PEDPER( .T. )
mMESES := aPER[ 7 ]
if !aPER[ 5 ]
   retu .F.
endif
if !USEMULT( { { "RDT", 1, 1 }, { "MS06", 1, 1 } } )
   dbcloseall()
   retu .F.
endif
dbselectar( "MS06" )
dbgotop()
while !eof()
   netreclock()
   do case
   case cMEDIA = "M"
      field->PCHORMED := 0
   case cMEDIA = "I"
      field->PCHORAMD := 0
   case cMEDIA = "1"
      field->PCHORAX1 := 0
   case cMEDIA = "2"
      field->PCHORAX2 := 0
   endcase
   dbunlock()
   dbskip()
enddo

dbselectar( "RDT" )
dbgotop()
while !eof()
   mCODIGO := alltrim( CODIGO )
   mSEQ    := SEQ
   mSSQ    := SSQ
   mQTD    := 0
   mHOR    := 0
   while mSEQ = SEQ .and. mSSQ = SSQ .and. mCODIGO = trim( CODIGO ) .and. !eof()
      @ 24, 00 say mCODIGO + " " + str( SEQ ) + " " + str( SSQ ) + " " + str( MES ) + " " + str( ANO ) + " " + strzero( recno() )
      CALCPER( aPER, ANO, MES, { || MA2MEDSEQC() } )
      dbskip()
   enddo
   if mQTD > 0 .and. mHOR > 0
      dbselectar( "MS06" )
      dbgotop()
      if dbseek( padr( mCODIGO, 24 ) + str( mSEQ, 3 ) + str( mSSQ, 3 ) )
         netreclock()
         do case
         case cMEDIA = "M"
            field->PCHORMED := mQTD / mHOR
         case cMEDIA = "I"
            field->PCHORAMD := mQTD / mHOR
         case cMEDIA = "1"
            field->PCHORAX1 := mQTD / mHOR
         case cMEDIA = "2"
            field->PCHORAX2 := mQTD / mHOR
         endcase
         if PCHORMED > 0
            field->PCHORMEQ := 1 / PCHORMED
         endif
         dbunlock()
      endif
   endif
   dbselectar( "RDT" )
enddo
dbcloseall()

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MA2MEDSEQC()
*+
*+    Called from ( m_a2.prg     )   1 - function ma2medseq()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MA2MEDSEQC

mQTD += PQTDDE
mHOR += PHORAS
retu

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MA2CALLED()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MA2CALLED

MDI( "Calculando Leading-Time" )
if !USEMULT( { { "MS01", 1, 1 }, { "MS06", 1, 1 } } )
   retu .F.
endif
FILTRO := ''
FILTRO := RFILORD( "MS01", .F. )
if !USEREDE( "MS01", 1, 0 )
   retu .F.
endif
if !empty( FILTRO )
   set filter to &FILTRO
endif
dbgotop()
while !eof()
   mCODIGO := alltrim( CODIGO )
   @ 24, 00 say mCODIGO
   if PCPRGMED > 0 .and. PCPRGHOR > 0
      mPCPRGMED := PCPRGMED
      mPCPRGHOR := PCPRGHOR
      dbselectar( "MS06" )
      dbseek( mCODIGO )
      while mCODIGO = alltrim( CODIGO ) .and. !eof()
         netreclock()
         if PCHORMEQ > 0
            field->PCHORDIA := ( 1 / mPCPRGHOR ) * PCHORMEQ
            field->LEADCALC := mPCPRGMED * PCHORDIA
            field->PCHORNEC := mPCPRGMED * PCHORMEQ
            field->LEADARRE := round( LEADCALC + .5, 0 )
         else
            field->PCHORDIA := 0
            field->LEADCALC := 0
         endif
         dbunlock()
         dbskip()
      enddo
   endif
   dbselectar( "MS01" )
   dbskip()
enddo
if !MDG( "Calcular Prz-Dias" )
   dbcloseall()
   retu .T.
endif
dbselectar( "MS01" )
dbgotop()
while !eof()
   mCODIGO := CODIGO
   @ 24, 00 say mCODIGO
   nTOTAL := 0
   //   nRECNO:=0
   dbselectar( "MS06" )
   dbgotop()
   dbseek( mCODIGO )
   while alltrim( mCODIGO ) = alltrim( CODIGO ) .and. !eof()
      nTOTAL += LEADARRE
      nRECNO := recno()
      dbskip()
   enddo
   dbgotop()
   dbseek( mCODIGO )
   while alltrim( mCODIGO ) = alltrim( CODIGO ) .and. !eof()
      netreclock()
      field->LIMTIME := nTOTAL
      dbunlock()
      nTOTAL -= LEADARRE
      if nTOTAL <= 0
         nTOTAL := 1
      endif
      dbskip()
   enddo
   dbselectar( "MS01" )
   dbskip()
enddo
dbcloseall()
retu .T.

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MA2MEDPRG()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MA2MEDPRG( nTIPO )

if !MDG( "As ApuraЦo Entrega EstЦo OK" )
   retu .F.
endif
aPER := PEDPER( .T. )
if !aPER[ 5 ]
   retu .F.
endif
if nTIPO = 1
   if !USEMULT( { { "BS5", 1, 2 }, { "MS01", 1, 2 } } )
      dbcloseall()
      retu .F.
   endif
else
   if !USEMULT( { { "BS5", 1, 2 }, { "OP01", 1, 2 } } )
      dbcloseall()
      retu .F.
   endif
endif
IF nTIPO=1
   DBSELECTAR("MS01")
   DBGOTOP()
   WHILE ! EOF()
       netgrvcam("PCPRGMED",0)
       DBSKIP()
   ENDDO
ELSE
   DBSELECTAR("OP01")
   DBGOTOP()
   WHILE ! EOF()
       netreclock()
       field->VMED := 0
       field->VMEQ := 0
       dbunlock()
       DBSKIP()
   ENDDO
ENDIF
dbselectar( "BS5" )
dbgotop()
while !eof()
   mCODIGO := alltrim( CODIGO )
   mQTD    := 0
   while mCODIGO = trim( CODIGO ) .and. !eof()
      @ 24, 00 say mCODIGO + " " + str( MES ) + " " + str( ANO ) + " " + strzero( recno() )
      CALCPER( aPER, ANO, MES, { || mQTD := mQTD + QTDDE } )
      dbskip()
   enddo
   if mQTD > 0
      if nTIPO = 1
         dbselectar( "MS01" )
         dbgotop()
         if dbseek( mCODIGO )
            netgrvcam("PCPRGMED",mQTD / aPER[ 7 ])
         endif
      else
         dbselectar( "OP01" )
         dbgotop()
         if dbseek( mCODIGO )
            netreclock()
            field->VMED := mQTD / aPER[ 7 ]                 //QTDE/N Meses
            field->VMEQ := VMED / 2     //Quinzenal
            dbunlock()
         endif
      endif
   endif
   dbselectar( "BS5" )
enddo
dbcloseall()

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MA2CHKPRG()
*+
*+    Called from ( m_a2.prg     )   1 - function ma2pltinv()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MA2CHKPRG(lSOOP)
IF VALTYPE(lSOOP)#"L"
   lSOOP:=.F.
ENDIF

MDI( "Checando Produto ComposiЦo Sequencia" )
if !USEMULT( { { "MA01", 1, 1 },{ "MS01", 1, 2 },{ "MS01X", 1, 1 }, { "OP01", 1, 0 } } )
   retu .F.
endif
dbselectar( "MS01" )
while !eof()
   netreclock()
   if empty( PCPRGMED ).AND.EMPTY(ESTQSAL).AND.(EMPTY(ULTIMOFA).OR.(ZDATA-ULTIMOFA)>180)
      field->ATIVO := "N"
   ELSE
      field->ATIVO := "S"
   endif
   if empty( CLIPCP )
      field->CLIPCP := FORNECEDO
   endif
   dbunlock()
   dbskip()
enddo
dbselectar( "op01" )
dbgotop()
while !eof()
   mCODIGO := CODIGO
   mATIVO  := ATIVO
   mCODIGOINT:=""
   mNOME:=""
   mCLIENTE:=CLIENTE
   mCOGNOME:=COGNOME
   MDS( mCODIGO )
   dbselectar( "ms01" )
   dbgotop()
   if dbseek( Mcodigo )
      IF EMPTY(ATIVO)
         GRAVACAMPO({"ATIVO"},{"'S'"})
      endif         
      mCODIGOINT:=CODIGOINT
      mNOME:=NOME
      mCLIENTE:=FORNECEDO
   ENDIF         
   IF EMPTY(mCODIGOINT).OR.EMPTY(mCLIENTE).OR.EMPTY(mNOME)
      dbselectar( "ms01X" )
      dbgotop()
      if dbseek( Mcodigo )
         IF EMPTY(mCODIGOINT)
            mCODIGOINT:=CODIGOINT
         ENDIF   
         IF EMPTY(mNOME)
            mNOME:=NOME
         ENDIF
         IF EMPTY(MCLIENTE)
            mCLIENTE:=FORNECEDO
         ENDIF   
      endif
   ENDIF
   IF EMPTY(mCOGNOME)
      dbselectar( "MA01" )
      dbgotop()
      if dbseek( MCLIENTE )
         mCOGNOME:=COGNOME      
      ENDIF
   ENDIF
   dbselectar( "op01" )
   IF EMPTY(CODIGOINT).AND.! EMPTY(mCODIGOINT)
      GRAVACAMPO({"CODIGOINT"},{"mCODIGOINT"})
   ENDIF
   IF EMPTY(NOME).AND.! EMPTY(mNOME)
      GRAVACAMPO({"NOME"},{"mNOME"})
   ENDIF   
   IF EMPTY(COGNOME).AND.! EMPTY(mCOGNOME)
      GRAVACAMPO({"COGNOME"},{"mCOGNOME"})
   ENDIF   
   IF EMPTY(CLIENTE).AND.! EMPTY(mCLIENTE)
      GRAVACAMPO({"CLIENTE"},{"mCLIENTE"})
   ENDIF   
   dbskip()
enddo
dbcloseall()
IF lSOOP
   RETU
ENDIF
IF MDG("Excluir Composicao Produtos Inativos")
   MAS2CHKARQ( "MS03" )
ENDIF
IF MDG("Excluir Operacoes Produtos Inativos")
   MAS2CHKARQ( "MS06" )
ENDIF

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MAS2CHKARQ()
*+
*+    Called from ( m_a2.prg     )   2 - function ma2chkprg()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MAS2CHKARQ( cARQ )

IF cARQ="MS06"
   if !USEMULT( { { "MS01", 1, 2 }, { cARQ, 1, 99 },{"MS06BX",1,99} } )
      retu .F.
   endif
ELSE
   if !USEMULT( { { "MS01", 1, 2 }, { cARQ, 1, 99 } } )
      retu .F.
   endif
endif
dbselectar( cARQ )
INITVARS()
CLRVARS()
dbgotop()
while !eof()
   mCODIGO := alltrim( CODIGO )
   MDS( mCODIGO )
   lTEM := .F.
   dbselectar( "MS01" )
   dbgotop()
   if dbseek( mCODIGO )
      if ATIVO <> "N"
         lTEM := .T.
      endif
   endif
   dbselectar( cARQ )
   while mCODIGO = alltrim( CODIGO ) .and. !eof()
      if !lTEM
         IF cARQ="MS06"
            EQUVARS()
            NOVOOPA("MS06BX",,,.F.)
         ENDIF
         dbselectar( cARQ )
         netrecdel()
      endif
      dbskip()
   enddo
enddo
dbcloseall()
if userede(Carq,0,99)
   dbselectar( cARQ )
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   DBEVAL({|| netrecdel()},{|| EMPTY(CODIGO)}, {|| zei_fort(nLASTREC,,,1)})
   if cARQ = "MS03"
      zei_fort( nLASTREC,,,0)
      DBEVAL({|| netrecdel()},{|| EMPTY(CODCOMP)}, {|| zei_fort(nLASTREC,,,1)})
   endif
   pack
   dbcloseall()
endif

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MA2PLTINV()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MA2PLTINV

//Checa Itens Ativos sequencia composiao
IF MDG("Checar Composiao Sequencia")
   MA2CHKPRG()
ENDIF

IF MDG("Calcular Preo Inventario MatPrima")
   CALCINV("M")
ENDIF

IF MDG("Calcular Preo Inventario Componentes")
   CALCINV("C")
ENDIF

IF MDG("Calcular Preo Inventario Produtos")
   MASCALINV()
ENDIF


if !USEMULT( { { "MS01", 1, 99 }, { "MS06", 1, 99 }, { "MT01", 1, 99 }, { "MU01", 1, 99 }, { "MS03", 1, 99 } } )
   retu .F.
endif
dbselectar( "MS01" )
MDS()
dbgotop()
while !eof()
   cCODIGO := alltrim( CODIGO )
   if empty( PLTINV )
      netgrvcam("PLTINV",PLTINV)
   endif
   mPLANTA := PLTINV
   if mPLANTA > 0
      @ 24, 00 say CODIGO
      dbselectar( "MS06" )
      dbgotop()
      dbseek( cCODIGO )
      while cCODIGO = alltrim( CODIGO ) .and. !eof()
         @ 24, 40 say SEQ
         @ 24, 44 say SSQ
         if PLTINV <> mPLANTA
            netgrvcam("PLTINV",mPLANTA)
         endif
         dbskip()
      enddo
      dbselectar( "MS03" )
      dbgotop()
      dbseek( cCODIGO )
      while cCODIGO = alltrim( CODIGO ) .and. !eof()
         if TIPOENT = "C" .or. TIPOENT = "M"
            @ 24, 40 say CODCOMP
            cSUBCOD := alltrim( CODCOMP )
            dbselectar( if( TIPOENT = "C", "MT01", "MU01" ) )
            dbgotop()
            if dbseek( cSUBCOD )
               if PLTINV <> mPLANTA
                  netgrvcam("PLTINV",mPLANTA)
               endif
            endif
         endif
         dbselectar( "MS03" )
         dbskip()
      enddo
   endif
   dbselectar( "MS01" )
   netgrvcam("VALFATINV",0)
   dbskip()
enddo
MA2PLT01( "MT01" )
MA2PLT01( "MU01" )
MA2PLT01( "MS01" )
MA2PLT01( "MS06" )
dbcloseall()

IF MDG("Calcular Faturamento Mes")
   ma2pltfat()
endif
retu

func ma2pltfat()
aDAD := PEGMES( { "M2" } )
nMES := aDAD[ 1]
nANO := aDAD[ 2]
cARQ:= aDAD[5][1]


IF ! USEMULT({{"MS01",1,99},{caRQ,1,0}})
   RETU .F.
ENDIF
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","TIPOENT+CODIGO")
ordSetFocus("temp")


DBSELECTAR(cARQ)
DBGOTOP()
DBSEEK("P") //Acha o Primeiro Produto
WHILE TIPOENT="P".AND.! EOF()
   @ 24,00 SAY RECNO()
   mCODIGO:=CODIGO
   mVAL:=0
   WHILE mCODIGO=CODIGO.AND.TIPOENT="P".AND.! EOF()
     mVAL+=VALORMER
     DBSELECTAR(cARQ)
     DBSKIP()
   ENDDO
   IF mVAL>0
      DBSELECTAR("MS01")
      DBGOTOP()
      IF DBSEEK(mCODIGO)
         netgrvcam("VALFATINV",mVAL)
      ENDIF
   ENDIF
   DBSELECTAR(cARQ)
ENDDO
dbcloseaLL()


MA2PLT02("MS01","FAT")
MA2PLT02("MS01")
MA2PLT02("MS06")
MA2PLT02("MT01")
MA2PLT02("MU01")


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MA2PLT02()
*+
*+    Called from ( m_a2.prg     )   2 - function ma2pltinv()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MA2PLT02( cARQ ,cVAL)
IF VALTYPE(cVAL)#"C"
   cVAL:="EST"
ENDIF
IF ! USEMULT({{cARQ,1,0},{"MSINV",1,99},{"MA01",1,1}})
   RETU .F.
ENDIF
IF cARQ="MS01".AND.cVAL="FAT" //Apaga Competencia
   DBSELECTAR("MSINV")
   DBGOTOP()
   WHILE ! EOF()
      @ 24,00 SAY RECNO()
      IF MES=nMES.AND.ANO=nANO
         netrecdel()
      ENDIF
      DBSELECTAR("MSINV")
     DBSKIP()
   ENDDO
ENDIF
MDS( cARQ )
dbselectar( cARQ )

nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","PLTINV")
ordSetFocus("temp")


dbgotop()
while !eof()
   @ 24, 10 say CODIGO
   mVAL:=0
   mPLTINV:=PLTINV
   WHILE mPLTINV=PLTINV.AND. ! EOF()
     IF cVAL="FAT"
        mVAL+=VALFATINV
     ELSE
        IF PLTINV>0.AND.ESTQSAL>0              //Menos 1 Inativo
           mVAL+=ESTQSAL*VALINV
        ENDIF
     ENDIF
     dbskip()
   enddo
   IF mVAL>0
      mCOGNOME:=""
      DBSELECTAR("MA01")
      DBGOTOP()
      IF DBSEEK(mPLTINV)
         mCOGNOME:=COGNOME
      ENDIF
      DBSELECTAR("MSINV")
      DBGOTOP()
      IF ! DBSEEK(STR(mPLTINV,8)+STR(nANO,4)+STR(nMES,2))
         netrecapp()
         FIELD->CLIENTE:=mPLTINV
         FIELD->COGNOME:=mCOGNOME
         FIELD->MES:=nMES
         FIELD->ANO:=nANO
      ELSE
         netreclock()
      ENDIF
      DO CASE
         CASE cARQ="MT01"
              FIELD->MAT:=mVAL
         CASE cARQ="MU01"
              FIELD->COM:=mVAL
         CASE cARQ="MS01".AND.cVAL="FAT"
              FIELD->FAT:=mVAL
         CASE cARQ="MS01"
              FIELD->EST:=mVAL
         CASE cARQ="MS06"
              FIELD->PRO:=mVAL
      ENDCASE
      FIELD->MATCOM:=MAT+COM
      FIELD->ESP   :=EST+PRO
      FIELD->TOT   :=MAT+COM+PRO+EST
      FIELD->MATP:=PERC(MAT,FAT)
      FIELD->COMP:=PERC(COM,FAT)
      FIELD->MATCOMP:=PERC(MATCOM,FAT)
      FIELD->ESTP:=PERC(EST,FAT)
      FIELD->PROP:=PERC(PRO,FAT)
      FIELD->ESPP:=PERC(ESP,FAT)
      FIELD->TOTP:=PERC(TOT,FAT)
      DBUNLOCK()
   ENDIF
   DBSELECTAR(cARQ)
enddo
DBCLOSEALL()

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function MA2PLT01()
*+
*+    Called from ( m_a2.prg     )   2 - function ma2pltinv()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func MA2PLT01( cARQ )

MDS( cARQ )
dbselectar( cARQ )
dbgotop()
while !eof()
   @ 24, 10 say CODIGO
   if empty( PLTINV )
      GRAVACAMPO({"PLTINV"},{"-1"})  //Menos 1 Inativo
   endif
   dbskip()
enddo


*+ EOF: M_A2.PRG
