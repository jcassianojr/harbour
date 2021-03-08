*:*****************************************************************************
*:
*:      FOUC3.PRG: Op‡„o FGTS
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/08/94     11:21
*:
*:  Procs & Fncts: FOUC3()
*:
*:          Chama: CABEX()  (fun‡„o em FOLPROC.PRG)
*:
*:     Arq. Dados: BCOFGTS
*:
*:         Indice: BCOFGTS   Por ordem de n£mero de Empresas
*:                           EMP
*:
*:     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
*:*****************************************************************************

CABEX('IMPRIMIR OP€ŽO DE FGTS')
IF ! netuse("BCOFGTS") 
   RETU
ENDIF
DBGOTOP()
IF DBSEEK(NREMP)
   BANCFGTS=NOME
   AGENFGTS=NOMEAGENC
ELSE
   BANCFGTS:=AGENFGTS:=""
ENDIF
DBCLOSEAREA()

IF MDG('Deseja detalhes em negrito')
   N = cIMPNEG 
   M = cIMPNER
ELSE
   N = ""
   M = ""
ENDIF

mTEMP=tmpfile(cRDDEXT)
INX    := ""
FILTRO := ""
aRETU:=RFILORD(PES)
INX:=aRETU[1]
FILTRO:=aRETU[2]

IF ! NETUSE(PES) 
   RETU
ENDIF
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp",inx)
ordSetFocus("temp")


SET FILTER TO &FILTRO
SET DEVICE TO PRINT
DBGOTOP()
WHILE ! EOF()
   @ PROW(),1 SAY REPL('-',80)
   @ PROW()+1,1 SAY 'DECLARACAO DE OPCAO PARA FUNDO DE GARANTIA DO TEMPO DE SERVICO)'
   @ PROW()+1,20 SAY '(Lei No. 5.107 de 13 de setembro de 1966)'
   @ PROW()+1,1 SAY REPL('-',80)
   @ PROW()+5,1 SAY 'Eu,'+N+NOME+M
   @ PROW()+1,1 SAY 'portador da Carteira Profissional No.'+N+IF(left(TIRAOUT(CPF),7)=PROFIS,LEFT(TIRAOUT(CPF),7),PROFISM+' Serie: '+N+SERIE+M+' UF:'+N+CTPSUF)+M
   @ PROW()+1,1 SAY 'Empregado da empresa:'+N+msg2+M
   @ PROW()+1,1 SAY 'Sito A: '+N+ender1+' - '+bai1+' - '+cid1+M+' Estado '+N+est1+M
   @ PROW()+1,1 SAY '      Declaro para todos os fins, que nesta data, exerco a opcao'
   @ PROW()+1,1 SAY 'pelo regime do Regulamento do Fundo de Garantia do Tempo de servico,'
   @ PROW()+1,1 SAY 'aprovado pelo decreto no. 68.910, de 20 de dezembro de 1966.'
   @ PROW()+2,1 SAY cid1
   @ PROW(),30 SAY N+DTOC(fgts)+M
   @ PROW()+2,1 SAY REPL('_',40)
   @ PROW()+1,1 SAY 'Assinatura'
   @ PROW()+2,1 SAY 'TESTEMUNHAS'
   @ PROW()+2,1 SAY REPL('_',40)
   @ PROW()+2,1 SAY REPL('_',40)
   @ PROW()+2,1 SAY REPL('_',40)
   @ PROW()+1,1 SAY 'Assistente responsavel legal pelo menor, quando couber'
   @ PROW()+1,1 SAY REPL('-',80)
   @ PROW()+2,1 SAY 'Recebemos o Original'
   @ PROW()+1,30 SAY CID1+', '+N+DTOC(fgts)+M
   @ PROW()+2,1 SAY REPL('_',40)
   @ PROW()+2,1 SAY REPL('-',80)
   @ PROW()+1,1 SAY '1 - Em'
   @ PROW(),8 SAY N+DTOC(fgts)+M
   @ PROW(),18 SAY 'optou pelo sistema estabelecido na Lei no. 5.107,'
   @ PROW()+1,5 SAY 'de 13 de setembro de 1966, que estabeleceu o Fundo de Garantia'
   @ PROW()+1,5 SAY 'do Tempo de Servico'
   @ PROW()+2,1 SAY '2 - Os depositos na conta vinculada do empregado, decorrente da'
   @ PROW()+1,5 SAY 'Lei no. 5.1l07 de 13 de setembro de 1966, sao feitos no'
   @ PROW()+1,5 SAY 'Banco: '+N+BANCFGTS+M
   @ PROW()+1,5 SAY 'Agencia: '+N+AGENFGTS+M
   EJEC
   DBSKIP()
ENDDO
DBCLOSEAREA()
SET DEVI TO SCRE
FERASE(mTEMP)
RETU .T.

*: FIM: FOUC3.PRG
