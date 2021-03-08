*+¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥
*+
*+    Source Module => J:\FOLHA\PTO\FOPTO_1.PRG
*+
*+    Reformatted by Click! 2.03 on Dec-19-2002 at 10:11 am
*+
*+¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥

HELPDBF := "FOPTO10"

while .T.
   CABE3( 'FOPTO_1 - Relogio', 23 )
   OPCAO( 04, 01, "&A Copiar Arquivo          ", 65, " Faz copia do arquivo de Relogio/Ponto para a folha       " ) //1    
   OPCAO( 05, 01, "&B Transferir Arquivo      ", 66, " Carrega dados do arquivo Relogio/Ponto/Migracao          " ) //2    Utiliza arquivo de migracao append txt
   OPCAO( 06, 01, "&C Transferir Ponto        ", 67, " Transfere os dados do Relogio/Ponto para o Folha/Ponto   " ) //3
   OPCAO( 07, 01, "&D Ver/Imp Arq Relogio     ", 68, " Permite visualizar e imprimir arquivo exportacao Relogio " ) //4
   OPCAO( 08, 01, "&E Ver Arquivo Migracao    ", 69, " Exibe arquivo do Ponto/Migracao                          " ) //5
   OPCAO( 09, 01, "&F Ver Arquivo Migrado     ", 70, " Exibe arquivo do Ponto/Migrado                           " ) //6
   OPCAO( 10, 01, "&G Imprimir Arq/Migracao   ", 71, " Imprimir arquivo do Ponto/Migracao                       " ) //7
   OPCAO( 11, 01, "&H Imprimir Arq/Migrado    ", 72, " Imprimir arquivo do Ponto/Migrado                        " ) //8
   OPCAO( 12, 01, "&I Copia Reserva Arq/Rel   ", 73, " Efetua Copia Reserva Arq/Relogio do mes                  " ) //9
   OPCAO( 13, 01, "&J Voltar Copia Reserva    ", 74, " Retorna Copia Reserva Arq/Relogio do mes                 " ) //10
   OPCAO( 14, 01, "&K Importacao Expressa     ", 75, " Importada os dados do relogio sem Perguntas              " ) //11    Utiliza arquivo de migracao append txt
   OPCAO( 15, 01, "&L Importar Direto Com Perg", 76, " Importa.txt e relogio junto                              " ) //12
   OPCAO( 16, 01, "&M Importar Direto Sem Perg", 77, " Importa.txt e relogio junto sem perguntas                " ) //13
   OPCAO( 17, 01, "&N TXT Gravar BKP Periodo  ", 78, " Faz uma copia do TXT do periodo Mes                      " ) //14
   OPCAO( 18, 01, "&O TXT Optimizar Periodo   ", 79, " Optimizar um periodo do TXT                              " ) //15
   OPCAO( 19, 01, "&P TXT Conversao Formatos  ", 80, " Conversao de formatos                                    " ) //16
   OPCAO( 04, 41, "&Q Modelos de Relogios     ", 81, " Cadastro de Modelos de relogios                          " ) //17
   OPCAO( 05, 41, "&R Configuracao Importacao ", 82, " Configurar Importacao                                    " ) //18
   OPCAO( 06, 41, "&S Equipamentos            ", 83, " Configurar Equipamentos                                  " ) //19
   OPCAO( 07, 41, "&T Motivos Passagens AFDT  ", 84, " Motivos Passagens AFDT                                   " ) //20
   OPCAO( 08, 41, "&U Imp.Catraca WREL Portari", 85, " Importar Catracas WREL Portaria/Acesso                   " ) //21
   OPCAO( 09, 41, "&V Imp.Catraca WREL Refeito", 86, " Importar Catracas WREL Refeicao                          " ) //22
   OPCAO( 10, 41, "&W Gerar carga.txt rep     ", 88, " Gerar carga.txt rep                                      " ) //23
   OPCAO( 11, 41, "&X Sincronizar Catraca     ", 88, " Sincronizar Catraca                                      " ) //24
   OPCAO( 12, 41, "&Y Gerar AFD               ", 88, " Gerar AFD                                                " ) //25
   OPCAO( 13, 41, "&Z Importar AFD REP        ", 88, " Importar AFD Relogio                                     " ) //26   
   OPCAO := menu(, 24 )
   if ZUSER <> "SUPERVISOR" .and. ZUSER <> "SOFTEC" .and. OPCAO > 0
      if !VERSEHA( "MUSERM", , USERMCRI( ZUSER, "A", OPCAO ) )
         ALERTX( "Voce nao tem acesso, Verifique com o Supervisor" )
         loop
      endif
   endif
   IF ZFECHADO="S"
      if OPCAO=1.or.OPCAO=2.or.OPCAO=3.or.OPCAO=11.or.OPCAO=12.or.OPCAO=13
         ALERTX("Mes ja Fechado")
         loop
      endif
   ENDIF
   do case
   case OPCAO = 1
      FOPTO_14(.t.)   //A
  case OPCAO = 2
      FOPTO_11(0)    //B
   case OPCAO = 3
      FOPTO_12()     //C
   case OPCAO = 4
      FOPTO_13()    //D
   case OPCAO = 5
      FOPTO_16()     //E
   case OPCAO = 6
      FOPTO_16("D" )  //F
   case OPCAO = 7     //G
      FOPTO_3E(  )
   case OPCAO = 8     //H
      FOPTO_3E( "D" )
   case OPCAO = 9 //i
      FOPTO_17()
   case OPCAO = 10 //j
      FOPTO_18( )
   case OPCAO = 11   //k
       FOPTO_14(.f.)
   case OPCAO = 12 //l
       FOPTO_19(.t.)
   case OPCAO = 13 //m
       FOPTO_19(.f.)
   case OPCAO = 14 //n
       FOPTO_19(.f.,"B")
   case OPCAO = 15 //o
       FOPTO_19(.f.,"A")
   case OPCAO = 16 //p
       FOPTO_19(.f.,"C")
   case OPCAO = 17 //Q
      PADRAO("RELOGIOS","RELOGIOS","' '+STR(mNUMERO,8)+' '+mNOME","mNUMERO","Cadastro de Modelos Relogios","Cod.  Nome", ;
              {|| PEGCHAVE("mNUMERO",ULTIMOREG("RELOGIOS","NUMERO",.T.),"Codigo:")},"RELOGM","RELOGM",{|| FO_FOR("GRUPO='RELOG'")}, ;
              ,,,,"X")
   case OPCAO = 18 //R
      PADRAO("FOPTOREL","FOPTOREL","' '+STR(mNUMERO,8)+' '+mNOME","mNUMERO","Configuracao de Importacao","Cod.  Nome", ;
              {|| PEGCHAVE("mNUMERO",ULTIMOREG("FOPTOREL","NUMERO",.T.),"Codigo:")},"PTOREL","PTOREL",{|| FO_FOR("GRUPO='RELOG'")}, ;
              ,,,,"X")
   case OPCAO = 19 //S
      PADRAO("FOPTOEQP","FOPTOEQP","' '+STR(mNUMERO,8)+' '+mNOME","mNUMERO","Configuracao de Equipametos","Cod.  Nome", ;
              {|| PEGCHAVE("mNUMERO",ULTIMOREG("FOPTOEQP","NUMERO",.T.),"Codigo:")},"PTOEQP","PTOEQP",{|| FO_FOR("GRUPO='RELOG'")}, ;
              ,,,,"X")
   case OPCAO = 20 //T
      PADRAO("AFDTERR","AFDTERR","' '+STR(mNUMERO,8)+' '+DTOC(mDATA)+' '+STR(mHORA,5,2)+' '+mMOTOCO","STR(mNUMERO,8)+DTOS(mDATA)+STR(mHORA,5,2)","Motivos AFDT","Numero Data Hora Motivo", ;
              {|| iAFDTERR()},"AFDTER","AFDTER",{|| FO_FOR("GRUPO='AFD'")}, ;
              ,,,,"X")
   case OPCAO = 21 //U importar wrel portaria acesso
         FOPTO_15(1)
   case OPCAO = 22 //V importar wrel refeitorio
         FOPTO_15(2)
   case opcao = 23 //w gerar carga.txt
         fopto_rep()
   case opcao = 24 //X
         lDEMITDOSEXP:=MDG("Exportar demitidos")
		 cCAMPOEXP:="CHAPA"
         IF MDG("Usar Campo Chapa")
		    IF MDG("Usar campo Numero")
			   cCAMPOEXP:="NUMERO"
			endif
		 ENDIF		 
         if lDEMITDOSEXP
            fopto_cat(cCAMPOEXP)
 		 else
		    fopto_cat("if(empty(demitido),"+cCAMPOEXP+",0)")
		 ENDIF   		 
		 IF MDG("Gravar Data Demissao")
            fopto_cat("0",cCAMPOEXP)    		 
		 ENDIF
   case opcao = 25 //Y
         geraafd(.T.)
   case opcao = 26 //z
        fopto_19(.f.,"R")
   otherwise
      retu
   endcase
