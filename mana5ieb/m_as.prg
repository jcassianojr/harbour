*:*****************************************************************************
*:
*:       M_AS.PRG: Cadastro de Produtos
*:      Linguagem: Clipper 5.x
*:        Sistema: Mana5 - ITAESBRA
*:      Copyright (c) 1994 by Disk Softwares S/C Ltda.
*:
*:*****************************************************************************


sMAS004:=SENHAX("MAS004")
sMAS005:=SENHAX("MAS005")


PADRAX(0,,0,{"MS01","MS02","MS01P"},"C½digo "+" Cliente"+"Compras"+" Nome"+spac(37)+"Unid"+spac(2)+"IPI",;
     "' '+mCODIGO+' '+STR(mFORNECEDO)+' '+mCOMPRA+' '+LEFT(mNOME,30)+' '+mUNID+' '+mCODIPI",;
     "IMS101","IMS101",,{|| MASDEL()},;
     {|| MASPOSREP()},,"MAS",,,,,,)



FUNC MASDEL()
IF MDG("Apagar Lista de Pre+o Tamb'm")
   PADDEL("MS02",mCODIGO,"CODIGO","mCODIGO")
ENDIF
IF MDG("Apagar Pre+o Planilha")
   PADDEL("MS01P",mCODIGO,"CODIGO","mCODIGO")
ENDIF
RETU .T.


FUNC MASPOSREP()
xCODIGO:=mCODIGO
xFORNECEDO:=mFORNECEDO
xCOMPRA:=mCOMPRA
IF sMAS004
   IF MDG("Alterar Lista de Pre+o")
      PADRAO(1,1,0,"MS02","  Data   Tipo    Valor Compra  Cliente     UN CF A",;
          "' '+DTOC(mDATA)+' '+mTIPO+' '+STR(mVALOR, 10, 4)+' '+mCOMPRA+' '+STR(mFORNECEDO)+' '+mUNIDE+' '+mCOIDE+' '+mATUAL",;
          "MAS2","IMS201","IMS201",;
           {|| mCODIGO:=xCODIGO } ,;
           {||PADARR("MS02",xCODIGO,"CODIGO","XCODIGO")})
   ENDIF
   IF MDG("Alterar Pre+o Planilha-Pre+os Diferenciados Cliente")
      PADRAO(1,1,0,"MS01P","Codigo Cliente",;
          "' '+mCODIGO+' '+STR(mFORNECEDO)+' '+STR(mPPLAN)",;
          "MASP",,,{|| mCODIGO:=xCODIGO },{||PADARR("MS01P",xCODIGO,"CODIGO","XCODIGO")})
   ENDIF
ENDIF
RETU .T.


FUNC MASCALINV
MDI("Calculando Valor Inventario")
nFATOR:=0.7000
nFATO2:=0.5600
MDS("Digite o Fator/Fator Processo")
@ 24,40 GET nFATOR
@ 24,60 GET nFATO2
IF ! READCUR()
   RETU .F.
ENDIF
IF ! USEMULT({{"MS01",1,1},{"MS02",1,1},{"MS06",1,1}})
   RETU .F.
ENDIF
DBSELECTAR("MS01")
DBGOTOP()
WHILE ! EOF()
    @ 24,00 SAY CODIGO
    cCODIGO:=CODIGO
    nPRECO:=0
    nPREC2:=0
    cUNID :=UNID
    cUNI2 :=UNID
    dDATA :=CTOD(SPACE(8))
    dDAT2 :=CTOD(SPACE(8))
    DBSELECTAR("MS02")
    DBGOTOP()
    DBSEEK(cCODIGO)
    WHILE cCODIGO=CODIGO.AND.! EOF()
      IF ATUAL#"N"
         IF EMPTY(COMPRA) //Preferencialmente nao exportado
            nPRECO:=VALOR
             IF ! EMPTY(UNIDE)
                cUNID:=UNIDE
             ENDIF
             dDATA:=DATA
         ELSE
            IF EMPTY(nPREC2)
               nPREC2:=VALOR
               IF ! EMPTY(UNIDE)
                  cUNI2:=UNIDE
               ENDIF
               dDAT2:=DATA
            ENDIF
         ENDIF
         IF ! EMPTY(nPRECO)
            EXIT
         ENDIF
      ENDIF
      DBSKIP()
    ENDDO
    IF EMPTY(nPRECO).AND.! EMPTY(nPREC2)
       nPRECO:=nPREC2
       cUNID :=cUNI2
       dDATA := dDAT2
    ENDIF
    if cUNID="CT"
       nPRECO:=round(nPRECO/100,4)
    ENDIF
    if cUNID="ML"
       nPRECO:=round(nPRECO/1000,4)
    ENDIF
    IF nPRECO>0
       DBSELECTAR("MS06")
       DBGOTOP()
       DBSEEK(cCODIGO)
       WHILE cCODIGO=CODIGO.AND.! EOF()
            netreclock()
            FIELD->ULTPRC:=nPRECO
            IF EMPTY(VALIII)
               FIELD->VALINV:=nPRECO*nFATO2
            ELSE
               FIELD->VALINV:=(nPRECO*VALIII/100)*nFATO2
            ENDIF
            DBUNLOCK()
            DBSKIP()
       ENDDO
       DBSELECTAR("MS01")
       netreclock()
       FIELD->ULTPRC:=nPRECO
       FIELD->VALINV:=nPRECO*nFATOR
       FIELD->ULTUND:=cUNID
       FIELD->ULTDATA:=dDATA
       DBUNLOCK()
    ENDIF
    DBSELECTAR("MS01")
    DBSKIP()
