*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
*+
*+    Source Module => J:\ITAESBRA\M_BM6.PRG
*+
*+
*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ

//Modo de Trabalho no Video
MDI( " Ý C lculo da Apura‡„o de Vendas" )

// Variaveis de Trabalho
CRIARVARS( "MA01" )
CRIARVARS( "MM02" )

//Pegando Cores de Trabalho
MAO001 := COR( "MAO001" )

// declaracao de variaveis
mSUCATA1 := mSUCATA2 := 0.00
mVALPRES := 0

ARQWORK  := "MM02"
ARQWORK2 := "MK01"
ARQWORK3 := "MN01PG"
ARQWORK4 := "MM01"

//Declarando vari veis iniciais de trabalho
GASMESANT := 0.00
DESPMES   := 0.00
nMESUSO   := month( ZDATA )
nANOUSO   := year( ZDATA )

MDS( "Confirme a Competencia" )
@ 24, 50 get nMESUSO
@ 24, 60 get nANOUSO
if !READCUR()
   retu .F.
endif

if MDG( "Revisar Saldos Anteriores" )
   PADRAO( 0, 1, 0, "APUITA", "Mes Ano Valor", "' '+STR(mANO)+' '+STR(mMES)+' '+STR(mSALDO,18,2)", "MBM6" )
endif

if MDG( "Revisar Servicos" )
   PADRAO( 0, 1, 0, "APUSER", "Cliente  Ano Mes Valor", "' '+STR(mCLIENTE,8)+' '+STR(mANO,4)+' '+STR(mMES,2)+' '+STR(mVALOR,12,2)", "MBM6A" )
endif

cMESUSO := strzero( nMESUSO, 2 )
cANOUSO := substr( strzero( nANOUSO, 4 ), 3, 2 )
//xyMES  :=nMESUSO
if nMESUSO = 1
   FATMESANT := OBTER( "APUITA", str( nANOUSO - 1, 4 ) + str( 12, 2 ), "SALDO" )
else
   FATMESANT := OBTER( "APUITA", str( nANOUSO, 4 ) + str( nMESUSO - 1, 2 ), "SALDO" )
endif

if MDG( "Mes j  Fechado" )
   xREFMES  := cANOUSO + cMESUSO
   ARQWORK  := "M2" + xREFMES
   ARQWORK2 := "K1" + xREFMES
   ARQWORK3 := "MN" + xREFMES
   ARQWORK4 := "M1" + xREFMES
else
   if MDG( "Deseja Acumulado" )
      xREFMES := space( 20 )
      MDS( "Digite Observa‡ao de Cabe‡ario" )
      @ 24, 40 get xREFMES
      READCUR()
      if MDG( "Deseja Reacumular" )
         aPER := PEDPER( .T. )
         SOMAANO( "MM92", "M2",,,,,,, aPER )
         SOMAANO( "MK91", "K1",,,,,,, aPER )
         SOMAANO( "MN99", "MN",,,,,,, aPER )
         SOMAANO( "MM91", "M1",,,,,,, aPER )
      endif
      ARQWORK  := "MM92"
      ARQWORK2 := "MK91"
      ARQWORK3 := "MN99"
      ARQWORK4 := "MM91"
   endif
endif

setcolor( MAO001 )
@ 21, 00 clea
@ 21, 05 say "Digite o Faturamento do Mˆs Anterior  => " get FATMESANT pict '999,999,999.99'
@ 22, 05 say "Digite o Valor Pago no Mˆs Anterior   => " get GASMESANT pict '999,999,999.99'
if !READCUR()
   dbcloseall()
   retu .F.
endif

if !USEREDE( "APURA", 0, 99 )
   retu
endif
zap
dbclosearea()

if !USEREDE( "APURA2", 0, 99 )
   retu
endif
zap
dbclosearea()

mDESPMES := GASMESANT

@ 24, 00
@ 24, 05 say "Apurando Vendas Aguarde ..."

mTOT1NF := mTOT2NF := mTOT3NF := mTOT4NF := 0.00
mTOT1   := mTOT2 := mTOT3 := mTOT4 := mTOTIPI := 0.00
mTOTS   := mTOTSNF := 0
lTIPO02 := MDG( "Listar Tipo Serv 2-Ferramenta" )
lTIPSER := MDG( "Listar Servi‡os" )

aUFE := {}
if MDG( "Especificar Grupo Clientes/Fornecedores - Excluir" )
   nNUMERO := 0
   @ 24, 00 say "Cliente No."
   @ 24, 60 say "Esc ou 0 para encerrar"
   while .T.
      @ 24, 20 get nNUMERO
      if !READCUR()
         exit
      endif
      if empty( nNUMERO )
         exit
      endif
      aadd( aUFE, nNUMERO )
   enddo
   if empty( aUFE )
      ALERTX( "Grupo NÆo Especificado" )
   endif
