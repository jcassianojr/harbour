*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
*+
*+    Source Module => C:\DEVELO~1\CLIPPER\FOLHA\OBJ\FOA2.PRG
*+
*+    Reformatted by Click! 2.03 on Jan-21-2002 at  4:27 pm
*+
*+ЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭ
#INCLUDE "BOX.CH"

CABEX( 'Entrada de Dados Para Folha' )
para CX, CY

OPCAO1 := 'S'
XA     := XB := XC := XD := XE := XF := CTR := CTCONTA := 0

CW := if( MDG( 'Deseja Confirmar os Valores' ), 1, 0 )

if ! NETUSE(PES) 
   dbcloseall()
   retu .F.
endif
FILTRO := "EMPTY(DEMITIDO)" //.AND.(EMPTY(SITUACAO).OR.SITUACAO='P')"
FI     := trim( FILTRO )
FILTRO := FILTRO( FI )
set filter to &FILTRO

if !ARQUSAR( CX )
   dbcloseall()
   retu .F.
endif
cSELE2:=ALIAS()


if ! NETUSE("CONTAS") 
   dbcloseall()
   retu .F.
endif

if CY = 1
   CC := PEGRELCTA( "" )
   X  := 0
endif

while OPCAO1 = 'S'
   @ 07, 00 clea
   if CY = 0
      MDS( 'NUMERO DA CONTA ------->' )
      @ 24, 57 get CTCONTA pict '#####'
      READCUR()
   endif
   if CY = 1
      X ++
      if X = 16
         OPCAO1 := 'N'
         loop
      endif
      CTCONTA := CC[ X ]
      if CTCONTA = 0
         OPCAO1 := 'N'
         loop
      endif
   endif
   // ** (LOCALIZANDO A CONTA )
   DBSELECTAR("CONTAS")
   dbgotop()
   if dbseek( CTCONTA )
      if ACEITE # "S" .or. ZUSER = "SUPERVISOR"
         HORA := VALE := 0
         XB   := TIPO
         HB_dispbox(12, 8, 16, 71,B_DOUBLE+" ")
         @ 12, 16 say "-" + repl( '-', 37 ) + "-"
         @ 16, 16 say "-" + repl( '-', 37 ) + "-"
         @ 13, 10 say "Conta Э Descrimina‡„o" + spac( 23 ) + "Э Valor/Horas"
         @ 14, 08 say 'З' + repl( '-', 7 ) + "+" + repl( '-', 37 ) + "+" + repl( '-', 16 ) + '¶'
         @ 15, 16 say "Э" + spac( 37 ) + "Э"
         @ 15, 11 say CODIGO                                                                     picture "###"
         @ 15, 18 say DESCR
         if XB = 1 .or. XB = 3 .or. XB = 4
            @ 15, 56 get HORA pict '###.##'
         else
            @ 15, 56 get VALE pict '###,###,###.##'
         endif
         READCUR()
         if VALE # 0 .or. HORA # 0
            DBSELECTAR(PES)
            dbgotop()
            while !eof()
               PETELA( 7 )
               IF ! EMPTy(SITUACAO)
                  ALERTX(SITUACAO+'-'+CHECKTAB("SITU"+SITUACAO,,,"Situacao nao Cadastrado",2))
               ENDIF
               CTR := NUMERO
               if CW = 1 .OR. ! EMPTy(SITUACAO)
                  DBSELECTAR(cSELE2)
                  VALE := VALCTA( CTR, CTCONTA )
                  HORA := if( found(), HORAS, 0 )
                  if XB = 1 .or. XB = 3 .or. XB = 4
                     @ 15, 56 get HORA pict '###.##'
                     READCUR()
                  else
                     @ 15, 56 get VALE pict '###,###,###.##'
                     READCUR()
                  endif
               endif
               GRAVA2( CTCONTA )
               if XB = 1 .or. XB = 3 .or. XB = 4
                  field->HORAS := HORA
               endif
               DBSELECTAR(PES)
               dbskip()
            enddo
         endif
      else
         ALERTX( "Inclus„o desta Conta Permitida Somente para o Supervisor" )
      endif
   else
      ALERTX( "Conta n„o Cadastrada" )
   endif
   if CY = 0
      @  7, 00 clear
      MDS( 'Deseja Continuar (S/N)=>' )
      @ 24, 57 get OPCAO1
      READCUR()
   endif
enddo
DBSELECTAR(cSELE2)
FODZER()
dbcloseall()
retu

*+ EOF: FOA2.PRG
