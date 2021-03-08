*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BDIH.PRG
*+
*+    Functions: Function MBDIH()
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:15 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

//#INCLUDE "COMANDO.CH"

function m_bdih
para cTIP

ZFOL := ZLIM := ZLIV := 0
ZULT := ZDATA

if cTIP = "1"
   MDI( " Э APURAЂЋO IPI" )
else
   MDI( " Э APURAЂЋO ICMS" )
endif


aRETU  := PERFEC( { "MM06","MK06" }, { "M6","K6" }, { "MM96","MK96" } )
nMES   := aRETU[ 1 ]
nANO   := aRETU[ 2 ]
ARQSAI := aRETU[5,1]
ARQENT := aRETU[5,2]
mCOMPETENCIA    := aRETU[ 7 ]
nCRE   := nDEB := 0
nDEB01   := nDEB02 := nCRE01 := nCRE02 := nCRE03 := 0
nUFESP   := 0
cPERIODO := "1o. Decendio" + space( 10 )
cTIPOCAN :="T"
cAPUNEW:="S"


@ 20 ,00 SAY "Digite o M€s e o ano"
@ 21, 00 SAY "Digite o Complemento"
@ 22, 00 SAY "Digite a Ufesp"
@ 23, 00 SAY "Grupo (T)odos (C)anceladas (N)Жo Canceladas"
@ 24,00 SAY "Apurar CFO Novo"
@ 20, 40 get nMES
@ 20, 45 get nANO
@ 21, 30 get cPERIODO
@ 22, 40 get nUFESP pict "9999.999"
@ 23, 40 get cTIPOCAN PICT "!" VALID cTIPOCAN $ "TCN"
@ 24,40 get cAPUNEW  PICT "!" VALID cAPUNEW $ "SN"
IF ! READCUR()
   RETU .F.
ENDIF

lESTORNO := MDG( "Incluir Estornos" )
if lESTORNO .and. MDG( "Revisar Estornos" )
   PADRAO( 0, 1, 0, "FI_OCO", "Ano/Mes T It Ocorencia" + spac( 22 ) + "Valor/ICM    Valor/IPI", ;
           "' '+STR(mANO,  4)+' '+STR(mMES,  2)+' '+mTIPO+' '+STR(mITEM,  2)+' '+mDESCRICAO+' '+STR(mVALICM, 12, 2)+' '+STR(mVALIPI, 12, 2)", ;
           "MA54", "MA5401", "MA5401", ;
           { || iMA54() }, { || PADARR( "FI_OCO", str( nANO, 4 ) + str( nMES, 2 ), "STR(nANO,4)+STR(nMES,2)", "STR(ANO,4)+STR(MES,2)" ) } )
endif


if MDG( "Apurar Entrada" )
   MDS( "Aguarde Apurando Entrada" )
   M_BDIH01(ARQENT,"C")
endif

if MDG( "Apurar Saida" )
   MDS( "Aguarde Apurando Saida" )
   M_BDIH01(ARQSAI)
endif

priv   wNOME,wINSCR,wCGC,wJUCESPC,wJUCESPD
priv   wIMUNICI,wENDERECO,wCIDADE,wESTADO,wCEP,wBAIRRO
pegempmbdi()


if cTIP = "1"
   PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAXIPI", "FILIVIPI", "FILIMIPI", "FILAIPI" }, { "ZFOL", "ZLIV", "ZLIM", "ZULT" } )
else
   PEGACAMPO( "FI_MES", "STR(ZNUMERO,5)+STRZERO(nANO,4)+STRZERO(nMES,2)", { "FIPAXICM", "FILIVICM", "FILIMICM", "FILAICM" }, { "ZFOL", "ZLIV", "ZLIM", "ZULT" } )
endif
ZFOL ++

if !CHECKIMP( 0 )
   retu .F.
endif

if lESTORNO
   if !USEREDE( "FI_OCO", 1, 1 )
      retu .F.
   endif
