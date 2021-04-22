MDI("Gerar Remessa Combran‡a")
cContrato:=SPACE(12)
cEMP:=PADR("ITAESBRA",30)
cSUB:="I"
cIN1:="10"
cIN2:="38"
cESP:="01"
cOCO:="01"
nSEQ:=1
cBANCO='341' //Itau
cBANCONOME:=SPACE(15)
cARQUIVO:="C:\BANCOS\       .TXT"+SPACE(40)
@ 08,09 SAY "Codigo Banco"
@ 08,30 get cBANCO PICT '999' VALID CHECKEXI("MF01","cBANCO","STRVAL(NUMERO)+' '+NOME","NUMERO","BANCO",.T.)
READCUR()

cCAR:="   "
PEGACAMPO("MF01","cBANCO",{"LEFT(CARTEIRA,3)"},{"cCAR"})
IF EMPTY(CARQ)
   cCAR:="112"
ENDIF


DO CASE
   CASE cBANCO='341'
        cBANCONOME:=PADR("BANCO ITAU SA",15)
        cContrato:=PADR("024900657818",12)
   CASE cBANCO='237'
        cBANCONOME:=PADR("BRADESCO",15)
   CASE cBANCO='353'
        cBANCONOME:=PADR("SANTANDER",15)
        cCONTRATO:=padr("21944290895742908957",20)
        cSUB:="2"
   CASE cBANCO='479'
        cBANCONOME:=PADR("BANKBOSTON",15)
        cCONTRATO:=SPACE(8)
ENDCASE
TELASAY( "GERCOB" )
EDITSAY( "GERCOB" )

IF !  MDG("Iniciar Gera‡ao Arquivo")
    RETU .F.
ENDIF


FILTRO := RFILORD( "MN01", .F., "" )
IF ! USEMULT({{"MN01",1,99},{"MB01",1,1},{"MA01",1,1}})
   RETU .F.
ENDIF


cARQUIVO:=STRTRAN(cARQUIVO," ","")

USO:=FCREATE(cARQUIVO)
if ferror() # 0
   ALERTX( "Erro na Cria‡„o do Arquivo" )
   retu
endif


SET CENTURY OFF
//Header
FWRITE(USO,"0")  //1
FWRITE(USO,"1")  //2
FWRITE(USO,"REMESSA") //3-9 Remessa
FWRITE(USO,"01") //10-11
FWRITE(USO,PADR("COBRANCA",15)) //12-26
DO CASE
   case cBANCO='479' //B Boston
      FWRITE(USO,SPACE(2)) //27-28
      FWRITE(USO,"1") //29 Producao
      FWRITE(USO,PADR(cCONTRATO,8))  //30-37
      FWRITE(USO,SPACE(9)) //38-46
   CASE cBANCO='353' //Santander
      FWRITE(USO,PADR(cCONTRATO,20)) //27-46
//      FWRITE(USO,SPACE(2)) //27-28
//      FWRITE(USO,"1") //29 Producao
//      FWRITE(USO,SPACE(9)) //30-39
//      FWRITE(USO,PADR(cCONTRATO,8))  //39-46
   OTHERWISE //Outros Itau
      FWRITE(USO,padr(cContrato,12)) //27-38
      FWRITE(USO,SPACE(8)) //39-46
ENDCASE
FWRITE(USO,PADR(cEMP,30)) //47 Nome do cedente
//FWRITE(USO,strzero(cBANCO,3)) //77-79
FWRITE(USO,cBANCO)
FWRITE(USO,PADR(cBANCONOME,15)) //80-94  Nome do Banco
FWRITE(USO,STRTRAN(DTOC(ZDATA),"/","")) //95-100 Data Gravacao
FWRITE(USO,SPACE(294)) //101-394
FWRITE(USO,STRZERO(nSEQ,6)) //394-400 Sequencia
FWRITE(USO,CHR(13)+CHR(10))
nSEQ++


//Registros
DBSELECTAR("MN01")
if !empty( FILTRO )
   set filter to &FILTRO
