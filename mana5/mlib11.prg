*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib11.prg
*+
*+
*+
*+    Sistema   : MANAEXO
*+
*+    Linguagem : Harbour
*+
*+    Autor     : Jorge Cassiano
*+
*+    Copyright (c) 2010, Jorge Cassiano
*+
*+
*+
*+    Documentado em 30-Ago-2011 as 10:55 am
*+
*+
*+
*+--------------------------------------------------------------------
*+


//  cARQ-> Arquivo de Trbalho
//  aREP-> Matriz Multidimensional de troca Chave Ou Blocco
//  aCOR-> Matriz Com as Cores
//  bVID-> Bloco com String Para a Barra de Rolagem
//  bTEL-> Bloco Para Exibi‡„o da Tela
//  bGET-> Bloco Para Edi‡„o da mVARS
//  bCHA-> Bloco Para Chaves especias
//  bAUX-> Bloco para Processor Teclas N„o Padr„o Opcional
//  wVAR-> Variavel de Controle Tecla Enter
//  cCAB-> String de Cabe‡ario Opcional
//  cROD-> Stirng de Rodap‚ Opcional
//  bAU2-> Bloco Para Tecla enter Alternativa
//  eINI-> Express„o Inicial do Seek
//  bINS-> Bloco Apos Insert
//  bpos-> Bloco Apos troca vars
//  bequ-> Bloco Apos igual vars
//  bdel-> Blobo Apos Delete


#INCLUDE "INKEY.CH"
#INCLUDE "BOX.CH"


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function METBRO()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func METBRO(cARQ,aREP,aCOR,bVID,bTEL,bGET,bCHA,bAUX,wVAR,cCAB,cROD,bAU2,eINI,bINS,bPOS,bEQU,bDEL,eFILTRO)


local cTELA
if valtype(cROD) # "C"
   cROD := "INS=Novo DEL=Apaga Enter=Altera Ctrl+ENTER=Busca Alt+F10=Listar"+spac(16)+"Ý"
endif
nIND := if(lPIND,NUMIND(cARQ),nIEXI)
setcursor(0)
if !USEREDE(cARQ,1,99)
   retu .F.
endif
IF VALTYPE(eFILTRO) = "C" .AND. !empty(eFILTRO)
   SET FILTER TO &eFILTRO.
ENDIF

//Tela Basica
setcolor(aCOR[1])
HB_dispbox(2,0,24 - 1,79,B_DOUBLE)
if valtype(cCAB) = "C"
   @ 03,1 say cCAB         
else
   @ 03,1 say cCBAS         
endif
@  4,0 say '+'+replicate('-',77)+'TÝ'         
setcolor(aCOR[1])

//Inicia o TBROWSE
oTB        := tbrowsedb(05,01,24 - 2,78)
ocTB       := tbcolumnnew("",bVID)
ocTB:WIDTH := 78
oTB:ADDCOLUMN(ocTB)

//Coloca a Barra de Trabalho
priv nSBAR
priv aSBAR
nSBAR := lastrec()
aSBAR := ScrollBarNew(04,79,24 - 1,substr(aCOR[1],rat(",",aCOR[1])+1))
ScrollBarDisplay(aSBAR)

//Inicia o LOOP
dbsetorder(nIND)
dbgotop()
if valtype(eINI) # "U"
   dbseek(eINI)
   if eof()
      dbgotop()
   endif
