*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => J:\ITAESBRA\M_BO7.PRG
*+
*+    Reformatted by Click! 2.03 on May-7-2001 at  2:17 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ

function m_bo7
PARA nTIPO
IF nTIPO=1
   MDI( " Э DESADV - MGO - GMB " )
ELSE
   MDI( " Э DESADV - ELECTROLUX " )
ENDIF
tCGC     := OBTER( "MANEMP", ZNUMERO, "CGC" )
mCGC     := substr( tCGC, 1, 2 ) + substr( tCGC, 4, 3 ) + substr( tCGC, 8, 3 ) + substr( tCGC, 12, 4 ) + substr( tCGC, 17, 2 )
mCOMEMP  := "QNO"
mCOMCLI  := "BFT"
mDOC     := space( 5 )
mFABRICA := space( 5 )
mCLIENTE := mNRNOTA := mPESBRU := mITENS := 0
mSERIE   := "0  "
mDATANF  := mDATAEM := substr( dtos( ZDATA ), 3, 8 )
//mETAPA   := "12" //Entrega
mETAPA   := "25" //Retira
mHORAEM  := mHORANF := left( strtran( time(), ":", "" ), 4 )
IF nTIPO=1
   mCAMINHO := "p:\novell\EDIWISE\MANA5\"
ELSE
   mCAMINHO := "p:\novell\ITAESBRA\ARQUIVO\"
ENDIF
mREPOR   := "N"
mGERAAE  := " "

cARQ1:="MM01"
cARQ2:="MM02"


mNRNOTA:=ESCOLHEXI(cARQ1,mNRNOTA,"' '+STR(NUMERO,8)+' '+DTOC(DATA)+' '+HORAEMI","NUMERO","GERAAE=IF(nTIPO=1,'S','E')")
IF VALTYPE(mNRNOTA)#"N"
   mNRNOTA:=0
ENDIF

MDS( "Qual Nota Fiscal" )
@ 24, 40 get mNRNOTA PICT "99999999"
if !READCUR()
   retu .F.
endif
mCAMINHO := alltrim( mCAMINHO ) + "N" + strzero( mNRNOTA, 7 ) + ".TXT"+SPACE(20)

mELE02:=mELE03:=mELE03:=mELE04:=mELE05:=mELE06:=""
mELE07:=mELE08:=mELE09:=mELE10:=mELE11:=mELE12:=mELE13:=""


WHILE .T.
   IF ! PEGACAMPO(cARQ1, "mNRNOTA", { "FORNECEDO","DATA","TOTALBRU","GERAAE"} ,;
                     { "mCLIENTE","mDATANF","mPESBRU","mGERAAE" })
      ALERTX( "Nao achei Nota Fiscal" )
      IF MDG("Tentar Mes Fechado")
         cVAR     := MESANO()
         cARQ1 := "M1" + cVAR
         CARQ2 := "M2" + cVAR
         LOOP
      ENDIF
  ELSE
     EXIT
  endif
ENDDO

IF mGERAAE="G"
   IF ! MDG("Aviso Ja Gerado - Gerar Novamente")
      retu .F.
   ENDIF
ENDIF
IF mGERAAE<>"S".AND.mGERAAE<>"E"
   IF ! MDG("Nota Nao Marcada para Aviso - Gerar ")
      retu .F.
   ENDIF
ENDIF

mPESBRU := strzero( int( mPESBRU ), 10 )
PEGACAMPO( "MA01", "mCLIENTE", { "DOCA", "SISCO"   ,"CLICOMP","CLIENTR","CODIGO","CGCCOMP","CGC3" },;
                               { "mDOC", "mFABRICA","mELE07" ,"mELE08" ,"mELE09","mELE10","mELE11" } )


mELE02:=mNRNOTA
mELE03:=mDATANF
mELE04:=mDATANF
mELE05:=mDATANF
mELE06:=mDATANF
mELE12:=tCGC
mELE13:="FOB"
IF nTIPO=1
  mDATANF:=substr( dtos(mDATANF ), 3, 8 )
ENDIF



if ! USEREDE( cARQ2, 1, 1 )
   dbcloseall()
   retu .F.
