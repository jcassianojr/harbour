*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BDIL.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"

function m_bdil
para cTIPOLIV
IF VALTYPE(cTIPOLIV)#"C"
   cTIPOLIV:="S"
ENDIF

MDI(" Э Imprimir Livros Fiscal")

if !CHECKIMP( 0 )
   retu .F.
endif



DO CASE
  CASE cTIPOLIV="E"
     aRETU := PERFEC( { "MK01", "MK06" }, { "K1", "K6" }, { "MK91", "MK96" } )
  CASE cTIPOLIV="SE"
     aRETU := PERFEC( { "MK01", "MK09" }, { "K1", "K9" }, { "MK91", "MK90" } )
  CASE cTIPOLIV="SS"
     aRETU := PERFEC( { "MM01", "MM09" }, { "M1", "M9" }, { "MM91", "MM90" } )
  otherwise
     aRETU := PERFEC( { "MM01", "MM06" }, { "M1", "M6" }, { "MM91", "MM96" } )
ENDCASE
nMES         := aRETU[ 1 ]
nANO         := aRETU[ 2 ]
ARQWORK1 := aRETU[ 5, 1 ]
ARQWORK2 := aRETU[ 5, 2 ]
mCOMPETENCIA := aRETU[ 7 ]


cTIPOCAN :="T"
cAPUNEW:="S"
@ 22,00 SAY "Digite o M€s e o ano"
@ 23,00 SAY "Grupo (T)odos (C)anceladas (N)Жo Canceladas"
@ 24,00 SAY "Apurar CFO Novo"
@ 22,40 get nMES  PICT "99"
@ 22,45 get nANO  PICT "9999"
@ 23,50 get cTIPOCAN PICT "!" VALID cTIPOCAN $ "TCN"
@ 24,40 get cAPUNEW  PICT "!" VALID cAPUNEW $ "SN"
IF ! READCUR()
   RETU .F.
ENDIF

priv   wNOME,wINSCR,wCGC,wJUCESPC,wJUCESPD
priv   wIMUNICI,wENDERECO,wCIDADE,wESTADO,wCEP,wBAIRRO
pegempmbdi()


FILTRO := ''
DO CASE
  CASE cTIPOLIV="E"
   FILTRO := RFILORD( "MK06", .F. )
  CASE cTIPOLIV="SE"
   FILTRO := RFILORD( "MK09", .F. )
  CASE cTIPOLIV="SS"
   FILTRO := RFILORD( "MM09", .F. )
 otherwise
   FILTRO := RFILORD( "MM06", .F. )
ENDCASE

//Variaveis do Sistema
SEQ  := 0
ZFOL := ZLIM := ZLIV := 0
ZULT := ZDATA

DO CASE
   CASE cTIPOLIV="E"
        PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGE", "FILIME", "FILIVE", "FILANE" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   CASE cTIPOLIV="SE"
        PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGISE", "FILIMISE", "FILIVISE", "FILANISE" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   CASE cTIPOLIV="SS"
        PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGISS", "FILIMISS", "FILIVISS", "FILANISS" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   otherwise
        PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGS", "FILIMS", "FILIVS", "FILANS" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
ENDCASE

lPRIMEIRO := .T.
nLISTA    := 8
CTLIN     := 80
aTOTGER   := array( 11 )
aTOTFOL   := array( 11 )
aTOTCOD   := array( 11 )
afill( aTOTGER, 0 )
afill( aTOTFOL, 0 )
afill( aTOTCOD, 0 )
aUF  := {}
aVAL := {}

