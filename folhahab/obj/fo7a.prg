*****************************************************************************
*:
*:       FO7A.PRG: Inclui/Altera Cadastro Funcionario
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:
*:*****************************************************************************
* FO_TAB FO_PES
* UF     ESTADO/CTPSUF

* VINC   RAISVINC   VINCULO
* RACA   RACA
* DEFI   DEFICI
* GINS   ESCOLA    FO_TAB CODIG2=ESCO / ESCRAIS
* ESCO   ESCRAIS   FO_TAB CODIG2=GIND / ESCOLA  --ESC2
* CIVI   CIVIL nao mais usado
* ESTCIVIL 
* TADM   TIPOADM RAISTADM
* FADM   TIPFGTS
* TSA2   TIPO
* ALTF   ALTFGTS
* FCAT   CATEGORIA
* FDEM   FGTSMOT
* RCAU   MOTIVO    -->FO_RCAU.DBF    CODIGO
* RDEM   RAISDEM   -->FO_RCAU.DBF    RAIS
* FOCO   OCOFGTS   -->FO_RCAU.DBF    CODGRE
*        PGFGTS    -->FO_RCAU.DBF    PAGAFGTS

* SITU   SITUACAO
* SIEM   RAISSITU   RAFA


#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

MESTADO:=""
MCIDADE:=""
MNESTADO:=""
MNCIDADE:=""
MPAIS   :=""
MCBONEW :=""
MFAIXA  :=""
mREQCNH :=""
mREQOC  :=""
mOCEMIS :=""


CABEX('INCLUI/ALTERA CADASTRO FUNCIONARIO')
CTR = 0
MDS('NUMERO DO FUNCIONARIO ->')
@ 24,35 GET CTR PICT '#######'
READCUR()
IF CTR=0
   RETURN
ENDIF

IF ! NETUSE(PES)
   DBCLOSEALL()
   RETU .F.
ENDIF
INITVARS()
DBGOTOP()
IF ! DBSEEK(CTR)
   IF MDG('Nao cadastrado Deseja incluir (S/N)')
      limpavars()
      IF ! iFOPTO4E(.F.)      
         ALERTX("dados básicos não preenchidos")
         RETURN
      ENDIF
      netrecapp()
      FIELD->NUMERO:=CTR
      FIELD->CNUMERO:=STRZERO(CTR,8)
      FIELD->CPF:=mCPF
      FIELD->PIS:=mPIS
      FIELD->NASC:=mNASC
      FIELD->NOME:=mNOME
   ELSE
      DBCLOSEALL()
      RETU
   ENDIF
ELSE
   netreclock()
ENDIF


IF ! NETUSE("FORAIS") 
   DBCLOSEALL()
   RETU .F.
ENDIF
DBGOTOP()
IF ! DBSEEK(STR(ANOUSO,4)+STR(CTR,8))
   netrecapp()
   FIELD->ANO   :=ANOUSO
   FIELD->NUMERO:=CTR
ELSE
   netreclock()
ENDIF

IF ! NETUSE("FO_SAL") 
   DBCLOSEALL()
   RETU .F.
ENDIF
DBGOTOP()
IF ! DBSEEK(str(CTR,8)+STR(ANOUSO,4))
   netrecapp()
   FIELD->NUMERO:=CTR
   FIELD->ANO   :=ANOUSO
ELSE
   netreclock()
ENDIF


dbselectar(pes)
CorrigeFo_pes()
ALLTRUE(CHECKCID(,,.F.,IBGE,{{"UF","mESTADO"},{"NOME","mCIDADE"}}))
ALLTRUE(CheckBacen(NASCPAIS,mPAIS,.F.,{{"STRZERO(BACEN,4)","NACPAIS"},{"NOME","mPAIS"}}) )

VERSEHA("FUNCAO",,FUNCAO,"STR(CODIGO)+' '+NOME","'Cargo/Função Invalida'",.F.,{{"CBONEW","mCBONEW"},{"FAIXA","mFAIXA"},{"REQCNH","mREQCNH"},{"REQOC","mREQOC"},{"OCEMIS","mOCEMIS"}})

