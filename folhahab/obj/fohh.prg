*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fohh.prg
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
*+    Documentado em 27-Dez-2024 as  9:46 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :       FOHH.PRG: Rela‡„o de Contribui‡„o ao Sindicato
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1998,  SOFTEC  S/C Ltda.
// :  Atualizado em: 30/06/98
// :
// :*****************************************************************************
////#INCLUDE "COMANDO.CH"

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function fohh()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function fohh

PARA POS1,CTA
IF ARQ = 9 .OR. ARQ = 10
   MDT('Use a opcao Folha de Pagamento')
   RETU
ENDIF
IF ARQ = 6
   ALERTX("Nao Disponivel VT")
   RETU .F.
ENDIF


IF !MDL('Rela‡„o de Contribui‡„o ao Sindicato '+POS1,0)
   RETU
ENDIF

CTA := 630
@ 24,00 SAY "Confirme a Conta"                    
@ 24,60 GET CTA                PICT '####'        
IF !READCUR()
   RETU .F.
ENDIF

IF !ARQCTA(ARQ)
   DBCLOSEALL()
   RETU .F.
ENDIF
DBGOTOP()
if !DBSEEK(CTA)
   DBCLOSEALL()
   ALERTX("Conta N„o Cadastrada")
   RETU .F.
ENDIF
DBCLOSEALL()




IF !ARQUSAR(ARQ,1)
   DBCLOSEALL()
   RETU .F.
ENDIF
cSELE1 := Alias()

IF !ARQPES(ARQ,1,0)
   RETU .F.
ENDIF
FILTRO := ''
INX    := ""
FILORD(.T.)
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
if valtype(INX) = "N"
   dbsetorder(INX)
ELSE
   ordDestroy("temp")
   ordcreate(,"temp",inx)
   ordSetFocus("temp")
ENDIF
set filter to &FILTRO

cSELE2 := ALIAS()


IF !NETUSE("SINDICAT")
   DBCLOSEALL()
   RETU
ENDIF

IF !NETUSE("FUNCAO")
   DBCLOSEALL()
   RETU
ENDIF

IMPRESSORA()
DBSELECTAR("SINDICAT")
DBGOTOP()
WHILE !EOF()
   mCODIGO   := CODIGO
   mNOME     := NOME
   mCGC      := CGC
   mTELEFONE := TELEFONE
   mENDERECO := ENDERECO
   mBAIRRO   := BAIRRO
   mESTADO   := ESTADO
   mCIDADE   := CIDADE
   mCEP      := CEP
   FL        := TOTFOL := TOTREC := CONT := 0
   CTLIN     := 80
   FINAL     := .F.
   FOHHH()
   DBSELECTAR("SINDICAT")
   DBSKIP()
ENDDO
DBCLOSEALL()
VIDEO()
IMPEND()
mTEMP := tmpfile(cRDDEXT)
RETU

// !*****************************************************************************
// !
// !         Fun‡„o: FOHHH()
// !
// !    Chamado por: FOHH.PRG
// !
// !          Chama: VALCTA()           (fun‡„o    em FOLPROC.PRG)
// !               : FOHHROD()          (fun‡„o    em FOHH.PRG)
// !               : SALHM()            (fun‡„o    em FOLPROC.PRG)
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOHHH()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC FOHHH

