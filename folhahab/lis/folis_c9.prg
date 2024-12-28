*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : folis_c9.prg
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
// :   FOLIS_C9.PRG: Listar Rais
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************

////#INCLUDE "COMANDO.CH"

IF !MDL('Listar RAIS',0)
   RETU
ENDIF

MESTADO  := ""
MCIDADE  := ""
MNESTADO := ""
MNCIDADE := ""
MPAIS    := ""


MDS('Carregando dados da firma')
IF !netuse("firma")
   RETU
ENDIF
DBGOTOP()
DBSEEK(NREMP)
IF FOUND()
   ENDERR  := ENDERECO
   BAIRRR  := BAIRRO
   CIDADR  := CIDADE
   ESTADR  := ESTADO
   CPR     := CEP
   NRCGCR  := CGC
   ATI     := ATIVIDADE
   NAT     := NAT_ESTAB
   SOC     := NR_SOCIOS
   FAMIL   := NR_FAMILIA
   SCGC    := CGCANT
   XENDERE := ALTEND
ENDIF
DBCLOSEALL()




ANOBAS := YEAR(DXDIA)
MDS("Confirme o Ano Base")
@ 24,40 GET ANOBAS PICT '####'        
READCUR()




XLF := 0

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

IF !NETUSE("FORAIS")
   DBCLOSEALL()
   RETU .F.
ENDIF

dbselectar(pes)
DBGOTOP()
WHILE !EOF()
   XLF ++
   DBSKIP()
ENDDO
XLF1 := INT(XLF / 5)
IF INT(XLF / 5) # XLF / 5
   XLF1 ++
ENDIF
XLF2 := STRZERO(XLF1,4)


FL     := 1
PAGINA := 0