if MDG( "Iniciar Dados" )
   mVAL01 := mVAL02 := mVAL03 := mVAL04 := mVAL05 := mVAL06 := 0
   mVAL07 := mVAL08 := mVAL09 := mVAL10 := mVAL11 := 0
   TELASAY( "MBDIE1" )
   EDITSAY( "MBDIE1" )
   aTOTGER   := { mVAL01, mVAL02, mVAL03, mVAL04, mVAL05, mVAL06, mVAL07, mVAL08, mVAL09, mVAL10, mVAL11 }
   aTOTFOL   := { mVAL01, mVAL02, mVAL03, mVAL04, mVAL05, mVAL06, mVAL07, mVAL08, mVAL09, mVAL10, mVAL11 }
   lPRIMEIRO := .F.
   CTLIN     := 13
endif

if ! USEMULT( { { ARQWORK1, 1, 1 }, { ARQWORK2, 1, 0 }, { "MA01", 1, 1 }, { "MB01", 1, 1 } } )
   retu .F.
endif

MDS( "Imprimindo..." )

IMPRESSORA()

IF cTIPOLIV="SS".OR.cTIPOLIV="SE"
    impchr(cIMPEXP)
ENDIF    


dbselectar( ARQWORK2 )
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
IF cTIPOLIV="SS".OR.cTIPOLIV="SE"
   ordDestroy("temp")
   ordcreate(,"temp","STR(LOTE,5)")
   ordSetFocus("temp")
ELSE
  IF cAPUNEW="N"
     ordDestroy("temp")
     ordcreate(,"temp","STR(LOTE,5)+DOPER+STR(DIPI,4,1)+CHKIPI+STR(DICM,5,2)")
     ordSetFocus("temp")
  ELSE
    ordDestroy("temp")
    ordcreate(,"temp","STR(LOTE,5)+DCFONEW+STR(DIPI,4,1)+CHKIPI+STR(DICM,5,2)")
    ordSetFocus("temp")     
  ENDIF
ENDIF

if !empty( FILTRO )
   set filter to &FILTRO.