endif
while .T.
   dbselectar(cARQ)
   @  3,79 say "Ý"         
   MDS(cROD)
   //Enquanto n„o estabiliza, aguarda uma tecla.
   while (!oTB:STABILIZE())
      nKEY := HOTINKEY()
      if nKEY != 0
         exit
      endif
   enddo
   nMOVE := 0
   if oTB:STABLE  //Se objeto j  est vel...
      ScrollBarUpdate(aSBAR,(oTB:ROWPOS+4),nSBAR,.T.)
      nKEY  := 0
      nMOVE := 0
      while nKEY = 0
         nKEY := HOTINKEY()
         nKEY := LERMOUSE(nKEY)
         do case
            case MOUSE_B = 1 .and. MOUSE_Y = 4
               nKEY := K_UP
            case MOUSE_B = 1 .and. MOUSE_Y = 23
               nKEY := K_DOWN
            case MOUSE_B = 2
               nKEY := K_ESC
            case MOUSE_Y = 1 .and. MOUSE_B = 1 .and. MOUSE_X < 4
               nKEY := K_ESC
            case MOUSE_B = 1 .and. (oTB:ROWPOS+4) = MOUSE_Y .and. MOUSE_X # 79
               nKEY := K_ENTER
         endcase
         if MOUSE_X = MAXCOL() - 1 .and. MOUSE_B = 1
            do case
               case MOUSE_Y = 03
                  nKEY := K_HOME
               case MOUSE_Y >= 5 .and. MOUSE_Y <= 13
                  nKEY := K_PGUP
               case MOUSE_Y >= 14 .and. MOUSE_Y <= 22
                  nKEY := K_PGDN
               case MOUSE_Y = 24
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
         if MOUSE_B = 1 .and. MOUSE_Y > 4 .and. MOUSE_Y < MAXROW() - 1 .and. MOUSE_X # MAXCOL() - 1 .and. (oTB:ROWPOS+4) # MOUSE_Y
            if MOUSE_Y < (oTB:ROWPOS+4)
               nKEY  := 255   //Apenas Para Sair do Loop e marcar subir
               nMOVE := (oTB:ROWPOS+4) - MOUSE_Y
            else
               nKEY  := 254   //Apenas Para Sair do Loop e marcar descer
               nMOVE := MOUSE_Y - (oTB:ROWPOS+4)
            endif
         endif
      enddo
   endif

   //Saltar
   if nMOVE > 0
      if nKEY = 255
         for X := 1 to nMOVE
            oTB:UP()  //Cursor para cima.
         next X
      else
         for X := 1 to nMOVE
            oTB:DOWN()  //Cursor para baixo.
         next X
      endif
      nKEY := 0   //Zera o Inkey Evitar Conflito
      //  oTB:REFRESHALL() //Atualiza os Dados N„o Necessario
   endif

   //Teclas Deslocamento do Objeto TBrowse.
   do case
      case nKEY == K_UP   //Cursor para cima.
         oTB:UP()
      case nKEY == K_DOWN   //Cursor para baixo.
         oTB:DOWN()
      case nKEY == K_LEFT   //Cursor para esquerda.
         oTB:LEFT()
      case nKEY == K_RIGHT  //Cursos para direita.
         oTB:RIGHT()
      case nKEY == K_HOME   //Cursor para posi‡„o inicial da tela.
         oTB:GOTOP()
      case nKEY == K_END  //Cursor para posi‡„o final da tela.
         oTB:GOBOTTOM()
      case nKEY == K_PGUP   //Move cursor uma p gina de tela para cima.
         oTB:PAGEUP()
      case nKEY == K_PGDN   //Move cursor uma p gina de tela para baixo.
         oTB:PAGEDOWN()
      case nKEY == K_CTRL_PGUP  //Move cursor para o primeiro registro.
         oTB:GOTOP()
      case nKEY == K_CTRL_PGDN  //Move cursor para o £ltimo registro.
         oTB:GOBOTTOM()
   endcase

   //Informa o in¡cio ou o fim do arquivo (ou fonte de dados).
   if oTB:HITTOP
      MDS(" Vocˆ est  no primeiro registro !")
   endif
   if oTB:HITBOTTOM
      MDS(" Vocˆ est  no £ltimo registro !")
   endif

   if oTB:STABLE
      inclui := .F.
      do case
         case nKEY = K_ENTER .and. wVAR = 3
            eval(bAU2)
            setcursor(1)  //Aciona novamente o cursor.
            dbcloseall()
            exit
         case nKEY = K_ENTER .and. wVAR # 3
            nREG  := recno()
            cTELA := savescreen(02,00,24 - 1,79)
            EQUVARS()
            if valtype(bEQU) = "B"
               eval(bEQU)
            endif
            setcursor(1)
            //Metodo de Edi‡„o
            setcolor(aCOR[2])
            if cTIPG = "1"
               //Desenha a Tela
               eval(bTEL)
               // Get nas Menvars
               eval(bGET)
            else
               EDITGET(.T.,aCOR)
            endif
            setcursor(0)
            dbselectar(cARQ)
            netreclock()
            REPLVARS()
            dbunlock()
            if valtype(bPOS) = "B"
               eval(bPOS)
            endif
            dbselectar(cARQ)
            GRAVALOG(&wCHA,"ALT",cARQ)
            restscreen(02,00,24 - 1,79,cTELA)
            if nIND # 1
               oTB:GOTOP()
               oTB:REFRESHALL()
               dbgoto(nREG)
               oTB:REFRESHALL()
            else
               oTB:REFRESHCURRENT()
            endif
         case nKEY = K_DEL
            if mdg("Deseja Apagar")
               GRAVALOG(&wCHA,"DEL",cARQ)
               EQUVARS()  //Usado As Vezes Belo Block Del
               DELEREG(,,.F.,.F.,.F.)   //da o skip depois evitar erros bDEL
               //            DELEREG( cARQ, eBUSCA, lSAL, lLOG, lTOP )
               if valtype(bDEL) = "B"
                  eval(bDEL)
               endif
               dbselectar(cARQ)
               dbskip()
               if eof()
                  dbskip(- 1)
               endif
               nSBAR --
               oTB:REFRESHALL()
            endif
         case nKEY = K_INS
            cTELA := savescreen(02,00,24 - 1,79)
            nREG  := recno()
            CLRVARS()
            if valtype(bCHA) = "B"
               eval(bCHA)
            else
               if valtype(bINS) = "B"
                  lTMPRETU := eval(bINS)
                  IF VALTYPE(lTMPRETU) = "L"
                     IF !lTMPRETU
                        loop
                     endif
                  ENDIF
               endif
               PEGBUS(cARQ,1)
            endif
            dbselectar(cARQ)
            dbsetorder(1)
            dbgotop()
            IF !dbseek(mCHAVE)
               inclui := .T.
               netrecapp()
               nSBAR ++
               if valtype(aREP) = "A"
                  for X := 1 to len(aREP)
                     cFIL         := aREP[X,1]
                     cVAR         := aREP[X,2]
                     field->&cFIL := &cVAR
                  next X
               endif
               if valtype(aREP) = "B"
                  eval(aREP)
               endif
               netreclock()
               REPLVARS()
               dbunlock()
               DBCOMMITALL()
               nREG := recno()
               setcursor(1)
               //Metodo de Edi‡„o
               setcolor(aCOR[2])
               if cTIPG = "1"
                  //Desenha a Tela
                  eval(bTEL)
                  // Get nas Menvars
                  eval(bGET)
               else
                  EDITGET(.T.,aCOR)
               endif
               setcursor(0)
               dbselectar(cARQ)
               netreclock()
               REPLVARS()
               dbunlock()
               GRAVALOG(&wCHA,"INC",cARQ)
               if valtype(bPOS) = "B"
                  eval(bPOS)
               endif
            else
               ALERTX("J  Cadastrado Com esta Chave")
               dbgoto(nREG)
            endif
            dbselectar(cARQ)
            dbsetorder(nIND)
            restscreen(02,00,24 - 1,79,cTELA)
            oTB:GOTOP()
            oTB:REFRESHALL()
            dbgoto(nREG)
            oTB:REFRESHALL()
         case nKEY = K_CTRL_ENTER
            nREG    := recno()
            nIBUS   := if(lPBUS,NUMIND(cARQ),nIBUS)
            mCHABUS := PEGBUS(cARQ,nIBUS)
            IF VALTYPE(mCHABUS) = "C"
               mCHABUS := ALLTRIM(mCHABUS)
            ENDIF
            dbselectar(cARQ)
            dbsetorder(nIBUS)
            OTB:GOTOP()
            IF !dbseek(mCHABUS)
               ALERTX("Registro NÆo Encontrado")
               dbskip(- 1)  //O Mais Proximo e o anterior
               if bof()
                  dbgotop()
               endif
            ENDIF
            nREG := recno()
            dbsetorder(nIND)
            dbgoto(nREG)
            oTB:REFRESHALL()
      endcase
   endif
   if valtype(bAUX) = "B"
      eval(bAUX)
   endif
   if nKEY = K_ESC  //Encerra consulta.
      if mdg(" Deseja encerrar a consulta ?")
         setcursor(1)   //Aciona novamente o cursor.
         dbcloseall()
         exit
      endif
   endif
enddo

retu .T.

