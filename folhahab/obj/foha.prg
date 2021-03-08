*:*****************************************************************************
*:
*:       FOHA.PRG: Imprimir Guia de INPS
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1997,  SOFTEC  S/C Ltda.
*:  Atualizado em: 20/11/97     14:43
*:
*:*****************************************************************************


////#INCLUDE "COMANDO.CH"
#INCLUDE "INKEY.CH"

function foha
PARA CC,CW,CT

IF CW=9.OR.CW=10
   MDT('Use a opcao Folha')
   RETU
ENDIF
IF CW=6
   ALERTX("Nao Disponivel VT")
   RETU .F.
ENDIF

IF ! MDL('Guia de IAPAS',0)
   RETU
ENDIF
mTEMP=tmpfile(cRDDEXT)

ATUALIZA:=1.000000
FPAS=OBTER("FIRMA",,NREMP,"FPAS")
QTFUN:=VALVEND:=PROLABO:=NATALI:=PROAUTO:=0
TOT1:=TOT2:=TOT6:=TXSEGU:=TXEMPRE:=TXTERCE:=0
BASEINPS:=TOTRECO:=TOTDEDU:=0
PROAUT2 :=PROLAB2:=ADCACI:=0
PERLABO:=PERAUTO:=0
CREDITO:=COMPENSA:=0
cMES:=STRZERO(MESTRAB,2)
cANO:=STRZERO(ANO,4)
dINI:=BOM(zdata)
dFIM:=EOM(ZDATA)
cINCPG:="N"
TERCE:="0000"
mPAGGPS:="2100"

CLSCOR()
MDS("Confirme seu FPAS/cPAG")
set key K_F11 to TECLAF11
@ 24,40 Get FPAS    PICT '####' VALID VERSEHA("CONFINSS",,FPAS,,'C¢digo FPAS INEXISTENTE',.T.,;
                                       {{"ACIDENTE","TXSEGU"},;
                                       {"EMPRESA","TXEMPRE"},;
                                       {"TOTAL","TXTERCE"},;
                                       {"STRZERO(TERCEIRO,4)","TERCE"},;
                                       {"PEMP","PERLABO"},{"PAUT","PERAUTO"}})
@ 24,50 GET mPAGGPS VALID VERSEHA("TBCODPG","TBCODPG",mPAGGPS,"NOME",'"Codigo Pagamento N„o Cadastrado"')
IF ! READCUR()
   set key K_F11 
   RETU .F.
ENDIF
set key K_F11 



CLSROW(03)
@ 03,00 SAY 'Confirme Taxas e Valores de Calculo'
@ 04,01 SAY "Competencia"
@ 05,01 SAY "Pro Labore e %"
@ 06,01 SAY "Autonomos e %"
@ 07,01 SAY "Fator de Atualiza‡„o"
@ 08,01 SAY 'Taxa Acidente de Trabalho '
@ 09,01 SAY 'Taxa da Empresa           '
@ 10,01 SAY 'Taxa de Terceiros         '
@ 11,01 SAY 'Codigo dos Terceiros      '
@ 04,30 GET cMES
@ 04,35 GET cANO
IF CT#1
   @ 05,24 GET PROLABO PICT '###,###,###.##'
   @ 05,17 GET PERLABO PICT '##.##'
   @ 06,24 GET PROAUTO PICT '###,###,###.##'
   @ 06,17 GET PERAUTO PICT '##.##'
ENDIF
@ 07,20 GET ATUALIZA PICT "99999999999.999999"
IF CT#1
   @ 08,30 GET TXSEGU  PICT '###.##'
   @ 09,30 GET TXEMPRE PICT '###.##'
   @ 10,30 GET TXTERCE PICT '###.##'
   @ 11,30 GET TERCE
ENDIF
IF CT=1
   @ 13,01 SAY "Periodo Inclui Pagas"
   @ 13,30 GET dINI
   @ 13,40 GET dFIM
   @ 13,50 GET cINCPG PICT "!" VALID cINCPG $ "SN"
ENDIF
READCUR()


MDS('Somando o Numero de Empregados')
IF ! ARQPES(CW,1,1)
   RETU
