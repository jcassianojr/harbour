*+лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
*+
*+    Source Module => C:\DEVELOP\CLIPPER\FOLHA\PTO\FOPTO_31.PRG
*+
*+    Functions: Function FOPTO31()
*+
*+лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

FUNCTION FOPTO_31
PARA nTIP31

if !MDL( 'FOPTO_31 - Listagem do Ponto Mensal' )
   retu
endif

cPN := "PN" + ANOMESW  //Ponto
cPD := "PD" + ANOMESW  //Passagens
cPO := "PO" + ANOMESW  //Ocorrencias
cPM := "PM" + ANOMESW  //Troca de Horarios
cPH := "PH" + ANOMESW  //Correcao de Horarios
cPT := "PT" + ANOMESW  //Totais

IF nTIP31=2
   cPD := PARQDIO()
ENDIF

lMIN := .F.
CODCTA := PEGCX()
DESCTA := array( 24 )


if ! NETUSE("FIRMA")
   retu
endif
dbgotop()
dbseek( NREMP )

if ! NETUSE(pes) 
   dbcloseall()
   retu
endif
FILTRO := '((EMPTY(DEMITIDO)).OR.(MONTH(DEMITIDO)>=MESTRAB.AND.YEAR(DEMITIDO)>=ANOUSO))'
INX    := ""
FILORD(.T.)
nLASTREC:=LASTREC()
zei_fort( nLASTREC,,,0)
if valtype(INX)="N"
   dbsetorder(INX)
ELSE
   ordDestroy("temp")
   ordcreate(,"temp",inx) //,{|| zei_fort(nLASTREC,,,1)})
   ordSetFocus("temp")
ENDIF   
set filter to &FILTRO


if ! netuse(Cpn)
   dbcloseaLL()
   retu
endif

if ! netuse(CpD)
   dbcloseaLL()
   retu
endif

if ! NETUSE("TABFALTA")
   dbcloseaLL()
   retu
endif

if ! netuse("tabturno")
   dbcloseaLL()
   retu
endif

if ! NETUSE(cPO)
   dbcloseall()
   retu .F.
endif

if ! NETUSE(cPM)
   dbcloseall()
   retu .F.
endif

if ! NETUSE(cPH)
   dbcloseall()
   retu .F.
endif

if ! NETUSE(cPT)
   dbcloseall()
   retu .F.
endif

if ! NETUSE("CONTAS")
   dbcloseall()
   retu .F.
endif


LISTARUE( { | X | FOPTO31( X ) } )

retuRN

*+лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
*+
*+    Function FOPTO31()
*+
*+    Called from ( fopto_31.prg )   1 - function fopto2h()
*+
*+лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
*+
func FOPTO31

