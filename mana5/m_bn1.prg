*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_bn1.prg
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
// :   M_BN1.PRG   : Imprimir Duplicata em formulario continuo
// :   Linguagem   : Clipper 5.x
// :        Sistema: MANA5
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :
// :  Documentado em: Julho 28, 1994 as 17:39:37                DISK!  vers„o 5.01
// :*****************************************************************************

//Modo de Trabalho no Video
MDI(" þ Imprimir Duplicata a Receber Direto no Formulario ")


//Checa a Impressora
IF !CHECKIMP()
   RETURN .F.
ENDIF

//N£mero de C¢pias
NRCOPIA := 1
@ 24,00
@ 24,00 SAY "N£mero de copias:" GET NRCOPIA PICT '99'       
IF !READCUR()
   RETU .F.
ENDIF


// Indice da Listagem
nIND := NUMIND("MN01")

//Filtro da Listagem
FILTRO := ''
FILTRO := RFILORD("MN01",.F.)

//Abertura do Arquivo
IF !USEREDE("MA01",1,1)
   RETU
ENDIF
IF !USEREDE("MN01",1,nIND)
   DBCLOSEALL()
   RETU
ENDIF
IF !EMPTY(FILTRO)
   SET FILTER TO &FILTRO
ENDIF
DBGOTOP()
IF EOF()
   DBCLOSEALL()
   RETU .F.
ENDIF


FOR X := 1 TO NRCOPIA
   CTLIN   := 80
   ZPAGINA := 0
   SET PRINT ON
   ? CHR(27)+'C'+CHR(45)
   SET PRINT OFF
   SET DEVICE TO PRINT
   DBGOTOP()
   WHILE !EOF()
      CTLIN := 1
      @ CTLIN,00 SAY impchr(Cimpexp)         
      CTLIN += 6
      @ CTLIN,62 SAY DATA         
      CTLIN += 5
      @ CTLIN,01 SAY TRAN(VALOR,'@E 9,999,999,999.99')         
      @ CTLIN,20 SAY NRNOTA                                    
      @ CTLIN,27 SAY TRAN(VALOR,'@E 9,999,999,999.99')         
      @ CTLIN,44 SAY STR(NRNOTA)+'-'+TIPFAT                    
      @ CTLIN,58 SAY VENCIMENT                                 
      CTLIN    += 7
      mCLIENTE := CLIENTE
      DBSELECTAR("MA01")
      DBGOTOP()
      DBSEEK(mCLIENTE)
      IF FOUND()
         @ CTLIN,25 SAY NOME                                
         @ CTLIN,74 SAY "("+STRZERO(mCLIENTE,5)+")"         
         CTLIN ++
         @ CTLIN,25 SAY ALLTRIM(ENDERECO)+" - "+CEP         
         @ CTLIN,68 SAY ESTADO+impchr(Cimpcom)              
         CTLIN ++
         @ CTLIN,42  SAY ENDERECO2                    
         @ CTLIN,82  SAY CIDADE2                      
         @ CTLIN,104 SAY ESTADO2                      
         @ CTLIN,107 SAY CEP2+impchr(Cimpexp)         
         CTLIN ++
         @ CTLIN,28 SAY CGC                           
         @ CTLIN,65 SAY INSCR+impchr(Cimpcom)         
         CTLIN += 2
      ELSE
         CTLIN += 5
      ENDIF
      DBSELECTAR('MN01')
      @ CTLIN,42 SAY EXT(VALOR,1,105,105,105)         
      CTLIN ++
      @ CTLIN,42 SAY EXT(VALOR,2,105,105,105)         
      CTLIN ++
      @ CTLIN,42 SAY EXT(VALOR,3,105,105,105)+impchr(Cimpexp)+CHR(13)         
      CTLIN ++
      DBSKIP()
   ENDDO
NEXT X
SET DEVI TO SCREEN
DBCLOSEALL()
RETU

// ** EOF ***
