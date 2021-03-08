*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_al3.prg
*+
*+
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2010, Jorge Cassiano
*+
*+
*+
*+    Documentado em 30-Ago-2011 as 10:55 am
*+
*+
*+
*+--------------------------------------------------------------------
*+

//  Fechamento do Contas a Pagas e Recebidas
//
//

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function m_al3()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function m_al3

PARA cARQREF,cSTRREF,cVARREF,cARQRE2,cSTRRE2,cVARASS,cARQRE3,cSTRRE3,cVARAS3
MDI(" Ý Fechamento Mensal ")
@ 22,00 say cARQREF         
lSEG := .F.
lTER := .F.
IF VALTYPE(cARQRE2) = "C" .AND. VALTYPE(cSTRRE2) = "C" .AND. VALTYPE(cVARASS) = "C"
   lSEG := .T.
ENDIF
IF VALTYPE(cARQRE3) = "C" .AND. VALTYPE(cSTRRE3) = "C" .AND. VALTYPE(cVARAS3) = "C"
   lTER := .T.
ENDIF
//IF VALTYPE(cREFER)="C"
//   cMESANO:=cSTRREF+cREFER
//ELSE
//   cMESANO:=cSTRREF+MESANO()
//ENDIF

aRETU   := PEGMES({""},.F.,{""})
cMES    := aRETU[3]
cANO    := aRETU[4]
cMESANO := cSTRREF+cANO+cMES
cDIRE   := ZDIRP+"E"+strzero(znumero,3)+STRZERO(aRETU[2],4)+"\"
if empty(Aretu[1]) .or. empty(Aretu[2])
   ALERTX("Ano e(ou) Mes NÆo Preenchido(s)")
   retu .f.
endif

CRIARVARS(cARQREF)
IF cARQREF = "MAIL"
   CHECKARQ(cARQREF,cMESANO,,.F.,cDIRE,aRETU[2],aRETU[1])
ELSE
   CHECKARQ(cARQREF,cMESANO,,,cDIRE,aRETU[2],aRETU[1])
ENDIF
IF lSEG
   cMESAN2 := cSTRRE2+cANO+cMES
   CRIARVARS(cARQRE2)
   CHECKARQ(cARQRE2,cMESAN2,,,cDIRE,aRETU[2],aRETU[1])
ENDIF
IF lTER
   cMESAN3 := cSTRRE3+cANO+cMES
   CRIARVARS(cARQRE3)
   CHECKARQ(cARQRE3,cMESAN3,,,cDIRE,aRETU[2],aRETU[1])
ENDIF
IF !MDG("Iniciar Fechamento"+STR(aRETU[1])+"/"+STR(aRETU[2]))
   RETU .F.
ENDIF
IF cARQREF = "MAIL"
   IF !USEREDE(cARQREF,1,0)   //
      RETU .F.
   ENDIF
   IF !USEREDE(cMESANO,1,0)
      DBCLOSEALL()
      RETU .F.
   ENDIF
ELSE
   IF !USEREDE(cARQREF,1,99)  //
      RETU .F.
   ENDIF
   IF !USEREDE(cMESANO,1,99)
      DBCLOSEALL()
      RETU .F.
   ENDIF
ENDIF
IF lSEG
   IF !USEREDE(cARQRE2,1,99)
      DBCLOSEALL()
      RETU .F.
   ENDIF
   IF !USEREDE(cMESAN2,1,99)
      DBCLOSEALL()
      RETU .F.
   ENDIF
ENDIF
IF lTER
   IF !USEREDE(cARQRE3,1,99)
      DBCLOSEALL()
      RETU .F.
   ENDIF
   IF !USEREDE(cMESAN3,1,99)
      DBCLOSEALL()
      RETU .F.
   ENDIF
ENDIF
MDS()
@ 22,00 say cARQREF         
DBSELECTAR(cARQREF)
nLASTREC := lastrec()
nPOSREC  := 1
DBGOTOP()
WHILE !EOF()
   IF VALTYPE(cVARREF) # "C"
      dDATAREF := DATAPG
   ELSE
      dDATAREF := &cVARREF.
   ENDIF
   @ 24,00 SAY STR(RECNO(),8)         
   @ 24,09 SAY dDATAREF               
   IF STRZERO(MONTH(dDATAREF),2) = cMES .AND. ;
                   SUBSTR(STRZERO(YEAR(dDATAREF),4),3,2) = cANO
      EQUVARS()
      IF lSEG
         xCHAVE := &cVARASS.
         @ 24,18 SAY xCHAVE         
      ENDIF
      IF lTER
         xCHAV3 := &cVARAS3.
      ENDIF
      NOVOOPA(cMESANO,,,.F.)
      DELEREG(cARQREF,,,.F.)
      IF lSEG
         DBSELECTAR(cARQRE2)
         DBGOTOP()
         DBSEEK(xCHAVE)
         WHILE !EOF()
            EQUVARS()
            IF xCHAVE = &cVARASS.
               NOVOOPA(cMESAN2,,,.F.)
               DELEREG(cARQRE2,,,.F.)
            ELSE
               EXIT
            ENDIF
            DBSKIP()
         ENDDO
      ENDIF
      IF lTER
         DBSELECTAR(cARQRE3)
         DBGOTOP()
         DBSEEK(xCHAV3)
         WHILE !EOF()
            EQUVARS()
            IF xCHAV3 = &cVARAS3.
               NOVOOPA(cMESAN3,,,.F.)
               DELEREG(cARQRE3,,,.F.)
            ELSE
               EXIT
            ENDIF
            DBSKIP()
         ENDDO
      ENDIF
   ENDIF
   DBSELECTAR(cARQREF)
   DBSKIP()
   zei_fort(nLASTREC,.T.,nPOSREC)
   nPOSREC ++
ENDDO
DBCLOSEALL()
lFIXUSER := ZUSER <> "SOFTEC" .OR. MDG("Fixar"+CARQREF)
IF cARQREF = "MAIL"
   IF lFIXUSER
      FIXAR(cARQREF,.F.)
   ENDIF
ELSE
   IF lFIXUSER
      FIXAR(cARQREF)
   ENDIF
ENDIF
IF lSEG
   IF lFIXUSER
      FIXAR(cARQRE2)
   ENDIF
ENDIF
IF lTER
   IF cARQRE3 = "MM06"  //Itens de NF Canceladas
      IF !USEREDE(cARQRE3,1,99)
         DBCLOSEALL()
         RETU .F.
      ENDIF
      IF !USEREDE(cMESAN3,1,99)
         DBCLOSEALL()
         RETU .F.
      ENDIF
      DBSELECTAR(cARQRE3)
      WHILE !EOF()
         IF STRZERO(MONTH(dCANCEL),2) = cMES .AND. ;
                         SUBSTR(STRZERO(YEAR(dCANCEL),4),3,2) = cANO
            EQUVARS()
            NOVOOPA(cMESN3,,,.F.)
            DELEREG(cARQRE3,,,.F.)
         ENDIF
         DBSELECTAR(cARQRE3)
         DBSKIP()
      ENDDO
      DBCLOSEALL()
   ENDIF
   IF lFIXUSER
      FIXAR(cARQRE3)
   ENDIF
ENDIF
IF cARQREF = "MAIL"
   IF lFIXUSER
      MAILFIX()
   ENDIF
ENDIF
