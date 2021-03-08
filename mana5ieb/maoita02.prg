
#INCLUDE "INKEY.CH"
//#INCLUDE "COMANDO.CH"
#INCLUDE "BOX.CH"

function maoita02
para nTIPO //1 Zerados //2-Grupo //3-Filtro //4-Automaticos //5 Cliente

//Modo de Trabalho no V¡deo
IF nTIPO=1
   MDI( " Ý Excluir Pedidos Zerados" )
ENDIF
IF nTIPO=2
   mGRUPO:=0
   MDI( " Ý Excluir Grupo Pedidos")
   @ 23,00 SAY "Digite o Grupo Pedido"
   @ 24,40 GET mGRUPO PICT "99999"
   READCUR()
   mGRPFIM:=mGRUPO+.999
   IF ! MDG("Excluir Grupo:"+STR(mGRUPO)+"/"+alltrim(STR(mGRPFIM)))
      RETU .F.
   ENDIF
ENDIF

IF nTIPO=4
   dINI  :=  dFIM := ZDATA
   cTIPO := " "
   @ 21,00 SAY "Periodo"
   @ 22,00 SAY "Tipo (T)odas (A)Sem+Dia Prg(S)emanal Prg(D)iaria"
   @ 23,00 say "     Electrolux->D(E)lfor (O)rders "
   @ 21, 15 get dINI
   @ 21, 25 get dFIM
   @ 23, 78 get cTipo PICT "!" VALID cTIPO $ "ASDEOT"
   if !READCUR()
      retu .F.
   endif
ENDIF

IF nTIPO=5
   nCLIINI:=0
   nCLIFIM:=0
   MDI( " Ý Digite o Grupo Cliente")
   @ 24,40 GET nCLIINI PICT "99999999"
   @ 24,50 GET nCLIFIM PICT "99999999"
   READCUR()
   IF ! MDG("Excluir Grupo Cliente:"+STR(nCLIINI)+" ao "+str(nCLIFIM))
      RETU .F.
   ENDIF
ENDIF


IF nTIPO#3
   IF ! MDG("Continuar Exclusao Pedidos")
      RETU .F.
   ENDIF
ENDIF




MDS( " Aguarde. Abrindo os arquivos de dados ..." )

if ! USEMULT( { { "MO01", 1, 99 }, { "MO02", 1, 99 }, { "MO01BX", 1, 99 }, { "MO02BX", 1, 99 } } )
   retu .F.
endif

dbselectar( "MO01" )
dbsetorder( 1 )
INITVARS()
CLRVARS()
dbselectar( "MO02" )
INITVARS()
CLRVARS()

//Declarando vari veis
REGISTRO := 0
COLUNA   := 27

//Tela de Dados
HB_dispbox( 2, 0, 23, 79,B_DOUBLE)
@ 08, 13 say "N£mero do Pedido   : "
@ 10, 13 say "Registros Apagados : "
@ 16, 11 say "+--------------------------+"
@ 17, 11 say "Ý                          Ý"
@ 18, 11 say "+--------------------------+"
@ 17, 13 say "Processando : ÝÝÝÝÝÝÝÝÝÝ"
MDS( " " )

dbselectar( "MO02" )
dbgotop()
while !eof()
   @ 17, COLUNA say "Ý"
   if COLUNA = 36
      @ 17, 27 clear to 17, 36
      @ 17, 27 say "ÝÝÝÝÝÝÝÝÝ"
      COLUNA := 26
   endif
   mPEDIDO  := PEDIDO
   mQTDESAL := QTDESAL
   mQTDEENT := QTDEENT
   mGERAOF  := GERAOF
   @ 08, 35 say mPEDIDO pict '99999.99'
   lAPAGA:=.F.
   lBACKUP:=.T.
   if nTIPO=1.AND.mQTDESAL = 0.00
      lAPAGA:=.T.
   endif
   if nTIPO=2.AND.PEDIDO>=mGRUPO.AND.PEDIDO<=mGRPFIM
      lAPAGA:=.T.
   endif
   IF nTIPO=5.AND.(FORNECEDO>=nCLIINI.AND.FORNECEDO<=nCLIFIM)
      lAPAGA:=.T.
   ENDIF
   if nTIPO=4
      mBAIXAM=" "
      mTIPOPRG:=" "
      dbselectar("MO01")
      dbgotop()
      if dbseek(mPEDIDO)
         mBAIXAM:=BAIXAM
         mTIPOPRG:=TIPOPRG
      endif
      dbselectar("MO02")
      if ENTREGA >= dINI .and. ENTREGA <= dFIM .and. mBAIXAM = "N"
         if (cTIPO = "A".AND.(mTIPOPRG="D".OR.mTIPOPRG="S")) ;
            .or. cTIPO = mTIPOPRG ;
            .or. cTIPO = "T"
            lAPAGA:=.T.
            IF QTDEENT=0
               lBACKUP:=.F.
            ENDIF
         endif
      endif
   endif
   if lAPAGA
      mOS     := mPEDIDO
      mOF     := mPEDIDO
      mITEM   := ITEM
      mCODIGO := CODIGO
      xCHAVE  := str( mOS, 8, 2 ) + str( mITEM, 2 )
      EQUVARS()
      IF lBACKUP
         NOVOOPA( "MO02BX", .T., .T. )
      ENDIF
      dbselectar( "MO01" )
      dbgotop()
      if dbseek( mPEDIDO )
         EQUVARS()
         DELEREG(,,.F.,.F.)
         IF lBACKUP
            NOVOOPA( "MO01BX", .T., .T. )
         ENDIF
         REGISTRO ++
         @ 10, 35 say REGISTRO pict '99999'
      endif
      IF mGERAOF="S"
         APAGAREG( "OF01", xCHAVE, .F., .F.,,.F. )
         MAOFDEL()
      ENDIF
      dbselectar( "MO02" )
      DELEREG(,,.F.,.F.)
   endif
   dbselectar( "MO02" )
   dbskip()
   COLUNA ++
enddo
dbcloseall()
release all like m *
MAOFIXAR()



*+ EOF: M_DR.PRG