endif
dbgotop()
while !eof()
   xORDEM     := ORDEM
   xLOTE      := LOTE
   xDATA      := DATA
   xDATAREF   := DATAREF
   xNUMERO    := NUMERO
   xFORNECEDO := FORNECEDO
   xDOPER     := IF(cAPUNEW="N",DOPER,DCFONEW)
   xSUBDOPER  := SUBDOPER
   xDIPAM     := DIPAM
   mESPECIE   := ""
   mSERIE     := ""
   mTIPOFOR   := ""
   mFORNECEDO := 0
   xOBS       := ""
   mCHAVE     := xNUMERO
   IF cTIPOLIV="E".OR.cTIPOLIV="SE"
      mCHAVE:=STR(xNUMERO,8)+STR(xFORNECEDO,5)
   ENDIF
   IF cTIPOLIV="SS".OR.cTIPOLIV="SE"
      mESPECIE   := ESPECIE
      mSERIE     := SERIE
      mTIPOFOR   := TIPOFOR
      mFORNECEDO := FORNECEDO
   ELSE
      dbselectar( ARQWORK1 )
      dbgotop()
      if dbseek( mCHAVE )
         mESPECIE   := ESPECIE
         mSERIE     := SERIE
         mTIPOFOR   := TIPOCLI
         mFORNECEDO := FORNECEDO
     endif
   ENDIF
   mNOMEFOR := ""
   mCGCFORN := ""
   mINSCFOR := ""
   mUFFORN  := ""
   mCCM     :=""
   mPESSOA  := ""
   dbselectar( if( mTIPOFOR = "C", "MA01", "MB01" ) )
   dbgotop()
   if dbseek( mFORNECEDO )
      mNOMEFOR := NOME
      mCGCFORN := CGC
      mINSCFOR := if( mTIPOFOR = "C", INSCR, IESTADUAL )
      mUFFORN  := ESTADO
      mCCM     := IMUNICIPI
      mPESSOA  := PESSOA
   endif
   dbselectar( ARQWORK2 )
   while xLOTE = LOTE .and. !eof()
      xDOPER    := IF(cAPUNEW="N",DOPER,DCFONEW)
      xSUBDOPER := SUBDOPER
      xDIPI     := DIPI
      xDICM     := DICM
      xOBS      := OBS
      xCHKIPI   := CHKIPI
      xCODREC   := ""
      IF cTIPOLIV="SE".OR.cTIPOLIV="SS"
         xCODREC:=CODREC
      ENDIF
      while xLOTE = LOTE .and. xDOPER = IF(cAPUNEW="N",DOPER,DCFONEW) .and. xDIPI = DIPI .and. xCHKIPI = CHKIPI.and. xDICM = DICM .and. !eof()
         IF SOMACANCEL()
            aTOTCOD[ 1 ] += DVALORNF
            aTOTCOD[ 2 ] += DBASEICM
            aTOTCOD[ 3 ] += DVALICM
            aTOTCOD[ 4 ] += ISENTAICM
            aTOTCOD[ 5 ] += OUTRAICM
            aTOTCOD[ 6 ] += OBSICM
            aTOTCOD[ 7 ] += DBASEIPI
            aTOTCOD[ 8 ] += DVALIPI
            aTOTCOD[ 9 ] += ISENTAIPI
            aTOTCOD[ 10 ] += OUTRAIPI
            aTOTCOD[ 11 ] += OBSIPI
         ENDIF
         dbskip()
      enddo
      nREFLIS:=6
      IF cTIPOLIV="SS".OR.cTIPOLIV="SE"
         nREFLIS:=6
      ENDIF
      IF cTIPOLIV="S"
         nREFLIS:=6
      ENDIF
      if nLISTA > nREFLIS
         if ! lPRIMEIRO
            @ CTLIN,  0 say "Sub-total a transportar"
            CTLIN ++
            @ CTLIN,0 SAY mBDIL03()
            CTLIN ++
            mBDIL01({aTOTFOL[1],aTOTFOL[2],aTOTFOL[3],aTOTFOL[4],aTOTFOL[5],aTOTFOL[6]})
            IF cTIPOLIV=="E".OR.cTIPOLIV=="S"
               mBDIL01({0,aTOTFOL[7],aTOTFOL[8],aTOTFOL[9],aTOTFOL[10],aTOTFOL[11]},.T.)
            ENDIF
         endif
         mBDIL02()
        if cTIPOLIV="SE"
           @  1,  0  say "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S " 
           @  2,  0  say "REF.:"+mCOMPETENCIA+" DATA:"+ DTOC(ZDATA)+ " HORA:"+left(time(),5) +" F.:"+str(ZFOL,4)
        ELSE
            @  1,  0  say "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S  REF.:"+mCOMPETENCIA+" DATA:"+ DTOC(ZDATA)+ " HORA:"+left(time(),5) +" F.:"+str(ZFOL,4)
            @  2,  0  say repl( "-", 132 )
         ENDIF     
         DO CASE
            CASE cTIPOLIV="E"
               @  3,  0  say "L I V R O   D E   R E G I S T R O   D E   E N T R A D A S - RE - MODELO P1"
            CASE cTIPOLIV="SE"
               @  3,  0  say "REGISTRO DE SERVICOS TOMADOS OU INTERMEDIADOS DE TERCEIROS - MODELO 56"
            CASE cTIPOLIV="SS"
               @  3,  0  say "REGISTRO DE SERVICOS - MODELO 57"
            otherwise
               @  3,  0  say "L I V R O   D E   R E G I S T R O   D E   S A I D A S     - RE - MODELO P2"
         ENDCASE
         @  4,  0  say "FIRMA:" + trim(wNOME) 
         //@  4,  7  say wNOME
         if cTIPOLIV="SE"
            @  4, 43  say "MES OU PERIODO/ANO:"+ mCOMPETENCIA
         else
            @  4, 71 say "MES OU PERIODO/ANO:"+ mCOMPETENCIA
         endif   
         CTLIN:=5
         IF cTIPOLIV="SE"
            @ CTLIN,0 say "INSC.EST.:" + wINSCR + " CNPJ:" + wCGC 
            CTLIN++
            @ CTLIN,0 SAY "JUCESP:" + TRIM(wJUCESPC) + " em" + dtoc(wJUCESPD) + " INSC. Municipal:" + wIMUNICI 
         ELSE         
            @  CTLIN,  0  say "INSC.EST.:" + wINSCR + " CNPJ:" + wCGC + " Jucesp:" + TRIM(wJUCESPC) + " em" + dtoc(wJUCESPD) + " INSC. Municipal:" + wIMUNICI
         ENDIF    
         //@  5, 11  say wINSCR
         //@  5, 32  say wCGC
         //@  5, 59  say wJUCESPC
         //@  5, 78  say wJUCESPD
         //@  5, 105 say wIMUNICI
         CTLIN++
         @  CTLIN,  0  say "ENDEREЂO:" + ALLTRIM(wENDERECO) + " Cidade:" + ALLTRIM(wCIDADE) + " Estado:"+ wESTADO +" CEP:"+wCEP
         //@  CTLIN, 10  say wENDERECO
         //@  CTLIN, 59  say wCIDADE
         //@  CTLIN, 103 say wESTADO
         //@  CTLIN, 111 say wCEP
         CTLIN++
         IF cTIPOLIV=="E".OR.cTIPOLIV=="S"
             @  CTLIN,  0  say repl( "-", 132 )
         ELSE
             @  CTLIN,  0  say repl( "-", 80 )
         ENDIF    
         CTLIN++
         if lPRIMEIRO
            lPRIMEIRO := .F.
            CTLIN++
            //CTLIN     :=8
         else
            @  CTLIN,  0  say "Sub-total de transporte"
            CTLIN++
            @  CTLIN,0 SAY mBDIL03()
            CTLIN++
            //CTLIN:= 10
            mBDIL01({aTOTFOL[1],aTOTFOL[2],aTOTFOL[3],aTOTFOL[4],aTOTFOL[5],aTOTFOL[6]})
            CTLIN++
            //CTLIN:= 11
            IF cTIPOLIV=="E".OR.cTIPOLIV=="S"
               mBDIL01({0,aTOTFOL[7],aTOTFOL[8],aTOTFOL[9],aTOTFOL[10],aTOTFOL[11]},.T.)
               CTLIN++
               //CTLIN := 13
            ELSE
               @ CTLIN,0 say repl( "-", 80 ) //132 Traco SS E SE
               CTLIN++
               //CTLIN:=12
            ENDIF
         endif
         ZFOL ++
         nLISTA := 1
      endif
      nPOS := ascan( aUF, mUFFORN )
      if nPOS > 0
         aVAL[ nPOS, 1 ] += aTOTCOD[ 1 ]
         aVAL[ nPOS, 2 ] += aTOTCOD[ 2 ]
      else
         aadd( aUF, mUFFORN )
         aadd( aVAL, { aTOTCOD[ 1 ], aTOTCOD[ 2 ] } )
      endif
      IF cTIPOLIV="SE"
         @ CTLIN,  0  say "SEQUENCIA-"+strzero( xLOTE, 5 )+" DATA ENTRADA-"+DTOC(xDATAREF)+" DATA DOCUMENTO-"+DTOC(xDATA)
         CTLIN ++
         @ CTLIN,  0  say "ESPECIE-"+mESPECIE+" SERIE-"+mSERIE+" NUMERO DOC.-"+str(xNUMERO,8)+" UF-"+mUFFORN
         CTLIN ++
      ELSE
         @ CTLIN,  0  say "SEQUENCIA-"+strzero( xLOTE, 5 )+" DATA ENTRADA-"+DTOC(xDATAREF);
            +" DATA DOCUMENTO-"+DTOC(xDATA)+" ESPECIE-"+mESPECIE+" SERIE-"+mSERIE+" NUMERO DOC.-";
            +str(xNUMERO,8)+IF(cTIPOLIV="E".OR.cTIPOLIV="SE",""," UF-"+mUFFORN)
         CTLIN ++
      ENDIF    
      IF cTIPOLIV="E"
         @ CTLIN,  0  say "EMITENTE-"+mNOMEFOR+IF(mPESSOA="F"," CPF-"," CNPJ-")+mCGCFORN+ ;
                      " INSCR.EST.-" + mINSCFOR + IF(cTIPOLIV="SE"," CCM-"+mCCM,"")+ " UF-"+mUFFORN
         CTLIN ++
      ENDIF
      IF cTIPOLIV="SE"
         @ CTLIN,  0  say "EMITENTE-"+mNOMEFOR+IF(mPESSOA="F"," CPF-"," CNPJ-")+mCGCFORN
         CTLIN ++
         @ CTLIN,  0  say "INSCR.EST.-" + mINSCFOR + IF(cTIPOLIV="SE"," CCM-"+mCCM,"")+ " UF-"+mUFFORN
         CTLIN ++
      ENDIF

      IF cTIPOLIV="SS".OR.cTIPOLIV="SE"
      ELSE
         @ CTLIN,  0 say "CODIGO FISCAL-                        CODIGO CONTABIL-" + spac( 17 ) + "OBS-"
         IF cAPUNEW="N"
            @ CTLIN, 15 say xDOPER
            @ CTLIN, 19 say xSUBDOPER
         ELSE
            @ CTLIN, 15 say xDOPER  PICT "@R 9.999"
         ENDIF
         @ CTLIN, 34 say xDIPAM
         @ CTLIN, 76 say XOBS
         CTLIN ++
      ENDIF   
      @ CTLIN,0 SAY mBDIL03()
      CTLIN ++
      mXICM := if( aTOTCOD[ 3 ] > 0, "T", "" )
      mXIPI := if( aTOTCOD[ 8 ] > 0, "T", "" )
      mXICM += if( aTOTCOD[ 4 ] > 0, "I", "" )
      mXIPI += if( aTOTCOD[ 9 ] > 0, "I", "" )
      mXICM += if( aTOTCOD[ 5 ] > 0, "O", "" )
      mXIPI += if( aTOTCOD[ 10 ] > 0, "O", "" )
      mXICM += if( aTOTCOD[ 6 ] > 0, "B", "" )
      mXIPI += if( aTOTCOD[ 11 ] > 0, "B", "" )
      IF cTIPOLIV=="E".OR.cTIPOLIV=="S"
         mBDIL01({aTOTCOD[1],aTOTCOD[2],aTOTCOD[3],aTOTCOD[4],aTOTCOD[5],aTOTCOD[6]},.F.,{"COD.ICMS-",mXICM,xDICM})
         mBDIL01({0         ,aTOTCOD[7],aTOTCOD[8],aTOTCOD[9],aTOTCOD[10],aTOTCOD[11]},.T.,{"COD.IPI -",mXIPI,xDIPI})
      ELSE
         mBDIL01({aTOTCOD[1],aTOTCOD[2],aTOTCOD[3],aTOTCOD[4],aTOTCOD[5],aTOTCOD[6]},.T.,{"COD.REC -",XCODREC,""})
      ENDIF
      nLISTA ++
      for X := 1 to 11
         aTOTGER[ X ] += aTOTCOD[ X ]
         aTOTFOL[ X ] += aTOTCOD[ X ]
      next X
      afill( aTOTCOD, 0 )
   enddo
   dbselectar( ARQWORK2 )