SALTO := 3
SET PRIN ON
?? CHR(27)+'C'+CHR(51)
SET PRIN OFF
SET DEVI TO PRINT
DBSELECTAR(PES)
DBGOTOP()
CABRAIS()
SALTO := 8
WHILE !EOF()
   ALLTRUE(CHECKCID(,,.F.,IBGE,{{"UF","mESTADO"},{"NOME","mCIDADE"}}))
   ALLTRUE(CheckBacen(NASCPAIS,mPAIS,.F.,{{"STRZERO(BACEN,4)","NACPAIS"},{"NOME","mPAIS"}}))
   IF PAGINA = 5
      PAGINA := 0
      FL ++
      CABRAIS()
   ENDIF
   PAGINA ++
   mNUMERO := NUMERO
   dbselectar("forais")
   dbgotop()
   IF dbseek(str(nanouso,4)+str(mNUMERO,8))
      netrecapp()
      field->numero := mNUMERO
      field->ano    := anouso
   endif
   dbselectar(pes)
   @ PROW()+ 3,7 SAY PIS                                                                                                                                                                                                                                        
   @ PROW(),20   SAY NOME                                                                                                                                                                                                                                       
   @ PROW(),62   SAY AVOSM                                                                                                                                                                                                                                      
   @ PROW(),65   SAY RAIZJAN                                                                                                                                                                                                       PICT '@E ####,###.##'        
   @ PROW(),78   SAY RAIZFEV                                                                                                                                                                                                       PICT '@E ####,###.##'        
   @ PROW(),91   SAY RAIZMAR                                                                                                                                                                                                       PICT '@E ####,###.##'        
   @ PROW(),104  SAY RAIZABR                                                                                                                                                                                                       PICT '@E ####,###.##'        
   @ PROW()+ 2,5 SAY IF(left(TIRAOUT(CPF),7) = PROFIS,LEFT(TIRAOUT(CPF),7)+"/"+SUBSTR(TIRAOUT(CPF),8),PROFIS+"-"+SERIE+"/"+CTPSUF) //CTPS digital com os primeiros 7 dígitos do CPF e o campo Série, com os 4 dígitos restantes                              
   @ PROW(),20   SAY NASC                                                                                                                                                                                                                                       
   @ PROW(),31   SAY ADMITIDO                                                                                                                                                                                                                                   
   @ PROW(),41   SAY '1'                                                                                                                                                                                                                                        
   @ PROW(),44   SAY STRZERO(MONTH(ADMITIDO),2)+'/'+RIGHT(STR(YEAR(ADMITIDO),4),2)                                                                                                                                                                              
   @ PROW(),48   SAY SAL13_1                                                                                                                                                                                                       PICT '@E ####,###.##'        
   @ PROW(),62   SAY MES_1                                                                                                                                                                                                                                      
   @ PROW(),65   SAY RAIZMAI                                                                                                                                                                                                       PICT '@E ####,###.##'        
   @ PROW(),78   SAY RAIZJUN                                                                                                                                                                                                       PICT '@E ####,###.##'        
   @ PROW(),91   SAY RAIZJUL                                                                                                                                                                                                       PICT '@E ####,###.##'        
   @ PROW(),104  SAY RAIZAGO                                                                                                                                                                                                       PICT '@E ####,###.##'        
   @ PROW()+ 2,5 SAY OBTER("FUNCAO",,FOPES->FUNCAO,"CBONEW") //CBONEW                                                                                                                                                                                           
   @ PROW(),11   SAY FORAIS->RAISVINC                                                                                                                                                                                                                           
   @ PROW(),13   SAY FORAIS->RAISSITU                                                                                                                                                                                                                           
   @ PROW(),15   SAY ESCRAIS                                                                                                                                                                                                                                    
   @ PROW(),17   SAY NASCPAIS                                                                                                                                                                                                                                   
   IF NACPAIS <> "1058"
      @ PROW(),21 SAY STR(ANONASCI)+' '+mPAIS         
   ENDIF
   IF EMPTY(DEMITIDO)
      @ PROW(),20 SAY SALDEZ PICT '@E ###########.##'        
   ELSE
      MESDEM := MONTH(DEMITIDO)
      XSAL   := 'SAL'+SUBSTR(MMES(MESDEM),1,3)
      XSAL   := &XSAL.
      @ PROW(),20 SAY XSAL                                           PICT '@E ###########.##'        
      @ PROW(),41 SAY STRZERO(DAY(DEMITIDO),2)+'/'+STRZERO(MESDEM,2)                                 
      @ PROW(),47 SAY MOTIVO                                                                         
   ENDIF
   @ PROW(),35  SAY TIPO                                 
   @ PROW(),37  SAY HRSEM   PICT '##'                    
   @ PROW(),48  SAY SAL13_2 PICT '@E ####,###.##'        
   @ PROW(),62  SAY MES_2                                
   @ PROW(),65  SAY RAIZSET PICT '@E ####,###.##'        
   @ PROW(),78  SAY RAIZOUT PICT '@E ####,###.##'        
   @ PROW(),91  SAY RAIZNOV PICT '@E ####,###.##'        
   @ PROW(),104 SAY RAIZDEZ PICT '@E ####,###.##'        
   DBSKIP()
ENDDO
IMPFOL()
VIDEO()
SET PRINT ON
?? CHR(27)+'C'+CHR(66)
SET PRINT OFF
DBCLOSEALL()
IMPEND()
RETU

// !*****************************************************************************
// !
// !       CABRAIS
// !
// !    Chamado por: FOLIS_C9.PRG
// !
// !*****************************************************************************

*+--------------------------------------------------------------------
*+
*+
*+
*+    Function CABRAIS()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
function CABRAIS

@ PROW()+SALTO,5 SAY MSG2                                      
@ PROW()+ 2,7    SAY ENDERR                                    
@ PROW()+ 1,103  SAY STRZERO(FL,4)+'/'+XLF2                    
@ PROW(),114     SAY ANOBAS                 PICT '####'        
@ PROW()+ 1,7    SAY BAIRRR                                    
@ PROW()+ 2,7    SAY CPR                                       
@ PROW(),19      SAY CIDADR                                    
@ PROW(),55      SAY ESTADR                                    
IF SCGC <> SPAC(18)
   @ PROW(),103 SAY 'X'         
ENDIF
IF XENDERE <> ' '
   @ PROW(),111 SAY 'X'         
ENDIF
@ PROW()+ 2,61 SAY CGC                    
@ PROW(),84    SAY ATI                    
@ PROW(),90    SAY NAT                    
@ PROW(),93    SAY SOC   PICT '##'        
@ PROW(),96    SAY FAMIL PICT '##'        
@ PROW(),101   SAY SCGC                   
RETU

// : FIM: FOLIS_C9.PRG

*+ EOF: folis_c9.prg
*+
