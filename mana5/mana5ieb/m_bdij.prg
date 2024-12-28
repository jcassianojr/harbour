// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : m_bdij.prg
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
// +    Documentado em 28-Dez-2024 as 10:47 am
// +
// +
// +
// +--------------------------------------------------------------------
// +

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Source Module => J:\ITAESBRA\M_BDIJ.PRG
// +
// +    Functions: Function MBDIJ01()
// +               Function MBDIJ02()
// +
// +    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

// #INCLUDE "COMANDO.CH"


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function m_bdij()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION m_bdij

   PARA cIMPOSTO, cTIPOLIV

   DO CASE
   CASE cIMPOSTO = "ICM"
      MDI( " Э Resumo ICMS CFO por Aliquota" )
   CASE cIMPOSTO = "ISSCOD"
      MDI( " Э Resumo ISS Codigo por Aliquota" )
   CASE cIMPOSTO = "ISS"
      MDI( " Э Resumo ISS CFO por Aliquota" )
   OTHERWISE
      MDI( " Э Resumo IPI CFO por Aliquota" )
   ENDCASE

   l200     := l300 := l500 := l600 := .T.
   aCFO     := {}
   aVAL     := {}
   ZFOL     := 1
   CTLIN    := 80
   cTIPOCAN := "T"
   cAPUNEW  := "S"



   xDATAREF := ZDATA
   PRIV wNOME, wINSCR, wCGC, wJUCESPC, wJUCESPD
   PRIV wIMUNICI, wENDERECO, wCIDADE, wESTADO, wCEP, wBAIRRO
   pegempmbdi()


   IF cIMPOSTO = "ISS"
      aRETU := PERFEC( { "MK09", "MM09" }, { "K9", "M9" }, { "MK90", "MM90" } )
   ELSE
      aRETU := PERFEC( { "MK06", "MM06" }, { "K6", "M6" }, { "MK96", "MM96" } )
   ENDIF
   nMES := aRETU[ 1 ]
   nANO := aRETU[ 2 ]


   ZFOL := ZLIM := ZLIV := 0
   ZULT := ZDATA
   DO CASE
   CASE cTIPOLIV = "E"
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGE", "FILIME", "FILIVE", "FILANE" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   CASE cTIPOLIV = "SE"
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGISE", "FILIMISE", "FILIVISE", "FILANISE" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   CASE cTIPOLIV = "SS"
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGISS", "FILIMISS", "FILIVISS", "FILANISS" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   OTHERWISE
      PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAGS", "FILIMS", "FILIVS", "FILANS" }, { "ZFOL", "ZLIM", "ZLIV", "ZULT" } )
   ENDCASE

   @ 22, 00 SAY "Confirme o numero da Folha"
   @ 23, 00 SAY "Grupo (T)odos (C)anceladas (N)Жo Canceladas"
   @ 24, 00 SAY "Apurar CFO Novo"
   @ 22, 40 GET ZFOL
   @ 23, 45 GET cTIPOCAN                                      PICT "!" VALID cTIPOCAN $ "TCN"
   @ 24, 40 GET cAPUNEW                                       PICT "!" VALID cAPUNEW $ "SN"
   IF !READCUR()
      RETU .F.
   ENDIF



   IF !USEREDE( "FI_TEMP1", 0, 99 )
      RETU .F.
   ENDIF
   ZAP
   DO CASE
   CASE cAPUNEW = "N" .AND. ( cIMPOSTO = "ICM" .OR. cIMPOSTO = "ISS" .OR. cIMPOSTO = "ISSCOD" )
      dbSetOrder( 1 )
   CASE cAPUNEW = "S" .AND. ( cIMPOSTO = "ICM" .OR. cIMPOSTO = "ISS" .OR. cIMPOSTO = "ISSCOD" )
      dbSetOrder( 2 )
   CASE cAPUNEW = "N" .AND. cIMPOSTO = "IPI"
      dbSetOrder( 3 )
   CASE cAPUNEW = "S" .AND. cIMPOSTO = "IPI"
      dbSetOrder( 4 )
   ENDCASE
   MBDIJ02( aRETU[ 5, 1 ], "Entrada" )
   MBDIJ02( aRETU[ 5, 2 ], "Saida" )


   IF !CHECKIMP( 0 )
      RETU .F.
   ENDIF
   aGER := Array( 11 )
   AFill( aGER, 0 )
   aGRU := Array( 11 )
   AFill( aGRU, 0 )
   IMPRESSORA()
   dbSelectAr( "FI_TEMP1" )
   dbGoTop()
   WHILE !Eof()
      IF CTLIN > 50
         ZFOL++
         mBDIL02()
         @  1, 0   SAY "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
         @  1, 83  SAY Left( MMES( aRETU[ 1 ] ), 3 ) + "/" + Str( aRETU[ 2 ], 4 )
         @  1, 97  SAY ZDATA
         @  1, 113 SAY Left( Time(), 5 )
         @  1, 128 SAY Str( ZFOL, 4 )
         @  2, 0   SAY repl( "-", 132 )
         @  3, 0   SAY "L I V R O   D E   R E G I S T R O                        - RE - MODELO P1"
         @  4, 0   SAY "FIRMA:" + spac( 45 ) + "MES OU PERIODO/ANO:"
         @  4, 7   SAY wNOME
         @  4, 71  SAY aRETU[ 7 ]
         @  5, 0   SAY "INSC.EST.:" + spac( 16 ) + "CNPJ:" + spac( 20 ) + "Jucesp:" + spac( 17 ) + "em" + spac( 11 ) + "INSC. Municipal:"
         @  5, 11  SAY wINSCR
         @  5, 32  SAY wCGC
         @  5, 59  SAY wJUCESPC
         @  5, 78  SAY wJUCESPD
         @  5, 105 SAY wIMUNICI
         @  6, 0   SAY "ENDEREЂO:" + spac( 42 ) + "Cidade:" + spac( 37 ) + "Estado:    CEP:"
         @  6, 10  SAY wENDERECO
         @  6, 59  SAY wCIDADE
         @  6, 103 SAY wESTADO
         @  6, 111 SAY wCEP
         @  7, 0   SAY repl( "-", 132 )
         @  8, 0   SAY "CFO ALIQ. VALOR CONT./SUBST." + spac( 15 ) + "BASE DE CALCULO      VALOR ICMS/IPI      VALOR ISENTO      VALOR OUTROS   OBSERVACAO"
         @  9, 0   SAY repl( "-", 132 )
         CTLIN := 10
      ENDIF
      cCFO := IF( cAPUNEW = "N", CFO, CFONEW )
      IF l200 .AND. Val( cCFO ) >= 200 .AND. cIMPOSTO <> "ISSCOD"
         IF aGRU[ 9 ] > 0
            MBDIJ01( 'Sub-Total', aGRU )
         ENDIF
         l200 := .F.
         AFill( aGRU, 0 )
      ENDIF
      IF l300 .AND. Val( cCFO ) >= 300 .AND. cIMPOSTO <> "ISSCOD"
         IF aGRU[ 9 ] > 0
            MBDIJ01( 'Sub-Total', aGRU )
         ENDIF
         l300 := .F.
         AFill( aGRU, 0 )
      ENDIF
      IF l500 .AND. Val( cCFO ) >= 500 .AND. cIMPOSTO <> "ISSCOD"
         IF aGRU[ 9 ] > 0
            MBDIJ01( 'Sub-Total', aGRU )
         ENDIF
         l500 := .F.
         AFill( aGRU, 0 )
      ENDIF
      IF l600 .AND. Val( cCFO ) >= 600 .AND. cIMPOSTO <> "ISSCOD"
         IF aGRU[ 9 ] > 0
            MBDIJ01( 'Sub-Total', aGRU )
         ENDIF
         l600 := .F.
         AFill( aGRU, 0 )
      ENDIF
      IF cAPUNEW = "N" .OR. cIMPOSTO <> "ISSCOD"
         @ CTLIN, 0 SAY cCFO
      ELSE
         @ CTLIN, 0 SAY cCFO PICT "@R 9.999"
      ENDIF
      aDAD := { ICMBAS, ICMVAL, ICMISE, ICMOUT, IPIBAS, IPIVAL, IPIISE, IPIOUT, CONTABIL, OBSICM, OBSIPI }
      DO CASE
      CASE cIMPOSTO = "IPI"
         IF cAPUNEW = "N"
            MBDIJ01( SUBCFO + " " + Str( IPI, 5, 2 ), aDAD, "#", { "ICMS", "IPI" } )
         ELSE
            MBDIJ01( Str( IPI, 5, 2 ), aDAD, "#", { "ICMS", "IPI" } )
         ENDIF
      CASE cIMPOSTO = "ISS" .AND. cAPUNEW = "N"
         MBDIJ01( SUBCFO + " " + Str( ICM, 5, 2 ), aDAD, "#", { "ISS", "" } )
      CASE cIMPOSTO = "ISS" .OR. cIMPOSTO = "ISSCOD"
         MBDIJ01( Str( ICM, 5, 2 ), aDAD, "#", { "ISS", "" } )
      OTHERWISE
         IF cAPUNEW = "N"
            MBDIJ01( SUBCFO + " " + Str( ICM, 5, 2 ), aDAD, "#", { "ICMS", "IPI" } )
         ELSE
            MBDIJ01( Str( ICM, 5, 2 ), aDAD, "#", { "ICMS", "IPI" } )
         ENDIF
      ENDCASE
      FOR X := 1 TO 11
         aGRU[ X ] += aDAD[ X ]
         aGER[ X ] += aDAD[ X ]
      NEXT X
      dbSkip()
   ENDDO
   IF aGRU[ 9 ] > 0
      MBDIJ01( 'Sub-Total', aGRU )
   ENDIF
   MBDIJ01( "Total", aGER )
   dbCloseAll()
   IMPFOL()
   VIDEO()
   IMPEND()

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MBDIJ01()
// +
// +    Called from ( m_bdij.prg   )   7 - function mbdii()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBDIJ01()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MBDIJ01( cTITULO, aDAD, cDIV, aTIT )

   IF ValType( cDIV ) # "C"
      cDIV := "-"
   ENDIF
   IF cDIV # "#"
      @ CTLIN, 0 SAY repl( cDIV, 132 )
      CTLIN++
   ELSE
      cDIV := "-"
   ENDIF
   @ CTLIN, 5  SAY cTITULO
   @ CTLIN, 22 SAY aDAD[ 9 ] PICT "@E 9999,999,999.99"
   IF ValType( aTIT ) = "A"
      @ CTLIN, 38 SAY aTIT[ 1 ]
   ENDIF
   @ CTLIN, 43  SAY aDAD[ 1 ]  PICT "@E 9999,999,999.99"
   @ CTLIN, 63  SAY aDAD[ 2 ]  PICT "@E 9999,999,999.99"
   @ CTLIN, 81  SAY aDAD[ 3 ]  PICT "@E 9999,999,999.99"
   @ CTLIN, 99  SAY aDAD[ 4 ]  PICT "@E 9999,999,999.99"
   @ CTLIN, 117 SAY aDAD[ 10 ] PICT "@E 9999,999,999.99"
   CTLIN++
   IF cIMPOSTO = "ISS" .OR. cIMPOSTO = "ISSCOD"
   ELSE
      IF ValType( aTIT ) = "A"
         @ CTLIN, 38 SAY aTIT[ 2 ]
      ENDIF
      @ CTLIN, 43  SAY aDAD[ 5 ]  PICT "@E 9999,999,999.99"
      @ CTLIN, 63  SAY aDAD[ 6 ]  PICT "@E 9999,999,999.99"
      @ CTLIN, 81  SAY aDAD[ 7 ]  PICT "@E 9999,999,999.99"
      @ CTLIN, 99  SAY aDAD[ 8 ]  PICT "@E 9999,999,999.99"
      @ CTLIN, 117 SAY aDAD[ 11 ] PICT "@E 9999,999,999.99"
      CTLIN++
   ENDIF
   @ CTLIN, 0 SAY repl( cDIV, 132 )
   CTLIN++
   RETU

// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +
// +    Function MBDIJ02()
// +
// +    Called from ( m_bdij.prg   )   2 - function mbdii()
// +
// +ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
// +


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function MBDIJ02()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC MBDIJ02( cARQ, cTITULO )

   IF !MDG( "Apurar " + cTITULO )
      RETU
   ENDIF
   MDS( "Aguarde Apurando " + cTITULO )
   FILTRO := ''
   FILTRO := RFILORD( cARQ, .F. )
   IF !USEREDE( cARQ, 1, 0 )
      dbCloseAll()
      RETU .F.
   ENDIF
   IF !Empty( FILTRO )
      SET FILTER TO &FILTRO
   ENDIF
   dbGoTop()
   WHILE !Eof()
      @ 24, 40 SAY NUMERO
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
         IF cIMPOSTO = "ISS" .OR. cIMPOSTO = "ISSCOD"
            mCODREC := CODREC
         ENDIF
         IF cIMPOSTO = "ISSCOD"
            mCFO    := mCODREC
            mCFONEW := mCODREC
            mSUBCFO := ""
         ENDIF
         DO CASE
         CASE cIMPOSTO = "IPI"
            IF cAPUNEW = "N"
               mCHAVE := mCFO + mSUBCFO + Str( mIPI, 5, 2 )
            ELSE
               mCHAVE := mCFONEW + Str( mIPI, 5, 2 )
            ENDIF
         CASE cIMPOSTO = "ISSCOD"
            mCHAVE := mCODREC + Str( mICM, 5, 2 )
         OTHERWISE
            IF cAPUNEW = "N"
               mCHAVE := mCFO + mSUBCFO + Str( mICM, 5, 2 )
            ELSE
               mCHAVE := mCFONEW + Str( mICM, 5, 2 )
            ENDIF
         ENDCASE
         dbSelectAr( "FI_TEMP1" )
         dbGoTop()
         IF !dbSeek( mCHAVE )
            netrecapp()
            field->CFO    := mCFO
            field->CFONEW := mCFONEW
            field->SUBCFO := mSUBCFO
            field->ICM    := mICM
            field->IPI    := mIPI
         ENDIF
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
      dbSelectAr( cARQ )
      dbSkip()
   ENDDO
   dbSelectAr( cARQ )
   dbCloseArea()
   RETU .T.

// + EOF: M_BDIJ.PRG

// + EOF: m_bdij.prg
// +
