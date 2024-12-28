*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : folis_a5.prg
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
*+    Documentado em 27-Dez-2024 as  9:26 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :
// :   FOLIS_A5.PRG: Acumular Dados para DIRF
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************


CABE2('* ACUMULADO DADOS P/DIRF *')
IF !MDG('Voce ja acumulou Informe de Rendimentos')
   FOLIS_A4()
   RETU
ENDIF
SETCOLOR("W/N,N/W")
@ 08,00 CLEA
nACU    := IRRESC()
nFATCAT := 0
@ 21,00 SAY "Digite o Teto de Corte Rendimentos Funcionarios Sem Retencao"                          
@ 22,00 SAY "Digite 0000000.01 - Incluir Todos Funcionarios Sem Retencao"                           
@ 23,00 SAY "Digite 0 - Para nao Incluir Funcionarios Sem Retencao"                                 
@ 24,60 GET nFATCAT                                                        PICT "9999999.99"        
IF !READCUR()
   RETU .F.
ENDIF

IF !ARQIRR(nACU,1,2)  //shared  fo_irrf
   RETU .F.
ENDIF
cSELE1 := ALIAS()
IF !ARQIRR(nACU,0,1)  //exclusive ajudir
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE2 := ALIAS()
FLOCK()
ZAP
MDS('Acumulando Dados Aguarde')
DBSELECTAR(cSELE1)
DBGOTOP()
WHILE !EOF()
   lVAL1 := .F.
   lVAL2 := .F.
   lVAL3 := .F.
   lVAL4 := .F.
   lVAL5 := .F.
   lVAL6 := .F.
   lVAL7 := .F.
   CTR   := NUMERO
   mCPF  := CPF
   IF EMPTY(mCPF) .OR. mCPF = "000.000.000-00"
      ALERTX("Sem CPF - Funcionario no. "+STR(CTR))
      IF !MDG("Continuar Mesmo Assim")
         DBCLOSEALL()
         RETU
      ENDIF
   ENDIF
   //MES
   MER := MES
   IF CODREN > 600 .AND. CODREN < 610
      MER := 13
   ENDIF
   DO CASE
   CASE CODREN = 401  //rendimentos
      lVAL1 := .T.
   CASE CODREN = 402  //deducoes e Previdencia Oficial
      lVAL2 := .T.
      lVAL4 := .T.
   CASE CODREN = 403  //Previdencia Privada
      lVAL7 := .T.
   CASE CODREN = 404  //Pensao Alimenticia
      lVAL2 := .T.
      lVAL6 := .T.
   CASE CODREN = 405  //Imposto Retido na Fonte
      lVAL3 := .T.
   CASE CODREN = 407  //Deducoes Dependentes
      VAL2  := .T.
      lVAL5 := .T.
   ENDCASE

   VAL := VALOR
   VAU := VALUFIR


   CTRC := mCPF+STR(MER,2)
   DBSELECTAR(cSELE2)
   DBGOTOP()
   IF !DBSEEK(CTRC)
      NETRECAPP()
      FIELD->NUMERO := CTR
      FIELD->CPF    := mCPF
      FIELD->MES    := MER
   ELSE
      NETRECLOCK()
   ENDIF
   DO CASE
   CASE lVAL1   //rendimentos
      FIELD->VALOR1 := VALOR1+VAL
      FIELD->VALUF1 := VALUF1+VAU
   CASE lVAL2   //inss+dependentes+pensao
      FIELD->VALOR2 := VALOR2+VAL
      FIELD->VALUF2 := VALUF2+VAU
   CASE lVAL3   //Imposto Retido na Fonte
      FIELD->VALOR3 := VALOR3+VAL
      FIELD->VALUF3 := VALUF3+VAU
   CASE lVAL4   //deducoes e Previdencia Oficial
      FIELD->VALOR4 := VALOR4+VAL
      FIELD->VALUF4 := VALUF4+VAU
   CASE lVAL5   //Deducoes Dependentes
      FIELD->VALOR5 := VALOR5+VAL
      FIELD->VALUF5 := VALUF5+VAU
   CASE lVAL6   //Pensao Alimenticia
      FIELD->VALOR6 := VALOR6+VAL
      FIELD->VALUF6 := VALUF6+VAU
   CASE lVAL7   //Previdencia Privada
      FIELD->VALOR7 := VALOR7+VAL
      FIELD->VALUF7 := VALUF7+VAU
   ENDCASE
   DBUNLOCK()
   DBSELECTAR(cSELE1)
   DBSKIP()
ENDDO
DBCLOSEALL()


MDS('Aguarde Terminando acumulacao')
IF !ARQIRR(nACU,0,1)  //exclusive Arede ajudir
   DBCLOSEALL()
   RETU .F.
ENDIF
WHILE !EOF()
   mCPF    := CPF
   nREC    := RECNO()
   nVALOR3 := 0
   nVALOR1 := 0
   WHILE CPF = mCPF .AND. !EOF()
      nVALOR1 += VALOR1
      nVALOR3 += VALOR3
      DBSKIP()
   ENDDO
   IF nVALOR3 = 0
      IF nFATCAT = 0 .OR. nVALOR1 <= nFATCAT
         DBGOTO(nREC)
         WHILE CPF = mCPF .AND. !EOF()
            PCK := .T.
            NETRECDEL()
            DBSKIP()
         ENDDO
      ENDIF
   ENDIF
ENDDO
flock()
PACK
DBCLOSEALL()
RETU

// : FIM: FOLIS_A5.PRG

*+ EOF: folis_a5.prg
*+
