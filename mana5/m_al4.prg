*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_al4.prg
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

// :*****************************************************************************
// :
// :   M_AL4.PRG   : FLUXO FINANCEIRO VIA VIDEO
//
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :*****************************************************************************

MDI(" þ Fluxo Financeiro ")
mQUEBRA := mdg("Deseja quebra por dia?")
FATOR   := ZTOTCRE := ZTOTDEB := 0.00
TELA    := SAVESCREEN(8,0,24,79)
FLUXO()
zSALDO := FATOR
DBSELECTAR('MZ01')
PRIV ZDATA := CTOD(SPACE(8))
ZNRCONTA := 0
DBGOTOP()
CTLIN := 4
SETCOLOR('N/W')
@  2,0 CLEAR
@  2,1  SAY 'Dup/NF   Venc Cli/For       Historico               Valor    Tipo     Saldo   '         
@  3,01 SAY REPL('Ä',78)                                                                             
@  3,00 SAY 'Ú'                                                                                      
@  3,07 SAY 'Â' // 209                                                                               
@  3,16 SAY 'Â'                                                                                      
@  3,20 SAY 'Â'                                                                                      
@  3,48 SAY 'Â'                                                                                      
@  3,62 SAY 'Â'                                                                                      
@  3,64 SAY 'Â'                                                                                      
@  3,79 SAY '¿'                                                                                      
mDIA   := VENCIMENT
mTOTDP := mTOTDR := 0.00
LIN22  := .F.
WHILE !EOF() .AND. LASTKEY() # 27
   SETCOLOR('N/W')
   IF CTLIN >= 22
      IF CTLIN = 22 .AND. LIN22
         SETCOLOR('N/W')
         @ CTLIN,01 SAY REPL('Ä',78)         
         @ CTLIN,00 SAY 'À'                  
         @ CTLIN,07 SAY 'Á'                  
         @ CTLIN,16 SAY 'Á'                  
         @ CTLIN,20 SAY 'Á'                  
         @ CTLIN,48 SAY 'Á'                  
         @ CTLIN,62 SAY 'Á'                  
         @ CTLIN,64 SAY 'Á'                  
         @ CTLIN,79 SAY 'Ù'                  
      ENDIF
      @ 24,0
      @ 24,1 SAY 'Pressione qualquer tecla... '         
      INKEY(0)
      IF LASTKEY() = 27
         DBCLOSEALL()
         RETU
      ENDIF
      CTLIN := 4
      @  3,0 CLEAR
      @  3,1  SAY REPL('Ä',78)         
      @  3,00 SAY 'Ú'                  
      @  3,07 SAY 'Â'                  
      @  3,16 SAY 'Â'                  
      @  3,20 SAY 'Â'                  
      @  3,48 SAY 'Â'                  
      @  3,62 SAY 'Â'                  
      @  3,64 SAY 'Â'                  
      @  3,79 SAY '¿'                  
   ENDIF
   @ CTLIN,00 SAY '³' // 179         
   @ CTLIN,07 SAY '³' // 179         
   @ CTLIN,16 SAY '³'                
   @ CTLIN,20 SAY '³'                
   @ CTLIN,48 SAY '³'                
   @ CTLIN,62 SAY '³'                
   @ CTLIN,64 SAY '³'                
   @ CTLIN,79 SAY '³'                
   LIN22 := .F.
   IF CTLIN = 21
      LIN22 := .T.
   ENDIF
   IF DEBCRE = 'C'
      ZTOTCRE += VALORS
      mTOTDR  += VALORS
   ELSEIF DEBCRE = 'D'
      SETCOLOR('R/W')
      ZTOTDEB += VALORS
      mTOTDP  += VALORS
   ENDIF
   zSALDO += VALORS
   @ CTLIN,01 SAY NRNOTA                                               PICT '999999'                  
   @ CTLIN,08 SAY VENCIMENT                                                                           
   @ CTLIN,17 SAY CLIENTE                                              PICT '999'                     
   @ CTLIN,21 SAY LEFT(TRIM(COGNOME)+' '+TRIM(OBS1)+' '+TRIM(OBS2),27)                                
   @ CTLIN,49 SAY VALORS                                               PICT '@E 9999999999.99'        
   @ CTLIN,63 SAY IF(DEBCRE = 'D','D',IF(DEBCRE = 'C','C','E'))                                       
   IF zSALDO < 0
      SETCOLOR('R/W')
   ELSE
      SETCOLOR('B/W')
   ENDIF
   @ CTLIN,65 SAY zSALDO PICT '@E 99999999999.99'        
   SETCOLOR('R/W')
   @ 23,01 SAY 'D‚bitos: '+TRAN(zTOTDEB,'@E 999,999,999.99')         
   SETCOLOR('B/W')
   @ 23,31 SAY 'Cr‚ditos: '+TRAN(zTOTCRE,'@E 999,999,999.99')         
   IF zSALDO < 0
      SETCOLOR('R/W')
   ENDIF
   @ 23,58 SAY 'Saldo: '+TRAN(zSALDO,'@E 999,999,999.99')         
   CTLIN ++
   DBSKIP()
   SETCOLOR('N/W')
   IF mQUEBRA
      IF mDIA # VENCIMENT
         @ CTLIN,01 SAY REPL('Ä',78)         
         @ CTLIN,00 SAY 'À'                  
         @ CTLIN,07 SAY 'Á'                  
         @ CTLIN,16 SAY 'Á'                  
         @ CTLIN,20 SAY 'Á'                  
         @ CTLIN,48 SAY 'Á'                  
         @ CTLIN,62 SAY 'Á'                  
         @ CTLIN,64 SAY 'Á'                  
         @ CTLIN,79 SAY 'Ù'                  
         CTLIN ++
         IF CTLIN > 21
            @ 24,0
            @ 24,1 SAY 'Pressione qualquer tecla... '         
            INKEY(0)
            IF LASTKEY() = 27
               DBCLOSEALL()
               RETU
            ENDIF
            IF !EOF()
               CTLIN := 3
               @  3,0 CLEAR
            ENDIF
         ENDIF
         @ CTLIN,0
         @ CTLIN - 1,0 SAY IF(CTLIN # 3,'Ã','')                             
         @ CTLIN,0     SAY 'ÀÄ'+CHR(16)+' Dia: '+LEFT(DTOC(mDIA),5)         
         SETCOLOR('R/W')
         IF mTOTDP # 0.00
            @ CTLIN,COL()+1 SAY 'D‚b '+LTRIM(TRAN(mTOTDP,'@E 999,999,999.99'))         
         ENDIF
         SETCOLOR('B/W')
         IF mTOTDR # 0.00
            @ CTLIN,COL()+1 SAY 'Cr‚ '+LTRIM(TRAN(mTOTDR,'@E 999,999,999.99'))         
         ENDIF
         mSAL := IF(mTOTDR # 0.00 .AND. mTOTDP # 0.00,.T.,.F.)
         IF M->mSAL
            IF mTOTDR+mTOTDP < 0
               SETCOLOR('R/W')
            ENDIF
            @ CTLIN,COL()+1 SAY 'Sdo '+LTRIM(TRAN(mTOTDR+mTOTDP,'@E 999,999,999.99'))         
         ENDIF
         SETCOLOR('N/W')
         IF !EOF()
            CTLIN ++
            IF CTLIN < 21
               @ CTLIN,01 SAY REPL('Ä',78)         
               @ CTLIN,00 SAY 'Ú'                  
               @ CTLIN,07 SAY 'Â'                  
               @ CTLIN,16 SAY 'Â'                  
               @ CTLIN,20 SAY 'Â'                  
               @ CTLIN,48 SAY 'Â'                  
               @ CTLIN,62 SAY 'Â'                  
               @ CTLIN,64 SAY 'Â'                  
               @ CTLIN,79 SAY '¿'                  
            ENDIF
         ENDIF
         CTLIN ++
         mTOTDP := mTOTDR := 0.00
         mDIA   := VENCIMENT
      ENDIF
   ENDIF
ENDDO
DBCLOSEAREA()
@ 24,1 SAY 'Pressione qualquer tecla... '         
INKEY(0)
RESTSCREEN(TELA,8,0,24,79)
RETU

// : FIM: M_AL4.PRG