if empty(field->OCEMI) .and. mREQOC="S"
   field->OCEMI:=mOCEMIS
endif


SETCOLOR("W/N,N/W,N,N,N/W")
@ 7,0 CLEAR
PETELA(3)
set key K_F11 to TECLAF11
@  5,  1 SAY SPACE(78)
@  5,  1 SAY "FONE:"
@  5, 40 say "UnidFunc:"
@  5, 60 say "CCusto:"
@  6,  1 SAY replicate('-',78)
@  7,  1 SAY "Endereco:"
@  8,  1 SAY "Compl.:"
@  8, 41 SAY "Bairro:"
@  9,  1 SAY "UF/CIDADE:"+spac(51)+"CEP:"
@ 10,  1 SAY replicate('-',76)
@ 11,  1 SAY "CTPS:         Serie:       UF:               No.Ordem Relatorios:"
@ 12,  1 SAY replicate('-',76)
@ 13,  1 SAY "                                  RG:"
@ 14,  1 SAY replicate('-',76)
@ 15,  1 SAY "Habilitacao:"+spac(12)+"Catg   Validade"+spac(10)+"Expedicao"
@ 16,  1 SAY "OrgaoClasse:"+spac(12)+"Catg   Validade"+spac(10)+"Expedicao"
@ 17,  1 say "SEXO(M/F)"
@ 17, 65 SAY "Etnia:"
@ 17, 71 SAY "Defi:"
@ 19,  1 SAY "CPF:"+spac(17)+"PIS:"+spac(14)+"CI(INSS)"+spac(13)+"Classe"
@ 20,  1 SAY "Titulo Eleitor:                  Zona:     Secao:    cns:"
@ 21,  1 SAY "EMAIL:"
@ 22,  1 SAY "Pai"+spac(33)+"Mae"
@ 23,  1 SAY replicate('-',78)
@ 04,39 SAY NUMERO
@ 04,02 GET DEPTO
@ 04,12 GET SETOR
@ 04,21 GET SECAO
@ 04,30 GET CHAPA
@ 04,48 GET NOME
@  5,08 GET FONE   
@ 05,49 GET UNIFUN  VALID VERSEHA("UNID",,UNIFUN,"NOME",'"Unidade nao cadastrado"')
@ 05,68 GET CCUSTO
@ 05,76 GET MODIRETA valid MODIRETA $ "SNACDI "
@ 07,12 GET ENDTIP   PICT "!!" VALID VERSEHA("ESOCIAL_TAB20",,mENDTIP,"NOME",'"Tipos de Logradouros - eSocial"')   // VALID alltrue(CHECKTAB(PADR("ELOG",4)+PADR(mENDTIP,5),24,0,"Tipo Nao Cadastrado"))
@ 07,15 GET ENDER   
@ 07,56 GET ENDNUM  
@  8,10 GET ENDCOMPL
@  8,49 GET BAIRRO
@  9,12 GET IBGE      VALID CHECKCID(,,.T.,IBGE,{{"UF","mESTADO"},{"NOME","mCIDADE"}})
@  9,20 GET mESTADO   WHEN EMPTY(IBGE) PICT "!!" VALID CHECKTAB(PADR("UF",4)+PADR(mESTADO,5),24,0,"Estado Nao Cadastrado")
@  9,23 GET mCIDADE   WHEN EMPTY(IBGE) VALID CHECKCID(mESTADO,mCIDADE,.T.,,{{"CODIBGE","IBGE"}})
@  9,65 GET CEP      PICT "#####-###" VALID CHKUFCEP(CEP,ESTADO)
@ 11,07 GET PROFIS   PICT '9999999' VALID CHECKCTPS() ////CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
@ 11,22 GET SERIE    PICT '99999'  VALID CHECKSERIE()
@ 11,32 GET CTPSUF   PICT '!!'  VALID CHECKTAB(PADR("UF",4)+PADR(CTPSUF,5),24,0,"Estado Nao Cadastrado")
@ 11,35 GET CTPSDATA
@ 11,67 GET ORDEM    PICT '9999999999'
@ 13,39 GET RGTIP    VALID RGTIP="RG" .OR. RGTIP="RGE" .OR. RGTIP="RIC" .OR. RGTIP="CPF"
@ 13,43 GET RGUF     PICT "!!" VALID RGTIP="CPF" .OR. CHECKTAB(PADR("UF",4)+PADR(RGUF,5),24,0,"Estado Nao Cadastrado")
@ 13,46 GET RG       VALID ALLTRUE(CHECKRG(FORMATARG(RG,RGTIP),.T.,RGTIP,NASC,RGUF)) //Fopto_cat fopto_42 fopto_32 disklib folis_d9 folis_d1
@ 13,61 GET RGEMIS   VALID RGTIP="CPF" .OR. VERSEHA("ORGEMISS",,RGEMIS,"NOME",'"Orgao emissor nao cadastrado"') 
@ 13,68 GET RGDATA
@ 15,13 GET CNH      VALID IF(mREQCNH="S",! EMPTY(CNH),.T.)
@ 15,29 GET CATCNH   WHEN ! EMPTY(CNH)
@ 15,40 GET VALCNH   WHEN ! EMPTY(CNH)
@ 15,59 GET EXPCNH   WHEN ! EMPTY(CNH)
@ 16,13 GET OC       VALID IF(mREQOC="S",! EMPTY(OC),.T.)
@ 16,40 GET OCVAL    WHEN ! EMPTY(OC)
@ 16,59 GET OCEXP    WHEN ! EMPTY(OC) 
@ 16,68 GET OCEMI    WHEN ! EMPTY(OC) VALID VERSEHA("ORGEMISS",,OCEMI,"NOME",'"Orgao emissor nao cadastrado"') 
@ 17,11 GET SEXO     WHEN ALLTRUE(CHECKSEXO(NOME,SEXO,.T.)) VALID SEXO $ "MF"
@ 17,70 GET RACS     VALID CHECKTAB("RACS"+RACS,24,0,"Etnia e-Social Nao Cadastrada")
@ 17,76 GET DEFICI   VALID CHECKTAB("DEFI"+PADR(DEFICI,5),24,0,"Tipo Deficiência invalido")
@ 19, 7 GET CPF      PICTURE "999.999.999-99" VALID VALCPF(CPF)
@ 19,28 GET PIS      VALID VALPIS(PIS,.t.,.t.,EVINC)
@ 19,50 GET CI       PICTURE '99999999999'
@ 19,69 GET CLASSE   PICTURE '99'      WHEN ! EMPTY(CI)
@ 20,18 GET TITULO   VALID EMPTY(TITULO).OR.CHECKTITULO(TITULO)
@ 20,39 GET TITUZONA WHEN ! EMPTY(TITULO)
@ 20,50 GET TITUSECA WHEN ! EMPTY(TITULO)
@ 20,60 get CNS      VALID ALLTRUE(VALCNS(CNS))
@ 21,10 GET EMAIL    valid CHECKEMAIL(EMAIL)
@ 22, 6 GET PAI      PICT "@S30"
@ 22,42 GET MAE      PICT "@S30"
READCUR()


