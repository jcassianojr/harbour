***
*** PADRAO .PRG  :
*** Gerado em    : Janeiro 17, 1996
*** Programador  : Disk Softwares
*** Linguagem    : Clipper 5.x
***


//Teclas Operacionais
//#INCLUDE "TECLAS.CH"
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"
#INCLUDE "DBINFO.CH"
#INCLUDE "BOX.CH"

FUNC PADRAO

//Recebendo Parametro de Trabalho
PARA cARQ,cIND,eBARM,eCHAVEM,cCABX,cCAB,bCHA,bTEL,bGET,bLIS,cFIL,nLIN,cHELP,bAUX,cMOD

//cMOD T-Total E-So Edicao V-Visualizar(nao inc/del/alt) X-Inclui e Edicao

IF VALTYPE(cMOD)#"C"
   cMOD="T" //total
ENDIF

IF VALTYPE(nLIN)#"N"
   nLIN:=3
ENDIF

IF VALTYPE(cHELP)#"C"
   HELPDBF=cARQ
ELSE
   HELPDBF=cHELP
ENDIF

//Ajusta Variaveis
eBAR=STRTRAN(eBARM,"m","")
eCHAVE:=STRTRAN(eCHAVEM,"m","")
PRIV mCHAVE

//Modo de Trabalho no Video 
CABEX(cCABX)
VIDEO:="S"
MDS('Visualizar como Video (S)im (N)ao ou (B)rowse ')
@ 24,78 GET VIDEO PICT "!" VALID VIDEO $"SNB"
READCUR()
MD()

//Variaveis de Trabalho
nROW=24
PRIV PCK:=.F.
GRAPP=1
CRIARVARS(cARQ)
PRIV aPAD1,aPAD2
aPAD1={}    &&Matriz com os dizeres do Achoice
aPAD2={}    &&



PRIV aPADTEL:={}
IF VALTYPE(bTEL)="C"
   aPADTEL:=TELAPEG(bTEL)
   bTEL:={|| TELASAY(aPADTEL)}
ENDIF

PRIV aPADGET:={}
IF VALTYPE(bGET)="C"
   aPADGET:=EDITPEG(bGET)
   bGET:={|| EDITSAY(aPADGET)}
ENDIF


//Incializando a ajuda on Line
PRIV HELPDBF:=cARQ


//Carregando Matriz
IF VIDEO="S".OR.VIDEO="B"
   IF ! netuse(cARQ) 
      RETU
   ENDIF
   
   //IF VIDEO="S"
   //   IF LASTREC()>4096
   //      MDT("Mais que 4096 registro Visualizacao Mudada para (B)rowse")
  //       VIDEO:="B"
   //  ENDIF
   //ENDIF
   //harbour sem limite array
   
   GRAF=LASTREC()
   xGRAF=0
   xPOS=1
   GRAPT=LASTREC()
   GRAPT('Carregando  - Aguarde...')
   IF VALTYPE(cFIL)="C".AND.! EMPty(cFIL) //Filtro Passado com complemento cFIL
      FILTRO=FILTRO(ALLTRIM(cFIL))
      SET FILTER TO &FILTRO
   ENDIF
   IF VALTYPE(cFIL)="A" //Filtro Passado Porem pede Complemto ou nao {.T.,cFIL,.T.} OU {.F.,cFIL,.T.}
                        //terceiro parametro limpavars
      IF cFIL[1]
         FILTRO=FILTRO(cFIL[2])
      ELSE
         FILTRO=cFIL[2]
      ENDIF
      SET FILTER TO &FILTRO
   ENDIF
   IF VALTYPE(cFIL)="L" //Filtro Nao Passao Porem Pergunta .T.
      IF cFIL
         FILTRO=FILTRO("")
         SET FILTER TO &FILTRO
      ENDIF
   ENDIF
ENDIF
IF VIDEO="S"
   nIndexes  :=  dbORDERINFO( DBOI_ORDERCOUNT )
   aNtxNames  := {}
   FOR i = 1 TO nIndexes
       AAdd( aNtxNames ,  dbORDERINFO( DBOI_NAME , ,  i )+" - "+dbORDERINFO( DBOI_EXPRESSION , ,  i ) )
   NEXT
   IF nIndexes>1
      nRESP := ACHOICE(6,6, 16,74,aNTXNAMES)
      if lastkey()=13
         dbsetorder(nRESP)
      endif
   ENDIF
   DBGOTOP()
   WHILE ! EOF()
      AADD(aPAD1,&eBAR.)
      AADD(aPAD2,&eCHAVE.)
      xPOS++
      GRAPS()
      DBSKIP()
   ENDDO
   DBCLOSEALL()
   IF xPOS=1
      IF ! MDG('Nenhum Lancamento Neste Arquivo Deseja Incluir')
         RETU
      ENDIF
      IF ! fPAD(1,0)
         RETU
      ENDIF
   ENDIF
