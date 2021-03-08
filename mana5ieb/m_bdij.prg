*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BDIJ.PRG
*+
*+    Functions: Function MBDIJ01()
*+               Function MBDIJ02()
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"

function m_bdij
PARA cIMPOSTO,cTIPOLIV



DO CASE
 CASE cIMPOSTO="ICM"
   MDI(" Э Resumo ICMS CFO por Aliquota" )
 CASE cIMPOSTO="ISSCOD"
   MDI(" Э Resumo ISS Codigo por Aliquota" )
 CASE cIMPOSTO="ISS"
   MDI(" Э Resumo ISS CFO por Aliquota" )
otherwise
   MDI(" Э Resumo IPI CFO por Aliquota" )
ENDCASE

l200  := l300 := l500 := l600 := .T.
aCFO  := {}
aVAL  := {}
ZFOL  := 1
CTLIN := 80
cTIPOCAN :="T"
cAPUNEW:="S"



xDATAREF:=ZDATA
priv   wNOME,wINSCR,wCGC,wJUCESPC,wJUCESPD
priv   wIMUNICI,wENDERECO,wCIDADE,wESTADO,wCEP,wBAIRRO
pegempmbdi()


IF cIMPOSTO="ISS"
   aRETU := PERFEC( { "MK09", "MM09" }, { "K9", "M9" }, { "MK90", "MM90" } )
ELSE
   aRETU := PERFEC( { "MK06", "MM06" }, { "K6", "M6" }, { "MK96", "MM96" } )
ENDIF
nMES         := aRETU[ 1 ]
nANO         := aRETU[ 2 ]


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

@ 22,00 SAY "Confirme o numero da Folha"
@ 23,00 SAY "Grupo (T)odos (C)anceladas (N)Жo Canceladas"
@ 24,00 SAY "Apurar CFO Novo"
@ 22,40 get ZFOL
@ 23,45 get cTIPOCAN PICT "!" VALID cTIPOCAN $ "TCN"
@ 24,40 get cAPUNEW  PICT "!" VALID cAPUNEW $ "SN"
if !READCUR()
   retu .F.
endif



if !USEREDE( "FI_TEMP1", 0, 99 )
   retu .F.
endif
zap
DO CASE
   CASE cAPUNEW="N".AND.(cIMPOSTO="ICM".OR.cIMPOSTO="ISS".OR.cIMPOSTO="ISSCOD")
        DBSETORDER(1)
   CASE cAPUNEW="S".AND.(cIMPOSTO="ICM".OR.cIMPOSTO="ISS".OR.cIMPOSTO="ISSCOD")
        DBSETORDER(2)
   CASE cAPUNEW="N".AND.cIMPOSTO="IPI"
        DBSETORDER(3)
   CASE cAPUNEW="S".AND.cIMPOSTO="IPI"
        DBSETORDER(4)
ENDCASE
MBDIJ02( aRETU[ 5, 1 ], "Entrada" )
MBDIJ02( aRETU[ 5, 2 ], "Saida" )


if !CHECKIMP( 0 )
   retu .F.
