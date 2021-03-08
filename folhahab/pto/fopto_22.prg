*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_22.PRG
*+
*+    Functions: Function DIMP22()
*+               Function FOPTO22()
*+
*+    Reformatted by Click! 2.03 on Jun-25-2003 at  5:17 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

////#INCLUDE "COMANDO.CH"
#INCLUDE "INKEY.CH"

PEGPTOHOR( "XX", .T., .F. )   //Verifica indices

CABE2( 'FOPTO_22 - Alterar o Ponto Diario' )

aCODCTA := PEGCX()

cPN := "PN" + ANOMESW
cPT := "PT" + ANOMESW
cPD := "PD" + ANOMESW
cPP := "PP" + ANOMESW
cPA := "PA" + ANOMESW
cPS := "PS" + ANOMESW

//testa criacao portaria evitar erros
CHECKCRI( cPP, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
//testa criacao refeitorio evitar erros
CHECKCRI( cPA, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )


if ! NETUSE(cPN)
   retu
endif
FILTRO := ''
FI     := trim( FILTRO )
FILTRO := FILTRO( FI )
set filter to &FILTRO

if ! NETUSE(cPD)
   dbcloseall()
   retu
endif

if ! NETUSE(cPT)
   dbcloseall()
   retu
endif

if ! NETUSE(cPS)
   dbcloseall()
   retu
endif

if ! NETUSE(cPP)
   dbcloseall()
   retu
endif

if ! NETUSE(cPA)
   dbcloseall()
   retu
endif
IF ! netuse("fo_ptt")
   dbcloseall()
endif

//clear typeahead
hb_keyClear()
keyboard " "
//sele 1
dbselectar(cPN)
dbgotop()
@  3,  0 say "   Num   Dia    Cod SOD  Ent  Almoco    Saida Turno Ent  Almoco     Saida V F BC"
DECLARE CAMPOS[ 1 ]
CAMPOS[1] = 'STR(NUMERO,6)+" "+LEFT(CDIA(DATA),3)+","+LEFT(DTOC(DATA),5)+" "+COD+" "+SOD+" "+STR(ENT,5,2)+" "+STR(ALS,5,2)+" "+STR(ALE,5,2)+" "+STR(SAI,5,2)+" "+CODREV+" "+STR(ENTREV,  5, 2)+" "+STR(ALIREV,5, 2)+" "+STR(ALSREV,5,2)+" "+STR(SAIREV,5,2)+" "+VIRADA+" "+FOLSN+" "+BCOSN'
dbedit( 4, 0, 24, 79, CAMPOS, "DIMP22", .T., "", "", "", "", "" )
dbcloseall()
//clear typeahead
hb_keyClear()
keyboard " "
retu

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function DIMP22()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function DIMP22
parameters MODO
KEY := lastkey()
do case
case KEY = K_DEL
   if MDG( "Deseja realmente Apagar" )
      netrecdel()
      DBUNLOCK()
   endif
   dbskip()
   hb_keyPut(  K_PGUP )
   hb_keyPut( K_PGDN )
case KEY = 13
   cTELA := savescreen( 03, 0, 24, 79 )
   setcursor( 1 )
   mNUMERO := NUMERO
   mDIA    := DAY(DATA)
   mDATA   := DATA
   mHORARIO:= HORARIO
   COL     := 3
   CLSBOX( 03, 0, 24, 79 )
   @  3,  2 say "Num       Cod SOD  Ent  Almoco    Saida н Turno Ent    Almoco     Saida  V FO"
   @  4,  1 say mNUMERO                                                                                                                                           pict '99999999'
   @  4, 47 say ENTREV                                                                                                                                            pict '999.99'
   @  4, 54 say ALIREV                                                                                                                                            pict '999.99'
   @  4, 61 say ALSREV                                                                                                                                            pict '999.99'
   @  4, 68 say SAIREV                                                                                                                                            pict '999.99'
   @  4, 76 say virada
   @  4, 78 say folsn
   @ 05,  1 say "Extra SNVT"
   @ 05, 12 say "Almoco"
   @ 05, 20 say "Red.Jorn."
   @ 05, 30 say "Bco Horas"
   @ 06, 02 say "01-" + spac( 7 ) + "02-" + spac( 7 ) + "03-" + spac( 7 ) + "04-" + spac( 7 ) + "05-" + spac( 7 ) + "06-" + spac( 7 ) + "07-" + spac( 7 ) + "08-"
   for X := 1 to 8
      @ 06, ( X * 10 ) - 4 say aCODCTA[ X ] PICT "999"
   next X
   @ 07, 02 say "09-" + spac( 7 ) + "10-" + spac( 7 ) + "11-" + spac( 7 ) + "12-" + spac( 7 ) + "13-" + spac( 7 ) + "14-" + spac( 7 ) + "15-" + spac( 7 ) + "16-"
   for X := 1 to 8
      @ 07, ( X * 10 ) - 4 say aCODCTA[ X + 8 ]  PICT "999"
   next X
   @ 08, 00 say " н Totais do dia"+" н "+DTOC(mDATA)+" "+CDIA(mDATA)+" Horario:"+str(mHORARIO,8)
   for X := 1 to 8
       cVAR := "CTA" + strzero( X, 2 )
       @ 09, ( X * 10 ) - 7 say &cVAR.
   next X
   for X := 1 to 8
       cVAR := "CTA" + strzero( X + 8, 2 )
       @ 10, ( X * 10 ) - 7 say &cVAR.
   next X   
   @ 11, 00 say " н Totais das Contas"
   //Totais
   dbselectar( cPT )
   dbgotop()
   if !dbseek( mNUMERO )
      @ 11, 16 say 'Nao encontrado os Totais'
   else
      for X := 1 to 8
         cVAR := "CTA" + strzero( X, 2 )
         @ 12, ( X * 10 ) - 8 say &cVAR.
      next X
      for X := 1 to 8
         cVAR := "CTA" + strzero( X + 8, 2 )
         @ 13, ( X * 10 ) - 8 say &cVAR.
      next X
   endif
   //anual
   @ 14,00 SAY " н Totais Anuais"
   aTOTANO:=PEGTOTANO(mNUMERO,.F.)
   for X := 1 to 8
       @ 15, ( X * 10 ) - 8 say aTOTANO[X]     pict '9999.99'
   next X
   for X := 1 to 8
       @ 16, ( X * 10 ) - 8 say aTOTANO[X+8]   pict '9999.99'
   next X
   //Semana
   IF dow(mDATA)=1
      @ 17,00 SAY " н Totais da Semana"
      dbselectar( cPS )
      dbgotop()
      if dbseek( str( mNUMERO, 8 ) + dtos( mDATA ) )
         for X := 1 to 8
             cVAR := "CTA" + strzero( X, 2 )
             @ 18, ( X * 10 ) - 8 say &cVAR.
         next X
         for X := 1 to 8
            cVAR := "CTA" + strzero( X + 8, 2 )
            @ 19, ( X * 10 ) - 8 say &cVAR.
        next X
      Endif
   ENDIF


   nSALDO:=pegsaldobco(mNUMERO,nANOANT,nMESANT,.t.)
   @ 5,49 say  STRZERO(nMESANT,2) + "/" + strZERO( nANOANT,4)
   @ 5,57 say  nSALDO  pict "9999.99"



   verpassagens(mNUMERO,mDATA,.F.,.T.)
   dbselectar( cPN )
   netreclock()
   @  4, 13        SAY COD
   @  4, 16        SAY sod
   @  4, 19        SAY ENT
   @  4, 25        SAY ALS
   @  4, 31        SAY ALE
   @  4, 37        SAY SAI
   @  4, 45        SAY CODREV
   IF ZFECHADO="S"
      @  4, 76        SAY virada
      @  4, 78        SAY FOLSN
      @  5, 06        SAY EXTSN
      @  5, 18        SAY ALMOCO
      @  5, 28        SAY REDSN
      @  5, 39        SAY BCOSN
      @  5, 41        SAY BCOHRS       pict '9999.99'
      INKEY(0)
   ELSE
      @  4, 76        get virada       pict "!"                valid virada $ "SNV "
      @  4, 78        get FOLSN        pict "!"                valid FOLSN $ "SNVM "
      @  5, 06        get EXTSN        pict "!"                valid EXTSN $ "SNVTZA5 "
      @  5, 18        get ALMOCO       pict "!"                valid ALMOCO $ "ABCDESN "
      @  5, 28        get REDSN        pict "!"                valid REDSN $ "SN "
      @  5, 39        get BCOSN        pict "!"                valid BCOSN $ "SNF "
      @  5, 41        get BCOHRS       pict '9999.99'
      READCUR()
   ENDIF
   restscreen( 3, 0, 24, 79, cTELA )
   setcursor( 0 )
   dbunlock()
case KEY = 27
   return  0 
case KEY = 2        // BUSCA DADOS
   NUM := NUMERO
   DIX := DATA
   aSALVA:=SALVAA()
   @  3, 16 say "Digite o NЃmero do Funcionario :"
   @  5, 16 say "Digite a Data" + spac( 18 ) + ":"
   @ 03, 50 get NUM                                pict '######'
   @ 05, 50 get DIX
   READCUR()
   BUSCA := str( NUM, 8 ) + dtos( DIX )
   REG   := recno()
   dbgotop()
   if !dbseek( BUSCA )
      @ 02, 01 clea to 06, 78
      @ 04, 16 say 'Nao encontrado'
      inkey( 2 )
      dbgoto( REG )
   endif
   RESTAA(aSALVA)
   return  2 
endcase
return  1 

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function FOPTO22()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
func FOPTO22
if empty( CODREV )
   field->ENTREV := 0
   field->ALIREV := 0
   field->ALSREV := 0
   field->SAIREV := 0
else
   aRETU         := PEGPTOHOR( CODREV, .T., .T. )
   dbselectar(cPN)
   IF aRETU[6]
      field->ENTREV := aRETU[ 1 ]
      field->ALIREV := aRETU[ 2 ]
      field->ALSREV := aRETU[ 3 ]
      field->SAIREV := aRETU[ 4 ]
      field->VIRADA := aRETU[ 5 ]
      field->FOLSN  := aRETU[ 7 ]
      field->HORARIO:= Aretu[ 8 ]
   ENDif
endif
@  4, 47 say ENTREV pict '999.99'
@  4, 54 say ALIREV pict '999.99'
@  4, 61 say ALSREV pict '999.99'
@  4, 68 say SAIREV pict '999.99'
@  4, 76 say virada
@  4, 78 SAY folsn
return .T.


*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function PegTotAno()
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNC PegTotAno(nNUMUSO,lOpen)
aTOTANO:=ARRAY(24)
AFILL(aTOTANO,0)
IF lOPEN
   IF ! NETUSE("FO_PTT")
      RETU aTOTANO
   ENDIF
ENDIF
dbselectar( "FO_PTT" )
dbgotop()
dbseek( str( nNUMUSO, 8 ) + STR( ANOUSO,4 ) )
WHILE nNUMUSO=NUMERO.AND.MES<MESTRAB.AND.! EOF()
      FOR X= 1 TO 24
         cVAR := "CTA" + strzero( X, 2 )
          aTOTANO[X]+=&cVAR.
      NEXT X
    DBSKip()
ENDDO
IF lOPEN
   DBCLOSEAREA()
ENDIF
RETURN aTOTANO

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function verpassagens
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
FUNCTION VerPassagens(nNUMERO,dDATA,lOPEN,lMES,mPIS)
LOCAL X,LIN,COL,nPASSAGENS:=0
IF VALTYPE(mPIS)<>'C'
   OBTER(PES,,mNUMERO,"PIS")
ENDIF
IF lOPEN
   cPD := "PD" + ANOMESW
   cPP := "PP" + ANOMESW
   cPA := "PA" + ANOMESW
   if ! NETUSE(cPD)
     dbcloseall()
     retuRN 0
   endif
   if ! NETUSE(cPP)
      dbcloseall()
      retuRN 0
   endif
   if ! NETUSE(cPA)
      dbcloseall()
      retuRN 0
   endif
ENDIF
   LIN:=20
   for x:=1 to 3
      COL:=12
      DO CASE
         CASE x=1
           @ LIN, 01 say "Passagens :"
           dbselectar( cPD )
         CASE X=2
           @ LIN, 01 say "Portaria  :"
           dbselectar( cPp )
         CASE X=3
           @ LIN, 01 say "Refeitorio:"
           dbselectar( cPa )
      endCASE
      dbgotop()
      dbseek( str( nNUMERO, 8 ) + dtos( dDATA ) )
      IF NUMERO<>nNUMERO
         @ LIN, 12 say 'Sem Passagens'
      else
         while DATA = dDATA .and. NUMERO = nNUMERO .and. !eof()         
            @ LIN, COL say HORA
            @ lin,col()+1 say TIPOM+TIPOR+IF(X=1,RELOGIO,"")
            IF X<>1 .OR. EMPTY(mPIS) .OR. PIS=mPIS            
               IF X=1 .AND. TIPOM<>'D'
                  nPASSAGENS++
               ENDIF            
               col += IF(X=1,13,9)
               IF COL>75
                  LIN++
                  COL=1
               ENDIF
           ENDIF    
           dbskip()
         enddo
      endif
      LIN++
   next x
  IF lOPEN
      dbselectar( cPD )
      dbclosearea()
      dbselectar( cPp )
      dbclosearea()
      dbselectar( cPA )
      dbclosearea()
  ENDIF
  IF VALTYPE(lMES)="L".AND.lMES     
     if nPASSAGENS>1 .AND. INT(nPASSAGENS/2)<>nPASSAGENS/2
        ALERTX("Passagens impares descartar desnecessarias")
     ENDIF   
  ENDIF
  RETURN nPASSAGENS

  
FUNCTION temalmoco(nNUMERO,dDATA,lOPEN,aRELFXREF)
LOCAL nALMOCO,cALIAS,nFX,nFXFIM
cALIAS:=ALIAS()
nALMOCO:=0
nFXFIM:=LEN(aRELFXREF)         
IF lOPEN
   cPA := "PA" + ANOMESW
   if ! NETUSE(cPA)
      dbcloseall()
      retuRN 0
   endif
ENDIF
dbselectar( cPa )
dbgotop()
dbseek( str( nNUMERO, 8 ) + dtos( dDATA ) )
while DATA = dDATA .and. NUMERO = nNUMERO .and. !eof()      
      FOR nFX=1 TO nFXFIM
         IF TIPOM<>'S' .AND. ALLTRIM(RELOGIO)=ALLTRIM(aRELFXREF[nFX,1]) .AND. HORA>=aRELFXREF[nFX,2] .AND.  HORA<=aRELFXREF[nFX,3]
            nALMOCO++
         ENDIF   
      NEXT X   
      dbskip()
enddo
IF lOPEN
   dbselectar( cPA )
   dbclosearea()
ENDIF
IF ! EMPTY(cALIAS)
   DBSELECTAR(cALIAS)
ENDIF
RETURN nALMOCO
  
  
*+ EOF: FOPTO_22.PRG
