*+--------------------------------------------------------------------
*+
*+    Programa  : mail.prg
*+    Function mail()
*+
*+    Sistema   : MANAEXO
*+    Linguagem : Harbour
*+    Copyright (c) 2021, Jorge Cassiano
*+
*+    Documentado em 23/03/2021
*+
*+--------------------------------------------------------------------
*+

function mail

PARA cARQ
LOCAL cRETU
IF VALTYPE(cARQ) # "C"
   cARQ := "MAIL"
ENDIF
cRETU := .F.
MDS("Checando Correspondencias")
WHILE !USEREDE(cARQ,1,0)
ENDDO
DBGOTOP()
WHILE !EOF()
   IF EMPTY(NUMERO)
      netreclock()
      FIELD->NUMERO := RECNO()
      DBUNLOCK()
   ENDIF
   IF ALLTRIM(DESTINO) = ALLTRIM(ZUSER)
      cRETU := .T.
      EXIT
   ENDIF
   @ 24,50 SAY RECNO()         
   DBSKIP()
ENDDO
INITVARS()
CLRVARS()
DBCLOSEAREA()
IF !cRETU
   ALERTX("Sem Novas Correspondencias")
   RETU .F.
ENDIF
WHILE .T.
   mNUMERO := ESCOLHEXI(cARQ,"","DTOC(DATA)+' '+ASSUNTO","RECNO()","DESTINO=ZUSER",0)
   IF VALTYPE(mNUMERO) = "N"
      cLIDO := "N"
      IF USEREDE(cARQ,1,0)
         //         SET FILTER TO NUMERO=mNUMERO
         //       DBGOTOP()
         DBGOTO(mNUMERO)
         EQUVARS()
         DBCLOSEAREA()
         IF ALLTRIM(zUSER) = ALLTRIM(mDESTINO)
            TELASAY("MAIL01")
            nLINHAS := MLCOUNT(mTEXTO)
            FOR X := 1 TO nLINHAS
               @  6+X,2 SAY MEMOLINE(mTEXTO,,X)         
            NEXT X
            EDITSAY("MAIL01")
            IF cLIDO = "S" .AND. cARQ == "MAIL"
               IF USEREDE("MAILPG",1,0)
                  NetRecApp()
                  REPLVARS(.F.)
                  FIELD->NUMERO := RECNO()
                  FIELD->DATAOK := DATE()
                  FIELD->HORAOK := TIME()
                  DBCLOSEAREA()
               ENDIF
               IF USEREDE("MAIL",1,0)
                  //                  SET FILTER TO NUMERO=mNUMERO
                  //                  DBGOTOP()
                  DBGOTO(mNUMERO)
                  netRecdel()
                  DBCLOSEAREA()
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   IF MDG("Encerrar Consulta")
      EXIT
   ENDIF
ENDDO
DBCLOSEALL()


*+--------------------------------------------------------------------
*+
*+    Function MAILDELUSR()
*+
*+--------------------------------------------------------------------
*+
FUNCtion MAILDELUSR

cUSER := SPACE(15)
MDS("Digite o Nome do Usuario")
@ 24,40 GET cUSER         
IF !READCUR()
   RETU .F.
ENDIF
cUSER := ALLTRIM(cUSER)
MAILDELETE("cUSER=ALLTRIM(DESTINO)")


*+--------------------------------------------------------------------
*+
*+    Function MAILDELCOD()
*+
*+--------------------------------------------------------------------
*+
FUNCtion MAILDELCOD

cUSER := SPACE(8)
MDS("Digite o Codigo")
@ 24,40 GET cUSER         
IF !READCUR()
   RETU .F.
ENDIF
cUSER := ALLTRIM(cUSER)
MAILDELETE("cUSER=ERRO")


*+--------------------------------------------------------------------
*+
*+    Function MAILDELDATA()
*+
*+--------------------------------------------------------------------
*+
FUNCtion MAILDELDATA

dDATA := ZDATA
MDS("Digite o Data Final")
@ 24,40 GET dDATA         
IF !READCUR()
   RETU .F.
ENDIF
MAILDELETE("DATA<=dDATA",dDATA)



*+--------------------------------------------------------------------
*+
*+    Function MAILDELETE()
*+
*+--------------------------------------------------------------------
*+
FUNCtion MAILDELETE(cCOND,dDATA)

MDS("")
IF VALTYPE(dDATA) # "D"
   dDATA := DATE()
ENDIF
IF !USEMULT({{"MAIL",1,0},{"MAILPG",1,0}})
   RETU .F.
ENDIF
INITVARS()
DBSELECTAR("MAIL")
DBGOTOP()
WHILE !EOF()
   @ 24,00 SAY RECNO()         
   IF &cCOND.
      EQUVARS()
      DBSELECTAR("MAILPG")
      netrecapp()
      REPLVARS(.F.)
      FIELD->NUMERO := RECNO()
      FIELD->DATAOK := dDATA
      FIELD->HORAOK := TIME()
      DBSELECTAR("MAIL")
      netrecdel()
   ENDIF
   DBSELECTAR("MAIL")
   DBSKIP()
ENDDO
DBCLOSEALL()
MAILFIX()
RETU .T.


*+--------------------------------------------------------------------
*+
*+    Function MAILFIX()
*+
*+--------------------------------------------------------------------
*+
FUNCTION MAILFIX() //''efetua limpeza da pack e recria para reduzir os memos ->memopack
IF ! USEREDE("MAIL",0,0,,,300)   //
   ALERTX("Arquivo MAIL em uso")
   RETU .F.
ENDIF
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
DBEVAL({|| netgrvcam("DATA",DATE())},{|| EMPTY(DATA)},{|| zei_fort(nLASTREC,,,1)})
zei_fort(nLASTREC,,,0)
DBEVAL({|| netrecdel()},{|| EMPTY(DESTINO)},{|| zei_fort(nLASTREC,,,1)})
zei_fort(nLASTREC,,,0)
DBEVAL({|| netrecdel()},{|| EMPTY(DE)},{|| zei_fort(nLASTREC,,,1)})
PACK
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
DBEVAL({|| netgrvcam("NUMERO",RECNO())},,{|| zei_fort(nLASTREC,,,1)})
DBCLOSEALL()
ALERTX(MEMOPACK(ZDIRP+"MAIL\MAIL",.t.,.t.,"DBFCDX"))


IF !USEREDE("MAILPG",0,0)   //
   ALERTX("Arquivo MAILPG em uso")
   RETU .F.
ENDIF
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
DBEVAL({|| netgrvcam("DATAOK",DATE())},{|| EMPTY(DATAOK)},{|| zei_fort(nLASTREC,,,1)})
zei_fort(nLASTREC,,,0)
DBEVAL({|| netrecdel()},{|| EMPTY(DESTINO)},{|| zei_fort(nLASTREC,,,1)})
zei_fort(nLASTREC,,,0)
DBEVAL({|| netrecdel()},{|| EMPTY(DE)},{|| zei_fort(nLASTREC,,,1)})
PACK
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
DBEVAL({|| netgrvcam("NUMERO",RECNO())},,{|| zei_fort(nLASTREC,,,1)})
DBCLOSEALL()
ALERTX(MEMOPACK(ZDIRP+"MAIL\MAILPG",.t.,.t.,"DBFCDX"))

