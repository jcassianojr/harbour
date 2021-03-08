*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BDIA.PRG
*+
*+    Functions: Function M_BDIA01()
*+
*+    Reformatted by Click! 2.03 on Dec-5-2002 at  2:54 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"



//Modo de Trabalho no Video
MDI( " Э Imprimir Relatўrio " )

if !CHECKIMP( 0 )
   retu .F.
endif
cEMP := IMP( "ZEMP" )

aRETU   := PERFEC( { "MK06", "MM06" }, { "K6", "M6" }, { "MK96", "MM96" } )
MES     := aRETU[ 1 ]
ANO     := aRETU[ 2 ]
cARQENT := aRETU[ 5, 1 ]
cARQSAI := aRETU[ 5, 2 ]
cVAR    := aRETU[ 7 ]
cCABAUX := space( 40 )
cAPUNEW:="S"


cTIPOCAN := "T"
cTIPREL  := "S"
@ 21,00 SAY "Quebrar por Unidade"
@ 22,00 say "Cabe‡ario Aux."
@ 23,00 say "Grupo (T)odos (C)anceladas (N)Жo Canceladas"
@ 24,00 SAY "Apurar CFO Novo"
@ 21,00 get cTIPREL    PICTURE "!" VALID cTIPREL $ "SN"
@ 22,20 get cCABAUX
@ 23,45 get cTIPOCAN pictURE "!" valid cTIPOCAN $ "TCN"
@ 24,40 get cAPUNEW   PICTURE "!" VALID cAPUNEW $ "SN"
if !READCUR()
   retu .F.
endif

if MDG( "Entradas" )
   M_BDIA01( cARQENT, "DIPI - Nota Fiscal de Entradas" )
endif
if MDG( "Saidas" )
   M_BDIA01( cARQSAI, "DIPI - Nota Fiscal de Saidas" )
endif
VIDEO()

IMPEND()

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function M_BDIA01()
*+
*+    Called from ( m_bdia.prg   )   2 -
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func M_BDIA01( ARQWORK )


// Vari veis de Trabalho
CTLIN     := 1
xUNIDADE  := space( 2 )
xDVALORNF := xDBASEICM := xDVALICM := xISENTAICM := 0.00
xOUTRAICM := xDBASEIPI := xDVALIPI := xISENTAIPI := xOUTRAIPI := 0.00
xOBSICM   := xOBSIPI := 0
tDVALORNF := tDBASEICM := tDVALICM := tISENTAICM := 0.00
tOUTRAICM := tDBASEIPI := tDVALIPI := tISENTAIPI := tOUTRAIPI := 0.00
tOBSICM   := tOBSIPI := 0
xQTDE     := 0.000
tQTDE     := 0.000

FILTRO := ''
FILTRO := RFILORD( ARQWORK, .F. )

CTLIN := 80
if !USEREDE( ARQWORK, 1, 0 )
   retu
endif
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
IF cAPUNEW="N"
   ordDestroy("temp")
   ordcreate(,"temp","dcfonew+dclassipi+unidade")
   ordSetFocus("temp")
ELSE
   ordDestroy("temp")
   ordcreate(,"temp","doper+dclassipi+unidade")
   ordSetFocus("temp")
ENDIF


if !empty( FILTRO )
   set filter to &FILTRO
endif
dbgotop()
ZFOL := 0
if !eof()
   IMPRESSORA()
endif

