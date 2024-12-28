*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foic0.prg
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

// :*****************************************************************************
// :
// :      FOIC0.PRG: Acumulado Dados para o Resumo Departamento II
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  SOFTEC  S/C Ltda.
// :  Atualizado em: 15/07/98
// :
// :*****************************************************************************


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function foic0()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function foic0

PARA CCARQ
CABEX('Acumulado Dados para o Resumo Departamento II')

IF !NETUSE("DEPTO")   ///AREDE("DEPTO","DEPTO",1)
   RETU
ENDIF

IF MDG('Deseja apagar acumulo anterior')
   netzap("AJUGER")
   IF !NETUSE("AJUGER")   //BREDE("AJUGER",0)
      RETU
   ENDIF
   MDS('Criando Arquivo de Trabalho')
   DBSELECTAR("DEPTO")
   DBGOTOP()
   WHILE !EOF()
      DEP := DEPTO
      SET := SETOR
      SEC := SECAO
      NOM := NOMEC
      CON := CONTROLE
      DBSELECTAR("AJUGER")
      netrecapp()
      FIELD->DEPTO    := DEP
      FIELD->SETOR    := SET
      FIELD->SECAO    := SEC
      FIELD->NOME     := NOM
      FIELD->CONTROLE := CON
      DBSELECTAR("DEPTO")
      DBSKIP()
   ENDDO
   DBCLOSEALL()
ENDIF

MDS('Aguarde Acumulando Dados')
IF !ARQPES(CCARQ,1,1)
   RETU
ENDIF
cSELE1 := ALIAS()

IF !ARQUSAR(CCARQ,1)
   RETU .F.
ENDIF
cSELE2 := ALIAS()

IF !ARQCTA(CCARQ,1,1)
   RETU
ENDIF
FILTRO := 'RESG>0.AND.RESG<6'
SET FILTER TO &FILTRO
cSELE3 := ALIAS()

IF !NETUSE("AJUGER")  //BREDE("AJUGER",0)
   RETU
ENDIF

DECLARE BUS[3]
DBSELECTAR(cSELE1)
DBGOTOP()
WHILE !EOF()
   PETELA(7)
   CTR  := NUMERO
   MADM := MDEM := MATI := SALH := SALM := 0
   SALHM()
   BUS[1] = DEPTO * 1000000
   BUS[2] = DEPTO * 1000000+SETOR * 1000
   BUS[3] = DEPTO * 1000000+SETOR * 1000+SECAO
   IF MONTH(ADMITIDO) = MES .AND. YEAR(ADMITIDO) = ANO
      MADM := 1
   ENDIF
   IF MONTH(DEMITIDO) = MES
      MDEM := 1
   ENDIF
   IF EMPTY(DEMITIDO) .OR. MONTH(DEMITIDO) >= MES
      MATI := 1
   ENDIF
   DBSELECTAR("AJUGER")
   FOR X := 1 TO 3
      DBGOTOP()
      IF DBSEEK(BUS[X])
         NETRECLOCK()
         FIELD->ADM     := ADM+MADM
         FIELD->DEM     := DEM+MDEM
         FIELD->ATI     := ATI+MATI
         FIELD->SALARIO := SALARIO+SALM
         DBUNLOCK()
      ENDIF
   NEXT
   IF MATI = 1
      DBSELECTAR(cSELE3)
      DBGOTOP()
      WHILE !EOF()
         TIT := DESCR
         CTA := CODIGO
         CCC := RESG
         MDS(TIT)
         BUSCA := (CTR * 10000)+CTA
         DBSELECTAR(cSELE2)
         DBGOTOP()
         IF DBSEEK(BUSCA)
            QTW := 'QT'+STR(CCC,1)
            VLW := 'VL'+STR(CCC,1)
            HOR := HORAS
            VAL := VALOR
            DBSELECTAR("AJUGER")
            FOR X := 1 TO 3
               DBGOTOP()
               IF DBSEEK(BUS[X])
                  NETRECLOCK()
                  FIELD->&QTW := &QTW+HOR
                  FIELD->&VLW := &VLW+VAL
                  DBUNLOCK()
               ENDIF
            NEXT
         ENDIF
         DBSELECTAR(cSELE3)
         DBSKIP()
      ENDDO
   ENDIF
   DBSELECTAR(cSELE1)
   DBSKIP()
ENDDO
DBSELECTAR("AJUGER")
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
DBEval({|| netrecdel()},{|| QT1 = 0 .AND. QT2 = 0 .AND. QT3 = 0 .AND. QT4 = 0 .AND. QT5 = 0 .AND. VL1 = 0 .AND. VL2 = 0 .AND. VL3 = 0 .AND. VL4 = 0 .AND. VL5 = 0},{|| zei_fort(nLASTREC,,,1)})
DBCLOSEALL()
netPACK("AJUGER")
RETU
// : FIM: FOIC0.PRG

*+ EOF: foic0.prg
*+
