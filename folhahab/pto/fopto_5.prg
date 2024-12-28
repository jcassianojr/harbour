// +--------------------------------------------------------------------
// +
// +
// +
// +    Programa  : fopto_5.prg
// +
// +
// +
// +     Sistema:
// +
// +     Linguagem: Harbour
// +
// +     Autor: jcassiano
// +
// +     Copyright (c) 2024,  jcassiano
// +
// +
// +
// +
// +
// +    Documentado em 27-Dez-2024 as  9:33 pm
// +
// +
// +
// +--------------------------------------------------------------------
// +


HELPDBF := "FOPTO40"

WHILE .T.
CABE3( 'FOPTO_4 - Horarios', 23 )
OPCAO( 04, 01, " &A -                             ", 65, "                                               " )
OPCAO( 05, 01, " &B -                             ", 66, "                                               " )
OPCAO( 06, 01, " &C - Sincroniza Func->Horarios   ", 67, " Inclui admitidos,Exclui Demitidos do Cadastro " )
OPCAO( 07, 01, " &D - Funcionario Hor.Fixos/Escala", 68, " Funcionarios Horarios Fixo/Escala             " )
OPCAO( 08, 01, " &E - Horarios Semanal Fixo       ", 69, " Horarios Semanal Fixo                         " )
OPCAO( 09, 01, " &F -                             ", 70, "                                               " )
OPCAO( 10, 01, " &G -                             ", 71, "                                               " )
OPCAO( 11, 01, " &H -                             ", 72, "                                               " )
OPCAO( 12, 01, " &I -                             ", 73, "                                               " )
OPCAO( 13, 01, " &J -                             ", 74, "                                               " )
OPCAO( 14, 01, " &K - Horarios Escalas/Ajustes    ", 75, " Horarios Escalas/Ajustes  os                  " )
OPCAO( 15, 01, " &L - Correcao de Horarios        ", 76, " Correcao de Horarios                          " )
OPCAO( 16, 01, " &M - Multiplas Troca Horario     ", 77, " Multiplas Troca de Horarios                   " )
OPCAO( 17, 01, " &N -                             ", 78, "                                               " )
OPCAO( 18, 01, " &O - Descritivos de Horarios     ", 79, " Descritivos de horarios                       " )
OPCAO( 19, 01, " &P -                             ", 80, "                                               " )
OPCAO( 20, 01, " &Q -                             ", 81, "                                               " )
OPCAO( 21, 01, " &R -                             ", 82, "                                               " )
OPCAO( 04, 41, " &S - Escalas do Mes              ", 83, " Cadastro de Escalas de Revezamentos           " )
OPCAO( 05, 41, " &T - Escalas Padrao              ", 84, " Configurar Escalas Padrao                     " )
OPCAO( 06, 41, " &U - Apagar Um Escala            ", 85, " Apagar uma Escala de Revezamento              " )
OPCAO( 07, 41, " &V - Importar Escala Revezamento ", 86, " Importar Escalas de Revezamento  TXT          " )
OPCAO( 08, 41, " &W - Horario Fixo->Escala        ", 87, " Trocar Horario Fixo para Escala               " )
OPCAO( 09, 41, " &X - Trocar Descritivo Turno     ", 88, " Trocar Descritivo Turno                       " )
OPCAO( 10, 41, " &Y - Multiplas Troca Desc.Turno  ", 89, " Multiplas Troca Desc.Turno                    " )
OPCAO( 11, 41, " &Z -                             ", 90, "                                               " )
OPCAO( 12, 41, " &1 -                             ", 49, "                                               " )
OPCAO( 13, 41, " &2 -                             ", 50, "                                               " )
OPCAO( 14, 41, " &3 -                             ", 51, "                                               " )
OPCAO( 15, 41, " &4 -                             ", 52, "                                               " )
OPCAO( 16, 41, " &5 -                             ", 53, "                                               " )
OPCAO( 17, 41, " &6 -                             ", 54, "                                               " )
OPCAO( 18, 41, " &7 -                             ", 55, "                                               " )
OPCAO( 19, 41, " &8 -                             ", 56, "                                               " )
OPCAO( 20, 41, " &9 -                             ", 57, "                                               " )
OPCAO( 21, 41, " &0 -                             ", 48, "                                               " )
OPCAO := menu( 2, 24 )
IF ZUSER <> "SUPERVISOR" .AND. ZUSER <> "SOFTEC" .AND. OPCAO > 0
IF !VERSEHA( "MUSERM",, USERMCRI( ZUSER, "E", OPCAO ) )
ALERTX( "Voce nao tem acesso, Verifique com o Supervisor" )
LOOP
ENDIF
ENDIF
IF ZFECHADO = "S"
IF OPCAO = 31 .OR. OPCAO = 29 .OR. OPCAO = 24 .OR. OPCAO = 13
ALERTX( "Mes ja Fechado" )
LOOP
ENDIF
ENDIF
DO CASE
CASE OPCAO = 1   // A
CASE OPCAO = 2   // B
CASE OPCAO = 3   // C - Atualiza Hor rio Referencia
FOPTO_43()
CASE OPCAO = 4   // D - Alterar Hor rio Referencia
FOPTO_44()
CASE OPCAO = 5   // E - Horario de Referencia Basico
PADRAO( "FOPTOHRE", "FOPTOHRE", "' '+mCODIGO+' '+STR(mHENT,5,2)+' '+STR(mHALS,5,2)+' '+STR(mHALE,5,2)+' '+STR(mHSAI,5,2)+' '", "mCODIGO", "FOPTO_4D - Horario de Referencia Basico", "Codigo Entr.   Almoco    Saida", ;
            {|| PEGCHAVE( "mCODIGO", Space( 2 ), "Codigo:" ) }, {|| tFOPTO44( 2 ) }, {|| gFOPTO44( 2 ) }, {|| FO_RELL( "PONTOCAD06" ) },, 2,,, "X" )
