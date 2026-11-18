# Análise Exploratória de Dados (EDA)
 
## 1. Objetivo desta Etapa
 
Antes da modelagem, esta etapa tem como objetivo **entender a estrutura, a completude e a qualidade** dos dados brutos filtrados em `Dataset_novo_V3.csv`, identificando tratamentos necessários (formato numérico, valores ausentes, granularidade temporal) antes da modelagem.
 
**Perguntas norteadoras desta EDA:**
- Qual é a granularidade real do arquivo (linhas, colunas, período coberto)?
- Os 3 pontos de coleta (BILL02900, BIRP00500, CFUG02900) têm cobertura temporal comparável?
- Quais parâmetros têm dados ausentes e em que magnitude?
- Os 7 parâmetros do IQA de maior peso estão completos o suficiente para a modelagem?
- Que tratamentos de limpeza são necessários antes da modelagem?
**Problema de modelagem:** prever os 7 parâmetros do IQA no ponto de jusante **CFUG02900**, a partir dos mesmos 7 parâmetros nos pontos de montante **BILL02900** e **BIRP00500**. Os montantes entram como a média dos dois valores. Não é calculado o IQA.
 
---
 
## 2. Estrutura do Arquivo
 
| Item | Valor |
|---|---|
| Dimensões | 48 linhas × 32 colunas |
| Formato dos dados | **Largo (wide)**: cada parâmetro está em uma coluna e cada linha representa uma coleta |
| Pontos de coleta | 3 — `BILL02900`, `BIRP00500`, `CFUG02900` (Complexo Billings) |
| Coletas por ponto | 16 cada (48 no total) |
| Período coberto | 15/03/2022 a 17/12/2025, aproximadamente trimestral |
| Status Ponto | todas as linhas = `Ativo` |
| Colunas técnicas/estruturais | `Cod_Interaguas`, `Código Ponto`, `Status Ponto`, `Data Coleta`, `Hora Coleta` |
| Colunas sem nome | 2 colunas vazias, a descartar |
| Colunas auxiliares | `Oxige. adaptado`, `ph adap`, `DBO adap`: derivadas e quase vazias, **não usar** |
| Colunas de parâmetros | 22 parâmetros físico-químicos, de nutrientes, clorofila e metais |
 
> **Observação:** o arquivo já está pivotado. Cada parâmetro está em uma coluna, então não é preciso transformar linhas em colunas.
 
---
 
## 3. Cobertura Temporal por Ponto
 
| Ponto | Município | Primeira coleta | Última coleta | Nº de coletas |
|---|---|---|---|---|
| BILL02900 | Não informado no arquivo | 15/03/2022 | 03/12/2025 | 16 |
| BIRP00500 | Não informado no arquivo | 15/03/2022 | 17/12/2025 | 16 |
| CFUG02900 | Não informado no arquivo | 31/03/2022 | 02/12/2025 | 16 |
 
A cobertura é **balanceada entre os três pontos**, com as mesmas 16 janelas de coleta por ponto. A diferença entre as datas pareadas é de 1 a 42 dias. Em 3 campanhas (2022-10, 2024-06 e 2025-10), a diferença entre CFUG02900 e um dos montantes passa de 30 dias.
 
> **Nota:** o arquivo não informa o município de cada ponto. Os três pertencem ao Complexo Billings, e a identificação municipal fica pendente.
 
---
 
## 4. Qualidade dos Dados
 
### 4.1 Formato numérico
Todos os parâmetros, exceto `Chuvas nas últimas 24h 0/1` (binária), estão armazenados como **texto com vírgula decimal** (ex.: `"6,14"`). É necessário `str.replace(',', '.')` seguido de conversão para `float` antes de qualquer cálculo. `Sólido Dissolvido Total` e `Chuvas` já vêm como inteiros.
 
### 4.2 Valores ausentes
 
