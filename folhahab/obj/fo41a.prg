*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fo41a.prg
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
*+    Documentado em 27-Dez-2024 as  9:44 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :      FO41A.PRG: Calcular Reajuste Salarial
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/94     11:19
// :
// :  Procs & Fncts: FO41A()
// :
// :          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
// :               : PETELA()           (fun‡„o    em FOLPROC.PRG)
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
// :*****************************************************************************
#INCLUDE "BOX.CH"



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fo41a()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function fo41a

PARA CC
CABEX('Calcular Reajuste Salarial')
@ 10,19 TO 19,61 DOUB
@ 12,22 SAY "Nota importante."                             
@ 13,22 SAY "Todos  os  funcion rios  ativos  da"          
@ 14,22 SAY "Empresa ter„o seus sal rios mudados"          
@ 15,22 SAY "de acordo com os dados que vocˆ ir "          
@ 16,22 SAY "fornecer..."                                  
@ 17,22 SAY "Sendo assim preste Aten‡„o !!!!!!!!."         
IF !MDG('Deseja Prosseguir (S/N) ')
   RETU
ENDIF
@ 07,00 CLEA
MESO  := MESD := TETO := 0
MOT   := SPAC(2)
PORC  := 0.0000
ARRE  := 0.00
CONFI := .F.
IF MDG('Deseja Limitar um teto de aumento')
   MDS('Digite o valor do teto para aumento')
   @ 24,40 GET TETO PICT '###,###,###.##'        
   READCUR()
ENDIF
IF MDG('Deseja arredondar')
   MDS('DIGITE O ARREDONDAMENTO')
   @ 24,40 GET ARRE PICT '####.##'        
   READCUR()
ENDIF
IF MDG('Deseja confirmar os valores')
   CONFI := .T.
ENDIF
@ 07,00 CLEAR
@ 09,00 TO 19,39 DOUB
@ 09,40 TO 19,51 DOUB
@ 09,52 TO 19,79 DOUB
@ 11,02 SAY "Digite o Mˆs de Referˆncia ========> "                                    
@ 13,02 SAY "Digite o Mˆs do Novo Sal rio ======> "                                    
@ 15,02 SAY "Digite o Motivo do  Aumento  ======> "                                    
@ 17,02 SAY "Digite o Valor da Porcentagem  %  => "                                    
@ 11,44 GET MESO                                    PICT "##"         RANGE 1,12       
@ 13,44 GET MESD                                    PICT "##"         RANGE 1,12       
@ 15,44 GET MOT                                     PICT "!!"                          
@ 17,40 GET PORC                                    PICT "#####.####"                  
IF !READCUR()
   RETU .F.
ENDIF
IF MESO = 0
   ALERTX("Mˆs de Origem igual a zero")
   RETU .F.
ENDIF
IF MESD = 0
   ALERTX("Mˆs de Destino igual a zero")
   RETU .F.
ENDIF

MESOE := MMES(MESO)
MESDE := MMES(MESD)
@ 11,55 SAY MESOE         
@ 13,55 SAY MESDE         
IF !MDG('Deseja Prosseguir (S/N) ')
   RETU
ENDIF

PORC1 := ((PORC / 100)+1)
MEO   := 'SAL'+SUBSTR(MESOE,1,3)
MED   := 'SAL'+SUBSTR(MESDE,1,3)
XMOT  := 'MOT'+IF(MESD > 9,STR(MESD,2),STR(MESD,1))


@ 07,00 CLEA
HB_dispbox(11,0,17,79,B_DOUBLE+" ")
@ 13,04 SAY "Sal rio Referˆncia "+CHR(16)+SPAC(12)+CHR(17)+"   "+ZMOEDA06+SPAC(17)+"Motivo:"         
@ 15,04 SAY "Sal rio Destino    "+CHR(16)+SPAC(12)+CHR(17)+"   "+ZMOEDA06                            
@ 13,25 SAY MESOE                                                                                    
@ 15,25 SAY MESDE                                                                                    

IF CC = 1
   ANOREF := 0
   MDS("Digite o Ano de Referˆncia")
   @ 24,40 GET ANOREF PICT "99"        
   READCUR()
   PAS := HB_CWD()+'EMP'+STRZERO(ANOREF,2)+STRZERO(NREMP,3)+"\"+IF(NRSEN # 'DiReT','FO_PES','FO_DIR')
   IF !file(PAS+".DBF")
      ALERTX("N„o encontrei o arquivo de funcion rios deste ano")
      RETU .F.
   ENDIF
   MDS("Carregando Salario Ano Anterior")
   aNUM := {}
   aSAL := {}
   IF !netuse(pas)
      RETU .F.
   ENDIF
   WHILE !EOF()
      PETELA(8)
      AADD(aNUM,NUMERO)
      AADD(aSAL,&MEO.)
      DBSKIP()
   ENDDO
   DBCLOSEAREA()
ENDIF

IF !netuse(pes)   //AREDE(PES,PES,0)
   RETU
ENDIF
FILTRO := 'EMPTY(DEMITIDO)'
FI     := TRIM(FILTRO)
FILTRO := FILTRO(FI)
SET FILTER TO &FILTRO
DBGOTOP()
WHILE !EOF()
   PETELA(8)
   TIPX  := TIPO
   BUSCA := NUMERO

   // * SALARIO BASICO DO REAJUSTE
   IF CC = 0
      VAL1 := &MEO
   ELSE
      nPOS := ASCAN(aNUM,BUSCA)
      VAL1 := IF(nPOS > 0,aSAL[nPOS],0)
   ENDIF
   @ 13,44 SAY VAL1 PICTURE "###,###,###.##"        

   // * CALCULAR O REAJUSTE
   VAL2 := ROUND((VAL1 * PORC1),2)

   // *** teto do reajuste
   IF teto # 0
      IF TIPX = "1" .OR. TIPO = 'M'
         IF VAL1 > TETO
            VAL2 := ROUND((TETO * PORC1),2)
         ENDIF
      ENDIF
      IF TIPX = "5" .OR. TIPO = 'H'
         IF VAL1 > TETO / 220
            VAL2 := ROUND((TETO / 220 * PORC1),2)
         ENDIF
      ENDIF
   ENDIF

   // **ARREDONDA REAJUSTE
   IF ARRE # 0
      SALDO1 := INT(VAL2 / ARRE)
      SALDO2 := SALDO1 * ARRE
      SALDO3 := SALDO2+ARRE
      SALDO4 := SALDO3 - VAL2
      IF SALDO4 = ARRE
         SALDO4 := 0
      ENDIF
      VAL2 := VAL2+SALDO4
   ENDIF

   // **CONFIRMAR OS VALORES
   netreclock()
   IF CONFI
      @ 15,44 GET VAL2 PICTURE "###,###,###.##"        
      @ 15,60 GET mot  PICTURE "!!"                    
      IF !READCUR()
         EXIT
      ENDIF
   ELSE
      @ 15,44 SAY VAL2 PICTURE "###,###,###.##"        
      @ 15,60 SAY mot  PICTURE "!!"                    
   ENDIF

   // * GRAVAR O NOVO SALARIO CALCULADO
   FIELD->&MED  := VAL2
   FIELD->&XMOT := MOT
   dbunlock()
   DBSKIP()
ENDDO
DBCLOSEALL()
RETU

// : FIM: FO41A.PRG

*+ EOF: fo41a.prg
*+