endif
//Contando Itens
dbgotop()
dbseek( str( mNRNOTA, 8 ) )
while NUMERO = mNRNOTA .and. !eof()
   mITENS ++
//  24/04/2006 removida conforme solicitacao
//   IF mFABRICA="72474".OR.mFABRICA="72475"
//      IF CODIGO="93.336.186".OR.CODIGO="93.336.187".OR.CODIGO="93.361.545"
//         mDOC:="S01"
//      ENDIF
//   ENDIF
   dbskip()
enddo

IF nTIPO=2
   IF ! USEREDE("OSCRT",1,1)
      DBCLOSEALL()
      RETU .F.
   ENDIF
ENDIF

mDOC   := padr( mDOC, 5 )
mITENS := strzero( int( mITENS ), 18 )

IF mFABRICA="72668".OR.mFABRICA="72667".OR.mFABRICA="72474"
   mCOMCLI  := "MZ7"
ENDIF

IF nTIPO=1
   if ! MBO701()
      retu
   endif
ELSE
   if ! MBO702()
      retu
   endif
ENDIF

if file(mCAMINHO).and.filesize(Mcaminho)>0
   GRAVAMVAR( "MM01", mNRNOTA , {"GERAAE","HORAAE"}, {"'G'","LEFT(TIME(),5)"} )
   gravalog(mCAMINHO,"AE",strzero(mNRNOTA,8))
   gravalog(mFABRICA,"AE",strzero(mNRNOTA,8))
else
   ALERTX("Erro gravando TXT tente novamente")
endif


FUNC MBO701()
TELASAY("AGM001")
EDITSAY("AGM001")
mCAMINHO:=STRTRAN(mCAMINHO," ","")

nHANDLE := fcreate( alltrim( mCAMINHO ) )
if ferror() # 0
   ALERTX( "Erro na Cria‡„o do Arquivo" )
   retu .f.
endif

fwrite( nHANDLE, "AV" )
if mREPOR = "S"
   fwrite( nHANDLE, mCGC )
else
   fwrite( nHANDLE, mCOMEMP )
endif
fwrite( nHANDLE, mCOMCLI )
fwrite( nHANDLE, strzero( mNRNOTA, 6 ) )
fwrite( nHANDLE, mSERIE )
fwrite( nHANDLE, mDATANF )
fwrite( nHANDLE, mHORANF )
fwrite( nHANDLE, mDATAEM )
fwrite( nHANDLE, mHORAEM )
fwrite( nHANDLE, mPESBRU )
fwrite( nHANDLE, mITENS )
fwrite( nHANDLE, mFABRICA )
fwrite( nHANDLE, mDOC )
fwrite( nHANDLE, mETAPA )
if mREPOR = "S"
   fwrite( nHANDLE, space( 2 ) )
else
   fwrite( nHANDLE, space( 13 ) )
endif
fwrite( nHANDLE, chr( 13 ) + chr( 10 ) )

dbselectar( cARQ2 )
dbgotop()
dbseek( str( mNRNOTA, 8 ) )
while NUMERO = mNRNOTA .and. !eof()
   nQTDDE   := CONVUN( QTDE, UNID )
   mCODIGO  := padr( strtran( CODIGO, ".", "" ), 30 )
   mANO     := strzero( year( ZDATA ), 4 )
   mPEDIDO  := padr( PEDIDOCLI, 12 )
   mQTDE01  := strzero( nQTDDE, 10 )
   mQTDE02  := strzero( nQTDDE, 10 )
   mUNIDADE := "EA "
   TELASAY("AGM201")
   EDITSAY("AGM201")
   fwrite( nHANDLE, "IT" )
   fwrite( nHANDLE, mCODIGO )
   fwrite( nHANDLE, mANO )
   fwrite( nHANDLE, mPEDIDO )
   fwrite( nHANDLE, mQTDE01 )
   fwrite( nHANDLE, mQTDE02 )
   fwrite( nHANDLE, mUNIDADE )
   fwrite( nHANDLE, space( 18 ) )
   fwrite( nHANDLE, chr( 13 ) + chr( 10 ) )
   dbselectar( cARQ2 )
   dbskip()
