*:*****************************************************************************
*:
*:
*:   RECUGER3.PRG: Editor de Arquivos dbf
*:      Linguagem: Clipper 5.x
*:        Sistema: RECURSOS
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/28/94     11:29
*:
*:  Procs & Fncts: RECUGER3()
*:               : FUNCDISP()
*:               : LISTAGEM()
*:               : DIM2()
*:               : TOPOPAG()
*:
*:          Chama: CABE2()            (fun‡„o    em RECUPROC.PRG)
*:               : FUNCDISP()         (fun‡„o    em RECUGER3.PRG, chamado  no Achoice())
*:               : LISTAGEM()         (fun‡„o    em RECUGER3.PRG)
*:
*:
*:     Documentado 05/13/94 em 15:46                DISK!  vers„o 5.01
*:*****************************************************************************


cabe2('Editor de Arquivos dbf')
@ 08,00 CLEAR
PARAMETERS tamanho,grupo
PUBLIC TAMPRINT
TAMPRINT=VAL(TAMANHO)
DO WHILE .T.
   @ 08,00 CLEAR
   ARQUIVO=grupo
   DECLARE dbf_arq[adir(ARQUIVO)],cabec[4]
   cabec[1] = "NOME"
   cabec[2] = "TIPO"
   cabec[3] = "TAM"
   CABEC[4] = "DEC"
   PUBLIC N_CAMP
   N_CAMP=0
   @ 08,2 TO 21,11 DOUB
   @ 08,5 SAY "DBFs"
   @ 08,35 TO 21,66 DOUB

   DBF_ARQ:=FILENAMES("*.DBF")
   DO WHILE .T.
      OPCAO=ACHOICE(9,3,20,10,DBF_ARQ)
      IF OPCAO=0
         EXIT
      ENDIF
      ARQUIVO=DBF_ARQ[OPCAO]
      IF ! NETUSE(ARQUSO,,,,,.F.,) //BREDE(ARQUIVO,0)
         RETU
      ENDIF
      qtcampos=FCOUNT()
      PUBLIC no_camp[qtcampos]
      DECLARE v1[qtcampos],v2[qtcampos],v3[qtcampos],v4[qtcampos]
      DECLARE VP[QTCAMPOS] && Matriz auxiliar, pois v1 sera clareada quando selecionada
      AFIELDS(v1,v2,v3,v4)
      AFIELDS(VP)

      cho=0
      PUBLIC FL,ELEMENTO,POSICAO
      ELEMENTO=1
      POSICAO=0

      FILTRO=SPAC(50)
      MD()
      @ 23,03 SAY 'FILTRAR POR : ' GET FILTRO
      READCUR()
      
      FILTRO=ALLTRIM(FILTRO)
      INX    := ""
      FILORD(.T.)
      nLASTREC:=LASTREC()
      zei_fort( nLASTREC,,,0)
      if valtype(INX)="N"
         dbsetorder(INX)
      ELSE
         ordDestroy("temp")
         ordcreate(,"temp",inx)
         ordSetFocus("temp")
      ENDIF   
      set filter to &FILTRO 
      
 
      MDS('Escolha os dados para a listagem')
      DO WHILE .T.
         FL=.T.
         cho = ACHOICE(9,36,20,65,v1,.T.,"funcdisp",ELEMENTO,POSICAO)
         IF FL=.T.
            EXIT
         ENDIF

         V1[ELEMENTO]=SPAC(LEN(V1[ELEMENTO]))
      ENDDO
   ENDDO
   @ 08,00 CLEA

   IF N_CAMP<>0
      DECLARE matriz_N[N_CAMP]
      DECLARE matriz_T[N_CAMP]
      DECLARE matriz_D[N_CAMP]
      DECLARE matriz_l[N_CAMP]

      DECLARE CABECAMPO[N_CAMP]
      FOR Y=1 TO N_CAMP
         matriz_N[Y]=vp[no_camp[y]]
         matriz_T[Y]=v2[no_camp[y]]
         matriz_l[Y]=v3[no_camp[y]]
         Matriz_D[Y]=v4[no_camp[y]]
         CABECAMPO[Y]=v1[no_camp[y]]
      NEXT
      @ 08,00 CLEA
      CB1=SPAC(tamprint)
      CB2=SPAC(tamprint)
      CB3=SPAC(tamprint)
      CB4=SPAC(tamprint)
      @ 08,2 SAY "ENTRE COM O CABECALHO"
      @ 09,2 GET CB1 PICT "@S70"
      @ 10,2 GET CB2 PICT "@S70"
      @ 11,2 GET CB3 PICT "@S70"
      @ 12,2 GET CB4 PICT "@S70"
      READCUR()
      CABEC=""
      CABEC1=CB1
      CABEC2=CB2
      CABEC3=CB3
      CABEC4=CB4

      cabec=cabec+(cabec1+SPAC(tamprint-LEN(cabec1)))   && centraliza os cabecalhos
      cabec=cabec+(cabec2+SPAC(tamprint-LEN(cabec2)))   && em tamprint colunas
      cabec=cabec+(cabec3+SPAC(tamprint-LEN(cabec3)))
      cabec=cabec+(cabec4+SPAC(tamprint-LEN(cabec4)))

      IF CHECKiMP(0)
        SET DEVI TO PRIN
        listagem(CABEC,MATRIZ_N,MATRIZ_T,MATRIZ_L,MATRIZ_D,CABECAMPO,TAMPRINT)
        IMPFOL()
        SET DEVI TO SCRE
        IMPEND()
      ENDIF
   ENDIF
   IF ! MDG('DESEJA CONTINUAR (S/N)')
      RETU
   ENDIF
