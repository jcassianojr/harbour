////#INCLUDE "COMANDO.CH"
#include "adordd.ch"
#include "try.ch"

/*
*cpfTrab
*nisTrab
*nomeTrab
sexo
racaCor
*estadoCivil
*grauInstrucao
*nascimento *dtNascto codMunicipio uf
paisNascto
*nomeMae 
*nomePai
*nrCtps
*nrRg *orgaoEmissor *dtExpedicao
nrOc orgaoEmissor dtExpedicao dtValidade
*nrcnh orgaoEmissor dtExpedicao *dtValidade
*tpLogradouro *descLogradouro *nrLogradouro *complemento *bairro *cep *codmunicipio uf
*tpDep  *nomeDep *dtNascto *cpfDep depIRRF depSF
*fonePrincipal 
*emailPrincipal

*/


local cConn:="Provider=MSDASQL.1;Persist Security Info=False;Data Source=ol_logix"
local cCOMANDO:=""
PUBLIC oConn,oErr,oREGISTRO,oREGISTR2

IF ! MDL('FOPTO_32 - Pesquisa Funcionarios ')
   RETU
ENDIF

if ! NETUSE("FUNCAO") 
   return
endif


if ! NETUSE(PES) 
   dbcloseall()
   return
endif
FILTRO := FILTRO( '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))' )
//FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
set filter to &FILTRO 
dbgotop()

try
   oConn:=CreateObject( "ADODB.Connection" )
   with object oConn
      :ConnectionString:=cConn
      :Open()
   end

   cCOMANDO:="SET ISOLATION TO DIRTY READ"
   oComm:=CreateObject( "ADODB.Command" )
   with object oComm
      :CommandText:=cCOMANDO
      :CommandType:=adCmdText
      :ActiveConnection:=oConn
      :Execute()
   end

catch oErr
     ShowAdoError(oERR,oCoNn,cCOMANDO)
end

oRegistro:= CreateObject('ADODB.RecordSet')
oRegistro:CursorLocation := 3
oRegistr2:= CreateObject('ADODB.RecordSet')
oRegistr2:CursorLocation := 3

aUNID:={}
aUNIDDESC:={}
cSQL:="SELECT cod_uni_funcio,den_uni_funcio FROM unidade_funcional"
CSQL+=" WHERE COD_EMPRESA='"+STRZERO(NREMP,2)+"' AND dat_validade_fim>=today"
TRY
  oRegistr2:Open(cSQL, oConN, adOpenForwardOnly,adLockReadOnly) 
catch oErr
  ShowAdoError(oERR,oConn,cSQL)
END  
while .not. oregistr2:eof                          
    AADD(aUNID,strval(oregistr2:fields("cod_uni_funcio"):value))       
    AADD(aUNIDDESC,strval(oregistr2:fields("den_uni_funcio"):value))       
    oregistr2:movenext()
enddo
oregistr2:close()           

aGrau:={}
agrauDESC:={}
cSQL:="SELECT * FROM grau_instrucao"
TRY
  oRegistr2:Open(cSQL, oConN, adOpenForwardOnly,adLockReadOnly) 
catch oErr
  ShowAdoError(oERR,oConn,cSQL)
END  
while .not. oregistr2:eof                          
    AADD(agrau,oregistr2:fields("cod_grau_instr"):value)       
    AADD(agrauDESC,strval(oregistr2:fields("den_grau_instr"):value))       
    oregistr2:movenext()
enddo
oregistr2:close()           


LISTARUE( { | X | FOPTO32( X ) } )
oConn:close()
dbcloseall()
        
