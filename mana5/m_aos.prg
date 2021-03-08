*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_aos.prg
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

MDI(" Ý Gerar Acumulado Programacao")
mTIPARQ := "S"
mTIPOPR := "A"
cARQORI := "OSPRG"
cARQDES := "OSPRA"

mDATAINI := ZDATA
while dow(mDATAINI) # 2
   mDATAINI --
enddo
mDATAACM := mDATAINI
mDATAFIM := mDATAINI+6
nSEMANAS := 8

//Remover Depois de apagar lista tipo da base dados
mLISTA := ""
mTIPO  := ""


@ 17,00 SAY "(S)emanal (D)iario (P)edidos Electrolux->D(E)lfor (O)rders"                                                  
@ 17,60 GET mTIPARQ                                                      VALID mTIPARQ $ "SDPEO"                          
@ 18,00 SAY "(A)cumular Excluir->Periodo (E)ntrega (P)rograma Acumulo"                                                    
@ 18,60 GET mTIPOPR                                                      VALID mTIPOPR $ "AEP"                            
@ 20,00 SAY "Data Acumulacao"                                                                                             
@ 20,25 GET mDATAACM                                                     WHEN mTIPOPR $ "AP"                              
@ 21,00 SAY "Periodo "                                                                                                    
@ 21,25 get mDATAINI                                                     WHEN mTIPOPR $ "AE"                              
@ 21,35 GET mDATAFIM                                                     WHEN mTIPOPR $ "AE"                              
@ 22,00 SAY "Semanas a Acumular"                                                                                          
@ 22,25 GET nSEMANAS                                                     PICT "99"               WHEN mTIPOPR $ "A"       
IF !READCUR()
   RETU .F.
ENDIF


DO CASE
   CASE mTIPARQ = "S"
      cARQORI := "OSPRG"
      cARQDES := "OSPRA"
   CASE mTIPARQ = "D"
      cARQORI := "OSPR2"
      cARQDES := "OSPRD"
   CASE mTIPARQ = "O"
      cARQORI := "OSPR3"
      cARQDES := "OSPRF"
   CASE mTIPARQ = "E"
      cARQORI := "OSPRE"
      cARQDES := "OSPRB"
   CASE mTIPARQ = "P"
      cARQORI := "MO02"
      cARQDES := "OSPRO"
ENDCASE

IF !USEMULT({{cARQORI,0,99},{cARQDES,0,99}})
   RETU .F.
ENDIF
DBSELECTAR(cARQDES)
nLASTREC := LASTREC()
IF mTIPOPR = "P" .OR. mTIPOPR = "A"
   nLASTREC := LASTREC()
   zei_fort(nLASTREC,,,0)
   DBEVAL({|| netrecdel()},{|| DATAACM = mDATAACM},{|| zei_fort(nLASTREC,,,1)})
   PACK
ENDIF
IF mTIPOPR = "E"
   nLASTREC := LASTREC()
   zei_fort(nLASTREC,,,0)
   DBEVAL({|| netrecdel()},{|| DATAPRG >= mDATAINI .AND. DATAPRG <= mDATAFIM},{|| zei_fort(nLASTREC,,,1)})
   PACK
ENDIF
IF mTIPOPR = "A"
   DBSELECTAR(cARQORI)
   IF mTIPARQ = "P"
      DBSETORDER(3)   //Codigo Produto MO02
   ELSE
      DBSETORDER(2)   //Produto Programacoes ospr?
   ENDIF
   nLASTREC := LASTREC()
   FOR X := 1 TO nSEMANAS
      mDATAPRG := mDATAINI
      @ 23,10 SAY mDATAINI         
      @ 23,20 SAY mDATAFIM         
      @ 23,30 SAY X                
      DBGOTOP()
      WHILE !EOF()
         @ 23,00 SAY RECNO()         
         ZEI_FORT(nLASTREC)
         mPRODUTO := IF(mTIPARQ = "P",CODIGO,PRODUTO)
         @ 23,32 SAY mPRODUTO         
         mQTDE := 0
         WHILE mPRODUTO = IF(mTIPARQ = "P",CODIGO,PRODUTO) .AND. !EOF()
            mPROGRAMA := IF(mTIPARQ = "P",ENTREGA,PROGRAMA)
            IF mPROGRAMA >= mDATAINI .AND. mPROGRAMA <= mDATAFIM
               @ 23,70 SAY mPROGRAMA         
               mQTDE += IF(mTIPARQ = "P",CONVUN(QTDEPED,UNID),QTDE)
            ENDIF
            DBSKIP()
         ENDDO
         IF mQTDE > 0 .AND. !EMPTY(mPRODUTO)
            DBSELECTAR(cARQDES)
            netrecapp()
            REPLVARS()
         ENDIF
         DBSELECTAR(cARQORI)
      ENDDO
      mDATAINI := mDATAINI+7
      mDATAFIM := mDATAFIM+7
   NEXT X
ENDIF
DBCLOSEALL()

