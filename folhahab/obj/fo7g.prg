*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fo7g.prg
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
*+    Documentado em 27-Dez-2024 as  9:45 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// :       FO7G.PRG : Ficha de Salario Familia
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO
// :      Copyright (c) 1997,  SOFTEC  S/C Ltda.
// :  Atualizado em: 22/10/97     11:25
// :
// :*****************************************************************************

////#INCLUDE "COMANDO.CH"

IF !MDG("Voce ja  checou as Baixas")
   RETU .F.
ENDIF
IF !MDL('Ficha Salario Familia',0)
   RETU .F.
ENDIF


if !NETUSE(pes)
   dbcloseall()
   retu
endif
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

IF !NETUSE("FOSFAM")
   DBCLOSEALL()
   RETU .F.
ENDIF
nLASTREC := LASTREC()
zei_fort(nLASTREC,,,0)
ordDestroy("temp")
ordcreate(,"temp","STR(NUMERO,8)+DTOS(NASCTO)")
ordSetFocus("temp")

IMPRESSORA()
DBSELECTAR(PES)
DBGOTOP()
WHILE !EOF()
   lCAB := .T.
   VIDEO()
   PETELA(8)
   IMPRESSORA()
   mNUMERO   := NUMERO
   mNOME     := NOME
   mCTPS     := IF(left(TIRAOUT(CPF),7) = PROFIS,CPF,PROFIS+"-"+SERIE+"/"+CTPSUF)   //CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes
   nORD      := 1
   mADMITIDO := ADMITIDO
   DBSELECTAR("FOSFAM")
   DBGOTOP()
   DBSEEK(STR(mNUMERO,8))
   WHILE mNUMERO = NUMERO .AND. !EOF()
      IF EMPTY(FOSFAM->BAIXA) .OR. FOSFAM->SALFAM = 'S'
         IF lCAB
            lCAB := .F.
            @  0,0   SAY IF(IM1 = 'A',IMPstr(Cimpcom),impstr(Cimpexp))                                        
            @  0,40  SAY IMPCHR(14)+"FICHA DE SALARIO FAMILIA"                                                
            @  2,0   SAY "Empresa: "+MSG2                                                                     
            @  2,100 SAY "CGC: "+CGC1                                                                         
            @  3,00  SAY "Endereco: "+ENDER1                                                                  
            @  4,00  SAY "Bairro: "+ALLTRIM(BAI1)+" Cidade: "+ALLTRIM(CID1)+" Estado: "+ALLTRIM(EST1)         
            @  5,00  SAY "Nome do Empregado: "+mNOME                                                          
            @  5,90  SAY "No. CTPS: "+mCTPS                                                                   
            @  6,00  SAY "Data de Admissao na Empresa: "+DTOC(mADMITIDO)                                      
            @  6,90  SAY "Data da Cessacao da Relacao de Emprego"                                             
            @  7,20  SAY "FILHOS MENORES DE 14 ANOS - (Dados Extra¡dos das Certidoes)"                        
            @  8,00  SAY REPl("-",200)                                                                        
            @  9,0   SAY "Ord"                                                                                
            @  9,4   SAY "Nome do Filho"                                                                      
            @  9,44  SAY "Nascto"                                                                             
            @  9,53  SAY "Local Nascto"                                                                       
            @  9,89  SAY "Cartorio"                                                                           
            @  9,105 SAY "No.Reg"                                                                             
            @  9,116 SAY "Livro"                                                                              
            @  9,122 SAY "Folha"                                                                              
            @  9,128 SAY "D.Entr."                                                                            
            @  9,137 SAY "D.Baixa"                                                                            
            @  9,146 SAY "Visto Fiscalizacao"                                                                 
         ENDIF
         @ PROW()+ 1,0 SAY nORD         PICT "99"        
         @ PROW(), 3   SAY NOME                          
         @ PROW(),44   SAY NASCTO                        
         @ PROW(),53   SAY LOCAL                         
         @ PROW(),89   SAY CARTORIO                      
         @ PROW(),105  SAY NREGIS                        
         @ PROW(),116  SAY LIVRO                         
         @ PROW(),122  SAY FOLHA                         
         @ PROW(),128  SAY ENTREGA                       
         @ PROW(),137  SAY BAIXA                         
         @ PROW(),146  SAY REPL("_",40)                  
         nORD ++
      ENDIF
      DBSELECTAR("FOSFAM")
      DBSKIP()
   ENDDO
   IF !lCAB   ///se fez cabecario tem rodape
      @ 55,0   SAY "Recebi os Documentos Acima"         
      @ 55,50  SAY "Data da Rescisao"                   
      @ 55,100 SAY REPL("_",50)                         
      @ 56,100 SAY "Assinatura"                         
      IMPFOL()
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
VIDEO()
DBCLOSEALL()
IMPEND()
RETU .T.

*+ EOF: fo7g.prg
*+
