("Acumular DIPI")

cAPUNEW:="S"
@ 24,00 SAY "Apurar CFO Novo"
@ 24,40 get cAPUNEW  PICT "!" VALID cAPUNEW $ "SN"
IF ! READCUR()
   RETU .F.
ENDIF


if MDG( "Acumular NF Entrada" )
   SOMAANO( "MK96", "K6" )
ENDIF
if MDG( "Acumular NF Saida" )
   SOMAANO( "MM96", "M6" )
ENDIF

if MDG( "Apurar NF Entrada" )
   MBDIP01( "MK96", "ADIPIE" )
ENDIF
if MDG( "Apurar NF Saida" )
   MBDIP01( "MM96", "ADIPIS" )
ENDIF


func MBDIP01(cARQ,cAPU)

MDS("Aguarde Apurando")
if ! usemult({{Carq,1,99},{cAPU,0,99},{"MD04",1, IF(cAPUNEW="S",2,3)},{"MB01",1,1},{"MA01",1,1},{"FI_NBM",1,1}})
   retu .f.
endif
dbselectar(CAPU)
ZAP
DBSETORDER(IF(cAPUNEW="N",1,2))

dbselectar(Carq)
MDS("Iniciando Apuracao")
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
IF cAPUNEW="N"
   ordDestroy("temp")
   ordcreate(,"temp","DCFONEW+STR(FORNECEDO,8)+DCLASSIPI")
   ordSetFocus("temp")
ELSE
   ordDestroy("temp")
   ordcreate(,"temp","DOPER+STR(FORNECEDO,8)+DCLASSIPI")
   ordSetFocus("temp")  
ENDIF
MDS()
dbgotop()
while ! eof()
  @ 24,00 SAY RECNO()
  mDOPER:=DOPER
  mDCFONEW:=DCFONEW
  mFICHA:=.F.
  dbselectar("md04")
  dbgotop()
  if dbseek(mDOPER)
     IF FICHA="S"
        mFICHA:=.T.
     ENDIF
  endif
  dbselectar(Carq)
  WHILE IF(cAPUNEW="N",mDOPER,mDCFONEW) =IF(cAPUNEW="N",DOPER,DCFONEW).AND.! EOF()
      mFORNECEDO:=FORNECEDO
      mDCLASSIPI:=DCLASSIPI
      mTIPOFOR  :=TIPOFOR
      mCGC:=SPACE(14)
      mCOGNOME:=""
      mDVALORNF:=0
      mDVALIPI:=0
      @ 24,00 SAY mFORNECEDO
      @ 24,10 SAY mDCLASSIPI
      WHILE mTIPOFOR=TIPOFOR.AND.IF(cAPUNEW="N",mDOPER,mDCFONEW) =IF(cAPUNEW="N",DOPER,DCFONEW).AND.mFORNECEDO=FORNECEDO.AND.mDCLASSIPI=DCLASSIPI.AND.! EOF()
         mDVALORNF+=DVALORNF
         mDVALIPI+=DVALIPI
         dbskip()
      ENDDO
      IF mDVALORNF>0
         dbselectar(IF(mTIPOFOR="C","MA01","MB01"))
         dbgotop()
         if dbseek(Mfornecedo)
            mCGC:=CGC
            mCOGNOME:=COGNOME
         endif
         IF EMPTY(mCGC)
            mCGC:=STR(mFORNECEDO,8)
         ENDIF
         mDESCRI:=""
         dbselectar("fi_nbm")
         dbgotop()
         IF dbseek(strtran(alltrim(mDCLASSIPI),".",""))
            mDESCRI:=DESCRI
         ENDIF
         dbselectar(Capu)
         netrecapp()
         replvars(.F.)
      endif
      dbselectar(Carq)
  ENDDO
  dbselectar(Carq)
enddo
dbcloseall()
