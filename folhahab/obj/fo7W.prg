*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
*+
*+    Source Module => J:\FOLHA\OBJ\FO7W.PRG
*+
*+
*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ

#INCLUDE "BOX.CH"

cARQTXT:="C:\TEMP\DUP.TXT"
nHANDLE:=FCREATE(cARQTXT)
cFILTRO:="EMPTY(DEMITIDO).OR.YEAR(DEMITIDO)>=ANOUSO"
IF ! NETUSE(pes,,,,,.F.,)
   RETU
ENDIF

SET FILTER TO &cFILTRO.

chkpesdup("CPF","CPF: ")
chkpesdup("RG","RG: ")
chkpesdup("CI","CI:")
chkpesdup("PIS","PIS:")
chkpesdup("CNH","CNH:")
chkpesdup("TITULO","TITULO:")
chkpesdup("PROFIS+'/'+SERIE","CTPS:")
chkpesdup("CNS","CNS:")
dbcloseall()
FCLOSE(nHANDLE)
VERTXT(cARQTXT)
IF MDG("Deseja imprimir")
   imparq(cARQTXT)
endif

function chkpesdup(cVAR,cERRO)
ordDestroy("temp")
ordcreate(,"temp",Cvar)
ordSetFocus("temp")

dbgotop()
while ! eof()
   zerro:=""
   eNUM:=NUMERO
   eNOME:=NOME
   eVAR:=&cVAR.
   cDIZ:=STR(NUMERO)+": "
   
   ZERRO:=cERRO+" invalido: "
   
   if cVAR="CNH".or.cVAR="TITULO"
      IF VAL(eVAR)=0
         eVAR:=""
      ENDIF
   endif
   
   if cVAR="PIS"
      IF !  VALPIS(PIS,.F.,.F.,FIELD->EVINC)    
         FWrite(nHANDLE,cDIZ+ZERRO+PIS+HB_OSNEWLINE())
      endif
   ENDIF    
   

   if cVAR="CPF"    
      IF ! valcpf(cpf,.F.)
         FWrite(nHANDLE,cDIZ+ZERRO+CPF+HB_OSNEWLINE())
      endif
   endif   
   
   if cVAR="CNS"
      IF ! valCNS(cns,.F.)
         FWrite(nHANDLE,cDIZ+ZERRO+CNS+HB_OSNEWLINE())
      endif
   endif   

   
   if cVAR="RG" .AND. EVINC<>"722" .AND. EVINC<> "721" //nao checar diretores
      IF ! checkrg(RG,.F.,RGTIP,NASC,RGUF)
         FWrite(nHANDLE,cDIZ+zerro+RG+HB_OSNEWLINE())
      endif
   endif


   if cVAR="TITULO"
      IF ! checkTITULO(TITULO,.F.)
         FWrite(nHANDLE,cDIZ+ZERRO+TITULO+HB_OSNEWLINE())
      endif
   endif
   
   IF cVAR="CEP" //CEP
      IF ! EMPTY(CEP) .AND. ! EMPTY(ESTADO) .AND. cep2uf(cep)<>ESTADO
         FWrite(nHANDLE,cDIZ+"-Cep="+CEP+" nao e do estado="+ESTADO+HB_OSNEWLINE())
      ENDIF
   ENDIF   
   
   
   
   dbskip()
   if ! EMPTY(eVAR) .AND. ! eof()
     IF eVAR=&cVAR.
        IF eNOME<>NOME
           if cVAR="CTPS" .AND. (EVINC="722" .OR. EVINC="721")           
           ELSE
             FWRITE(nHANDLE,cERRO+STR(eNUM,8)+"-"+eNOME+"="+STR(NUMERO,8)+"-"+NOME+"-->"+STRVAL(eVAR)+HB_OSNEWLINE())
           ENDIF  
        ENDIF   
     ENDIF
   endif
enddo
return .t.

