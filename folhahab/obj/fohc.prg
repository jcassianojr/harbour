*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fohc.prg
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
// :      FOHC .PRG: Guia Inss Por Departamento
// :      Linguagem: Clipper 5.x
// :        Sistema:
// :          Autor: Equipe Disk
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 05/02/94     17:15
// :
// :     Documentado 05/13/94 em 14:06                DISK!  vers„o 5.01
// :*****************************************************************************
//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"

IF ARQ = 9 .OR. ARQ = 10
   MDT('Use a op‡„o Folha')
   RETU
ENDIF
IF ARQ = 6
   ALERTX("Nao Disponivel VT")
   RETU .F.
ENDIF



IF MDG("Deseja Reacumular")
   lZERAR := MDG("Zerar Acumulo Anterior")
   aCOD   := {}
   aTIP   := {}
   aPER   := {}
   MDS("Carregando Configura‡„o da Conta")
   IF !ARQCTA(ARQ)
      DBCLOSEALL()
      RETU .F.
   ENDIF
   DBGOTOP()
   WHILE !EOF()
      IF GUIA_IAPAS # 1
         AADD(aCOD,CODIGO)
         AADD(aTIP,GUIA_IAPAS)
         AADD(aPER,IF(ARQ = 8,BASERED,100))
      ENDIF
      DBSKIP()
   ENDDO
   DBCLOSEALL()

   IF LEN(aCOD) = 0
      ALERTX("Nenhuma Conta Configurada")
      RETU .F.
   ENDIF
   IF !ARQUSAR(ARQ,1)
      DBCLOSEALL()
      RETU .F.
   ENDIF
   cSELE1 := ALIAS()

   IF !ARQPES(ARQ,1,1)
      DBCLOSEALL()
      RETU .F.
   ENDIF
   cSELE2 := ALIAS()

   IF !netuse("depto")  //AREDE("DEPTO","DEPTO",0)
      RETU
   ENDIF
   IF lZERAR
      MDS("Zerando Acumulo Anterior")
      DBGOTOP()
      WHILE !EOF()
         netreclock()
         FIELD->TOTBAS := 0
         FIELD->TOTREC := 0
         FIELD->TOTDED := 0
         FIELD->TOTFUN := 0
         dbunlock()
         DBSKIP()
      ENDDO
   ENDIF

   MDS("Acumulando Dados")
   DBSELECTAR(cSELE2)   //Funcionarios
   DBGOTOP()
   WHILE !EOF()
      PETELA(8)
      mNUMERO := NUMERO
      mDEPTO  := DEPTO
      mSETOR  := SETOR
      mSECAO  := SECAO
      mTOTBAS := 0
      mTOTREC := 0
      mTOTDED := 0
      mADCACI := 0
      DBSELECTAR(cSELE1)  //Folha de Pagamento
      DBGOTOP()
      DBSEEK(mNUMERO * 10000)
      WHILE NUMERO = mNUMERO .AND. !EOF()
         nPOS := ASCAN(aCOD,CONTA)
         IF nPOS > 0
            mGUIA  := aTIP[nPOS]
            mVALOR := VALOR
            IF ARQ = 8  //RPA
               mVALOR := ROUND(mVALOR * aPER[nPOS],2)
            ENDIF
            mTOTBAS += IF(mGUIA = 0 .OR. mGUIA = 5,mVALOR,0)
            mTOTBAS -= IF(mGUIA = 2,mVALOR,0)
            mTOTREC += IF(mGUIA = 3,mVALOR,0)
            mTOTDED += IF(mGUIA = 4 .OR. mGUIA = 5,mVALOR,0)
            mADCACI += IF(mGUIA = 6,mVALOR,0)
         ENDIF
         DBSKIP()
      ENDDO
      aCHAVE := {mDEPTO * 1000000,;
       mDEPTO * 1000000+mSETOR * 1000,;
       mDEPTO * 1000000+mSETOR * 1000+mSECAO}
      DBSELECTAR("DEPTO")   //Depto
      FOR X := 1 TO 3
         DBGOTOP()
         IF DBSEEK(aCHAVE[X])
            netreclock()
            FIELD->TOTBAS := TOTBAS+mTOTBAS
            FIELD->TOTREC := TOTREC+mTOTREC
            FIELD->TOTDED := TOTDED+mTOTDED
            FIELD->TOTADI := TOTADI+mADCACI
            FIELD->TOTFUN := TOTFUN+1
            dbunlock()
         ENDIF
      NEXT X
      DBSELECTAR(cSELE2)  //Retornando Funcion rios
      DBSKIP()
   ENDDO
   DBCLOSEALL()
ENDIF


@ 07,00 CLEA
OPCAO(13,35,' &Departamento ',68)
OPCAO(14,35,' &Setor        ',83)
OPCAO(15,35,' se&C‡„o       ',67)
OP := MENU(1,0)
DO CASE
CASE OP = 1 
   FILTRO := 'SETOR=0.AND.SECAO=0'
CASE OP = 2 
   FILTRO := 'SECAO=0'
