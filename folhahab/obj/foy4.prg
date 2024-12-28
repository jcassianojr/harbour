*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : foy4.prg
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


if MDG('Refaz controles da folha')
   LIMPAR(FOL,FOL)
   dbcloseall()
endif
if MDG('Refazer Folha V.Transp.')
   LIMPAR("VTFOLHA","VTFOLHA")
endif
if MDG('Refazer Folha V.Transp Avulsa')
   LIMPAR("VTAVUL","VTAVUL")
endif
if MDG('Refazer Programa V.Transp ')
   LIMPAR("VTFIXO","VTFIXO")
endif
if MDG('Refaz controles Folha F‚rias')
   LIMPAR("FO_PFE","FO_PFE")
endif
if MDG('Refaz controles Folha Rescis„o')
   LIMPAR("FO_RSS","FO_RSS")
endif
retu
if MDG('Refaz controles Folha 13 Salario')
   LIMPAR(PEG13(1))
   LIMPAR(PEG13(2))
   LIMPAR(PEG13(3))
   LIMPAR(PEG13(4))
endif
return


*+--------------------------------------------------------------------
*+
*+
*+
*+    Function limpar()
*+
*+
*+
*+--------------------------------------------------------------------
*+
*+
*+
func limpar(cARQ,cIND)


if valtype(cIND) # "C"
   cIND := cARQ
endif
if !netuse(pes)
   retu .f.
endif
if !netuse(carq)
   dbcloseall()
   retu .f.
endif
dbselectar(cARQ)
nLASTREC := LASTREC()
MDS("Ajustando Codigos de Trabalho")
zei_fort(nLASTREC,,,0)
DBEval({|| netgrvcam("CONTROLE",(NUMERO * 10000)+CONTA)},,{|| zei_fort(nLASTREC,,,1)})

//arqui nao funciona dbeval pos a comparacao e apos skip duplicidades
MDS("Checando Codigos de Trabalho")
dbgotop()
while !eof()
   ctr := controle
   dbskip()
   if controle = ctr
      netrecdel()
   endif
enddo

MDS("Excluindo funcionarios 0")
zei_fort(nLASTREC,,,0)
DBEval({|| netrecDel()},{|| NUMERO = 0},{|| zei_fort(nLASTREC,,,1)})
MDS("Excluindo Contas=0")
zei_fort(nLASTREC,,,0)
DBEval({|| netrecdel()},{|| CONTA = 0},{|| zei_fort(nLASTREC,,,1)})
MDS("Excluindo Lancamentos com valor e horas zerados")
zei_fort(nLASTREC,,,0)
DBEval({|| netrecdel()},{|| HORAS = 0 .AND. VALOR = 0},{|| zei_fort(nLASTREC,,,1)})

MDS("Checando Consistencia Dados")
dbselectar(cARQ)
dbgotop()
while !eof()
   mNUMERO := NUMERO
   dbselectar(PES)
   dbgotop()
   lACHEI := dbseek(mNUMERO)
   dbselectar(cARQ)
   while mNUMERO = NUMERO .and. !eof()
      if !lACHEI
         netrecdel()
      endif
      dbskip()
   enddo
   @ 24,00 say CONTROLE         
enddo
dbselectar(cARQ)
dbcloseall()
MDS("Fixando o Arquivo")
netpack(Carq)
retu .T.


*+ EOF: foy4.prg
*+
