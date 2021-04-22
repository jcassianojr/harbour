MDI("Ý Importando GIA")
IF MDG("Criar Acumulado por CFO")
   M_BDIG(2)
endif
if mdg("Criar Acumulado por CFO-UF")
   M_BDIO()
endif
if mdg("Criar Acumulado ZF/ALC")
   GIAZF()
ENDIF


if ! USEREDE( "MANEMP", 1, 1 )
   retu .F.
endif
dbgotop()
if ! dbseek( ZNUMERO )
   dbcloseall()
   ALERTX( "Falta Cadastro Empresa" )
   retu
else
   cCGC      := CGC
   cIE       := INSCR
   cCIDADE   := CIDADE
   cESTADO   := ESTADO
   cNOME     := NOME
   cTELEFAX  := TELEFAX
   cDDDFAX   := DDDFAX
   cENDERE   := ENDERECO
   cBAIRRO   := BAIRRO
   cCEP      := CEP
   cCONTATO  := CONTATO
   cDDD      := DDD
   cTELEFONE := TELEFONE
endif
dbcloseall()
cANO:=STRZERO(YEAR(ZDATA),4)
cMES:=STRZERO(MONTH(ZDATA),2)
cCNAE:="2833900"

cLAYOUT:="0206"


HB_dispbox( 4, 0, 23, 79, B_DOUBLE)
@  5,  2 say "Dados do Reponsavel Pelo Arquivo"

@ 06, 02 say "Nome do Arquivo"
@ 07, 02 SAY "Competencia"
@ 08, 02 SAY "Cnae"
@ 09, 02 SAY "Layout"
@ 07, 20 get cMES
@ 07, 24 GET cANO
@ 08, 20 get cCNAE
@ 09,20 get cLAYOUT
IF ! READCUR()
   RETU .F.
ENDIF

