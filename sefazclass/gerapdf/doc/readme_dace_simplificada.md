# Gerador de DACE Resumida em PDF com Harbour e LibHaru 📄🚀

Este projeto é uma ferramenta de alto desempenho desenvolvida em **Harbour** para a geração automática e homologada do documento **DACE Resumida** (Declaração Auxiliar de Conteúdo Eletrônica) em formato PDF. 

O sistema realiza o parsing direto do arquivo XML de distribuição da DACE, formata e mascara os dados de forma inteligente (respeitando as regras de privacidade e a LGPD) e renderiza dinamicamente o documento em milímetros (conversão direta para pontos PDF).

---

## 🌟 Principais Recursos

* **Renderização Vetorial:** Desenho preciso de tabelas, contornos e blocos cinzas de destaque usando a biblioteca nativa **LibHaru**.
* **Integração com HB_ZEBRA:** Geração e posicionamento dinâmico de **QR Code** de homologação em tempo real no PDF.
* **Sistema de Coordenadas em Milímetros:** Conversão matemática transparente de milímetros para pontos PDF, facilitando o design do layout.
* **Mascaramento Dinâmico Inteligente:** * Aplicação de máscaras dinâmicas diferenciadas para CPF/CNPJ de Remetente (`CPF: 123.******-89` e `CNPJ: 99.999.999/9999-99`).
  * Máscara específica homologada de privacidade para CPF de Destinatário (`CPF: 123.***.***-89`).
* **Tratamento de Strings Avançado:** Conversão de strings UTF-8 para PTISO (ANSI) garantindo a integridade dos caracteres acentuados nas observações do DACE.

---

## 📊 Estrutura Visual da DACE Resumida (Demo do Layout)

Abaixo, uma representação lógica de como o layout do PDF é estruturado pelo código:
```text
+---------------------------------------------------------------------------+
|         DACE RESUMIDA - DECLARAÇÃO AUXILIAR DE CONTEÚDO ELETRÔNICA        |
+---------------------------------------------------------------------------+
|  Nº 007.222.294   SÉRIE: 025                                              |
|  DATA DE EMISSÃO: 2026-07-13T12:47:35-03:00                               |
|  PROTOCOLO DE AUTORIZAÇÃO: 3352600058739999                               |
|  MODALIDADE DO TRANSPORTE: 0-CORREIOS                                     |
+---------------------------------------------------------------------------+
|  CNPJ/CPF REMETENTE: 054.******-79                                        |
|  NOME REMETENTE: marcelo antonio lazzaro carli                            |
|  CIDADE-UF: Marília-SP                                                    |
|  ENDEREÇO: Rua Andre Martins Parra, 123 - Jardim Colibri - CEP: 17514-260 |
+---------------------------------------------------------------------------+
|  CNPJ/CPF DESTINATÁRIO: 137.******-88                                     |
|  NOME DESTINATÁRIO: Fulano de Tal                                         |
|  CIDADE-UF: Morello - ES                                                  |
|  ENDEREÇO: Rua do Sossego, 0 sn - zona rural - CEP: 29723-000             |
+---------------------------------------------------------------------------+
|  CNPJ FISCO/MARKETPLACE: 16.922.038/0001-51                               |
|  NOME: Enjoei S.A.                                                        |
+-----------------+---------------------------------------------------------+
|                 | É contribuinte de ICMS qualquer pessoa física...        |
|   [ QR CODE ]   |                                                         |
|                 | Constitui crime contra a ordem tributária...            |
+-----------------+---------------------------------------------------------+
|                          Chave de Acesso DC-e                             |
|         3526 0716 9220 3800 0151 9902 5007 2222 9411 1234 4321            |
+---------------------------------------------------------------------------+
---
```
## 🛠️ Pré-requisitos e Dependências

Para compilar e executar este gerador de PDF, certifique-se de ter instalado e configurado em seu ambiente Harbour:

1. **Compilador Harbour** (3.2.0 ou superior)
2. **Biblioteca LibHaru (hpdf)** (Geração de PDFs nativos)
3. **Biblioteca hb_zebra** (Para renderização de códigos de barras e QR Codes)

2. Compilar o Projeto
Para compilar utilizando o utilitário hbmk2, execute:
```
call c:\minigui\batch\compile.bat Demo_dace_simplificada /L hbhpdf /L hbzebra
```
3. Rodar os Testes
Chame a função principal passando o arquivo XML de teste fornecido neste repositório:
Snippet de código
```
DCe("teste_dace.xml")
```

💡 Destaques de Código e Soluções Engenhosas
Conversão Milimétrica para PDF (MM_X e MM_Y)
A LibHaru utiliza pontos tipográficos (points) baseados em polegadas como unidade padrão. Para facilitar o desenho técnico, criamos uma camada matemática estática que traduz milímetros de uma régua comum direto para as coordenadas exatas da folha A4:

```
Snippet de código
Static Function MM_X( nCol )
Return nCol * 2.834645669

Static Function MM_Y( nRow, nHeight )
Return nHeight - ( nRow * 2.834645669 )
```
Máscaras inline seguras com iif
O parser extrai a tag do XML e escolhe em tempo de execução a formatação ideal para proteger as informações sensíveis:
```
Snippet de código
DrawText( hPdf, hPage, 055, 105, "CNPJ/CPF DESTINATÁRIO: " + ;
iif( !Empty( XmlNode( XmlNode(cXml, [dest]), [CPF] ) ), ;
Left( XmlNode( XmlNode(cXml, [dest]), [CPF] ), 3 ) + ".******-" + Right( XmlNode( XmlNode(cXml, [dest]), [CPF] ), 2 ), ;
iif( !Empty( XmlNode( XmlNode(cXml, [dest]), [CNPJ] ) ), ;
Transf( XmlNode( XmlNode(cXml, [dest]), [CNPJ] ), "@R 99.999.999/9999-99" ), "" ) ), ;
"Helvetica", 7.5, .T., .F., nHeight )
```
📄 Licença
Este projeto está sob a licença MIT. Consulte o arquivo LICENSE para obter mais detalhes.