endif

IMPRESSORA()
if ZFOL = ZLIM
   M_BDIN( if( cTIP = "2", 6, 8 ) )
   ZLIV ++
   ZFOL := 1
   M_BDIN( if( cTIP = "2", 5, 7 ) )
   ZFOL := 2
endif

video()
if MDG( "Confirmar Valores" )
   @ 23, 00 clea
   @ 23, 00 say "Creditos"
   @ 23, 20 say "Debitos"
   @ 24, 00 get nCRE
   @ 24, 20 get nDEB
   READCUR()
endif
impressora()

@  1,  0  say "S O F T E C   -  S I S T E M A   D E   L I V R O S   F I S C A I S      REF.:"+mCOMPETENCIA+" DATA:" + DTOC(ZDATA) + " HORA:" + left( time(), 5 ) + " F.:"+str( ZFOL, 4 )
@  2,  0  say repl( "-", 132 )
if cTIP = "1"
   @  3,  0 say "R E G I S T R O  D E  A P U R A C A O  D O  I P I"
else
   @  3,  0 say "R E G I S T R O  D E  A P U R A C A O  D O  I C M S"
endif
@  4,  0  say "FIRMA:" +wNOME + "MES OU PERIODO/ANO:"+alltrim( cPERIODO ) + " " + mCOMPETENCIA
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
@  8, 40  say "DEBITO DO IMPOSTO (SAIDAS)"
@ 10,  0  say "Por Saidas com Debito de Imposto    "
@ 10, 50  say nDEB                                                                                                              pict "999,999,999.99"
@ 12,  0  say "Outros Debitos               "
MBDIH( "A", "nDEB01" )
if empty( nDEB01 )
   @ prow(), 50 say nDEB01 pict "999,999,999.99"
endif
@ prow() + 2, 0 say "Estorno de Creditos                 "
MBDIH( "B", "nDEB02" )
if empty( nDEB02 )
   @ prow(), 50 say nDEB02 pict "999,999,999.99"
endif
nTOTDEB := nDEB + nDEB01 + nDEB02
@ prow() + 2, 0  say "TOTAL"
@ prow(), 60     say nTOTDEB                                pict "999,999,999.99"
@ prow() + 2, 0  say repl( "-", 132 )
@ prow() + 1, 40 say "CREDITO DO IMPOSTO (ENTRADAS)"
@ prow() + 2, 0  say "Por Entradas com Credito do Imposto "
@ prow(), 50     say nCRE                                   pict "999,999,999.99"
@ prow() + 2, 0  say "Saldo Credor do Periodo Anterior    "
MBDIH( "C", "nCRE01" )
if empty( nCRE01 )
   @ prow(), 50 say nCRE01 pict "999,999,999.99"
endif
@ prow() + 2, 0 say "Outros Creditos                     "
MBDIH( "D", "nCRE02" )
if empty( nCRE02 )
   @ prow(), 50 say nCRE02 pict "999,999,999.99"
endif
@ prow() + 2, 0 say "Estorno de Debitos                  "
MBDIH( "E", "nCRE03" )
if empty( nCRE03 )
   @ prow(), 50 say nCRE03 pict "999,999,999.99"
endif
nTOTCRE := nCRE + nCRE01 + nCRE02 + nCRE03
@ prow() + 2, 0  say "TOTAL                               "
@ prow(), 60     say nTOTCRE                                 pict "999,999,999.99"
@ prow() + 2, 0  say repl( "-", 132 )
@ prow() + 1, 40 say "APURACAO DOS SALDOS"
@ prow() + 2, 0  say "Saldo Devedor (Debito Menos Credito) "
if nTOTCRE < nTOTDEB
   @ prow(), 60 say nTOTDEB - nTOTCRE pict "999,999,999.99"
else
   @ prow(), 60 say 0 pict "999,999,999.99"
