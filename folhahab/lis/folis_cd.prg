*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : folis_cd.prg
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
// :
// : FOLIS_CD.PRG  : Listar 13§ Provis„o Acumulada'
// :      Linguagem: Clipper 5.x
// :        Sistema: FOLHA DE PAGAMENTO - MODULO LISTAS
// :      Copyright (c) 1999,  SOFTEC  S/C Ltda.
// :  Atualizado em: 23/02/99
// :
// :*****************************************************************************

////#INCLUDE "COMANDO.CH"

IF !MDL('Listar 13§ Provis„o Acumulada',0)
   RETU
ENDIF


lANAL := MDG("Deseja Resumo Analitico")
aXCON := PEGRELCTA("PROV13")


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


IF !NETUSE("PROV13")
   DBCLOSEALL()
   RETU .F.
ENDIF


LISTARUE({| X | FOLISCD(X)})



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOLISCD()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNC FOLISCD

PARA COMPARE
TOTALIZA := .F.
aCOM     := {}
aVAL     := {}
CTLIN    := 80
DBSELECTAR(PES)
DBGOTOP()
WHILE !EOF()
   IF &COMPARE
      TOTALIZA := .T.
      IF CTLIN > 55 .AND. lANAL
         FOLISCD01()
      ENDIF
      IF lANAL
         @ CTLIN,0 SAY REPL('-',132)         
         CTLIN ++
         @ CTLIN,0  SAY NUMERO           
         @ CTLIN,6  SAY NOME             
         @ CTLIN,36 SAY ADMITIDO         
         CTLIN ++
      ENDIF
      mNUMERO := NUMERO
      DBSELECTAR("PROV13")
      DBGOTOP()
      DBSEEK(STRZERO(mNUMERO,8))
      WHILE mNUMERO = NUMERO .AND. !EOF()
         IF lANAL
            @ CTLIN,0  SAY MES                                             
            @ CTLIN,3  SAY ANO                                             
            @ CTLIN,8  SAY AVOS                                            
            @ CTLIN,12 SAY SALARIO+SALVAR PICT '@E 999,999,999.99'         
            @ CTLIN,28 SAY VALOR          PICT '@E 9999,999,999.99'        
            @ CTLIN,44 SAY VALENC         PICT '@E 9999,999,999.99'        
            @ CTLIN,60 SAY VALTOT         PICT '@E 9999,999,999.99'        
            @ CTLIN,76 SAY VALPRI         PICT '@E 9999,999,999.99'        
            @ CTLIN,92 SAY VALLIQ         PICT '@E 9999,999,999.99'        
            CTLIN ++
         ENDIF
         //Valores Pagos
         VIDEO()
         nDESCONTA := 0
         cARQUSO   := 'FP'+EMP+STRZERO(MES,2)
         IF !NETUSE(cARQUSO)  //AREDE(cARQUSO,cARQUSO,0)
            DBCLOSEALL()
            RETU .F.
         ENDIF
         FOR W := 1 TO 15
            IF !EMPTY(aXCON[W])
               DBGOTOP()
               DBSEEK(mNUMERO * 10000+aXCON[W])
               IF FOUND()
                  nDESCONTA += VALOR
               ENDIF
            ENDIF
         NEXT W
         DBCLOSEAREA()
         IMPRESSORA()
         DBSELECTAR("PROV13")
         nPOS := ASCAN(aCOM,STRZERO(ANO,4)+STRZERO(MES,2))
         IF nPOS > 0
            aVAL[nPOS ,  1] += VALOR
            aVAL[nPOS ,  2] += VALENC
            aVAL[nPOS ,  3] += VALTOT
            aVAL[nPOS ,  4] += VALPRI
            aVAL[nPOS ,  5] += VALLIQ
            aVAL[nPOS ,  6] += nDESCONTA
         ELSE
            AADD(aCOM,STRZERO(ANO,4)+STRZERO(MES,2))
            AADD(aVAL,{VALOR,VALENC,VALTOT,VALPRI,VALLIQ,nDESCONTA})
         ENDIF
         DBSKIP()
      ENDDO
   ENDIF
   DBSELECTAR(PES)
   DBSKIP()