CASE OPCAO = 6   // F
CASE OPCAO = 7   // G
CASE OPCAO = 8   // H
CASE OPCAO = 9   // I
CASE OPCAO = 10  // J
CASE OPCAO = 11  // K - Horarios Escalas/Ajustes
FOPTO_4B()
CASE OPCAO = 12  // L Correcao de Hoa rios
FOPTO_4L()
CASE OPCAO = 13  // M Multiplas Trocas de Horario
fopto_4L2()
CASE OPCAO = 14  // N
CASE OPCAO = 15  // O - Referencia de Turnos
FOPTO_4F()
CASE OPCAO = 16  // P
CASE OPCAO = 17  // Q
CASE OPCAO = 18  // R
CASE OPCAO = 19  // S - Escalas de Revezamento
FOPTO_4G()
CASE opcao = 20  // T escalas padrao
fopto4gpad()
CASE opcao = 21  // U Apagar Escala Padrao
fopto4gapa()
CASE opcao = 22  // V Importar escalas revezamento
FOPTO_4v()
CASE opcao = 23  // W Horario Fixo Escala
horpadtoesc()
CASE opcao = 24  // X trocar descritivo turno individual
trocahtt( 1 )
CASE OPCAO = 25  // Y trocar descritivo turno multiplos
trocahtt( 2 )
CASE OPCAO = 26  // Z
CASE OPCAO = 27  // 1 -
CASE OPCAO = 28  // 2 -
CASE OPCAO = 29  // 3 -
CASE OPCAO = 30  // 4
CASE OPCAO = 31  // 5
CASE OPCAO = 32  // 6
CASE opcao = 33  // 7
CASE opcao = 34  // 8
CASE opcao = 35  // 9
CASE opcao = 36  // 0
OTHER
RETU
ENDCASE
ENDDO




// + EOF: fopto_5.prg
// +
