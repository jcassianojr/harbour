*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fod2bas.prg
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
*+    Documentado em 27-Dez-2024 as  9:45 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :    FOD2BAS.PRG: Calcular os Vencimentos da Folha de Pagamento
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/08/94     10:31
// :
// :  Procs & Fncts: FOD2BAS()
// :
// :          Chama: PETELA()           (funÎ"o    em FOLPROC.PRG)
// :               : SALHM()            (funÎ"o    em FOLPROC.PRG)
// :               : GRAVA2()           (funÎ"o    em FOLPROC.PRG)
// :               : VALCTA()           (funÎ"o    em FOLPROC.PRG)
// :               : CALCDEPE()         (funÎ"o    em FOD.PRG)
// :
// :     Arq. Total: CONTAS - Cadastro de Vencimentos e Descontos
// :                 SINDICAT - Cadastrode Sindicatos
// :
// :        Indices: CONTA    Por ordem de c½digo
// :                          CODIGO
// :                 SIND     Por Codigo de Cadastramento
// :                          CODIGO
// :
// :     Documentado 05/13/94 em 14:54                DISK!  vers"o 5.01
// :*****************************************************************************



FFGTS := VINSL := VPERI := 0
IF !netuse(pes)
   RETU
ENDIF
SET FILTER TO &FILTRO

IF nFOLTIP = 1
   IF !NETUSE(FOL)
      RETU
   ENDIF
ELSE
   IF !NETUSE(FO_COMP)
      RETU
   ENDIF
ENDIF
cSELE2 := ALIAS()

IF !NETUSE("CONTAS")
   RETU
ENDIF
DBGOTOP()
IF DBSEEK(426)
   FFGTS := FATOR
ENDIF
IF DBGOTOP()
   VINSL := VALOR
ENDIF
DBGOTOP()
IF DBSEEK(114)
   FPERI := FATOR
ENDIF


IF !NETUSE("SINDICAT")
   RETU
ENDIF
INITVARS()
CLRVARS()


DBSELECTAR(PES)
DBGOTOP()
WHILE !EOF()
   IF !EMPTY(SITUACAO) .AND. SITUACAO # "P"
      DBSKIP()
      LOOP
   ENDIF
   PETELA(7)
   CTR  := NUMERO
   SALH := SALM := VALE := 0
   SALHM()
   SINDLOGI := .F.
   CONTASS  := .F.
   mPGASSI  := PGASSI
   MDS('Verificando Sindicato do Funcionario')
   BUSCA := SINDICATO
   DBSELECTAR("SINDICATO")
   IF DBSEEK(BUSCA)
      XSAL     := LTRIM(MMES)
      XSAL     := SUBSTR(XSAL,1,3)
      XSAL     := 'SAL'+XSAL
      VALESIND := &XSAL.
      VALTAXA  := (TAXAASS / 100)
      VALTETO  := TETOASS
      SINDLOGI := .T.
      IF MONTH(DATASS1) = MES .OR. MONTH(DATASS2) = MES
         CONTASS := .T.
      ENDIF
      EQUVARS()
   ELSE
      VALTAXA := VALTETO := VALESIND := 0
      CLRVARS()
   ENDIF
   DBSELECTAR(PES)
   IF SINDLOGI
      IF SOCIOSIND = 'S'
         MDS('Descontando Mensalidade do Sindicato')
         VALE := 0.00
         IF EMPTY(mDESSIND) .OR. mDESSIND = "S"
            VALE := VALESIND
         ENDIF
         IF mDESSIND = "P"
            VALE := SALM * mPERSIND / 100
            VALE := IF(VALE > mTETSIND,mTETSIND,VALE)
         ENDIF
         dbselectar(cSELE2)
         GRAVA2(IF(EMPTY(mCTASIND),610,mCTASIND))
         DBSELECTAR(PES)
      ENDIF
      IF CONTASS .AND. mPGASSI # "N"
         MDS('Descontando ContribuiÎ"o Assistencial')
         VALE := SALM * VALTAXA
         VALE := IF(VALE > VALTETO,VALTETO,VALE)
         dbselectar(cSELE2)
         GRAVA2(IF(EMPTY(mCTAASSI),620,mCTAASSI))
         DBSELECTAR(PES)
      ENDIF
      IF mDESCONF = "S"
         MDS('Descontando ContribuiÎ"o Confederativa')
         VALE := SALM * mPERCONF / 100
         VALE := IF(VALE > mTETCONF,mTETCONF,VALE)
         dbselectar(cSELE2)
         GRAVA2(IF(EMPTY(mCTACONF),621,mCTACONF))
         DBSELECTAR(PES)
      ENDIF
   ENDIF
   IF MES > 2
      IF EMPTY(DATCONTSIN) .OR. (MONTH(DATCONTSIN) = MES)
         MDS('Descontando ContribuiÎ"o Sindical')
         netreclock()
         FIELD->DATCONTSIN := DXDIA
         dbunlock()
         VALE := SALM / 30
         dbselectar(cSELE2)
         VALE += VALCTA(CTR,435)  //CTA 435 VARIAVEL SINDICAL INDICADO
         GRAVA2(630)
         DBSELECTAR(PES)
      ENDIF
   ENDIF


   IF PERICULO = 'S'
      MDS('Creditando Periculosidade')
      VALE := SALM * FPERI
      dbselectar(cSELE2)
      GRAVA2(114)
      DBSELECTAR(PES)
   ENDIF

   IF INSALUBRI = 'S'
      MDS('Creditando Insalubridade')
      VALE := VINSL
      dbselectar(cSELE2)
      GRAVA2(110)
      DBSELECTAR(PES)
   ENDIF


   DBSELECTAR(PES)
   MDS('Desconto Assistencia Medica')
   nVALTMP := PEGVALTIP(ASSM,VAASSMED)
   IF nVALTMP > 0
      dbselectar(cSELE2)
      GRAVA2(615)
   ENDIF

   DBSELECTAR(PES)
   MDS('Desconto Assistencia Odontologica')
   nVALTMP := PEGVALTIP(ASSO,VAASSODO)
   IF nVALTMP > 0
      dbselectar(cSELE2)
      GRAVA2(616)
   ENDIF

   DBSELECTAR(PES)
   DEP := FOSFAMQTDE(CTR)
   IF DEP > 0
      MDS('Calculando deducoes por dependente')
      VALE := CALCDEPE()
      dbselectar(cSELE2)
      GRAVA2(413)
      DBSELECTAR(PES)
   endif

   QTFIL := FOSFAMQTDE(CTR,"S")
   IF QTFIL > 0
      MDS('Quantidade de Filhos menores que 14 anos')
      VALE := QTFIL
      dbselectar(cSELE2)
      GRAVA2(491)
      DBSELECTAR(PES)
   ENDIF


   DBSELECTAR(PES)
   DBSKIP()
ENDDO
RETU

// : FIM: FOD2BAS.PRG


*+ EOF: fod2bas.prg
*+
