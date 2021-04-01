#include "dbinfo.ch"
*****************************************************************
FUNCTION ISMEMO (cARQ,lMES,lINFO)
*****************************************************************
LOCAL cMES,lRETU,i
IF vALTYPE(lMES)#"L"
   lMES:=.F.
ENDIF
IF vALTYPE(lINFO)#"L"
   lINFO:=.T.
ENDIF

lRETU:=.F.
cMES:="Parece Nao Ser DBF"
if NETUSE(cARQ,,,,,.F.,)
   //FUNCTION ShortTableHasMemoField()Return Ascan( dbStruct(), {|x| x[ 2] == 'M'}) != 0
   if Ascan( dbStruct(), {|x| x[ 2] == 'M'}) != 0
      lRETU:=.T.
   endif   
   //for i:=1 to FCount()
//       if FieldType( i ) == "M"
//           lRETU:=.T.
//           exit
//       endif
//   NEXT
   dbclosearea()
ELSE
   cMES:="Nao foi possivel abrir: "
endif
IF lINFO
   Infotipodbf(cARQ,lMES)
else
   if Lmes
      ALERTX(cMES+": "+cARQ)
   endif
endif
return lRETU


*****************************************************************
FUNCTION INFOTIPODBF(filename,lMES)
*****************************************************************
LOCAL buffer := ' ', handle , ret_value,cMES

IF AT(".", filename) = 0
   filename = TRIM(filename) + ".DBF"
ENDIF
IF vALTYPE(lMES)#"L"
   lMES:=.F.
ENDIF

//
//Retorna -1 Se Nao For DBF
//
ret_value:=-1
cMES:="Parece Nao Ser DBF"

handle = hb_FOPEN(filename , 0)


* Se nao ocorrer erro na abertura, carrega o primeiro byte.
IF FERROR() = 0 .AND. FREAD(handle, @buffer, 1) = 1

    /*
    O primeiro byte de um arquivo do dBASE III e' 131 se os campos de
     memo estiverem definidos. Do contrario, e' 03. Se nao for 131 nem
     03, o arquivo nao e' uma base de dados do dBASE III. Nesse caso,
     retorna -1, que e' o valor de retorno predefinido.
     Verifica a existencia do codigo do memo no buffer.
	03h(03) dBASE III w/o memo file    //Usado
	04h(04)dBASE IV or IV w/o memo file
	05h(05)dBASE V w/o memo file
	83h(131) dBASE III+ with memo file //Usado
	F5h(245) FoxPro w. memo file //usado
	8Bh(139) dBASE IV w. memo //usado
	8Eh(142) dBASE IV w. SQL table
	30h(48) Visual FoxPro w. DBC
	7Bh(123) dBASE IV with memo
    */


    do case
        case buffer = CHR(142) // 8Eh DBF
             cMES="dBASE IV  SQL table"
             ret_value = 8
        case buffer = CHR(48) // 30h DBF
             cMES="Visual FoxPro DBC"
             ret_value = 7
        case buffer = CHR(123) // 7Bh DBF
             cMES="dBASE IV com memo"
             ret_value = 6
       case buffer = CHR(05) //05h DBF
            cMES="dbase V  Sem memo"
            ret_value = 5
       case buffer = CHR(04) //04h DBF
            cMES="dbase IV  Sem memo"
            ret_value = 4
       case buffer = CHR(139) //8Bh DBF/MDX DBFMDX (DBT-MEMO)
            cMES="dbase IV  com memo"
            ret_value = 3
       case buffer = CHR(245) //F5h DBF/CDX-IDX DBFCDX ADSCDX (FPT-MEMO)
            cMES="Foxpro  com memo"
            ret_value = 2
       case buffer = CHR(131) //83h DBF/NTX        DBFNTX ADSNTX COMIX (DBT-MEMO)
            cMES="dBASE III com memo"
           * Tambem pode ser comix  DBF/NTX       COMIX (DBT-MEMO)
          ret_value = 1
       case buffer = CHR(03) //03H DBF/NTX/CDX FORTESS DBFNTX DBFCDX DBFMDX COMIX ADSCDX ADSNTX
            cMES="dBASE III sem memo"
            ret_value = 0
    Endcase
ELSE
   ret_value=-2 //Nao Pode Ser Verificado
   cMES="Nao Pode Ser Verificado"
ENDIF
* Apaga tudo e encerra a funcao.
FCLOSE(handle)
if Lmes
   ALERTX(Cmes)
endif
RETURN (ret_value)
