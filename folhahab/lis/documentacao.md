# 📘 Documentacao Tecnica do Projeto
> Gerado em: 05/12/26 19:11:19

## 🏗️ Estrutura de Modulos (PRGs)

### 📄 Arquivo: `foldirf.prg`
- Function DIRFPEGDAD()
- Function DIRFREG01()
- Function DIRFREG02()

### 📄 Arquivo: `folhalis.prg`
- Function main()

### 📄 Arquivo: `folisp.prg`
- Function TABINSS()
- Function TABIRRF()
- Function CALCDEPE()
- Function CALCIRRF()
- Function GRAVA2()
- Function FODZER()
- Function CABE2()
- Function CABE3()
- Function CERTEZA()
- Function MDL()
- Function VALCTA()
- Function CABEX()

### 📄 Arquivo: `folis_a1.prg`
- Function folis_a1()

### 📄 Arquivo: `folis_a7.prg`
- Function DIRFEMPDAD()

### 📄 Arquivo: `folis_b1.prg`
- Function folis_b1()
- Function VALVAR()

### 📄 Arquivo: `folis_b4.prg`
- Function folis_b4()

### 📄 Arquivo: `folis_c1.prg`
- Function FOLISC1B()
- Function FOLISC1A()
- Function FOLISC1()

### 📄 Arquivo: `folis_c2.prg`
- Function folis_c2()
- Function CABVAR()

### 📄 Arquivo: `folis_c4.prg`
- Function ANOSTR()
- Function FOLISC41()

### 📄 Arquivo: `folis_c6.prg`
- Function folis_c6()
- Function IMPINFO()
- Function IRRFTEL()
- Function IRRFGET()

### 📄 Arquivo: `folis_c7.prg`
- Function FOLISD5()
- Function D55()
- Function D5X()
- Function PEGVALD5X()

### 📄 Arquivo: `folis_c9.prg`
- Function CABRAIS()

### 📄 Arquivo: `folis_cc.prg`
- Function FOLISCC01()

### 📄 Arquivo: `folis_cd.prg`
- Function FOLISCD()
- Function FOLISCD01()

### 📄 Arquivo: `folis_d1.prg`
- Function folis_d1()
- Function FOLISD1SAY()

### 📄 Arquivo: `folis_d2.prg`
- Function gFOLISD2()
- Function tFOLISD2()

### 📄 Arquivo: `folis_d3.prg`
- Function VAREDIT()

### 📄 Arquivo: `folis_da.prg`
- Function IMPDA()

### 📄 Arquivo: `folis_dc.prg`
- Function gDC()
- Function iDC02()

### 📄 Arquivo: `follib01.prg`
- Function ARQIRR()
- Function IRRESC()

## 📊 Dicionario de Dados e Acessos

