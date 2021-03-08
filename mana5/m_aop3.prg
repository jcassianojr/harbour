*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_aop3.prg
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

MDI("Importar Saldo de Pedidos")
PARA cARQ,cARQ2,lCALC
IF VALTYPE(cARQ) # "C"
   cARQ  := "OP01"
   cARQ2 := "OP02"
ENDIF
IF VALTYPE(lCALC) # "L"
   lCALC := .T.
ENDIF
d01    := d02 := d03 := ZDATA
dG01   := dG02 := dG03 := ZDATA
dMEN   := ZDATA
nMES   := 22
nSEM   := 4
cESTRA := "T"
cTIPO  := "P"
cZERA  := "N"

while dow(dg01) # 2
   dg01 --
enddo
dg02 := dg01+7
dg03 := dg01+14
d01  := dG01+6
d02  := dG02+6
d03  := dG03+6

@ 10,00 say "Digite as Data Apura‡„o"         
@ 10,24 get d01                               
@ 10,34 get d02                               
@ 10,44 get d03                               

@ 12,00 SAY "Digite as Data Grava‡„o"         
@ 12,24 get dG01                              
@ 12,34 get dG02                              
@ 12,44 get dG03                              

@ 14,00 SAY "Mensal"                    
@ 14,20 GET dMEN                        
@ 14,30 get nMES     PICT "9999"        
@ 14,40 get nSEM     PICT "9999"        

@ 16,00 SAY "Gravar T-Tres Semanas 1-Primeira 2-Segunda 3-Terceira"                 
@ 16,55 GET cESTRA                                                  PICT "!"        

@ 18,00 SAY "(P)edidos Prg(S)emanal Prg(D)iaria"                        
@ 19,00 SAY "Electrolux->D(E)lfor (O)rders (I)ntegrada"                 
@ 18,40 GET cTIPO                                       PICT "!"        

@ 20,00 SAY "Zerar Saldos (S/N)"                                   
@ 20,20 GET cZERA                PICT "!" VALID cZERA $ "SN"       
IF !READCUR()
   retu .f.
endif

IF cZERA = "S"
   IF !MDG("Importar Zerando Saldos")
      RETU
   ENDIF
ENDIF


//Caqop  Codigo Produto
cARQOP  := "MO02"
eCODIGO := "CODIGO"
DO CASE
   CASE cTIPO = "P"
      if !usemult({{cARQOP,1,3},{cARQ,1,99},{cARQ2,1,99}})
         retu .f.
      endif
   CASE cTIPO = "S"
      eCODIGO := "PRODUTO"
      cARQOP  := "OSPRG"
      if !usemult({{cARQOP,1,2},{cARQ,1,99},{cARQ2,1,99}})
         retu .f.
      endif
   CASE cTIPO = "D"
      cARQOP  := "OSPR2"
      eCODIGO := "PRODUTO"
      if !usemult({{cARQOP,1,2},{cARQ,1,99},{cARQ2,1,99}})
         retu .f.
      endif
   CASE cTIPO = "E"
      cARQOP  := "OSPRE"
      eCODIGO := "PRODUTO"
      if !usemult({{cARQOP,1,2},{cARQ,1,99},{cARQ2,1,99}})
         retu .f.
      endif
   CASE cTIPO = "O"
      cARQOP  := "OSPR3"
      eCODIGO := "PRODUTO"
      if !usemult({{cARQOP,1,2},{cARQ,1,99},{cARQ2,1,99}})
         retu .f.
      endif
   CASE cTIPO = "I"
      cARQOP  := "OSPRS"
      eCODIGO := "PRODUTO"
      if !usemult({{cARQOP,1,2},{cARQ,1,99},{cARQ2,1,99}})
         retu .f.
      endif
ENDCASE

FILTRO := ''
FILTRO := RFILORD(cARQOP,.F.)


IF cZERA = "S"
   DBSELECTAR(cARQ)
   DBGOTOP()
   WHILE !EOF()
      @ 24,00 SAY RECNO()         
      GRAVACAMPO({"QATR","QSEM","QSE2","ATIVO"},{"0","0","0","'N'"})
      DBSELECTAR(cARQ)
      DBSKIP()
   ENDDO
   DBSELECTAR(cARQ2)
   DBGOTOP()
   WHILE !EOF()
      @ 24,00 SAY RECNO()         
      GRAVACAMPO({"QPSAI"},{"0"})
      DBSELECTAR(cARQ2)
      DBSKIP()
   ENDDO
ENDIF
dbselectar(cARQ)
INITVARS()
CLRVARS()
dbselectar(cARQOP)
IF !EMPTY(FILTRO)
   SET FILTER TO &FILTRO
ENDIF
dbgotop()
while !eof()
   mCODIGO := &eCODIGO.
   @ 24,00 SAY mCODIGO         
   mQATR := 0
   mQSEM := 0
   mQSE2 := 0
   mQMEN := 0
   while mCODIGO = &eCODIGO. .AND. !EOF()
      cUNID := "PC"
      IF cTIPO = "P"
         cUNID := UNID
      ENDIF
      nQTDESAL := 0
      dENTREGA := ZDATA
      IF cTIPO = "P"
         nQTDESAL := QTDESAL
         dENTREGA := ENTREGA
      ELSE
         nQTDESAL := QTDE
         dENTREGA := PROGRAMA
      ENDIF
      IF nQTDESAL > 0.001
         IF cTIPO = "P" .AND. PEDMEN = "S"
            IF dENTREGA <= dMEN
               mQMEN += CONVUN(nQTDESAL,cUNID)
            ENDIF
         ELSE
            IF dENTREGA <= d01
               mQATR += CONVUN(nQTDESAL,cUNID)
            ENDIF
            IF dENTREGA > d01 .AND. dENTREGA <= d02
               mQSEM += CONVUN(nQTDESAL,cUNID)
            ENDIF
            IF dENTREGA > d02 .AND. dENTREGA <= d03
               mQSE2 += CONVUN(nQTDESAL,cUNID)
            ENDIF
         ENDIF
      ENDIF
      dbselectar(cARQOP)
      dbskip()
   enddo
   IF mQMEN > 0
      mQMEN := INT(mQMEN / nMES * nSEM)
      mQATR += mQMEN
      mQSEM += mQMEN
      mQSE2 += mQMEN
   ENDIF
   IF mQATR+mQSEM+mQSE2 > 0
      dbselectar(cARQ)
      dbsetorder(2)
      dbgotop()
      if !dbseek(alltrim(mcodigo))
         dbsetorder(1)
         dbgobottom()
         mOP := OP
         mOP ++
         netrecapp()
         FIELD->OP     := mOP
         FIELD->CODIGO := mCODIGO
      else
         netreclock()
      endif
      FIELD->ATIVO := "S"
      IF cESTRA = "1" .OR. cESTRA = "T"
         FIELD->DATAA := dG01
         FIELD->QATR  := mQATR
      ENDIF
      IF cESTRA = "2" .OR. cESTRA = "T"
         FIELD->DATAS := dG02
         FIELD->QSEM  := mQSEM
      ENDIF
      IF cESTRA = "3" .OR. cESTRA = "T"
         FIELD->DATA2 := dG03
         FIELD->QSE2  := mQSE2
      ENDIF
      dbunlock()
   ENDIF
   dbselectar(cARQOP)
enddo
dbcloseall()
MA2CHKPRG(.T.)
IF lCALC
   //Consolida Resultado
   MAOP03(.F.,cARQ,cARQ2)
ENDIF