ENDIF
DBGOTOP()
WHILE ! EOF()
   IF ((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MES.AND.YEAR(DEMITIDO)>=ANO))
      QTFUN++
   ENDIF
   DBSKIP()
ENDDO
DBCLOSEALL()


IF CT=0
   MDS('Aguarde Acumulando dados para GUIA')
   IF ! ARQUSAR(CW,1,1)
      DBCLOSEALL()
      RETU .F.
   ENDIF
   nLASTREC:=LASTREC()
   zei_fort( nLASTREC,,,0)
   ordDestroy("temp")
   ordcreate(,"temp","conta")
   ordSetFocus("temp")

   
   cSELE1:=ALIAS()

   IF ! ARQCTA(CW)
      DBCLOSEALL()
      RETU .F.
   ENDIF
   cSELE2:=ALIAS()
   
   DBSELECTAR(cSELE1)
   DBGOTOP()
   WHILE ! EOF()
      CTA=CONTA
      GUIAINPS=1
      TOTCTA=0
      WHILE CTA=CONTA .AND. ! EOF()
         TOTCTA+=VALOR
         DBSKIP()
      ENDDO
      TOTCTA := IF(ATUALIZA#1,ROUND(TOTCTA*ATUALIZA,2),TOTCTA)
      DBSELECTAR(cSELE2)
      DBGOTOP()
      IF DBSEEK(CTA)
         GUIAINPS=GUIA_IAPAS
         IF CW=8 //Autonomos BaseReduzida
            TOTCTA:=ROUND(TOTCTA*BASERED/100,2)
         ENDIF
      ENDIF
      BASEINPS += IF(GUIAINPS=0.OR.GUIAINPS=5,TOTCTA,0)
      BASEINPS -= IF(GUIAINPS=2,TOTCTA,0)
      TOTRECO  += IF(GUIAINPS=3,TOTCTA,0)
      TOTDEDU  += IF(GUIAINPS=4.OR.GUIAINPS=5,TOTCTA,0)
      ADCACI   += IF(GUIAINPS=6,TOTCTA,0)
      DBSELECTAR(cSELE1)
   ENDDO
   DBCLOSEALL()
//   IF MDG("Confirmar Valores Acumulados")
      @ 03,40 SAY "Confirme os Acumuladores"
      @ 04,40 SAY "Base INSS"
      @ 05,40 SAY "Segurados"
      @ 06,40 SAY "Dedu‡”es "
      @ 07,40 SAY "Adc.Ac.Trab."
      @ 08,40 SAY "Creditos"
      @ 09,40 SAY "Compensa‡ao"
      @ 04,55 GET BASEINPS PICT '###,###,###.##'
      @ 05,55 GET TOTRECO  PICT '###,###,###.##'
      @ 06,55 GET TOTDEDU  PICT '###,###,###.##'
      @ 07,55 GET ADCACI   PICT '###,###,###.##'
      @ 08,55 GET CREDITO  PICT '###,###,###.##'
      @ 09,55 GET COMPENSA PICT '###,###,###.##'
      READCUR()
//   ENDIF
ENDIF

IF CT=1
   ACIDENT:=TOTRECO:=EMPRESA:=TERCEIRO:=TOTDEDU:=LIQUIDO:=0
   IF ! netuse("GINSSE") //AREDE("GINSSE","GINSSE",1)
      DBCLOSEALL()
      RETU .F.
   ENDIF
   DBSELECTAR("GINSSE")
   DBGOTOP()
   DBSEEK(STRZERO(NREMP,5))
   WHILE NREMP=NUMEMP.AND.! EOF()
      IF PAGA#"S".OR.cINCPG="S"
         cDAT:="01/"+STRZERO(MES,2)+"/"+STRZERO(ANO,4)
         dDAT:=CTOD(cDAT)
         IF dDAT>=dINI.AND.dDAT<=dFIM
            TOTRECO +=VALREC
            EMPRESA +=VALEMA
            ACIDENT +=VALACI
            TERCEIRO+=VALTER
         TOTDEDU +=VALDED
         LIQUIDO +=VALLIQ
         CREDITO +=VALCRE
         COMPENSA+=VALCOM
      ENDIF
      ENDIF
      DBSKIP()
   ENDDO
   DBCLOSEALL()
ENDIF

FPAS1:=OBTER("FIRMA",,NREMP,"FPAS")
CODSAT:=OBTER("FIRMA",,NREMP,"ACID")

IF FPAS=770
   TOTRECO=0
   TOTDEDU=0
ENDIF
IF CT=0
   LABO:=ROUND(PROAUTO*PERAUTO/100,2)+ROUND(PROLABO*PERLABO/100,2)
   EMPRESA =ROUND((BASEINPS)*(TXEMPRE/100),2)
   EMPRESA+=LABO
   ACIDENT =ROUND(BASEINPS * (TXSEGU/100),2)
   EMPRESA1=ACIDENT + EMPRESA + ADCACI
   TERCEIRO=ROUND(BASEINPS*(TXTERCE/100),2)
ENDIF
IF CT=1
   EMPRESA1=ACIDENT + EMPRESA
ENDIF
//Terceiro Sempre Paga
SOMA    :=TOTRECO+EMPRESA1
DESSOMA :=TOTDEDU+CREDITO+COMPENSA
DESCONTO:=IF(DESSOMA>SOMA,SOMA,DESSOMA)
LIQUIDO :=SOMA - DESCONTO +TERCEIRO
ATUAL:=0.00
JUROS:=0.00
TOTAL:=0
FOHA04("")
IF CC = 0
   FOHA01(CT)
ENDIF
IF CC=1
   IF ! MDG("Modelo GPS")
      FOHA02(CT)
   ELSE
      FOHA03(CT)
   ENDIF
ENDIF
IF CT=1
   IF MDG("Deseja Apenas Resumo")
       FOHA01(CT)
   ELSE
     IF ! MDG("Modelo GPS")
        FOHA02(CT)
     ELSE
        FOHA03(CT)
     ENDIF
   ENDIF
   RETU .T.
ENDIF
IF MDG("Gravar Resultados do Mes")
   IF ! NETUSE("GINSSE") //AREDE("GINSSE","GINSSE",0)
      RETU .F.
   ENDIF
   DBGOTOP()
   IF ! DBSEEK(STRZERO(NREMP,5)+STRZERO(VAL(cANO),4)+STRZERO(VAL(cMES),2))
      netrecapp()
   else
      netreclock()   
   ENDIF
   FIELD->VALREC :=TOTRECO
   FIELD->VALEMP :=EMPRESA1
   FIELD->VALEMA :=EMPRESA
   FIELD->VALACI :=ACIDENT
   FIELD->VALTER :=TERCEIRO
   FIELD->VALDED :=TOTDEDU
   FIELD->VALLIQ :=LIQUIDO
   FIELD->VALCRE :=CREDITO
   FIELD->VALCOM :=COMPENSA
   FIELD->SUB01  :=VALREC+VALEMA
   FIELD->SUB02  :=SUB01+VALACI
   nTEMP:=SOMA-TOTDEDU
   IF nTEMP>0.AND.CREDITO>0
      nTEMP:=CREDITO-nTEMP
      IF nTEMP>0
         FIELD->SUB03  :=CREDITO-nTEMP
      ELSE
         FIELD->SUB03 :=CREDITO
      ENDIF
      FIELD->VALUSO:=CREDITO-SUB03
   ENDIF
   FIELD->MES    :=VAL(cMES)
   FIELD->ANO    :=VAL(cANO)
   FIELD->NUMEMP:=NREMP
   DBCLOSEALL()
ENDIF
RETU


FUNC FOHA01(CT)
IMPRESSORA()
@  0,  0 SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))
@  1,  0 say "MINISTERIO DA PREVIDENCIA E ASSISTENCIA SOCIAL"
@  2,  0 say "INSS - Instituto Nacional do Seguro Social"
@  3, 70 say "G R P S - Guia de Recolhimento da Previdencia Social"
@  5, 70 say "9-Tipo de Identificacao"
@  5,109 say "10-Identificacao"
IF zCEI # SPAC(12)
   @  6, 70 say "|1| 1 - CGC/CNPJ   2 - CEI "
   @  6, 109 say CGC
