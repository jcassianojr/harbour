*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fopto_4j.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 27-Dez-2024 as  9:33 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+



//Teclas Operacionais
#INCLUDE "INKEY.CH"
////#INCLUDE "COMANDO.CH"

CRIARVARS("FOPTOPRO")



while .T.
   CABE3('FOPTO_4J - Provisorios   ',23)
   OPCAO(04,01," &A - Consultar Competencia em Uso",65," Consultar                                     ")
   OPCAO(05,01," &B - Consultar Todos Lancamentos ",66,"                          Arquivado            ")
   OPCAO(06,01," &C - Consultar Arquivado         ",67," Consultar Arquivados                          ")
   OPCAO(07,01," &D - Arquivar Demitidos          ",68," Arquiva             Demitidos                 ")
   OPCAO(08,01," &E - Arquivar Um ano             ",69," Arquiva Um Ano                                ")
   OPCAO(09,01," &F - Arquivar Competencia MesAno ",70," Arquiva uma competencia mes/ano               ")
   OPCAO(10,01," &G - Arquivar Um Funcionario     ",71," Arquiva Um Funcionario                        ")
   OPCAO(11,01," &H - Retornar Demitidos          ",72," Retorna             Demitidos                 ")
   OPCAO(12,01," &I - Retornar Um ano             ",73," Retorna Um Ano                                ")
   OPCAO(13,01," &J - Retornar Competencia MesAno ",74," Retorna uma competencia mes/ano               ")
   OPCAO(14,01," &K - Retornar Um Funcionario     ",75," Retorna Um Funcionario                        ")
   //   OPCAO( 15, 01, " &L - Excluir um Funcionario+Mvto ", 76, " Excluir um Funcionario Provisorio+Movimento   " )
   OPCAO := menu(1,24)
   DO CASE
   CASE OPCAO = 1   //A Consulta Atual So competencia
      cFILTRO := "DATA>=ZDATAINI.AND.DATA<=ZDATAFIM"
      PADRAO("FOPTOPRO","FOPTOPRO","STR(mORIGEM)+' '+DTOC(mDATA)+' '+STR(mDESTINO)+' '+mNOME","STR(mORIGEM)+DTOS(mDATA)","Cadastro de Provisorios","Origem      Dia   Destino Obs",;
       {|| iFOPTO4J()},{|| tFOPTO4J()},{|| gFOPTO4J()},{|| FO_RELL("PONTOCAD11")},cFILTRO,2)
   CASE OPCAO = 2   //B Consulta Atual
      PADRAO("FOPTOPRO","FOPTOPRO","STR(mORIGEM)+' '+DTOC(mDATA)+' '+STR(mDESTINO)+' '+mNOME","STR(mORIGEM)+DTOS(mDATA)","Cadastro de Provisorios","Origem      Dia   Destino Obs",;
       {|| iFOPTO4J()},{|| tFOPTO4J()},{|| gFOPTO4J()},{|| FO_RELL("PONTOCAD11")},,2)
   CASE OPCAO = 3   //C Consultar Arquivados
      PADRAO("FOPTOPRD","FOPTOPRD","STR(mORIGEM)+' '+DTOC(mDATA)+' '+STR(mDESTINO)+' '+mNOME","STR(mORIGEM)+DTOS(mDATA)","Cadastro de Provisorios","Origem      Dia   Destino Obs",;
       {|| iFOPTO4J()},{|| tFOPTO4J()},{|| gFOPTO4J()},{|| FO_RELL("PONTOCAD11")},,2)
   CASE OPCAO = 4   //D Arquiva Demitido
      fopto4u(1,3)
   CASE OPCAO = 5   //E Arquiva Ano
      fopto4u(2,3)
   CASE OPCAO = 6   //F Arquiva Mes Ano
      fopto4u(3,3)
   CASE OPCAO = 7   //G Arquiva Funcionario
      fopto4u(4,3)
   CASE OPCAO = 8   //H Retorna Demitidos
      fopto4u(1,4)
   CASE OPCAO = 9   //I Retorna Ano
      fopto4u(2,4)
   CASE OPCAO = 10  //J Retorna mes ano
      fopto4u(3,4)
   CASE OPCAO = 11  //K Retorna funcionario
      fopto4u(4,4)
   OTHERWISE
      retu
   endcase
   if opcao = 1 .or. opcao = 2
      if mdg("Atualizar Importacao Provisorios")
         TrocaPro()
         if MDG("Deseja Transferir Dados Ponto do Mes")
            FOPTO_12()
         endif
      endif
   endif