para COMPARE
dbselectar(pes)
dbgotop()
while !eof()
   if &COMPARE

      dbselectar(pes)
      NUM := NUMERO
      mNUMERO:= NUMERO
      aCH:={}


     IF nTIP31=3
        lLISTA:=.F.
        aUSO:={cPO,cPM,cPH}
        FOR KW=1 TO 3
           dbselectar( aUSO[KW] )
           dbgotop()
           dbseek(STR(NUM,8))
           if NUM=NUMERO
              lLISTA:=.T.
           endif
        NEXT KW
      ENDIF


      IF nTIP31<>3.OR.lLISTA
          dbselectar("firma")
          @ prow() + 1, 0 say repl( '=', 79 )
          @ prow() + 1, 0 say "FOLHA DE PONTO - " + ALLTRIM(RAZAO)
          @ prow(), 56    say "CGC:" + CGC
          @ prow() + 1, 0 say "End: " + ENDERECO + " - " + BAIRRO + " - " + CIDADE + " - " + ESTADO
          if !empty( NOMSETOR )
             @ prow() + 1, 0 say NOMSETOR
          endif
          dbselectar(pes)
          cHT  := HT
          cHTT := HTT
          dADM := ADMITIDO
          cPIS   := PIS
          cEVINC:=FIELD->EVINC
          ANO := str( year( DXDIA ), 4 )
          @ prow() + 1, 0 say "Funcionario:" + str( NUM, 8 ) + "-" + NOME + " PIS: " + cPIS
          @ prow() + 1, 0 say "Depto: " + STRVAL( DEPTO, 4 ) + "/" + STRVAL( SETOR, 3 ) + "/" + STRVAL( SECAO, 3 ) + " Horario: "
          dbselectar("tabturno")
          dbgotop()
          if dbseek( cHTT )
             @ prow(), 30    say NOME
             @ prow() + 1, 0 say "Admitido: " + dtoc( dADM )
             if !empty( NOM2 )
                @ prow(), 30 say NOM2
             endif
          else
             @ prow(), 30    say "Descritivo de Horario nao Cadastrado"
             @ prow() + 1, 0 say "Admitido: " + dtoc( dADM )
          endif
          @ prow() + 1, 0 say "Competencia: " + MMES( MESTRAB ) + "/" + ANO
          @ prow(),pcol()+1 say IMPSTR(cIMPCOM)+" Legenda: #Alteracao de Horario Trabalho *Lancamento Manual (I)ncluido (D)esconsiderado"
          @ prow() + 1, 0 say repl( '-', 132 )
          IF nTIP31<>3
             @ prow() + 1, 0 say "DIA"
             @ prow(),10 say "CH  Jornada Realizada"
             @ PROW(),35 SAY "Marcacoes Registradas no Ponto Eletronico"
          ENDIF
          IF nTIP31=1
             @ PROW(),80 say "Correcoes"
          ENDIF

         IF ! VALPIS(cPIS,.F.,.F.,cEVINC)
            @ PROW()+1,0 SAY ZERRO
            IMPFOL()
            dbselectar(PES)
            dbskip()
            loop
         ENDIF


      ENDIF

      IF nTIP31<>3
        dbselecTAREA(cPN)
        dbgotop()
        dbseek( str( NUM, 8 ) )
        while NUMERO = NUM .and. !eof()
           CODIG := COD
           SODIG := SOD
           ENTRA := ENT
           SAIDA := SAI
           Mdata:=DATA

           IF LEFT(SODIG,1)="_" //Codigos Indicativos Horario Flexivel _A _0
              SODIG:=""
           ENDIF
           @ prow() + 1, 0 say mDATA
           IF nTIP31<>1
             @ prow(),pcol() say MUDHOR
           ENDIF
           COL := 10
           if nTIP31=1
              if horario>0
                 @ prow(),10 say str(horario,3) 
                 IF ASCAN(aCH,HORARIO)=0
                    AADD(aCH,HORARIO)
                 ENDIF
              endif
              if ENTRA # 0 .or. SAIDA # 0
                 @ prow(),14 say ENTRA
                 @ prow(),pcol() say MUDENT
                 if empty( ALS ) .and. empty( ALE )
                    //@ prow(), 19 say "AS"
                 else
                    @ prow(), 16  say ALS
                    @ prow(),pcol() say MUDALS
                    @ prow(), 22 say ALE
                    @ prow(),pcol() say MUDALE
                 endif
                 @ prow(), 28 say SAIDA
                 @ prow(),pcol() say MUDSAI
                 COL := 34
              endif
           ENDIF
           IF nTIP31=1.OR.nTIP31=2
              COL:=IF(nTIP31=1,35,10)
              dbselectar(Cpd)
              dbgotop()
              dbseek( str( NUM, 8 ) + dtos( mDATA ) )
              while DATA = mDATA .and. NUMERO = NUM .and. !eof()
                  @ prow(), COL     say HORA
                  COL += 6
                  if COL >= 82
                     @ prow() + 1, 0 say ""
                     COL := IF(nTIP31=1,35,10)
                  endif
                  dbskip()
              enddo
           ENDIF



           DBSELECTAREA(cPN)
           cNOME:=""
           fopto31a(CODIG)
           fopto31a(SODIG)

           dbseleCTAREA(cPN)
           //mudanca de horario
           IF nTIP31=1
              IF ! EMPTY(MUDHOR)
                 @ prow(),80 SAY MUDHOR
                 @ prow(),82 say CODREV
                 @ prow(),86 say ENTREV
                 if empty( ALIREV ) .and. empty( ALSREV )
                 else
                   @ prow(), 92   say ALIREV
                   @ prow(), 98   say ALSREV
                 endif
                 @ prow(),104  say SAIREV
              ENDIF
           ENDIF
           dbselectar(CPN)

           //Ajuste de horas
           IF nTIP31=1
              IF ! EMPTY(ALLTRIM(MUDENT+MUDALE+MUDALS+MUDSAI))
                 IF PCOL()>80
                    @ PROW()+1,0 SAY ""
                 ENDIF
                 dbselectar(cPM)
                 dbgotop()
                 if dbseek( str( mNUMERO, 8 ) + dtos( mDATA ))
                    cZERHOR:=IF(TYPE("ZERHOR")="C",ZERHOR," ") //zerhor competencia antigas
                    DO CASE
                       CASE cZERHOR="S"
                            cZERHOR:="D"
                       CASE EMPTY(cZERHOR)
                            cZERHOR:="I"
                    ENDCASE
                    @ prow(), 80 SAY "*"
                    @ prow(), 82 say cZERHOR
                    @ prow(), 86 say IF(EMPTY(HOROCO),"",HOROCO)
                    @ prow(), 92 say IF(EMPTY(HOROC2),"",HOROC2)
                    @ prow(), 98 say IF(EMPTY(HOROC3),"",HOROC3)
                    @ prow(),104 say IF(EMPTY(HOROC4),"",HOROC4)
                    IF LEN(ALLTRIM(MOTOCO))>20
                       @ PROW()+1,0 SAY ""
                       @ PROW(),35  SAY MOTOCO
                    ELSE
                       @ prow(),110 say IF(EMPTY(MOTOCO),"Preencher Motivo",left(MOTOCO,20))
                    ENDIF
                 ENDIF
              ENDIF
           ENDIF
           dbselectar(CPN)

           //Observacao ocorrencia
           IF nTIP31=1
              IF EMPTY(CODIG).OR.CODIG="FO".OR.CODIG="SA".OR.CODIG="DO".OR.CODIG="FE"
              ELSE
                 IF PCOL()>80
                    @ PROW()+1,0 SAY ""
                 ENDIF
                 dbselectar(cPO)
                 dbgotop()
                 if dbseek( str( mNUMERO, 8 ) + dtos( mDATA ))
                    IF EMPTY(OCOFIM).AND.OCOINI=mDATA
                    ELSE
                       @ prow(), 86 say OCOINI
                    ENDIF                    
                    @ prow(), 96 say IF(EMPTY(OCOFIM),"",OCOFIM)
                    
                    IF LEN(ALLTRIM(OCOMOT))>20
                       @ PROW()+1,0 SAY ""
                       @ PROW(),35  SAY OCOMOT
                    ELSE
                       @ prow(),110 say IF(EMPTY(OCOMOT),"Preencher Motivo",left(OCOMOT,20))
                    ENDIF
                 ENDIF
              ENDIF
           ENDIF


           DBSELECTAREA(cPN)
           dbskip()
        enddo
      ENDIF

      IF nTIP31=3.AND.lLISTA
         FOR KW=1 TO 3
            dbselectar( aUSO[KW] )
            while numero=NUM.AND. ! eof()
                IF KW=1    //Ocorrencias
                   @ PROW()+1,0 SAY "Ocorrencia      -> "
                   @ PROW(),PCOL()+1 say OCOINI
                   @ PROW(),PCOL()+1 SAY if(empty(ocofim),space(8),OCOFIM)
                   @ PROW(),PCOL()+1 SAY OCOCOD
                   @ PROW(),PCOL()+1 SAY OCOSUB
                   @ PROW(),PCOL()+1 SAY IF(EMPTY(OCOMOT),"Preencher Motivo",LEFT(OCOMOT,20))
                ENDIF
                IF KW=2   //passagens
                   @ PROW()+1,0 SAY "Marcacao        -> "
                   @ PROW(),PCOL()+1 say DATOCO