else
   @  6, 70 say "|2| 1 - CGC/CNPJ   2 - CEI "
   @  6, 109 say ZCEI
endif
@  7,  0 say "2-Nome ou Razao Social"
@  7, 70 say Replicate("_", 62)
@  8,  0 say MSG2
@  8, 70 say "11-FPAS"
@  8,109 say "12-Referencia(uso INSS)"
@  9,  0 say Replicate("_", 66)
@  9, 70 say FPAS
@ 10,  0 say "3-Endereco"
@ 10, 51 say "4-Telefone"
@ 10, 70 say Replicate("_", 62)
@ 11,  0 say ENDER1
@ 11, 51 say zTELEFONE
@ 11, 70 say "13-Comp.(mes/ano)"
@ 11, 89 say "14-Comp.(uso INSS)"
@ 11, 109 say "15-Vencto.(uso do INSS)"
@ 12, 70 say cMES+'/'+cANO
@ 13,  0 say Replicate("_", 66)
@ 13, 70 say Replicate("_", 62)
@ 14,  0 say "5-CEP"
@ 14, 12 say "6-Municipio"
@ 14, 60 say "7-UF"
@ 15,  0 say CEP1
@ 15, 12 say CID1
@ 15, 60 say EST1
@ 15, 70 say "DISCRIMINATIVO"
@ 15, 101 say "CODIGO"
@ 15, 126 say "VALOR"
@ 16,  0 say Replicate("_", 66)
@ 16, 70 say Replicate("_", 62)
@ 17,  0 say "8-Outras Informacoes"
@ 17, 40 say "No. de Empregados"
@ 18, 46 say QTFUN
@ 18, 70 say "16 - Segurados"
@ 18, 101 say "1031"
@ 18, 113 say TOTRECO picture "@E 999,999,999,999.99"
IF CT=2
   @ 19,00 SAY IMPCHR(cIMPTIT)+STR(DEPTO)+"-"+STR(SETOR)+"-"+STR(SECAO)+"-"+NOME