FUNCTION FOPTO32
para COMPARE        
WHILE ! FO_PES->(EOF())
  if &COMPARE
    VIDEO()
    PETELA(8)
    Impressora()
    nNUMERO:=FO_PES->NUMERO
    
    mREQCNH:=OBTER("FUNCAO",,FO_PES->FUNCAO,"REQCNH")
    mREQOC :=OBTER("FUNCAO",,FO_PES->FUNCAO,"REQOC")
    
    // IF nNUMERO=334
      CSQL:="SELECT f.cod_empresa,f.num_matricula,f.nom_completo,"
      CSQL+=" fi.end_funcio,fi.end_compl,rhu_funcionarios_compl.num_cartao_saude,"
      CSQL+=" b.den_bairro,c.den_cidade,c.cod_uni_feder,fi.cod_cep,f.cod_uni_funcio,"
      CSQL+=" fu.num_endereco,fu.num_cart_prof,fu.num_serie_prof,fu.uf_prof,fi.num_cpf,"
      cSQL+=" fi.num_cart_ident,fi.uf_ident,fi.ies_org_ident,fu.dat_emissao_ci, "
      CSQL+=" fu.cat_cnh,fu.num_cnh,fu.dat_venc_cnh,fu.num_inscricao_inss,fi.num_telef_res,"
      CSQL+=" fi.cod_grau_instr,fi.ies_est_civil,fi.ies_aposentado,fi.num_pis,"
      CSQL+=" age(fi.dat_nascimento) as idade,fi.dat_nascimento,cidades.cod_uni_feder AS UFNasc,cidades.den_cidade AS CidNasc,  "
      cSQL+=" fun_meio_contato.den_contato AS email,rhu_funcionarios_compl.tip_logradouro "
      CSQL+=" FROM funcionario f LEFT OUTER JOIN fun_infor fi ON  fi.cod_empresa   = f.cod_empresa  AND fi.num_matricula = f.num_matricula"
      CSQL+=" LEFT OUTER JOIN fun_diversos fu ON  fu.cod_empresa   = f.cod_empresa  AND fu.num_matricula = f.num_matricula"                          
      CSQL+=" LEFT OUTER JOIN bairros b    ON  b.cod_cidade = fi.cod_cidade  AND b.cod_bairro = fi.cod_bairro"
      CSQL+=" LEFT OUTER JOIN cidades c    ON  c.cod_cidade = fi.cod_cidade"
      CSQL+=" LEFT OUTER JOIN cidades    ON  cidades.cod_cidade = fI.cod_cidade_nasc  "
      CSQL+=" LEFT JOIN rhu_funcionarios_compl ON f.cod_empresa=rhu_funcionarios_compl.cod_empresa AND f.num_matricula=rhu_funcionarios_compl.num_matricula "
      CSQL+=" LEFT JOIN fun_meio_contato ON f.cod_empresa=fun_meio_contato.cod_empresa AND f.num_matricula=fun_meio_contato.num_matricula AND ies_contato='E' "
      CSQL+=" where f.cod_empresa='"+STRZERO(NREMP,2)+"'"
      CSQL+=" AND f.num_matricula="+STR(nNUMERO)   
       TRY
          oRegistro:Open(cSQL, oConN, adOpenForwardOnly,adLockReadOnly) //1, 3)
       catch oErr
           ShowAdoError(oERR,oConn,cSQL)
       END    
       if .NOT. oregistro:eof  
           cUNID:=""
           nPOS:=ASCAN(aUNID,STRVAL(oregistro:fields("cod_uni_funcio"):value))  
           IF nPOS>0
              cUNID:=aUNIDDESC[nPOS]
           ENDIF  
           
           cINSTR:=""
           nPOS:=ASCAN(aGRAU,oregistro:fields("cod_grau_instr"):value)  
           IF nPOS>0
              cINSTR:=aGRAUDESC[nPOS]
           ENDIF  
            @ PROW()+1, 0 SAY "  PARA       : "+STRVAL(oregistro:fields("nom_completo"):value)            
            @ PROW()+1, 0 SAY "  MATRICULA  : "+STR(NUMERO,8)
            @ PROW() , 40 SAY "  SETOR      : "+cUNID
            @ PROW()+1, 0 SAY ""
            @ PROW()+1, 0 SAY "                           ATUALIZACAO DADOS CADASTRAIS                       "
            @ PROW()+1, 0 SAY ""                                                                              
            @ PROW()+1, 0 SAY "      Solicitamos CONFERIR os dados abaixo, visando atualizacao do Cadastro   "
            @ PROW()+1, 0 SAY "      de Empregados, 'PARA A RECEITA FEDERAL' . "                              
            @ PROW()+1, 0 SAY ""                                                                              
            @ PROW()+1, 0 SAY "      DADOS DO CADASTRO ATUAL              HOUVE ALTERACAO ( ) SIM   ( ) NAO  "
            @ PROW()+1, 0 SAY ""    
            // POT32LIN("",STRVAL(oregistro:fields(""):value),.T.)
            cENDERECO:=     ALLTRIM(STRVAL(oregistro:fields("tip_logradouro"):value))
            cENDERECO+="  "+ALLTRIM(STRVAL(oregistro:fields("end_funcio"):value))
            cENDERECO+=", "+ALLTRIM(STRVAL(oregistro:fields("num_endereco"):value))
            cENDERECO+="  "+ALLTRIM(STRVAL(oregistro:fields("end_compl"):value))            
            POT32LIN("ENDERECO",cENDERECO,.F.)            
            POT32LIN("BAIRRO",STRVAL(oregistro:fields("den_bairro"):value),.F.)
            POT32LIN("MUNICIPIO",STRVAL(oregistro:fields("den_cidade"):value),.F.)
            POT32LIN("CEP",STRZERO(oregistro:fields("cod_cep"):value,8),.F.)
            POT32LIN("TELEFONE",FORMATATEL(STRVAL(oregistro:fields("num_telef_res"):value)),.F.) 
            POT32LIN("EMAIL",STRVAL(oregistro:fields("email"):value),.F.)
            POT32LIN("CPF",STRVAL(oregistro:fields("num_cpf"):value),.F.)
            POT32LIN("PIS",STRVAL(oregistro:fields("num_pis"):value),.F.)            
            cRG:=      ALLTRIM(STRVAL(oregistro:fields("num_cart_ident"):value))
            cRG+="/"  +ALLTRIM(STRVAL(oregistro:fields("uf_ident"):value))
            cRG+="-"+ALLTRIM(STRVAL(oregistro:fields("ies_org_ident"):value))
            cRG+=" "+strval(oregistrO:fields("dat_emissao_ci"):value,,,"DMY/4")   
            
            
            POT32LIN("RG",cRG,.F.)
            cCTPS:=STRVAL(oregistro:fields("num_cart_prof"):value)+" Serie:"+STRVAL(oregistro:fields("num_serie_prof"):value)+" UF:"+STRVAL(oregistro:fields("uf_prof"):value)
            POT32LIN("CTPS",cCTPS,.F.)   

            IF mREQCNH="S"
               cCNH:=    ALLTRIM(STRVAL(oregistro:fields("num_cnh"):value))
               cCNH+="-"+ALLTRIM(STRVAL(oregistro:fields("cat_cnh"):value))
               cCNH+=" "+strval(oregistrO:fields("dat_venc_cnh"):value,,,"DMY/4")   
               POT32LIN("CNH",cCNH,.F.)              
            ENDIF

            /* abaixo             
            IF mREQOC="S"
               cOC:=    ALLTRIM(STRVAL(oregistro:fields(""):value))
               cOC+="-"+ALLTRIM(STRVAL(oregistro:fields(""):value))
               cOC+=" "+strval(oregistrO:fields(""):value,,,"DMY/4")   
               POT32LIN("Orgao Classe",cOC,.F.)              
            ENDIF
            */
            
            IF mREQOC="S"  //pegando dados ponto ate ajuste logix
               cOC:=ALLTRIM(OC)+"-"+ALLTRIM(OCEMI)+"Em: "+DTOC(OCEXP)+" Ate: "+DTOC(OCVAL)
               POT32LIN("Orgao Classe",cOC,.F.)              
            ENDIF
            
            POT32LIN("Cartao SUS",STRVAL(oregistro:fields("num_cartao_saude"):value),.F.)
            POT32LIN("GRAU INSTRUCAO",cINSTR,.F.)    
            cCIVCOD:=STRVAL(oregistro:fields("ies_est_civil"):value)
            cCIVIL:=""
            do case
               case cCIVCOD="S"
                   cCIVIL:="Solteiro(a)"
               case cCIVCOD="C"
                   cCIVIL:="Casado(a)"
               case cCIVCOD="V"
                   cCIVIL:="Viuvo(a)"
               case cCIVCOD="D"
                   cCIVIL:="Divorciado(a)"
               case cCIVCOD="Q"
                   cCIVIL:="Desquitado(a)"
               case cCIVCOD="M"
                   cCIVIL:="Marital"
               case cCIVCOD="U"
                   cCIVIL:="Uniao Estavel"                   
               case cCIVCOD="O"
                   cCIVIL:="Outros"                  
            endcase
            POT32LIN("ESTADO CIVIL",cCIVIL,.F.)    
            
            @ PROW()+1,2      SAY "Nascto: "+strval(oregistrO:fields("dat_nascimento"):value,,,"DMY/4")   
            @ PROW(),PCOL()+1 SAY "("+strval(oregistrO:fields("idade"):value)+") "
            @ PROW(),PCOL() SAY strval(oregistrO:fields("UFNasc"):value)+"-"
            @ PROW(),PCOL() SAY strval(oregistrO:fields("CidNasc"):value)
            @ PROW(),PCOL()+1 SAY REPL("_",17)      

            
            @ PROW()+1, 20 SAY "  DEPENDENTES PARA IMPOSTO DE RENDA "            
            cSQL:=" SELECT dependentes.*,rhu_depend_docum.cpf,RHU_DEPENDENTES_COMPL.num_cartao_saude "
            cSQL+=" ,age(dependentes.dat_nasc) AS idade,RHU_DEPENDENTES_COMPL.tip_dependente_sped_social AS esocial "
            cSQL+="             ,cidades.den_cidade,cidades.cod_uni_feder "
            cSQL+=" FROM dependentes "
            CSQL+="    left JOIN rhu_depend_docum ON  dependentes.cod_empresa=rhu_depend_docum.empresa "            
            CSQL+="       AND dependentes.num_matricula=rhu_depend_docum.matricula "
            CSQL+="       AND dependentes.num_depend=rhu_depend_docum.dependente "
            CSQL+="    left JOIN RHU_DEPENDENTES_COMPL ON  dependentes.cod_empresa=RHU_DEPENDENTES_COMPL.cod_empresa"
            CSQL+="       AND dependentes.num_matricula=RHU_DEPENDENTES_COMPL.num_matricula "
            CSQL+="       AND dependentes.num_depend=RHU_DEPENDENTES_COMPL.num_depend"
            CSQL+="    LEFT JOIN cidades on dependentes.cod_cidade_nasc=cidades.cod_cidade "                                        
            CSQL+=" WHERE  dependentes.cod_empresa='"+STRZERO(NREMP,2)+"'"
            CSQL+="       AND dependentes.num_matricula="+STR(nNUMERO) 
            TRY
               oRegistr2:Open(cSQL, oConN, adOpenForwardOnly,adLockReadOnly) 
            catch oErr
               ShowAdoError(oERR,oConn,cSQL)
            END  
            cPAI:=""
            cMAE:=""            
            cPAINASC:=""
            cMAENASC:=""     
            lTEMDEP:=.F.   
            while .not. oregistr2:eof              
               lTEMDEP:=.T.   
               nGRAU:=VAL(strval(oregistr2:fields("cod_grau_par"):value))
               nIDADE:=oregistr2:fields("idade"):value  
               if strval(oregistr2:fields("ies_dep_irrf"):value)="S"
                  cTIPODEP:="**** Tipo Esocial nao preenchido ****"
                  nESOCIAL:=VAL(strval(oregistr2:fields("esocial"):value))                     
                  DO CASE
                     CASE nESOCIAL=1
                          cTIPODEP:="01-Conjuge ou companheiro(a) com o(a) qual tenha filho ou viva ha mais de 5 (cinco) anos."
                     CASE nESOCIAL=2
                          cTIPODEP:="02-Filho(a) ou enteado(a) ate 21 (vinte e um) anos. "
                     CASE nESOCIAL=3
                          cTIPODEP:="03-Filho(a) ou enteado(a) universitario(a) ou cursando escola tecnica de 2º grau, até 24 (vinte e quatro) anos."
                     CASE nESOCIAL=4
                          cTIPODEP:="04-Filho(a) ou enteado(a) em qualquer idade, quando incapacitado física e/ou mentalmente para o trabalho."
                     CASE nESOCIAL=5
                          cTIPODEP:="05-Irmao(a), neto(a) ou bisneto(a) sem arrimo dos pais, do(a) qual detenha a guarda judicial, ate 21 (vinte e um) anos."
                     CASE nESOCIAL=6
                          cTIPODEP:="06-Irmao(a), neto(a) ou bisneto(a) sem arrimo dos pais, com idade até 24 anos, se ainda estiver cursando estabelecimento de nível superior ou escola técnica de 2º grau, desde que tenha  detido sua guarda judicial até os 21 anos."
                     CASE nESOCIAL=7
                          cTIPODEP:="07-Irmao(a), neto(a) ou bisneto(a) sem arrimo dos pais, do(a) qual detenha a guarda judicial, em qualquer idade, quando incapacitado física e/ou mentalmente para o trabalho."
                     CASE nESOCIAL=8
                          cTIPODEP:="08-Pais, avos e bisavos."
                     CASE nESOCIAL=9
                          cTIPODEP:="09-Menor pobre, até 21 (Vinte e um) anos, que crie e eduque e o qual detenha a guarda judicial."
                     CASE nESOCIAL=10
                          cTIPODEP:="10-A pessoa absolutamente incapaz, da qual seja tutor ou curador."
                  END CASE
                  cCPFDEP:=strval(oregistr2:fields("cpf"):value)                  
                  @ PROW()+1, 0 SAY " "+padr(strval(oregistr2:fields("nom_depend"):value),40)+" CPF:"+IF(EMPTY(cCPFDEP),REPL("_",20),cCPFDEP)
                  IF nIDADE>=16 .AND. EMPTY(cCPFDEP)
                     @ PROW()+1, 0 SAY "**** Maior de 16 anos cpf obrigatório ****"
                  ENDIF
                  IF nIDADE=15.AND. EMPTY(cCPFDEP)
                     @ PROW()+1, 0 SAY "**** Ira Fazer 16 anos cpf obrigatório ****"
                  ENDIF
                  IF LEN(cTIPODEP)>80
                     @ PROW()+1, 0 SAY SUBSTR(cTIPODEP,1,80)
                     @ PROW()+1, 4 SAY SUBSTR(cTIPODEP,81,160)
                  ELSE
                     @ PROW()+1, 0 SAY cTIPODEP
                  ENDIF
                  @ PROW()+1,0      SAY "Nascto: "+strval(oregistr2:fields("dat_nasc"):value,,,"DMY/4")   
                  @ PROW(),PCOL()+1 SAY " ("+strval(nIDADE)+") "
                  @ PROW(),PCOL() SAY strval(oregistr2:fields("cod_uni_feder"):value)+"-"
                  @ PROW(),PCOL() SAY strval(oregistr2:fields("den_cidade"):value)
                  @ PROW(),PCOL()+1 SAY REPL("_",17)
                  POT32LIN("Cartao SUS",STRVAL(oregistr2:fields("num_cartao_saude"):value),.F.)                  
               endif 
               if nGRAU=1
                  cPAI:=strval(oregistr2:fields("nom_depend"):value)
                  cPAINASC:=strval(oregistr2:fields("dat_nasc"):value,,,"DMY/4")
                  cPAINASC+=" ("+strval(nIDADE)+") "
                  cPAINASC+=strval(oregistr2:fields("cod_uni_feder"):value)+"-"
                  cPAINASC+=strval(oregistr2:fields("den_cidade"):value)
               endif
               if nGRAU=2
                  cMAE:=strval(oregistr2:fields("nom_depend"):value)
                  cMAENASC:=strval(oregistr2:fields("dat_nasc"):value,,,"DMY/4")
                  cMAENASC+=" ("+strval(nIDADE)+") "
                  cMAENASC+=strval(oregistr2:fields("cod_uni_feder"):value)+"-"
                  cMAENASC+=strval(oregistr2:fields("den_cidade"):value)
               endif 
               if (nGRAU=7  .or. ngrau=8 .or. ngrau=9 .or. ngrau=18) .AND. nIDADE<=14
                  cREGISTRO:=alltrim(STRVAL(oregistr2:fields("matR_reg_nasc"):VALUE))
                  IF Val(cREGISTRO)=0
                     cREGISTRO:=StrVAL(oregistr2:fields("num_reg_nasc"):VALUE) 
                  ELSE 
                     IF LEN(cREGISTRO)<>32
                        @ PROW()+1,0 SAY "**** Rici nao tem 32 digitos ****"
                     ENDIF                     
                  ENDIF                  
                  IF Val(cREGISTRO)=0
                     @ PROW()+1,0 SAY "*** filho(a)/enteado(a) menor 14 anos sem certidão nascimento/rici ****"
                  ENDIF
               ENDIF
               @ PROW()+1, 0 SAY " "+REPL("-",68)+" "
               oregistr2:movenext()
            enddo
            oregistr2:close()           
            IF ! lTEMDEP
               @ PROW()+1, 0 SAY " "+REPL("-",68)+" "            
            ENDIF   
            @ PROW()+1, 0 SAY "             VOCE E APOSENTADO?   (    ) SIM        (    ) NAO                "
            @ PROW()+1, 0 SAY " "+REPL("-",68)+" "
            @ PROW()+1, 0 SAY "(PAI) "+ALLTRIM(cPAI)+ " Nascto:"+cPAINASC
           // @ PROW()+1, 0 SAY "      NOME DO PAI (SEM ABREVIAR)   "+cPAI            
            //@ PROW()+1, 0 SAY " DATA DE NASCIMENTO (PAI) "+cPAINASC
            @ PROW()+1, 0 SAY ""
            @ PROW()+1, 0 SAY "      ___________________________________________ _______/_________/__________ "
            @ PROW()+1, 0 SAY ""                                
            @ PROW()+1, 0 SAY "(MAE) "+ALLTRIM(cMAE)+ " Nascto:"+cMAENASC            