enddo

FUNCTION iAFDTERR
@ 24,00 SAY "Numero"
@ 24,20 SAY "Data"
@ 24,40 say "HORA"
@ 24,10 GET mNUMERO
@ 24,30 GET mDATA
@ 24,40 GET mHORA
READCUR()
mCHAVE:=str( mNUMero, 8 ) + dtos( mDATA ) + str( mHORA, 5, 2 )
RETURN .T.

FUNCTIOn gAFDTERR
IF EMPTY(mMOTOCO)
   RETU .T.
ENDIF
IF NETUSE("PD" + ANOMESW)
  if dbseek(mCHAVE)
     netreclock()
     field->numero:=mNUMERO
     field->data  :=mDATA
     field->hora  :=mHORA
     field->TIPOM :="D"
  endif
  DBCLOSEAREA()
ENDIF
RETURN .T.

function fopto_rep()
set century on
if ! netuse("fo_pes")
   return 
endif
if ! netuse("funcao")
   dbcloseall()
   return
endif   
Nuso:=fcreate('carga'+strZERO(nremp,3)+'.txt')
dbseleCtar("fo_pes")
dbgotop()
while ! eof()
   petela(8)
   mNUMERO:=NUMERO
   mNOME  :=NOME
   mFUNCAO:=FUNCAO
   cFUNCAO=OBTER("FUNCAO",,FUNCAO,"NOME") 
   dbselectar("fo_pes")
   if empty(demitido).and. ! empty(pis)
     fwrite(nUSO,strzero(mNUMERO,20))
     fwrite(nUSO,left(pis,11))
     fwrite(nUSO,"000000")
     fwrite(nUSO,STRTRAN(DTOC(ADMITIDO),"/",""))
     fwrite(nUSO,PADR(mNOME,52))
     fwrite(nUSO,padr(cfuncao,30))   
     fwrite(nUSO,chr(13)+chr(10))                  
   endif    
   dbselectar("fo_pes")
   dbskip()
enddo
dbcloseall()
fclose(nUSO)
return .t.


*+ EOF: FOPTO_1.PRG
