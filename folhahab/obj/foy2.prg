*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\OBJ\FOY2.PRG
*+
*+    Functions: Function iFOY2()
*+               Function tFOY2()
*+               Function gFOY2()
*+               Function INDEXT()
*+
*+    Reformatted by Click! 2.03 on Jan-19-2004 at  5:30 pm
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн

#INCLUDE "INKEY.CH"
#INCLUDE "BOX.CH"

FUNCTION FOY2()
CABEX( 'Configurar Ordenacao' )
para CCWORK, CCNTX, CCPERG
INFOR( CCNTX, "DBF+NTX+STR(SEQ,3)", CCNTX, .T. )
if valtype( CCPERG ) # "C"
   CCPERG := "S"
endif

if CCWORK = 1     //Edio
   PADRAO( CCNTX, CCNTX, "' '+mDBF+' '+mDESCRICAO", "mDBF+mNTX+STR(mSEQ,3)", "Configurar Indexacao", "Arquivo Nome", ;
           { || iFOY2() }, { || tFOY2() }, { || gFOY2() }, { || FO_FOR( "GRUPO='SISTEM'" ) } )
endif

if CCWORK = 0       //Indexar
   do case
   case CCPERG = "S"
      INDEXT(,, MDG( 'Somente Arquivos da Empresa' ) )
   case CCPERG = "N"
      INDEXT(,, .F. )
   case CCPERG = "E"
      INDEXT(,, .T. )
   endcase
endif
RETURN

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function iFOY2()
*+
*+    Called from ( foy2.prg     )   1 -
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function iFOY2

mDBF := space( 8 )
mNTX := space( 8 )
mSEQ := 0
MDS( "Digite Arquivo/Indice" )
@ 24, 40 get mDBF
@ 24, 50 get mNTX when ALLTRUE( if( empty( mNTX ), mNTX := mDBF, ) )
@ 24, 60 get mSEQ
READCUR()
mCHAVE := mDBF + mNTX + str( mSEQ, 3 )
retu

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function tFOY2()
*+
*+    Called from ( foy2.prg     )   1 -
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function tFOY2()
HB_dispbox( 9, 0, 23, 79,B_DOUBLE+" ")
@ 11,  2 say "Descricao Do Arquivo :"
@ 14,  2 say "Nome do Arquivo de Dados  :"
@ 16,  2 say "Seq:"
@ 16, 20 say "Nome do Arquivo de Indice :"
@ 17,  2 say "Nome alias(TAG):"
@ 18,  2 say "Chave Para Criacao do Arquivo de Indice :"
@ 21,  2 say "Este arquivo e Indidual por empresa (S)im(N)ao(I)ni:"
retu

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function gFOY2()
*+
*+    Called from ( foy2.prg     )   1 -
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function gFOY2()

@ 12,  2 get mDESCRICAO
@ 14, 31 get mDBF
@ 16, 10 get mSEQ       valid mSEQ > 0
@ 16, 51 get mNTX
@ 17, 20 get mTAG
@ 19,  2 get mCAMPO
@ 21, 54 get mPAD       valid mPAD $ " SNIA"
READCUR()
retu

*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
*+    Function INDEXT()
*+
*+    Called from ( foy2.prg     )   3 -
*+
*+нннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннннн
*+
function INDEXT( nINI, nFIM, xEMP )
if ! netuse(ccNTX) 
   retu
