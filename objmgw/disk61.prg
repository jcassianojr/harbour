*:*****************************************************************************
*:
*:     DISK61.PRG: Imprimir Arquivos de Textos
*:      Linguagem: Harbour
*:        Sistema: DISK61 - Imprimir Arquivos de Textos
*:  Atualizado em: 26/04/2010
*:
*:*****************************************************************************

*!*****************************************************************************
*!
*! Fun‡„o: IMPARQ(xarquivo,msetup,mmarlin,mmarinf,mmarsup,mmaresq,mmardir,mmarcol,mgraf)
*! xARQUIVO  Nome do Arquivo
*! mMARLIN   Numero de Linhas do Formul rio
*! mMARINF   Margem Inferior
*! mMARSUP   Margem Superior
*! mMARESQ   Margem Esquerda
*! mMARDIR   Margem Direita
*! mMARCOL   Numero de Coluna por folha
*! mGRAF     Imprimir Caracteres Graficos
*!
*!*****************************************************************************
FUNCtion imparq(xarquivo,msetup,mmarlin,mmarinf,mmarsup,mmaresq,mmardir,mmarcol,mgraf)

PRIV texto,Fim,meio,X,y,mlinha
//Checando os Parametos
IF VALTYPE(xarquivo)#"C"
   ALERTX("Falta nome de Arquivo")
   RETU .F.
ENDIF
IF ! file(xarquivo)
   ALERTX("Arquivo nao Encontrado")
   RETU .F.
ENDIF
nHANDLE  := fopen( xARQUIVO )
if nHANDLE = 0
   ALERTX( "Arquivo nAo Pode ser Aberto" )
endif
IF VALTYPE(msetup)#"C"
   msetup:=""
ENDIF
IF VALTYPE(mmarlin)#"N".OR.EMPTY(mmarlin)
   mmarlin:=66
ENDIF
IF VALTYPE(mmarinf)#"N" 
   mmarinf:=0
ENDIF
IF VALTYPE(mmarsup)#"N" 
   mmarsup:=0
ENDIF
IF VALTYPE(mmaresq)#"N"
   mmaresq:=0
ENDIF
IF VALTYPE(mmardir)#"N"
   mmardir:=0
ENDIF
IF VALTYPE(mmarcol)#"N".OR.EMPTY(mmarcol)
   mmarcol:=80
ENDIF
IF VALTYPE(mGRAF)="C"
   IF mGRAF="S"
      mGRAF:=.T.
   ENDIF
   IF mGRAF="N"
      mGRAF:=.F.
   ENDIF
ENDIF   
IF VALTYPE(mgraf)#"L"
   mgraf:=.F.
ENDIF

IF ! CHECKIMP(0)
   RETU .F.
ENDIF
IMPRESSORA()
IF ! Empty(msetup)
   msetup=ALLTRIM(msetup)
   @ PROW(),0 SAY &msetup
ENDIF
meio=mmarlin-(mmarsup*2)-mmarinf
lFIM:=.F.
WHILE ! lFIM
   @ PROW()+mmarsup,0 SAY ""
   FOR y=1 TO meio
      WHILE ! lFIM
           mLINHA:= RTRIM(FREADLINE( nHANDLE ))
           mLINHA:= LEFT(mLINHA,mmarcol-mmaresq-mmardir)
           IF  mLINHA="__FINAL__"
               lFIM:=.T.
           ELSE
              @ PROW()+1,mmaresq SAY mlinha
           ENDIF
      ENDDO
   NEXT y
   @ PROW()+mmarinf,0 SAY ""
ENDDO
fclose(nHANDLE)
IMPFOL()
VIDEO()
IMPEND()
RETU .T.



*!*****************************************************************************
*!
*!         Fun‡„o: TIPOIMP()
*!
*!    Chamado por: IMPARQ()     (fun‡„o em DISK61.PRG)
*!
*!*****************************************************************************
FUNC tipoimp(texto)
aORI:={'#AQ','#DQ' ,'#AE','#AC','#DC',;
       '#AI','#DI','#AN','#DN','#AX', ;
       '#AD','#DXD','#AS','#DS','#AEC',;
       '#DEC','#AIE','#DIE','#AIC','#DIC',;
       '#ACA','#ACB','#ACC','#ACD','#DCE'}
aDES:={CHR(27)+CHR(71),CHR(27)+CHR(72),cIMPTIT,cIMPCOM,cIMPEXP, ;
       CHR(27)+CHR(52),CHR(27)+CHR(53),cIMPNEG,cIMPNER,;
       CHR(27)+CHR(83)+CHR(00),CHR(27)+CHR(83)+CHR(01),CHR(27)+CHR(84),;
       CHR(27)+CHR(45)+CHR(00),CHR(27)+CHR(45)+CHR(01),CHR(27)+CHR(87)+CHR(00), ;
       CHR(27)+CHR(87)+CHR(01),CHR(27)+CHR(52)+CHR(27)+CHR(87)+CHR(01), ;
       CHR(27)+CHR(53)+CHR(27)+CHR(87)+CHR(00),CHR(27)+CHR(91)+CHR(50)+CHR(27)+CHR(52),;
       CHR(27)+CHR(91)+CHR(48)+CHR(27)+CHR(53),;
       CHR(27)+CHR(91)+CHR(50),CHR(27)+CHR(91)+CHR(51),CHR(27)+CHR(91)+CHR(52),;
       CHR(27)+CHR(91)+CHR(53),CHR(27)+CHR(91)+CHR(48)}
texto=charconv(texto,aORI,aDES)
RETU texto



*!*****************************************************************************
*!
*!         Fun‡„o: TIPOGRA() Corrige Quadro para Impress„o
*!
*!    Chamado por: IMPARQ()  (fun‡„o em DISK61.PRG)
*!
*!*****************************************************************************
FUNC tipogra(texto)
aORI:={'Ý','Ý','µ','¶','Ý','Ý','+','Æ','Ç','Ý','×','Ø','Ý','Ý','Þ'}
aDES:={'|','|','|','|','|','|','|','|','|','|','|','|','|','|','|'}
texto:=charconv(texto,aORI,aDES)
aORI:={'·','¸','+','+','½','¾','+','+','-','-','-','+','+','+','-','-','-','+','Ï','Ð','Ñ','Ò','Ó','Ô','i','Ö','+','+','_','î'}
aDES:={'-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-'}
texto:=charconv(texto,aORI,aDES)
RETU texto
*: FIM: DISK61.PRG
