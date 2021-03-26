*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    FOPTO_25.PRG
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

FUNCTION FOPTO_25
PARA nTIPO //1 Ponto->Folha             //2 Ponto->Arquivo.txt
           //3 Refeicao->Arquivo.txt    //4 Refeicao->Folha
           //5 SaldoBanco->Arquivo.txt  //6 SaldoBanco->Folha
           //7 Ver Imprimir folha       //8 Ver imprimir Refeicao 

DO CASE
   CASE nTIPO=1
      CABE2( 'FOPTO_25 - Transferir Totais Para      Folha' )
   CASE nTIPO=2
      CABE2( 'FOPTO_25 - Exportar   Totais para      Folha' )
   CASE nTIPO=3
      CABE2( 'FOPTO_25 - Exportar   Refeicos        Folha' )
   CASE nTIPO=4                                 
      CABE2( 'FOPTO_25 - Transferir Refeicos        Folha' )
   CASE nTIPO=5
      CABE2( 'FOPTO_25 - Exportar   Saldo Banco Hora Folha' )
   CASE nTIPO=6
      CABE2( 'FOPTO_25 - Transferir Saldo Banco Hora Folha' )
   CASE nTIPO=7
      CABE2( 'FOPTO_25 - Ver Arq. Totais Exportados  Folha' )
   CASE nTIPO=8
      CABE2( 'FOPTO_25 - Ver Arq .Exportados     Refeicos' )
      
endcase

cMIG:=strzero(nremp,2)
if ! NETUSE("FIRMA") 
   retu
endif
dbgotop()
if dbseek( NREMP )
  if ! empty(CODEMPMIG)
      cMIG:=CODEMPMIG
  endif
endif
dbcloseall()

IF nTIPO=1.OR.nTIPO=2
   aCODCTA := PEGCX()
   aTR     := PEGCX( "T" )
   FOR X=1 TO 24
      cCTA:="mCTA"+STRZERO(X,2)
      &CCTA.:=aTR[X]
   NEXT    
   @  9,  7 SAY "Cta01   Cta02   Cta03   Cta04   Cta05   Cta06   Cta07   Cta08"
   @ 12,  7 SAY "Cta09   Cta10   Cta11   Cta12   Cta13   Cta14   Cta15   Cta16"
   @ 15,  7 SAY "Cta17   Cta18   Cta19   Cta20   Cta21   Cta22   Cta23   Cta24"
   @ 10, 7 GET mCTA01  valid mCTA01 $ "SN "
   @ 10,15 GET mCTA02  valid mCTA02 $ "SN "
   @ 10,23 GET mCTA03  valid mCTA03 $ "SN "
   @ 10,31 GET mCTA04  valid mCTA04 $ "SN "
   @ 10,39 GET mCTA05  valid mCTA05 $ "SN "
   @ 10,47 GET mCTA06  valid mCTA06 $ "SN "
   @ 10,55 GET mCTA07  valid mCTA07 $ "SN "
   @ 10,63 GET mCTA08  valid mCTA08 $ "SN "
   @ 13, 7 GET mCTA09  valid mCTA09 $ "SN "
   @ 13,15 GET mCTA10  valid mCTA10 $ "SN "
   @ 13,23 GET mCTA11  valid mCTA11 $ "SN "
   @ 13,31 GET mCTA12  valid mCTA12 $ "SN "
   @ 13,39 GET mCTA13  valid mCTA13 $ "SN "
   @ 13,47 GET mCTA14  valid mCTA14 $ "SN "
   @ 13,55 GET mCTA15  valid mCTA15 $ "SN "
   @ 13,63 GET mCTA16  valid mCTA16 $ "SN "
   @ 16, 7 GET mCTA17  valid mCTA17 $ "SN "
   @ 16,15 GET mCTA18  valid mCTA18 $ "SN "
   @ 16,23 GET mCTA19  valid mCTA19 $ "SN "
   @ 16,31 GET mCTA20  valid mCTA20 $ "SN "
   @ 16,39 GET mCTA21  valid mCTA21 $ "SN "
   @ 16,47 GET mCTA22  valid mCTA22 $ "SN "
   @ 16,55 GET mCTA23  valid mCTA23 $ "SN "
   @ 16,63 GET mCTA23  valid mCTA24 $ "SN "
   READCUR()

   FOR X=1 TO 24
      cCTA:="mCTA"+STRZERO(X,2)
      aTR[X]:=&CCTA.
   NEXT