endif

if !USEMULT( { { "MA01", 1, 1 }, { "MB01", 1, 1 }, { ARQWORK4, 1, 1 }, { "APURA", 1, 1 }, { "APUSER", 1, 99 }, { ARQWORK, 1, 2 } } )
   retu
endif

dbselectar( ARQWORK )
set filter to APURA # "N"
dbgotop()
while !eof()
   FORN      := FORNECEDO
   mCOGNOME  := space( 12 )
   mGRUPOEMP := space( 12 )
   nNUMERO   := 0
   while FORN = FORNECEDO .and. !eof()
      @ 24, 40 say FORNECEDO pict '99999'
      @ 24, 50 say NUMERO    pict "999999"
      @ 24, 63 say VALORTOT  pict '@E 999,999,999.99'
      nNUMERO := NUMERO
      if ascan( aUFE, FORN ) = 0        //Se nao estiver lista excluidos
         do case
         case TIPOSERV = "1"            //Produ‡„o
            mTOT1   := ( VALORTOT - VALORIPI ) + mTOT1
            mTOT1NF := VALORTOT + mTOT1NF
         case TIPOSERV = "2"            //Ferram.
            if lTIPO02
               mTOT2   := ( VALORTOT - VALORIPI ) + mTOT2
               mTOT2NF := VALORTOT + mTOT2NF
            endif
         case TIPOSERV = "3"            //Mo.Produ‡„o
            mTOT3   := ( VALORTOT - VALORIPI ) + mTOT3
            mTOT3NF := VALORTOT + mTOT3NF
         case TIPOSERV = "4"            //Mo.Ferram.
            mTOT4   := ( VALORTOT - VALORIPI ) + mTOT4
            mTOT4NF := VALORTOT + mTOT4NF
         case TIPOSERV = "5"
            mSUCATA1 := ( VALORTOT - VALORIPI ) + mSUCATA1
            mSUCATA2 := VALORTOT + mSUCATA2
         endcase
         if TIPOSERV >= "1" .and. TIPOSERV <= "5"
            if TIPOSERV <> "2" .or. lTIPO02
               mTOTIPI := VALORIPI + mTOTIPI
            endif
         endif
      endif
      dbskip()
   enddo
   mTIPOCLI := "C"
   dbselectar( ARQWORK4 )
   dbgotop()
   if dbseek( nNUMERO )
      mTIPOCLI := if( empty( TIPOCLI ), "C", TIPOCLI )
   endif
   dbselectar( if( mTIPOCLI = "F", "MB01", "MA01" ) )
   dbgotop()
   if dbseek( FORN )
      mCOGNOME := COGNOME
      if mTIPOCLI = "C"
         mGRUPOEMP := GRUPOEMP
      endif
   endif
   if lTIPSER
      dbselectar( "APUSER" )
      dbgotop()
      dbseek( str( FORN, 8 ) + str( nANOUSO, 4 ) + str( nMESUSO, 2 ) )
      while FORN = CLIENTE .and. ANO = nANOUSO .and. MES = nMESUSO .and. !eof()
         mTOTS   += VALOR
         mTOTSNF += VALOR
         dbskip()
      enddo
   endif

   mTOTALMER := mTOT1 + mTOT2 + mTOT3 + mTOT4 + mTOTS
   mTOTAL    := mTOTIPI + mTOTALMER
   if mTOTALMER > 0                     //.AND.aSCAN(aUFE,FORN)=0 movido loop soma acima
      //Para exluir todos tipos sucata...
      dbselectar( "APURA" )
      netrecapp()
      field->FORNECEDO := FORN
      field->COGNOME   := mCOGNOME
      field->GRUPOEMP  := mGRUPOEMP
      field->PROD      := mTOT1
      field->FERRA     := mTOT2
      field->MOPROD    := mTOT3
      field->MOFERRA   := mTOT4
      field->SERV      := mTOTS
      field->TOTALMER  := mTOTALMER
      field->total     := mTOTAL
      field->PROD2     := mTOT1NF
      field->FERRA2    := mTOT2NF
      field->MOPROD2   := mTOT3NF
      field->MOFERRA2  := mTOT4NF
      field->SERV2     := mTOTSNF
   endif
   //zerando vari veis de trabalho.
   mTOTALMER := mTOTAL := 0.00
   mTOT1NF   := mTOT2NF := mTOT3NF := mTOT4NF := 0.00
   mTOT1     := mTOT2 := mTOT3 := mTOT4 := mTOTIPI := 0.00
   mTOTS     := mTOTSNF := 0
   dbselectar( ARQWORK )