ENDDO




*!*****************************************************************************
*!
*!         Fun‡„o: FUNCDISP()
*!
*!    Chamado por: RECUGER3.PRG
*!
*!*****************************************************************************
FUNC funcdisp
PARAMETERS modo,elem,posi
IF LASTKEY()=27
   RETU(0)
ELSEIF LASTKEY()=13

   n_camp=n_camp+1
   no_camp[n_camp]=elem
   fl=.F.
   ELEMENTO=ELEM

   RETU(0)
ENDIF
RETU(2)



*****************************************************************************
*  Nome da Funcao : Listagem
*  Parametros passados : Cabecalho da listagem, Nome dos campos, Tipo dos
*                        campos, Tamanho dos campos, Cabecalho dos campos
*  Obs : O primeiro e o ultimo parametro sao (M)emos, e o restante sao (A)rrays
*
*
*****************************************************************************
*!*****************************************************************************
*!
*!         Fun‡„o: LISTAGEM()
*!
*!    Chamado por: RECUGER3.PRG
*!
*!          Chama: DIM2()             (fun‡„o    em RECUGER3.PRG)
*!               : TOPOPAG()          (fun‡„o    em RECUGER3.PRG)
*!
*!*****************************************************************************
FUNC listagem
PARAMETERS cabecalho,CAMPOS_N,CAMPOS_T,CAMPOS_L,CAMPOS_D,cabecamp

nc=LEN(CAMPOS_N)   && numero de elementos da matriz

DECLARE ESPCAMPO[NC*2],ESPCAB[NC*2]   && declara matrizes Bidimendionais,
&& (funcao anexa.)
tamformul=0   && variavel para medir tamanho dos campos

FOR J= 1 TO NC
   IF LEN(CABECAMP[J]) > CAMPOS_L[J] && Se cabec. do campo maior que campo...

      diferenca=(LEN(CABECAMP[J] ) - CAMPOS_L[J] )/2

      ESPCAMPO[DIM2(J,1)] = SPAC( diferenca+1 )
      ESPCAMPO[DIM2(J,2)] = SPAC( diferenca+1 )

      ESPCAB[DIM2(J,1)]   = SPAC(1)
      ESPCAB[DIM2(J,2)]   = SPAC(1)

   ELSE

      diferenca=( CAMPOS_L[J] - LEN(CABECAMP[J] )  )/2

      ESPCAMPO[DIM2(J,1)] = SPAC(1)
      ESPCAMPO[DIM2(J,2)] = SPAC(1)
      ESPCAB[DIM2(J,1)]   = SPAC( diferenca+1  )
      ESPCAB[DIM2(J,2)]   = SPAC( diferenca+1  )

   ENDIF
   tamformul=tamformul+IIF(campos_l[j]>LEN(cabecamp[j]),campos_l[j],LEN(cabecamp[j]))


NEXT

IF tamformul>tamprint   && Se nao couber na pagina, aborte...
   TONE(500,2)
   RETU .F.