@ 06,00 CLEA
@ 06,00 Say "|Nascimento:"
@ 09,00 SAY "|Escolaridade:            |Estado Civil:      |" 
@ 10,00 SAY "|01 - Analfabeto          |(S)olteiro       1 |" 
@ 11,00 SAY "|02 - Primário incompleto |(C)asado         2 |"  
@ 12,00 SAY "|03 - Primário Completo   |(V)iuvo          5 |" 
@ 13,00 SAY "|04 - Ginasio Incompleto  |(D)ivorciado     3 |" 
@ 14,00 SAY "|05 - Ginasio Completo    |(U)unial Estavel 1 |"
@ 15,00 SAY "|06 - Medio    Incompleto |(M)arital        1 |"
@ 16,00 SAY "|07 - Medio  Completo     |(O)Outros        1 |" 
@ 17,00 SAY "|08 - Superior Incompleto |se(P)arado       4 |" 
@ 18,00 SAY "|09 - Superior Completo   |des(Q)uitado     4 |"  
@ 19,00 SAY "|10 - pOS Graduação       |                   |"  
@ 20,00 SAY "|11 - Mestrado            |                   |"  
@ 21,00 SAY "|12 - Doutorado           |                   |"  
@ 22,00 SAY "|                         |                   |"  
@ 23,00 SAY "|                         |                   |"  
@ 06,12 GET NASC
@ 06,21 GET NASCPAIS  VALID CheckBacen(NASCPAIS,mPAIS,.T.,{{"STRZERO(BACEN,4)","NACPAIS"},{"NOME","mPAIS"}}) 
@ 06,26 GET mPAIS     WHEN EMPTY(NASCPAIS) VALID CheckBacen(0,mPAIS,.T.,{{"STRZERO(BACEN,4)","NACPAIS"},{"NOME","mPAIS"}}) 
@ 06,38 get ANONASCI  WHEN NASCPAIS<>"1058" PICT "9999"
@ 07,12 GET NASCIBGE  VALID CHECKCID(,,.T.,NASCIBGE,{{"UF","mNESTADO"},{"NOME","mNCIDADE"}})
@  7,20 GET mNESTADO  WHEN EMPTY(NASCIBGE) PICT "!!" VALID CHECKTAB(PADR("UF",4)+PADR(mNESTADO,5),24,0,"Estado Nao Cadastrado")
@  7,23 GET mNCIDADE  WHEN EMPTY(NASCIBGE) VALID CHECKCID(mNESTADO,mNCIDADE,.T.,,{{"CODIBGE","IBGE"}})
@ 09,15 GET ESCRAIS   VALID CHECKTAB("ESC2"+ESCRAIS ,24,0,"Escolaridade nao Cadastrada")
@ 09,40 GET ESTCIVIL  VALID CHECKTAB("ECIV"+ESTCIVIL,24,0,"Estado civil nao cadastrado")
//@ 09,40 GET CIVIL     VALID CHECKTAB("CIVI"+STR(CIVIL,1)+"    ",24,0,"Estado Civil nao Cadastrado")
READCUR()
DBSELECTAR(PES)
@ 06,0 CLEAR
@ 06,00 SAY "+----------------------------------------------------------------------------+"
@ 07,00 SAY "|Admitido:        -   FGTS:       -    FUNCAO:     CBO:                      |"
@ 08,00 SAY "|Transfer:                                                                   |"
@ 09,00 SAY "|ETADM:  EIADM:  1oEmp:  Regime:  Prev:  Vinc:  Jornada:  Contrato:          |"
@ 10,00 SAY "|-------------||-------------------------------------------------------------|"
@ 11,00 SAY "|Horas por/   ||Banco:       Agencia:           Conta:                       |"
@ 12,00 SAY "|Semana       ||-------------------------------------------------------------|"
@ 13,00 SAY "|-------------||EVOLUCAO SALARIAL : ADMITIDO COM :                  Fai.     |"
@ 14,00 SAY "|Pagamento:   ||-------------------------------------------------------------|"
@ 15,00 SAY "|M - Mensal   ||Jan =                          Jul =                         |"
@ 16,00 SAY "|Q - Quinzenal||Fev =                          Ago =                         |"
@ 17,00 SAY "|S - Semana   ||Mar =                          Set =                         |"
@ 18,00 SAY "|D - Diario   ||Abr =                          Out =                         |"
@ 19,00 SAY "|H - Horas    ||Mai =                          Nov =                         |"
@ 20,00 SAY "|Y - Tarefa   ||Jun =                          Dez =                         |"
@ 21,00 SAY "|O - Outros   ||:Preencha os Quadros a Esquerda com o código de Reajuste     |"
@ 22,00 SAY "+-------------++-------------------------------------------------------------+"
@ 07,11 GET ADMITIDO VALID CHECKADM()
@ 07,27 GET FGTS    VALID CHECKFGTS(FGTS)
@ 07,36 GET TIPFGTS VALID CHECKTAB("FADM"+PADR(TIPFGTS,5),24,0,"código não Cadastrado")
@ 07,46 GET FUNCAO  valid vERSEHA("FUNCAO",,FUNCAO,"STR(CODIGO)+' '+NOME","'Cargo/Função Invalida'",.t.,{{"CBONEW","mCBONEW"},{"FAIXA","mFAIXA"}})
@ 07,55 SAY mCBONEW
@ 08,12 get DATTRANSF
@ 08,21 GET NUMEMPANT WHEN ! EMPTY(mDATTRANSF) PICT "999"
@ 08,25 GET NUMREGANT WHEN ! EMPTY(mDATTRANSF) PICT "99999999"
@ 09,07 GET ETADM  VALID CHECKTAB("ETAD"+PADR(ETADM,5),24,0,"código nao Cadastrado")
@ 09,15 GET EIADM  VALID CHECKTAB("EIAD"+PADR(EIADM,5),24,0,"codigo nao Cadastrado")
@ 09,23 GET E1ADM  VALID CHECKTAB("E1AD"+PADR(E1ADM,5),24,0,"codigo nao Cadastrado")
@ 09,32 GET EREGI  VALID CHECKTAB("EREG"+PADR(EREGI,5),24,0,"codigo nao Cadastrado")
@ 09,40 GET EPREV  VALID CHECKTAB("EPRE"+PADR(EPREV,5),24,0,"codigo nao Cadastrado")
@ 09,46 GET ELTRA  VALID CHECKTAB("ELTR"+PADR(ELTRA,5),24,0,"codigo nao Cadastrado")
@ 09,56 GET ETJOR  VALID CHECKTAB("ETJO"+PADR(ETJOR,5),24,0,"codigo nao Cadastrado")
@ 09,67 GET ETCOR  VALID CHECKTAB("ETCO"+PADR(ETCOR,5),24,0,"codigo nao Cadastrado")
@ 12,09 GET HRSEM  VALID HRSEM>0
@ 14,13 GET TIPO   VALID CHECKTAB("TSA2"+TIPO+"    ",24,0,"Tipo nao Cadastrado")
READCUR()
IF ZUSER="SUPERVISOR"
   @ 11,28 GET BANCO
   @ 11,43 GET AGENCIA
   @ 11,60 GET CONTA VALID CHECKCTA(BANCO,AGENCIA,CONTA)   
   @ 13,76 SAY mFAIXA
   READCUR()   
   dbselectar("fo_sal")
   //@ 13,76 GET FAIXA  VALID EMPTY(FAIXA).OR.VERSEHA("FO_FAI",,FAIXA,"DESCRICAO",'"FAIXA nao Cadastrada"')
   @ 15,25 GET SALJAN
   @ 15,46 GET MOT1    WHEN ! EMPTY(SALJAN)
   @ 16,25 GET SALFEV
   @ 16,46 GET MOT2   WHEN ! EMPTY(SALFEV)
   @ 17,25 GET SALMAR
   @ 17,46 GET MOT3  WHEN ! EMPTY(SALMAR)
   READCUR()
   @ 18,25 GET SALABR
   @ 18,46 GET MOT4 WHEN ! EMPTY(SALABR)
   @ 19,25 GET SALMAI
   @ 19,46 GET MOT5 WHEN ! EMPTY(SALMAI)
   @ 20,25 GET SALJUN
   @ 20,46 GET MOT6 WHEN ! EMPTY(SALJUN)
   READCUR()
   @ 15,56 GET SALJUL
   @ 15,76 GET MOT7 WHEN ! EMPTY(SALJUL)
   @ 16,56 GET SALAGO
   @ 16,76 GET MOT8 WHEN ! EMPTY(SALAGO)
   @ 17,56 GET SALSET
   @ 17,76 GET MOT9 WHEN ! EMPTY(SALSET)
   READCUR()
   @ 18,56 GET SALOUT
   @ 18,76 GET MOT10 WHEN ! EMPTY(SALOUT)
   @ 19,56 GET SALNOV
   @ 19,76 GET MOT11 WHEN ! EMPTY(SALNOV)
   @ 20,56 GET SALDEZ
   @ 20,76 GET MOT12 WHEN ! EMPTY(SALDEZ)
   READCUR()
   dbselectar(pes)