//                   @ PROW(),PCOL()+1 SAY CODOCO
                   @ PROW(),PCOL()+1 SAY HOROCO
                   @ PROW(),PCOL()+1 SAY HOROC2
                   @ PROW(),PCOL()+1 SAY HOROC3
                   @ PROW(),PCOL()+1 SAY HOROC4
                   @ PROW(),PCOL()+1 SAY IF(EMPTY(MOTOCO),"Preencher Motivo",LEFT(MOTOCO,20))
                ENDIF
                IF KW=3    //Horarios de trabalho
                   @ PROW()+1,0 SAY "Troca de Horario-> "
                   @ PROW(),PCOL()+1 say OCOINI
                   @ PROW(),PCOL()+1 SAY if(empty(ocofim),space(8),OCOFIM)
                   @ PROW(),PCOL()+1 SAY OCOCOD
                   @ PROW(),PCOL()+1 SAY IF(EMPTY(OCOMOT),"Preencher Motivo",LEFT(OCOMOT,20))
                ENDIF
                dBSkip()
            enddo
         NEXT KW
      ENDIF

      IF nTIP31=1  //Horarios
         @ prow() + 1, 0 say IMPSTR( cIMPCOM ) + "CH-Horarios Contratuais: "+repl( '=', 107 ) + IMPSTR( cIMPCOM )
         nCOL=0
         FOR X=1 TO LEN(aCH)                   
             aTMP=PEGPTOHOR(aCH[X])             
             IF nCOL=0
                @ PROW()+1,0 SAY IMPSTR(cIMPCOM)+STR(aCH[X],3)
             ELSE
                @ PROW(),nCOL SAY IMPSTR(cIMPCOM)+STR(aCH[X],3)
             ENDIF         
             @ PROW(), PCOL()+3 say aTMP[1] pict '99.99'
             @ PROW(), PCOL()+5 say aTMP[2] pict '99.99'
             @ PROW(), PCOL()+5 say aTMP[3] pict '99.99'
             @ PROW(), PCOL()+5 say aTMP[4] pict '99.99'
             nCOL+=50
             IF nCOL=100
                nCOL=0                
             ENDIF             
         NEXT X
      endif
      IF nTIP31=1   //Totais do mes
         dbselectar(cPT)
         dbgotop()
         IF dbseek( mNUMERO )
            nTOTBCOHRS:=BCOHRS
            @ prow() + 1, 0 say IMPSTR( cIMPCOM ) + repl( '=', 132 ) + IMPSTR( cIMPCOM )
                               aTOTAL := { CTA01, CTA02, CTA03, CTA04, CTA05, CTA06, CTA07, CTA08, ;
                                           CTA09, CTA10, CTA11, CTA12, CTA13, CTA14, CTA15, CTA16, ;
                                           CTA17, CTA18, CTA19, CTA20, CTA21, CTA22, CTA23, CTA24 }
             for X := 1 to 8
                nSALTO := 1
                BUSCA  := CODCTA[ X ]       //Contas 0 a 8
                BUSCA  := if( empty( BUSCA ), 0, &BUSCA )   //usa macro tipsal alguns nao pode ser para todos empregados
                dbselectar("CONTAS")
                dbgotop()
                dbseek( BUSCA )
                DESCTA[ X ] = if( found(), DESCR, "" )
                if !empty( aTOTAL[ X ] )
                   @ prow() + 1, 0 say strzero( X, 3 ) + " - " + DESCTA[ X ]
                   @ prow(), 50    say if( lMIN, BHOR( aTOTAL[ X ] ), aTOTAL[ X ] ) pict "9999.99"
                   nSALTO := 0
                endif
                BUSCA := CODCTA[ X + 8 ]    //Contas 9 a 16
                BUSCA := if( empty( BUSCA ), 0, &BUSCA )  //usa macro tipsal alguns nao pode ser para todos empregados
                dbselectar("CONTAS")
                dbgotop()
                dbseek( BUSCA )
                DESCTA[ X + 8 ] = if( found(), DESCR, "" )
                if !empty( aTOTAL[ X + 8 ] )
                   @ prow() + nSALTO, 60 say strzero( X + 8, 3 ) + " - " + DESCTA[ X + 8 ]
                   @ prow(), 110         say if( lMIN, BHOR( aTOTAL[ X + 8 ] ), aTOTAL[ X + 8 ] ) pict "9999.99"
                endif
             next X
             
         ENDIF
      ENDIF
      IF nTIP31=1 //nTIP31<>3.OR.lLISTA
         @ prow() + 1, 0 say IMPSTR( cIMPCOM ) + repl( '=', 132 ) + IMPSTR( cIMPCOM )
         @ PROW() + 1,  0 SAY "Emitido Em:"+dtoc(dxdia)+" "+time()
         @ prow() + 3, 20 say IMPSTR(cIMPEXP)+repl( '-', 30 ) + spac( 5 ) + repl( '-', 30 )
         @ prow() + 1, 20 say "Assinatura do RH" + spac( 15 ) + "Assinatura do Funcionario"
         @ prow() + 1, 0 say repl( '=', 79 )
         IMPFOL()
      ENDIF
   endif
   dbselectar(pes)
   dbskip()
enddo
return 


FUNC fopto31a(cCOD)
IF empty(cCOD)
   RETURN ""
ENDIF
if ! empty( cNOME )
   cNOME += " / "
ENDIF
Dbselectar("tabfalta")
dbgotop()
if dbseek( cCOD )
   cNOME := cCOD + "-" + ALLTRIM(NOME)
else
   cNOME := cCOD
endif
IF COL+LEN(cNOME)>80
   @ PROW()+1,0 SAY ""
   COL := IF(nTIP31=1,35,10)
ENDIF
@ prow(), COL say cNOME
col=pcol()+1
Return ""



*+ EOF: FOPTO_31.PRG