ENDIF
IF CT=1
   @ 19,00 SAY 'Acumulada Periodo: '+DTOC(dINI)+" a "+DTOC(dFIM)
ENDIF
@ 20,  70 say "17 - Empresa"
@ 20, 101 say "1040"
@ 20, 113 say EMPRESA1 picture "@E 999,999,999,999.99"
@ 21,  0 say "Salario-Contribuicao"
@ 21, 60 say "%"
@ 22,  0 say "-Empregados              :"
@ 22, 32 say BASEINPS picture "@E 999,999,999,999.99"
@ 22, 55 SAY TXEMPRE PICT "999.99"
@ 22, 70 say "18 - Terceiros"
@ 22, 101 say TERCE
@ 22, 106 SAY TXTERCE
@ 22, 113 say TERCEIRO picture "@E 999,999,999,999.99"
@ 23,  0 say "-Empregadores(Pr¢-Labore):"
@ 23, 32 say PROLABO PICT "@E 999,999,999,999.99"
@ 23, 55 SAY PERLABO PICT "999.99"
@ 24,  0 say "-Autonomos               :"
@ 24, 32 say PROAUTO PICT "@E 999,999,999,999.99"
@ 24, 55 SAY PERAUTO PICT "999.99"
@ 24, 70 say "19 - Creditos"
@ 24,113 say CREDITO picture "@E 999,999,999,999.99"
@ 25,  0 say "-Sub Total               :"
@ 25, 32 say BASEINPS+PROLABO+PROAUTO PICT "@E 999,999,999,999.99"
@ 26,  0 say "-SAT                     :"
@ 26, 28 say CODSAT
@ 26 ,36 SAY ACIDENT PICT "@E 999,999,999.99"
@ 26, 55 SAY TXSEGU  PICT "999.99"
@ 26, 70 say "20 - Compensacoes"
@ 26,113 say COMPENSA picture "@E 999,999,999,999.99"
@ 27 , 0 SAY "Somente Empresa"
@ 27 ,32 SAY EMPRESA PICT "@E 999,999,999,999.99"
@ 28,  0 say Replicate("_", 66)
@ 28, 70 say "21 - Deducoes FPAS"
@ 28, 101 say "1058"
@ 28, 113 say TOTDEDU picture "@E 999,999,999,999.99"
@ 30, 70 say "22 - Total Liquido"
@ 30, 101 say "1066"
@ 30, 113 say LIQUIDO picture "@E 999,999,999,999.99"
@ 32, 70 say "23 - Atualizacao Monetaria"
@ 32, 101 say "1074"
@ 32, 113 say ATUAL picture  "@E 999,999,999,999.99"
@ 34, 70 say "24 - Juros/Multa"
@ 34, 101 say "1082"
@ 34, 113 say JUROS picture "@E 999,999,999,999.99"
@ 36, 70 say "25 - Total"
@ 36, 101 say "1090"
@ 36, 113 say TOTAL picture "@E 999,999,999,999.99"
IF CT#2
   IMPFOL()
   VIDEO()
   IMPEND()
