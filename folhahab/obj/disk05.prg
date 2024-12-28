*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : disk05.prg
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
// :       ATUALIZA(xARQUIVO1,xBUSCA,xARQUIVO2,nINDICE2,lAPA)
// :
// :*****************************************************************************


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function ATUALIZA()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION ATUALIZA(xARQUIVO1,xBUSCA,xARQUIVO2,nINDICE2,lAPA)

IF VALTYPE(lAPA) # "L"
   lAPA := .F.
ENDIF
if valtype(nINDICE2) # "N"
   nINDICE2 := 1
endif
IF !NETUSE(xARQUIVO1,,,,,.F.,)
   RETU .F.
ENDIF
INITVARS()
CLRVARS()
cSELE1 := ALIAS()

IF !NETUSE(xARQUIVO2)
   DBCLOSEALL()
   RETU .F.
ENDIF
INITVARS()
CLRVARS()
cSELE2 := ALIAS()
IF nINDICE2 <> 1
   DBSETORDER(nINDICE2)
ENDIF

DBSELECTAR(cSELE1)
GRAPP := 1
GRAPT := LASTREC()
GRAPT('Aguarde Atualizando -> '+xARQUIVO2)
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
DBGOTOP()
WHILE !EOF()
   EQUVARS()
   BUSCA := &xBUSCA.
   DBSELECTAR(cSELE2)
   DBGOTOP()
   if !DBSEEK(BUSCA)
      netrecapp()
      REPLVARS()
   else
      do case
      case xARQUIVO1 = "NEWPAISES" .AND. EMPTY(UF)
         NETRECLOCK()
         FIELD->UF := "EX"
         dbunlock()
         REPLVARS(.T.,.T.)
      case xARQUIVO1 = "NEWCNAE2" .AND. EMPTY(ALIQ_ATV) .and. !empty(mALIQ_ATV)
         netreclock()
         field->ALIQ_ATV := mALIQ_ATV
         dbunlock()
      case xARQUIVO1 = "NEWCNAE2" .AND. EMPTY(NCM_ATV) .and. !empty(mNCM_ATV)
         netreclock()
         field->NCM_ATV := mNCM_ATV
         dbunlock()
      case xARQUIVO1 = "NEWCBON" .AND. EMPTY(CAGEDESCO) .and. !empty(MCAGEDESCO)
         netreclock()
         field->CAGEDESCO := mCAGEDESCO
         dbunlock()
      case xARQUIVO1 = "NEWNATJ" .AND. EMPTY(NATGRU)
         netreclock()
         DO CASE
         CASE LEFT(CODIGO,1) = "1"
            field->natgru := "1. ADMINISTRACAO PUBLICA"
         CASE LEFT(CODIGO,1) = "2"
            field->natgru := "2. ENTIDADES EMPRESARIAIS"
         CASE LEFT(CODIGO,1) = "3"
            field->natgru := "3. ENTIDADES SEM FINS LUCRATIVOS"
         CASE LEFT(CODIGO,1) = "4"
            field->natgru := "4. PESSOAS FISICAS"
         CASE LEFT(CODIGO,1) = "5"
            field->natgru := "5. ORG. INTERNACIONAIS E OUTRAS INSTITUICOES EXT."
         ENDCASE
         dbunlock()
      endcase
   ENDIF
   DBSELECTAR(cSELE1)
   GRAPS()
   zei_fort(nLASTREC,,,1)
   DBSKIP()
ENDDO
FREEVARS()
DBCLOSEALL()
IF lAPA
   FERASE(xARQUIVO1+".DBF")
ENDIF
RETU .T.

*+ EOF: disk05.prg
*+