ENDIF
@ 06, 0 CLEAR
@  6,  0 SAY "+"+replicate('-',38)+"++"+replicate('-',38)+"+"
@  7,  0 SAY "|FGTS:"+spac(13)+"Cod.Alteracao"+spac(6)+replicate('|',2)+"   MOTIVO :         "+spac(18)+"|"
@  8,  0 SAY "|Categoria"+spac(28)+replicate('|',2)+"                                "+spac(6)+"|"
@  9,  0 SAY "|Tomador"+spac(30)+replicate('|',2)+spac(12)+"                    "+spac(6)+"|"
@ 10,  0 SAY "|Aviso"+spac(12)+"Demitido"+spac(12)+replicate('|',2)+"                                "+spac(6)+"|"
@ 11,  0 SAY "|Codigo p/ Cad. Adm/dem :"+spac(13)+replicate('|',2)+spac(12)+"                    "+spac(6)+"|"
@ 12,  0 SAY "|Motivo para RE FGTS    :"+spac(13)+replicate('|',2)+spac(12)+"                          |"
@ 13,  0 SAY "|FGTS pago Rescisao     :    (S/N)    "+replicate('|',2)+spac(12)+"                          |"
@ 14,  0 SAY "|"+replicate('-',38)+"||"+spac(12)+"                  "+spac(8)+"|"
@ 15,  0 SAY "|                                     "+replicate('|',2)+spac(12)+"          "+spac(16)+"|"
@ 16,  0 SAY "|          "+spac(27)+replicate('|',2)+spac(12)+"                 "+spac(9)+"|"
@ 17,  0 SAY "+"+replicate('-',38)+"+|                                     |"
@ 18, 40 SAY "|"+spac(12)+"                          |"
@ 19, 40 SAY "|"+spac(12)+"                          |"
@ 20, 40 SAY "|                                     |"
@ 21, 40 SAY "+"+replicate('-',38)+"+"
@  7, 8 GET CONTAFGTS VALID CTAFUN(CONTAFGTS,cCODEMP)
@  7,34 GET ALTFGTS   VALID EMPTY(ALTFGTS).OR.CHECKTAB("ALTF"+PADR(ALTFGTS,5),24,0,"Alteracao nao Cadastrada")
@  8,12 GET CATEGORIA VALID CHECKTAB("FCAT"+PADR(CATEGORIA,5),24,0,"Categoria nao Cadastrada")
@  9,15 GET EVINC     VALID VERSEHA("ESOCIAL_TAB01",,EVINC,"NOME",'"Categorias de Trabalhadores - eSocial"')           // VALID CHECKTAB("EVIN"+PADR(EVINC,5),24,0,"codigo nao Cadastrado")
@  9,10 GET TOMADOR   PICTURE '99999999'
@ 10, 9 GET AVISOPREV
@ 10,28 GET DEMITIDO
READCUR()
IF ! EMPTY(AVISOPREV).OR. ! EMPTY(DEMITIDO)
   @  7,53 GET MOTIVO    VALID (EMPTY(MOTIVO) .OR.VERSEHA("FO_RCAU",,MOTIVO,"NOME",'"Codigo Nao Cadastrado"')).AND.CHECKMOTDEM() //CHECKTAB("RCAU"+MOTIVO +"0  ",24,0,"Motivo nao Cadastrado")
   @ 11,27 GET MOTIVODEM VALID VERSEHA("CAGED",,MOTIVODEM,"DESCRICAO",'"Codigo Caged Nao Cadastrado"')
   @ 12,27 GET FGTSMOT   VALID EMPTY(FGTSMOT).OR.CHECKTAB("FDEM"+PADR(FGTSMOT,5),24,0,"Motivo nao Cadastrado")
   @ 13,27 GET PGFGTS    VALID PGFGTS $ " SN" PICT "!"
   READCUR()
