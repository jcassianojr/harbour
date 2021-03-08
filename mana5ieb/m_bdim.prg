*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => J:\ITAESBRA\M_BDIM.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

//#INCLUDE "COMANDO.CH"
function m_bdim
PARA cIMPOSTO

IF cIMPOSTO="IPI"
   MDI( " н Resumo por Aliquotas IPI" )
ELSE
   MDI( " н Resumo por Aliquotas ICM" )
ENDIF

cTIPOCAN:="T"
@ 23,00 SAY "Grupo (T)odos (C)anceladas (N)Цo Canceladas"
@ 23,40 get cTIPOCAN PICT "!" VALID cTIPOCAN $ "TCN"
if !READCUR()
   retu .F.
endif


aRETU   := PERFEC( { "MM06","MK06" }, { "M6","K6" }, { "MM96","MK96" } )
nMESUSO := aRETU[ 1 ]
nANOUSO := aRETU[ 2 ]
cARQSAI := aRETU[5,1]
cARQENT := aRETU[5,2]
CAB     := aRETU[ 7 ]

if ! CHECKIMP( 0 )
   retu .F.
endif

IF MDG("Listar Entradas")
   M_BDIM01(cARQENT)
ENDIF
IF MDG("Listar Saidas")
   M_BDIM01(cARQSAI)
ENDIF
IMPEND()


FUNC M_BDIM01(cARQ)
ZFOL   := 1
CTLIN  := 1
FILTRO := ''
FILTRO := RFILORD( cARQ, .F. )
if !USEREDE( cARQ, 1, 0 )
   dbcloseall()
   retu .F.
endif
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
IF cIMPOSTO="IPI"
   ordDestroy("temp")
   ordcreate(,"temp","STR(ORDEM,8)+STR(DIPI,5,2)")
   ordSetFocus("temp")
ELSE
   ordDestroy("temp")
   ordcreate(,"temp","STR(ORDEM,8)+STR(DICM,5,2)")
   ordSetFocus("temp")
ENDIF

if !empty( FILTRO )
   set filter to &FILTRO
endif
IMPRESSORA()
dbgotop()
while !eof()
   xLOTE    := LOTE
   xDATA    := DATA
   xDATAREF := DATAREF
   xNUMERO  := NUMERO
   xDOPER   := DOPER
   xORDEM   := ORDEM
   xDIPI    := DIPI
   xDICM    := DICM
   aTOTCOD  := array( 11 )
   afill( aTOTCOD, 0 )
   while xORDEM = ORDEM .and.IF(cIMPOSTO="IPI",xDIPI,xDICM) =IF(cIMPOSTO="IPI",DIPI,DICM) .and. !eof()
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
   if CTLIN > 55
      @  1,  0  say "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
      @  1, 83  say CAB
      @  1, 97  say ZDATA
      @  1, 113 say left( time(), 5 )
      @  1, 128 say str( ZFOL, 4 )
      @  2,  0  say repl( "-", 132 )
      IF cIMPOSTO="IPI"
         @  3,  0  say "Resumo por Aliquotas de IPI"
      ELSE
         @  3,  0  say "Resumo por Aliquotas de ICM"
      ENDIF
      @  4,  0  say repl( "-", 132 )
      CTLIN := 5
      ZFOL ++
   endif
   mXICM := if( aTOTCOD[ 3 ] > 0, "T", "" )
   mXIPI := if( aTOTCOD[ 8 ] > 0, "T", "" )
   mXICM += if( aTOTCOD[ 4 ] > 0, "I", "" )
   mXIPI += if( aTOTCOD[ 9 ] > 0, "I", "" )
   mXICM += if( aTOTCOD[ 5 ] > 0, "O", "" )
   mXIPI += if( aTOTCOD[ 10 ] > 0, "O", "" )

   @ CTLIN,  0  say "SEQUENCIA-"+strzero( xLOTE, 5 )+" DATA ENTRADA-" + DTOC(xDATAREF) + " DATA DOCUMENTO-" + DTOC(xDATA)+" NUN. DOC.-" + STR(xNUMERO,8)
   CTLIN ++
   @ CTLIN,  0 say "VALOR CONT./SUBST." + spac( 19 ) + "BASE DE CALCULO            VALOR ICMS/IPI      VALOR ISENTO      VALOR OUTROS   OBSERVACAO"
   CTLIN ++
   mBDIL01({aTOTCOD[1],aTOTCOD[2],aTOTCOD[3],aTOTCOD[4],aTOTCOD[5],aTOTCOD[6]},.F.,{"COD.ICMS-",mXICM,xDICM})
   mBDIL01({0         ,aTOTCOD[7],aTOTCOD[8],aTOTCOD[9],aTOTCOD[10],aTOTCOD[11]},.T.,{"COD.IPI -",mXIPI,xDIPI})
enddo
IMPFOL()
VIDEO()

*+ EOF: M_BDIM.PRG