endif
DBGOTOP()
WHILE ! EOF()
  IF GERACOB="S".AND.(BANCO=cBANCO.or.empty(BANCO))
       FWRITE(USO,"1") //001-001Tipo Registro
       FWRITE(USO,"02")  //003-003 Tipo Inscr 01-CPF 02-CGC
       FWRITE(USO,STRZERO(0,14)) //004-0017 Inscr
       IF cBANCO='353'
          FWRITE(USO,padr(cContrato,20)) //018-037 Contrato AgDc4Conta8Conta8
       ELSE
          FWRITE(USO,padr(cContrato,12)) //Contrato
          FWRITE(USO,SPACE(4))  //Brancos
          FWRITE(USO,SPACE(4))  //Instru‡ao Alegacao
       ENDIF
       FWRITE(USO,SPACE(25)) //038-062 Identificaco Empresa
       FWRITE(USO,STRZERO(0,8)) //063-070 Titulo Banco
       IF cBANCO='353'
          FWRITE(USO,"000000")   //071-076 Data Segundo Desconto
          FWRITE(USO," ")   //077-077 Branco
          FWRITE(USO,"0")   //078-078 Informacao de Multa
          FWRITE(USO,"0000")   //079-082 Multa por atraso
          FWRITE(USO,"00")       //083-084 Unidade de Valor Moeda corrente00
          FWRITE(USO,STRZERO(0,13))  //085-097 Valor do Titulo Outra Unidade
          FWRITE(USO,SPACE(4))   //098-101 Brancos
          FWRITE(USO,"000000")   //102-107 Data para Cobranca de Multa
       ELSE
          FWRITE(USO,STRZERO(0,13)) //Qtde Moedas(13)
          FWRITE(USO,cCAR) //Numero carteira(3)
          FWRITE(USO,SPACE(21))   //Uso Banco(21)
       ENDIF
       FWRITE(USO,cSUB) //108-108 Carteira
       FWRITE(USO,cOCO ) //109-110 Codigo Ocorrencia
       FWRITE(USO,PADR(ALLTRIM(STR(NUMERO,8)),10)) //111-120 N§ Documento
       FWRITE(USO,STRTRAN(DTOC(VENCIMENT),"/","")) //121-126 Vencimento
       mVALATUAL:=VALOR+JUROS-ABATER+JURVAL-VALPIS-VALFIN
       FWRITE(USO,GRVVAL(mVALATUAL,13,2)) //Valor com os Abatimentos
       //FWRITE(USO,strzero(cBANCO,3)) //codigo do Banco
       FWRITE(USO,cBANCO) //codigo do Banco
       FWRITE(USO,STRZERO(0,5)) //Agencia Cobranca
       FWRITE(USO,cESP )  //Especia do titulo
       FWRITE(USO,"N" ) //Aceito s/n
       FWRITE(USO,STRTRAN(DTOC(DATA),"/","")) //Emissao Titulo
       FWRITE(USO,cIN1)  //1§ Instru‡ao
       FWRITE(USO,cIN2) //2¦ Instru‡ao
       FWRITE(USO,STRZERO(0,13))  //Juros
       FWRITE(USO,SPACE(6)) //Desconto ate
       FWRITE(USO,STRZERO(0,13))  //Valor desconto
       FWRITE(USO,STRZERO(0,13)) //Iof
       FWRITE(USO,STRZERO(0,13)) //Abatimento
       mTIPOCLI:=TIPOCLI
       mFORNECEDO:=FORNECEDO
       mNUMERO:=NUMERO
       DBSELECTAR("MA01")
       IF mTIPOCLI="F"
          DBSELECTAR("MB01")
       ENDIF
       DBGOTOP()
       IF ! DBSEEK(mFORNECEDO)
           ALERTX("Cliente/Fornecedo Nao Encontrado NF"+STR(mNUMERO))
           FCLOSE(USO)
           FERASE(USO)
           DBCLOSEALL()
           RETU
       ENDIF
       FWRITE(USO,IF(PESSOA="J","02","01")) //tipo
       FWRITE(USO,STRZERO(VAL(TIRAOUT(CGC)),14)) //CGC
       FWRITE(USO,PADR(TIRAOUT(NOME),30)) //NOme
       FWRITE(USO,SPACE(10))  //Brancos
       IF mTIPOCLI="F"
          FWRITE(USO,PADR(TIRAOUT(ENDERECO),40)) //Endereco
          FWRITE(USO,PADR(TIRAOUT(BAIRRO),12)) //Bairro
          FWRITE(USO,STRZERO(VAL(TIRAOUT(CEP)),8) ) //Cep
          FWRITE(USO,PADR(TIRAOUT(CIDADE),15)) //Cidade
          FWRITE(USO,UPPER(ESTADO)) //Estado
       ELSE
          FWRITE(USO,PADR(TIRAOUT(ENDERECO2),40)) //Endereco
          FWRITE(USO,PADR(TIRAOUT(BAIRRO2),12)) //Bairro
          FWRITE(USO,STRZERO(VAL(TIRAOUT(CEP2)),8) ) //Cep
          FWRITE(USO,PADR(TIRAOUT(CIDADE2),15)) //Cidade
          FWRITE(USO,UPPER(ESTADO2)) //Estado
       ENDIF
       FWRITE(USO,SPACE(30)) //Brancos
       FWRITE(USO,SPACE(4)) //Complemenos
       FWRITE(USO,SPACE(6))  //Data MOra
       FWRITE(USO,"00" ) //Qtdias
       FWRITE(USO," " ) //Brancos
       FWRITE(USO,STRZERO(nSEQ,6)) //Sequencial
       FWRITE(USO,CHR(13)+CHR(10))
       nSEQ++
       DBSELECTAR("MN01")
       GRAVACAMPO("GERACOB","'G'")
       IF EMPTY(BANCO)
          GRAVACAMPO("BANCO","cBANCO")
       ENDIF
   ENDIF
  DBSKIP()