ENDIF   

IF nTIPO<>7.AND.nTIPO<>8
    if !MDG( 'Voce tem certeza' )
       retu .F.
    endif
ENDIF    
CX  := HX := VX:= array( 24 )
LF := chr( 13 ) + chr( 10 )
XA  := XB := XC := XD := XE := XF := VALE := 0
cPT := "PT" + ANOMESW 

if nTIPO=2.OR.nTIPO=3.OR.nTIPO=5.OR.nTIPO=7.OR.nTIPO=8
  if ! NETUSE("FOPTOCON") 
     retu .F.
   endif
   if ! dbseek(nremp)
      dbgotop()
   endif
   IF nTIPO=2.OR.nTIPO=7
      cARQUIVO := PADR(alltrim( CAMINEX ) + "H" +cMIG+ ANOMESW +".TXT",80)
      eFORMULA := alltrim( EXPORTA )
   ENDIF
   IF nTIPO=3.OR.nTIPO=8
      cARQUIVO  := PADR(alltrim( CAMINEX )+ "R" +cMIG+ ANOMESW +".TXT",80)
      eFORMULA  := alltrim( CAMINER )
      mCTA01 :=  CONTAREF 
   ENDIF
   IF nTIPO=5
      cARQUIVO := PADR(alltrim( CAMINEX ) + "B" +cMIG+ ANOMESW +".TXT",80)
      eFORMULA := alltrim( EXPORTA )      
      mCTA01 :=  0
   ENDIF   
   dbcloseall()
   if empty(eFORMULA)
      ALERTX("Formula Nao Preenchida")
      retu .f.
   ENDIF
  // cCAMUSO:=SPACE(80)
  // cARQUSO:=SPACE(80)
   cARQUIVO=WIN_GETSAVEFILENAME(        , "Exportar", HB_CWD(),"txt"   , "*.txt" , 1            ,               , cARQUIVO)
   //@ 23,00 SAY "confirme o caminho"
   //@ 24,00 get cARQUIVO
   //IF ! READCUR()
   //   RETU .F.
   //ENDIF
   //cARQUIVO:=ALLTRIM(CARQUIVO)
   IF nTIPO<>7.AND.nTIPO<>8
     nHANDLE := fcreate( cARQUIVO )
     IF FERROR()#0
        ALERTX("Erro na Criacao do Arquivo")
        RETU
     ENDIF
   ENDIF  
ENDIF

IF nTIPO=7.OR.nTIPO=8
   FOPTO13(cARQUIVO)
   RETURN .T.
ENDIF


if nTIPO=3.OR.nTIPO=4
   dINI := zdataini
   dFIM := zdatafim
   MDS( 'Digite o Periodo ' )
   @ 24, 40 get dINI
   @ 24, 50 get dFIM
   if !READCUR()
     retu .F.
   endif
endif

if nTIPO=5.or.nTIPO=6
   nANO := year( date())
   nMES := month(date())
   @ 24, 00
   @ 24, 00 say "ANO"
   @ 24, 20 say "Mes"   
   @ 24, 10 get nANO
   @ 24, 30 get nMES
   if ! READCUR()
      retu .F.
   endif
endif

if nTIPO=3.OR.nTIPO=4.or.nTIPO=5.OR.nTIPO=6   
   @ 24,00 
   @  9, 7 SAY "Conta   "
   @ 24,40 GET mCTA01  valiD mCTA01 > 0
   if !READCUR()
     retu .F.
   endif
endif


if ! netuse(pes) 
   retu
endif
INITVARS()
CLRVARS()
FILTRO := "EMPTY(DEMITIDO)"
FI     := trim( FILTRO )
FILTRO := FILTRO( FI )
set filter to &FILTRO

if ! netuse(fol) 
   dbcloseall()
   retu
endif
if ! netuse("contas") 
  dbcloseall()
   retu
endif
if nTIPO=1.OR.nTIPO=2
   if ! netuse(cPT) 
      dbcloseall()
      retu
   endif
endif
if nTIPO=3.OR.nTIPO=4
   if ! NETUSE(cPA) 
      dbcloseall()
      retu
   endif