while !eof()
   xDOPER := IF(cAPUNEW="N",DOPER,DCFONEW)
   while xDOPER = IF(cAPUNEW="N",DOPER,DCFONEW) .and. !eof()
      xDCLASSIPI := DCLASSIPI
      xUNIDADE   := UNIDADE
      while if( cTIPREL = "S",  xUNIDADE = UNIDADE,.T.).AND. ;
            xDCLASSIPI = DCLASSIPI .and. xDOPER = IF(cAPUNEW="N",DOPER,DCFONEW)  .and. !eof()
         if SOMACANCEL()
            //Acumuladores de Totais Gerais.
            xDVALORNF  += DVALORNF
            xDBASEICM  += DBASEICM
            xDVALICM   += DVALICM
            xISENTAICM += ISENTAICM
            xOUTRAICM  += OUTRAICM
            xOBSICM    += OBSICM
            xDBASEIPI  += DBASEIPI
            xDVALIPI   += DVALIPI
            xISENTAIPI += ISENTAIPI
            xOUTRAIPI  += OUTRAIPI
            xOBSIPI    += OBSIPI
            xQTDE      += QUANT
         endif
         dbskip()
      enddo
      if CTLIN > 55
         if CTLIN <> 80 .and. CTLIN < 60
            @ CTLIN,  0 say repl( '-', 230 )
         endif
         ZFOL ++
         @  1,  0  say "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S" + spac( 11 ) + "REF.:         DATA:" + spac( 11 ) + "HORA:" + spac( 11 ) + "F.:"
         @  1, 83  say cVAR
         @  1, 97  say ZDATA
         @  1, 113 say left( time(), 5 )
         @  1, 128 say str( ZFOL, 4 )
         @  2,  0  say repl( "-", 132 )
         @  3, 01  say 'DIPI-A'
         @  3, 20  say cCABAUX
         @  6,  2  say impchr(cIMPTIT) + cEMP + impchr(cIMPEXP)
         @  7, 00  say impchr(cIMPCOM) + repl( '-', 230 )
         @  9, 00  say 'Cod.Fisc.'
         @  9, 12  say 'Classific.'
         @  9, 32  say 'Total da NF'
         @  9, 47  say 'Base ICM'
         @  9, 62  say 'Valor ICM'
         @  9, 77  say 'Isentas ICM'
         @  9, 92  say 'Outras ICM'
         @  9, 107 say 'OBS ICM'
         @  9, 122 say 'Base IPI'
         @  9, 137 say 'Valor IPI'
         @  9, 152 say 'Isentas IPI'
         @  9, 167 say 'Outras IPI'
         @  9, 182 say 'Obs IPI'
         if cTIPREL = "S"
            @  9, 197 say 'Unid.  Quantidade'
         endif
         @ 10, 00 say repl( '-', 230 )
         CTLIN := 11
      endif
      @ CTLIN, 02  say xDOPER + '  -'
      @ CTLIN, 10  say xDCLASSIPI
      @ CTLIN, 32  say xDVALORNF      pict '@E 99,999,999.99'
      @ CTLIN, 47  say xDBASEICM      pict '@E 99,999,999.99'
      @ CTLIN, 62  say xDVALICM       pict '@E 99,999,999.99'
      @ CTLIN, 77  say xISENTAICM     pict '@E 99,999,999.99'
      @ CTLIN, 92  say xOUTRAICM      pict '@E 99,999,999.99'
      @ CTLIN, 107 say xOBSICM        pict '@E 99,999,999.99'
      @ CTLIN, 122 say xDBASEIPI      pict '@E 99,999,999.99'
      @ CTLIN, 137 say xDVALIPI       pict '@E 99,999,999.99'
      @ CTLIN, 152 say xISENTAIPI     pict '@E 99,999,999.99'
      @ CTLIN, 167 say xOUTRAIPI      pict '@E 99,999,999.99'
      @ CTLIN, 182 say xOBSIPI        pict '@E 99,999,999.99'
      if cTIPREL = "S"
         @ CTLIN, 197 say xUNIDADE pict '@!'
         @ CTLIN, 200 say xQTDE    pict '@E 999999999.999'
      endif
      CTLIN ++
      //Total Geral de cada item.
      tDVALORNF  += xDVALORNF
      tDBASEICM  += xDBASEICM
      tDVALICM   += xDVALICM
      tISENTAICM += xISENTAICM
      tOUTRAICM  += xOUTRAICM
      tOBSICM    += xOBSICM
      tDBASEIPI  += xDBASEIPI
      tDVALIPI   += xDVALIPI
      tISENTAIPI += xISENTAIPI
      tOUTRAIPI  += xOUTRAIPI
      tOBSIPI    += xOBSIPI
      tQTDE      += xQTDE

      //zera vari veis
      xDVALORNF := xDBASEICM := xDVALICM := xISENTAICM := 0.00
      xOUTRAICM := xDBASEIPI := xDVALIPI := xISENTAIPI := xOUTRAIPI := 0.00
      xQTDE     := 0.000
      xOBSICM   := xOBSIPI := 0
   enddo
   @ CTLIN, 00 say repl( '-', 230 )
   CTLIN ++
   @ CTLIN, 00  say 'Totais : '
   @ CTLIN, 32  say tDVALORNF   pict '@E 99,999,999.99'
   @ CTLIN, 47  say tDBASEICM   pict '@E 99,999,999.99'
   @ CTLIN, 62  say tDVALICM    pict '@E 99,999,999.99'
   @ CTLIN, 77  say tISENTAICM  pict '@E 99,999,999.99'
   @ CTLIN, 92  say tOUTRAICM   pict '@E 99,999,999.99'
   @ CTLIN, 107 say tOBSICM     pict '@E 99,999,999.99'
   @ CTLIN, 122 say tDBASEIPI   pict '@E 99,999,999.99'
   @ CTLIN, 137 say tDVALIPI    pict '@E 99,999,999.99'
   @ CTLIN, 152 say tISENTAIPI  pict '@E 99,999,999.99'
   @ CTLIN, 167 say tOUTRAIPI   pict '@E 99,999,999.99'
   @ CTLIN, 182 say tOBSIPI     pict '@E 99,999,999.99'
   @ CTLIN, 200 say tQTDE       pict '@E 999999999.999'
   CTLIN ++
   @ CTLIN, 00 say repl( '-', 230 )
   CTLIN += 2
   //Zera Totais.
   tDVALORNF := tDBASEICM := tDVALICM := tISENTAICM := 0.00
   tOUTRAICM := tDBASEIPI := tDVALIPI := tISENTAIPI := tOUTRAIPI := 0.00
   tOBSICM   := tOBSIPI := 0
   tQTDE     := 0.000
enddo
dbcloseall()
IMPFOL()

*+ EOF: M_BDIA.PRG