ENDIF

FOR J= 1 TO NC
   ESPCAMPO[DIM2(J,1)] =  ESPCAMPO[DIM2(J,1)] + SPAC(((tamprint-tamformul)/nc)/2)
   ESPCAMPO[DIM2(J,2)] =  ESPCAMPO[DIM2(J,2)] + SPAC(((tamprint-tamformul)/nc)/2)
   ESPCAB[DIM2(J,1)]   =  ESPCAB[DIM2(J,1)]   +  SPAC(((tamprint-tamformul)/nc)/2)
   ESPCAB[DIM2(J,2)]   =  ESPCAB[DIM2(J,2)]   +  SPAC(((tamprint-tamformul)/nc)/2)
NEXT


***********************  Extrai e centraliza o cabecalho linha a linha *******
nlcab=MLCOUNT(cabecalho)
DECLARE imprime[nlcab]
FOR X=1 TO nlcab
   imprime[x]=ALLTRIM(MEMOLINE(cabecalho,tamprint,X))
NEXT
FOR X=1 TO nlcab
   IF X=1
      imprime[x] = SPAC( (100 - LEN(imprime[x]) ) /2 ) +;
         imprime[x] + SPAC ( ( tamprint - LEN( imprime[x] ) )/2)
   ELSE
      imprime[x] = SPAC( ( tamprint - LEN(imprime[x]) ) /2 ) + imprime[x] +;
         SPAC( ( tamprint - LEN( imprime[x] ) )/2)
   ENDIF

NEXT X

******************** Rotina de impressao do conteudo dos campos *****
CP=1
TOPOPAG(NLCAB,IMPRIME,CP) && cabecalho do formulario
DBGOTOP()
DO WHILE .NOT. EOF()
   FOR X=1 TO NC
      v=CAMPOS_N[x]    && extrai o conteudo do campo na matriz
      conteudo= &v.    && ------------------------------------
      @ PROW(),PCOL() SAY ESPCAMPO[DIM2(x,1)]   && Espacador inicial
      @ PROW(),PCOL() SAY ACENTO(IIF(CAMPOS_T[X]="N",STR(conteudo,CAMPOS_L[X],CAMPOS_D[X]),CONTEUDO)) && campo a ser
      @ PROW(),PCOL() SAY ESPCAMPO[DIM2(x,2)]   && Espacador final                                    impresso
   NEXT
   @ PROW()+1,0 SAY ""
   IF PROW()>=50  && Se a linhas for maior ou igual a 50, pula pagina...
      IMPFOL()
      CP=CP+1
      TOPOPAG(NLCAB,IMPRIME,CP)
   ENDIF
   DBSKIP()
ENDDO
RETU .T.


*!*****************************************************************************
*!
*!         Fun‡„o: DIM2()
*!
*!    Chamado por: LISTAGEM()         (fun‡„o    em RECUGER3.PRG)
*!               : TOPOPAG()          (fun‡„o    em RECUGER3.PRG)
*!
*!*****************************************************************************
FUNC DIM2   && Gerencia uma matriz como se ela fosse Bidimensional...
PARAMETERS X,Y
RETU(((X-1)*2)+Y)

*!*****************************************************************************
*!
*!         Fun‡„o: TOPOPAG()
*!
*!    Chamado por: LISTAGEM()         (fun‡„o    em RECUGER3.PRG)
*!
*!          Chama: DIM2()             (fun‡„o    em RECUGER3.PRG)
*!
*!*****************************************************************************
FUNC TOPOPAG                                   && IMPRIME O CABECALHO DA PAGINA
PARA LINH,MATR,CPG
@ PROW()+1,0 SAY SPAC(TAMPRINT-15)+"Pagina  "+STRZERO(CPG,3)
FOR X=1 TO LINH                             && Extrai o cabecalho do formulario
   @ PROW()+1,0 SAY ACENTO(MATR[X])        && --------------------------------
NEXT X
@ PROW()+2,0 SAY ""
FOR X=1 TO NC                                           && cabecalho dos campos
   @ PROW(),PCOL() SAY espcab[dim2(x,1)] + CABECAMP[X] + espcab[dim2(x,2)]
NEXT
@ PROW()+1,0 SAY ""
RETU(.T.)
*: FIM: RECUGER3.PRG