enddo
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function iFOPTO4J()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func iFOPTO4J


MDS('Provisorio Real    Motivo:')
@ 24,26 get mORIGEM  pict "99999999"                                                               VALID mORIGEM > 0                                  
@ 24,35 get mDESTINO pict "99999999"                                                               valid mDESTINO <> mORIGEM .AND. mDESTINO > 0       
@ 24,44 get mMOTIVO  VALID ALLTRUE(IF(EMPTY(mNOME),mNOME := OBTER("FOPTOMOT",,mMOTIVO,"NOME"),""))                                                    
@ 24,53 get mNOME    pict "@S20"                                                                   valid !empty(mNOME)                                
if !READCUR()
   retu .F.
endif
mADMITIDO  := OBTER(PES,,mDESTINO,"ADMITIDO")
mDEMITIDO  := OBTER(PES,,mDESTINO,"DEMITIDO")
mDATTRANSF := OBTER(PES,,mDESTINO,"DATTRANSF")
IF mDATTRANSF > mADMITIDO
   mADMITIDO := mDATTRANSF
ENDIF
dINI := zdataini
dFIM := zdatafim
IF mADMITIDO > dINI
   dINI := mADMITIDO
ENDIF
if !empty(mDEMITIDO)
   IF dFIM > mDEMITIDO
      dFIM := mDEMITIDO
   ENDIF
ELSE
   mDEMITIDO := dFIM
ENDIF
MDS('Digite o Periodo ')
@ 24,40 get dINI VALID dINI >= mADMITIDO        
@ 24,50 get dFIM VALID dFIM <= mDEMITIDO        
if !READCUR()
   retu .F.
endif
//N„o Grava o ultimo por que a funcao padrao fara
for W := dINI to dFIM
   mDATA  := W
   mCHAVE := str(mORIGEM)+dtos(W)
   IF VIDEO <> "B"
      if NOVOREG("FOPTOPRO","FOPTOPRO",mCHAVE)
         if VIDEO = 'S'
            aadd(aPAD1,NIL)
            aadd(aPAD2,NIL)
            POS  := len(aPAD1)
            POSW := 1
            if POS > 1
               for X := 1 to POS - 1
                  mDARE := aPAD2[X]
                  if mCHAVE <= mDARE
                     exit
                  endif
               next
               POSW := X
            endif
            ains(aPAD1,POSW)
            ains(aPAD2,POSW)
            aPAD1[POSW] = STR(mORIGEM)+' '+DTOC(W)+' '+STR(mDESTINO)+' '+mNOME
            aPAD2[POSW] = str(mORIGEM)+dtos(W)
            pPAD := POSW
         endif
      endif
   ELSE
      DBGOTOP()
      IF !DBSEEK(mCHAVE)
         netrecapp()
         REPLVARS()
      ENDIF
   ENDIF
next W
mCHAVE := str(mORIGEM)+dtos(DFIM)
retu .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function gFOPTO4J()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function gFOPTO4J

@ 24,30 get mMOTIVO VALID ALLTRUE(IF(EMPTY(mNOME),mNOME := OBTER("FOPTOMOT",,mMOTIVO,"NOME"),""))                           
@ 24,40 get mNOME   pict "@S20"                                                                   valid !empty(mNOME)       
READCUR()
return .T.


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function tFOPTO4J()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function tFOPTO4J

@ 24,00 clea
@ 24,00 say mORIGEM          
@ 24,10 say mDATA            
@ 24,20 say mDESTINO         
@ 24,30 SAY mMOTIVO          
@ 24,40 say mNOME            
return .T.



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function TrocaPro()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCTION TrocaPro(cPD,dINI,dFIM)

LOCAL i
IF valtype(cPD) # "C"
   nTIPO := PEGRELOGIO()
   if nTIPO = 1 .or. nTIPO = 4 .or. nTIPO = 5
      cPD := PARQDIO(nTIPO)
   ELSE
      retu
   Endif
