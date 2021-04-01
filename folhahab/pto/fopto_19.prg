*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    FOPTO_19.PRG
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн


function fopto_19
para lPER,cOPER,nTIPO,nEQUIP,cARQIMP

// cOPER
// A=OPTIMIZAR B=BAKCUP C=CONVERTER D=AFDT T=IMPORTAR R=REP
// cOPER='D' pega nEQUIP relogio
// cARQIMP  nome do arquivo txt
// lOPER perguntas 
// nTIPO  
// Exemplos
// FOPTO_19(.f.,"D",1,aAFD[Z])  gerar afd equipamento


CABE2( 'FOPTO_19 - Importando/Exportando ' )


IF VALTYPE(lPER)#"L"
   lPER=.T.
ENDIF
IF VALTYPE(cOPER)#"C"
   cOPER="T"
ENDIF
IF cOPER="R"
   ntipo=6
endif
IF VALTYPE(ntipo)#"N"
   nTIPO := PEGRELOGIO()
ENDIF

nMODELO:=0
if ! NETUSE("foptorel")
   retu .F.
ENDIF
dbgotop()
if ! dbseek(ntipo)
   dbcloseall()
   ALERTX("falta configuracao relogio "+str(ntipo))
   retu .f.
endif
cCAMINHO:=ALLTRIM(caminho)
Carq=alltrim(arquivo)
nMODELO:=MODELO
dbcloseall()



if ! NETUSE("relogios")
   dbcloseall()
   retu .F.
ENDIF
dbgotop()
if ! dbseek(nMODELO)
   dbcloseall()
   ALERTX("falta configuracao modelo "+str(nMODELO))
   retu .f.
endif
mNUMINI:=NUMINI
mNUMFIM:=NUMFIM
mDIAINI:=DIAINI
mDIAFIM:=DIAFIM
mMESINI:=MESINI
mMESFIM:=MESFIM
mANOINI:=ANOINI
mANOFIM:=ANOFIM
mHORINI:=HORINI
mHORFIM:=HORFIM
mMININI:=MININI
mMINFIM:=MINFIM
mRELINI:=NUMRELINI
mRELFIM:=NUMRELFIM
mPISINI:=NUMPISINI
mPISFIM:=NUMPISFIM
mEMPINI:=NUMEMPINI
mEMPFIM:=NUMEMPFIM
mSEGINI:=SEGINI
mSEGFIM:=SEGFIM
mAFDT  :=AFDT
dbcloseall()


nCASAS   :=mNUMFIM-mNUMINI+1
nCASREL  :=mRELFIM-mRELINI+1
nCASANO  :=mANOFIM-mANOINI+1
nCASAPIS :=mPISFIM-mPISINI+1
nCASAEMP :=mEMPFIM-mEMPINI+1

lTXT:=.T.
lTIPOS:=cOPER="B".OR.cOPER="C"
IF lTIPOS
   lTXT:=MDG("SIM=TXT NAO=IMPORTADO")
ENDIF
if cOPER="D"
   IF cOPER="D".AND.! lPER
      lORI:=.T.
   ELSE
      lORI:=MDG("SIM=IMPORTADOS PONTO NAO=IMPORTADOS REP")
   ENDIF   
   lTXT:=.F.
endif

IF (VALTYPE(cARQIMP)<>"C".OR.EMPTY(cARQIMP)).AND.lTXT.AND.cOPER<>"D"
   copio:=PADR(ccaminho+carq,80)
   MDS( "Confirme Arquivo" )
   @ 24, 20 get COPIO pict "@S40"
   if !READCUR()
      retu .F.
   endif   
   COPIO := alltrim( COPIO )
   if empty(cARQ)
      cFILETMP:=""
      cEXTTMP:=""
      hb_fNameSplit( copio,,@cFILETMP,@cEXTTMP)
      cARQ:=cFILETMP+cEXTTMP
      ALERTX(Carq)
   endif
   COPID := HB_CWD() +CARQ
   if ! HB_FILEEXISTS( COPIO )
      MDT( 'Nao encontrei o arquivo ' + COPIO )
      retu
   ELSE   
      FILECOPY(COPIO,COPID)
   endif