ENDIF


HB_DISPBOX( 6, 0,23,79,B_DOUBLE+" ")
@  6, 22 SAY "|"+replicate('-',23)+"|"
@ 12,  0 SAY '|'
@ 15, 79 SAY '|'
@ 16,  0 SAY '|'
@ 18,  0 SAY '|'
@ 18, 79 SAY '|'
@  7,  2 SAY "Creditar (S/N)      | Descontar (S/N/ABCDE) |  Situacao:     "
@  8,  2 SAY "                    | Assis. Medica  :      |  (06)M - Maternidade          "
@  9,  2 SAY "Insalubridade  :    | Assis. Odonto. :      |  (01)S - Seguro(AciTrab)      "
@ 10,  2 SAY "Periculosidade :    | Assistencial   :   SN |  (03)I - INSS(Doenca)         "
@ 11,  2 SAY "Exposicao      :    | Cesta Basica   :   SNV|  (12)E - Exercito             "
@ 12,  2 SAY "                    | Vale Transporte:   SN | " // A - Afastado  (Nada Fgts)"
@ 13,  2 SAY "Sindicato Filiado :                         | " // P - Aposentado(N.Pg.INSS)"
@ 14,  2 SAY "Socio Sindicato   :   (S/N)                 | Aposentado "
@ 15,  2 SAY "Data Rec. Sindical:"+spac(25)+"|"+replicate('-',32)
@ 16,  1 SAY replicate('-',45)+"|  Exclui Vale (S/N/P):"
@ 17,  2 SAY "Exame Medico:"+spac(10)+"Proximo:"+spac(13)+"|  Dias/Horas Parcial :"
@ 18,  1 SAY replicate('-',45)+"|"+replicate('-',32)
@ 19,  2 SAY "Turno de Trabalho:    Horario de Trabalho:"