ENDIF
RETU .T.

FUNC FOHA02(CT)
SET PRIN ON
QQOUT(CHR(27)+'C'+CHR(36))
SET PRIN OFF
SET DEVI TO PRINT
@ PROW()+1,1 SAY IMPSTR(cIMPEXP)
IF ZCEI <> SPAC(12)
   @ PROW(),44 SAY '2'
   @ PROW(),60 SAY ZCEI
ELSE
   @ PROW(),44 SAY '1'
   @ PROW(),60 SAY CGC
ENDIF
@ PROW()+1,12 SAY 'CGC :'
@ PROW(),18 SAY CGC
IF ZCEI <> SPAC(12)
   @ PROW()+1,12 SAY 'CEI :'
   @ PROW(),18 SAY ZCEI
ELSE
   @ PROW()+1,6 SAY ' '
ENDIF
@ PROW()  ,45 SAY FPAS
@ PROW()+1,15 SAY IMPSTR(cIMPCOM)+MSG2+IMPSTR(cIMPEXP)
@ PROW()+1,43 SAY SUBSTR(cMES,1,1)
@ PROW()  ,46 SAY SUBSTR(cMES,2,1)
@ PROW()  ,49 SAY SUBSTR(cANO,3,1)
@ PROW()  ,52 SAY SUBSTR(cANO,4,1)
@ PROW()+1,15 SAY IMPSTR(cIMPCOM)+ENDER1+IMPSTR(cIMPEXP)
@ PROW()+1,15 SAY IMPSTR(cIMPCOM)+BAI1+' - CEP '+CEP1+IMPSTR(cIMPEXP)
@ PROW()+1,15 SAY IMPSTR(cIMPCOM)+TRIM(CID1)+' - '+EST1+IMPSTR(cIMPEXP)
@ PROW()  , 0 SAY ' '
@ PROW()  ,63 SAY TOTRECO PICT '#,###,###,###.##'
@ PROW()+2,63 SAY EMPRESA1 PICT '#,###,###,###.##'
@ PROW()+1, 2 SAY MSG2
@ PROW()+1,56 SAY TERCE
@ PROW()  ,63 SAY TERCEIRO PICTURE '#,###,###,###.##'
@ PROW()+3, 2 SAY ENDER1
@ PROW()+2,32 SAY IMPSTR(cIMPCOM)+ZTELEFONE+IMPSTR(cIMPEXP)
@ PROW()+1,63 SAY TOTDEDU PICTURE '#,###,###,###.##'
@ PROW()+1, 2 SAY IMPSTR(cIMPCOM)+CEP1+IMPSTR(cIMPEXP)
@ PROW()  , 9 SAY CID1
@ PROW()  ,36 SAY EST1
@ PROW()+1,63 SAY LIQUIDO PICT '#,###,###,###.##'
@ PROW()+1,31 SAY IF(NRSEN#'DiReT',QTFUN,0) PICT '####'
@ PROW()+2,20 SAY BASEINPS PICTURE '###,###,###,###.##'
@ PROW()+2,20 SAY PROAUTO+PROLABO PICT '###,###,###,###.##'
@ PROW()+2,20 SAY CODSAT
IF PROLABO # 0
   @ PROW()+1, 4 SAY 'Pro-Labore '
   @ PROW()  ,20 SAY PROLABO PICT '###,###,###,###.##'
ENDIF
IF PROAUTO # 0
   @ PROW()+1, 4 SAY 'Autonomo   '
   @ PROW()  ,20 SAY PROAUTO PICT '###,###,###,###.##'
ENDIF
IF CT=1
   @ PROW()+1, 4 SAY 'Acumulada Periodo  '+DTOC(dINI)+"-"+DTOC(dFIM)
ENDIF
IMPFOL()
SET DEVI TO SCRE
SET PRIN ON
QQOUT(CHR(27)+'C'+CHR(66))
SET PRIN OFF
IF CT#2
   IMPEND()
ENDIF
RETU .T.



FUNC FOHA03(CT)
SET PRIN ON
QQOUT(CHR(27)+'C'+CHR(20))
SET PRIN OFF
SET DEVI TO PRINT
@ PROW(),60 SAY mPAGGPS
//@ PROW()  ,60 SAY FPAS
@ PROW()+2,55 SAY cMES+"/"+cANO
IF ZCEI <> SPAC(12)
   @ PROW()+2,50 SAY ZCEI
ELSE
   @ PROW()+2,50 SAY CGC
ENDIF
@ PROW()+2,50 SAY LIQUIDO-TERCEIRO PICT '@E ###,###,###.##'
@ PROW()+1,02 SAY MSG2
@ PROW()+1,02 SAY ZTELEFONE
@ PROW()+1,02 SAY ENDER1
@ PROW()+1,02 SAY CEP1+" - "+ALLTRIM(CID1)+" - "+ALLTRIM(EST1)
@ PROW()+2,50 SAY TERCEIRO PICT '@E ###,###,###.##'
IF JUROS>0.OR.ATUAL>0
   @ PROW()+2,50 SAY JUROS+ATUAL PICT '@E ###,###,###.##'
ELSE
   @ PROW()+2,0 SAY ""
ENDIF
IF TOTAL>0
   @ PROW()+2,50 SAY TOTAL PICT '@E ###,###,###.##'
ELSE
   @ PROW()+2,0 SAY ""
ENDIF
IMPFOL()
SET DEVI TO SCRE
SET PRIN ON
QQOUT(CHR(27)+'C'+CHR(66))
SET PRIN OFF
IF CT#2
   IMPEND()
ENDIF
RETU .T.


FUNC FOHA04(cTITULO)
//IF MDG("Confirmar Calculos: "+cTITULO)
   @ 14,00 CLEA
   @ 14,00 SAY "Valores Calculados"
   @ 15,00 SAY "Segurados"
   @ 15,35 SAY "Empresa  "
   @ 15,50 SAY "Acidente "
   @ 16,00 SAY "Empresa  "
   @ 17,00 SAY "Terceiros"
   @ 18,00 SAY "Dedu‡”es "
   @ 19,00 SAY "Credito  "
   @ 20,00 SAY "Compensa"
   @ 21,00 SAY "Liquido  "
   @ 22,00 SAY "ATul.Monetaria"
   @ 23,00 SAY "Juros/Multa   "
   @ 15,20 GET TOTRECO  PICT '###,###,###.##'
   @ 16,20 GET EMPRESA1 PICT '###,###,###.##'
   @ 16,35 GET EMPRESA  PICT '###,###,###.##'
   @ 16,50 GET ACIDENT  PICT '###,###,###.##'
   @ 17,20 GET TERCEIRO PICT '###,###,###.##'
   @ 18,20 GET TOTDEDU  PICT '###,###,###.##'
   @ 19,20 GET CREDITO  PICT '###,###,###.##'
   @ 20,20 GET COMPENSA PICT '###,###,###.##'
   @ 21,20 GET LIQUIDO  PICT '###,###,###.##'
   @ 22,20 GET ATUAL    PICT '###,###,###.##'
   @ 23,20 GET JUROS    PICT '###,###,###.##'
   READCUR()
   TOTAL:=LIQUIDO+JUROS+ATUAL
//ENDIF
RETU .T.


*: FIM: FOHA.PRG