| Parâmetro | Faltantes (de 48) | Tratamento |
|---|---|---|
| Oxigênio Dissolvido | 0 | — |
| pH | 0 | — |
| Temperatura da água | 0 | — |
| Nitrogênio Total | 0 | — |
| Fósforo Total | 0 | — |
| Turbidez | 0 | — |
| Sólido Dissolvido Total | 0 | — |
| Nitrogênio Kjeldahl | 2 (ambas em CFUG02900) | Não usado diretamente (ver 4.3) |
| DBO (5, 20) | 33 (68,75%) | **Excluído**: 2 dos 3 pontos estão totalmente vazios |
 
Os 7 parâmetros do IQA escolhidos **não têm faltantes**, então não é necessária imputação.
 
Os 7 parâmetros escolhidos somam 0,75 do peso total do IQA (pesos da ANA, soma igual a 1). Ficam de fora **coliformes termotolerantes** (0,15), que não estão no arquivo, e **DBO** (0,10), excluída por faltantes. Fonte dos pesos: [ANA — Indicadores: Índice de Qualidade das Águas](https://www.ana.gov.br/portalpnqa/indicadores-indice-aguas.aspx).
 
### 4.3 Consistência do Nitrogênio Total
`Nitrogênio Total` é igual à soma de Nitrito + Nitrato + Kjeldahl + Amoniacal em 46 das 48 linhas (tolerância de 0,01). As duas exceções são de CFUG02900 em 02/09/2025 e 02/12/2025, onde o Kjeldahl está vazio. **Decisão:** usar a coluna total e não as frações, para evitar multicolinearidade.
 
### 4.4 Perda da informação de censura (`Sinal`)
Não foram encontrados valores com `<` ou `>` na leitura do arquivo. Não foi feita varredura automática, então a conferência fica como pendência. Se houver casos, registrar o tratamento adotado.
 
### 4.5 Colunas técnicas irrelevantes para a modelagem
- `Cod_Interaguas`, `Código Ponto`, `Status Ponto`, `Hora Coleta`: não entram como preditores.
- Duas colunas sem nome e as três `adap`: descartar.
---
 
## 5. Estatísticas Descritivas — 7 Parâmetros do IQA
 
*(valores após conversão para ponto decimal; unidades conforme dicionário de dados)*
 
| Parâmetro | Unidade | Média | Desvio-padrão | Mín | Mediana | Máx |
|---|---|---|---|---|---|---|
| Oxigênio Dissolvido | mg/L | 8,48 | 1,36 | 4,22 | 8,74 | 11,41 |
| pH | U.pH | 7,82 | 0,76 | 6,10 | 7,54 | 9,60 |
| Temperatura da água | °C | 22,37 | 3,00 | 16,00 | 22,05 | 28,80 |
| Nitrogênio Total | mg/L | 1,57 | 0,78 | 0,71 | 1,27 | 4,62 |
| Fósforo Total | mg/L | 0,022 | 0,009 | 0,01 | 0,02 | 0,06 |
| Turbidez | UNT | 6,41 | 5,03 | 2,12 | 5,25 | 30,00 |
| Sólido Dissolvido Total | mg/L | 93,21 | 15,37 | 50 | 100 | 124 |
 
---
 
## 6. Comparação entre Pontos
 
| Parâmetro | BILL02900 | BIRP00500 | CFUG02900 |
|---|---|---|---|
| OD (mg/L) | 8,24 | 7,90 | 9,30 |
| pH | 8,24 | 7,70 | 7,51 |
| Temperatura (°C) | 23,22 | 22,81 | 21,06 |
| Nitrogênio Total (mg/L) | 1,24 | 1,32 | 2,14 |
| Fósforo Total (mg/L) | 0,022 | 0,019 | 0,024 |
| Turbidez (UNT) | 8,77 | 6,98 | 3,47 |
| Sólido Dissolvido (mg/L) | 100,6 | 100,0 | 79,0 |
 
### 6.1 Observação
CFUG02900 é o ponto de jusante e apresenta perfil distinto: maior OD e maior nitrogênio total, e menor turbidez e sólidos. BIRP00500 tem `Sólido Dissolvido Total` constante em 100 mg/L, o que impede calcular correlação para esse parâmetro nesse ponto.
 
Os pontos a observar são:
- Turbidez máxima de 30 UNT em BILL02900 (19/09/2024), e 25 UNT em BIRP00500 na mesma data, ambas com chuva = 0. Podem ser outliers: verificar antes de remover.
- OD mínimo de 4,22 mg/L em BILL02900 (19/03/2025), com pH 7,3 e temperatura 25,7 °C.
---
 
## <h1> Gráficos e métricas </h1>
 
Os gráficos serão gerados em `eda.ipynb`, que depende do CSV `Dataset_novo_V3.csv`.
 
## <h2> Histogramas </h2>
 
Planejados para os 7 parâmetros, geral e por ponto. Ainda não foram gerados. Os resultados serão incluídos aqui após a análise.
 
## <h2> Comparativos </h2>
 
Planejados: boxplots por ponto, séries temporais de OD e pH por ponto, e matriz de correlação dos 7 parâmetros.
 
Correlação de cada parâmetro com o OD (primeira leitura, nos 48 registros):
 
| Parâmetro | r com OD |
|---|---|
| pH | +0,515 |
| Temperatura | −0,375 |
| Sólido Dissolvido Total | −0,243 |
| Nitrogênio Total | +0,176 |
| Fósforo Total | +0,110 |
| Turbidez | +0,004 |
 
## <h2> Modelagem: montantes e jusante </h2>
 
**Pareamento:** coletas pareadas pela sequência de campanhas (1ª com 1ª, 2ª com 2ª, e assim por diante). Resultam 16 linhas, cada uma com os 7 parâmetros de CFUG02900 e a média dos 7 parâmetros de BILL02900 e BIRP00500.
 
**Modelo:** uma regressão linear por parâmetro (7 no total), com um preditor: a média dos montantes para o mesmo parâmetro. R² e RMSE são de validação leave-one-out.
 
| Parâmetro | Coef. (β) | Intercepto | r | R² (dentro da amostra) | p-valor | R² (LOO) | RMSE (LOO) | RMSE (média) |
|---|---|---|---|---|---|---|---|---|
| Oxigênio dissolvido | 0,237 | 7,379 | 0,527 | 0,278 | 0,036 | 0,10 | 0,54 | 0,57 |
| pH | 0,059 | 7,048 | 0,220 | 0,048 | 0,413 | −0,30 | 0,22 | 0,19 |
| Temperatura | 0,792 | 2,840 | 0,726 | 0,528 | 0,001 | 0,40 | 2,30 | 2,97 |
| Nitrogênio total | −0,137 | 2,320 | −0,162 | 0,026 | 0,548 | −1,03 | 0,59 | 0,41 |
| Fósforo total | 0,098 | 0,022 | 0,126 | 0,016 | 0,642 | −0,67 | 0,008 | 0,006 |
| Turbidez | 0,104 | 2,652 | 0,569 | 0,324 | 0,021 | 0,21 | 0,86 | 0,97 |
| Sólidos | −1,067 | 186,0 | −0,066 | 0,004 | 0,809 | −0,15 | 21,0 | 19,6 |
 
**Leitura:**
- **Temperatura:** único parâmetro com previsão útil. R² (LOO) de 0,40 e p-valor de 0,001.
- **Turbidez e OD:** significativos (p = 0,02 e 0,04), mas com R² (LOO) de 0,21 e 0,10. Poder de previsão fora da amostra é fraco.
- **pH, nitrogênio total, fósforo total e sólidos:** não significativos e com R² (LOO) negativo. Não devem ser previstos com esse modelo.
> O RMSE da coluna "média" é o desvio-padrão da resposta sobre todos os dados, levemente favorável ao baseline. A comparação justa usaria a média por leave-one-out.
 
Com 16 pares, esses resultados são pouco estáveis. Turbidez e OD devem ser tratados como indicativos.
 
---
 
## Decisões em aberto
 
1. **Municípios** dos três pontos: não informados no arquivo.
2. **Outliers de turbidez** de 19/09/2024 (30 UNT em BILL02900 e 25 UNT em BIRP00500): manter ou remover?
3. **Varredura de censura** (`<` e `>`): não foi feita de forma automática.
4. **Pontos com datas afastadas** (diferença acima de 30 dias): manter no pareamento ou excluir?
 
