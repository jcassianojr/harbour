*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foy9.prg
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
*+    Documentado em 27-Dez-2024 as  9:46 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

#INCLUDE "BOX.CH"

PADRAO("DISKRELA","DISKRELA","mCODIGO+' '+mDESCRICAO","mCODIGO","Layout de Relatorios","Codigo Nome",;
 {|| PEGCHAVE("mCODIGO",SPACE(12),"Codigo:")},{|| tFOY9()},{|| gFOY9()},{| x | lFOY9(x)},,4,,{| x | aFOY9(x)})
RETU .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function tFOY9()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC tFOY9

@  7,0 SAY "i"+replicate('-',26)+"Ñ"+replicate('-',51)+"¸"                                                                           
@  8,0 SAY "| Relatorio:            | Descricao       :"+spac(36)+"|"                                                                
@  9,0 SAY "| Tipo:   Repeti‡„o:    | Arquivo &(Macro):"+spac(36)+"|"                                                                
@ 10,0 SAY "| Grupo:                | Arquivo Quebra  :"+spac(36)+"|"                                                                
@ 11,0 SAY "+"+replicate('-',26)+"+"+replicate('-',12)+"-"+replicate('-',12)+"-"+replicate('-',12)+"-"+replicate('-',12)+"|"         
@ 12,0 SAY "| Cabe‡ rio :"+spac(8)+"->    | Mem¢rias:  | Associar:  | Vari veis: | Totais:    |"                                     
@ 13,0 SAY "| Conte£do  :"+spac(8)+"->    | 1 :"+spac(8)+"| 1 :"+spac(8)+"| 1 :"+spac(8)+"| 1 :"+spac(8)+"|"                         
@ 14,0 SAY "| Rodap‚    :"+spac(8)+"->    | 2 :"+spac(8)+"| 2 :"+spac(8)+"| 2 :"+spac(8)+"| 2 :"+spac(8)+"|"                         
@ 15,0 SAY "| Quebra    :"+spac(8)+"->    | 3 :"+spac(8)+"| 3 :"+spac(8)+"| 3 :"+spac(8)+"| 3 :"+spac(8)+"|"                         
@ 16,0 SAY "+"+replicate('-',26)+"-"+replicate('-',12)+"-"+replicate('-',12)+"-"+replicate('-',12)+"-"+replicate('-',12)+"|"         
@ 17,0 SAY "|Filtro => (Exclus„o de dados do relat¢rio)"+spac(36)+"|"                                                                
@ 18,0 SAY "|Arquivo:"+spac(70)+"|"                                                                                                  
@ 19,0 SAY "|Quebra :"+spac(70)+"|"                                                                                                  
@ 20,0 SAY "|Setup  => (Configura‡„o Inicial da Impressora)"+spac(32)+"|"                                                            
@ 21,0 SAY "|"+spac(78)+"|"                                                                                                          
@ 22,0 SAY "|Arquivo Grava‡„o :"+spac(60)+"|"                                                                                        
@ 23,0 SAY "Ô"+replicate('-',78)+"¾"                                                                                                 
RETU


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gFOY9()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC gFOY9

@  8,13 SAY mCODIGO         
@ 09,7  GET mTIPO           
@ 09,20 GET mREP            
@ 10,9  GET mGRUPO          
READCUR()
@  8,46 GET mDESCRICAO                    
@ 09,42 GET mARQUIVO   pict "@S40"        
@ 10,42 GET mARQUIVOQ  pict "@S40"        
READCUR()
@ 12,14 GET mLISTAC         
@ 12,24 GET mLCAB           
@ 13,14 GET mLISTA          
@ 13,24 GET mLCOT           
@ 14,14 GET mLISTAR         
@ 14,24 GET mLROD           
@ 15,14 GET mLISTAQ         
@ 15,24 GET mLQUE           
READCUR()
@ 13,33 GET mMEMORIA1         
@ 14,33 GET mMEMORIA2         
@ 15,33 GET mMEMORIA3         
READCUR()
IF mMEMORIA1 # SPAC(6)
   MEMOS(1,mMEMORIA1)
ENDIF
IF mMEMORIA2 # SPAC(6)
   MEMOS(1,mMEMORIA2)