enddo
fwrite( nHANDLE, chr( 26 ) )
fclose( nHANDLE )
retu .t.

FUNC MBO702() //Electrolux
TELASAY("AEL001")
EDITSAY("AEL001")
mCAMINHO:=STRTRAN(mCAMINHO," ","")
nHANDLE := fcreate( alltrim( mCAMINHO ) )
if ferror() # 0
   ALERTX( "Erro na Cria‡„o do Arquivo" )
   retu .f.
endif
fwrite( nHANDLE, "01" )
fwrite( nHANDLE, STRZERO(mELE02,15) )
fwrite( nHANDLE, DTOS(mELE03))
fwrite( nHANDLE, DTOS(mELE04))
fwrite( nHANDLE, DTOS(mELE05))
fwrite( nHANDLE, DTOS(mELE06))
fwrite( nHANDLE, STRZERO(VAL(TIRAOUT(mELE07)),13))
fwrite( nHANDLE, STRZERO(VAL(TIRAOUT(mELE08)),13))
fwrite( nHANDLE, STRZERO(VAL(TIRAOUT(mELE09)),13))
fwrite( nHANDLE, STRZERO(VAL(TIRAOUT(mELE10)),14))
fwrite( nHANDLE, STRZERO(VAL(TIRAOUT(mELE11)),14))
fwrite( nHANDLE, STRZERO(VAL(TIRAOUT(mELE12)),14))
fwrite( nHANDLE, mELE13)
fwrite( nHANDLE, chr( 13 ) + chr( 10 ) )

dbselectar( cARQ2 )
dbgotop()
dbseek( str( mNRNOTA, 8 ) )
while NUMERO = mNRNOTA .and. !eof()
   mOS:=INT(OS)
   mITEM03:=SPACE(13)
   mITEM04:=SPACE(13)
   IF TIPOSERV<>"3"
       mITEM05:=CODIGO
   ELSE
       mITEM05:=PADR(ALLTRIM(CODIGO)+"*OP901",24)
   ENDIF
   mITEM06:=CONVUN(QTDE,UNID)
   mITEM07:=CONVUN(QTDE,UNID)
   mITEM08:=SPACE(15)
   mITEM10:=SPACE(15)
   dbselectar("oscrt")
   dbgotop()
   IF DBSEEK(mOS)
      mITEM03:=CODEAN
      mITEM04:=CODCLI
      mITEM08:=PEDIDOCLI
      mITEM10:=CONTRATO
   ENDIF
   dbselectar( cARQ2 )
   IF EMPTY(mITEM04)
      mITEM04:=mITEM05 //Codigo
   ENDIF
   IF EMPTY(mITEM08)
      mITEM08:=PEDIDOCLI
   ENDIF
   TELASAY("AEL201")
   EDITSAY("AEL201")
   dbselectar( cARQ2 )
   fwrite( nHANDLE, "02" )
   fwrite( nHANDLE,strzero(SEQ,6))
   fwrite( nHANDLE,STRZERO(VAL(TIRAOUT(mITEM03)),13)) //03
   fwrite( nHANDLE,PADR(TIRAOUT(mITEM04),15)) //04
   fwrite( nHANDLE,PADR(TIRAOUT(mITEM05),15)) //05
   fwrite( nHANDLE,GRVVAL(mITEM06,9,2)) //06
   fwrite( nHANDLE,GRVVAL(mITEM07,9,2)) //07
   fwrite( nHANDLE,PADR(TIRAOUT(mITEM08),15)) //08
   fwrite( nHANDLE,STRZERO(mOS,15)) //09
   fwrite( nHANDLE,PADR(TIRAOUT(mITEM10),15)) //10
   fwrite( nHANDLE, STRZERO(mNRNOTA,6) )
   fwrite( nHANDLE,"1  ")
   fwrite( nHANDLE, chr( 13 ) + chr( 10 ) )
   DBSKIP()
ENDDO
fwrite( nHANDLE, chr( 26 ) )
fclose( nHANDLE )
retu .t.

*+ EOF: M_BO7.PRG

