*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_4n.prg
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


CABE2("FOPTO_4N - Importar Ferias Folha")

cPO := "PO"+ANOMESW   //ANOWORK + strzero( MES, 2 )
CHECKCRI(cPO,"FO_POCO","STR(NUMERO,8)+DTOS(OCOINI)")

DATAINI := zdataini
DATAFIM := zdatafim
MDS('Digite as Datas Iniciais e Finais')
@ 24,40 get DATAINI         
@ 24,50 get DATAFIM         
if !READCUR()
   retu .F.
endif


if !NETUSE("FO_FER")
   dbcloseall()
   retu
endif

if !NETUSE(cPO)   //AREDE( cPO, cPO, 1 )
   dbcloseall()
   retu .F.
endif

dbselectar("FO_FER")
dbgotop()
while !eof()
   if (GOZOU1DE >= DATAINI .and. GOZOU1DE <= DATAFIM) .or. ;
               (GOZOU2DE >= DATAINI .and. GOZOU2DE <= DATAFIM) .or. ;
               (GOZOU1ATE >= DATAINI .and. GOZOU1ATE <= DATAFIM .and. !empty(GOZOU1ATE)) .or. ;
               (GOZOU2ATE >= DATAINI .and. GOZOU2ATE <= DATAFIM .and. !empty(GOZOU2ATE))
      @ 24,26 say NUMERO             
      @ 24,33 say NOME               
      @ 24,64 say DATFERIAS          
      @ 24,74 say DATFERIASF         
      if (GOZOU1DE >= DATAINI .and. GOZOU1DE <= DATAFIM) .or. ;
                  (GOZOU1ATE >= DATAINI .and. GOZOU1ATE <= DATAFIM .and. !empty(GOZOU1ATE))
         mCHAVE := str(NUMERO,8)+dtos(GOZOU1DE)
         dbselectar(cPO)
         dbgotop()
         if !dbseek(mCHAVE)
            netrecapp()
            field->NUMERO := FO_FER->NUMERO
            field->OCOINI := FO_FER->GOZOU1DE
         else
            netreclock()
         endif
         field->OCOFIM := FO_FER->GOZOU1ATE
         field->OCOCOD := "FN"
         dbunlock()
         dbselectar("FO_FER")
      endif
      if (GOZOU2DE >= DATAINI .and. GOZOU2DE <= DATAFIM) .or. ;
                  (GOZOU2ATE >= DATAINI .and. GOZOU2ATE <= DATAFIM .and. !empty(GOZOU2ATE))
         mCHAVE := str(NUMERO,8)+dtos(GOZOU2DE)
         dbselectar(cPO)
         dbgotop()
         if !dbseek(mCHAVE)
            netrecapp()
            field->NUMERO := FO_FER->NUMERO
            field->OCOINI := FO_FER->GOZOU2DE
         else
            netreclock()
         endif
         field->OCOFIM := FO_FER->GOZOU2ATE
         field->OCOCOD := "FN"
         dbunlock()
         dbselectar("FO_FER")
      endif
   endif
   dbselectar("FO_FER")
   dbskip()
enddo
dbcloseall()


*+ EOF: fopto_4n.prg
*+