enddo
//Total Geral
@ CTLIN,  0 say "Total"
CTLIN ++
@ CTLIN,0 SAY mBDIL03()
CTLIN ++

mBDIL01({aTOTGER[1],aTOTGER[2],aTOTGER[3],aTOTGER[4],aTOTGER[5],aTOTGER[6]})
IF cTIPOLIV=="E".OR.cTIPOLIV=="S"
   mBDIL01({0,aTOTGER[7],aTOTGER[8],aTOTGER[9],aTOTGER[10],aTOTGER[11]},.T.)
ENDIF
dbcloseall()
mBDIL02()
VIDEO()
IF cTIPOLIV=="E".OR.cTIPOLIV=="S"
   MBDII( .F. )
ENDIF
IMPEND()


FUNC mBDIL01(aDIZ,lTRACO,aSUB)
lSUB:=.F.
IF VALTYPE(lTRACO)#"L"
   lTRACO:=.F.
ENDIF
IF VALTYPE(aSUB)="A"
   lSUB:=.T.
ENDIF
IF aDIZ[1]>0
   @ CTLIN,  3  say aDIZ[ 1 ] pict "@E 9999,999,999.99"
ENDIF
IF lSUB
   @ CTLIN, 20  say aSUB[1]
   @ CTLIN, 30  say aSUB[2]
