*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fores_a2.prg
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
*+    Documentado em 27-Dez-2024 as  9:41 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :  FORES_A2.PRG : Remanejamento de F‚rias
// :     Linguagem : Clipper 5.2e
// :        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
// :      Copyright (c) 1997,  SOFTEC  S/C Ltda.
// :  Atualizado em: 08/07/97
// :
// :*****************************************************************************


CABE2('Remanejamento de F‚rias')
DIAFIM := DATE()
MDS('Digite a data Termino:')
@ 24,40 GET DIAFIM         
READCUR()


IF !netuse(pes)
   RETU
ENDIF
IF !netuse("FO_FER")
   RETU
ENDIF

MDS("Checando Competencia")
DBSELECTAR("FO_FER")
DBGOTOP()
WHILE !EOF()
   IF EMPTY(DATFERIAS) .OR. EMPTY(DATFERIASF)
      netrecdel()
   ENDIF
   DBSKIP()
ENDDO

MDS("Excluindo Funcionarios de Anos Anteriores")
DBSELECTAR("FO_FER")
DBGOTOP()
WHILE !EOF()
   mNUMERO := NUMERO
   DBSELECTAR(PES)
   DBGOTOP()
   DBSEEK(mNUMERO)
   lFUNC := FOUND()
   DBSELECTAR("FO_FER")
   WHILE mNUMERO = NUMERO .AND. !EOF()
      IF !lFUNC
         netrecdel()
      ENDIF
      DBSKIP()
   ENDDO
ENDDO
MDS("Fixando o arquivo")
//PACK

MDS("Remanejando o Arquivo")
DBSELECTAR(PES)
FILTRO := FILTRO('EMPTY(DEMITIDO)')
SET FILTER TO &FILTRO
DBGOTOP()
WHILE !EOF()
   PETELA(8)
   CTR  := NUMERO
   NOM  := NOME
   DEP1 := DEPTO
   SEC1 := SECAO
   SET1 := SETOR
   CHA1 := CHAPA
   DAT  := ADMITIDO
   IF EMPTY(ADMITIDO)
      ALERTX('Funcion rio sem data de admiss„o')
      DBSKIP()
      LOOP
   ENDIF
   DBSELECTAR("FO_FER")
   DBGOTOP()
   DBSEEK(CTR * 100000000)
   WHILE CTR = NUMERO .AND. !EOF()
      DAT := DATFERIASF+1
      DBSKIP()
   ENDDO
   WHILE DAT < DIAFIM
      GRAVAREM()
      DAT := DATFERIASF+1
   ENDDO
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
DBCLOSEALL()
RETU


// !*****************************************************************************
// !
// !       GRAVAREM
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function GRAVAREM()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION GRAVAREM   //GRAVA DADOS DO REMANEJAMENTO

IF DAY(DAT) = 29 .AND. MONTH(DAT) = 02
   DAT ++
ENDIF
CTLE := (((((CTR * 10000)+YEAR(DAT)) * 100)+MONTH(DAT)) * 100)+DAY(DAT)
DBSELECTAR("FO_FER")
DBGOTOP()
if !DBSEEK(CTLE)
   netrecapp()
   FO_FER->CONTROLE := CTLE
   IF DAY(DAT) # 1 .OR. MONTH(DAT) # 3
      DATF := CTOD(SUBSTR(DTOC(DAT - 1),1,6)+ANOSTR(YEAR(DAT - 1)+1))
   ELSE
      DATF := CTOD('28/02/'+ANOSTR(YEAR(DAT - 1)+1))
   ENDIF
   FO_FER->DATFERIAS  := DAT
   FO_FER->DATFERIASF := DATF
   FO_FER->BAIXADO    := 'N'
   FO_FER->DIASJUS    := 30
else
   netreclock()
ENDIF
IF EMPTY(DIASGOZA3)
   FO_FER->DIASGOZA3 := DIASJUS - DIASPAGO - DIASPAGO2 - DIASPAGO3
ENDIF
FO_FER->NUMERO := CTR
FO_FER->DEPTO  := DEP1
FO_FER->SECAO  := SEC1
FO_FER->SETOR  := SET1
FO_FER->NOME   := NOM
FO_FER->CHAPA  := CHA1
dbunlock()
RETU

// : FIM: FORES_A2.PRG

*+ EOF: fores_a2.prg
*+