enddo

//Servicos Sem Nota Fiscal de Saida
if lTIPSER
   dbselectar( "APUSER" )
   dbsetorder( 2 )
   dbgotop()
   dbseek( str( nANOUSO, 4 ) + str( nMESUSO, 2 ) )
   while ANO = nANOUSO .and. MES = nMESUSO .and. !eof()
      mFORNECEDO := CLIENTE
      mCOGNOME   := ""
      mGRUPOEMP  := ""
      //zerando vari veis de trabalho.
      mTOTS := 0
      while mFORNECEDO = CLIENTE .and. ANO = nANOUSO .and. MES = nMESUSO .and. !eof()
         if SEMNOTA = "S"
            mTOTS += VALOR
         endif
         dbskip()
      enddo
      if mTOTS > 0
         dbselectar( "MA01" )
         dbgotop()
         if dbseek( mFORNECEDO )
            mCOGNOME  := COGNOME
            mGRUPOEMP := GRUPOEMP
         endif
         if mTOTS > 0 .and. ascan( aUFE, mFORNECEDO ) = 0
            dbselectar( "APURA" )
            netrecapp()
            field->FORNECEDO := mFORNECEDO
            field->COGNOME   := mCOGNOME
            field->GRUPOEMP  := mGRUPOEMP
            field->SERV      := mTOTS
            field->TOTALMER  := mTOTS
            field->total     := mTOTS
            field->SERV2     := mTOTS
         endif
      endif
      dbselectar( "APUSER" )
   enddo
   dbcloseall()
endif

@ 24, 00
@ 24, 05 say "Fazendo os C lculos da Apura‡„o de Vendas"
aGRAVA := {}

if !USEREDE( "APURA", 0, 99 )
   dbcloseall()
   retu
endif
dbgotop()
mTOTMERC := mSUCATA1 + mVALPRES         //Soma Sucata e Presta‡„o de Servicos
while !eof()
   mTOTMERC += TOTALMER                 //Soma as Notas Apuradas
   dbskip()
enddo
dbgotop()
while !eof()
   //Declara‡„o de vari veis
   aadd( aGRAVA, { FORNECEDO, COGNOME, GRUPOEMP, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } )
   // 1         2          3   4 5 6 7 8 9 10 11 12 13 14 15
   nPOS  := len( aGRAVA )
   mCOGN := COGNOME
   while mCOGN = COGNOME .and. !eof()
      aGRAVA[ NPOS, 4 ] += PROD
      aGRAVA[ NPOS, 5 ] += FERRA
      aGRAVA[ NPOS, 6 ] += MOPROD
      aGRAVA[ NPOS, 7 ] += MOFERRA
      aGRAVA[ NPOS, 8 ] += TOTALMER
      aGRAVA[ NPOS, 9 ] += total
      aGRAVA[ NPOS, 10 ] += PROD2
      aGRAVA[ NPOS, 11 ] += FERRA2
      aGRAVA[ NPOS, 12 ] += MOPROD2
      aGRAVA[ NPOS, 13 ] += MOFERRA2
      aGRAVA[ NPOS, 14 ] += SERV
      aGRAVA[ NPOS, 15 ] += SERV2
      dbskip()
   enddo
enddo
dbcloseall()

if !USEREDE( "APURA2", 0, 99 )
   dbcloseall()
   retu
endif
zap
for X := 1 to len( aGRAVA )
   if aGRAVA[ X, 9 ] > 0
      netrecapp()
      field->FORNECEDO := aGRAVA[ X, 1 ]
      field->COGNOME   := aGRAVA[ X, 2 ]
      field->GRUPOEMP  := aGRAVA[ X, 3 ]
      field->PROD      := aGRAVA[ X, 4 ]
      field->FERRA     := aGRAVA[ X, 5 ]
      field->MOPROD    := aGRAVA[ X, 6 ]
      field->MOFERRA   := aGRAVA[ X, 7 ]
      field->TOTALMER  := aGRAVA[ X, 8 ]
      field->total     := aGRAVA[ X, 9 ]
      field->PROD2     := aGRAVA[ X, 10 ]
      field->FERRA2    := aGRAVA[ X, 11 ]
      field->MOPROD2   := aGRAVA[ X, 12 ]
      field->MOFERRA2  := aGRAVA[ X, 13 ]
      field->SERV      := aGRAVA[ X, 14 ]
      field->SERV2     := aGRAVA[ X, 15 ]
      field->PORCENTO  := PERC( TOTALMER, mTOTMERC )
   endif
next X
dbcloseall()

M_BM6A()

@ 24, 00
retu

*+ EOF: M_BM6.PRG
