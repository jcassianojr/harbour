*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : mlib15.prg
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


#INCLUDE "INKEY.CH"
// ****************************************************************************
//  cARQ:=Nome do arquivo                 EX : "MC01"
//  aCOR:=Matriz com As cores 1,2,5,6,7   EX : {MAC001,MAC002,MAC005,MAC006,MAC007}
//        No Exemplo as cores foram ja armazenadas nas variaveis
//        Posi‡„o na Matriz 1->[1] 2->[2] 5->[3] 6->[4] 7->[5]
//  eCHAVE="Macro contendo a Chave Principal de Indexa‡ao EX: "mNUMERO"
//
//  nOPER:=Variavel de Controle da Tecla Enter Ex: wMAC
//  bTEL:=Nome do Bloco que Exibe a Tela  EX : {||tMAC()}
//  bINS:=Bloco Para Inclus„o EX:{||fMAC(1,0)}
//  bDEL:=Bloco Para Dele‡„o  EX:{||fMAC(3,0)}
//  bAL1:=Bloco Para Alterar  EX:{||fMAC(2,0)}
//  bAL2:=Bloco Para Alterar  EX:{||fMAC(6,0)}
//  bLIS:=Bloco de Listagem Auxiliar - Padr„o=Manlista  EX:{||M_BC()}
//  bAUX:=Bloco Com Fun‡”es Para Teclas Auxiliares


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function METPAG()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func METPAG(cARQ,aCOR,eCHAVE,nOPR,bTEL,bINS,bDEL,bAL1,bAL2,bLIS,bAUX)


priv KEY := 0
nIND := if(lPIND,NUMIND(cARQ),nIEXI)
nREG := 0   //Fixa Posi‡„o Zero
nREG := REGMOV(cARQ,nIND,nREG,"T")
if nREG = 0   //Nenhum arquivo
   if !mdg("Nenhum Registro Deseja Cadastrar o Primeiro")
      eval(bINS)
      nREG := 1
   endif
endif
while .T.
   mCHAVE := &eCHAVE.
   if cTIPG = "1"
      eval(bTEL)
   else
      setcolor(aCOR[2])
      EDITGET(.F.,aCOR)
   endif
   setcolor(aCOR[1])
   @ MAXROW(), 0 say chr(17)+" "+chr(16)+" HOME END PGUP/DW=Move INS=Novo DEL=Apag ENT=Muda CTR+ENT=Busca ALT+F10=Lista"         
   KEY := 0
   while KEY = 0
      KEY := HOTINKEY()
      KEY := LERMOUSE(KEY)
      if MOUSE_Y = MAXROW() .and. MOUSE_B = 2
         do case
            case MOUSE_X = 0
               KEY := K_DOWN
            case MOUSE_X = 2
               KEY := K_UP
            case MOUSE_X > 3 .and. MOUSE_X < 8
               KEY := K_HOME
            case MOUSE_X > 8 .and. MOUSE_X < 12
               KEY := K_END
            case MOUSE_X > 12 .and. MOUSE_X < 17
               KEY := K_PGUP
            case MOUSE_X > 16 .and. MOUSE_X < 21
               KEY := K_PGDN
            case MOUSE_X > 25 .and. MOUSE_X < 34
               KEY := K_INS
            case MOUSE_X > 34 .and. MOUSE_X < 43
               KEY := K_DEL
            case MOUSE_X > 43 .and. MOUSE_X < 52
               KEY := K_ENTER
            case MOUSE_X > 52 .and. MOUSE_X < 66
               KEY := K_CTRL_RET
            case MOUSE_X > 66 .and. MOUSE_X < 79
               KEY := K_ALT_F10
         endcase
      endif
      if MOUSE_Y = 1 .and. MOUSE_B = 2 .and. MOUSE_X < 4
         KEY := K_ESC
      endif
   enddo
   do case
      case key = K_UP .or. KEY = K_RIGHT
         nREG := REGMOV(cARQ,nIND,nREG,+1)
      case key = K_DOWN .or. KEY = K_LEFT
         nREG := REGMOV(cARQ,nIND,nREG,- 1)
      case KEY = K_PGUP
         nREG := REGMOV(cARQ,nIND,nREG,+10)
      case KEY = K_PGDN
         nREG := REGMOV(cARQ,nIND,nREG,- 10)
      case key = K_HOME
         nREG := REGMOV(cARQ,nIND,nREG,"T")
      case key = K_END
         nREG := REGMOV(cARQ,nIND,nREG,"B")
      case KEY = K_INS
         eval(bINS)
      case KEY = K_ENTER .and. nOPR # 3
         eval(bAL1)
      case KEY = K_ENTER .and. nOPR = 3
         eval(bAL2)
         retu
      case KEY = K_DEL
         eval(bDEL)
      case KEY = K_ALT_F10
         if valtype(bLIS) = "B"
            eval(bLIS)
         else
            MANLISTA()
         endif
      case KEY = K_CTRL_RET
         nIBUS   := if(lPBUS,NUMIND(cARQ),nIBUS)
         mCHABUS := PEGBUS(cARQ,nIBUS)
         nREG    := REGBUS(cARQ,nIBUS,mCHABUS)
      case KEY = K_ESC
         exit
      otherwise
         if valtype(bAUX) = "B"
            eval(bAUX)
         endif
   endcase
enddo
retu .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function REGMOV()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func REGMOV(cARQ,nIND,nREG,nSAL)


local nREGRET := 0
local cMES    := ""
local lZERO   := .F.
if valtype(nREG) # "N"
   nREG := 1
endif
if !USEREDE(cARQ,1,nIND)
   ALERTX("N„o Consegui Abrir o Arquivo")
   retu nREG
endif
if valtype(nSAL) = "N"
   dbgoto(nREG)
   dbskip(nSAL)
   if nSAL < 0
      if bof()
         cMES := "Vocˆ est  no primeiro Registro"
         dbgotop()
      endif
   endif
   if nSAL > 0
      if eof()
         cMES := "Vocˆ est  no ultimo Registro"
         dbgobottom()
      endif
   endif
endif
if valtype(nSAL) = "C"
   if nSAL = "B"
      dbgobottom()
   endif
   if nSAL = "T"
      dbgotop()
      if eof()
         lZERO := .T.
      endif
   endif
endif
if !lZERO
   EQUVARS()
   nREGRET := recno()
endif
dbclosearea()
if !empty(cMES)
   ALERTX(cMES)
endif
retu nREGRET