endif 
if nTIPO=5.OR.nTIPO=6
   carq:=IF(lSECBCO,"BCOBAK","BCOHRS")
   if ! netuse(CArq) 
      dbcloseall()
      retu .F.
   endif
endif      



nFIM=24
IF nTIPO=3.OR.nTIPO=4.or.nTIPO=5.OR.nTIPO=6
   nFIM=1
ENDIF
dbselectar(pes)
dbgotop()
while !eof()
   PETELA( 8 )
   CTR := NUMERO
   cNUM:=STRZERO(NUMERO,8)
   cNU6:=STRZERO(NUMERO,6)
   TSA := TIPO
   EQUVARS()
   IF nTIPO=1.OR.nTIPO=2
      //Analise feita com arquivo pes pois checar tipo horista/mensalista entre outros na macro
      afill( CX, 0 )
      for X := 1 to 24
         cVAR := aCODCTA[ X ]
         if ! empty( cVAR )
            CX[ X ] = &CVAR.
         endif
      next X
   ENDIF
   IF nTIPO=3.OR.nTIPO=4.OR.nTIPO=5.OR.nTIPO=6
      CX[1]:=mCTA01
      aTR:={"S"}
   ENDIF
   
   lGRAVA:=.F.
      
   IF nTIPO=1.OR.nTIPO=2   
       dbselectar( cPT )
       dbgotop()
       if dbseek( CTR )
          HX := { CTA01, CTA02, CTA03, CTA04, CTA05, CTA06, CTA07, CTA08, ;
                  CTA09, CTA10, CTA11, CTA12, CTA13, CTA14, CTA15, CTA16, ;
                  CTA17, CTA18, CTA19, CTA20, CTA21, CTA22, CTA23, CTA24 }
          VX := { VAL01, VAL02, VAL03, VAL04, VAL05, VAL06, VAL07, VAL08, ;
                  VAL09, VAL10, VAL11, VAL12, VAL13, VAL14, VAL15, VAL16, ;
                  VAL17, VAL18, VAL19, VAL20, VAL21, VAL22, VAL23, VAL24 }
          nBANCO:=BCOHRS
          lGRAVA:=.T.
       ENDIF   
   ENDIF
   
   IF nTIPO=3.OR.nTIPO=4
      HX      := { 0 }
      dbselectar( cPA )
      dbgotop()
      dbseek( str( mNUMERO, 8 ) )
      while NUMERO = mNUMERO .and. !eof()   
         mDATA:=DATA      
         if data >= Dini .and. Data <= Dfim
            HX[ 1 ] ++
            WHILE NUMERO = mNUMERO.AND. mDATA=DATA.AND.! EOF()  //Somar uma vez no dia
               dbskip()
            enddo
         ELSE
            dbskip()    
         endif   
      enddo
      IF HX[ 1 ]>0
         lGRAVA:=.T.
      ENDIF
   ENDIF
   IF nTIPO=5.OR.nTIPO=6  
      dbselectar(cARQ)    
      HX      := {PegSaldoBco(mNUMERO,nANO,nMES,.F.)}
      dbselectar(pes)
      IF HX[ 1 ]>0
         lGRAVA:=.T. 
      ENDIF
   ENDIF   
   IF lGRAVA   
      for X := 1 to nFIM
         if HX[ X ] > 0 .and. CX[ X ] # 0 .and. aTR[ X ] # "N"
            cCTA:=STRZERO(CX[X],3)
            cHOR :=GRVVAL(HX[X],6,2)
            cVAL:=GRVVAL(VX[X],12,2)
            IF nTIPO=2.OR.nTIPO=3.OR.nTIPO=5
                fwrite( nHANDLE, &eFORMULA )
            ENDIF
            IF nTIPO=1.OR.nTIPO=4.OR.nTIPO=6
               netreclock()
               GRAVA2( CX[ X ] )
               &FOL.->HORAS := HX[ X ]
               dbunlock()
            ENDIF
         endif
      next X
   endif
   
   dbselectar(pes)
   dbskip()
enddo
dbcloseall()

IF nTIPO=2.OR.nTIPO=3
   fwrite( nHANDLE, chr( 26 ) )
   fclose( nHANDLE )
   if MDG( "Deseja Imprimir o arquivo Gerado" )
      IMPARQ( cARQUIVO )
   endif
ENDIF
retu

*+ EOF: FOPTO_25.PRG