ENDDO
DBCLOSEALL()

FUNC MSTROCALIS()
MDI(" Trocar Lista Produto")
nORIGEM = 0
nDESTINO =0
@ 23,00 SAY "Origem Destino"
@ 24,00 GET nORIGEM PICT "99999"
@ 24,10 GET nDESTINO PICT "99999"
if ! readcur()
    RETU .F.
endif
if userede("MS02",0,99)
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   DBEVAL({|| netgrvcam("FORNECEDO",nDESTINO)},{|| FORNECEDO=nORIGEM }, {|| zei_fort(nLASTREC,,,1)})
   DBCLOSEAREA()
ENDIF


FUNC MSTROCACOD(nTIPO)
IF VALTYPE(nTIPO)#"N"
   nTIPO:=1
ENDIF
MDI(" Trocar Codigo Produto")
cORI:=SPACE(24)
cDES:=SPACE(24)
cTIPO:=SPACE(1)
@ 22,00 Say "Origem"
@ 23,00 say "Destino"
IF nTIPO=4
   @ 21,00 Say "Tipo"
   @ 21,10 get cTIPO
ENDIF
@ 22,10 get cORI
@ 23,10 get cDES
IF ! READCUR()
   RETU .F.
ENDIF
cORI:=ALLTRIM(cORI)
cDES:=ALLTRIM(cDES)
IF LEN(CORI)=0.OR.LEN(cDES)=0
   ALERTX("Necessario Preencher Origem/Destino")
   RETU .F.
ENDIF
IF ! MDG("Mudar "+cORI+" para "+CDES)
   RETU .F.
ENDIF
IF ! MDG("Realmente Mudar "+CORI+" para "+CDES)
   RETU .F.
ENDIF
IF nTIPO=1 //Fiscal
   IF ! USEMULT({{"MS01",0,99},{"MS02",1,99}})
      RETU .F.
   ENDIF
   mds("Trocando MS01")
   DBSELECTAR("MS01")
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   DBEVAL({|| netgrvcam("CODIGO",cDES)},{|| CODIGO=cORI}, {|| zei_fort(nLASTREC,,,1)})
   DBCLOSEAREA()
   mds("Trocando MS02")
   DBSELECTAR("MS02")
   DBSETORDER(3) //Produto
   MUDCODMS()
   DBCLOSEALL()
endif
if Ntipo=2 //pcp
   IF ! USEMULT({{"OSCRT",1,99},{"MS03",1,99},{"MS06",1,99}})
     RETU .F.
   ENDIF
   mds("Trocando OSCRT")
   DBSELECTAR("OSCRT")
   DBSETORDER(4)
   MUDCODMS()
   DBCLOSEAREA()
   DBSELECTAR("MS03")
   DBSETORDER(4)
   MUDCODMS()
   DBCLOSEAREA()
   DBSELECTAR("MS06")
   DBSETORDER(2)
   MUDCODMS()
   DBCLOSEALL()
ENDIF
IF nTIPO=3 //NFS
   cARQ="MM02"
   IF MDG("Mes Fechado")
      cARQ="M2"+MESANO()
   ENDIF
   IF USEREDE(caRQ,1,99)
      DBSETORDER(5) //Codigo
      MUDCODMS()
      DBCLOSEAREA()
   ENDIF
ENDIF
IF nTIPO=4 //NFE
   cARQ="MK02"
   IF MDG("Mes Fechado")
      cARQ="K2"+MESANO()
   ENDIF
   IF USEREDE(caRQ,1,99)
      DBSETORDER(5) //Tipo + Codigo
      MUDCODMS(cTIPO+cORI)
      DBCLOSEAREA()
   ENDIF
ENDIF
IF nTIPO=5 //mo02
   IF USEREDE("MO02",1,99)
      DBSETORDER(3) //Codigo
      MUDCODMS(cORI)
      DBCLOSEAREA()
   ENDIF
ENDIF

RETU

FUNC MUDCODMS(cBUSCA)
IF VALTYPE(cBUSCA)#"C"
   cBUSCA:=cORI
ENDIF
WHILE .T.
   dbgotop()
   dbseek(cBUSCA)
   IF cORI=ALLTRIM(CODIGO)
      netreclock()
      FIELD->CODIGO:=cDES
      DBUNLOCK()
   ELSE
      EXIT
   ENDIF
ENDDO
RETU
