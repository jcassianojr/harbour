*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fohs.prg
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
// :       FOHH.PRG: Guia de Contribui‡„o ao Sindicato
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  SOFTEC  S/C Ltda.
// :  Atualizado em: 30/06/98
// :
// :*****************************************************************************

////#INCLUDE "COMANDO.CH"

IF ARQ = 9 .OR. ARQ = 10
   MDT('Use a opcao Folha de Pagamento')
   RETU
ENDIF
IF ARQ = 6
   ALERTX("Nao Disponivel VT")
   RETU .F.
ENDIF


IF !MDL('Rela‡„o de Contribui‡„o ao Sindical',0)
   RETU .F.
ENDIF


TIPATIV := OBTER("FIRMA",,NREMP,"ATIDES")

CTA := 630
@ 24,00 SAY "Confirme a Conta"                    
@ 24,60 GET CTA                PICT '####'        
IF !READCUR()
   RETU .F.
ENDIF

IF !ARQCTA(ARQ)
   DBCLOSEALL()
   RETU .F.
ENDIF
DBGOTOP()
if !DBSEEK(CTA)
   DBCLOSEALL()
   ALERTX("Conta N„o Cadastrada")
   RETU .F.
ENDIF
DBCLOSEALL()

xDATA := DXDIA
MDS("Confirme data de Vencimento")
@ 24,40 GET xDATA         
READCUR()
xANO := ANOWORK
MDS("Confirme Ano de Competencia")
@ 24,40 GET xANO         
READCUR()

IF !ARQUSAR(ARQ,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE1 := ALIAS()

TOTFUN := 0
IF !ARQPES(ARQ,1,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
FILTRO := FILTRO("")
DBGOTOP()
WHILE !EOF()
   IF ((EMPTY(DEMITIDO)) .OR. (MONTH(DEMITIDO) >= MES .AND. YEAR(DEMITIDO) >= ANO))
      TOTFUN ++
   ENDIF
   DBSKIP()
ENDDO
SET FILTER TO &FILTRO
cSELE2 := ALIAS()

IF !NETUSE("SINDICAT")  //AREDE("SINDICAT","SINDICAT",1)
   DBCLOSEALL()
   RETU .F.
ENDIF


IMPRESSORA()
DBSELECTAR("SINDICAT")
DBGOTOP()
WHILE !EOF()
   mCODIGO   := CODIGO
   mNOME     := NOME
   mCGC      := CGC
   mTELEFONE := TELEFONE
   mENDERECO := ENDERECO
   mBAIRRO   := BAIRRO
   mESTADO   := ESTADO
   mCIDADE   := CIDADE
   mCEP      := CEP
   mENTIDADE := ENTIDADE
   TOTREC    := CONT := CONTT := 0
   FOHHS()
   DBSELECTAR("SINDICAT")
   DBSKIP()
ENDDO
DBCLOSEALL()
VIDEO()
IMPEND()
RETU

// !*****************************************************************************
// !
// !         Fun‡„o: FOHHS()
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOHHS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC FOHHS

DBSELECTAR(cSELE2)
DBGOTOP()
WHILE !EOF()
   CTR := NUMERO
   IF SINDICATO = mCODIGO
      DBSELECTAR(cSELE1)
      VALF := VALCTA(CTR,CTA)
      IF VALF # 0
         TOTREC += VALF
         CONT ++
      ENDIF
   ENDIF
   DBSELECTAR(cSELE2)
   DBSKIP()
ENDDO
IF TOTREC > 0
   DBSELECTAR("SINDICAT")
   @ PROW()+ 5,77 SAY CGC1                                   
   @ PROW()+ 2,77 SAY xDATA                                  
   @ PROW(),92    SAY xANO                                   
   @ PROW()+ 3,03 SAY mNOME                                  
   @ PROW(),77    SAY mENTIDADE                              
   @ PROW()+ 2,03 SAY mENDERECO                              
   @ PROW(),77    SAY mCGC                                   
   @ PROW()+ 2,03 SAY mBAIRRO                                
   @ PROW(),40    SAY mCEP                                   
   @ PROW(),54    SAY mCIDADE                                
   @ PROW(),91    SAY mESTADO                                
   @ PROW()+ 3,03 SAY MSG2                                   
   @ PROW()+ 2,03 SAY ENDER1                                 
   @ PROW()+ 2,03 SAY CEP1                                   
   @ PROW(),19    SAY CID1                                   
   @ PROW(),54    SAY BAI1                                   
   @ PROW(),91    SAY EST1                                   
   @ PROW()+ 2,03 SAY TIPATIV                                
   @ PROW(),28    SAY ATIV1                                  
   @ PROW(),60    SAY "X"                                    
   @ PROW()+ 3,36 SAY "X"                                    
   @ PROW(),78    SAY TOTREC                                 
   @ PROW()+ 2,44 SAY CONT                                   
   @ PROW()+ 4,44 SAY TOTFUN                                 
   @ PROW()+ 2,44 SAY TOTFUN - CONT                          
   @ PROW(),78    SAY TOTREC                                 
   @ PROW()+10,03 SAY "" //Ajuste Tamanho Formulario         
ENDIF
RETU .T.


// : FIM: FOHS.PRG

*+ EOF: fohs.prg
*+
