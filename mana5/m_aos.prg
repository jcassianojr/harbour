// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_aos.prg
// +
// +
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +
// +
// +
// +    Documentado em 28-Dez-2024 as  9:56 am
// +
// +
// +
// +--------------------------------------------------------------------
// +


MDI( " Ý Gerar Acumulado Programacao" )
mTIPARQ := "S"
mTIPOPR := "A"
cARQORI := "OSPRG"
cARQDES := "OSPRA"

mDATAINI := ZDATA
WHILE DoW( mDATAINI ) # 2
mDATAINI--
ENDDO
mDATAACM := mDATAINI
mDATAFIM := mDATAINI + 6
nSEMANAS := 8

// Remover Depois de apagar lista tipo da base dados
mLISTA := ""
mTIPO  := ""


@ 17, 00 SAY "(S)emanal (D)iario (P)edidos Electrolux->D(E)lfor (O)rders"
@ 17, 60 GET mTIPARQ                                                      VALID mTIPARQ $ "SDPEO"
@ 18, 00 SAY "(A)cumular Excluir->Periodo (E)ntrega (P)rograma Acumulo"
@ 18, 60 GET mTIPOPR                                                      VALID mTIPOPR $ "AEP"
@ 20, 00 SAY "Data Acumulacao"
@ 20, 25 GET mDATAACM                                                     WHEN mTIPOPR $ "AP"
@ 21, 00 SAY "Periodo "
@ 21, 25 GET mDATAINI                                                     WHEN mTIPOPR $ "AE"
@ 21, 35 GET mDATAFIM                                                     WHEN mTIPOPR $ "AE"
@ 22, 00 SAY "Semanas a Acumular"
@ 22, 25 GET nSEMANAS                                                     PICT "99"               WHEN mTIPOPR $ "A"
IF !READCUR()
RETU .F.
ENDIF


DO CASE
CASE mTIPARQ = "S"
cARQORI := "OSPRG"
cARQDES := "OSPRA"
CASE mTIPARQ = "D"
cARQORI := "OSPR2"
cARQDES := "OSPRD"
CASE mTIPARQ = "O"
cARQORI := "OSPR3"
cARQDES := "OSPRF"
CASE mTIPARQ = "E"
cARQORI := "OSPRE"
cARQDES := "OSPRB"
CASE mTIPARQ = "P"
cARQORI := "MO02"
cARQDES := "OSPRO"
ENDCASE

IF !USEMULT( { { cARQORI, 0, 99 }, { cARQDES, 0, 99 } } )
RETU .F.
ENDIF
dbSelectAr( cARQDES )
nLASTREC := LastRec()
IF mTIPOPR = "P" .OR. mTIPOPR = "A"
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| DATAACM = mDATAACM }, {|| zei_fort( nLASTREC,,, 1 ) } )
PACK
ENDIF
IF mTIPOPR = "E"
nLASTREC := LastRec()
zei_fort( nLASTREC,,, 0 )
dbEval( {|| netrecdel() }, {|| DATAPRG >= mDATAINI .AND. DATAPRG <= mDATAFIM }, {|| zei_fort( nLASTREC,,, 1 ) } )
PACK
ENDIF
IF mTIPOPR = "A"
dbSelectAr( cARQORI )
IF mTIPARQ = "P"
dbSetOrder( 3 )   // Codigo Produto MO02
ELSE
dbSetOrder( 2 )   // Produto Programacoes ospr?
ENDIF
nLASTREC := LastRec()
FOR X := 1 TO nSEMANAS
mDATAPRG := mDATAINI
@ 23, 10 SAY mDATAINI
@ 23, 20 SAY mDATAFIM
@ 23, 30 SAY X
dbGoTop()
WHILE !Eof()
@ 23, 00 SAY RecNo()
ZEI_FORT( nLASTREC )
mPRODUTO := IF( mTIPARQ = "P", CODIGO, PRODUTO )
@ 23, 32 SAY mPRODUTO
mQTDE := 0
WHILE mPRODUTO = IF( mTIPARQ = "P", CODIGO, PRODUTO ) .AND. !Eof()
mPROGRAMA := IF( mTIPARQ = "P", ENTREGA, PROGRAMA )
IF mPROGRAMA >= mDATAINI .AND. mPROGRAMA <= mDATAFIM
@ 23, 70 SAY mPROGRAMA
mQTDE += IF( mTIPARQ = "P", CONVUN( QTDEPED, UNID ), QTDE )
ENDIF
dbSkip()
ENDDO
IF mQTDE > 0 .AND. !Empty( mPRODUTO )
dbSelectAr( cARQDES )
netrecapp()
REPLVARS()
ENDIF
dbSelectAr( cARQORI )
ENDDO
mDATAINI := mDATAINI + 7
mDATAFIM := mDATAFIM + 7
NEXT X
ENDIF
dbCloseAll()


// + EOF: m_aos.prg
// +
