# DANFE simplificado - etiqueta

Foi adicionado um gerador de DANFE simplificado para NF-e modelo 55.

Ele pega um XML autorizado `nfeProc` ou `NFe` completo e extrai:

- chave de acesso;
- codigo de barras Code128 da chave;
- dados do emitente;
- numero, serie, data e hora da emissao;
- dados do destinatario;
- protocolo de autorizacao;
- valor total da nota.

## Core sem PDF

Disponivel no core:

```harbour
cHtml  := SefazDanfeSimplificadoHtml( cXml )
cTexto := SefazDanfeSimplificadoTexto( cXml )
SefazDanfeSimplificadoSalvarHtml( cXml, "danfe_simplificado.html" )
```

Tambem pode usar pelos metodos da classe:

```harbour
cHtml := oSefaz:DanfeSimplificadoHtml()
oSefaz:DanfeSimplificadoSalvarHtml( "danfe_simplificado.html" )
```

Quando `cXml` nao for informado, a classe usa `cXmlAutorizado`; se estiver vazio, usa `cXmlRetorno`.

## PDF

Disponivel na build completa, com `harupdf` e `hbzebra` instalados:

```harbour
cRet := SefazDanfeSimplificadoPdf( cXml, "danfe_simplificado.pdf" )
```

Se `cRet` for igual ao nome do PDF, gerou corretamente. Caso contrario, `cRet` traz a mensagem de erro.

## Demos

Core/HTML:

```bat
tests\demo_danfe_simplificado_html.exe tests\nfe_teste_danfe_simplificado.xml
```

Build completa/PDF:

```bat
tests\demo_danfe_simplificado.exe tests\nfe_teste_danfe_simplificado.xml
```

O XML `tests\nfe_teste_danfe_simplificado.xml` e apenas massa fake para teste tecnico.