endif
dbgotop()
while ! eof()
   cCAM   := ""
   USODBF := ALLTRIM(DBF)
   aCHAVE:={}
   aINDICE:={}
   aTAG:={}
   while USODBF = ALLTRIM(DBF) .and. !eof()
      USONTX := ALLTRIM(NTX)
      USOCAM := ALLTRIM(CAMPO)
      USOTAG := ALLTRIM(TAG)
      if len( alltrim( USODBF ) ) = 3 .and. USODBF = "FOL"
         USODBF := FOL
         USONTX := FOL
      endif
      if len( alltrim( USODBF ) ) = 3 .and. USODBF = "SEM"
         USODBF := 'SS' + ARQMES
         USONTX := 'SS' + ARQMES
      endif
      if len( alltrim( USODBF ) ) = 3 .and. USODBF = "RPA"
         USODBF := 'RP' + ARQMES
         USONTX := 'RP' + ARQMES
      endif
      if len( alltrim( USODBF ) ) = 3 .and. USODBF = "RPL"
         USODBF := 'RL' + ARQMES
         USONTX := 'RL' + ARQMES
      endif
      //Definies do RPA
      if CCNTX = "RPANTX"
         if USODBF = "RPA08"
            USODBF := ARQMES
            USONTX := ARQMES 
         endif
      endif
      //Definies do Fiscal
      if CCNTX = "FISCANTX"
         do case
         case USODBF = "ENT"
            USODBF := ENT
            USONTX := ENT
         case USODBF = "SAI"
            USODBF := SAI
            USONTX := SAI
         case USODBF = "SER"
            USODBF := SER
            USONTX := SER
         endcase
      endif

      //Difinioes do Ponto
      if CCNTX = "FOPTONTX"
         cMESANO := ANOWORK + strzero( mestrab, 2 )
      endif
      if USODBF = "FO_PON"
         USODBF := "PN" + cMESANO
         USONTX := "PN" + cMESANO
         USOTAG := "PN" + cMESANO
      endif
      if USODBF = "FO_POT"
         USODBF := "PT" + cMESANO
         USONTX := "PT" + cMESANO
         USOTAG := "PT" + cMESANO         
      endif
      if USODBF = "FO_POS"
         USODBF := "PS" + cMESANO
         USONTX := "PS" + cMESANO
         USOTAG := "PS" + cMESANO         
      endif
      if USODBF = "FOPTOREV"
         USODBF := "PE" + cMESANO
         USONTX := "PE" + cMESANO
         USOTAG := "PE" + cMESANO                  
      endif
      if USODBF = "FO_POCO"
         USODBF := "PO" + cMESANO
         USONTX := "PO" + cMESANO
         USOTAG := "PO" + cMESANO                  
      endif
      if USODBF = "FO_PMAN"
         USODBF := "PM" + cMESANO
         USONTX := "PM" + cMESANO
         USOTAG := "PM" + cMESANO                  
      endif
      if USODBF = "FO_PHOR"
         USODBF := "PH" + cMESANO
         USONTX := "PH" + cMESANO
         USOTAG := "PH" + cMESANO                  
      endif
      if USODBF = "BCOREQ"
         USODBF := "BH" + cMESANO
         USONTX := "BH" + cMESANO
         USOTAG := "BH" + cMESANO                  
      endif
      if USODBF = "BCRBAK"
         USODBF := "BK" + cMESANO
         USONTX := "BK" + cMESANO
         USOTAG := "BK" + cMESANO                 
      endif
      if USODBF = "FO_PDES"
         USODBF := "PX" + cMESANO
         USONTX := "PX" + cMESANO
         USOTAG := "PX" + cMESANO                  
      endif
      if USODBF = "FO_DIO"
         USODBF := "PD" + cMESANO
         USONTX := "PD" + cMESANO
         USOTAG := "PD" + cMESANO                           
      endif
      if USODBF = "FO_ALM"
         USODBF := "PA" + cMESANO
         if USOCAM = "STR(NUMERO,8)+DTOS(DATA)+STRZERO(HOR,5,2)"
            USONTX := "PA" + cMESANO
         endif
         USOTAG := "PA" + cMESANO                           
      endif
      if USODBF = "FO_POR"
         USODBF := "PP" + cMESANO
         if USOCAM = "STR(NUMERO,8)+DTOS(DATA)+STRZERO(HOR,5,2)"
            USONTX := "PP" + cMESANO
         endif
         USOTAG := "PP" + cMESANO                           
      endif
      if USODBF = "PES"
         USODBF := PES
      endif
      
      //CAMINHO
      cCAM:=""
      IF PAD='S'
         cCAM:=ZDIRE
      ENDIF
      IF PAD='I'
         cCAM:=PEGCAMINI(USODBF)
      ENDIF
      IF PAD='A'
         cCAM:=ZDIRN
      ENDIF
      IF PAD='E' //Tabelas esocial
         cCAM:=  HB_CWD() + "esocial_tab\"
      ENDIF
      IF PAD="S" .OR. PAD="I" .OR. PAD="A" .OR. PAD="E"
          USODBF := cCAM + USODBF
          USONTX := cCAM + USODBF  
      ENDIF
      if ! xEMP .or. PAD = 'S'
          AADD(achave,USOCAM)
          AADD(aindice,usontx)
          aadd(aTAG,usotag)
      endif
      dbselectar( CCNTX )
      dbskip()
   enddo
   IF LEN(aCHAVE)>0
      INFOR(USODBF,aCHAVE,aINDICE,,aTAG)
   ENDIF
   dbselectar( CCNTX )
enddo
dbclosearea()
retu .T.


FUNCTION PEGCAMINI(cARQ,cCAM)
IF VALTYPE(cCAM)#"C"
   cCAM:=ProfileString( "FOLHA.INI", cARQ+ ".DBF", "CAMINHO", ZDIRE )
ENDIF
CCAM:=StrTran(CCAM,"[AA]",Right(StrZero(ANOUSO,4),2))
CCAM:=StrTran(CCAM,"[AAAA]",StrZero(ANOUSO,4))
CCAM:=StrTran(CCAM,"[MM]",StrZero(MESTRAB,2))
CCAM:=StrTran(CCAM,"[ZZZ]",StrZero(NREMP,3))	
CCAM:=StrTran(CCAM,"[ZZ]",StrZero(NREMP,2))
CCAM:=StrTran(CCAM,"[Z]",StrZero(NREMP,1))        
CCAM:=StrTran(CCAM,"[III]",StrZero(ZCODMANA5,3))	
CCAM:=StrTran(CCAM,"[II]",StrZero(ZCODMANA5,2))
CCAM:=StrTran(CCAM,"[I]",StrZero(ZCODMANA5,1))        
RETU cCAM
*+ EOF: FOY2.PRG
