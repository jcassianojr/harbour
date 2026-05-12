# 📘 Documentacao Tecnica do Projeto
> Gerado em: 05/12/26 19:03:55

## 🏗️ Estrutura de Modulos (PRGs)

### 📄 Arquivo: `cepruaimp.prg`
- Function main()
- Function tratacidade()
- Function idbairro()
- Function vertxt()

### 📄 Arquivo: `cepwebvia.prg`
- Function Main()
- Function FormataCEP()
- Function GRAVARUANAO()
- Function GRAVARUAIMP()
- Procedure CepRepublica()
- Function AppVersaoExe()
- Function AppUserName()
- Function CEPapicEp()
- Function cepapiawe()
- Function pegnodojason()
- Function cepWeb()
- Create Class ViaCEP()
- Function CEPBrasilAberto()
- Function CEPOpenCep()
- Function CEPBrasilApi()
- Function OpenCepjason()

### 📄 Arquivo: `convcep.prg`
- Function main()
- Function JasonCountry()
- Function pegnodojason()
- Function help()
- Function cidconvinc()

## 📊 Dicionario de Dados e Acessos

**Fonte:** `cepruaimp.prg`
> Tables: use cepruaerr new exclusive
> use cepruaimp new exclusive
> dbusearea(.T.,"DBFCDX",cARQUIVO,,.T.)
> dbusearea(.T.,"DBFCDX",cARQRUA,,.T.)
> dbusearea(.T.,"DBFCDX",cARQGEO,,.T.)
> Indexes: index on UF+CIDADE+CEP tag ufcidade
> index on RUA tag &cARQRUA.1
> index on CEP tag &cARQRUA.2
> index on CEP tag &cARQGEO.1

**Fonte:** `cepwebvia.prg`
> Tables: use cepruaimp new exclusive
> dbusearea(.T.,"DBFCDX",cFILECEP,,.F.)
> Indexes: index on CEP tag cep

**Fonte:** `convcep.prg`
> Tables: use md10imp new exclusive
> use ce_f new exclusive
> use md10imp new shared
> Indexes: index on RUA tag &cFILECEP.1 EVAL ZEI_FORT(nLASTREC,,,1)
> index on CEP tag &cFILECEP.2 EVAL ZEI_FORT(nLASTREC,,,1)
> index on RUA tag &cARQRUA.1 EVAL ZEI_FORT(nLASTREC,,,1)
> index on CEP tag &cARQRUA.2 EVAL ZEI_FORT(nLASTREC,,,1)

## 🕸️ Diagrama de Relacionamento (Mermaid)
```mermaid
graph TD
    convcep_prg --> flinecount()    in xhb.lib
    convcep_prg --> hb_langselect() in harbour.lib
    convcep_prg --> jasoncountry()  in convcep.prg
    convcep_prg --> mdg()           <unresolved function>
    convcep_prg --> mvinfoconftela( <unresolved function>
    convcep_prg --> netgrvcam()     <unresolved function>
    convcep_prg --> netgrvz()       <unresolved function>
    convcep_prg --> netpack()       <unresolved function>
    convcep_prg --> netrecapp()     <unresolved function>
    convcep_prg --> netrecdel()     <unresolved function>
    convcep_prg --> netreclock()    in xhb.lib
    convcep_prg --> netregosok()    <unresolved function>
    convcep_prg --> netuse()        <unresolved function>
    convcep_prg --> pegcidconv()    <unresolved function>
    convcep_prg --> zei_fort()      <unresolved function>
```
