*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foa7.prg
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
// :       FOY7.PRG: LANCAR DESCONTO ASSISTENCIA MEDICA POR DEPENDENTE
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  SOFTEC  S/C Ltda.
// :  Atualizado em: 21/07/98
// :
// :*****************************************************************************


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function foa7()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function foa7

PARA nARQ

CABEX('Lancar Desconto Assistencia Medica Por Dependente')

mSEMANA := 0
lSOMA   := MDG("Somar Funcionario Como Beneficiario")

CTR1 := 0
MDS('Qual a Conta para lancamento')
@ 24,40 GET CTR1         
IF !READCUR()
   RETU .F.
ENDIF



DESCONTO := 0.00
MDS('Qual o Valor por nte')
@ 24,40 GET DESCONTO PICT '###,###,###.##'        
IF !READCUR()
   RETU .F.
ENDIF


IF !ARQPES(nARQ)
   DBCLOSEALL()
   RETU .F.
ENDIF
FILTRO := 'EMPTY(DEMITIDO)'
FI     := TRIM(FILTRO)
FILTRO := FILTRO(FI)
SET FILTER TO &FILTRO
cSELE1 := ALIAS()


IF !ARQUSAR(nARQ,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE2 := ALIAS()

IF !ARQCTA(nARQ)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE3 := ALIAS()


DBSELECTAR(cSELE3)
DBGOTOP()
IF DBSEEK(CTR1)
   XA := FATOR
   XB := TIPO
   XC := TRIBUTINPS
   XD := TRIBUTIRR
   XE := TRIB_FGTS
   XF := VALOR
ELSE
   MDT('Conta n„o encontrada')
   DBCLOSEALL()
   RETU
ENDIF

DBSELECTAR(cSELE1)
DBGOTOP()
WHILE !EOF()
   PETELA(7)
   CTR := NUMERO
   IF lSOMA
      DEP := FOSFAMQTDE(CTR)+1
   ELSE
      DEP := FOSFAMQTDE(CTR)
   ENDIF
   VALE := DEP * DESCONTO
   CTA  := (CTR * 10000)+CTR1
   DBSELECTAR(cSELE2)
   DBGOTOP()
   IF !DBSEEK(CTA)
      netrecapp()
      FIELD->NUMERO   := CTR
      FIELD->CONTA    := CTR1
      FIELD->CONTROLE := CTA
   ELSE
      netreclock()
   ENDIF
   FIELD->VALOR      := VALE
   FIELD->FATOR      := XA
   FIELD->TIPO       := XB
   FIELD->TRIBUTINPS := XC
   FIELD->TRIBUTIRR  := XD
   FIELD->TRIB_FGTS  := XE
   FIELD->VALORBASE  := XF
   DBUNLOCK()
   DBSELECTAR(cSELE1)
   DBSKIP()
ENDDO
DBCLOSEALL()
RETU



// : FIM: FOY7.PRG

*+ EOF: foa7.prg
*+
