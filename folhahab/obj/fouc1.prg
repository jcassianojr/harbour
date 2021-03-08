*:*****************************************************************************
*:
*:      FOUC1.PRG: TERMO DE RESPONSABILIDADE
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/08/94     11:20
*:
*:  Procs & Fncts: FOUC1()
*:
*:          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
*:
*:     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
*:*****************************************************************************



CTR=0
CABEX('IMPRIMIR TERMO DE RESPONSABILIDADE')
MDS('Digite o numero do funcion rio')
@ 24,40 GET CTR PICT '#####'
READCUR()
IF MDG('Deseja detalhes em negrito')
   N=cIMPNEG 
   M=cIMPNER 
ELSE
   N=""
   m=""
ENDIF
IF ! netuse(pes) //AREDE(PES,PES,0)
   RETU
ENDIF
DBGOTOP()
if dbSEEK(CTR)
   SET DEVICE TO PRINT
   @ PROW(),1   SAY REPL('-',80)
   @ PROW()+1,1 SAY IMPCHR(cIMPTIT)
   @ PROW(),2   SAY 'TERMO DE RESPONSABILIDADE'
   @ PROW()+1,2 SAY '(CONSESSAO DE SALARIO FAMILIA PORTARIA No. MPAS - 3.040/82)'
   @ PROW()+1,1 SAY REPL('-',80)
   @ PROW()+1,1 SAY N+MSG2+M
   @ PROW(),60  SAY N+CGC+M
   @ PROW()+1,1 SAY 'NOME'
   @ PROW(),10  SAY N+NOME+M
   @ PROW()+1,1 SAY 'CTPS:'
   @ PROW(),10  SAY   N    +IF(left(TIRAOUT(CPF),7)=PROFIS,LEFT(TIRAOUT(CPF),7),PROFIS)   +' SERIE: '   +IF(left(TIRAOUT(CPF),7)=PROFIS,SUBSTR(TIRAOUT(CPF),8),SERIE)+' UF:'+CTPSUF +M
   @ PROW()+1,1 SAY REPL('-',80)
   @ PROW()+1,1 SAY 'BENEFICIARIOS'
   @ PROW()+1,1 SAY REPL('-',80)
   @ PROW()+1,1 SAY 'NOME'
   @ PROW(),50  SAY 'DATA DO NASCIMENTO'
   FOR X= 1 TO 10
      IF X > 9
         STORE STR(X,2) TO Y
      ELSE
         STORE STR(X,1) TO Y
      ENDIF
      STORE "DEPDAT"+Y TO DEPDAT
      STORE "DEPEND"+Y TO DEPEND
      STORE YEAR(&DEPDAT) TO ANOX
      IF ANOX <> 0
         STORE MONTH(&DEPDAT) TO MESX
         STORE ANO - ANOX TO ANOX
         STORE MES - MESX TO MESX
         IF MESX < 0
            STORE ANOX - 1 TO ANOX
         ENDIF
         IF ANOX < 14
            @ PROW()+1,1 SAY N+&DEPEND
            @ PROW(),50 SAY &DEPDAT
            @ PROW(),PCOL() SAY M
         ENDIF
      ENDIF
   NEXT X
   @ PROW()+1,1 SAY REPL('-',80)
   @ PROW()+1,1 SAY '      Pelo Presente TERMO DE RESPONSABILIDADE declaro estar ciente'
   @ PROW()+1,1 SAY 'de que deverei comunicar de imediato a ocorrencia dos seguintes fatos'
   @ PROW()+1,1 SAY 'ou ocorrencia que determinam a perda do direito ao salario-familia'
   @ PROW()+1,10 SAY '-OBITO DE FILHO;'
   @ PROW()+1,10 SAY '-CESSACAO DE INVALIDEZ DE FILHO INVALIDO;'
   @ PROW()+1,10 SAY '-SENTENCA JUDICIAL QUE DETERMINE O PAGAMENTO A OUTREM (casos de'
   @ PROW()+1,10 SAY ' desquite ou separacao, abandono de filho ou perda do patrio poder)'
   @ PROW()+1,1 SAY '      Estou ciente, ainda, de que a falta de cumprimento do compromisso'
   @ PROW()+1,1 SAY 'ora assumido, alem de obrigar a devolucao das importancia recebidas'
   @ PROW()+1,1 SAY 'indevidamentes, sujeitar-me-a as penalidade prevista no art 171 do'
   @ PROW()+1,1 SAY 'Codigo Penal e a rescisao do contrado de trabalho, por justa causa,'
   @ PROW()+1,1 SAY 'nos termos do art.482 da Consolidacao das Leis do Trabalho'
   @ PROW()+1,1 SAY REPL('-',80)
   @ PROW()+1,1 SAY CIDADE+','+N
   @ PROW(),20 SAY DTOC(DXDIA)+M
   @ PROW()+1,1 SAY REPL('-',80)
   @ PROW()+2,1 SAY REPL('_',40)
   @ PROW()+1,10 SAY 'Assinatura'
   @ PROW()+2,1 SAY REPL('-',80)
   IMPFOL()
   SET DEVICE TO SCREEN
ELSE
   MDT('Funcion rio n„o cadastrado')
ENDIF
DBCLOSEALL()
RETU
*: FIM: FOUC1.PRG
