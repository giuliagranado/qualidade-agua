## Explicação do Código — Regressão Logística (IQA × Chuva)

### 1. Carregamento e separação dos dados

O CSV é lido com separador `;`. A coluna 75 contém a variável binária chuva (0/1) e a coluna 29 contém o pH — ambas extraídas para cada cidade nas mesmas fatias de 16 observações já conhecidas: Bertioga (1–16)(BERTchuva e BERTPH), Cubatão (17–32)(CUBAchuva e CUBAPH) e Santos (33–48)(SANTchuva e SANTPH).

---

### 2. A função `plots()` — regressão logística aplicada

A função recebe a variável binária (`bin`), o preditor contínuo (`desc`) e o número de pontos da curva (`n`), e executa exatamente a sequência do anexo:

Ajuste com `glm(..., family = binomial)` — é o comando central da aula. Como o anexo explica, `family = binomial` é o que diz ao R "regressão logística". Os coeficientes retornados estão na escala do logit; por isso `exp(coef(m))` converte para razão de chances (cada +1 em pH multiplica as chances de chuva por esse fator).

Gráfico com três camadas, seguindo o padrão do slide 5 do anexo:
- Pontos azuis (`pch = 19, col = cazul`) — os dados brutos 0/1;
- Reta verde tracejada (`abline(lm(...))`) — a tentativa linear que o anexo mostra como inadequada, pois prevê valores fora de (0, 1);
- Curva laranja sigmoidal (`lines(..., type = "response")`) — a logística que respeita os limites, gerada com `predict(..., type = "response")`. O anexo alerta que sem `type = "response"` o `predict` devolve o logit, não a probabilidade.

As linhas horizontais cinzas em 0 e 1 (`abline(h = c(0,1))`) delimitam visualmente o intervalo válido de probabilidade.

---

### 3. Aplicação por cidade e geral

`plots()` é chamada quatro vezes: uma para cada cidade e uma com todos os 48 pontos combinados — permitindo comparar se o efeito do pH sobre a ocorrência de chuva varia entre Bertioga, Cubatão e Santos, ou se há um padrão geral.

---

### 4. Conclusão do código

Como variavel binária foi escolhida a chuva, transformada de sim e não para 0 e 1, e como variável target foi escolhido PH
foi feita a regressão para cada cidade e para o todo também e em todas as situações a linha da regressão não foi adequado
ao esperado, se mostrando uma linha segmentado com quedas e ascenções