ENDDO
//Trailer
FWRITE(USO,"9")
FWRITE(USO,SPACE(393))
FWRITE(USO,STRZERO(nSEQ,6))
FWRITE(USO,CHR(13)+CHR(10))
FWRITE(USO,CHR(26))
FCLOSE(USO)

FUNC MANVOLTG
MDI(" Ý Retornar Geradas")
cARQ:="MN01"
dDATA:=ZDATA
dDATF:=ZDATA
cBANCO:='341'
@ 24,00 SAY "Digite Data Emiss„o/Banco"
@ 24,40 GET dDATA
@ 24,50 GET dDATF
@ 24,60 GET cBANCO PICT '999' VALID CHECKEXI("MF01","cBANCO","STRVAL(NUMERO)+' '+NOME","NUMERO","BANCO",.T.)
IF ! readcur()
   retu .f.
ENDIF
FILTRO := RFILORD( "MN01", .F., "" )
IF ! MDG("Retornar Geradas")
   RETU .F.
ENDIF

IF ! USEREDE(cARQ,1,99)
   RETU .F.
ENDIF
DBSELECTAR(cARQ)
IF ! EMPTY(FILTRO)
   SET FILTER TO &FILTRO.
ENDIF
DBGOTOP()
WHILE ! EOF()
   @ 24,00 SAY RECNO()
   IF GERACOB="G".AND.BANCO=cBANCO
      IF DATA>=dDATA.AND.DATA<=dDATF
         GRAVACAMPO("GERACOB","'S'")
      ENDIF
   ENDIF
   DBSELECTAR(cARQ)
   DBSKIP()
ENDDO
dbcloseaLL()


FUNC MANPISCON
LOCAL nPERPIS,nPERFIN
nPERPIS:=0.1
nPERFIN:=0.5
MDI(" Ý Gerar Pis-Confins")
@ 24,00 SAY "Digite Pis/Confins"
@ 24,40 GET nPERPIS PICT "99.99"
@ 24,50 GET nPERFIN PICT "99.99"
IF ! readcur()
   retu .f.
ENDIF
FILTRO := RFILORD( "MN01", .F., "" )
IF ! MDG("Gerar Pis/Confins")
   RETU .F.
ENDIF
IF ! USEREDE("MN01",1,99)
   RETU .F.
ENDIF
DBSELECTAR("MN01")
IF ! EMPTY(FILTRO)
   SET FILTER TO &FILTRO.
ENDIF
DBGOTOP()
WHILE ! EOF()
   @ 24,00 SAY RECNO()
   nVALPIS:=ROUND(VALOR*nPERPIS/100,2)
   nVALFIN:=ROUND(VALOR*nPERFIN/100,2)
   nVALATUAL:=VALOR+JUROS-ABATER+JURVAL-nVALPIS-nVALFIN //Nvalpis/fin precisam ser os caluldos
   GRAVACAMPO({"VALPIS","VALFIN","VALATUAL"},{nVALPIS,nVALFIN,nVALATUAL},,.T.,.F.,.F.)
   DBSELECTAR("MN01")
   DBSKIP()
ENDDO
dbcloseaLL()