## 🕸️ Diagrama de Relacionamento (Mermaid)
```mermaid
graph TD
    folis_c1_prg --> acento()        <unresolved function>
    foldirf_prg --> acepad()        <unresolved function>
    folhalis_prg --> ac_agudo()      <unresolved function>
    folhalis_prg --> ac_circ()       <unresolved function>
    folhalis_prg --> ac_crase()      <unresolved function>
    folhalis_prg --> ac_til()        <unresolved function>
    folhalis_prg --> agen()          <unresolved function>
    folhalis_prg --> alertx()        <unresolved function>
    folis_c5_prg --> alltrue()       <unresolved function>
    folis_c4_prg --> anostr()        in folis_c4.prg
    folis_a4_prg --> arqirr()        in follib01.prg
    folis_a6_prg --> bacennacion()   <unresolved function>
    folisp_prg --> cabe2()         in folisp.prg
    folisp_prg --> cabe3()         in folisp.prg
    folis_c9_prg --> cabrais()       in folis_c9.prg
    folis_c2_prg --> cabvar()        in folis_c2.prg
    folis_b1_prg --> calcdepe()      in folisp.prg
    folis_b1_prg --> calcirrf()      in folisp.prg
    folis_b1_prg --> certeza()       in folisp.prg
    folis_d1_prg --> checkadm()      <unresolved function>
    folis_c5_prg --> checkbacen()    <unresolved function>
    folis_c5_prg --> checkcid()      <unresolved function>
    folis_d1_prg --> checkctps()     <unresolved function>
    foldirf_prg --> checkemail()    <unresolved function>
    folis_d1_prg --> checkfgts()     <unresolved function>
    folisp_prg --> checkimp()      <unresolved function>
    folis_d1_prg --> checkmotdem()   <unresolved function>
    folis_d1_prg --> checkserie()    <unresolved function>
    folis_c5_prg --> checktab()      <unresolved function>
    folis_d2_prg --> chkufcep()      <unresolved function>
    follib01_prg --> clsbox()        <unresolved function>
    folism_prg --> clscor()        <unresolved function>
    folism_prg --> clsrow()        <unresolved function>
    folis_cc_prg --> cmes()          <unresolved function>
    foldirf_prg --> cnpjcpfpict()   <unresolved function>
    foldirf_prg --> cnpjcpfval()    <unresolved function>
    folis_d1_prg --> corrigefo_pes() <unresolved function>
    folis_c7_prg --> d55()           in folis_c7.prg
    folis_c7_prg --> d5x()           in folis_c7.prg
    folis_d1_prg --> dbskipex()      <unresolved function>
    folhalis_prg --> deletaarq()     <unresolved function>
    folis_a7_prg --> dirfempdad()    in folis_a7.prg
    folis_a7_prg --> dirfpegdad()    in foldirf.prg
    folis_a7_prg --> dirfreg01()     in foldirf.prg
    folis_a7_prg --> dirfreg02()     in foldirf.prg
    folis_d7_prg --> dirmake()       in hbct.lib
    folis_dc_prg --> editpeg()       <unresolved function>
    folis_dc_prg --> editsay()       <unresolved function>
    folis_a2_prg --> eom()           in hbct.lib
    folhalis_prg --> escolhexi()     <unresolved function>
    folis_a2_prg --> filecopy()      in hbct.lib
    folis_d7_prg --> filenames()     <unresolved function>
    folis_c1_prg --> filord()        <unresolved function>
    folis_a2_prg --> filtro()        <unresolved function>
    folhalis_prg --> fim()           <unresolved function>
    folis_d_prg --> fo7w()          <unresolved function>
    folis_b1_prg --> fodzer()        in folisp.prg
    folis_c1_prg --> folisc1()       in folis_c1.prg
    folis_c1_prg --> folisc1a()      in folis_c1.prg
    folis_c1_prg --> folisc1b()      in folis_c1.prg
    folis_c4_prg --> folisc41()      in folis_c4.prg
    folis_cc_prg --> foliscc01()     in folis_cc.prg
    folis_cd_prg --> foliscd()       in folis_cd.prg
    folis_cd_prg --> foliscd01()     in folis_cd.prg
    folis_d1_prg --> folisd1say()    in folis_d1.prg
    folis_c7_prg --> folisd5()       in folis_c7.prg
    folhalis_prg --> folism()        <unresolved function>
    folism_prg --> folis_a()       <unresolved function>
    folis_a_prg --> folis_a1()      in folis_a1.prg
    folis_a_prg --> folis_a2()      <unresolved function>
    folis_a_prg --> folis_a3()      <unresolved function>
    folis_a_prg --> folis_a4()      <unresolved function>
    folis_a_prg --> folis_a5()      <unresolved function>
    folis_a_prg --> folis_a6()      <unresolved function>
    folis_a_prg --> folis_a7()      <unresolved function>
    folis_a_prg --> folis_a8()      <unresolved function>
    folism_prg --> folis_b()       <unresolved function>
    folis_b_prg --> folis_b1()      in folis_b1.prg
    folis_b_prg --> folis_b4()      in folis_b4.prg
    folism_prg --> folis_c()       <unresolved function>
    folis_c_prg --> folis_c1()      <unresolved function>
    folis_c_prg --> folis_c2()      in folis_c2.prg
    folis_c_prg --> folis_c4()      <unresolved function>
    folis_c_prg --> folis_c5()      <unresolved function>
    folis_a4_prg --> folis_c6()      in folis_c6.prg
    folis_c_prg --> folis_c7()      <unresolved function>
    folis_c_prg --> folis_c8()      <unresolved function>
    folis_c_prg --> folis_ca()      <unresolved function>
    folis_c_prg --> folis_cb()      <unresolved function>
    folis_c_prg --> folis_cc()      <unresolved function>
    folis_c_prg --> folis_cd()      <unresolved function>
    folis_c_prg --> folis_ce()      <unresolved function>
    folism_prg --> folis_d()       <unresolved function>
    folis_a6_prg --> folis_d1()      in folis_d1.prg
    folis_a6_prg --> folis_d2()      <unresolved function>
    folis_d_prg --> folis_d3()      <unresolved function>
    folis_d_prg --> folis_d6()      <unresolved function>
    folis_d_prg --> folis_d7()      <unresolved function>
    folis_d_prg --> folis_d9()      <unresolved function>
    folis_d_prg --> folis_da()      <unresolved function>
    folis_d_prg --> folis_dc()      <unresolved function>
    folis_b1_prg --> fosfamqtde()    <unresolved function>
    folis_d_prg --> foy2()          <unresolved function>
    folis_d_prg --> fo_for()        <unresolved function>
    folis_dc_prg --> gdc()           in folis_dc.prg
    folis_d2_prg --> gfolisd2()      in folis_d2.prg
    folis_b1_prg --> grava2()        in folisp.prg
    foldirf_prg --> grvval()        <unresolved function>
    folhalis_prg --> hb_cwd()        in harbour.lib
    foldirf_prg --> hb_dispbox()    in harbour.lib
    folhalis_prg --> hb_idlestate()  in harbour.lib
    folis_d3_prg --> hb_keyclear()   in harbour.lib
    folhalis_prg --> hb_langselect() in harbour.lib
    folhalis_prg --> hb_run()        in harbour.lib
    folis_c8_prg --> hb_scroll()     in harbour.lib
    folhalis_prg --> help()          <unresolved function>
    folis_dc_prg --> idc02()         in folis_dc.prg
    folis_a6_prg --> imparq()        <unresolved function>
    folis_c1_prg --> impchr()        <unresolved function>
    folis_da_prg --> impda()         in folis_da.prg
    folis_c2_prg --> impend()        <unresolved function>
    folis_c1_prg --> impfol()        <unresolved function>
    folis_c_prg --> imphp()         <unresolved function>
    folis_c6_prg --> impinfo()       in folis_c6.prg
    folis_d_prg --> imprais()       <unresolved function>
    folis_c4_prg --> impressora()    <unresolved function>
    folis_c1_prg --> impstr()        <unresolved function>
    folhalis_prg --> infor()         <unresolved function>
    folis_a4_prg --> irresc()        in follib01.prg
    folis_c6_prg --> irrfget()       in folis_c6.prg
    folis_c6_prg --> irrftel()       in folis_c6.prg
    folis_c1_prg --> listarue()      <unresolved function>
    folhalis_prg --> logotipo()      <unresolved function>
    folis_a3_prg --> md()            <unresolved function>
    folhalis_prg --> mdg()           <unresolved function>
    folis_c1_prg --> mdl()           in folisp.prg
    folhalis_prg --> mds()           <unresolved function>
    folhalis_prg --> mdt()           <unresolved function>
    folhalis_prg --> mmes()          <unresolved function>
    folhalis_prg --> mudadata()      <unresolved function>
    folhalis_prg --> mvinfoconftela( <unresolved function>
    folis_a1_prg --> netgrvcam()     <unresolved function>
    folis_a2_prg --> netpack()       <unresolved function>
    folisp_prg --> netrecapp()     <unresolved function>
    folisp_prg --> netrecdel()     <unresolved function>
    folisp_prg --> netreclock()    in xhb.lib
    folis_a1_prg --> netregcount()   <unresolved function>
    folhalis_prg --> netregosok()    <unresolved function>
    folhalis_prg --> netuse()        <unresolved function>
    folis_a1_prg --> netzap()        <unresolved function>
    folis_d1_prg --> nextrec()       <unresolved function>
    folhalis_prg --> nnetwhoami()    <unresolved function>
    folis_d7_prg --> nobreak()       <unresolved function>
    folhalis_prg --> notep()         <unresolved function>
    folis_a3_prg --> obter()         <unresolved function>
    follib01_prg --> opcao()         <unresolved function>
    folis_d_prg --> padrao()        <unresolved function>
    folis_b1_prg --> peg13()         <unresolved function>
    folis_dc_prg --> pegchave()      <unresolved function>
    folhalis_prg --> pegfolmes()     <unresolved function>
    folhalis_prg --> pegfolpat()     <unresolved function>
    folhalis_prg --> pegfolsen()     <unresolved function>
    folis_c1_prg --> pegrelcta()     <unresolved function>
    folis_c7_prg --> pegvald5x()     in folis_c7.prg
    folis_a2_prg --> petela()        <unresolved function>
    foldirf_prg --> pict()          <unresolved function>
    folis_d1_prg --> prevrec()       <unresolved function>
    foldirf_prg --> readcur()       <unresolved function>
    folis_a3_prg --> repl()          <unresolved function>
    folis_a2_prg --> salhm()         <unresolved function>
    folis_b1_prg --> tabinss()       in folisp.prg
    folis_b1_prg --> tabirrf()       in folisp.prg
    folhalis_prg --> teclas()        <unresolved function>
    folhalis_prg --> tele()          <unresolved function>
    folis_d2_prg --> tfolisd2()      in folis_d2.prg
    folis_a6_prg --> tirace()        <unresolved function>
    folis_a3_prg --> tiraout()       <unresolved function>
    folis_dc_prg --> ultimoreg()     <unresolved function>
    foldirf_prg --> valcpf()        <unresolved function>
    folis_a3_prg --> valcta()        in folisp.prg
    folis_d1_prg --> valpis()        <unresolved function>
    folis_b1_prg --> valvar()        in folis_b1.prg
    foldirf_prg --> verseha()       <unresolved function>
    folis_a6_prg --> vertxt()        <unresolved function>
    folis_c2_prg --> video()         in hbct.lib
    folis_a1_prg --> zei_fort()      <unresolved function>
    folhalis_prg --> __setcentury()  <unresolved function>
```
