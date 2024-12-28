*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_43.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 27-Dez-2024 as  9:33 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+


CABE2('FOPTO_43 - Atualizar CaDastro de Horarios de Referencias')

if !NETUSE(PES)
   retu
endif

if !NETUSE("FO_RELHR")
   dbcloseall()
   retu .F.
endif
INITVARS()
CLRVARS()

if !NETUSE("FOPTOHRE")
   dbcloseall()
   retu .F.
endif
INITVARS()
CLRVARS()

if !NETUSE("ESCALPAD")
   dbcloseall()
   retu .T.
endif

cPE := "PE"+ANOMESW
CHECKCRI(cPE,"FOPTOREV","GRUPO+DTOS(DATA)")

IF !NETUSE(cPE)
   dbcloseall()
   retu .f.
ENDIF

//1a. Fase Cria os Horarios
dbselectar(PES)
dbgotop()
while !eof()
   PETELA(9)
   NUM       := NUMERO
   mNOMEPES  := NOME
   mADMITIDO := ADMITIDO
   dbselectar("FO_RELHR")
   dbgotop()
   IF dbseek(NUM)
      netreclock()
   ELSE
      netrecapp()
      FO_RELHR->NUMERO := NUM
   endif
   FO_RELHR->NOME := mNOMEPES
   IF EMPTY(DATAREF1)
      FO_RELHR->DATAREF1 := mADMITIDO
   ENDIF
   DBUNLOCK()
   dbselectar(PES)
   dbskip()
enddo

//2a. Fase Cria os Horarios
dbselectar("fo_relhr")
dbgotop()
while !eof()
   @ 24,00 say numero         
   @ 24,10 say nome           
   mNUMERO := NUMERO
   mHFOL00 := HFOL00
   mGRUPO  := GRUPO
   mHORREF := HORREF

   //Ajusta codigos
   if empty(HFOL00) .AND. !empty(HORREF)
      NETGRVCAM("HFOL00","N")
   endif
   if empty(HFOL00) .AND. !empty(GRUPO)
      NETGRVCAM("HFOL00","S")
   endif
   IF HFOL00 = "S"  //Escala nao tem horario padrao
      netgrvcam("HORREF","")
   ENDIF
   IF HFOL00 = "N"  //horario padrao nao tem escala
      netgrvcam("GRUPO","")
   ENDIF

   //Tenta Opter o codigo
   IF EMPTY(mGRUPO) .AND. EMPTY(mHORREF)
      dbselectar(PES)
      dbgotop()
      if dbseek(mNUMERO)
         mHTT := HTT
         dbselectar("FOPTOHRE")
         dbgotop()
         if dbseek(mHTT)
            mHORREF := mHTT
         endif
         IF EMPTY(mHORREF)
            dbselectar("ESCALPAD")
            dbgotop()
            if dbseek(mHTT)
               mGRUPO := mHTT
            endif
            IF EMPTY(mGRUPO)
               dbselectar(cPE)
               dbgotop()
               if dbseek(mHTT)
                  mGRUPO := mHTT
               endif
            ENDIF
         endif
      endif
      dbselectar("fo_relhr")
      IF !EMPTY(mHORREF)
         NETGRVCAM("HFOL00","N")
         NETGRVCAM("HORREF",mHORREF)
      ENDIF
      IF !EMPTY(mGRUPO)
         NETGRVCAM("HFOL00","S")
         NETGRVCAM("GRUPO",mGRUPO)
      ENDIF
   ENDIF
   dbselectar("fo_relhr")
   dbskip()
enddo
dbcloseall()

return .T.



*+ EOF: fopto_43.prg
*+