endif
if valtype(dini) # "D"
   Dini := zdataini
   Dfim := zdatafim
   MDS('Digite o periodo ')
   @ 24,40 get Dini         
   @ 24,60 get Dfim         
   if !READCUR()
      retu .F.
   endif
endif
mds("Provisorios")
CHECKCRI(cPD,"FO_DIO","STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)")
if !NETUSE(cPD)
   dbcloseall()
   retu
endif
if !NETUSE("FOPTOPRO")
   dbcloseall()
   retu
endif
dbselectar("foptopro")
dbgotop()
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
while !eof()
   if DATA >= DINI .and. DATA <= DFIM
      mNUMERO  := ORIGEM
      mDESTINO := DESTINO
      mDATA    := DATA
      aORI     := {}
      aDES     := {}
      aREL     := {}
      cCHAVE   := STR(mNUMERO,8)+DTOS(mDATA)
      @ 24,20 say cCHAVE         
      dbselectar(cPD)
      dbgotop()
      dbseek(cCHAVE)
      while numero = mNUMERO .AND. DATA = mDATA .and. !eof()  //pegue os horarios
         aadd(aORI,STR(mNUMERO,8)+DTOS(mDATA)+STR(HORA,5,2))  //Necessario matriz pois cpd index e data e reposiona
         aadd(aDES,STR(mDESTINO,8)+DTOS(mDATA)+STR(HORA,5,2))
         aadd(aREL,{HORA,RELOGIO,TIPOR})
         dbskip()
      enddo
      FOR i := 1 TO LEN(aORI)
         dbselectar(cPD)  //desconsidera a com cracha provisorio
         dbgotop()
         if dbseek(aORI[I])
            netrecdel()
         endif
         dbselectar(cPD)  //considera a com cracha correto
         dbgotop()
         if !dbseek(ades[I])
            netrecapp()
            field->NUMERO  := mDESTINO
            FIELD->DATA    := mDATA
            FIELD->HORA    := aREL[I,1]
            FIELD->RELOGIO := aREL[I,2]
            FIELD->TIPOR   := aREL[I,3]
         endif
      NEXT i

      /* abaixo
     dbselectar(cPD)     
     dbseek(cCHAVE)
     while numero=mNUMERO.AND.DATA=mDATA.and. ! eof()
         mHORA:=HORA
         dbskip()
         if numero=mNUMERO.AND.DATA=mDATA.and.HORA=mHORA.AND.! EOF()   //Apaga dupliciadades
            NETRECDEL()
         endif
     enddo
     */
   endif
   dbselectar("foptopro")
   dbskip()
   zei_fort(nLASTREC,,,1)
enddo


dbselectar(cPD)
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
dbgotop()
while !eof()
   mNUMERO := NUMERO
   mDATA   := DATA
   mHORA   := HORA
   dbskip()
   if numero = mNUMERO .AND. DATA = mDATA .and. HORA = mHORA .and. !eof()   //Apaga dupliciadades
      NETRECDEL()
   endif
   zei_fort(nLASTREC,,,1)
enddo
dbcloseall()
netpack(cPD)


//FUNCtion APAGAPRO(mNUMERO)
//cPD := "PD" + ANOMESW
//CHECKCRI( cPD, "FO_DIO", "STR(NUMERO,8)+DTOS(DATA)+STR(HORA,5,2)" )
//
//if ! NETUSE(cPD)
//   dbcloseall()
//   retu
//endif
//dbgotop()
//dbseek(STR(mNUMERO,8))
//WHILE numero=mNUMERO.AND.! EOF()
//     netrecdel()
//     dbskip()
//ENDDO
//dbcloseall()
//if ! NETUSE("FOPTOPRO")
//   dbcloseall()
//   retu
//endif
//dbselectar("foptopro")
//dbgotop()
//while ! eof()
//     IF ORIGEM=mNUMERO.OR.DESTINO=mNUMERO
//        netrecdel()
//     ENDIF
//     dbskip()
//ENDDO
//dbcloseall()
//fopto_2a("NUMERO="+STR(mNUMERO,8))



*+ EOF: fopto_4j.prg
*+