cARQUIVO:=WIN_GETSAVEFILENAME(, "Salvar GIA","C:\TEMP\","txt", "*.txt" , 1 , , "G"+cANO+cMES+STRZERO(ZNUMERO,1)+".TXT")

//cARQUIVO:="C:\TEMP\G"+cANO+cMES+STRZERO(ZNUMERO,1)+".TXT"+SPACE(20)
//@ 06, 20 get cARQUIVO
//IF ! READCUR()
//   RETU .F.
//ENDIF

if ! useMULT({{"APUCFOUF",1,99},{"APUCFO",1,99},{"APUCFOZF",1,99}})
   dbclosearea()
ENDIF
QT10:=QT20:=QT30:=QT31:=0
DBSELECTAR("APUCFO")
QT10:=LASTREC()

SET CENTURY ON
cARQUIVO:=STRTRAN(cARQUIVO," ","")
USO:=FCREATE(cARQUIVO)
if ferror() # 0
   ALERTX( "Erro na Criacao do Arquivo" )
   retu
endif
//Mestre
FWRITE(USO,"01")
FWRITE(USO,"01")
FWRITE(USO,DTOS(ZDATA))
FWRITE(USO,LEFT(TIRAOUT(TIME()),6))
FWRITE(USO,"0000")
FWRITE(USO,cLAYOUT) //203 ate versao 7.3 //204 versao 7.4 //205 versao 7.5
FWRITE(USO,"0001") //So Uma Empresa //Somente um 05
FWRITE(USO,HB_OSNEWLINE())
//Empresa
QT10:=0
DBSELECTAR("APUCFO")
dbgotop()
while ! eof()
   qt10++
   dbskip()
enddo

FWRITE(USO,"05")
FWRITE(USO,ACEPAD( TIRAOUT( cIE ), 12 ))
FWRITE(USO,ACEPAD( TIRAOUT( cCGC ), 14 ))
FWRITE(USO,STRZERO(VAL(cCNAE),7))
FWRITE(USO,"01") //Regime Periodico de Apuracao(RPA)
FWRITE(USO,cANO)
FWRITE(USO,cMES)
FWRITE(USO,"000000") //RPA 01 zeros
FWRITE(USO,"01") //Gia Normal
FWRITE(USO,"1") //Houve Movimento no Mes
FWRITE(USO,"0") //Ainda nao foi transmitida
FWRITE(USO,GRVVAL(0,15,2)) //Credor Anterior
FWRITE(USO,GRVVAL(0,15,2)) //Credor Anterior SubsTrit
FWRITE(USO,ACEPAD( TIRAOUT( cCGC ), 14 ))
FWRITE(USO,"0") //0 Gerado pelo Sistema
FWRITE(USO,GRVVAL(0,15,2)) //Pre fixado 0 para RPA 01
FWRITE(USO,REPL("0",32)) //Chave Interna
FWRITE(USO,STRZERO(QT10,4))
FWRITE(USO,STRZERO(QT20,4))
FWRITE(USO,STRZERO(QT30,4))
FWRITE(USO,STRZERO(QT31,4))
FWRITE(USO,HB_OSNEWLINE())

DBSELECTAR("APUCFOUF")
DBSETORDER(3) //Novo CFO Codigo UFGIA

DBSELECTAR("APUCFO")
DBSETORDER(2) //Novo CFO
DBGOTOP()
WHILE ! EOF()
   QT14:=0
   cCFONEW:=ALLTRIM(CFONEW)
   IF LEFT(cCFONEW,1)="2".OR.LEFT(cCFONEW,1)="6" //Somente Interestduais
      DBSELECTAR("APUCFOUF")
      DBGOTOP()
      DBSEEK(cCFONEW)
      WHILE cCFONEW=ALLTRIM(CFONEW).AND.! EOF()
         IF UF<>"ZZ"
            QT14++
         ENDIF
         DBSKIP()
      ENDDO
   ENDIF
   DBSELECTAR("APUCFO")
   //Registro CFO
   FWRITE(USO,"10")
   FWRITE(USO,cCFONEW+"00")
   FWRITE(USO,GRVVAL(CONTABIL,15,2))
   FWRITE(USO,GRVVAL(BASE,15,2))
   FWRITE(USO,GRVVAL(VALOR,15,2))
   FWRITE(USO,GRVVAL(ISENTA,15,2))
   FWRITE(USO,GRVVAL(outra,15,2))
   FWRITE(USO,GRVVAL(0,15,2)) //Imposto Retido ST
   FWRITE(USO,GRVVAL(0,15,2)) //Imposto Ret Subistutivo SP
   FWRITE(USO,GRVVAL(0,15,2)) //Imposto Substituido
   FWRITE(USO,GRVVAL(0,15,2)) //Outros Impostos
   FWRITE(USO,STRZERO(QT14,4))
   FWRITE(USO,HB_OSNEWLINE())
   IF LEFT(cCFONEW,1)="2".OR.LEFT(cCFONEW,1)="6" //Somente Interestduais
      DBSELECTAR("APUCFOUF")
      DBSEEK(cCFONEW)
      WHILE cCFONEW=ALLTRIM(CFONEW).AND.! EOF()
          nZONA:=0
          IF UF<>"ZZ"
             //Registro ESTADO
             FWRITE(USO,"14")
             FWRITE(USO,UFGIA)
             fWRITE(USO,GRVVAL(CONTABIL,15,2))
             FWRITE(USO,GRVVAL(BASE,15,2))
             FWRITE(USO,GRVVAL(0,15,2)) //Valor Contabil Nao contribuitem
             FWRITE(USO,GRVVAL(0,15,2)) //Base Contabil nao contribuitem
             FWRITE(USO,GRVVAL(VALOR,15,2))
             FWRITE(USO,GRVVAL(OUTRA,15,2))
             FWRITE(USO,GRVVAL(0,15,2)) //Imposto Cobrado ST
             FWRITE(USO,GRVVAL(0,15,2)) //Petroleo Energia
             FWRITE(USO,GRVVAL(0,15,2)) //Outros Produtos
             IF cCFONEW="6109"
                DBSELECTAR("APUCFOZF")
                nZONA=LASTREC()
             ENDIF
             IF nZONA>0
                FWRITE(USO,"1") //Sem Zona Franca/alc
                FWRITE(USO,STRZERO(nZONA,4)) //qt18 reg18zona franca
             ELSE
                FWRITE(USO,"0") //Sem Zona Franca/alc
                FWRITE(USO,STRZERO(0,4)) //qt18 reg18zona franca
             ENDIF
             FWRITE(USO,HB_OSNEWLINE())
          ENDIF
          IF nZONA>0
             DBSELECTAR("APUCFOZF")
             DBGOTOP()
             WHILE ! EOF()
                  FWRITE(USO,"18")
                  FWRITE(USO,STRZERO(NF,6))
                  FWRITE(USO,DTOS(DATA))
                  FWRITE(USO,GRVVAL(VALOR,15,2))
                  FWRITE(USO,TIRAOUT(CNPJ))
                  FWRITE(USO,CODMUN)
                  FWRITE(USO,HB_OSNEWLINE())
                  DBSKIP()
             ENDDO
          ENDIF
          DBSELECTAR("APUCFOUF")
          DBSKIP()
      ENDDO
   ENDIF
   DBSELECTAR("APUCFO")
   DBSKIP()
ENDDO
FCLOSE(USO)
DBCLOSEALL()

FUNC GIAZF()
aRETU   := PERFEC( { "MM01" }, { "M1" }, { "MM91" } )
cARQSAI := aRETU[ 5, 1 ]
if ! useMULT({{"APUCFOZF",0,99},{cARQSAI,1,99},{"MA01",1,99}})
   dbclosearea()
ENDIF
DBSELECTAR("APUCFOZF")
ZAP
DBSELECTAR(cARQSAI)
dbgotop()
WHILE ! EOF()
   IF CFONEW="6109"
      mNF:=NUMERO
      mFOR:=FORNECEDO
      mVALOR:=TOTNF
      mDATA:=DATA
      mCNPJ:=""
      mCODMUN:="00000"
      DBSELECTAR("MA01")
      DBGOTOP()
      IF DBSEEK(mFOR)
         mCNPJ:=CGC
         DO CASE
            CASE CIDADE="GUARAJA MIRIM"
               mCODMUN:="00001"
            CASE CIDADE="BRASILEIA"
               mCODMUN:="00105"
            CASE CIDADE="CRUZEIRO DO SUL"
               mCODMUN:="00107"
            CASE CIDADE="MANAUS"
               mCODMUN:="00255"
            CASE CIDADE="BONFIM"
               mCODMUN:="00307"
            CASE CIDADE="MACAPA"
               mCODMUN:="00605"
            CASE CIDADE="PRESIDENTE FIGUEIREDO"
               mCODMUN:="09841"
            CASE CIDADE="RIO PRETO DA EVA"
               mCODMUN:="09843"
            CASE CIDADE="TABATINGA"
               mCODMUN:="09847"
            CASE CIDADE="EPITACIOLANDIA"
               mCODMUN:="99998"
            CASE CIDADE="PACARAIMA"
               mCODMUN:="99999"
         ENDCASE
      ENDIF
      DBSELECTAR("APUCFOZF")
      netrecapp()
      FIELD->NF:=mNF
      FIELD->DATA:=mDATA
      FIELD->VALOR:=mVALOR
      FIELD->CNPJ:=mCNPJ
      FIELD->CODMUN:=mCODMUN
   ENDIF
   DBSELECTAR(cARQSAI)
   DBSKIP()
ENDDO
DBCLOSEALL()