//            @ PROW()+1, 0 SAY "      NOME DA MAE (SEM ABREVIAR)   "+cMAE
//            @ PROW()+1, 0 SAY " DATA DE NASCIMENTO (MAE) "+cMAENASC
            @ PROW()+1, 0 SAY ""
            @ PROW()+1, 0 SAY "      ___________________________________________ _______/_________/__________ "                     
            @ PROW()+1, 0 SAY " "+REPL("-",68)+" "
            @ PROW()+1, 0 SAY ""
            @ PROW()+1, 0 SAY "      FAVOR ASSINAR E DEVOLVER PARA O DEPARTAMENTO PESSOAL URGENTE            "
            @ PROW()+1, 0 SAY ""                                                                              
            @ PROW()+1, 0 SAY ""                  
            @ PROW()+1, 0 SAY " "+DTOC(DATE())+" "+REPL("-",58)+" "            
            @ PROW()+1, 12 SAY STR(NUMERO,8)+" "+PADR(STRVAL(oregistro:fields("nom_completo"):value),34)+cUNID
            //@ PROW()+1, 0 SAY "      ___________________________________________                             "
//            @ PROW()+1, 0 SAY "      "+PADR(STRVAL(oregistro:fields("nom_completo"):value),34)+cUNID
            //@ PROW()+1, 0 SAY "      "+STR(NUMERO,8)+SPACE(40)+DTOC(DATE())           
         impfol()
       endif  
       oRegistro:CLOSE()
   // ENDIF      
   ENDIF  
   FO_PES->(DBSKIP())  
ENDDO
//IMPEND()
//dbcloseall()
//oConn:close()


FUNCTION POT32LIN(cTIT,cVAR,llINHA)
@ PROW()+1, 0 SAY "  "+PADR(cTIT,10)+" : "+PADR(cVAR,30)+" "+REPLICATE("_",30)
IF lLINHA
   @ PROW()+1, 0 SAY ""
ENDIF
