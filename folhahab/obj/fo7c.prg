*:*****************************************************************************
*:
*:       FO7C.PRG: Imprimir Cadastro Completo Funcion rio
*:      Linguagem: Clipper 5.2e
*:        Sistema: FOLHA DE PAGAMENTO
*:      Copyright (c) 1997,  SOFTEC  S/C Ltda.
*:  Atualizado em: 21/08/97
*:
*:*****************************************************************************

////#INCLUDE "COMANDO.CH"

IF ! MDL('Imprimir Cadastro de Funcionarios - Completo ',0)
   RETU
ENDIF

MESTADO:=""
MCIDADE:=""
MNESTADO:=""
MNCIDADE:=""
MPAIS   :=""


lSAL:=MDG("Deseja com Salarios")
lDEP:=MDG("Deseja dependentes")
CTLIN=80
FL=0
POS1=SPAC(40)
MDS('Digite Cabecario Complementar')
@ 24,35 GET POS1
READCUR()

if Ldep
   IF ! NETUSE("FOSFAM") 
      RETURN .F.
   ENDIF
endif

if ! NETUSE("fo_sal") 
   dbcloseall()
   retu
endif


if ! NETUSE(pes) 
   dbcloseall()
   retu
endif
FILTRO=''
INX    := ""
FILORD(.T.)
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
if valtype(INX)="N"
   dbsetorder(INX)
ELSE
   ordDestroy("temp")
   ordcreate(,"temp",inx)
   ordSetFocus("temp")
ENDIF   
set filter to &FILTRO

IF ! netuse("FUNCAO") 
   DBCLOSEALL()
   RETU
ENDIF

IF ! NETUSE("SINDICAT") 
   DBCLOSEALL()
   RETU
ENDIF

IF ! NETUSE("DEPTO")
   DBCLOSEALL()
   RETU
ENDIF