ENDDO
IF TOTALIZA
   aANT  := {0,0,0,0,0,0}
   CTLIN := 80
   FOR W := 1 TO LEN(aCOM)
      IF CTLIN > 50
         FOLISCD01()
      ENDIF
      @ CTLIN,0   SAY RIGHT(aCOM[W],2)                                  
      @ CTLIN,4   SAY LEFT(aCOM[W],4)                                   
      @ CTLIN,28  SAY aVAL[W,1]        PICT '@E 9999,999,999.99'        
      @ CTLIN,44  SAY aVAL[W,2]        PICT '@E 9999,999,999.99'        
      @ CTLIN,60  SAY aVAL[W,3]        PICT '@E 9999,999,999.99'        
      @ CTLIN,76  SAY aVAL[W,4]        PICT '@E 9999,999,999.99'        
      @ CTLIN,92  SAY aVAL[W,5]        PICT '@E 9999,999,999.99'        
      @ CTLIN,108 SAY aVAL[W,6]        PICT '@E 9999,999,999.99'        
      CTLIN ++
      IF W # 1
         @ CTLIN,0  SAY "Diferen‡a"                                          
         @ CTLIN,28 SAY aVAL[W,1] - aANT[1] PICT '@E 9999,999,999.99'        
         @ CTLIN,44 SAY aVAL[W,2] - aANT[2] PICT '@E 9999,999,999.99'        
         @ CTLIN,60 SAY aVAL[W,3] - aANT[3] PICT '@E 9999,999,999.99'        
         @ CTLIN,76 SAY aVAL[W,4] - aANT[4] PICT '@E 9999,999,999.99'        
         @ CTLIN,92 SAY aVAL[W,5] - aANT[5] PICT '@E 9999,999,999.99'        
         CTLIN ++
      ENDIF
      aANT[ 1 ] := aVAL[W,1]
      aANT[ 2 ] := aVAL[W,2]
      aANT[ 3 ] := aVAL[W,3]
      aANT[ 4 ] := aVAL[W,4]
      aANT[ 5 ] := aVAL[W,5]
   NEXT W
   CTLIN ++
   IMPFOL()
ENDIF
RETU



*+--------------------------------------------------------------------
*+
*+
*+
*+    Function FOLISCD01()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
FUNCtion FOLISCD01

FL ++
@  1,1   SAY IF(IM1 = 'A',IMPSTR(cIMPCOM),IMPSTR(cIMPEXP))                                 
@  2,20  SAY IMPCHR(cIMPTIT)+MSG2                                                          
@  3,90  SAY TIME()                                                                        
@  3,100 SAY 'DATA '+DTOC(DXDIA)                                                           
@  3,120 SAY 'FL. '+STRZERO(FL,4)                                                          
@  4,00  SAY IMPCHR(cIMPTIT)+ACENTO('PROVISAO DE 13o Salario: '+ALLTRIM(NOMSETOR))         
@  5,0   SAY "MES"                                                                         
@  5,3   SAY "ANO"                                                                         
@  5,9   SAY "AVOS"                                                                        
@  5,16  SAY "SAL.SALV."                                                                   
@  5,34  SAY "VALOR"                                                                       
@  5,48  SAY "Encargos"                                                                    
@  5,64  SAY "Total"                                                                       
@  5,80  SAY "Primeira"                                                                    
@  5,96  SAY "Liquido"                                                                     
@  5,112 SAY "Pago"                                                                        
@  6,0   SAY REPL('-',132)                                                                 
CTLIN := 7
RETU .T.

// : FIM: FOLIS_CD.PRG

*+ EOF: folis_cd.prg
*+
