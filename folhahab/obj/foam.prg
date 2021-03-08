*:*****************************************************************************
*:
*:       FOAM.PRG: Ocorrencias Coletivas
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/08/94      8:59
*:
*:*****************************************************************************


CABEX('Cadastramento de Ocorrencias Coletivas')

CRIARVARS("FO_OCO")
tFOAL(.F.)
gFOAL(.F.)
xFOAL(1)



IF ! netuse(pes) //AREDE(PES,PES,1)
   RETU
ENDIF
FILTRO=''
FI=TRIM(FILTRO)
FILTRO=FILTRO(FI)
SET FILTER TO &FILTRO

IF ! netuse("FO_OCO") //AREDE("FO_OCO","FO_OCO",0)
   DBCLOSEALL()
   RETU
ENDIF

@ 08,00 CLEA
MDS('Aguarde Cadastrando Dados')
DBSELECTAR(PES)
DBGOTOP()
WHILE ! EOF()
   PETELA(7)
   mDEPTO:=DEPTO
   mSETOR:=SETOR
   mSECAO:=SECAO
   mCHAPA:=CHAPA
   mNOMEF:=NOME
   mNUMERO:=NUMERO
   mBUSCA:=STR(mNUMERO,8)+DTOS(mDATASAIDA)
   DBSELECTAR("FO_OCO")
   IF ! DBSEEK(mBUSCA)
      netrecapp()
      REPLVARS()
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
DBCLOSEALL()


*: FIM: FOAM.PRG
