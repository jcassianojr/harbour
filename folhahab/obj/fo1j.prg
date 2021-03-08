*:*****************************************************************************
*:
*:       FO1J.PRG: Eliminar Folha de Diretores
*:      Linguagem: Clipper 5.x
*:        Sistema: FOLHA DE PAGAMENTO
*:          Autor: Equipe Disk
*:      Copyright (c) 1994,  SOFTEC  S/C Ltda.
*:  Atualizado em: 04/25/94     11:08
*:
*:  Procs & Fncts: FO1J()
*:
*:          Chama: CABEX()            (fun‡„o    em FOLPROC.PRG)
*:
*:     Documentado 05/13/94 em 14:54                DISK!  vers„o 5.01
*:*****************************************************************************


CABEX("Eliminar Folha de Diretores")
IF ! MDG('Vocˆ tem certeza')
   RETU
ENDIF
IF ! MDG('Vocˆ realmente tem certeza')
   RETU
ENDIF
APA:=ARRAY(19)
APA[1]="FO_DIR"
APA[2]="FO_DAR"
APA[3]="FO_RDD"
APA[4]="SO"+EMP+"01"
APA[5]="SO"+EMP+"02"
APA[6]="SO"+EMP+"03"
APA[7]="SO"+EMP+"04"
APA[8]="SO"+EMP+"05"
APA[9]="SO"+EMP+"06"
APA[10]="SO"+EMP+"07"
APA[11]="SO"+EMP+"08"
APA[12]="SO"+EMP+"09"
APA[13]="SO"+EMP+"10"
APA[14]="SO"+EMP+"11"
APA[15]="SO"+EMP+"12"
APA[16]="SO"+EMP+"00"
APA[17]="FO_SO13"
APA[18]="AJUDIRF"
APA[19]="FO_IRD"
FOR X= 1 TO 19
   APAGAR=ZDIRE+APA[X]+".DBF"
   IF file(APAGAR)
      MDS('Deletando '+APAGAR)
      FERASE(APAGAR)
   ENDIF
NEXT X
RETU
*: FIM: FO1J.PRG