ENDIF
@ CTLIN, 37  say aDIZ[ 2 ]  pict "@E 9999,999,999.99"
IF lSUB
   @ CTLIN, 55  say aSUB[3]
ENDIF
IF cTIPOLIV="SS".OR.cTIPOLIV="SE"
   @ CTLIN, 63  say aDIZ[ 3 ]  pict "@E 999,999.99"
ELSE
   @ CTLIN, 63  say aDIZ[ 3 ]  pict "@E 9999,999,999.99"
ENDIF 
IF cTIPOLIV="SS".OR.cTIPOLIV="SE"
ELSE
   @ CTLIN, 81  say aDIZ[ 4 ]  pict "@E 9999,999,999.99"
   @ CTLIN, 99  say aDIZ[ 5 ] pict "@E 9999,999,999.99"
   @ CTLIN, 117 say aDIZ[ 6 ] pict "@E 9999,999,999.99"
ENDIF   
CTLIN ++
IF lTRACO
   IF cTIPOLIV="SS".OR.cTIPOLIV="SE"
      @ CTLIN,  0 say repl( "-", 80 )
   ELSE
      @ CTLIN,  0 say repl( "-", 132 )
   ENDIF    
   CTLIN++
ENDIF
RETU

FUNC mBDIL02()
if ZFOL = ZLIM
   DO CASE
      CASE cTIPOLIV="E"
           M_BDIN( 4 ,,xDATAREF)
           ZLIV ++
           ZFOL := 1
           M_BDIN( 3 ,,xDATAREF)
           ZFOL := 2
      CASE cTIPOLIV="SE"
           M_BDIN( 10,, xDATAREF)
           ZLIV ++
           ZFOL := 1
           M_BDIN( 9 ,,xDATAREF)
           ZFOL := 2
      CASE cTIPOLIV="SS"
           M_BDIN( 11,,xDATAREF )
           ZLIV ++
           ZFOL := 1
           M_BDIN( 12,,xDATAREF )
           ZFOL := 2
      otherwise
           M_BDIN( 2 ,,xDATAREF)
           ZLIV ++
           ZFOL := 1
           M_BDIN( 1 ,,xDATAREF)
           ZFOL := 2
  ENDCASE
ENDIF
RETU

FUNC mBDIL03()
LOCAL cTEXTO
IF cTIPOLIV=="E".OR.cTIPOLIV=="S"
   cTEXTO:="VALOR CONT./SUBST." + spac( 19 ) + "BASE DE CALCULO            VALOR ICMS/IPI      VALOR ISENTO      VALOR OUTROS   OBSERVACAO"
ELSE
   cTEXTO:="VALOR CONT./SUBST." + spac( 19 ) + "BASE DE CALCULO            VALOR ISS"
ENDIF
RETU cTEXTO
*+ EOF: M_BDIL.PRG
