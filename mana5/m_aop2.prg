*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_aop2.prg
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

MDI(" Ý Saldo de Produ‡„o")
lMS01 := MDG("Importar Saldos Produtos")
lMS06 := MDG("Importar Saldos Produtos Processo")
lMS02 := MDG("Gravar Datas")
d01   := d02 := d03 := ZDATA
IF lMS02
   MDS("Digite as Datas")
   @ 24,20 get d01         
   @ 24,30 get d02         
   @ 24,40 get d03         
   READCUR()
ENDIF

MAOP2CAL(lMS01,lMS02,lMS06,"OP01","OP02",.T.)


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function mAOP2CAL()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC mAOP2CAL(lMS01,lMS02,lMS06,cARQ,cARQ2,lFILTRO)   //Estoque,Data,Est.pro,arq,arq2

MDS("Aguarde Atualizando")
IF !USEMULT({{cARQ,1,99},{caRQ2,1,99},{"MS01",1,1},{"MS06",1,1}})
   RETU .F.
ENDIF


FILTRO := ''
IF lFILTRO
   FILTRO := RFILORD(cARQ,.F.)
ENDIF


DBSELECTAR(cARQ)
IF !EMPTY(FILTRO)
   SET FILTER TO &FILTRO
ENDIF
dbgotop()
WHILE !EOF()
   @ 24,00 SAY CODIGO         
   mCODIGO    := CODIGO
   mOP        := OP
   mSAL       := 0
   mCODIGOINT := ""
   DBSELECTAR("MS01")
   DBGOTOP()
   IF DBSEEK(mCODIGO)
      mSAL       := ESTQSAL
      mCODIGOINT := CODIGOINT
   ENDIF
   DBSELECTAR(cARQ)
   netreclock()
   IF EMPTY(CODIGOINT)
      FIELD->CODIGOINT := mCODIGOINT
   ENDIF
   IF lMS01
      FIELD->QSAI := mSAL
      IF mSAL > 0
         FIELD->ATIVO := "S"
      ENDIF
   ENDIF
   IF lMS02
      FIELD->DATAA := d01
      FIELD->DATAS := d02
      FIELD->DATA2 := d03
   ENDIF
   FIELD->QINI := QATR+QSEM+QSE2
   IF QINI > 0
      FIELD->ATIVO := "S"
   ENDIF
   FIELD->QIN2 := QATR+QSEM
   FIELD->QSAL := IF(QINI > QSAI,QINI - QSAI,0)
   nBASE       := QSAI
   IF QATR > nBASE  //Atraso
      FIELD->QSA2 := QATR - nBASE
      nBASE       := 0
   ELSE
      FIELD->QSA2 := 0
      nBASE       -= QATR
   ENDIF
   IF QSEM > nBASE  //1a.Semana
      FIELD->QSAS := QSEM - nBASE
      nBASE       := 0
   ELSE
      FIELD->QSAS := 0
      nBASE       -= QSEM
   ENDIF
   IF QSE2 > nBASE  //2a.Semana
      FIELD->QSAA := QSE2 - nBASE
      nBASE       := 0
   ELSE
      FIELD->QSAA := 0
      nBASE       -= QSE2
   ENDIF
   DBUNLOCK()
   xQPINI := QSAL
   xQPINA := QSAA
   xQPINS := QSAS
   xQPIN2 := QSA2
   DBSELECTAR(caRQ2)
   DBGOTOP()
   DBSEEK(STR(mOP,8,2))
   WHILE mOP = OP .AND. !EOF()
      @ 24,30 SAY SEQ         
      @ 24,35 SAY SSQ         
      mSEQ := SEQ
      mSSQ := SSQ
      mSAL := 0
      DBSELECTAR("MS06")
      DBGOTOP()
      IF DBSEEK(PADR(mCODIGO,24)+STR(mSEQ,3)+STR(mSSQ,3))
         IF ESTQSAL > 0   //tirado caso com saldo deve ser ajustado manualmente PULREQ<>"S"
            mSAL := ESTQSAL
         ENDIF
      ENDIF
      DBSELECTAR(caRQ2)
      netreclock()
      IF lMS06
         FIELD->QPSAI := mSAL
      ENDIF
      FIELD->QPINI := xQPINI
      FIELD->QPINA := xQPINI
      FIELD->QPINS := xQPINS
      FIELD->QPIN2 := xQPIN2
      DBUNLOCK()
      DBSELECTAR(caRQ2)
      DBSKIP()
   ENDDO
   DBSELECTAR(caRQ)
   DBSKIP()
ENDDO
DBCLOSEALL()

//Consolida Resultado
MAOP03(.F.,cARQ,cARQ2)
