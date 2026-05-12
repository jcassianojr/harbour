# 📘 Documentacao Tecnica do Projeto
> Gerado em: 05/12/26 19:14:07

## 🏗️ Estrutura de Modulos (PRGs)

### 📄 Arquivo: `folharfe.prg`
- Function main()

### 📄 Arquivo: `foresp.prg`
- Function FORES_CY()
- Function MDL()
- Function TABINSS()
- Function TABIRRF()
- Function CALCINSS()
- Function CALCDEPE()
- Function CALCIRRF()
- Function CABE2()
- Function CABE3()
- Function CABEX()
- Function GRAVA2()
- Function FODZER()
- Function ANOSTR()
- Function VALCTA()
- Function VALVAR()
- Function CABEP()
- Function ACUVAR()

### 📄 Arquivo: `fores_a2.prg`
- Function GRAVAREM()

### 📄 Arquivo: `fores_a5.prg`
- Function FOREA5()

### 📄 Arquivo: `fores_a8.prg`
- Function FORESA8()

### 📄 Arquivo: `fores_a9.prg`
- Function tRESA9()
- Function gRESA9()

### 📄 Arquivo: `fores_b2.prg`
- Function CABB2()
- Function CABB22()

### 📄 Arquivo: `fores_b3.prg`
- Function B3X()

### 📄 Arquivo: `fores_b4.prg`
- Function B4XB()
- Function B4XA()
- Function B4X()

### 📄 Arquivo: `fores_b6.prg`
- Function FORESB6A()
- Function FORESB6()

### 📄 Arquivo: `fores_c1.prg`
- Function fores_c1()
- Function GRAVA3()
- Function GRAVAA()
- Function SOMAMES()

### 📄 Arquivo: `fores_c3.prg`
- Function GRAVA4()
- Function GRAVA5()
- Function GRAVA6()
- Function RESTELA()

### 📄 Arquivo: `fores_d1.prg`
- Function fores_d1()

### 📄 Arquivo: `fores_e6.prg`
- Function fores_e6()

### 📄 Arquivo: `fores_e7.prg`
- Function fores_e7()

### 📄 Arquivo: `fores_e9.prg`
- Function fores_e9()

### 📄 Arquivo: `fores_ed.prg`
- Function fores_ed()

### 📄 Arquivo: `fores_ex.prg`
- Function fores_ex()

### 📄 Arquivo: `fores_ez.prg`
- Function CALCEZ01()
- Function CALCEZ02()
- Function CALCEZ03()
- Function CALCEZ04()
- Function CALCEZ05()

## 📊 Dicionario de Dados e Acessos