*!*****************************************************************************
*!
*!         Funcao: VALSITU()
*!
*!*****************************************************************************
FUNCTION VALSITU(eSITU,eVALE,eRAIS)
/*
01 Acidente/Doença do trabalho
02 Novo afastamento decorrente do mesmo acidente/doença do trabalho dentro de 60 dias
03 Acidente/Doença não relacionada ao trabalho
04 Novo afastamento decorrente do mesmo acidente/doença não relacionado ao trabalho dentro de
60 dias
05 Afastamento/licença prevista em regime próprio (estatuto), sem remuneração
06 Aposentadoria por invalidez
07 Acompanhamento - Licença para acompanhamento de membro da família enfermo
08 Afastamento do empregado para participar de atividade do Conselho Curador do FGTS – art.
65, §6º, Dec. 99.684/90 (Regulamento do FGTS)
10 Afastamento/licença prevista em regime próprio (estatuto), com remuneração
11 Cárcere
12 Cargo Eletivo - Candidato a cargo eletivo - Lei 7.664/1988. art. 25, parágrafo único - Celetistas
em geral
13 Cargo Eletivo - Candidato a cargo eletivo - Lei 7.664/1988. art. 25, parágrafo único - Servidor
público, estatutário ou não, dos órgãos ou entidades da Administração Direta ou Indireta da
União, dos Estados, do Distrito Federal, dos Municípios e dos Territórios, das fundações
instituídas pelo Poder Público, e ao empregado de empresas concessionárias de serviços
públicos
14 Cessão
15 Gozo de férias - Afastamento temporário para o gozo de férias
16 Licença remunerada - Liberalidade da empresa ou Acordo/Convenção Coletiva de Trabalho
17 Licença Maternidade - 120 dias
18 Licença Maternidade - a partir de 120 dias até 180 dias
19 Licença Maternidade - Afastamento temporário por motivo de aborto não criminoso
20 Licença Maternidade - Afastamento temporário por motivo de licença-maternidade decorrente
de adoção ou guarda judicial de criança
21 Licença não remunerada ou Sem Vencimento
22 Mandato Eleitoral - Afastamento temporário para o exercício de mandato eleitoral, sem
remuneração
23 Mandato Eleitoral - Afastamento temporário para o exercício de mandato eleitoral, com
remuneração
24 Mandato Sindical - Afastamento temporário para exercício de mandato sindical
25 Mulher vítima de violência - Lei 11.340/2006 - art. 9º §2o, II - Lei Maria da Penha
26 Participação de empregado no Conselho Nacional de Previdência Social–CNPS (art. 3º, Lei
8.213/1991)
27 Qualificação - Afastamento por suspensão do contrato de acordo com o art 476-A da CLT
28 Representante Sindical - Afastamento pelo tempo que se fizer necessário, quando, na qualidade
de representante de entidade sindical, estiver participando de reunião oficial de organismo
internacional do qual o Brasil seja membro
29 Serviço Militar - Afastamento temporário para prestar serviço militar obrigatório;
30 Suspensão disciplinar - CLT, art. 474
31 Servidor Público em Disponibilidade

01  Acidente de trabalho
02  Novo afastamento em decorrência do mesmo acidente de trabalho
03  Doença
04  Novo afastamento em decorrência da mesma doença, dentro de 60 dias contados da cessação do afastamento anterior
05  Licença paternidade;
06  Licença maternidade (120 dias)
07  Licença maternidade - (a partir de 120 dias até 180 dias) 08 Licença maternidade decorrente de adoção ou guarda judicial de criança até 1 (um) ano de idade (120 dias)
09  Licença maternidade decorrente de adoção ou guarda judicial de criança a partir de 1 (um) ano até 4 (quatro) anos de idade (60 dias)
10  Licença maternidade decorrente de adoção ou guarda judicial de criança a partir de 4 (quatro) anos até 8 (oito) anos de idade (60 dias)
11  Aborto não criminoso;
12  Prestação de Serviço Militar
13  Exercício de mandato sindical
14  Licença sem Vencimentos;
15  Exercício de mandato eleitoral;
16  Participação de curso ou programa de qualificação - Art 476A da CLT
17  Aposentadoria por Invalidez;
18  Gozo de férias;
19  Cessão de Trabalhador
20  Cárcere;
99  Outros Motivos de afastamento temporário.
*/

mSITU:=&eSITU.
IF EMPTY(mSITU)
   RETU .T.
ENDIF
SCR_SIT=SAVESCREEN(22,00,24,79)
IF EMPTY(mSITU) .AND. ! EMPTY(&Evale.)
   IF MDG("Confirmar não receber adiantamento")
   ELSE
      &evale.:=""
   ENDIF
ENDIF
IF EMPTY(mSITU)
   RESTSCREEN(22,00,24,79,SCR_SIT)  
   RETURN .T.
ENDIF
IF mSITU="S"
   &eSITU.:="01"
ENDIF
IF mSITU="I"
   &eSITU.:="03"   
ENDIF
IF mSITU="E"
   &eSITU.:="12"
ENDIF
IF mSITU="M"
   &eSITU.:="06"
ENDIF
IF mSITU="S" .OR.  mSITU="01"   
   &eRAIS.:="2"
ENDIF
IF mSITU="I" .OR.  mSITU="03"   
   &eRAIS.:="5"
ENDIF
IF mSITU="E" .OR.  MSITU="12"   
   &eRAIS.:="3"
ENDIF
IF mSITU="M" .OR.  MSITU="06"   
   &eRAIS.:="4"