DBSELECTAR(cSELE2)
DBGOTOP()
WHILE !EOF()
   CTR := NUMERO
   IF SINDICATO = mCODIGO
      DBSELECTAR(cSELE1)
      VALF := VALCTA(CTR,CTA)
      IF VALF # 0
         IF CTLIN > 50
            IF CTLIN # 80
               FOHHROD()
            ENDIF
            DBSELECTAR("SINDICAT")
            FL ++
            @ PROW(), 0 SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))                                                                                                               
            @  1,0      SAY REPL("-",132)                                                                                                                                               
            @  2,1      SAY "Dados do Sindicato:"+SPAC(28)+"| Dados Da Empresa:"+SPAC(30)+"|"                                                                                           
            @  3,48     SAY "|"+SPAC(48)+"|"                                                                                                                                            
            @  3,1      SAY mNOME                                                                                                                                                       
            @  3,50     SAY MSG2                                                                                                                                                        
            @  3,99     SAY IMPSTR(cIMPCOM)+IMPCHR(cIMPTIT)+CGC1+IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))                                                                          
            @  4,1      SAY "Telefone:"+SPAC(7)+"C.G.C."+SPAC(25)+"| Telefone:"+SPAC(7)+"C.G.C."+SPAC(25)+"|"                                                                           
            @  5,48     SAY "|"+SPAC(48)+"|"                                                                                                                                            
            @  5,1      SAY mTELEFONE                                                                                                                                                   
            @  5,17     SAY mCGC                                                                                                                                                        
            @  5,50     SAY zTELEFONE                                                                                                                                                   
            @  5,66     SAY CGC1                                                                                                                                                        
            @  5,99     SAY MSG2                                                                                                                                                        
            @  6,1      SAY ACENTO("Endere‡o:"+SPAC(22)+"Bairro:"+SPAC(9)+"| Endere‡o:"+SPAC(22)+"Bairro:"+SPAC(9)+"|")                                                                 
            @  7,48     SAY "|"+SPAC(48)+"|"                                                                                                                                            
            @  7,1      SAY mENDERECO                                                                                                                                                   
            @  7,32     SAY mBAIRRO                                                                                                                                                     
            @  7,50     SAY ENDER1                                                                                                                                                      
            @  7,81     SAY BAI1                                                                                                                                                        
            @  7,104    SAY IMPSTR(cIMPCOM)+ENDER1+IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))                                                                                        
            @  8,1      SAY "Cidade:"+SPAC(14)+"UF  CEP:"+SPAC(18)+"| Cidade:"+SPAC(14)+"UF  CEP:"+SPAC(18)+"|"                                                                         
            @  8,103    SAY IMPSTR(cIMPCOM)+BAI1                                                                                                                                        
            @  8,121    SAY CEP1+IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))                                                                                                          
            @  9,21     SAY "-"+SPAC(26)+"|"+SPAC(21)+"-"+SPAC(26)+"|"                                                                                                                  
            @  9,1      SAY mCIDADE                                                                                                                                                     
            @  9,22     SAY mESTADO                                                                                                                                                     
            @  9,26     SAY mCEP                                                                                                                                                        
            @  9,50     SAY CID1                                                                                                                                                        
            @  9,71     SAY EST1                                                                                                                                                        
            @  9,75     SAY CEP1                                                                                                                                                        
            @  9,109    SAY IMPSTR(cIMPCOM)+CID1                                                                                                                                        
            @  9,127    SAY "-"+EST1+IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))                                                                                                      
            @ 10,0      SAY REPL("-",132)                                                                                                                                               
            @ 11,1      SAY POS1                                                                                                                                                        
            @ 11,50     SAY ACENTO("- RELA€ŽO DE EMPREGADOS -"+SPAC(11)+"Mˆs"+SPAC(12)+"de"+SPAC(15)+"Folha :")                                                                         
            @ 11,90     SAY MMES                                                                                                                                                        
            @ 11,104    SAY ANO                                                                                                                                      PICT '####'        
            @ 11,126    SAY STR(FL,6)                                                                                                                                                   
            @ 12,0      SAY REPL("-",132)                                                                                                                                               
            @ 13,1      SAY ACENTO("ORD   ADMISSŽO  CTPS/SERIE    NOME"+SPAC(28)+"Cargo Ocupado"+SPAC(6)+"Salario Base"+SPAC(8)+"Tipo"+SPAC(8)+"Valor Contribui‡„o")                    
            @ 14,0      SAY REPL("-",132)                                                                                                                                               
            CTLIN := 15
         ENDIF
         FINAL  := .T.
         TOTREC += VALF
         TOTFOL += VALF
         CONT ++
         DBSELECTAR(cSELE2)
         VAR1 := SALM := SALH := 0
         SALHM()
         @ CTLIN,1   SAY CONT                                                                                                                                                           PICT '####'                            
         @ CTLIN,7   SAY ADMITIDO                                                                                                                                                                                              
         @ CTLIN,17  SAY IF(left(TIRAOUT(CPF),7) = PROFIS,CPF,PROFIS+"-"+SERIE+"/"+CTPSUF) //CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes                                        
         @ CTLIN,31  SAY NOME                                                                                                                                                                                                  
         @ CTLIN,63  SAY OBTER("FUNCAO",,FUNCAO,"NOME")                                                                                                                                                                        
         @ CTLIN,82  SAY VAR1                                                                                                                                                           PICTURE '@E 999,999,999,999.99'        
         @ CTLIN,102 SAY CHECKTAB("TSA2"+TIPO+"    ",,,"Tipo naoCadastrado",2)                                                                                                                                                 
         @ CTLIN,114 SAY VALF                                                                                                                                                           PICTURE '@E 999,999,999,999.99'        
         CTLIN ++
      ENDIF
   ENDIF
   DBSELECTAR(cSELE2)
   DBSKIP()
ENDDO
FOHHROD()
RETU .T.


// !*****************************************************************************
// !
// !         Fun‡„o: FOHHROD()
// !
// !    Chamado por: FOHHH()            (fun‡„o    em FOHH.PRG)
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOHHROD()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC FOHHROD  //RODAPE DA FOLHA

IF FINAL
   @ PROW()+ 1,0 SAY REPL("-",132)                                                                                                     
   @ PROW()+ 1,1 SAY "Total da Folha :"+SPAC(48)+"|  Total Geral :"                                                                    
   @ PROW(),18   SAY TOTFOL                                                                        PICT '@E 999,999,999,999.99'        
   @ PROW(),82   SAY TOTREC                                                                        PICT '@E 999,999,999,999.99'        
   @ PROW()+ 1,0 SAY REPL("-",132)                                                                                                     
   @ PROW()+ 1,1 SAY "Localidade/Data:"+SPAC(17)+",    de"+SPAC(12)+"de"+SPAC(10)+"|  Assinatura:"                                     
   @ PROW(),18   SAY CID1                                                                                                              
   @ PROW(),35   SAY DAY(DXDIA)                                                                                                        
   @ PROW(),42   SAY MMES                                                                                                              
   @ PROW(),56   SAY ANO                                                                           PICT '####'                         
   @ PROW()+ 1,0 SAY REPL("-",132)                                                                                                     
   TOTFOL := 0
   IMPFOL()
ENDIF
RETU .T.
// : FIM: FOHH.PRG

*+ EOF: fohh.prg
*+