// Get nas Menvars
@  9,19 GET INSALUBRI  VALID INSALUBRI $ "SN " PICT "!"
@ 10,19 GET PERICULO   VALID PERICULO $ "SN " PICT "!"
@ 11,19 GET OCOFGTS    VALID CHECKTAB("FOCO"+PADR(OCOFGTS,5),24,0,"Codigo nao Cadastrado").AND.ALLTRUE(VALOCO("OCOFGTS","EOCO"))
@  8,41 GET ASSM       VALID ASSM $ "SNABCDE " PICT "!"
@ 09,41 GET ASSO       VALID ASSO $ "SNABCDE " PICT "!"
@ 10,41 GET PGASSI     VALID PGASSI $ "SN" PICT "!"
@ 11,41 get CESTA      valid CESTA $ "SNV "
@ 12,41 GET VT         VALID VT $ "SN "
@  7,59 GET SITUACAO   VALID VALSITU(SITUACAO,"EXCVALE","RAISSITU")
@ 13,22 GET SINDICATO  PICT '99'
@ 14,22 GET SOCIOSIND  VALID SOCIOSIND $ "SN " PICT "!"
@ 14,59 GET APOSENT
@ 14,61 GET APOSEND    WHEN ! EMPTY(APOSENT)
@ 15,22 GET DATCONTSIN
@ 17,16 GET EXADAT
@ 17,34 GET EXAPRO
@ 19,21 SAY HTT             //potaria cat relogio requer troca htttroca()
@ 19,45 SAY HT              //
@ 16,70 GET EXCVALE    VALID EXCVALE  $"SNP "
@ 17,70 GET VALEHORA   PICTURE '999.99' WHEN EXCVALE="P"
READCUR()
set key K_F11 to
CorrigeFo_pes()
DBUNLOCK()
IF (MONTH(ADMITIDO)=MES.AND.YEAR(ADMITIDO)=ANO) ;
   .OR.(MONTH(DEMITIDO)=MES.AND.YEAR(DEMITIDO)=ANO) ;
   .OR.(MONTH(AVISOPREV)=MES.AND.YEAR(AVISOPREV)=ANO) ;
   .OR. ! EMPTY(SITUACAO)
   dbselectar("FORAIS")
   HB_DISPBOX( 6, 0,23,79,B_DOUBLE+" ")
   @  6,  2 SAY 'Dados RAIS'
   @  7,  0 SAY '| Vinculo            :'   
   @  8,  0 SAY '| Alvará             :'
   @  9,  0 SAY '| Tipo Admissão      :'
   @ 10,  0 SAY '| Rais Situação      :'
   @ 10,  0 SAY '| Código Desligamento:'
   @  7, 25 GET RAISVINC VALID VERSEHA("VINCULO",,RAISVINC,"NOME",'"Vinculo nao Cadastrado"')   
   @  8, 25 GET ALVARA   VALID ALAVARA # "SN"
   @  9 ,25 GET TIPOADM  VALID VERSEHA("RAISTADM",,TIPOADM,"NOME",'"Tipo de admissao Nao Cadastrado"')    
   @ 10, 25 GET RAISSITU VALID CHECKTAB("SIEM"+"0"+RAISSITU+"0  ",24,0,"SituaCAo nAo Cadastrada")   
   @ 11, 25 GET RAISDEM  VALID EMPTY(RAISDEM).OR.CHECKTAB("RDEM"+RAISDEM+"   ",24,0,"Motivo não Cadastrado")     
   readcur()
   dbunlock()
