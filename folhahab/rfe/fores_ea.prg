*:*****************************************************************************
*:
*:   FORES_EA.PRG: Nome do Programa
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA PAGAMENTO - RECISAO E FERIAS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/26/94      9:07
*:
*:  Procs & Fncts: FORES_EA()
*:
*:     Documentado 05/13/94 em 15:05                DISK!  vers„o 5.01
*:*****************************************************************************
////#INCLUDE "COMANDO.CH"


EMITIDO=GOZOU1DE-32
EMITIDO=EMITIDO-IF(DOW(EMITIDO)=7,1,0)
EMITIDO=EMITIDO+IF(DOW(EMITIDO)=1,1,0)
RETORNO=GOZOU1ATE+1
@ 22,00
@ 22,00 SAY 'Confirme Data de Emiss„o'
@ 23,00 SAY 'Confirme Data de Retorno'
@ 22,40 GET EMITIDO
@ 23,40 GET RETORNO
READCUR()



IMPRESSORA()
FOR X=1 TO COP
   @ PROW()+1, 0 SAY IMPCHR(cIMPTIT)+'AVISO PREVIO DE FERIAS'
   @ PROW()+1, 0 SAY IMPSTR(cIMPCOM)+'De acordo com o art. 135 da C.L.T., participando no minimo com 30 dias de antecedencia (nova redacao dada pela lei 7414/85)'+IMPSTR(cIMPEXP)
   @ PROW()+1, 0 SAY REPL('=',80)
   @ PROW()+2, 0 SAY 'Local: '+CID1+','+EST1+'-'+DTOC(EMITIDO)
   @ PROW()+2, 0 SAY 'Firma '+MSG2
   @ PROW()+1, 0 SAY 'Endereco '+ENDER1+'-'+BAI1+'-'+CID1+'-'+EST1
   @ PROW()+1, 0 SAY REPL('=',80)
   DBSELECTAR(PES)
   @ PROW()+2, 0 SAY 'Sr.(a)'
   @ PROW()+1, 0 SAY 'Numero: '+STR(NUMERO)+' Nome: '+NOME
   @ PROW()+1, 0 SAY 'CTPS: '+IF(left(TIRAOUT(CPF),7)=PROFIS,CPF,PROFIS+"-"+SERIE+"/"+CTPSUF) //CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
   @ PROW()+2, 0 SAY IMPSTR(cIMPCOM)+'Nos termos das Disposicoes legais vigentes, suas ferias serao concedidas conforme demonstrativo abaixo:'+IMPSTR(cIMPEXP)
   DBSELECTAR("FO_FER")
   @ PROW()+1, 0 SAY REPL('-',80)
   @ PROW()+1, 0 SAY "Periodo Aquisitivo"+SPAC(13)+"Periodo de Gozo"+SPAC(15)+"Retorno ao trabalho"
   @ PROW()+1, 9 SAY "a"+SPAC(29)+"a"
   @ PROW()  , 0 SAY DATFERIAS
   @ PROW()  ,11 SAY DATFERIASF
   @ PROW()  ,30 SAY GOZOU1DE
   @ PROW()  ,41 SAY GOZOU1ATE
   @ PROW()  ,67 SAY RETORNO
   @ PROW()+1, 0 SAY REPL('-',80)
   @ PROW()+2, 0 SAY IMPSTR(cIMPCOM)+'Favor Apresentar a sua Carteira de Trabalho e Previdencia Social ao Departamento de Pessoal para as anotacoes necessarias.'+IMPSTR(cIMPEXP)
   @ PROW()+1, 0 SAY REPL('=',80)
   @ PROW()+3, 0 SAY REPL('-',30)
   @ PROW()  ,39 SAY REPL('-',30)
   @ PROW()+1,10 SAY 'Empregador'
   @ PROW()  ,49 SAY 'Empregado'
   @ PROW()+2, 0 SAY REPL('=',80)
   IMPFOL()
NEXT X
VIDEO()
IMPEND()
RETU
*: FIM: FORES_EA.PRG
