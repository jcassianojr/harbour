//Teclas Operacionais
//Checagem de Conta Contabil Marcada como comentario
//  implementar depois
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
// #iNCLUDE "MEMOGET.CH"
// #INCLUDE "FILEGET.CH"
#INCLUDE "BOX.CH"


FUNCTION EDITPEG(cCOD,cARQ)
LOCAL aRETU:={},cDBF:=ALIAS()
IF VALTYPE(cARQ)#"C"
   cARQ:="FOLGET"
ENDIF
IF ! netuse(cARQ) //AREDE(cARQ,cARQ,1)
   RETU aRETU
ENDIF
DBGOTOP()
DBSEEK(cCOD)
WHILE CODIGO=cCOD.AND.! EOF()
   AADD(aRETU,{TIP,LININI,COLINI,LINFIM,COLFIM,ALLTRIM(CAMPO),ALLTRIM(ESTILO),ALLTRIM(MENSAGEM),ALLTRIM(CONDICAO),ALLTRIM(PRECOND)})
   DBSKIP()
ENDDO
DBCLOSEAREA()
IF ! EMPTY(cDBF)
   DBSELECTAR(cDBF)
ENDIF
RETU aRETU


FUNCTION EDITSAY(aGET,nMES)
LOCAL i,cTIP,nLININI,nCOLINI,nLINFIM,nCOLFIM,cESTILO
PRIV  v_pic:="@S18"
PRIV  cDIZ:=""
IF VALTYPE(aGET)="C"    //Recebeu o Codigo do layout e nao a matriz
   aGET:=EDITPEG(aGET)  //Pega o relatorio
ENDIF
IF VALTYPE(nMES)#"N"
   SET MESS TO 24 CENTER
ELSE
   SET MESS TO &nMES
ENDIF
IF EMPTY(aGET)
   ALERTX("Layout de Edi‡„o Vazio")
   RETU .F.
ENDIF
@ 24,0 CLEA
FOR i=1 TO LEN(aGET)
    cTIP   :=aGET[I][1]
    nLININI:=aGET[I][2]
    nCOLINI:=aGET[I][3]
    nLINFIM:=aGET[I][4]
    nCOLFIM:=aGET[I][5]
    IF nLININI==97
       nLININI:=nROW
    ENDIF
    IF nLINFIM==97
       nLINFIM:=nROW
    ENDIF
    IF nLININI==98
       nLININI:=ROW()
    ENDIF
    IF nLINFIM==98
       nLINFIM:=ROW()
    ENDIF
    IF nLININI==99
       nLININI:=24
    ENDIF
    IF nLINFIM==99
       nLINFIM:=24
    ENDIF
    cDIZ      := aGET[I][6]
    cESTILO   := aGET[I][7]
    cMENSAGEM := aGET[I][8]
    cVALIDAR  := aGET[I][9]
    cPREVAL   := aGET[I][10]
    DO CASE
       CASE cTIP="T"
            TELASAY(ALLTRIM(cDIZ))
//       CASE cTIP="M"
//            @ nLININI,nCOLINI GET &cDIZ. MEMO COORD {9,2,16,77}
       CASE cTIP="R"
            READCUR()
//       CASE cTIP="2"
//            cDIZ2:=cDIZ
//            IF ZLANC=0
//               @ nLININI,nCOLINI GET &cDIZ. PICT ZPICCC VALID CHECKCC(cDIZ2)
//            ELSE
//               @ nLININI,nCOLINI GET &cDIZ.             VALID CHECKCC(cDIZ2)
//            ENDIF
       CASE cTIP="1"       
//            @ nLININI,nCOLINI GET mCGC PICT (v_pic) WHEN { |oGet| CNPJCPFPICT(oGet,mPESSOA,nLININI,nCOLINI) }  VALID CNPJCPFVAL(mCGC,mPESSOA)
            @ nLININI,nCOLINI GET &cDIZ. PICT (v_pic) WHEN { |oGet| CNPJCPFPICT(oGet,mPESSOA,nLININI,nCOLINI) }  VALID CNPJCPFVAL(&cDIZ.,mPESSOA)
       CASE cTIP="S" //Say Simples
            IF EMPTY(cESTILO) //Sem ou Com Picture
               @ nLININI,nCOLINI SAY &cDIZ.
            ELSE
               @ nLININI,nCOLINI SAY &cDIZ. PICT &cESTILO.
            ENDIF
       CASE EMPTY(cTIP) //GET
            IF EMPTY(cESTILO) //Sem Picture
               DO CASE
                  CASE EMPTY(cVALIDAR).AND.EMPTY(cPREVAL)
                       @ nLININI,nCOLINI GET &cDIZ.
                  CASE ! EMPTY(cVALIDAR).AND.! EMPTY(cPREVAL)
                       @ nLININI,nCOLINI GET &cDIZ. VALID &cVALIDAR WHEN &cPREVAL
                  CASE ! EMPTY(cVALIDAR).AND.EMPTY(cPREVAL)
                       @ nLININI,nCOLINI GET &cDIZ. VALID &cVALIDAR
                  CASE  EMPTY(cVALIDAR).AND.! EMPTY(cPREVAL)
                       @ nLININI,nCOLINI GET &cDIZ. WHEN &cPREVAL
               ENDCASE
            ELSE              //Com Picture
               DO CASE
                  CASE EMPTY(cVALIDAR).AND.EMPTY(cPREVAL)
                       @ nLININI,nCOLINI GET &cDIZ. PICT &cESTILO.
                  CASE ! EMPTY(cVALIDAR).AND.! EMPTY(cPREVAL)
                       @ nLININI,nCOLINI GET &cDIZ. VALID &cVALIDAR WHEN &cPREVAL PICT &cESTILO.
                  CASE ! EMPTY(cVALIDAR).AND.EMPTY(cPREVAL)
                       @ nLININI,nCOLINI GET &cDIZ. VALID &cVALIDAR PICT &cESTILO.
                  CASE  EMPTY(cVALIDAR).AND.! EMPTY(cPREVAL)
                       @ nLININI,nCOLINI GET &cDIZ. WHEN &cPREVAL PICT &cESTILO.
               ENDCASE
            ENDIF
       CASE cTIP="B" //Box
            DO CASE
               CASE LEFT(cDIZ,2)="SD".OR.cDIZ="B_SINGLE_DOUBLE"                           
                    HB_DISPBOX(nLININI,nCOLINI,nLINFIM,nCOLFIM,B_SINGLE_DOUBLE+" ")   
               CASE LEFT(cDIZ,2)="DS".OR.cDIZ="B_DOUBLE_SINGLE"                           
                    HB_DISPBOX(nLININI,nCOLINI,nLINFIM,nCOLFIM,B_DOUBLE_SINGLE+" ")                  
               CASE LEFT(cDIZ,1)="D".OR.cDIZ="B_DOUBLE"
                    HB_DISPBOX(nLININI,nCOLINI,nLINFIM,nCOLFIM,B_DOUBLE+" ")
               CASE LEFT(cDIZ,1)="S".OR.cDIZ="B_SINGLE"                           
                    HB_DISPBOX(nLININI,nCOLINI,nLINFIM,nCOLFIM,B_SINGLE+" ")                     
               OTHERWISE
                    HB_DISPBOX(nLININI,nCOLINI,nLINFIM,nCOLFIM,&cDIZ.)
            ENDCASE
       CASE cTIP="C" //cor
            SETCOLOR(&cDIZ)
    ENDCASE
NEXT i
READCUR()
RETU .T.