ENDIF

//PosicAo Inicial do Ponteiro
pPAD:=1

//Processando o Metodo Escolhido
IF VIDEO='S'
   NOBREAK()
   PRIV nSBAR,aSBAR
   nSBAR=LEN(aPAD1)
   aSBAR:= ScrollBarNew(05,79,23,,pPAD)
   ScrollBarDisplay(aSBAR)
   ScrollBarUpdate(aSBAR,pPAD,nSBAR,.T.)
   WHILE .T.
      HB_SCROLL(nLIN,0,23,79)
      HB_DISPBOX(nLIN,0,23,79,B_DOUBLE+" ")
      @ nLIN+1, 1 SAY cCAB
      @ nLIN+2, 0 SAY '+'+replicate('-',78)+'í'
      @ 24, 0 SAY "INS=Novo DEL=Apaga Enter=Altera Ctrl+ENTER=Busca Alt+F10=Lista"+spac(17)+"í"
      ScrollBarUpdate(aSBAR,pPAD,nSBAR,.T.)
      ScrollBarDisplay(aSBAR)
      pPAD2=ACHOICE(nLIN+3,01,22,78,aPAD1,,"ACHRETB",pPAD)
      pPAD=IF(pPAD2#0,pPAD2,pPAD)
      pPAD2=pPAD
      DO CASE
         CASE LASTKEY() = K_ESC ;  MDS('Retornando') ;  EXIT
         CASE LASTKEY() = K_ALT_F10 ;  MDS('Imprimindo') ;  fPAD(4,pPAD) //EVAL(bLIS,pPAD)
         CASE LASTKEY() = K_INS ;  MDS('Incluindo ') ;  fPAD(1,pPAD)
         CASE LASTKEY() = K_ENTER ;  MDS('Alterando ') ;  fPAD(2,pPAD)
         CASE LASTKEY() = K_DEL ;  MDS('Excluindo ') ;  fPAD(3,pPAD)
         CASE (LK_ALT_ENT .OR. LK_TAB) .AND. VALTYPE(bAUX)="B" ; EVAL(bAUX,pPAD)
         CASE pBUS                        && CTRL+ENTER USO O aPAD1
              EVAL(bCHA)
              pPAD=ASCAN(aPAD2,mCHAVE)
              IF pPAD=0
                 MDT( 'Nao localizei o Registro Correspondente ....')
                 pPAD=pPAD2
                 LOOP
              ENDIF
         OTHERWISE ; LOOP
      ENDCASE
   ENDDO
ENDIF
IF VIDEO="N"
   ** ENTRADA SEM VER O BROWSE DOS REGISTROS
   WHILE .T.
      OPCAO(24,01,' &INCLUIR  ',73)
      OPCAO(24,16,' &ALTERAR  ',65)
      OPCAO(24,31,' &EXCLUIR  ',69)
      OPCAO(24,46,' &LISTAR   ',76)
      OPCAO(24,61,' &RETORNAR ',82)
      OPT:=MENU(,0)
      DO CASE
         CASE OPT=1 ; fPAD(1,0)
         CASE OPT=2 ; fPAD(2,pPAD)
         CASE OPT=3 ; fPAD(3,0)
         CASE OPT=4 ; fPAD(4,pPAD) //EVAL(bLIS)
         OTHERWISE  ; EXIT
      ENDCASE
   ENDDO
ENDIF

IF VIDEO="B"
   //Tela Basica
   HB_dispbox( 2, 0, 24 - 1, 79, B_DOUBLE+" ")
   @ 03,  1 say cCAB
   @  4,  0 say '+' + replicate( '-', 77 ) + 'Tí'
   //Inicia o TBROWSE
   oTB        := tbrowsedb( 05, 01, 22, 78 )
   ocTB := tbcolumnnew( "", { || &eBAR. })
   ocTB:WIDTH := 78
   oTB:ADDCOLUMN( ocTB )
   oTB:REFRESHALL()

   //Coloca a Barra de Trabalho
   priv nSBAR
   priv aSBAR
   nSBAR := lastrec()
   aSBAR := ScrollBarNew( 04, 79, 23,,1)
   ScrollBarDisplay( aSBAR )
   while .T.
     dbselectar( cARQ )
     @ 24, 0 SAY "INS=Novo DEL=Apaga Enter=Altera Ctrl+ENTER=Busca Alt+F10=Lista"+spac(17)+"í"
     @  3, 79 say "í"
     while ! oTB:STABILIZE()
         nKEY := inkey()
         if nKEY != 0
            exit
         endif
     enddo
     if oTB:STABILIZE()
         nKEY := inkey( 0 )
     endif
     //nKEY:=INKEY(0)
     nMOVE := 0
     if oTB:STABLE    //Se objeto j  est vel...
        ScrollBarUpdate( aSBAR, ( oTB:ROWPOS + 4 ), nSBAR, .T. )
        nKEY  := 0
        nMOVE := 0
        while nKEY = 0
           nKEY := HOTINKEY()
           nKEY := LERMOUSE( nKEY )
           do case
              case MOUSE_B = 1 .and. MOUSE_Y = 4
                   nKEY := K_UP
              case MOUSE_B = 1 .and. MOUSE_Y = MAXROW()-1
                   nKEY := K_DOWN
              case MOUSE_Y = 1 .and. MOUSE_B = 1 .and. MOUSE_X < 4
                   nKEY := K_ESC
              case MOUSE_B = 1 .and. ( oTB:ROWPOS + 4 ) = MOUSE_Y .and. MOUSE_X # 79
                   nKEY := K_ENTER
           endcase
           if MOUSE_X = MAXCOL()-1 .and. MOUSE_B = 1      
              do case
                 case MOUSE_Y = 03
                      nKEY := K_HOME
                 case MOUSE_Y >= 5 .and. MOUSE_Y <= 13
                      nKEY := K_PGUP
                 case MOUSE_Y >= 14 .and. MOUSE_Y <= 22
                      nKEY := K_PGDN
                 case MOUSE_Y = MAXROW()
                      nKEY := K_END
              endcase
           endif
           if MOUSE_Y = MAXROW() .and. MOUSE_B = 1
              do case
                 case MOUSE_X > 00 .and. MOUSE_X < 07
                      nKEY := K_INS
                 case MOUSE_X > 09 .and. MOUSE_X < 17
               nKEY := K_DEL
            case MOUSE_X > 19 .and. MOUSE_X < 30
               nKEY := K_ENTER
            case MOUSE_X > 32 .and. MOUSE_X < 47
               nKEY := K_CTRL_RET
            case MOUSE_X > 49 .and. MOUSE_X < 62
               nKEY := K_ALT_F10
            endcase
         endif
         if MOUSE_B = 1 .and. MOUSE_Y > 4 .and. MOUSE_Y < MAXROW()-1 .and. MOUSE_X # MAXCOL()-1 .and. ( oTB:ROWPOS + 4 ) # MOUSE_Y
            if MOUSE_Y < ( oTB:ROWPOS + 4 )
               nKEY  := 255             //Apenas Para Sair do Loop e marcar subir
               nMOVE := ( oTB:ROWPOS + 4 ) - MOUSE_Y
            else
               nKEY  := 254             //Apenas Para Sair do Loop e marcar descer
               nMOVE := MOUSE_Y - ( oTB:ROWPOS + 4 )
            endif
         endif
      enddo
   endif

   //Saltar
   if nMOVE > 0
      if nKEY = 255
         for X := 1 to nMOVE
            oTB:UP()                    //Cursor para cima.
         next X
      else
         for X := 1 to nMOVE
            oTB:DOWN()                  //Cursor para baixo.
         next X
      endif
      nKEY := 0     //Zera o Inkey Evitar Conflito
      //  oTB:REFRESHALL() //Atualiza os Dados N?o Necessario
   endif

   //Teclas Deslocamento do Objeto TBrowse.
   do case
       case nKEY == K_UP                    //Cursor para cima.
          oTB:UP()
       case nKEY == K_DOWN                  //Cursor para baixo.
          oTB:DOWN()
       case nKEY == K_LEFT                  //Cursor para esquerda.
          oTB:LEFT()
       case nKEY == K_RIGHT                 //Cursos para direita.
          oTB:RIGHT()
       case nKEY == K_HOME                  //Cursor para posi??o inicial da tela.
          oTB:GOTOP()
       case nKEY == K_END                   //Cursor para posi??o final da tela.
          oTB:GOBOTTOM()
       case nKEY == K_PGUP                  //Move cursor uma p gina de tela para cima.
          oTB:PAGEUP()
       case nKEY == K_PGDN                  //Move cursor uma p gina de tela para baixo.
          oTB:PAGEDOWN()
       case nKEY == K_CTRL_PGUP             //Move cursor para o primeiro registro.
          oTB:GOTOP()
       case nKEY == K_CTRL_PGDN             //Move cursor para o œltimo registro.
          oTB:GOBOTTOM()
   endcase

   //Informa o in­cio ou o fim do arquivo (ou fonte de dados).
   if oTB:HITTOP
      MDS( " Voce esta no primeiro registro !" )
   endif
   if oTB:HITBOTTOM
      MDS( " Voce esta  no œltimo registro !" )
   endif

   if oTB:STABLE
      IF nKEY = K_INS
         IF cMOD="T" .OR. cMOD="X"
            CLRVARS()
            EVAL(bCHA)
            nKEY:=K_ENTER
         ELSE
             ALERTX("Modo de Exibicao")
         ENDIF
      ENDIF
      do case
      case nKEY = K_ENTER
           cTELA := savescreen( 02, 00, 23, 79 )
           EQUVARS()
           setcursor( 1 )
           eval(btel)
           set key K_F11 to TECLAF11
           eval(bget)
           set key K_F11
           restscreen( 02, 00, 23, 79, cTELA )
           setcursor( 0 )
           netreclock()
           REPLVARS()
           dbunlock()
      case nKEY = K_DEL
           IF cMOD="T"
              IF MDG("Excluir Registro")
                 netrecdel()
                 dbskipex()
                 nSBAR --
                 oTB:REFRESHALL()
              ENDIF
           ELSE
              ALERTX("Modo de Exibicao")
           ENDIF
      case (nKEY = K_ALT_ENTER.OR. nKey=K_TAB).AND.VALTYPE(bAUX)="B"
           EVAL(bAUX,0)
      CASE nKEY = K_ALT_F10
           EQUVARS()
           EVAL(bLIS)
      endcase
   endif


   if nKEY > 96 .and. nKEY < 123
       nKEY := asc( upper( chr( nKEY ) ) )
   endif
   if nKEY > 64 .and. nKEY < 91
      OtB:GOTOP()
      IF ! dbseek( CHR(nKEY) )
         dbskipEX(-1) //O Mais Proximo e o anterior
     ENDIF
     nREG := recno()
     dbgoto( nREG ) //forcar o refresh
     oTB:REFRESHALL()
   ENDIF

   if nKEY = K_ESC  //Encerra consulta.
      if mdg( " Deseja encerrar a consulta ?" )
         setcursor( 1 )                 //Aciona novamente o cursor.
         dbcloseall()
         exit
      endif
   endif
  enddo
endif



//LIBERA VARIAVEIS
IF VALTYPE(cFIL)="A"
   IF cFIL[3]=.T.
      LIMPAVARS(cARQ)
   ENDIF
ELSE
   LIMPAVARS(cARQ)
ENDIF

netpack(cARQ,pck)


RETU .T.

*******************
FUNCtion fPAD(OPRPAD,POSPAD)   &&INCLUIR=1//EDITAR=2//EXCLUIR=3//LISTAR=4 // POSICAO MATRIZ
*******************
INCLUI:=.F.
//Pegar a Chave de Busca
IF OPRPAD#1
   IF VIDEO='S'
      mCHAVE:=aPAD2[POSPAD]
   ELSE
      EVAL(bCHA)
   ENDIF
ENDIF



//Operacao de Exclusao
IF OPRPAD=3
   IF cMOD="T"
      IF APAGAREG(cARQ,cIND,mCHAVE)
         IF VIDEO="S"
            aPAD1[POSPAD]=' Registro Excluido / Apagado / Deletado '
         ENDIF
         PCK=.T.
      ENDIF
      RETU .T.
   ELSE
      ALERTX("Modo de Exibicao-Nao Exclui")
      RETU .F.
   ENDIF
ENDIF

//Operacao de Inclusao
IF OPRPAD=1
   IF cMOD="T".OR.cMOD="X"
      ZERAVARS(cARQ)
      EVAL(bCHA)
      IF ! NOVOREG(cARQ,cIND,mCHAVE)
         RETU .F.
      ENDIF
      INCLUI:=.T.
  ELSE
     ALERTX("Modo de Exibicao-Nao Incluir")
     RETU .F.
  ENDIF
ENDIF


//IGUALAR mVARS
IF ! IGUALVARS(cARQ,cIND,mCHAVE)
   RETU .F.
ENDIF

//Operacao de Listagem
if OPRPAD=4
   EVAL(bLIS)
   RETURN .T.
endif
// Desenha a Tela
EVAL(bTEL)


// Get nas Menvars
set key K_F11 to TECLAF11
EVAL(bGET)
set key K_F11

IF cMOD="V"
   @ 24,00 SAY "Continuar:"
   @ 24,20 GET zCONTINUA
   READCUR()
ENDIF


//Atualiza as Matrizes se nao for inclusao
IF VIDEO='S'.AND.OPRPAD#1
   aPAD1[POSPAD]=&eBARM.
   aPAD2[POSPAD]=&eCHAVEM.
ENDIF

//Posiciona o Novo Elemento na Matriz
IF VIDEO='S'.AND.OPRPAD=1
   AADD(aPAD1,NIL)
   AADD(aPAD2,NIL)
   POSPAD=LEN(aPAD1)
   POSW=1
   IF POSPAD>1
      FOR X = 1 TO POSPAD-1
          mDARE=aPAD2[X]
          IF mCHAVE<=mDARE
             EXIT
          ENDIF
      NEXT
      POSW=X
   ENDIF
   AINS(aPAD1,POSW)
   AINS(aPAD2,POSW)
   aPAD1[POSW]=&eBARM.
   aPAD2[POSW]=&eCHAVEM.
   pPAD=POSW
ENDIF

IF cMOD="T".or.cMOD="E".or.cMOD="X"
   REPORVARS(cARQ,cIND,mCHAVE)
ELSE
   MDT("Modo de Exibicao-Nao Grava alteracoes")
ENDIF


RETU .T.


*+¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
*+
*+    Function PEGCHAVE()
*+
*+¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
*+
FUNC PEGCHAVE(eVAR,eVAL,cTITULO)
mCHAVE:=eVAL
MDS(cTITULO)
@ 24,30 get mCHAVE
READCUR()
&eVAR.:=mCHAVE



*+¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
*+
*+    Function TECLAF11()
*+
*+¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
*+
func TECLAF11
para cPRO, nLIN, cVAR
LOCAL nPRO
priv eEXECUTE
nPRO:=1
cPRO=ALLTRIM(UPPER(cPRO))
WHILE cPRO="READCUR".OR.cPRO="(B)FPAD"
   cPRO=ALLTRIM(UPPER(PROCNAME(nPRO)))
   nPRO++
ENDDO
IF TYPE(cVAR)="D"
   CALEND()
   IF VALTYPE(READVAR)="D"
      IF MDG("USAR "+STRVAL(READVAR))
         &cVAR. := READVAR
      ENDIF
   ENDIF
ENDIF
IF TYPE(cVAR)="N"
   DO CASE
      CASE cVAR="MNINSTU".OR.cVAR="MNUMFUN" .or.cVAR="MORIGEM".OR.CVAR="MDESTINO"
           &cVAR.=ESCOLHEXI( PES, &cVAR., "STR(NUMERO,8)+' '+NOME", "NUMERO")
      CASE cVAR="MNUMERO".OR.cVAR="NUMERO".OR.cVAR="NUM".OR.cVAR="NNUMERO".OR.cVAR="MDESTINO"
           &cVAR.=ESCOLHEXI( PES, &cVAR., "STR(NUMERO,8)+' '+NOME", "NUMERO")
      CASE cVAR="CONTAREF"
           &cVAR.=ESCOLHEXI( "CONTAS", &cVAR., "STR(CODIGO,8)+' '+DESCR", "CODIGO")
      CASE cVAR="MCONTA".AND.cPRO="FOAA8"
           &cVAR.=ESCOLHEXI( CC2A, &cVAR., "STR(CODIGO,8)+' '+DESCR", "CODIGO")
     CASE cVAR="NREMP"
           &cVAR.=ESCOLHEXI( "FIRMA", &cVAR., "STR(NRCLIEN,8)+' '+RAZAO", "NRCLIEN")
      CASE cVAR="MFUNCAO"
           &cVAR.=ESCOLHEXI( "FUNCAO", &cVAR., "STR(CODIGO,8)+' '+DESCR", "CODIGO")
      CASE cVAR="MDEPTO"
           &cVAR.=ESCOLHEXI( "DEPTO", &cVAR., "STR(DEPTO,8)+' '+STR(SETOR,8)+' '+STR(SECAO,8)+' '+NOME", "DEPTO")
      CASE cVAR="MSETOR"
           &cVAR.=ESCOLHEXI( "DEPTO", &cVAR., "STR(DEPTO,8)+' '+STR(SETOR,8)+' '+STR(SECAO,8)+' '+NOME", "SETOR")
      CASE cVAR="MSECAO"
           &cVAR.=ESCOLHEXI( "DEPTO", &cVAR., "STR(DEPTO,8)+' '+STR(SETOR,8)+' '+STR(SECAO,8)+' '+NOME", "SECAO")
      CASE cVAR="MCCUSTO"
           &cVAR.=ESCOLHEXI( "UNID", &cVAR., "STR(NUMERO,8)+' '+CODIGO+' '+NOME+' '+MODIRETA", "NUMERO")
      CASE cVAR="MUNIFUN".OR.cVAR="UNIFUN"
           &cVAR.=ESCOLHEXI( "UNID", &cVAR., "CODIGO+' '+STR(NUMERO,8)+' '+NOME+' '+MODIRETA", "CODIGO")
      CASE cVAR="MMODELO"
           &cVAR.=ESCOLHEXI( "RELOGIOS", &cVAR., "STR(NUMERO,8)+' '+NOME", "NUMERO")
      CASE cVAR="MMOTIVO"
           &cVAR.=ESCOLHEXI( "FOPTOMOT", &cVAR., "STR(NUMERO,8)+' '+NOME", "NUMERO")
      CASE cVAR="MHORARIO"
           &cVAR.=ESCOLHEXI( "FOPTOHOR", &cVAR., "' '+mCODIGO+' '+STR(mENT,  6, 2)+' '+STR(mALMI,  6, 2)+' '+STR(mALMF,  6, 2)+' '+STR(mSAI,  6, 2)", "NUMERO")     
      OTHERWISE
        CALC()
        IF VALTYPE(READVAR)="N"
           IF MDG("USAR "+STRVAL(READVAR))
              READVAR:= READVAR
           ENDIF
           &cVAR. := READVAR
        ENDIF
  ENDCASE
ENDIF
IF VALTYPE(cVAR)="C"
   cVAR=ALLTRIM(UPPER(cVAR))
   DO CASE
      CASE cVAR="MHTT".OR.cVAR="MANT"
           &cVAR.=ESCOLHEXI( "TABTURNO", &cVAR., "CODIGO+' '+NOME", "CODIGO")
      CASE cVAR="MHORREF".OR.cVAR="MHORPAD"
           &cVAR.=ESCOLHEXI( "FOPTOHRE", &cVAR., "CODIGO+' '+NOME", "CODIGO")
      CASE cVAR="MPAGGPS"
           &cVAR.=ESCOLHEXI( "TBCODPG", &cVAR., "CODIGO+' '+NOME", "CODIGO")
      CASE cVAR="FAIXA"
           &cVAR.=ESCOLHEXI( "FO_FAI", &cVAR., "FAIXA+' '+DESCRICAO", "FAIXA")
      CASE cVAR="TIPODEP"
           &cVAR.=ESCOLHEXI( "CODFGTS", &cVAR., "CODIGO+' '+NOME", "CODIGO")
      CASE cVAR="MOTIVO"
           &cVAR.=ESCOLHEXI( "FO_RCAU", &cVAR., "CODIGO+' '+NOME", "CODIGO")           
      CASE cVAR="MOTIVODEM"
           &cVAR.=ESCOLHEXI( "CAGED", &cVAR., "CODIGO+' '+DESCRICAO", "CODIGO")
      CASE cVAR="MCBONEW".OR.cVAR="CBONEW"
           &cVAR.=ESCOLHEXI( "FO_CBON", &cVAR., "CODIGO+' '+STRZERO(CAGEDESCO,2)+' '+NOME", "CODIGO")
      CASE cVAR="MCBO".OR.cVAR="CBO"
           &cVAR.=ESCOLHEXI( "FO_CBO", &cVAR., "CODIGO+' '+NOME", "CODIGO")
      CASE cVAR="MUNIFUN".OR.cVAR="UNIFUN"
           &cVAR.=ESCOLHEXI( "UNID", &cVAR., "CODIGO+' '+NOME", "CODIGO")
      CASE cVAR="FPAS".OR.cVAR="MFPAS"
           &cVAR.=ESCOLHEXI( "CONFINSS", &cVAR., "FPAS+' '+DESCRICAO", "FPAS")
      CASE cVAR="CODRET"
           &cVAR.=ESCOLHEXI( "CODIRRF", &cVAR., "CODIGO+' '+NOME", "CODIGO")
      CASE cVAR="MNAT".OR.cVAR="NAT_ESTAB"
           &cVAR.=ESCOLHEXI( "RAISNATJ", &cVAR., "CODIGO+' '+NOME", "CODIGO")
      CASE cVAR="ATIVIDADE"
           &cVAR.=ESCOLHEXI( "FO_CNAE2", &cVAR., "CODIGO+' '+DESCRICAO", "CODIGO")
      CASE cVAR="MACID"
           &cVAR.=ESCOLHEXI( "FO_CSAT", &cVAR., "CODIGO+' '+DESCRICAO", "CODIGO")
      CASE cVAR="MCID"
           &cVAR.=ESCOLHEXI( "CID", &cVAR., "CODIGO+' '+NOME", "CODIGO")                 
      CASE cVAR="MCURSO"
           &cVAR.=ESCOLHEXI( CARQCUR, &cVAR., "CURSO+' '+DESCURSO", "CURSO")
      CASE cVAR="MAREA"
           &cVAR.=ESCOLHEXI( cARQMP05, &cVAR., "CODIGO+' '+DESCRI", "CODIGO")
      CASE cVAR="MCOD".OR.cVAR="MCODREV".OR.LEFT(cVAR,5)="MCHOR"
           &cVAR.=ESCOLHEXI( "FOPTOHOR", &cVAR., "' '+mCODIGO+' '+STR(mENT,  6, 2)+' '+STR(mALMI,  6, 2)+' '+STR(mALMF,  6, 2)+' '+STR(mSAI,  6, 2)", "CODIGO",,2)
      CASE cVAR="DOCO".OR.cVAR="MOCOCOD".OR.cVAR="MOCOSUB".OR.cVAR="MSOD".OR.cVAR="MCODOCO"
           &cVAR.=ESCOLHEXI( "TABFALTA", &cVAR., "CODIGO+' '+NOME", "CODIGO")
//      CASE cVAR=""
//           &cVAR.=ESCOLHEXI( "", &cVAR., "", "")
//      CASE cVAR=""
//           &cVAR.=ESCOLHEXI( "", &cVAR., "", "")



      OTHERWISE
         ALERTX(cPRO+"/"+cVAR+"F11 ainda nao disponivel")
   ENDCASE
ENDIF
retu .T.



*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
*+    Function ESCOLHEXI()
*+
*+íííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííííí
*+
func ESCOLHEXI( cARQ, cNOME, cSTR1, cSTR2, lCOND, nIND )
local aTABA := {}
local aTABB := {}
local nPOS
if valtype( nIND ) # "N"
   nIND := 1
endif
aSALVA:=SALVAA()
MDS( "Aguarde Pesquisando Tabela" )
IF ! netuse(cARQ)
   RESTAA(aSALVA)
   RETURN ""
ENDIF
IF VALTYPE(nIND)="N"
   dbsetorder(nIND)
ENDIF
dbgotop()
while !eof()
   if valtype( lCOND ) # "C"
      aadd( aTABA, &cSTR1. )
      aadd( aTABB, &cSTR2. )
   else
      if &lCOND.
         aadd( aTABA, &cSTR1. )
         aadd( aTABB, &cSTR2. )
      endif
   endif
   dbskip()
enddo
dbclosearea()
if !empty( aTABA )
   nPOS  := ascan( aTABB, cNOME )
   nPOS  := if( nPOS > 1, nPOS, 1 )
   nPOS  := ESCARR( aTABA, 4, 5, 24 - 3, 63, nPOS, "Escolha o Item" )
   nPOS  := if( nPOS > 1, nPOS, 1 )
   if lastkey() = K_ENTER
      cNOME := aTABB[ nPOS ]
   ENDIF
endif
RESTAA(aSALVA)
retu cNOME

