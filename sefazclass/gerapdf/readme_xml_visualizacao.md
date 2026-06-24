# XML Viewer Harbour

Modulo separado para visualizar XML dentro do sistema, sem abrir navegador externo.

Ele segue a ideia visual do navegador:

- cabecalho informando que o XML nao possui estilo;
- linha separadora;
- XML indentado em formato de arvore;
- tags coloridas quando usado em controle HTML interno.

## Funcoes

Retorna HTML pronto para um WebBrowser/WebView interno:

```harbour
cHtml := SefazXmlVisualizacaoHtml( cXml )
```

Retorna texto indentado para MemoEdit/RichEdit/painel proprio:

```harbour
cTexto := SefazXmlVisualizacaoTexto( cXml )
```

Tambem aceita caminho de arquivo:

```harbour
cHtml := SefazXmlVisualizacaoHtml( "retorno.xml" )
```

Salvar a visualizacao:

```harbour
SefazXmlVisualizacaoSalvarHtml( cXml, "visualizacao_xml.html" )
SefazXmlVisualizacaoSalvarTexto( cXml, "visualizacao_xml.txt" )
```

## Importante

Nenhuma funcao abre navegador, executa `ShellExecute`, chama `start` ou usa programa externo.

O sistema que consome a funcao decide onde mostrar:

- WebBrowser interno;
- WebView interno;
- RichEdit;
- MemoEdit;
- grid/arvore propria.

## Demo

```bat
compilar.bat
demo_xml_visualizacao.exe
```

O demo apenas gera arquivos de exemplo e nao abre nada fora do sistema.

