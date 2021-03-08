*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : m_a7a.prg
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

// *
// * Carta de Corre‡„o
// *
//Teclas Operacionais
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"

//Modo de Trabalho no Video
MDI(" Ý Carta de Corre‡„o")

//Pegando Cores de Trabalho
PRIV PAD001,PAD002,PAD005,PAD006,PAD007,MA7A01
CORARR({"MAM401","MAM402","MAM405","MAM406","MAM407","MA7A01"},;
 {"PAD001","PAD002","PAD005","PAD006","PAD007","MA7A01"})


CRIARVARS("MM03")
CRIARVARS("MA01")
cDESC1    := "nossa"
cTIPO     := "C"
cENDERECO := PADR(IMP("ZEND")+" - "+IMP("ZBAR")+" - CEP "+IMP("ZCEP")+" - S.P.",80)
nNUMERO   := 0
dDATA     := ZDATA
dDATA2    := ZDATA
cNOTA     := SPACE(10)
cSERIE    := SPACE(10)
nERRO1    := nERRO2 := nERRO3 := nERRO4 := nERRO5 := 0
nERRO6    := nERRO7 := nERRO8 := nERRO9 := nERRO10 := 0
aERRO     := ARRAY(10,10)
TELASAY("MA7A01")
EDITSAY("MA7A01")



IF !IGUALVARS(ARQUSO,nNUMERO)
   ALERTX("Codigo Cliente/Fornec./Transp. n„o Cadastrado")
   RETU .F.
ENDIF


aERRO[ 1, 10 ]  := nERRO1
aERRO[ 2, 10 ]  := nERRO2
aERRO[ 3, 10 ]  := nERRO3
aERRO[ 4, 10 ]  := nERRO4
aERRO[ 5, 10 ]  := nERRO5
aERRO[ 6, 10 ]  := nERRO6
aERRO[ 7, 10 ]  := nERRO7
aERRO[ 8, 10 ]  := nERRO8
aERRO[ 9, 10 ]  := nERRO9
aERRO[ 10, 10 ] := nERRO10



FOR X := 1 TO 10
   IF !EMPTY(aERRO[X ,  10])
      IGUALVARS("MM03",aERRO[X ,  10])
      TELASAY("MAM401")
      EDITSAY("MAM401")
      aERRO[ X, 01 ] := mLIN01
      aERRO[ X, 02 ] := mLIN02
      aERRO[ X, 03 ] := mLIN03
      aERRO[ X, 04 ] := mLIN04
      aERRO[ X, 05 ] := mLIN05
      aERRO[ X, 06 ] := mLIN06
      aERRO[ X, 07 ] := mLIN07
      aERRO[ X, 08 ] := mLIN08
      aERRO[ X, 09 ] := mDESMENS
   ENDIF
NEXT X

nCOPIA := 1
MDS("Digite o Numero de Copias")
@ 24,40 GET nCOPIA         
READCUR()

IF !CHECKIMP(0)
   RETU .F.
ENDIF