## 🕸️ Diagrama de Relacionamento (Mermaid)
```mermaid
graph TD
    fores_b3_prg --> acento()        <unresolved function>
    foresp_prg --> acuvar()        in foresp.prg
    folharfe_prg --> ac_agudo()      <unresolved function>
    folharfe_prg --> ac_circ()       <unresolved function>
    folharfe_prg --> ac_crase()      <unresolved function>
    folharfe_prg --> ac_til()        <unresolved function>
    folharfe_prg --> agen()          <unresolved function>
    folharfe_prg --> alertx()        <unresolved function>
    fores_a9_prg --> alltrue()       <unresolved function>
    foresp_prg --> anostr()        in foresp.prg
    fores_b3_prg --> b3x()           in fores_b3.prg
    fores_b4_prg --> b4x()           in fores_b4.prg
    fores_b4_prg --> b4xa()          in fores_b4.prg
    fores_b4_prg --> b4xb()          in fores_b4.prg
    fores_b2_prg --> cabb2()         in fores_b2.prg
    fores_b2_prg --> cabb22()        in fores_b2.prg
    foresp_prg --> cabe2()         in foresp.prg
    fores_a_prg --> cabe3()         in foresp.prg
    fores_c3_prg --> cabep()         in foresp.prg
    fores_c1_prg --> calcdepe()      in foresp.prg
    fores_ez_prg --> calcez01()      in fores_ez.prg
    fores_ez_prg --> calcez02()      in fores_ez.prg
    fores_ez_prg --> calcez03()      in fores_ez.prg
    fores_ez_prg --> calcez04()      in fores_ez.prg
    fores_ez_prg --> calcez05()      in fores_ez.prg
    fores_c1_prg --> calcinss()      in foresp.prg
    fores_c1_prg --> calcirrf()      in foresp.prg
    foresp_prg --> checkimp()      <unresolved function>
    fores_c3_prg --> checkmotdem()   <unresolved function>
    fores_c3_prg --> checktab()      <unresolved function>
    folharfe_prg --> deletaarq()     <unresolved function>
    fores_e7_prg --> editsay()       <unresolved function>
    fores_e7_prg --> equvars()       <unresolved function>
    folharfe_prg --> escolhexi()     <unresolved function>
    fores_e6_prg --> ext()           <unresolved function>
    fores_b1_prg --> filord()        <unresolved function>
    fores_a2_prg --> filtro()        <unresolved function>
    folharfe_prg --> fim()           <unresolved function>
    fores_c1_prg --> fodzer()        in foresp.prg
    fores_a5_prg --> forea5()        in fores_a5.prg
    fores_a8_prg --> foresa8()       in fores_a8.prg
    fores_b6_prg --> foresb6()       in fores_b6.prg
    fores_b6_prg --> foresb6a()      in fores_b6.prg
    folharfe_prg --> foresm()        <unresolved function>
    fores_a1_prg --> foresrg()       <unresolved function>
    fores_a1_prg --> foresrs()       <unresolved function>
    fores_a1_prg --> foresrt()       <unresolved function>
    foresm_prg --> fores_a()       <unresolved function>
    fores_a_prg --> fores_a1()      <unresolved function>
    fores_a_prg --> fores_a2()      <unresolved function>
    fores_a_prg --> fores_a3()      <unresolved function>
    fores_a_prg --> fores_a4()      <unresolved function>
    fores_a_prg --> fores_a5()      <unresolved function>
    fores_a_prg --> fores_a8()      <unresolved function>
    fores_a_prg --> fores_a9()      <unresolved function>
    foresm_prg --> fores_b()       <unresolved function>
    fores_b_prg --> fores_b1()      <unresolved function>
    fores_b_prg --> fores_b2()      <unresolved function>
    fores_b_prg --> fores_b3()      <unresolved function>
    fores_b_prg --> fores_b4()      <unresolved function>
    fores_b_prg --> fores_b5()      <unresolved function>
    fores_b_prg --> fores_b6()      <unresolved function>
    foresm_prg --> fores_c()       <unresolved function>
    fores_c_prg --> fores_c1()      in fores_c1.prg
    fores_c_prg --> fores_c3()      <unresolved function>
    fores_c3_prg --> fores_cx()      <unresolved function>
    fores_a3_prg --> fores_cy()      in foresp.prg
    foresm_prg --> fores_d()       <unresolved function>
    fores_d_prg --> fores_d1()      in fores_d1.prg
    foresm_prg --> fores_e()       <unresolved function>
    fores_e_prg --> fores_e6()      in fores_e6.prg
    fores_e_prg --> fores_e7()      in fores_e7.prg
    fores_e_prg --> fores_e8()      <unresolved function>
    fores_e_prg --> fores_e9()      in fores_e9.prg
    fores_ex_prg --> fores_ea()      <unresolved function>
    fores_ex_prg --> fores_eb()      <unresolved function>
    fores_ex_prg --> fores_ec()      <unresolved function>
    fores_ex_prg --> fores_ed()      in fores_ed.prg
    fores_e_prg --> fores_ex()      in fores_ex.prg
    fores_e_prg --> fores_ez()      <unresolved function>
    fores_c1_prg --> fosfamqtde()    <unresolved function>
    fores_a_prg --> foy2()          <unresolved function>
    fores_a9_prg --> fo_for()        <unresolved function>
    foresp_prg --> graps()         <unresolved function>
    foresp_prg --> grapt()         <unresolved function>
    fores_c1_prg --> grava2()        in foresp.prg
    fores_c1_prg --> grava3()        in fores_c1.prg
    fores_c3_prg --> grava4()        in fores_c3.prg
    fores_c3_prg --> grava5()        in fores_c3.prg
    fores_c3_prg --> grava6()        in fores_c3.prg
    fores_c1_prg --> gravaa()        in fores_c1.prg
    fores_a2_prg --> gravarem()      in fores_a2.prg
    fores_a9_prg --> gresa9()        in fores_a9.prg
    foresm_prg --> hb_dispbox()    in harbour.lib
    folharfe_prg --> hb_idlestate()  in harbour.lib
    folharfe_prg --> hb_langselect() in harbour.lib
    folharfe_prg --> hb_run()        in harbour.lib
    foresp_prg --> hb_scroll()     in harbour.lib
    folharfe_prg --> help()          <unresolved function>
    fores_b1_prg --> impchr()        <unresolved function>
    fores_b1_prg --> impend()        <unresolved function>
    fores_b1_prg --> impfol()        <unresolved function>
    fores_b_prg --> imphp()         <unresolved function>
    fores_b1_prg --> impressora()    <unresolved function>
    fores_b1_prg --> impstr()        <unresolved function>
    folharfe_prg --> infor()         <unresolved function>
    fores_e7_prg --> initvars()      <unresolved function>
    fores_b3_prg --> listarue()      <unresolved function>
    folharfe_prg --> logotipo()      <unresolved function>
    fores_a3_prg --> md()            <unresolved function>
    folharfe_prg --> mdg()           <unresolved function>
    fores_b1_prg --> mdl()           in foresp.prg
    folharfe_prg --> mds()           <unresolved function>
    folharfe_prg --> mdt()           <unresolved function>
    folharfe_prg --> mmes()          <unresolved function>
    folharfe_prg --> mudadata()      <unresolved function>
    folharfe_prg --> mvinfoconftela( <unresolved function>
    foresp_prg --> netgrvcam()     <unresolved function>
    fores_b4_prg --> netpack()       <unresolved function>
    foresp_prg --> netrecapp()     <unresolved function>
    foresp_prg --> netrecdel()     <unresolved function>
    foresp_prg --> netreclock()    in xhb.lib
    folharfe_prg --> netregosok()    <unresolved function>
    folharfe_prg --> netuse()        <unresolved function>
    fores_a3_prg --> nextrec()       <unresolved function>
    folharfe_prg --> nnetwhoami()    <unresolved function>
    folharfe_prg --> notep()         <unresolved function>
    fores_b3_prg --> obter()         <unresolved function>
    fores_a1_prg --> opcao()         <unresolved function>
    fores_a9_prg --> padrao()        <unresolved function>
    folharfe_prg --> pegfolmes()     <unresolved function>
    folharfe_prg --> pegfolpat()     <unresolved function>
    folharfe_prg --> pegfolsen()     <unresolved function>
    fores_b4_prg --> pegrelcta()     <unresolved function>
    fores_c3_prg --> pegvaltab()     <unresolved function>
    fores_c3_prg --> pegvaltip()     <unresolved function>
    fores_a1_prg --> petela()        <unresolved function>
    fores_a3_prg --> prevrec()       <unresolved function>
    foresp_prg --> readcur()       <unresolved function>
    foresrt_prg --> repl()          <unresolved function>
    fores_c3_prg --> restela()       in fores_c3.prg
    fores_a3_prg --> salhm()         <unresolved function>
    fores_c1_prg --> somames()       in fores_c1.prg
    fores_c1_prg --> tabinss()       in foresp.prg
    fores_c1_prg --> tabirrf()       in foresp.prg
    folharfe_prg --> teclas()        <unresolved function>
    fores_e7_prg --> telasay()       <unresolved function>
    folharfe_prg --> tele()          <unresolved function>
    fores_e6_prg --> tiraout()       <unresolved function>
    fores_a9_prg --> tresa9()        in fores_a9.prg
    fores_c1_prg --> valcta()        in foresp.prg
    foresp_prg --> valvar()        in foresp.prg
    fores_b4_prg --> verseha()       <unresolved function>
    fores_b1_prg --> video()         in hbct.lib
    foresp_prg --> zei_fort()      <unresolved function>
    folharfe_prg --> __setcentury()  <unresolved function>
```