OTHERWISE 
   FILTRO := 'SETOR<>0.AND.SECAO<>0'
ENDCASE

@ 13,00 CLEA
PERLABO := PERAUTO := 0
cMES    := STRZERO(MESTRAB,2)
cANO    := STRZERO(ANO,4)
cTIP    := "R"
mPAGGPS := "2100"
set key K_F11 to TECLAF11
@ 12,00      SAY "(R)esumo (P)rps (G)ps"                                                                                             
@ 13,14      SAY "DIGITE O % PRO-LABORE"                                                                                             
@ 14,14      SAY "DIGITE O % AUTONOMO"                                                                                               
@ 16,14      SAY "Competencia"                                                                                                       
@ 17,14      SAY "Cod. Pagto"                                                                                                        
@ 12,56      GET cTIP                    VALID cTIP $ "RPG"                                                           PICT "!"       
@ 13,56      GET PERLABO                 PICT '##.##'                                                                                
@ 14,56      GET PERAUTO                 PICT '##.##'                                                                                
@ 16,66      GET cMES                                                                                                                
@ 16,COL()+1 GET cANO                                                                                                                
@ 17,66      GET mPAGGPS                 VALID VERSEHA("TBCODPG",,mPAGGPS,"NOME",'"Codigo Pagamento N„o Cadastrado"')                
READCUR()
set key K_F11

lGRA := MDG("Gravar Resultados- Apura‡„o Contabil")

IF !CHECKIMP(0)
   RETU .F.
ENDIF
IF !NETUSE("DEPTO")   //AREDE("DEPTO","DEPTO",1)
   RETU
ENDIF
FILTRO := FILTRO(FILTRO)
SET FILTER TO &FILTRO.

IF lGRA
   IF !NETUSE("GINSSD")   //AREDE("GINSSD","GINSSD",0)
      DBCLOSEALL()
      RETU .F.
   ENDIF
ENDIF


IMPRESSORA()
DBSELECTAR("DEPTO")
DBGOTOP()
WHILE !EOF()
   LABO     := ROUND(TOTAUT * PERAUTO / 100,2)+ROUND(TOTLAB * PERLABO / 100,2)
   EMPRESA  := ROUND((TOTBAS) * (TXEMP / 100),2)
   EMPRESA  += LABO
   ACIDENT  := ROUND(TOTBAS * (TXSEG / 100),2)
   EMPRESA1 := ACIDENT+EMPRESA+TOTADI
   TERCEIRO := ROUND(TOTBAS * (TXTER / 100),2)
   SOMA     := TOTREC+EMPRESA1+TERCEIRO
   LIQUIDO  := SOMA - TOTDED
   QTFUN    := TOTFUN
   BASEINPS := TOTBAS
   PROLABO  := TOTLAB
   PROAUTO  := TOTAUT
   JUROS    := ATUAL := 0.00
   TOTDEDU  := TOTDED
   TOTRECO  := TOTREC
   TOTAL    := 0
   TXSEGU   := TXSEG
   TXEMPRE  := TXEMP
   TXTERCE  := TXTER
   TERCE    := ""
   VIDEO()
   FOHA04(STR(DEPTO)+"-"+STR(SETOR)+"-"+STR(SECAO)+"-"+NOME)
   IMPRESSORA()
   DO CASE
   CASE cTIP = "R" 
      FOHA01(2)
   CASE cTIP = "P" 
      FOHA02(2)
   CASE cTIP = "G" 
      FOHA03(2)
   ENDCASE
   IMPFOL()
   IF lGRA
      mVALREC   := TOTREC
      mVALEMP   := EMPRESA1
      mVALTER   := TERCEIRO
      mVALDED   := TOTDED
      mVALLIQ   := LIQUIDO
      mDEPTO    := DEPTO
      mSETOR    := SETOR
      mSECAO    := SECAO
      mCONTROLE := STRZERO(mDEPTO,4)+STRZERO(mSETOR,3)+STRZERO(mSECAO,3)+STRZERO(VAL(cANO),4)+STRZERO(VAL(cMES),2)
      DBSELECTAR("GINSSD")
      DBGOTOP()
      DBSEEK(mCONTROLE)
      IF !FOUND()
         netrecapp()
      else
         netreclock()
      ENDIF
      FIELD->VALREC   := mVALREC
      FIELD->VALEMP   := mVALEMP
      FIELD->VALTER   := mVALTER
      FIELD->VALDED   := mVALDED
      FIELD->VALLIQ   := mVALLIQ
      FIELD->MES      := VAL(cMES)
      FIELD->ANO      := VAL(cANO)
      FIELD->DEPTO    := mDEPTO
      FIELD->SETOR    := mSETOR
      FIELD->SECAO    := mSECAO
      FIELD->NUMEMP   := NREMP
      FIELD->CONTROLE := mCONTROLE
   ENDIF
   DBSELECTAR("DEPTO")
   DBSKIP()
ENDDO
DBCLOSEALL()
VIDEO()
IMPEND()

*+ EOF: fohc.prg
*+