endif
aGER := array( 11 )
afill( aGER, 0 )
aGRU := array( 11 )
afill( aGRU, 0 )
IMPRESSORA()
dbselectar( "FI_TEMP1" )
dbgotop()
while !eof()
   if CTLIN > 50
      ZFOL ++
      mBDIL02()
      @  1,  0  say "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
      @  1, 83  say left( MMES( aRETU[ 1 ] ), 3 ) + "/" + str( aRETU[ 2 ], 4 )
      @  1, 97  say ZDATA
      @  1, 113 say left( time(), 5 )
      @  1, 128 say str( ZFOL, 4 )
      @  2,  0  say repl( "-", 132 )
      @  3,  0  say "L I V R O   D E   R E G I S T R O                        - RE - MODELO P1"
      @  4,  0  say "FIRMA:" + spac( 45 ) + "MES OU PERIODO/ANO:"
      @  4,  7  say wNOME
      @  4, 71  say aRETU[ 7 ]
      @  5,  0  say "INSC.EST.:" + spac( 16 ) + "CNPJ:" + spac( 20 ) + "Jucesp:" + spac( 17 ) + "em" + spac( 11 ) + "INSC. Municipal:"
      @  5, 11  say wINSCR
      @  5, 32  say wCGC
      @  5, 59  say wJUCESPC
      @  5, 78  say wJUCESPD
      @  5, 105 say wIMUNICI
      @  6,  0  say "ENDEREЂO:" + spac( 42 ) + "Cidade:" + spac( 37 ) + "Estado:    CEP:"
      @  6, 10  say wENDERECO
      @  6, 59  say wCIDADE
      @  6, 103 say wESTADO
      @  6, 111 say wCEP
      @  7,  0  say repl( "-", 132 )
      @  8,  0  say "CFO ALIQ. VALOR CONT./SUBST." + spac( 15 ) + "BASE DE CALCULO      VALOR ICMS/IPI      VALOR ISENTO      VALOR OUTROS   OBSERVACAO"
      @  9,  0  say repl( "-", 132 )
      CTLIN := 10
   endif
   cCFO:=IF(cAPUNEW="N",CFO,CFONEW)
   if l200 .and. val( cCFO ) >= 200.AND.cIMPOSTO<>"ISSCOD"
      if aGRU[ 9 ] > 0
         MBDIJ01( 'Sub-Total', aGRU )
      endif
      l200 := .F.
      afill( aGRU, 0 )
   endif
   if l300 .and. val( cCFO ) >= 300.AND.cIMPOSTO<>"ISSCOD"
      if aGRU[ 9 ] > 0
         MBDIJ01( 'Sub-Total', aGRU )
      endif
      l300 := .F.
      afill( aGRU, 0 )
   endif
   if l500 .and. val( cCFO ) >= 500.AND.cIMPOSTO<>"ISSCOD"
      if aGRU[ 9 ] > 0
         MBDIJ01( 'Sub-Total', aGRU )
      endif
      l500 := .F.
      afill( aGRU, 0 )
   endif
   if l600 .and. val( cCFO ) >= 600.AND.cIMPOSTO<>"ISSCOD"
      if aGRU[ 9 ] > 0
         MBDIJ01( 'Sub-Total', aGRU )
      endif
      l600 := .F.
      afill( aGRU, 0 )
   endif
   IF cAPUNEW="N".OR.cIMPOSTO<>"ISSCOD"
      @ CTLIN,  0 say cCFO
   ELSE
      @ CTLIN,  0 say cCFO PICT "@R 9.999"
   ENDIF
   aDAD := { ICMBAS, ICMVAL, ICMISE, ICMOUT, IPIBAS, IPIVAL, IPIISE, IPIOUT, CONTABIL, OBSICM, OBSIPI }
   DO CASE
     CASE cIMPOSTO="IPI"
        IF cAPUNEW="N"
           MBDIJ01( SUBCFO + " " + str( IPI, 5, 2 ), aDAD, "#", { "ICMS", "IPI" } )
        ELSE
           MBDIJ01( str( IPI, 5, 2 ), aDAD, "#", { "ICMS", "IPI" } )
        ENDIF
    CASE cIMPOSTO="ISS".AND. cAPUNEW="N"
          MBDIJ01( SUBCFO + " " + str( ICM, 5, 2 ), aDAD, "#", { "ISS", "" } )
    CASE cIMPOSTO="ISS".OR.cIMPOSTO="ISSCOD"
          MBDIJ01( str( ICM, 5, 2 ), aDAD, "#", { "ISS", "" } )
    otherwise
      IF cAPUNEW="N"
          MBDIJ01( SUBCFO + " " + str( ICM, 5, 2 ), aDAD, "#", { "ICMS", "IPI" } )
       ELSE
          MBDIJ01( str( ICM, 5, 2 ), aDAD, "#", { "ICMS", "IPI" } )
       ENDIF
   ENDCASE
   for X := 1 to 11
      aGRU[ X ] += aDAD[ X ]
      aGER[ X ] += aDAD[ X ]
   next X
   dbskip()
enddo
if aGRU[ 9 ] > 0
   MBDIJ01( 'Sub-Total', aGRU )
endif
MBDIJ01( "Total", aGER )
dbcloseall()
IMPFOL()
VIDEO()
IMPEND()

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MBDIJ01()
*+
*+    Called from ( m_bdij.prg   )   7 - function mbdii()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MBDIJ01( cTITULO, aDAD, cDIV, aTIT )

if valtype( cDIV ) # "C"
   cDIV := "-"
endif
if cDIV # "#"
   @ CTLIN,  0 say repl( cDIV, 132 )
   CTLIN ++
else
   cDIV := "-"
endif
@ CTLIN,  5 say cTITULO
@ CTLIN, 22 say aDAD[ 9 ] pict "@E 9999,999,999.99"
if valtype( aTIT ) = "A"
   @ CTLIN, 38 say aTIT[ 1 ]
