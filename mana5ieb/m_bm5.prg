*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BM5.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:16 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"

function m_bm5
para cTIPOARQ

MDI( " Э Cruzar Apuracao NF / Apura‡„o Livro" )


IF cTIPOARQ="S"
   aRETU := PERFEC( { "MM02", "MM06" }, { "M2", "M6" }, { "MM92", "MM96" } )
ELSE
   aRETU := PERFEC( { "MK02", "MK06" }, { "K2", "K6" }, { "MK92", "MK96" } )
ENDIF
nMES         := aRETU[ 1 ]
nANO         := aRETU[ 2 ]
ARQNF := aRETU[ 5, 1 ]
ARQLV := aRETU[ 5, 2 ]
mCOMPETENCIA := aRETU[ 7 ]


cAPUNEW:="S"
@ 24,00 SAY "Apurar CFO Novo"
@ 24,40 get cAPUNEW  PICT "!" VALID cAPUNEW $ "SN"

if !USEMULT( { { ARQLV, 1, 0 }, { ARQNF, 1, 0 }, { "MD04", 1, IF(cAPUNEW="S",2,3) } } )
   retu .F.
endif


DBSELECTAR(ARQLV)
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","str( NUMERO, 8 ) + str( FORNECEDO, 5 ) + str( ITEM,5)")
ordSetFocus("temp")




if !CHECKIMP( 0 )
   retu .F.
endif

CTLIN  := 80
nTOTNF := 0
nTOTLV := 0
nTOTAP := 0

IMPRESSORA()
dbselectar( ARQNF )
dbgotop()
while !eof()
   IF cTIPOARQ="S"
      mNUMERO := NUMERO
   ELSE
      mNUMERO := NRNOTA
   ENDIF
   VIDEO()
   @ 24, 00 say mNUMERO
   IMPRESSORA()
   if APURA # "N"
      IF cTIPOARQ="E"
         mCHAVE:=str( NRNOTA, 8 ) + str( FORNECEDO, 5 ) + str( ITEM,5)
      ELSE
         mCHAVE:=str( NUMERO, 8 ) + str( FORNECEDO, 5 ) + str( SEQ,5)
      ENDIF
      mVALORNF := VALORTOT
      cCFO := IF(cAPUNEW="S",CFONEW,left( OPERACAO, 3 ))
      nVALLV   := 0
      nTOTNF   += VALORTOT
      if CTLIN > 50
         CTLIN := 4
      endif
      @ CTLIN,  0 say mNUMERO  pict "999999"
      @ CTLIN,  7 say OPERACAO
      @ CTLIN, 18 say mVALORNF pict "@E 999,999.99"
      dbselectar( ARQLV )
      dbgotop()
      if dbseek( mCHAVE )
         @ CTLIN, 29 say DVALORNF pict "@E 999,999.99"
         nTOTLV += DVALORNF
         nVALLV := DVALORNF
         if mVALORNF # DVALORNF
            @ CTLIN, 41 say "Dif"
         endif
      endif
      lDEBITA  := .F.
      lCREDITA := .F.
      mCFO:=DCFONEW
      dbselectar( "MD04" )
      dbgotop()
      if dbseek( mCFO )
         if PIS = "+" .and. FIN = "+"
            @ CTLIN, 45 say "CRE"
            lCREDITA := .T.
         endif
         if PIS = "-" .and. FIN = "-"
            @ CTLIN, 45 say "DEB"
            lDEBITA := .T.
         endif
         if PIS = "A" .and. FIN = "A"
            @ CTLIN, 45 say "ATV"
         endif
         if PIS = "E" .and. FIN = "E"
            @ CTLIN, 45 say "EXP"
         endif
         if PIS = "M" .and. FIN = "M"
            @ CTLIN, 45 say "MAO"
         endif
      endif
      if lCREDITA
         nTOTAP += nVALLV
         @ CTLIN, 50 say nVALLV pict "@E 999,999.99"
      endif
      if lDEBITA
         nTOTAP -= nVALLV
         @ CTLIN, 50 say - nVALLV pict "@E 999,999.99"
      endif
      CTLIN ++
   endif
   dbselectar( ARQNF )
   dbskip()
enddo
dbcloseall()
@ CTLIN,  0 say "TOTAL"
@ CTLIN, 18 say nTOTNF  pict "@E 9999999.99"
@ CTLIN, 29 say nTOTLV  pict "@E 9999999.99"
@ CTLIN, 50 say nTOTAP  pict "@E 9999999.99"
IMPFOL()
VIDEO()
IMPEND()

*+ EOF: M_BM5.PRG