DBSELECTAR(PES)
DBGOTOP()
IMPRESSORA()
WHILE ! EOF()
   mNUMERO:=NUMERO
   ALLTRUE(CHECKCID(,,.F.,IBGE,{{"UF","mESTADO"},{"NOME","mCIDADE"}}))
   ALLTRUE(CheckBacen(NASCPAIS,mPAIS,.F.,{{"STRZERO(BACEN,4)","NACPAIS"},{"NOME","mPAIS"}}) )
   FO7CCAB()
   CTLIN++
   @ CTLIN,1 SAY 'DEPTO'
   @ CTLIN,8 SAY 'SETOR'
   @ CTLIN,15 SAY 'SECAO'
   @ CTLIN,59 SAY 'CHAPA'
   @ CTLIN,65 SAY 'N. Reg'
   @ CTLIN,73 SAY 'NOME FUNCIONARIO'
   @ CTLIN,105 SAY 'ORDEM'
   CTLIN++
   @ CTLIN,2 SAY DEPTO
   @ CTLIN,9 SAY SETOR
   @ CTLIN,16 SAY SECAO
   DDEM:=DEPTO*1000000+SETOR*1000+SECAO
   DBSELECTAR("DEPTO")
   DBGOTOP()
   DBSEEK(DDEM)
   @ CTLIN,20 SAY IF(FOUND(),NOME,'Secao nao Cadastrada')
   DBSELECTAR(PES)
   @ CTLIN,60 SAY CHAPA
   @ CTLIN,66 SAY NUMERO
   @ CTLIN,73 SAY NOME
   @ CTLIN,107 SAY ORDEM
   IF ! EMPTY(DEMITIDO)
      @ CTLIN,112 SAY 'D E M I T I D O'
      @ CTLIN,112 SAY 'D E M I T I D O'
   ENDIF
   CTLIN++
   @ CTLIN,0 SAY REPL('-',132)
   CTLIN++
   @ CTLIN,2 SAY 'ENDERECO -->'
   @ CTLIN,14 SAY  ENDER+", "+alltrim(ENDNUM)+" "+alltrim( ENDCOMPL)
   @ CTLIN,50 SAY 'PIS --------->'
   @ CTLIN,64 SAY  PIS
   @ CTLIN,92 SAY 'BANCO --------->'
   @ CTLIN,108 SAY BANCO
   CTLIN++
   @ CTLIN,2 SAY 'BAIRRO ---->'
   @ CTLIN,14 SAY BAIRRO
   @ CTLIN,50 SAY 'F.G.T.S ----->'
   @ CTLIN,64 SAY FGTS
   @ CTLIN,92 SAY 'AGENCIA ------->'
   @ CTLIN,108 SAY AGENCIA
   CTLIN++
   @ CTLIN,2 SAY 'CIDADE ---->'
   @ CTLIN,14 SAY  CIDADE
   @ CTLIN,50 SAY 'DT ADMISSAO ->'
   @ CTLIN,64 SAY ADMITIDO
   @ CTLIN,92 SAY 'N. CONTA ------>'
   @ CTLIN,108 SAY CONTA
   CTLIN++
   @ CTLIN,2 SAY 'ESTADO ---->'
   @ CTLIN,14 SAY ESTADO
   @ CTLIN,50 SAY 'TIPO -------->'
   @ CTLIN,64 SAY TIPO+'-'+CHECKTAB("TSA2"+TIPO+"    ",,,"Tipo naoCadastrado",2)
   @ CTLIN,92 SAY 'SOCIO SIND ---->'
   @ CTLIN,108 SAY SOCIOSIND
   CTLIN++
   @ CTLIN,2 SAY 'CEP ------->'
   @ CTLIN,14 SAY CEP
   @ CTLIN,50 SAY 'H. SEMANAIS ->'
   @ CTLIN,64 SAY HRSEM
   @ CTLIN,92 SAY 'SITUACAO ------>'
   @ CTLIN,108 SAY SITUACAO+'-'+CHECKTAB("SITU"+SITUACAO,,,"Situacao nao Cadastrado",2)
   @ CTLIN,109 SAY '-'
   @ CTLIN,110 SAY SITUA
   CTLIN++
   @ CTLIN,2 SAY 'TELEFONE -->'
   @ CTLIN,14 SAY FONE
   @ CTLIN,50 SAY 'FUNCAO ------>'
   @ CTLIN,64 SAY FUNCAO
   @ CTLIN,68 SAY '-'
   @ CTLIN,69 SAY OBTER("FUNCAO",,FUNCAO,"FNOME") 
   DBSELECTAR(PES)
   @ CTLIN,92 SAY 'INSALUBRIDADE-->'
   @ CTLIN,108 SAY INSALUBRI
   CTLIN++
   @ CTLIN,2 SAY 'DT NASCTO ->'
   @ CTLIN,14 SAY NASC
   @ CTLIN,50 SAY 'CBO ->'   
   @ CTLIN,62 SAY  OBTER("FUNCAO",,FUNCAO,"CBONEW") 
   @ CTLIN,92 SAY 'PERICULOSIDADE->'
   @ CTLIN,108 SAY PERICULO
   CTLIN++
   @ CTLIN,2 SAY 'EST. CIVIL->'
   @ CTLIN,14 SAY ESTCIVIL+"-"+CHECKTAB("ECIV"+ESTCIVIL,,,"Estado Civil nao Cadastrado",2) 
   @ CTLIN,50 SAY IF(EMPTY(DEMITIDO),"",'DEMITIDO:'+DTOC(DEMITIDO))   
   @ CTLIN,92 SAY 'RG: '+RG+"/"+RGUF+"-"+RGEMIS    
   CTLIN++
   @ CTLIN,2 SAY 'Escolarid.->'
   @ CTLIN,14 SAY ESCRAIS+"-"+CHECKTAB("EESC" +ESCRAIS ,,,"Escolaridade nao Cadastrada",2)
   @ CTLIN,50 SAY 'DT REC.SIND.->'
   @ CTLIN,64 SAY DATCONTSIN
   @ CTLIN,92 SAY 'N. SINDICATO--->'
   @ CTLIN,108 SAY SINDICATO
   @ CTLIN,110 SAY '-'
   DDEM:=SINDICATO
   DBSELECTAR("SINDICAT")
   DBGOTOP()
   DBSEEK(DDEM)
   @ CTLIN,111 SAY IF(FOUND(),COGNOME,"Nao Cadastrado")
   DBSELECTAR(PES)
   CTLIN++
   @ CTLIN,2 SAY 'NAC. ------>'
   @ CTLIN,14 SAY NASCPAIS
   @ CTLIN,PCOL()+1 SAY mPAIS
   @ CTLIN,50 SAY 'C.P.F ------->'
   @ CTLIN,64 SAY CPF
   @ CTLIN,92 SAY 'CARTEIRA ------>'
   @ CTLIN,PCOL()+1 SAY IF(left(TIRAOUT(CPF),7)=PROFIS,CPF,PROFIS+"-"+SERIE+"/"+CTPSUF) //CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
   IF lSAL
      dbselectar("fo_sal")
      dbgotop()
      if dbseek(str(mNUMERO,8)+STR(ANOUSO,4))
         CTLIN+=2
         @ CTLIN,14 SAY 'EVOLUCAO DE SALARIO'
         @ CTLIN,14 SAY 'EVOLUCAO DE SALARIO'
         CTLIN+=2
         @ CTLIN,57 SAY 'NOME'
         @ CTLIN,80 SAY 'DATA'
         @ CTLIN,95 SAY 'NOME'
         @ CTLIN,118 SAY 'DATA'
         CTLIN++
         @ CTLIN,2 SAY 'JAN ->'
         @ CTLIN,8 SAY SALJAN
         @ CTLIN,26 SAY '-'
         @ CTLIN,27 SAY MOT1
         @ CTLIN,30 SAY 'JUL ->'
         @ CTLIN,36 SAY SALJUL
         @ CTLIN,53 SAY '-'
         @ CTLIN,54 SAY MOT7
         CTLIN++
         @ CTLIN,2 SAY 'FEV ->'
         @ CTLIN,8 SAY SALFEV
         @ CTLIN,26 SAY '-'
         @ CTLIN,27 SAY MOT2
         @ CTLIN,30 SAY 'AGO ->'
         @ CTLIN,36 SAY SALAGO
         @ CTLIN,53 SAY '-'
         @ CTLIN,54 SAY MOT8
         CTLIN++
         @ CTLIN,2 SAY 'MAR ->'
         @ CTLIN,8 SAY SALMAR
         @ CTLIN,26 SAY '-'
         @ CTLIN,27 SAY MOT3
         @ CTLIN,30 SAY 'SET ->'
         @ CTLIN,36 SAY SALSET
         @ CTLIN,53 SAY '-'
         @ CTLIN,54 SAY MOT9
         CTLIN++
         @ CTLIN,2 SAY 'ABR ->'
         @ CTLIN,8 SAY SALABR
         @ CTLIN,26 SAY '-'
         @ CTLIN,27 SAY MOT4
         @ CTLIN,30 SAY 'OUT ->'
         @ CTLIN,36 SAY SALOUT
         @ CTLIN,53 SAY '-'
         @ CTLIN,54 SAY MOT10
         CTLIN++
         @ CTLIN,2 SAY 'MAI ->'
         @ CTLIN,8 SAY SALMAI
         @ CTLIN,26 SAY '-'
         @ CTLIN,27 SAY MOT5
         @ CTLIN,30 SAY 'NOV ->'
         @ CTLIN,36 SAY SALNOV
         @ CTLIN,53 SAY '-'
         @ CTLIN,54 SAY MOT11
         CTLIN++
         @ CTLIN,2 SAY 'JUN ->'
         @ CTLIN,8 SAY SALJUN
         @ CTLIN,26 SAY '-'
         @ CTLIN,27 SAY MOT6
         @ CTLIN,30 SAY 'DEZ ->'
         @ CTLIN,36 SAY SALDEZ
         @ CTLIN,53 SAY '-'
         @ CTLIN,54 SAY MOT12
         @ CTLIN,56 SAY CO
      ENDIF   
   ENDIF
   dbselectar(pes)
   IF lDEP
      CTLIN++
      @ CTLIN,2 SAY "Dependente"
      CTLIN++
      dbselectar("FOSFAM")
      dbgotop()
      dbseek(STR(mNUMERO,8))
      while mNUMERO=NUMERO .AND. ! EOF()
        FO7CCAB()
        @ CTLIN, 2 SAY REQUISI
        @ CTLIN,10 SAY NASCTO
        @ CTLIN,12 SAY IRRF
        @ CTLIN,14 SAY BAIXA
        @ CTLIN,16 SAY CNS
        @ CTLIN,32 SAY NOME
        CTLIN++
        dbskip()           
     enddo
     dbselectar(pes)
   ENDIF
   CTLIN+=3
   DBSKIP()
ENDDO
DBCLOSEALL()
IMPFOL()
VIDEO()
IMPEND()
RETURN

FUNCTION FO7CCAB
   IF CTLIN > 50
      FL++
      @ 1,  1 SAY IF(IM1 = 'A',IMPstr(Cimpcom),IMPstr(Cimpexp))
      @ 2, 20 SAY IMPCHR(14)+MSG2
      @ 3, 20 SAY IMPCHR(14)+' CADASTRO GERAL DE FUNCIONARIO'
      @ 5,  0 SAY POS1
      @ 5,100 SAY TIME()
      @ 5,110 SAY DXDIA
      @ 5,120 SAY 'FL. '+STRZERO(FL,4)
      @ 6,  0 SAY REPL('-',132)
      CTLIN:=7
   ENDIF
RETURN
*: FIM: FO7C.PRG