IMPRESSORA()
FOR Z := 1 TO nCOPIA
   @ PROW()+ 1,0 SAY PADR(ACENTO("ITAESBRA  Ind£stria Mecƒnica Ltda."),80)                                                                              
   @ PROW(), 0   SAY PADR(ACENTO("ITAESBRA  Ind£stria Mecƒnica Ltda."),80)                                                                              
   @ PROW()+ 1,0 SAY ACENTO("-----------------------------------------------------------------------------")                                            
   @ PROW()+ 1,0 SAY ACENTO("C.G.C. 61.381.323/0001-67   Inscricao 103.689.678.113")                                                                    
   @ PROW()+ 1,0 SAY ACENTO(cENDERECO)                                                                                                                  
   @ PROW()+ 1,0 SAY ACENTO("Telefone:(11)6948-8899 - Fax:(11)6948-8883")                                                                             
   @ PROW()+ 1,0 SAY ACENTO("=============================================================================")                                            
   @ PROW()+ 2,0 SAY ACENTO("                              S„o Paulo, "+STRZERO(DAY(dDATA),2)+" de "+CMES(dDATA)+" de "+STRZERO(YEAR(dDATA),4))         
   @ PROW()+ 2,0 SAY ACENTO(mNOME)                                                                                                                      
   @ PROW()+ 1,0 SAY ACENTO(mEndereco)                                                                                                                  
   @ PROW()+ 1,0 SAY ACENTO(mCIDADE)+" - "+mESTADO                                                                                                      
   @ PROW()+ 1,0 SAY ACENTO(mCEP)                                                                                                                       
   @ PROW()+ 2,0 SAY ACENTO("Prezados Senhores:-")                                                                                                      
   @ PROW()+ 2,0 SAY ACENTO("Comunicamos a V.Sa. que a "+cDESC1+" Nota Fiscal de nr. "+cNOTA+IF(EMPTY(cSERIE),""," S‚rie "+cSERIE))                     
   @ PROW()+ 1,0 SAY ACENTO("Data de "+DTOC(dDATA2)+" , a nosso entender, deixou de atender a legisla‡„o fiscal,")                                      
   @ PROW()+ 1,0 SAY ACENTO("e para sua regulariza‡„o informamos:")                                                                                     
   @ PROW()+ 1,0 SAY ACENTO("-----------------------------------------------------------------------------")                                            
   @ PROW()+ 1,0 SAY ACENTO("                  RETIFICA€™ES A SEREM CONSIDERADAS")                                                                      
   @ PROW()+ 1,0 SAY ACENTO("-----------------------------------------------------------------------------")                                            
   FOR X := 1 TO 10
      IF !EMPTY(aERRO[X ,  10])
         @ PROW()+ 1,0 SAY ACENTO(STR(aERRO[X,10])+" - "+aERRO[X,09])         
         FOR Y := 1 TO 8
            IF !EMPTY(aERRO[X ,  Y])
               @ PROW()+ 1,5 SAY ACENTO(aERRO[X,Y])         
            ENDIF
         NEXT Y
      ENDIF
   NEXT X
   @ PROW()+ 1,0 SAY ACENTO("-----------------------------------------------------------------------------")         
   @ PROW()+ 1,0 SAY ACENTO("Assim sendo, Solicitamos:")                                                             
   @ PROW()+ 1,0 SAY ACENTO("1. Devolverem copia da Presente devidamente protocolada.")                              
   @ PROW()+ 1,0 SAY ACENTO("2. Efetuarem as corre‡”es nos itens assinalados.")                                      
   @ PROW()+ 1,0 SAY ACENTO("3. Enviarem Nota Fiscal Complementar  (Se for o Caso)")                                 
   @ PROW()+ 1,0 SAY ACENTO("   Carta Emitida na forma do art.173, paragrafo 3. do decreto 87981/82 (RIPI)")         
   @ PROW()+ 1,0 SAY ACENTO("pelo n„o entendimento ao disposto no art.83, decreto 17727/81(RICM).")                  
   @ PROW()+ 1,0 SAY ACENTO("=============================================================================")         
   @ PROW()+ 1,0 SAY ACENTO("                           DECLARA€ŽO")                                                 
   @ PROW()+ 1,0 SAY ACENTO("    Declaramos, a quem possa - interessar, que os valores referentes aos")              
   @ PROW()+ 1,0 SAY ACENTO("Impostos (IPI e ICM) foram lan‡ados em nossos livros fiscais obedecendo as")            
   @ PROW()+ 1,0 SAY ACENTO("corre‡”es Mencionadas.")                                                                
   @ PROW()+ 2,0 SAY ACENTO("Atenciosamente        ITAESBRA IND—STRIA MECANICA LTDA")                                
   @ PROW()+ 2,0 SAY ACENTO("                      ________________________________")                                
   @ PROW()+ 1,0 SAY ACENTO("                             Depto Fiscal")                                             
   @ PROW()+ 1,0 SAY ACENTO("=============================================================================")         
   @ PROW()+ 1,0 SAY ACENTO("---------------------- Acusamos o Recebimento da 1a. Via --------------------")         
   @ PROW()+ 1,0 SAY ACENTO("|                                                                           |")         
   @ PROW()+ 1,0 SAY ACENTO("| _____________________, ____/____/____ ___________________________________ |")         
   @ PROW()+ 1,0 SAY ACENTO("| LOCAL                  DATA             CARIMBO E ASSINATURA              |")         
   @ PROW()+ 1,0 SAY ACENTO("-----------------------------------------------------------------------------")         
   IMPFOL()
NEXT Z
VIDEO()
IMPEND()
