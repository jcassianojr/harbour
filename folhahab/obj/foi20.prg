*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foi20.prg
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
// :      FOI20.PRG: Apurando Depto/Setor/Se‡„o
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/25/98     12:12
// :
// :*****************************************************************************


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function foi20()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function foi20

PARA CCARQ
CABEX('Apurando Depto/Setor/Se‡„o ')
IF !ARQUSAR(CCARQ,1)
   RETU .F.
ENDIF
cSELE1 := ALIAS()

IF !ARQPES(CCARQ,1,1)
   RETU
ENDIF
cSELE2 := ALIAS()

IF !ARQCTA(CCARQ,1,1)
   RETU
ENDIF
cSELE3 := ALIAS()


IF MDG('Deseja Apagar acumulo anterior')
   NETZAP("APUDEPTO")
ENDIF

IF !NETUSE("APUDEPTO")  //AREDE("APUDEPTO","APUDEPTO",0)
   RETU
ENDIF


IF !NETUSE("DEPTO")   //AREDE("DEPTO","DEPTO",1)
   RETU
ENDIF
MDS('Acumulando dados')
DECLARE BUSCA[3]
DBSELECTAR(cSELE1)
DBGOTOP()
WHILE !EOF()  //LOOP FOLHA
   NR1 := NUMERO
   DBSELECTAR(cSELE2)
   DBGOTOP()
   IF !DBSEEK(NR1)  //VERIFICA FUNCIONARIO
      MDT('Falta Cadastramento Funcionario: '+STR(NR1,4))
      DBCLOSEALL()
      RETU
   ENDIF
   PETELA(10)
   DEP := DEPTO
   SET := SETOR
   SEC := SECAO
   VER := DEPTO * 1000000+SETOR * 1000+SECAO
   DBSELECTAR("DEPTO")
   DBGOTOP()
   IF !DBSEEK(VER)  //VERIFICA CENTRO CUSTO
      DBCLOSEALL()
      MDG('Falta Cadastramento de Centro de Custo')
      RETU .F.
   ENDIF
   DBSELECTAR(cSELE1)
   WHILE NUMERO = NR1 .AND. !EOF()  //LOOP DE ACUMULACAO
      CTA := CONTA
      HOR := HORAS
      VAL := VALOR
      BUSCA[1] = DEP * 1000000000+CTA
      BUSCA[2] = DEP * 1000000000+SET * 1000000+CTA
      BUSCA[3] = DEP * 1000000000+SET * 1000000+SEC * 10000+CTA
      FOR Q := 1 TO 3
         DBSELECTAR("APUDEPTO")
         DBGOTOP()
         IF !DBSEEK(BUSCA[Q])
            netrecapp()
            FIELD->DEPTO    := DEP
            FIELD->SETOR    := IF(Q = 1,0,SET)
            FIELD->SECAO    := IF(Q = 3,SEC,0)
            FIELD->CONTA    := CTA
            FIELD->CONTROLE := BUSCA[Q]
         else
            netreclock()
         ENDIF
         FIELD->HORAS := HORAS+HOR
         FIELD->VALOR := VALOR+VAL
      NEXT Q
      DBSELECTAR(cSELE1)
      DBSKIP()
   ENDDO
ENDDO
DBCLOSEALL()

IF !netuse("APUDEPTO")  //AREDE("APUDEPTO","APUDEPTO",0)
   RETU
ENDIF
FODZER()
DBCLOSEALL()
RETU

// : FIM: FOI20.PRG

*+ EOF: foi20.prg
*+
