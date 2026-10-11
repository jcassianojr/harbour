# ðŸ“˜ Harbour Documentation

**Generated:** 10/11/2026
**Total symbols:** 383

## ðŸ“‘ Table of Contents

- [ShowAdoError](#showadoerror) `[function]`
- [FixSRTExtendido](#fixsrtextendido) `[function]`
- [FIXINT](#fixint) `[function]`
- [FIXNUM](#fixnum) `[function]`
- [FIXSTR](#fixstr) `[function]`
- [FIXDATS](#fixdats) `[function]`
- [FIXDATA](#fixdata) `[function]`
- [FIXLOGIC](#fixlogic) `[function]`
- [FIXHORA](#fixhora) `[function]`
- [FIXESCAPECODES](#fixescapecodes) `[function]`
- [DateToMySQL](#datetomysql) `[function]`
- [pegcidconv](#pegcidconv) `[function]`
- [BUSCAIBGE](#buscaibge) `[function]`
- [IRRFIBGE](#irrfibge) `[function]`
- [coduf](#coduf) `[function]`
- [tratanome](#tratanome) `[function]`
- [hb_fopen](#hb_fopen) `[function]`
- [alltrue](#alltrue) `[function]`
- [clscor](#clscor) `[function]`
- [video](#video) `[function]`
- [impressora](#impressora) `[function]`
- [clsrow](#clsrow) `[function]`
- [clsbox](#clsbox) `[function]`
- [NNETWHOAMI](#nnetwhoami) `[function]`
- [MDG](#mdg) `[function]`
- [MDS](#mds) `[function]`
- [Hotinkey](#hotinkey) `[function]`
- [SALVAA](#salvaa) `[function]`
- [RESTAA](#restaa) `[function]`
- [MascararEmail](#mascararemail) `[function]`
- [CheckEmail](#checkemail) `[function]`
- [rmacro](#rmacro) `[function]`
- [ArqLogDataHora](#arqlogdatahora) `[function]`
- [GetDrvMapLetter](#getdrvmapletter) `[function]`
- [MsgYesNo](#msgyesno) `[function]`
- [MsgExclamation](#msgexclamation) `[function]`
- [MsgWarning](#msgwarning) `[function]`
- [MsgStop](#msgstop) `[function]`
- [ALERTX](#alertx) `[function]`
- [shellexecprint](#shellexecprint) `[function]`
- [ShellExecuteOpen](#shellexecuteopen) `[function]`
- [ArraytoTexto](#arraytotexto) `[function]`
- [WaitProcess](#waitprocess) `[function]`
- [CHR_A_AGUDO](#chr_a_agudo) `[constant]`
- [CHR_a_AGUDO](#chr_a_agudo) `[constant]`
- [CHR_E_AGUDO](#chr_e_agudo) `[constant]`
- [CHR_e_AGUDO](#chr_e_agudo) `[constant]`
- [CHR_I_AGUDO](#chr_i_agudo) `[constant]`
- [CHR_i_AGUDO](#chr_i_agudo) `[constant]`
- [CHR_O_AGUDO](#chr_o_agudo) `[constant]`
- [CHR_o_AGUDO](#chr_o_agudo) `[constant]`
- [CHR_U_AGUDO](#chr_u_agudo) `[constant]`
- [CHR_u_AGUDO](#chr_u_agudo) `[constant]`
- [CHR_C_CEDIL](#chr_c_cedil) `[constant]`
- [CHR_c_CEDIL](#chr_c_cedil) `[constant]`
- [CHR_A_TIL](#chr_a_til) `[constant]`
- [CHR_a_TIL](#chr_a_til) `[constant]`
- [CHR_O_TIL](#chr_o_til) `[constant]`
- [CHR_o_TIL](#chr_o_til) `[constant]`
- [CHR_N_TIL](#chr_n_til) `[constant]`
- [CHR_n_TIL](#chr_n_til) `[constant]`
- [CHR_A_CIRC](#chr_a_circ) `[constant]`
- [CHR_a_CIRC](#chr_a_circ) `[constant]`
- [CHR_E_CIRC](#chr_e_circ) `[constant]`
- [CHR_e_CIRC](#chr_e_circ) `[constant]`
- [CHR_I_CIRC](#chr_i_circ) `[constant]`
- [CHR_i_CIRC](#chr_i_circ) `[constant]`
- [CHR_O_CIRC](#chr_o_circ) `[constant]`
- [CHR_o_CIRC](#chr_o_circ) `[constant]`
- [CHR_U_CIRC](#chr_u_circ) `[constant]`
- [CHR_u_CIRC](#chr_u_circ) `[constant]`
- [CHR_A_TREM](#chr_a_trem) `[constant]`
- [CHR_a_TREM](#chr_a_trem) `[constant]`
- [CHR_E_TREM](#chr_e_trem) `[constant]`
- [CHR_e_TREM](#chr_e_trem) `[constant]`
- [CHR_I_TREM](#chr_i_trem) `[constant]`
- [CHR_i_TREM](#chr_i_trem) `[constant]`
- [CHR_O_TREM](#chr_o_trem) `[constant]`
- [CHR_o_TREM](#chr_o_trem) `[constant]`
- [CHR_U_TREM](#chr_u_trem) `[constant]`
- [CHR_u_TREM](#chr_u_trem) `[constant]`
- [CHR_A_CRASE](#chr_a_crase) `[constant]`
- [CHR_a_CRASE](#chr_a_crase) `[constant]`
- [CHR_E_CRASE](#chr_e_crase) `[constant]`
- [CHR_e_CRASE](#chr_e_crase) `[constant]`
- [CHR_I_CRASE](#chr_i_crase) `[constant]`
- [CHR_i_CRASE](#chr_i_crase) `[constant]`
- [CHR_O_CRASE](#chr_o_crase) `[constant]`
- [CHR_o_CRASE](#chr_o_crase) `[constant]`
- [CHR_U_CRASE](#chr_u_crase) `[constant]`
- [CHR_u_CRASE](#chr_u_crase) `[constant]`
- [CHR_ORD_FEM](#chr_ord_fem) `[constant]`
- [CHR_ORD_MASC](#chr_ord_masc) `[constant]`
- [CHR_GRAU](#chr_grau) `[constant]`
- [CHR_COPY](#chr_copy) `[constant]`
- [CHR_REG](#chr_reg) `[constant]`
- [CHR_SECAO](#chr_secao) `[constant]`
- [Readcur  // DESLIGA E LIGA O CURS PARA UM READ](#readcur  // desliga e liga o curs para um read) `[function]`
- [Xctrldel](#xctrldel) `[function]`
- [Xbhor](#xbhor) `[function]`
- [Xchor](#xchor) `[function]`
- [Xctrlins](#xctrlins) `[function]`
- [XCENTER](#xcenter) `[function]`
- [XPOSDIR](#xposdir) `[function]`
- [XPOSESQ](#xposesq) `[function]`
- [Xaltins](#xaltins) `[function]`
- [Xcapfirs](#xcapfirs) `[function]`
- [XEXPAND](#xexpand) `[function]`
- [XCONVMIN](#xconvmin) `[function]`
- [Xconvmai](#xconvmai) `[function]`
- [xcaptxt](#xcaptxt) `[function]`
- [XGRATXT](#xgratxt) `[function]`
- [xediwor](#xediwor) `[function]`
- [xtirace](#xtirace) `[function]`
- [Nobreak](#nobreak) `[function]`
- [XLERTXT](#xlertxt) `[function]`
- [ACEPAD](#acepad) `[function]`
- [Convmini](#convmini) `[function]`
- [Convmais](#convmais) `[function]`
- [tirace](#tirace) `[function]`
- [CHARCONV](#charconv) `[function]`
- [CHARCNVMT](#charcnvmt) `[function]`
- [ConverterAcentos](#converteracentos) `[function]`
- [tirace2](#tirace2) `[function]`
- [CHR_A_AGUDO](#chr_a_agudo) `[constant]`
- [CHR_a_AGUDO](#chr_a_agudo) `[constant]`
- [CHR_E_AGUDO](#chr_e_agudo) `[constant]`
- [CHR_e_AGUDO](#chr_e_agudo) `[constant]`
- [CHR_I_AGUDO](#chr_i_agudo) `[constant]`
- [CHR_i_AGUDO](#chr_i_agudo) `[constant]`
- [CHR_O_AGUDO](#chr_o_agudo) `[constant]`
- [CHR_o_AGUDO](#chr_o_agudo) `[constant]`
- [CHR_U_AGUDO](#chr_u_agudo) `[constant]`
- [CHR_u_AGUDO](#chr_u_agudo) `[constant]`
- [CHR_C_CEDIL](#chr_c_cedil) `[constant]`
- [CHR_c_CEDIL](#chr_c_cedil) `[constant]`
- [CHR_A_TIL](#chr_a_til) `[constant]`
- [CHR_a_TIL](#chr_a_til) `[constant]`
- [CHR_O_TIL](#chr_o_til) `[constant]`
- [CHR_o_TIL](#chr_o_til) `[constant]`
- [CHR_N_TIL](#chr_n_til) `[constant]`
- [CHR_n_TIL](#chr_n_til) `[constant]`
- [CHR_A_CIRC](#chr_a_circ) `[constant]`
- [CHR_a_CIRC](#chr_a_circ) `[constant]`
- [CHR_E_CIRC](#chr_e_circ) `[constant]`
- [CHR_e_CIRC](#chr_e_circ) `[constant]`
- [CHR_I_CIRC](#chr_i_circ) `[constant]`
- [CHR_i_CIRC](#chr_i_circ) `[constant]`
- [CHR_O_CIRC](#chr_o_circ) `[constant]`
- [CHR_o_CIRC](#chr_o_circ) `[constant]`
- [CHR_U_CIRC](#chr_u_circ) `[constant]`
- [CHR_u_CIRC](#chr_u_circ) `[constant]`
- [CHR_A_TREM](#chr_a_trem) `[constant]`
- [CHR_a_TREM](#chr_a_trem) `[constant]`
- [CHR_E_TREM](#chr_e_trem) `[constant]`
- [CHR_e_TREM](#chr_e_trem) `[constant]`
- [CHR_I_TREM](#chr_i_trem) `[constant]`
- [CHR_i_TREM](#chr_i_trem) `[constant]`
- [CHR_O_TREM](#chr_o_trem) `[constant]`
- [CHR_o_TREM](#chr_o_trem) `[constant]`
- [CHR_U_TREM](#chr_u_trem) `[constant]`
- [CHR_u_TREM](#chr_u_trem) `[constant]`
- [CHR_A_CRASE](#chr_a_crase) `[constant]`
- [CHR_a_CRASE](#chr_a_crase) `[constant]`
- [CHR_E_CRASE](#chr_e_crase) `[constant]`
- [CHR_e_CRASE](#chr_e_crase) `[constant]`
- [CHR_I_CRASE](#chr_i_crase) `[constant]`
- [CHR_i_CRASE](#chr_i_crase) `[constant]`
- [CHR_O_CRASE](#chr_o_crase) `[constant]`
- [CHR_o_CRASE](#chr_o_crase) `[constant]`
- [CHR_U_CRASE](#chr_u_crase) `[constant]`
- [CHR_u_CRASE](#chr_u_crase) `[constant]`
- [Acentuar](#acentuar) `[function]`
- [AC_AGUDO](#ac_agudo) `[function]`
- [AC_CRASE](#ac_crase) `[function]`
- [AC_TIL](#ac_til) `[function]`
- [AC_CIRC](#ac_circ) `[function]`
- [liga_acento](#liga_acento) `[function]`
- [Acento](#acento) `[function]`
- [convansi](#convansi) `[function]`
- [convoem](#convoem) `[function]`
- [str2html](#str2html) `[function]`
- [CAPFIRS2](#capfirs2) `[function]`
- [SonumeroX](#sonumerox) `[function]`
- [TIRAOUT](#tiraout) `[function]`
- [GRVVAL](#grvval) `[function]`
- [data2str](#data2str) `[function]`
- [str2data](#str2data) `[function]`
- [DifDatas](#difdatas) `[function]`
- [DIGADATA](#digadata) `[function]`
- [Cmes](#cmes) `[function]`
- [Mmes](#mmes) `[function]`
- [Cdia](#cdia) `[function]`
- [Ddia](#ddia) `[function]`
- [CTOHORA](#ctohora) `[function]`
- [StrLogic](#strlogic) `[function]`
- [Logic2Str](#logic2str) `[function]`
- [Strval](#strval) `[function]`
- [CHOR](#chor) `[function]`
- [BHOR](#bhor) `[function]`
- [geotodec](#geotodec) `[function]`
- [calcgeokm](#calcgeokm) `[function]`
- [deg2rad](#deg2rad) `[function]`
- [rad2deg](#rad2deg) `[function]`
- [MinutoToHora](#minutotohora) `[function]`
- [aconvertend](#aconvertend) `[function]`
- [UniversalToDate](#universaltodate) `[function]`
- [UniversalDateTime](#universaldatetime) `[function]`
- [TB_UPARROW](#tb_uparrow) `[constant]`
- [TB_DNARROW](#tb_dnarrow) `[constant]`
- [TB_BACKGROUND](#tb_background) `[constant]`
- [TB_HIGHLIGHT](#tb_highlight) `[constant]`
- [TB_ROWTOP](#tb_rowtop) `[constant]`
- [TB_COLTOP](#tb_coltop) `[constant]`
- [TB_ROWBOTTOM](#tb_rowbottom) `[constant]`
- [TB_COLBOTTOM](#tb_colbottom) `[constant]`
- [TB_COLOR](#tb_color) `[constant]`
- [TB_POSITION](#tb_position) `[constant]`
- [TB_ELEMENTS](#tb_elements) `[constant]`
- [SCROLLBARNEW](#scrollbarnew) `[function]`
- [SCROLLBARDISPLAY](#scrollbardisplay) `[function]`
- [SCROLLBARUPDATE](#scrollbarupdate) `[function]`
- [ACHRETB](#achretb) `[function]`
- [editarq](#editarq) `[function]`
- [valcnpj](#valcnpj) `[function]`
- [VALCGC](#valcgc) `[function]`
- [Valcpf](#valcpf) `[function]`
- [CNPJ_Novo](#cnpj_novo) `[function]`
- [Mod11](#mod11) `[function]`
- [formatacpf](#formatacpf) `[function]`
- [formatacnpj](#formatacnpj) `[function]`
- [CNPJCPFPICT](#cnpjcpfpict) `[function]`
- [CNPJCPFVAL](#cnpjcpfval) `[function]`
- [VALCEI](#valcei) `[function]`
- [MascararNumGenerico](#mascararnumgenerico) `[function]`
- [MascaraCNPJ](#mascaracnpj) `[function]`
- [MascararNome](#mascararnome) `[function]`
- [OfuscarDataAleatoria](#ofuscardataaleatoria) `[function]`
- [MascararCPF](#mascararcpf) `[function]`
- [PEGAPASS](#pegapass) `[function]`
- [CheckPass](#checkpass) `[function]`
- [TECLAS](#teclas) `[function]`
- [CARDCHEK](#cardchek) `[function]`
- [CHECKCTA](#checkcta) `[function]`
- [CALCDIG](#calcdig) `[function]`
- [DAC10](#dac10) `[function]`
- [GravaCampo](#gravacampo) `[function]`
- [GravaERRO](#gravaerro) `[function]`
- [CLRVARS](#clrvars) `[function]`
- [EQUVARS](#equvars) `[function]`
- [FREEVARS](#freevars) `[function]`
- [INITVARS](#initvars) `[function]`
- [REPLVARS](#replvars) `[function]`
- [MAKEVAR](#makevar) `[function]`
- [MAKE_EMPTY](#make_empty) `[function]`
- [FormataRG](#formatarg) `[function]`
- [MascararRG](#mascararrg) `[function]`
- [CheckRG](#checkrg) `[function]`
- [PEGDDD](#pegddd) `[function]`
- [PEGTEL](#pegtel) `[function]`
- [PEGPREF](#pegpref) `[function]`
- [formataTel](#formatatel) `[function]`
- [ForTel2](#fortel2) `[function]`
- [FormataCEP](#formatacep) `[function]`
- [chkufcep](#chkufcep) `[function]`
- [cep2uf](#cep2uf) `[function]`
- [FILENAMES](#filenames) `[function]`
- [TIRAEXT](#tiraext) `[function]`
- [TROCAEXT](#trocaext) `[function]`
- [DELETAARQ](#deletaarq) `[function]`
- [BIF_RETURNONLYFSDIRS](#bif_returnonlyfsdirs) `[constant]`
- [BIF_NONEWFOLDERBUTTON](#bif_nonewfolderbutton) `[constant]`
- [SelectFolder](#selectfolder) `[function]`
- [DomingoDePascoa](#domingodepascoa) `[function]`
- [TercaDeCarnaval](#tercadecarnaval) `[function]`
- [INFOR  ](#infor  ) `[function]`
- [REDEFILE](#redefile) `[function]`
- [ADJVAL](#adjval) `[constant]`
- [ENCODE](#encode) `[function]`
- [DECODE](#decode) `[function]`
- [ENCODEVAL](#encodeval) `[function]`
- [DECODEVAL](#decodeval) `[function]`
- [XDECODE](#xdecode) `[function]`
- [XENCODE](#xencode) `[function]`
- [XDECDAT](#xdecdat) `[function]`
- [ISMEMO](#ismemo) `[function]`
- [INFOTIPODBF](#infotipodbf) `[function]`
- [FIELD_ENTRY_SIZE](#field_entry_size) `[constant]`
- [FIELD_NAME_SIZE](#field_name_size) `[constant]`
- [GetHeaderInfo](#getheaderinfo) `[function]`
- [HEXTABLE](#hextable) `[constant]`
- [HEX2DEC](#hex2dec) `[function]`
- [FT_BYT2HEX](#ft_byt2hex) `[function]`
- [MAKEDBF](#makedbf) `[function]`
- [f_names](#f_names) `[constant]`
- [f_types](#f_types) `[constant]`
- [f_lens](#f_lens) `[constant]`
- [f_decs](#f_decs) `[constant]`
- [f_ok](#f_ok) `[constant]`
- [parse](#parse) `[function]`
- [MEMOPACK](#memopack) `[function]`
- [READTEXT](#readtext) `[function]`
- [wind_rows](#wind_rows) `[constant]`
- [wind_cols](#wind_cols) `[constant]`
- [TMPFILE](#tmpfile) `[function]`
- [ESCARR](#escarr) `[function]`
- [MEMOVIEW](#memoview) `[function]`
- [DBFVIEW](#dbfview) `[function]`
- [FILEVIEWF](#fileviewf) `[function]`
- [FILEVIEWG](#fileviewg) `[function]`
- [BASBRO](#basbro) `[function]`
- [fmemoline](#fmemoline) `[function]`
- [OPCAO](#opcao) `[function]`
- [menu](#menu) `[function]`
- [PROV_RSA_FULL](#prov_rsa_full) `[constant]`
- [CRYPT_VERIFYCONTEXT](#crypt_verifycontext) `[constant]`
- [CALG_MD5](#calg_md5) `[constant]`
- [CALG_RC2](#calg_rc2) `[constant]`
- [parametrosLerDados](#parametroslerdados) `[function]`
- [ParametrosEnviarDados](#parametrosenviardados) `[function]`
- [CaminhoArquivoCofre](#caminhoarquivocofre) `[function]`
- [LerDoCofre](#lerdocofre) `[function]`
- [GravarNoCofre](#gravarnocofre) `[function]`
- [ExcluirBanco](#excluirbanco) `[function]`
- [netregosok](#netregosok) `[function]`
- [netgrvcam](#netgrvcam) `[function]`
- [netgrvd](#netgrvd) `[function]`
- [netgrvz](#netgrvz) `[function]`
- [dbSkipEx](#dbskipex) `[function]`
- [netrecapp](#netrecapp) `[function]`
- [netrecdel](#netrecdel) `[function]`
- [netreclock](#netreclock) `[function]`
- [netrecunlcom](#netrecunlcom) `[function]`
- [netpack](#netpack) `[function]`
- [netzap](#netzap) `[function]`
- [NetRegCount](#netregcount) `[function]`
- [netuse](#netuse) `[function]`
- [zei_fort](#zei_fort) `[function]`
- [sdvpegpos](#sdvpegpos) `[function]`
- [sdvarrpos](#sdvarrpos) `[function]`
- [sdvarrcam](#sdvarrcam) `[function]`
- [FtsBuscaPorArquivo](#ftsbuscaporarquivo) `[function]`
- [FtsBuscaDbf](#ftsbuscadbf) `[function]`
- [ftshsx](#ftshsx) `[function]`
- [RecToStr](#rectostr) `[function]`
- [FilterFtsBusca](#filterftsbusca) `[function]`
- [netregosok](#netregosok) `[function]`
- [netgrvcam](#netgrvcam) `[function]`
- [netgrvd](#netgrvd) `[function]`
- [netgrvz](#netgrvz) `[function]`
- [dbSkipEx](#dbskipex) `[function]`
- [netrecapp](#netrecapp) `[function]`
- [netrecdel](#netrecdel) `[function]`
- [netreclock](#netreclock) `[function]`
- [netrecunlcom](#netrecunlcom) `[function]`
- [netpack](#netpack) `[function]`
- [netzap](#netzap) `[function]`
- [NetRegCount](#netregcount) `[function]`
- [netuse](#netuse) `[function]`
- [zei_fort](#zei_fort) `[function]`
- [sdvpegpos](#sdvpegpos) `[function]`
- [sdvarrpos](#sdvarrpos) `[function]`
- [sdvarrcam](#sdvarrcam) `[function]`
- [FILETOPDF](#filetopdf) `[function]`
- [ProfileString](#profilestring) `[function]`
- [SetProfile](#setprofile) `[function]`
- [ProfileNum](#profilenum) `[function]`
- [ProfileDate](#profiledate) `[function]`
- [ProfileLogical](#profilelogical) `[function]`
- [ValIE](#valie) `[function]`
- [FormataIE](#formataie) `[function]`
- [formataprocesso](#formataprocesso) `[function]`
- [validaprocesso](#validaprocesso) `[function]`
- [validaPlaca](#validaplaca) `[function]`
- [validacnh](#validacnh) `[function]`
- [CheckCNHCat](#checkcnhcat) `[function]`
- [MVINFOConfTela](#mvinfoconftela) `[function]`
- [xhb_ErrorLog](#xhb_errorlog) `[function]`
- [ErrorSys](#errorsys) `[function]`
- [xhb_ErrorSys](#xhb_errorsys) `[function]`
- [__ErrorBlock](#__errorblock) `[function]`
- [__MinimalErrorHandler](#__minimalerrorhandler) `[function]`
- [PS_OS_ERR](#ps_os_err) `[function]`

---

## ShowAdoError
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\adoerror.prg` (line 34)

---

## FixSRTExtendido
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\adofix.prg` (line 25)

---

## FIXINT
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\adofix.prg` (line 84)

---

## FIXNUM
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\adofix.prg` (line 95)

---

## FIXSTR
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\adofix.prg` (line 110)

---

## FIXDATS
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\adofix.prg` (line 124)

---

## FIXDATA
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\adofix.prg` (line 159)

---

## FIXLOGIC
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\adofix.prg` (line 193)

---

## FIXHORA
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\adofix.prg` (line 221)

---

## FIXESCAPECODES
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\adofix.prg` (line 238)

---

## DateToMySQL
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\adofix.prg` (line 259)

---

## pegcidconv
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\cepsutil.prg` (line 41)

---

## BUSCAIBGE
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\cepsutil.prg` (line 74)

---

## IRRFIBGE
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\cepsutil.prg` (line 118)

---

## coduf
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\cepsutil.prg` (line 150)

---

## tratanome
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\cepsutil.prg` (line 201)

---

## hb_fopen
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 64)

---

## alltrue
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 81)

---

## clscor
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 99)

---

## video
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 116)

---

## impressora
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 133)

---

## clsrow
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 150)

---

## clsbox
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 167)

---

## NNETWHOAMI
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 186)

---

## MDG
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 211)

---

## MDS
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 229)

---

## Hotinkey
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 252)

---

## SALVAA
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 301)

---

## RESTAA
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 324)

---

## MascararEmail
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 336)

---

## CheckEmail
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 376)

---

## rmacro
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 457)

---

## ArqLogDataHora
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 489)

---

## GetDrvMapLetter
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 516)

---

## MsgYesNo
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 551)

---

## MsgExclamation
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 574)

---

## MsgWarning
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 595)

---

## MsgStop
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 616)

---

## ALERTX
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 637)

---

## shellexecprint
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 668)

---

## ShellExecuteOpen
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 696)

---

## ArraytoTexto
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 706)

---

## WaitProcess
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\comp.prg` (line 711)

---

## CHR_A_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 52)

### ðŸ’Ž Value
```harbour
"193 // Á"
```

---

## CHR_a_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 53)

### ðŸ’Ž Value
```harbour
"225 // á"
```

---

## CHR_E_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 54)

### ðŸ’Ž Value
```harbour
"201 // É"
```

---

## CHR_e_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 55)

### ðŸ’Ž Value
```harbour
"233 // é"
```

---

## CHR_I_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 56)

### ðŸ’Ž Value
```harbour
"205 // Í"
```

---

## CHR_i_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 57)

### ðŸ’Ž Value
```harbour
"237 // í"
```

---

## CHR_O_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 58)

### ðŸ’Ž Value
```harbour
"211 // Ó"
```

---

## CHR_o_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 59)

### ðŸ’Ž Value
```harbour
"243 // ó"
```

---

## CHR_U_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 60)

### ðŸ’Ž Value
```harbour
"218 // Ú"
```

---

## CHR_u_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 61)

### ðŸ’Ž Value
```harbour
"250 // ú"
```

---

## CHR_C_CEDIL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 62)

### ðŸ’Ž Value
```harbour
"199 // Ç"
```

---

## CHR_c_CEDIL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 63)

### ðŸ’Ž Value
```harbour
"231 // ç"
```

---

## CHR_A_TIL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 64)

### ðŸ’Ž Value
```harbour
"195 // Ã"
```

---

## CHR_a_TIL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 65)

### ðŸ’Ž Value
```harbour
"227 // ã"
```

---

## CHR_O_TIL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 66)

### ðŸ’Ž Value
```harbour
"213 // Õ"
```

---

## CHR_o_TIL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 67)

### ðŸ’Ž Value
```harbour
"245 // õ"
```

---

## CHR_N_TIL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 68)

### ðŸ’Ž Value
```harbour
"209 // Ñ"
```

---

## CHR_n_TIL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 69)

### ðŸ’Ž Value
```harbour
"241 // ñ"
```

---

## CHR_A_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 70)

### ðŸ’Ž Value
```harbour
"194 // Â"
```

---

## CHR_a_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 71)

### ðŸ’Ž Value
```harbour
"226 // â"
```

---

## CHR_E_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 72)

### ðŸ’Ž Value
```harbour
"202 // Ê"
```

---

## CHR_e_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 73)

### ðŸ’Ž Value
```harbour
"234 // ê"
```

---

## CHR_I_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 74)

### ðŸ’Ž Value
```harbour
"206 // Î"
```

---

## CHR_i_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 75)

### ðŸ’Ž Value
```harbour
"238 // î"
```

---

## CHR_O_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 76)

### ðŸ’Ž Value
```harbour
"212 // Ô"
```

---

## CHR_o_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 77)

### ðŸ’Ž Value
```harbour
"244 // ô"
```

---

## CHR_U_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 78)

### ðŸ’Ž Value
```harbour
"219 // Û"
```

---

## CHR_u_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 79)

### ðŸ’Ž Value
```harbour
"251 // û"
```

---

## CHR_A_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 80)

### ðŸ’Ž Value
```harbour
"196 // Ä"
```

---

## CHR_a_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 81)

### ðŸ’Ž Value
```harbour
"228 // ä"
```

---

## CHR_E_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 82)

### ðŸ’Ž Value
```harbour
"203 // Ë"
```

---

## CHR_e_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 83)

### ðŸ’Ž Value
```harbour
"235 // ë"
```

---

## CHR_I_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 84)

### ðŸ’Ž Value
```harbour
"207 // Ï"
```

---

## CHR_i_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 85)

### ðŸ’Ž Value
```harbour
"239 // ï"
```

---

## CHR_O_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 86)

### ðŸ’Ž Value
```harbour
"214 // Ö"
```

---

## CHR_o_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 87)

### ðŸ’Ž Value
```harbour
"246 // ö"
```

---

## CHR_U_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 88)

### ðŸ’Ž Value
```harbour
"220 // Ü"
```

---

## CHR_u_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 89)

### ðŸ’Ž Value
```harbour
"252 // ü"
```

---

## CHR_A_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 90)

### ðŸ’Ž Value
```harbour
"192 // À"
```

---

## CHR_a_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 91)

### ðŸ’Ž Value
```harbour
"224 // à"
```

---

## CHR_E_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 92)

### ðŸ’Ž Value
```harbour
"200 // È"
```

---

## CHR_e_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 93)

### ðŸ’Ž Value
```harbour
"232 // è"
```

---

## CHR_I_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 94)

### ðŸ’Ž Value
```harbour
"204 // Ì"
```

---

## CHR_i_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 95)

### ðŸ’Ž Value
```harbour
"236 // ì"
```

---

## CHR_O_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 96)

### ðŸ’Ž Value
```harbour
"210 // Ò"
```

---

## CHR_o_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 97)

### ðŸ’Ž Value
```harbour
"242 // ò"
```

---

## CHR_U_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 98)

### ðŸ’Ž Value
```harbour
"217 // Ù"
```

---

## CHR_u_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 99)

### ðŸ’Ž Value
```harbour
"249 // ù"
```

---

## CHR_ORD_FEM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 100)

### ðŸ’Ž Value
```harbour
"170 // ª Ordinal Feminino"
```

---

## CHR_ORD_MASC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 101)

### ðŸ’Ž Value
```harbour
"186 // º Ordinal Masculino"
```

---

## CHR_GRAU
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 102)

### ðŸ’Ž Value
```harbour
"176 // ° Grau (Temperatura/Geográfico)"
```

---

## CHR_COPY
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 103)

### ðŸ’Ž Value
```harbour
"169 // © Copyright"
```

---

## CHR_REG
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 104)

### ðŸ’Ž Value
```harbour
"174 // ® Registrado"
```

---

## CHR_SECAO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 105)

### ðŸ’Ž Value
```harbour
"167 // § Seção"
```

---

## Readcur  // DESLIGA E LIGA O CURS PARA UM READ
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 113)

---

## Xctrldel
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 169)

---

## Xbhor
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 187)

---

## Xchor
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 209)

---

## Xctrlins
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 228)

---

## XCENTER
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 244)

---

## XPOSDIR
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 267)

---

## XPOSESQ
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 290)

---

## Xaltins
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 313)

---

## Xcapfirs
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 327)

---

## XEXPAND
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 352)

---

## XCONVMIN
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 374)

---

## Xconvmai
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 395)

---

## xcaptxt
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 416)

---

## XGRATXT
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 449)

---

## xediwor
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 474)

---

## xtirace
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 507)

---

## Nobreak
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 528)

---

## XLERTXT
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 543)

---

## ACEPAD
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 565)

---

## Convmini
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 578)

---

## Convmais
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 593)

---

## tirace
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 609)

---

## CHARCONV
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 624)

---

## CHARCNVMT
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 672)

---

## ConverterAcentos
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 713)

---

## tirace2
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk53.prg` (line 750)

---

## CHR_A_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 28)

### ðŸ’Ž Value
```harbour
"193 // Á"
```

---

## CHR_a_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 29)

### ðŸ’Ž Value
```harbour
"225 // á"
```

---

## CHR_E_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 30)

### ðŸ’Ž Value
```harbour
"201 // É"
```

---

## CHR_e_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 31)

### ðŸ’Ž Value
```harbour
"233 // é"
```

---

## CHR_I_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 32)

### ðŸ’Ž Value
```harbour
"205 // Í"
```

---

## CHR_i_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 33)

### ðŸ’Ž Value
```harbour
"237 // í"
```

---

## CHR_O_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 34)

### ðŸ’Ž Value
```harbour
"211 // Ó"
```

---

## CHR_o_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 35)

### ðŸ’Ž Value
```harbour
"243 // ó"
```

---

## CHR_U_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 36)

### ðŸ’Ž Value
```harbour
"218 // Ú"
```

---

## CHR_u_AGUDO
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 37)

### ðŸ’Ž Value
```harbour
"250 // ú"
```

---

## CHR_C_CEDIL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 38)

### ðŸ’Ž Value
```harbour
"199 // Ç"
```

---

## CHR_c_CEDIL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 39)

### ðŸ’Ž Value
```harbour
"231 // ç"
```

---

## CHR_A_TIL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 40)

### ðŸ’Ž Value
```harbour
"195 // Ã"
```

---

## CHR_a_TIL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 41)

### ðŸ’Ž Value
```harbour
"227 // ã"
```

---

## CHR_O_TIL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 42)

### ðŸ’Ž Value
```harbour
"213 // Õ"
```

---

## CHR_o_TIL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 43)

### ðŸ’Ž Value
```harbour
"245 // õ"
```

---

## CHR_N_TIL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 44)

### ðŸ’Ž Value
```harbour
"209 // Ñ"
```

---

## CHR_n_TIL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 45)

### ðŸ’Ž Value
```harbour
"241 // ñ"
```

---

## CHR_A_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 46)

### ðŸ’Ž Value
```harbour
"194 // Â"
```

---

## CHR_a_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 47)

### ðŸ’Ž Value
```harbour
"226 // â"
```

---

## CHR_E_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 48)

### ðŸ’Ž Value
```harbour
"202 // Ê"
```

---

## CHR_e_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 49)

### ðŸ’Ž Value
```harbour
"234 // ê"
```

---

## CHR_I_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 50)

### ðŸ’Ž Value
```harbour
"206 // Î"
```

---

## CHR_i_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 51)

### ðŸ’Ž Value
```harbour
"238 // î"
```

---

## CHR_O_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 52)

### ðŸ’Ž Value
```harbour
"212 // Ô"
```

---

## CHR_o_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 53)

### ðŸ’Ž Value
```harbour
"244 // ô"
```

---

## CHR_U_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 54)

### ðŸ’Ž Value
```harbour
"219 // Û"
```

---

## CHR_u_CIRC
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 55)

### ðŸ’Ž Value
```harbour
"251 // û"
```

---

## CHR_A_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 56)

### ðŸ’Ž Value
```harbour
"196 // Ä"
```

---

## CHR_a_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 57)

### ðŸ’Ž Value
```harbour
"228 // ä"
```

---

## CHR_E_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 58)

### ðŸ’Ž Value
```harbour
"203 // Ë"
```

---

## CHR_e_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 59)

### ðŸ’Ž Value
```harbour
"235 // ë"
```

---

## CHR_I_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 60)

### ðŸ’Ž Value
```harbour
"207 // Ï"
```

---

## CHR_i_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 61)

### ðŸ’Ž Value
```harbour
"239 // ï"
```

---

## CHR_O_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 62)

### ðŸ’Ž Value
```harbour
"214 // Ö"
```

---

## CHR_o_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 63)

### ðŸ’Ž Value
```harbour
"246 // ö"
```

---

## CHR_U_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 64)

### ðŸ’Ž Value
```harbour
"220 // Ü"
```

---

## CHR_u_TREM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 65)

### ðŸ’Ž Value
```harbour
"252 // ü"
```

---

## CHR_A_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 66)

### ðŸ’Ž Value
```harbour
"192 // À"
```

---

## CHR_a_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 67)

### ðŸ’Ž Value
```harbour
"224 // à"
```

---

## CHR_E_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 68)

### ðŸ’Ž Value
```harbour
"200 // È"
```

---

## CHR_e_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 69)

### ðŸ’Ž Value
```harbour
"232 // è"
```

---

## CHR_I_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 70)

### ðŸ’Ž Value
```harbour
"204 // Ì"
```

---

## CHR_i_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 71)

### ðŸ’Ž Value
```harbour
"236 // ì"
```

---

## CHR_O_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 72)

### ðŸ’Ž Value
```harbour
"210 // Ò"
```

---

## CHR_o_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 73)

### ðŸ’Ž Value
```harbour
"242 // ò"
```

---

## CHR_U_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 74)

### ðŸ’Ž Value
```harbour
"217 // Ù"
```

---

## CHR_u_CRASE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 75)

### ðŸ’Ž Value
```harbour
"249 // ù"
```

---

## Acentuar
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 77)

---

## AC_AGUDO
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 134)

---

## AC_CRASE
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 149)

---

## AC_TIL
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 162)

---

## AC_CIRC
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 175)

---

## liga_acento
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 186)

---

## Acento
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk54.prg` (line 207)

---

## convansi
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 100)

---

## convoem
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 116)

---

## str2html
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 132)

---

## CAPFIRS2
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 156)

---

## SonumeroX
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 185)

---

## TIRAOUT
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 221)

---

## GRVVAL
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 238)

---

## data2str
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 258)

---

## str2data
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 491)

---

## DifDatas
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 568)

---

## DIGADATA
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 612)

---

## Cmes
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 652)

---

## Mmes
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 667)

---

## Cdia
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 686)

---

## Ddia
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 701)

---

## CTOHORA
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 720)

---

## StrLogic
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 737)

---

## Logic2Str
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 780)

---

## Strval
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 828)

---

## CHOR
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 903)

---

## BHOR
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 919)

---

## geotodec
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 937)

---

## calcgeokm
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 965)

---

## deg2rad
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 990)

---

## rad2deg
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 1000)

---

## MinutoToHora
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 1047)

---

## aconvertend
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 1058)

---

## UniversalToDate
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 1101)

---

## UniversalDateTime
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk55.prg` (line 1241)

---

## TB_UPARROW
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk56.prg` (line 44)

### ðŸ’Ž Value
```harbour
"CHR(024)"
```

---

## TB_DNARROW
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk56.prg` (line 45)

### ðŸ’Ž Value
```harbour
"CHR(025)"
```

---

## TB_BACKGROUND
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk56.prg` (line 46)

### ðŸ’Ž Value
```harbour
"CHR(176)"
```

---

## TB_HIGHLIGHT
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk56.prg` (line 47)

### ðŸ’Ž Value
```harbour
"CHR(178)"
```

---

## TB_ROWTOP
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk56.prg` (line 48)

### ðŸ’Ž Value
```harbour
"1"
```

---

## TB_COLTOP
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk56.prg` (line 49)

### ðŸ’Ž Value
```harbour
"2"
```

---

## TB_ROWBOTTOM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk56.prg` (line 50)

### ðŸ’Ž Value
```harbour
"3"
```

---

## TB_COLBOTTOM
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk56.prg` (line 51)

### ðŸ’Ž Value
```harbour
"4"
```

---

## TB_COLOR
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk56.prg` (line 52)

### ðŸ’Ž Value
```harbour
"5"
```

---

## TB_POSITION
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk56.prg` (line 53)

### ðŸ’Ž Value
```harbour
"6"
```

---

## TB_ELEMENTS
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\disk56.prg` (line 54)

### ðŸ’Ž Value
```harbour
"6"
```

---

## SCROLLBARNEW
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk56.prg` (line 85)

ScrollBarNew( <nTopRow>, <nTopColumn>, <nBottomRow>, <cColorString>, <nInitPosition> ) --> aScrollBar Create a new scroll bar array with the specified coordinates /

---

## SCROLLBARDISPLAY
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk56.prg` (line 136)

ScrollBarDisplay( <aScrollBar> ) --> aScrollBar Display a scoll bar array to the screen /

---

## SCROLLBARUPDATE
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk56.prg` (line 192)

+  ScrollBarUpdate( <aScrollBar>, <nCurrent>, <nTotal>, + +     <lForceUpdate> ) --> aScrollBar + + + +  Update scroll bar array with new tab position and redisplay tab + + + +    Function SCROLLBARUPDATE() + + + +    Called from ( disk56.prg   )   1 - function achretb() + +                ( mlib16.prg   )   1 - function basbro() + + + /

---

## ACHRETB
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk56.prg` (line 257)

---

## editarq
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk57.prg` (line 45)

---

## valcnpj
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk59.prg` (line 51)

---

## VALCGC
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk59.prg` (line 68)

---

## Valcpf
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk59.prg` (line 203)

---

## CNPJ_Novo
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk59.prg` (line 301)

---

## Mod11
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk59.prg` (line 380)

---

## formatacpf
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk59.prg` (line 418)

---

## formatacnpj
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk59.prg` (line 445)

---

## CNPJCPFPICT
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk59.prg` (line 475)

---

## CNPJCPFVAL
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk59.prg` (line 508)

---

## VALCEI
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk59.prg` (line 539)

---

## MascararNumGenerico
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk59.prg` (line 592)

---

## MascaraCNPJ
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk59.prg` (line 639)

---

## MascararNome
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk59.prg` (line 672)

---

## OfuscarDataAleatoria
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk59.prg` (line 712)

---

## MascararCPF
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk59.prg` (line 759)

---

## PEGAPASS
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk63.prg` (line 38)

---

## CheckPass
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk63.prg` (line 119)

---

## TECLAS
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk66.prg` (line 35)

---

## CARDCHEK
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk68.prg` (line 7)

---

## CHECKCTA
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk68.prg` (line 80)

---

## CALCDIG
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk68.prg` (line 169)

---

## DAC10
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk68.prg` (line 172)

---

## GravaCampo
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk70.prg` (line 69)

---

## GravaERRO
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk70.prg` (line 204)

---

## CLRVARS
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk70.prg` (line 234)

---

## EQUVARS
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk70.prg` (line 252)

---

## FREEVARS
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk70.prg` (line 273)

---

## INITVARS
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk70.prg` (line 293)

---

## REPLVARS
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk70.prg` (line 319)

---

## MAKEVAR
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk70.prg` (line 366)

---

## MAKE_EMPTY
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk70.prg` (line 397)

---

## FormataRG
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk71.prg` (line 57)

---

## MascararRG
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk71.prg` (line 155)

---

## CheckRG
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk71.prg` (line 205)

---

## PEGDDD
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk71.prg` (line 357)

---

## PEGTEL
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk71.prg` (line 389)

---

## PEGPREF
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk71.prg` (line 420)

---

## formataTel
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk71.prg` (line 462)

---

## ForTel2
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk71.prg` (line 581)

---

## FormataCEP
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk71.prg` (line 609)

---

## chkufcep
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk71.prg` (line 630)

---

## cep2uf
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk71.prg` (line 654)

---

## FILENAMES
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk72.prg` (line 42)

---

## TIRAEXT
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk72.prg` (line 78)

---

## TROCAEXT
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk72.prg` (line 99)

---

## DELETAARQ
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\disk72.prg` (line 111)

---

## BIF_RETURNONLYFSDIRS
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\escolherpasta.prg` (line 4)

### ðŸ’Ž Value
```harbour
"1   "
```

---

## BIF_NONEWFOLDERBUTTON
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\escolherpasta.prg` (line 5)

### ðŸ’Ž Value
```harbour
"512 "
```

---

## SelectFolder
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\escolherpasta.prg` (line 10)

---

## DomingoDePascoa
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\feriado.prg` (line 49)

---

## TercaDeCarnaval
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\feriado.prg` (line 90)

---

## INFOR  
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\flib04hab.prg` (line 35)

---

## REDEFILE
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\flib04hab.prg` (line 151)

---

## ADJVAL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\f_encode.prg` (line 28)

### ðŸ’Ž Value
```harbour
"30"
```

---

## ENCODE
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_encode.prg` (line 48)

---

## DECODE
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_encode.prg` (line 106)

---

## ENCODEVAL
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_encode.prg` (line 149)

---

## DECODEVAL
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_encode.prg` (line 187)

---

## XDECODE
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_encode.prg` (line 225)

---

## XENCODE
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_encode.prg` (line 248)

---

## XDECDAT
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_encode.prg` (line 271)

---

## ISMEMO
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_ismemo.prg` (line 106)

---

## INFOTIPODBF
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_ismemo.prg` (line 151)

---

## FIELD_ENTRY_SIZE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\f_ismemo.prg` (line 392)

### ðŸ’Ž Value
```harbour
"32   // Size in bytes of a single DBF field descriptor."
```

---

## FIELD_NAME_SIZE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\f_ismemo.prg` (line 393)

### ðŸ’Ž Value
```harbour
"11   // Maximum field name length stored in the descriptor (including null terminator)."
```

---

## GetHeaderInfo
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_ismemo.prg` (line 426)

---

## HEXTABLE
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\f_ismemo.prg` (line 614)

### ðŸ’Ž Value
```harbour
""0123456789ABCDEF""
```

---

## HEX2DEC
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_ismemo.prg` (line 641)

---

## FT_BYT2HEX
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_ismemo.prg` (line 687)

---

## MAKEDBF
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_makedb.prg` (line 32)

---

## f_names
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\f_makedb.prg` (line 48)

### ðŸ’Ž Value
```harbour
"1"
```

---

## f_types
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\f_makedb.prg` (line 49)

### ðŸ’Ž Value
```harbour
"2"
```

---

## f_lens
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\f_makedb.prg` (line 50)

### ðŸ’Ž Value
```harbour
"3"
```

---

## f_decs
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\f_makedb.prg` (line 51)

### ðŸ’Ž Value
```harbour
"4"
```

---

## f_ok
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\f_makedb.prg` (line 52)

### ðŸ’Ž Value
```harbour
"5"
```

---

## parse
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_makedb.prg` (line 634)

---

## MEMOPACK
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_mmopac.prg` (line 51)

---

## READTEXT
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_readtx.prg` (line 42)

---

## wind_rows
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\f_readtx.prg` (line 52)

### ðŸ’Ž Value
```harbour
"(bottom - top) - 1   // window rows"
```

---

## wind_cols
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\f_readtx.prg` (line 53)

### ðŸ’Ž Value
```harbour
"(right - left) - 3   // window columns"
```

---

## TMPFILE
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\f_tempfi.prg` (line 42)

---

## ESCARR
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\mlib16.prg` (line 64)

---

## MEMOVIEW
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\mlib16.prg` (line 87)

---

## DBFVIEW
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\mlib16.prg` (line 111)

---

## FILEVIEWF
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\mlib16.prg` (line 135)

---

## FILEVIEWG
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\mlib16.prg` (line 158)

---

## BASBRO
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\mlib16.prg` (line 182)

---

## fmemoline
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\mlib16.prg` (line 520)

---

## OPCAO
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\mmousen.prg` (line 50)

---

## menu
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\mmousen.prg` (line 76)

---

## PROV_RSA_FULL
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\modeseguranca.prg` (line 1)

### ðŸ’Ž Value
```harbour
"1"
```

---

## CRYPT_VERIFYCONTEXT
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\modeseguranca.prg` (line 2)

### ðŸ’Ž Value
```harbour
"4026531840 // 0xF0000000"
```

---

## CALG_MD5
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\modeseguranca.prg` (line 3)

### ðŸ’Ž Value
```harbour
"32771"
```

---

## CALG_RC2
**Type:** `constant`
**Source:** `c:\develop\harbour\diversos\objmgw\modeseguranca.prg` (line 4)

### ðŸ’Ž Value
```harbour
"26114"
```

---

## parametrosLerDados
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\modeseguranca.prg` (line 8)

---

## ParametrosEnviarDados
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\modeseguranca.prg` (line 29)

---

## CaminhoArquivoCofre
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\modeseguranca.prg` (line 51)

---

## LerDoCofre
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\modeseguranca.prg` (line 56)

---

## GravarNoCofre
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\modeseguranca.prg` (line 111)

---

## ExcluirBanco
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\modeseguranca.prg` (line 150)

---

## netregosok
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 27)

---

## netgrvcam
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 45)

---

## netgrvd
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 65)

---

## netgrvz
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 87)

---

## dbSkipEx
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 108)

---

## netrecapp
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 127)

---

## netrecdel
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 148)

---

## netreclock
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 174)

---

## netrecunlcom
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 198)

---

## netpack
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 209)

---

## netzap
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 228)

---

## NetRegCount
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 245)

---

## netuse
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 269)

---

## zei_fort
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 372)

---

## sdvpegpos
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 427)

---

## sdvarrpos
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 467)

---

## sdvarrcam
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbf.prg` (line 488)

---

## FtsBuscaPorArquivo
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbffts.prg` (line 22)

FtsBuscaPorArquivo: Busca física direta em DBF via FOPEN/FSEEK Utiliza o cálculo estrutural nativo do DBF e suporta filtragem por colunas (aCampos). /

---

## FtsBuscaDbf
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbffts.prg` (line 124)

FtsBuscaDbf: Busca por registro via Alias lógico /

---

## ftshsx
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbffts.prg` (line 179)

ftshsx: Wrapper motor nativo HiPer-SEEK (.hsx) /

---

## RecToStr
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbffts.prg` (line 274)

Converte os campos de um registro atual para String respeitando o filtro aCampos /

---

## FilterFtsBusca
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbffts.prg` (line 303)

Cria macro filtro /

---

## netregosok
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 34)

---

## netgrvcam
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 52)

---

## netgrvd
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 72)

---

## netgrvz
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 94)

---

## dbSkipEx
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 115)

---

## netrecapp
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 134)

---

## netrecdel
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 155)

---

## netreclock
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 181)

---

## netrecunlcom
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 205)

---

## netpack
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 216)

---

## netzap
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 235)

---

## NetRegCount
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 252)

---

## netuse
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 276)

---

## zei_fort
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 458)

---

## sdvpegpos
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 513)

---

## sdvarrpos
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 553)

---

## sdvarrcam
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\netdbfsd3.prg` (line 574)

---

## FILETOPDF
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\pdf.prg` (line 45)

---

## ProfileString
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\profile.prg` (line 50)

---

## SetProfile
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\profile.prg` (line 120)

---

## ProfileNum
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\profile.prg` (line 182)

---

## ProfileDate
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\profile.prg` (line 205)

---

## ProfileLogical
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\profile.prg` (line 238)

---

## ValIE
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\validaie.prg` (line 58)

---

## FormataIE
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\validaie.prg` (line 248)

---

## formataprocesso
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\validaprocesso.prg` (line 83)

---

## validaprocesso
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\validaprocesso.prg` (line 109)

---

## validaPlaca
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\valida_placa.prg` (line 59)

---

## validacnh
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\valida_placa.prg` (line 227)

---

## CheckCNHCat
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\valida_placa.prg` (line 252)

---

## MVINFOConfTela
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\wvgini.prg` (line 44)

---

## xhb_ErrorLog
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\xhberr_mode.prg` (line 102)

---

## ErrorSys
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\xhberr_mode.prg` (line 128)

---

## xhb_ErrorSys
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\xhberr_mode.prg` (line 151)

---

## __ErrorBlock
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\xhberr_mode.prg` (line 848)

---

## __MinimalErrorHandler
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\xhberr_mode.prg` (line 866)

---

## PS_OS_ERR
**Type:** `function`
**Source:** `c:\develop\harbour\diversos\objmgw\xhberr_mode.prg` (line 921)

---