endif
@ prow() + 2, 0 say "Dedu‡”es "
@ prow() + 2, 0 say "Imposto a Recolher "
if nTOTCRE < nTOTDEB
   @ prow(), 60 say nTOTDEB - nTOTCRE pict "999,999,999.99"
else
   @ prow(), 60 say 0 pict "999,999,999.99"
endif
@ prow() + 2, 0 say "Saldo Devedor/Imposto a Recolher em Ufesp"
if nTOTCRE < nTOTDEB
   @ prow(), 60 say round( ( nTOTDEB - nTOTCRE ) / nUFESP, 3 ) pict "999,999,999.999"
else
   @ prow(), 60 say 0 pict "999,999,999.99"
endif
@ prow() + 2, 0 say "Saldo Credor (Credito menos Debito)   "
@ prow() + 1, 0 say "A transportar Perido Sequinte"
if nTOTCRE > nTOTDEB
   @ prow(), 60 say nTOTCRE - nTOTDEB pict "999,999,999.99"
endif
IMPFOL()
if lESTORNO
   dbcloseall()
endif
VIDEO()
IMPEND()

*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Function MBDIH()
*+
*+    Called from ( m_bdih.prg   )   5 - function mbdg02()
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
func MBDIH( cREF, cVAR)

if !lESTORNO
   retu .T.
endif
dbgotop()
dbseek( str( nANO, 4 ) + str( nMES, 2 ) + cREF )
while nANO = ANO .and. nMES = MES .and. cREF = TIPO .and. !eof()
   if cTIP = "1" .and. !empty( VALIPI )
      &cVAR. += VALIPI
      @ prow() + 1, 0 say DESCRICAO
      @ prow(), 60    say           VALIPI pict "999,999,999.99"
   endif
   if cTIP = "2" .and. !empty( VALICM )
      &cVAR. += VALICM
      @ prow() + 1, 0 say DESCRICAO
      @ prow(), 60    say           VALICM pict "999,999,999.99"
   endif
   dbskip()
enddo
retu .T.

func somacancel()
lSOMA:=.F.
IF cTIPOCAN="T"
   lSOMA:=.T.
ENDIF
IF cTIPOCAN="C".AND. ! EMPTY(DCANCEL)
   lSOMA:=.T.
ENDIF
IF cTIPOCAN="N".AND.EMPTY(DCANCEL)
   lSOMA:=.T.
ENDIF
retu lSOMA

FUNC pegempmbdi
if !USEREDE( "MANEMP", 1, 1 )
   retu .F.
endif
dbgotop()
IF dbseek( ZNUMERO )
   wNOME     := NOME
   wINSCR    := INSCR
   wCGC      := CGC
   wJUCESPC  := JUCESPC
   wJUCESPD  := JUCESPD
   wIMUNICI  := IMUNICI
   wENDERECO := ENDERECO
   wCIDADE   := CIDADE
   wESTADO   := ESTADO
   wCEP      := CEP
   wBAIRRO   := BAIRRO
else
   dbcloseall()
   retu .F.
endif
dbcloseall()
retu .t.


FUNC M_BDIH01(cARQ,cTIPO)
   FILTRO := ''
   FILTRO := RFILORD( cARQ, .F. )
   if ! USEREDE(cARQ, 1, 0 )
      dbcloseall()
      retu .F.
   endif
   if !empty( FILTRO )
      set filter to &FILTRO
   endif
   dbgotop()
   while !eof()
      @ 24, 40 say NUMERO
      IF somacancel()
         IF cTIPO="C"
            if cTIP = "1"
               nCRE += DVALIPI
            else
               nCRE += DVALICM
            endif
         ELSE
            if cTIP = "1"
               nDEB += DVALIPI
            else
               nDEB += DVALICM
            endif
         ENDIF
      ENDIF
      dbskip()
   enddo
   dbcloseall()
RETU


*+ EOF: M_BDIH.PRG
