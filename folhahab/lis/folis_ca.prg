*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : folis_ca.prg
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
*+    Documentado em 27-Dez-2024 as  9:26 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// :*****************************************************************************
// :
// : FOLIS_CA.PRG  : Listar Resumo Rais Empresa
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************

////#INCLUDE "COMANDO.CH"
IF !MDL('Listar RAIS Resumo Empresa',0)
   RETU
ENDIF
CTLIN := 80

if !NETUSE(arquso)
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


IMPRESSORA()
DBGOTOP()
WHILE !EOF()
   IF CTLIN > 55
      CTLIN := 1
      @ CTLIN,1 say "- E S T A B E L E C I M E N T O "+Replicate("-",47)         
   ENDIF
   CTLIN += 2
   @ CTLIN,3 say "Inscricao    : "+CGC         
   CTLIN ++
   @ CTLIN,3 say "Razao Social : "+RAZAO         
   CTLIN ++
   @ CTLIN,3 say "Endereco     : "+ENDERECO         
   CTLIN ++
   @ CTLIN,3  say "Bairro       : "+BAIRRO          
   @ CTLIN,53 say "Cod Municipio: "+CODIBGE         
   CTLIN ++
   @ CTLIN,3  say "Municipio    : "+CIDADE            
   @ CTLIN,53 say "CEP: "+CEP+"  UF: "+ESTADO         
   CTLIN ++
   @ CTLIN,3  say "Ativ. Econom.: "+ATIVIDADE                   
   @ CTLIN,25 say "Nat. Estabelecimento  : "+NAT_ESTAB          
   @ CTLIN,53 say "Nro. Proprietarios: "+STR(NR_SOCIOS)         
   CTLIN ++
   @ CTLIN,3  say "Alt. CGC/CEI : "+ALTINS                
   @ CTLIN,25 say "Causa: "+TIPINS                        
   @ CTLIN,35 say "Alt.Endereco:  "+ALTEND                
   @ CTLIN,53 say "Ind. Rais Negativa:  "+RAISNEG         
   CTLIN ++
   @ CTLIN,3  say "Inscr. Ant.  : "+CGCANT            
   @ CTLIN,53 say "Data Base "+STRZERO(DBASE)         
   CTLIN ++
   @ CTLIN,00 SAY REPL("-",80)         
   CTLIN ++
   DBSKIP()
ENDDO
DBCLOSEALL()
IMPFOL()
VIDEO()
IMPEND()
RETU .T.

*+ EOF: folis_ca.prg
*+