ENDIF
DBCLOSEALL()
IF MDG("Verificar Dependentes")
   FOSFAMQTDE(CTR,"S")
   PADRAO("FOSFAM","FOSFAM","' '+STR(mNUMERO,8)+' '+STR(mREQUISI,8)+' '+mNOME+' '+DTOC(mNASCTO)","STR(mNUMERO,8)+STR(mREQUISI,8)","Salario Familia","Funcionario SEQ.  Dependente"+spac(31)+"Nascto",;
          {|| FOSFAMCHV(CRT)},"FOSFAM","FOSFAM",{|| FO_FOR("GRUPO='FOSFAM'")},"NUMERO=CRT")
ENDIF
RETU



*!*****************************************************************************
*!
*!         Funcao: CHECKFUN()
*!
*!*****************************************************************************
/*
FUNCTION CHECKFUN(cFUNCAO)
LOCAL cDBF:=ALIAS(),lRETU:=.F.,cFAIXA:="  ",cCBONEW:=SPACE(6)
IF LASTKEY()=K_UP.OR.LASTKEY()=K_DOWN
   RETU .T.
ENDIF
IF ! NETUSE("FUNCAO")
   IF ! EMPTY(cDBF)
      DBSELECTAR(cDBF)
   ENDIF
   RETU .T.
ENDIF
DBGOTOP()
IF DBSEEK(cFUNCAO)
   cFAIXA:=FAIXA   
   cCBONEW:=CBONEW
   lRETU:=.T.
ENDIF
DBCLOSEAREA()
IF ! lRETU
   ALERTX("Funcao Nao Cadastrada")
ENDIF
IF ! EMPTY(cDBF)
   DBSELECTAR(cDBF)
ENDIF
IF ! EMPTY(cCBONEW)
   FIELD -> CBONEW   := cCBONEW   
ENDIF   
IF ! EMPTY(cFAIXA)
   FIELD -> FAIXA := cFAIXA
ENDIF
RETU lRETU
*/