ENDIF
IF MDG('Confirme Situação Especial')   
   IF MDG("Marcar para não receber adiantamento")   
      &EVALE.:="S"
   ENDIF
   RESTSCREEN(22,00,24,79,SCR_SIT)  
   RETURN CHECKTAB("SITU"+PADR(mSITU,5),24,0,"Situação não Cadastrado")
ENDIF
RESTSCREEN(22,00,24,79,SCR_SIT)
RETURN .T.

FUNCTION VALOCO(eOCO,eCAMPO)
cOCO:=&eoco.
DO CASE
      CASE coco="0" .OR. coco="1" .OR. coco="5" .OR. EMPTY(coco)
           &eCAMPO.:="1"      //nao exposto
     	CASE coco="4" .OR. coco="8"
      		&eCAMPO.:="2"      //25 anos
     	CASE coco="3" .OR. coco="7"
      		&eCAMPO.:="3"     //20 anos
     	CASE coco="2" .OR. coco="6"
      	  &eCAMPO.:="4"     //15 anos
ENDCASE
return .t.

FUNCTION CorrigeEndereco(eENDER,eENDNUM,eENDCOMPL,eENDTIP)
local  cENDER,cENDNUM,cENDCOMPL,cENDTIP,nLEN,aCNV,nFIM,X,nLENEND

aCNV:=aconvertend()


cENDER   :=&eENDER.
nLENEND:=LEN(cENDER)
cENDER:=ALLTRIM(cENDER)
cENDNUM  :=aLLTRIM(&eENDNUM.)
cENDCOMPL:=aLLTRIM(&eENDCOMPL.)
cENDTIP:=aLLTRIM(&eENDTIP.)
cENDER:=STRTRAN(cENDER,cENDNUM,"")
cENDER:=STRTRAN(cENDER,cENDCOMPL,"")
cENDER:=STRTRAN(cENDER,","," ")
cENDER:=STRTRAN(cENDER,"  "," ") //duplo espacos
IF ! EMPTY(cENDTIP)
   &eENDER.:=PADR(cENDER,nLENEND)
   RETURN cENDER
ENDIF

nFIM:=LEN(ACNV)
for x=1 to nFIM
    IF EMPTY(cENDTIP)
       nLEN:=LEN(aCNV[X,1])
       if aCNV[X,1]=SUBSTR(cENDER,1,NlEN)
          cENDER:=alltrim(SUBSTR(cENDER,NlEN+1))
          &eENDTIP.:=aCNV[X,2]
       endif
    ENDIF    
next x
&eENDER.:=PADR(cENDER,nLENEND)
RETURN cENDER
/*
01 - Analfabeto
02 - Até a 4ª série incompleta do ensino fundamental (antigo 1ºgrau ou primário), ou que tenha se alfabetizado sem terfrequentado escola regular.
03 - 4ª séria completa do ensino fundamental (antigo 1º grau ou rimário)
04 - Da 5ª a 8ª série do ensino fundamental (antigo 1º grau ou ginásio)
05 - Ensino fundamental completo (antigo 1º grau, primário ou ginásio)
06 - Ensino médio incompleto (antigo 2º grau, secundário ou colegial)
07 - Ensino médio completo (antigo 2º grau, secundário ou colegial)
08 - Educação superior incompleta
09 - Educação superior completa
10 - Pós Graduação
11 - Mestrado
12 - Doutorado
*/

FUNCTION BacenNacion(cBACEN)
nNACION:=0
IF cBACEN="1058"
   nNACION:="10"
ELSE
   nNACION:=VAL(OBTER( "FO_TAB",,"NACI"+cBACEN, "CODIGO", 2))   
ENDIF
RETURN nNACION

*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
*+
*+    Function iFOPTO4E() 
*+
*+ÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ
*+
function iFOPTO4E(lPEGCHAVE)
IF lPEGCHAVE
   PEGCHAVE("mNUMERO",ULTIMOREG(PES,"NUMERO",.T.),"Numero:")
   if verseha(PES,,mNUMERO,,,.F.,) //quando usado como crtl+enter busca
      return .f.
   endif
ENDIF   
HB_dispbox( 4, 0, 23, 79,B_DOUBLE+" ")
@  5,  2 say "Nome           :"
@  7, 02 SAY "CPF            :"
@  9, 38 say "PIS            :"
@ 11, 22 say "Data Nascimento:"
@  5, 15 GET mNOME VALID ! EMPTY(mNOME)
@  7,06 GET mCPF      PICTURE "999.999.999-99" VALID VALCPF(mCPF)
@  9,43 get mPIS     VALID VALPIS(mPIS) .OR. MDG("Pis em Branco Primeiro Emprego") 
@ 11,12 GET mNASC    VALID ! EMPTY(mNASC)
RETURN READCUR()

*: FIM: FO7A.PRG



