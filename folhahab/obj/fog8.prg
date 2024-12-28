*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fog8.prg
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
// :       FOG8.PRG: COMPENSACAO DE HORAS
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1994,  SOFTEC  S/C Ltda.
// :  Atualizado em: 04/18/94     11:44
// :
// :*****************************************************************************
////#INCLUDE "COMANDO.CH"

IF !MDL('Imprimir compensa‡„o de Horas',0)
   RETU
ENDIF
CTR    := 0
N      := cIMPNEG
M      := cIMPNER
TITULO := SPAC(60)
MDS('Digite o prazo')
@ 24,20 GET TITULO         
IF !READCUR()
   RETU .F.
ENDIF

if !NETUSE(pes)
   dbcloseall()
   retu
endif
FILTRO := ''
INX    := ""
FILORD(.T.)
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
if valtype(INX) = "N"
   dbsetorder(INX)
ELSE
   ordDestroy("temp")
   ordcreate(,"temp",inx)
   ordSetFocus("temp")
ENDIF
set filter to &FILTRO

IF !NETUSE("FO_HOR")
   RETU
ENDIF

IMPRESSORA()
DBSELECTAR(PES)
DBGOTOP()
WHILE !EOF()
   CTR := NUMERO
   FOR X := 1 TO 2
      @ PROW()+ 2,10 SAY ACENTO('ACORDO PARA COMPENSA€ŽO DE HORAS DE TRABALHO')                                                                                                                                                                       
      @ PROW()+ 2,10 SAY ACENTO(cid1+N+DTOC(dxdia)+M)                                                                                                                                                                                                 
      @ PROW()+ 2,0  SAY ACENTO('Pelo Presente acordo de compensa‡„o de horas firmado entre a firma')                                                                                                                                                 
      @ PROW()+ 1,0  SAY ACENTO(N+MSG2+M)                                                                                                                                                                                                             
      @ PROW()+ 1,0  SAY ACENTO('sita: '+N+ender1+' - '+bai1+' - '+ALLTRIM(cid1)+M+' Estado '+N+est1+M)                                                                                                                                               
      @ PROW()+ 1,0  SAY ACENTO('e o seu empregado '+N+NOME+M+' abaixo assinado ')                                                                                                                                                                    
      @ PROW()+ 1,0  SAY ACENTO('portador da Carteira Profissional No.: ')+N+IF(left(TIRAOUT(CPF),7) = PROFIS,LEFT(TIRAOUT(CPF),7),PROFIS)+M+' SERIE: '+N+IF(left(TIRAOUT(CPF),7) = PROFIS,SUBSTR(TIRAOUT(CPF),8),SERIE)+M+' UF: '+N+CTPSUF+M         
      @ PROW()+ 1,0  SAY ACENTO('fica convencionado, com base no que faculta a legislacao, que   o')                                                                                                                                                  
      @ PROW()+ 1,0  SAY ACENTO('hor rio normal de trabalho ser  o seguinte')                                                                                                                                                                         
      DBSELECTAR("FO_HOR")
      DBGOTOP()
      IF DBSEEK(CTR)
         @ PROW()+ 2,0 SAY ACENTO('Segunda: '+N+d1+M)         
         @ PROW()+ 1,0 SAY ACENTO('Terca  : '+N+d2+M)         
         @ PROW()+ 1,0 SAY ACENTO('Quarta : '+N+d3+M)         
         @ PROW()+ 1,0 SAY ACENTO('Quinta : '+N+d4+M)         
         @ PROW()+ 1,0 SAY ACENTO('Sexta  : '+N+d5+M)         
         @ PROW()+ 1,0 SAY ACENTO('Sabado : '+N+d6+M)         
         @ PROW()+ 1,0 SAY ACENTO('Domingo: '+N+d7+M)         
      ENDIF
      DBSELECTAR(PES)
      @ PROW()+ 2,0 SAY ACENTO('Perfazendo um total de '+N+STR(HRSEM)+M+'________ horas semanais')         
      @ PROW()+ 2,0 SAY ACENTO('E  por  estarem de pleno acordo, as partes contratantes')                  
      @ PROW()+ 1,0 SAY ACENTO('assinam o presente acordo em duas vias, o qual vigorar ')                  
      @ PROW()+ 1,0 SAY ACENTO('ate '+TITULO)                                                              
      @ PROW()+ 2,0 SAY 'Empregador : _____________________________________'                               
      @ PROW()+ 2,0 SAY 'Empregado  : _____________________________________'                               
      IF X = 1
         @ PROW()+ 2,0 SAY REPL('-',80)         
      ENDIF
   NEXT X
   impfol()
   DBSKIP()
ENDDO
DBCLOSEALL()
VIDEO()
IMPEND()
RETU

// : FIM: FOG8.PRG

*+ EOF: fog8.prg
*+