endif
@ CTLIN, 43  say aDAD[ 1 ]  pict "@E 9999,999,999.99"
@ CTLIN, 63  say aDAD[ 2 ]  pict "@E 9999,999,999.99"
@ CTLIN, 81  say aDAD[ 3 ]  pict "@E 9999,999,999.99"
@ CTLIN, 99  say aDAD[ 4 ]  pict "@E 9999,999,999.99"
@ CTLIN, 117 say aDAD[ 10 ] pict "@E 9999,999,999.99"
CTLIN ++
IF cIMPOSTO="ISS".OR.cIMPOSTO="ISSCOD"
ELSE
  if valtype( aTIT ) = "A"
     @ CTLIN, 38 say aTIT[ 2 ]
  endif
  @ CTLIN, 43  say aDAD[ 5 ]  pict "@E 9999,999,999.99"
  @ CTLIN, 63  say aDAD[ 6 ]  pict "@E 9999,999,999.99"
  @ CTLIN, 81  say aDAD[ 7 ]  pict "@E 9999,999,999.99"
  @ CTLIN, 99  say aDAD[ 8 ]  pict "@E 9999,999,999.99"
  @ CTLIN, 117 say aDAD[ 11 ] pict "@E 9999,999,999.99"
  CTLIN ++
ENDIF
@ CTLIN,  0 say repl( cDIV, 132 )
CTLIN ++
retu

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MBDIJ02()
*+
*+    Called from ( m_bdij.prg   )   2 - function mbdii()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MBDIJ02( cARQ, cTITULO )

if ! MDG( "Apurar " + cTITULO )
   RETU
ENDIF
MDS( "Aguarde Apurando " + cTITULO )
FILTRO := ''
FILTRO := RFILORD( cARQ, .F. )
if !USEREDE( cARQ, 1, 0 )
   dbcloseall()
   retu .F.
endif
if !empty( FILTRO )
   set filter to &FILTRO
endif
dbgotop()
while !eof()
   @ 24, 40 say NUMERO
   IF SOMACANCEL()
      mCFO      := DOPER
      mCFONEW   := DCFONEW
      mSUBCFO   := SUBDOPER
      mICM      := DICM
      mIPI      := DIPI
      mCONTABIL := DVALORNF
      mIPIBAS   := DBASEIPI
      mIPIVAL   := DVALIPI
      mIPIISE   := ISENTAIPI
      mIPIOUT   := OUTRAIPI
      mOBSIPI   := OBSIPI
      mICMBAS   := DBASEICM
      mICMVAL   := DVALICM
      mICMISE   := ISENTAICM
      mICMOUT   := OUTRAICM
      mOBSICM   := OBSICM
      xDATAREF  := DATAREF
      IF cIMPOSTO="ISS".OR.cIMPOSTO="ISSCOD"
         mCODREC:=CODREC
      ENDIF
      IF cIMPOSTO="ISSCOD"
         mCFO:=mCODREC
         mCFONEW:=mCODREC
         mSUBCFO:=""
      ENDIF
      DO CASE
         CASE cIMPOSTO="IPI"
             IF cAPUNEW="N"
               mCHAVE:= mCFO + mSUBCFO + str( mIPI,5, 2 )
             ELSE
               mCHAVE:= mCFONEW + str( mIPI,5, 2 )
             ENDIF
         CASE cIMPOSTO="ISSCOD"
               mCHAVE:= mCODREC + str( mICM,5, 2 )
         otherwise
             IF cAPUNEW="N"
               mCHAVE:= mCFO + mSUBCFO + str( mICM,5, 2 )
             ELSE
               mCHAVE:= mCFONEW + str( mICM,5, 2 )
            ENDIF
      ENDCASE
      dbselectar( "FI_TEMP1" )
      dbgotop()
      if !dbseek( mCHAVE)
         netrecapp()
         field->CFO    := mCFO
         field->CFONEW := mCFONEW
         field->SUBCFO := mSUBCFO
         field->ICM    := mICM
         field->IPI    := mIPI
      endif
      field->CONTABIL := CONTABIL + mCONTABIL
      field->ICMBAS   := ICMBAS + mICMBAS
      field->ICMISE   := ICMISE + mICMISE
      field->ICMOUT   := ICMOUT + mICMOUT
      field->ICMVAL   := ICMVAL + mICMVAL
      field->OBSICM   := OBSICM + mOBSICM
      field->IPIBAS   := IPIBAS + mIPIBAS
      field->IPIISE   := IPIISE + mIPIISE
      field->IPIOUT   := IPIOUT + mIPIOUT
      field->IPIVAL   := IPIVAL + mIPIVAL
      field->OBSIPI   := OBSIPI + mOBSIPI
   ENDIF
   Dbselectar( cARQ )
   dbskip()
enddo
dbselectar( cARQ )
dbclosearea()
retu .T.

*+ EOF: M_BDIJ.PRG