ENDIF
IF mMEMORIA3 # SPAC(6)
   MEMOS(1,mMEMORIA3)
ENDIF
@ 13,46 GET mASSOCIA1         
@ 14,46 GET mASSOCIA2         
@ 15,46 GET mASSOCIA3         
READCUR()
IF mASSOCIA1 # SPAC(6)
   MEMOS(2,mASSOCIA1)
ENDIF
IF mASSOCIA2 # SPAC(6)
   MEMOS(2,mASSOCIA2)
ENDIF
IF mASSOCIA3 # SPAC(6)
   MEMOS(2,mASSOCIA3)
ENDIF

@ 13,59 GET mVARIAVEL1         
@ 14,59 GET mVARIAVEL2         
@ 15,59 GET mVARIAVEL3         
READCUR()
IF mVARIAVEL1 # SPAC(6)
   MEMOS(1,mVARIAVEL1)
ENDIF
IF mVARIAVEL2 # SPAC(6)
   MEMOS(1,mVARIAVEL2)
ENDIF
IF mVARIAVEL3 # SPAC(6)
   MEMOS(1,mVARIAVEL3)
ENDIF
@ 13,72 GET mTOTAIS1         
@ 14,72 GET mTOTAIS2         
@ 15,72 GET mTOTAIS3         
READCUR()
IF mTOTAIS1 # SPAC(6)
   MEMOS(1,mTOTAIS1)
ENDIF
IF mTOTAIS2 # SPAC(6)
   MEMOS(1,mTOTAIS2)
ENDIF
IF mTOTAIS3 # SPAC(6)
   MEMOS(1,mTOTAIS3)
ENDIF
@ 18,9  GET mFILTRO           
@ 19,9  GET mFILTROQ          
@ 21,9  GET mSETUP            
@ 22,20 GET mGRAVAREM         
READCUR()
RETU


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function aFOY9()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC aFOY9(nPOS)

mCHAVE := ALLTRIM(aPAD2[nPOS])
IF !IGUALVARS("DISKRELA","DISKRELA",mCHAVE)
   RETU .F.
ENDIF
FOYAA()
RETU


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function lFOY9()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC lFOY9(nPOS)

ZDATA  := DXDIA
mCHAVE := ALLTRIM(aPAD2[nPOS])
FO_RELL(mCHAVE)
RETU




// !*****************************************************************************
// !
// !         Fun‡„o: MEMOS()
// !
// !    Chamado por: DISKRELG()         (fun‡„o    em FOY9.PRG)
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function MEMOS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC MEMOS

PARA CC,MEMORIZA
PRIV GETLIST := {}
SAVE SCRE
IF CC = 1
   IF !netuse("DISKRELM")
      RETU
   ENDIF
ELSE
   IF !netuse("DISKRELS")
      RETU
   ENDIF
ENDIF
DBGOTOP()
IF !DBSEEK(MEMORIZA)
   netrecapp()
   FIELD->NOME := MEMORIZA
ELSE
   netreclock()
ENDIF
HB_dispbox(7,0,21,79,B_DOUBLE+" ")
@ 08,02 SAY "Digite Dados para => "+MEMORIZA         
FOR X := 10 TO 19
   @ X,02 SAY STR(X - 9,2)         
NEXT X
@ 10,08 GET M01         
@ 11,08 GET M02         
@ 12,08 GET M03         
@ 13,08 GET M04         
@ 14,08 GET M05         
@ 15,08 GET M06         
@ 16,08 GET M07         
@ 17,08 GET M08         
@ 18,08 GET M09         
@ 19,08 GET M10         
READCUR()
IF CC = 2
   @ 10,74 GET V01         
   @ 11,74 GET V02         
   @ 12,74 GET V03         
   @ 13,74 GET V04         
   @ 14,74 GET V05         
   @ 15,74 GET V06         
   @ 16,74 GET V07         
   @ 17,74 GET V08         
   @ 18,74 GET V09         
   @ 19,74 GET V10         
   READCUR()
ENDIF
dbunlock()
REST SCRE
DBCLOSEAREA()

*+ EOF: foy9.prg
*+