ELSE
   CARQ := cARQIMP
   COPIO:= CARQIMP
ENDIF

DCORTE := zdataini
DCORTF := zdatafim

IF cOPER="D".AND.! lPER
ELSE
   MDS( 'Digite o periodo ' )
   @ 24, 40 get DCORTE
   @ 24, 60 get DCORTF
   if !READCUR()
      retu .F.
   endif
ENDIF

if cOPER="D"
   IF VALTYPE(nEQUIP)#"N"
      nEQUIP:=pegequip("ATIVO<>'N' .AND. GRUPOREL="+STR(nTIPO))
   ENDIF
   cREP  :=OBTER( "FOPTOEQP", , nEQUIP, "REP" )
ENDIF


if cOPER="C".OR.(cOPER="B".AND. ! lTXT)
   cMASCARA:=ESCOLHEXI( "RELOGIOS", 0, "NOME+' '+EXEMPLO", "EXEMPLO")
endif


if (lTIPOS.AND.!  lTXT).OR.cOPER="T".OR.(cOPER="D".AND.lORI)
   cPD := PARQDIO( nTIPO )
   CHECKCRI( cPD, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
   if ! netuse(cPD)
      dbcloseall()
      return
   endif
endif

if (cOPER="D".AND.! lORI)
   cPD := "REP"+cREP
   if ! netuse(cPD)
      dbcloseall()
      return
   endif
endif

IF ! NETUSE(PES)
   DBCLOSEALL()
   RETUrn
ENDIF

if mAFDT="S"
  FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
  set filter to &FILTRO
  dbsetorder(4)
endif


if cOPER="R"
  dbsetorder(4) //pis
endif

IF ! NETUSE("FOPTOPIS")
   DBCLOSEALL()
   RETURN .T.
ENDIF


if cOPER="B"
   nHANGRV:=FCREATE("MV"+strzero( NREMP, 2 )+ANOMESW+".TXT")
endif
if cOPER="A"
   nHANGRV:=FCREATE("AP"+strzero( NREMP, 2 )+ANOMESW+".TXT")
endif
if cOPER="C"
   nHANGRV:=FCREATE("CV"+strzero( NREMP, 2 )+ANOMESW+".TXT")
endif

lREPTEM:=.F.
if cOPER="D"
   SET CENTURY ON
   nHANGRV:=FCREATE("AFD_"+cREP+"_"+ANOMESW+".TXT") // strzero( nEQUIP, 2 )
   FWRITE(nHANGRV,REPL("0",9))
   FWRITE(nHANGRV,"1")
   FWRITE(nHANGRV,IF(zPESSOA="J","1",""))
   FWRITE(nHANGRV,TIRAOUT(ZCGC))
   FWRITE(nHANGRV,REPL("0",12))
   FWRITE(nHANGRV,PADR(ZEMPRESA,150))
   FWRITE(nHANGRV,STRZERO(VAL(cREP),17,0))
   FWRITE(nHANGRV,STRTRAN(DTOC(DCORTE),"/",""))
   FWRITE(nHANGRV,STRTRAN(DTOC(DCORTF),"/",""))
   FWRITE(nHANGRV,STRTRAN(DTOC(DATE()),"/",""))
   FWRITE(nHANGRV,LEFT(STRTRAN(TIME(),":",""),4))
   FWRITE(nHANGRV,CHR(13)+CHR(10))
   //DCORTE .and. mDATA <= DCORTF
   nSEQ:=1
   nREG3:=0
   nREG5:=0
   cREPDBF:="REP"+cREP
   IF lORI  
      IF FILE(cREPDBF+".DBF")
         lREPTEM:=netuse(cREPDBF)
         IF lREPTEM
            dbsetorder(2) //Pis data hora
         ENDIF
      ENDIF   
   ENDIF   
endif

IF lTXT   
    nHANDLE := hb_fopen( cARQ )
    if nHANDLE <= 0
       ALERTX( "Nao Consegui abrir o Arquivo: " + cARQ )
       fclose(Nhangrv)
       dbcloseall()
       retu .F.
    endif
    LINHA1 := FREADLINE( nHANDLE ) //Linha01
    IF mAFDT="S".OR.cOPER="R"
       cREP:=SUBSTR(LINHA1,188,17)
       nRELOGIO:=OBTER( "FOPTOEQP",,cREP, "NUMERO", 2, , , , , "NC" )
       LINHA1 := FREADLINE( nHANDLE )  //linha02
       LINHA1 := FREADLINE( nHANDLE )  //linha03 primeira linha de dados
    ENDIF
    LINHA  := alltrim( LINHA1)    
    IF cOPER="R"
       cREPDBF:="REP"+cREP
       IF ! FILE(cREPDBF+".DBF")
          aFOLHA:={{"PIS","C",12,0},{"DATA","D",8,0},;
                  {"HORA","N",7,2},{"NUMERO","N",8,0},{"EMP","N",5,0}}   //Emp guarda o numero da empresa processada pelo ponto          
          DBCREATE(cREPDBF,aFOLHA)     
          INFOR(cREPDBF,{"STR(NUMERO,8) + dtos( data ) + str( HORA, 5, 2 )","pis + dtos( data ) + str( HORA, 5, 2 )"} ,{cREPDBF,cREPDBF},.F.,{"REP01","REP02"}, .T.)                    
       ENDIF
       if ! netuse(cREPDBF)
          dbcloseall()
          retu .f.
       endif
       dbsetorder(2) //pis data hora
    ENDIF    
ELSE
   LINHA :="_"
   LINHA1:="-"
   dbselectar(cPD)
   dbgotop()
ENDIF

@ 05,02 say "Numero   :"
@ 06,02 say "Data/hora:"
@ 07,02 say "Relogio  :"
@ 08,02 say "Periodo  :"+DTOC(DCORTE)+" - "+DTOC(DCORTF)
@ 09,02 SAY "Pis      :"
@ 10,02 SAY "Linha    :"
IF cOPER="D"
   @ 11,02 SAY "REP:"+cREP+" "+IF(lREPTEM,"X","")
ENDIF
 
nLINHA:=0
while .T.
  IF ! lTXT
     LINHA:=str( NUMero, 8 ) + dtos( data ) + str( HORA, 5, 2 )+RELOGIO
  ENDIF
  @ 23,00 say linha
  mEMPRESA:=NREMP
  mNUMERO :=0
  mPIS    :=""
  tREL := "0"
  tSEG := "00"
  if ! empty( LINHA )
     IF lTXT
         IF mAFDT<>"S".AND.cOPER<>"R"
             mNUMERO :=val(substr( linha, mnumINI, nCASAS ))
             IF mPISINI>0
                mPIS    :=STRZERO(val(substr( linha, mPISINI,nCASAPIS)),11)
                dbselectar(PES)
                dbsetorder(4)
                dbgotop()
                IF dbseek(mPIS) //transferencias readmissoes  
                   mNUMERO:=NUMERO    
                   while mPIS=PIS .AND. ! EOF()
                       IF NUMERO>mNUMERO
                          mNUMERO:=NUMERO
                       endif   
                       dbskip()
                   enddo
                ELSE
                   mNUMERO :=0                
                ENDIF
                dbsetorder(1)
             ELSE
                dbselectar(PES)
                dbsetorder(1)
                dbgotop()
                IF dbseek(mNUMERO)                   
                   mPIS:=PIS
                ENDIF
             ENDIF
         ENDIF
         IF mEMPINI>0
            mEMPRESA:=val(substr( linha, mEMPINI,nCASAEMP))
         ENDIF
         tDIA := substr( linha, mDIAINI, 2 )
         tMES := substr( linha, mMESINI, 2 )
         tANO := substr( linha, mANOINI, nCASANO )
         tHOR := substr( linha, mHORINI, 2 )
         tMIN := substr( linha, mMININI, 2 )
         IF mRELINI>0   //alguns Relogios e catracas que nao registram codigo relogio
            tREL := substr( linha, mRELINI, nCASREL)
         ENDIF
         IF mAFDT="S"
            tREL:=STRZERO(nRELOGIO,4)
         ENDIF
         IF mSEGINI>0      //alguns Relogios e catracas que nao registram segundos
            tSEG := substr( linha ,mSEGINI, 2)
         ENDIF
         mHORA := VAL(tHOR+"."+tMIN)
         mDATA := ctod( tDIA + "/" + tMES + "/" + tANO )
         IF cOPER='R'
           IF SUBSTR(LINHA,10,1)="3" //Registro tipo 3
               mPIS    :=STRZERO(val(substr( linha, mPISINI,nCASAPIS)),11)
               dbselectar(PES)
               dbgotop()
               dbseek(mPIS)
               while mPIS=PIS.AND. ! eof()
                  if EMPTY(DEMITIDO)
                     mNUMERO:=NUMERO
                  ELSE
                     mADMITIDO:=if(EMPTY(DATTRANSF),ADMITIDO,DATATRANSF)
                     IF mDATA>=mADMITIDO.AND.mDATA<=DEMITIDO
                        mNUMERO:=NUMERO 
                     ENDIF
                  ENDIF
                  dbskip()                  
               ENDdo
           ENDIF
         ENDIF
         BUSCA := str( mNUMero, 8 ) + dtos( Mdata ) + str( mHORA, 5, 2 )
         IF mAFDT<>"S".OR.mNUMERO>0
            @ 05,15 SAY mNUMERO
            @ 06,15 SAY tDIA+"/"+tMES+"/"+tANO+" - "+tHOR+":"+tMIN+":"+tSEG
            @ 07,15 SAY tREL
         ENDIF
     ELSE
        IF cOPER="D".AND.! lORI
           mPIS:=PIS
        ENDIF   
        mNUMERO:=NUMERO
        mDATA:=DATA
        mHORA:=HORA
        tREL :=ALLTRIM(RELOGIO)
        cHORA:=STRZERO(HORA,5,2)
        tHOR :=SUBSTR(cHORA,1,2)
        tMIN :=SUBSTR(cHORA,4,2)
        tDIA :=strzero(day(mDATA),2)
        tMES :=strzero(month(mDATA),2)
        tANO :=strzero(year(mDATA),4)
        tSEG :="00"
        @ 05,15 SAY mNUMERO
        @ 06,15 SAY DTOC(mDATA)+" - "+cHORA
        @ 07,15 SAY tREL
     ENDIF        
     IF cOPER="R" .AND. SUBSTR(LINHA,10,1)="3"
        BUSCA := PADR(mpis,12) + dtos( Mdata ) + str( mHORA, 5, 2 )
        dbselectar(cREPDBF)
        dbgotop()
        if ! dbseek( BUSCA )
           netrecapp()
           field->pis      := mPIS
           field->data     := mDATA
           field->hora     := mHORA
           field->sequencia:= SUBSTR(linha,1,9)
           field->numero   := mNUMERO           
           dbunlock()
        ELSE
           IF EMPTY(NUMERO).and.! empty(mNUMERO)
              netreclock()
              field->numero   := mNUMERO
              dbunlock()
           ENDIF           
        endif       
     endif
     if ! empty( mDATA ) .and. ! empty( mNUMero ) .and. !empty( mHORa ).AND.cOPER<>"R"
        if mDATA >= DCORTE .and. mDATA <= DCORTF
            if cOPER="T"
               dbselectar(cPD)
               dbgotop()
               if ! dbseek( BUSCA )
                  netrecapp()
                  field->NUMERO :=mNUMERO
                  FIELD->DATA   :=mDATA
                  FIELD->HORA   :=mHORA
                  FIELD->RELOGIO:=alltrim(tREL)
                  FIELD->TIPOR  :="O"
                  field->pis    := mPIS
                else
                  if empty(pis) .and. ! empty(mPIS)
                     netreclock()
                     field->pis    := mPIS
                  endif   
                endif
             endif
             //pega o pis caso for exportar competencias antes da portaria nao tinham pis
             IF EMPTY(mPIS).AND. ! EMPTY(PIS) //1o. pis da importacao
                mPIS:=PIS
             ENDIF
             IF EMPTY(mPIS) //2. pis conforme cadastro
                dbselectar(pes)
                dbgotop()
                if dbseek(mNUMERO)                   
                    mPIS:=PIS
                 ENDIF
             ENDIF
             if empty(mPIS) //3. pis historico
                dbselectar("FOPTOPIS")
                 dbgotop()
                 if dbseek(mNUMERO)
                    mPIS:=PIS
                  ENDIF
             endif
             if cOPER="A".OR.(cOPER="B".AND. lTXT)
                FWRITE(nHANGRV,LINHA+CHR(13)+CHR(10))
             endif
             IF cOPER="C".OR.(cOPER="B".AND. ! lTXT)
                cLINCNV:=cMASCARA
                 //Exemplo mascara "CCCCCCCCCCCCCCCddmmaaHHMMSSnnnnnRR"
                 //C-Cracha Numero do Funcionario
                 //R-Relogio
                 //P-Pis
                 //E-Empresa
                 cLINCNV:=STRTRAN(cLINCNV,"dd",strzero(day(mDATA),2))
                 cLINCNV:=STRTRAN(cLINCNV,"mm",strzero(month(mDATA),2))
                 cLINCNV:=STRTRAN(cLINCNV,"aaaa",strzero(year(mDATA),4))
                 cLINCNV:=STRTRAN(cLINCNV,"aa",RIGHT(strzero(year(mDATA),4),2))
                 cLINCNV:=STRTRAN(cLINCNV,"HH",tHOR)
                 cLINCNV:=STRTRAN(cLINCNV,"MM",tMIN)
                 cLINCNV:=STRTRAN(cLINCNV,"SS",tSEG)
                 cLINCNV:=STRTRAN(cLINCNV,"n","0")
                 nLENCCC:=NUMAT("C",cLINCNV)
                 cLINCNV:=STRTRAN(cLINCNV,REPL("C",nLENCCC),STRZERO(mNUMERO,nLENCCC))  //
                 nLENCCC:=NUMAT("P",cLINCNV)
                 IF VALTYPE(mPIS)="C"
                    MPIS:=VAL(mPIS)
                 ENDIF
                 cLINCNV:=STRTRAN(cLINCNV,REPL("P",nLENCCC),STRZERO(mPIS,nLENCCC))  //
                 nLENCCC:=NUMAT("E",cLINCNV)
                 cLINCNV:=STRTRAN(cLINCNV,REPL("E",nLENCCC),STRZERO(mEMPRESA,nLENCCC))  //
                 nLENCCC:=NUMAT("R",cLINCNV)
                 IF nLENCCC>0
                    cLINCNV:=STRTRAN(cLINCNV,REPL("R",nLENCCC),STRZERO(VAL(tREL),nLENCCC))
                 ENDIF
                 FWRITE(nHANGRV,cLINCNV+CHR(13)+CHR(10))
             ENDIF
             IF cOPER="D".and.nequip=val(trel)
                IF ! EMPTY(mPIS)
                   FWRITE(nHANGRV,strzero(Nseq,9,0))
                   FWRITE(nHANGRV,"3")
                   FWRITE(nHANGRV,tDIA+tMES+IF(LEN(tANO)=2,"20"+tANO,tano))
                   FWRITE(nHANGRV,tHOR+tMIN)
                   FWRITE(nHANGRV,STRZERO(VAL(mPIS),12))
                   FWRITE(nHANGRV,CHR(13)+CHR(10))
                   nSEQ++
                   nREG3++
                   IF lREPTEM
                       /*
                       BUSCA := PADR(mpis,12) + dtos( Mdata ) + str( mHORA, 5, 2 )
                       dbselectar(cREPDBF)
                       dbgotop()
                       if dbseek( BUSCA )
                          //IF (EMPTY((cREPDBF)->NUMERO).OR.EMPTY((cREPDBF)->EMP)) // mNUMERO>0
                             netreclock()
                             @ 22,00 SAY "GRV: "+BUSCA
                             (cREPDBF)->numero:=mNUMERO
                             (cREPDBF)->emp   :=mEMPRESA
                             dbunlocK()
                          //ENDIF   
                       endif                          
                       */
                   ENDIF                                   
                endif
             ENDIF
        endif
     endif
  endif
  IF ! lTXT
     DBSELECTAR(cPD)
     DBSKIP()
     IF EOF()
       LINHA = "__FINAL__"
     ENDIF
  ELSE
    LINHA := alltrim( FREADLINE( nHANDLE ) )
    nLINHA++
    @ 10,15  SAY nLINHA
  ENDIF
  IF LINHA = "__FINAL__"
     exit
  endif
enddo
IF lTXT
  fclose( nHANDLE )
ENDIF


if cOPER="D".and.nreg3>0
   dbselectar(pes)
   dbgotop()
   while ! eof()
      PETELA(12)
      if year(admitido)=anouso.and.month(admitido)=mestrab
         FWRITE(nHANGRV,strzero(Nseq,9,0))
         FWRITE(nHANGRV,"5")
         FWRITE(nHANGRV,dtos(admitido))
         FWRITE(nHANGRV,"0800")
         FWRITE(nHANGRV,"I")
         FWRITE(nHANGRV,STRZERO(VAL(PIS),12))
         FWRITE(nHANGRV,PADR(NOME,52))
         FWRITE(nHANGRV,CHR(13)+CHR(10))
         nSEQ++
         nREG5++
      endif
      if year(demitido)=anouso.and.month(demitido)=mestrab
         FWRITE(nHANGRV,strzero(Nseq,9,0))
         FWRITE(nHANGRV,"5")
         FWRITE(nHANGRV,dtos(demitido))
         FWRITE(nHANGRV,"1700")
         FWRITE(nHANGRV,"E")
         FWRITE(nHANGRV,STRZERO(VAL(PIS),12))
         FWRITE(nHANGRV,PADR(NOME,52))
         FWRITE(nHANGRV,CHR(13)+CHR(10))
         nSEQ++
         nREG5++
      endif
      dbskip()
   enddo
    FWRITE(nHANGRV,REPL("9",9))
    FWRITE(nHANGRV,STRZERO(0,9,0))
    FWRITE(nHANGRV,STRZERO(nREG3,9,0))
    FWRITE(nHANGRV,STRZERO(0,9,0))
    FWRITE(nHANGRV,STRZERO(nREG5,9,0))
    FWRITE(nHANGRV,"9")
    FWRITE(nHANGRV,chr(13)+chr(10))
endif

/* melhorias necessarias na pis para incluir os periodos admissao demissao e transferencias
IF lREPTEM
   @ 24,00 SAY "Checando "+cREPDBF
   dbselectar(pes)
   dbsetorder(4) //pis
   dbselectar(cREPDBF)
   dbsetorder(2)
   dbgotop()
   while ! eof()
       mPIS:=AllTrim(PIS)
       mNUMERO:=0
       @ 24,20 SAY mPIS+StrZero(RecNo(),8)
       dbselectar(pes)
       dbGoTop()
       if dbseek(mPIS)
          mNUMERO:=NUMERO
          @ 24,30 say nome
       endif
       dbselectar(cREPDBF)
       while mPIS=AllTrim(PIS).AND.! EOF()
          lTEM:=.F. 
          IF mNUMERO>0.AND.EMPTY(NUMERO).AND.DATA >= DCORTE .AND. DATA <= DCORTF
             BUSCA:=str( mNUMero, 8 ) + dtos( DATA) + str(  HORA,5, 2 )              
             dbselectar(cPD)
             dbgotop()
             if dbseek(BUSCA)
                lTEM:=.T.
             endif
          endif
          dbselectar(cREPDBF)
          IF lTEM
             @ 22,00 SAY "GRV: "+BUSCA
             NETRECLOCK()
             FIELD->NUMERO:=mNUMERO
             FIELD->EMP:=NREMP
             dbUnlock()
          ENDIF
          dbskip()          
       enddo
   enddo
ENDIF
*/

dbcloseall()


if cOPER<>"T".AND.cOPER<>"R"
   fclose(nHANGRV)
endif

if cOPER="A".or.lTIPOS
   RETUrn .T.
endif

if (nTIPO = 1 .or. nTIPO = 4 .or. nTIPO = 5).AND.cOPER<>"D"
   trocapro(cpd,dcorte,dcortf)
   IF lPER
      if MDG( "Deseja Transferir Dados Ponto do Mes" )
         FOPTO_12()
      endif
   ELSE
       FOPTO_12(DCORTE,DCORTF)
   ENDIF
endif
