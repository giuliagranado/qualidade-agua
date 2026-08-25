# Análise Exploratória de Dados (EDA)

## 1. Objetivo desta Etapa

Antes de calcular o IQA e treinar o modelo de classificação, esta etapa tem como objetivo **entender a estrutura, a completude e a qualidade** dos dados brutos filtrados em `Dataset.xlsx`, identificando tratamentos necessários (formato numérico, valores ausentes, granularidade temporal) antes da modelagem.

**Perguntas norteadoras desta EDA:**
- Qual é a granularidade real do arquivo (linhas, colunas, período coberto)?
- Os 3 pontos de coleta (Santos, Cubatão, Bertioga) têm cobertura temporal comparável?
- Quais parâmetros têm dados ausentes e em que magnitude?
- Os 9 parâmetros que compõem o IQA estão completos o suficiente para o cálculo?
- Que tratamentos de limpeza são necessários antes da próxima etapa (cálculo do IQA)?

---

## 2. Estrutura do Arquivo

| Item | Valor |
|---|---|
| Dimensões | 48 linhas × 132 colunas |
| Formato dos dados | **Largo (wide)** — diferente do formato longo da extração bruta do Infoáguas; os dados já vêm pivotados, com cada parâmetro em uma coluna e cada linha representando uma coleta |
| Pontos de coleta | 3 — `IPAU02600` (Bertioga), `CUBA02700` (Cubatão), `SABO22500` (Santos) |
| Coletas por ponto | 16 coletas cada (48 no total) |
| Período coberto | 17/03/2022 a 09/12/2025, aproximadamente trimestral |
| Colunas técnicas/estruturais | `Cod_Interaguas`, `Código Ponto`, `Status Ponto`, `Data Coleta`, `Hora Coleta`, `Sistema Hídrico`, `CLASSE`, `Município`, `UF`, `Latitude`, `Longitude`, `Altitude`, `Localização`, `Captação` |
| Colunas de parâmetros | ~118 parâmetros físico-químicos, microbiológicos e ecotoxicológicos |

> **Observação:** ao contrário do que a documentação geral do projeto descreve para a extração bruta (formato longo, exigindo pivotagem), este arquivo já foi pivotado previamente. Isso significa que o passo de "transformar `Parametro` em colunas" **já está feito** — o que resta é selecionar e tratar as colunas relevantes ao IQA.

---

## 3. Cobertura Temporal por Município

| Município | Ponto | Primeira coleta | Última coleta | Nº de coletas |
|---|---|---|---|---|
| Bertioga | IPAU02600 | 17/03/2022 | 09/12/2025 | 16 |
| Cubatão | CUBA02700 | 31/03/2022 | 02/12/2025 | 16 |
| Santos | SABO22500 | 24/03/2022 | 03/12/2025 | 16 |

A cobertura é **balanceada entre os três municípios**, com periodicidade aproximadamente trimestral e as mesmas ~16 janelas de coleta por ponto ao longo dos quase 4 anos — o que favorece comparações diretas entre os três perfis de cidade propostos na pesquisa (urbana/portuária, industrial, ecoturismo/residencial).

---

## 4. Qualidade dos Dados

### 4.1 Formato numérico
Todos os parâmetros medidos 'tirando o de chuvas nas últimas 24 horas', o qual foi alterado de 'sim' e 'não' para 0 e 1, estão armazenados como **texto com vírgula decimal** (ex.: `"6,63000000"`), herdando o padrão numérico brasileiro da extração original da CETESB. É necessário `str.replace(',', '.')` seguido de conversão para `float` antes de qualquer cálculo.

### 4.2 Valores ausentes
Os dados ausentes se concentram fortemente em compostos orgânicos voláteis e hidrocarbonetos policíclicos aromáticos (colunas de µg/L), com até **32 valores ausentes em 48 linhas** (66%) nas colunas mais esparsas — parâmetros provavelmente analisados apenas em campanhas específicas, não em todas as coletas.

Também houveram parâmetros que foram coratados por falta de dados em um ou mais pontos, mantendo-se ao critério ao menos de três lihas por ponto para manter o para que se mantesse um parãmetro.

Os **9 parâmetros que compõem o IQA**, por outro lado, estão quase completos:

| Parâmetro do IQA | Coluna no arquivo | Valores ausentes (de 48) |
|---|---|---|
| pH | `PH U.pH` | 0 |
| Temperatura da água | `Temperatura Da Agua C°` | 0 |
| Oxigênio Dissolvido | `Oxigênio Dissolvido mg/l` | 0 |
| DBO | `DBO (5, 20)` | — (a conferir) |
| E. coli | `Escherichia coli** UFC/100mL` | 0 |
| Nitrogênio Kjeldahl | `Nitrogênio Kjeldahl mg/l` | 0 |
| Nitrogênio-Nitrato | `Nitrogênio-Nitrato mg/L` | 4 |
| Nitrogênio-Nitrito | `Nitrogênio-Nitrito mg/l` | 5 |
| Fósforo Total | `Fósforo Total mg/l` | 0 |
| Turbidez | `Turbidez (UNT)` | 0 |
| Resíduo (Sólido) Total | `Sólido Total` | 0 |

Isso é uma boa notícia para o cálculo do IQA: a maior parte dos parâmetros necessários está praticamente completa, com pequenas lacunas pontuais nas frações de nitrogênio (que precisarão ser somadas para compor o Nitrogênio Total) e absência da demanda bioquímica de oxigênio (DBO), pois apenas uma das tabelas continha o parâmetro (santos) e com apenas uma instância.

### 4.3 Perda da informação de censura (`Sinal`)
A coluna `Sinal` (que indicava, na extração bruta, se um valor estava abaixo/acima do limite de detecção do método) **não está presente neste arquivo pivotado** — não foi encontrado nenhum valor com `<` ou `>` embutido nas colunas numéricas. Isso sugere que, durante a filtragem/pivotagem do dataset, essa informação de censura estatística foi perdida ou descartada. **Limitação a registrar**: não é possível, a partir deste arquivo, diferenciar um valor medido diretamente de um valor no limite de detecção — algo relevante especialmente para os compostos-traço.

### 4.4 Colunas técnicas irrelevantes para a modelagem
- `Unnamed: 0` e `Fim Operação`: 100% ausentes (48/48) — podem ser descartadas.
- `Cod_Interaguas`, `Código Ponto`: identificadores, não devem entrar como *features* preditivas diretas (mas são úteis para agrupar/filtrar).
- `Latitude`/`Longitude`: em formato de texto (graus/minutos/segundos), exigem conversão para decimal caso se queira usá-las como variável espacial.

---

## 5. Estatísticas Descritivas — Parâmetros do IQA

*(valores após conversão para ponto decimal; unidades conforme dicionário de dados)*

| Parâmetro | Unidade | Observação da distribuição |
|---|---|---|
| pH | U.pH | Variação concentrada na faixa levemente ácida a neutra (~5,9 a ~7,4), compatível com águas de rio com influência de maré (classe Salobra em Santos) |
| Temperatura da água | °C | Variação sazonal esperada, com valores mais altos nas coletas de verão |
| Oxigênio Dissolvido | mg/L | Valores na faixa de ~8 a ~10 mg/L nas amostras iniciais — será necessário converter para % de saturação (depende de temperatura e altitude) antes do cálculo do IQA |
| Turbidez | UNT | Maior dispersão entre as três variáveis físicas, coerente com a diferença de perfil entre os municípios (industrial x urbano-portuário x residencial) |
| Sólido Total | mg/L | Valor mais frequente (moda) próximo de 50 mg/L |

> Recomenda-se complementar esta tabela com um notebook (`eda.ipynb`) contendo histogramas, boxplots por município e séries temporais por parâmetro — este README documenta os achados, não substitui a análise em código.

---

## 6. Comparação entre Municípios (perfis)

| Município | Perfil esperado | Ponto | Sistema Hídrico | Classe |
|---|---|---|---|---|
| Santos | Urbano/portuário | SABO22500 | Rio Saboó | Salobra 2 |
| Cubatão | Industrial | CUBA02700 | Rio cubatão | Classe 2 |
| Bertioga | Ecoturismo/residencial | IPAU02600 | Rio Itapanhaú | Classe 2 |

## 6.1 Observação
A partir da coleta de 13/06/2023 e 08/03/2023, a linha correspondente a Cubatão e Santos respectivamente passa a ter 72 colunas ausentes de uma vez, contra apenas 2 nas coletas anteriores — um salto abrupto que se repete em todas as coletas seguintes até dezembro de 2025. Isso não é um erro pontual, mas sim uma mudança no escopo analítico da CETESB para esse ponto: a partir dessa data, um bloco inteiro de compostos orgânicos voláteis (COVs) e hidrocarbonetos policíclicos aromáticos (HPAs) — benzeno, tolueno, xilenos, tricloroeteno, clorofórmio, naftaleno, benzo(a)pireno, entre outros — deixou de ser medido nesse ponto. Nenhum desses parâmetros integra os 9 usados no cálculo do IQA, então o índice em si não é afetado; ainda assim, vale registrar essa lacuna estrutural como limitação do dataset, especialmente caso se queira usar variáveis ecotoxicológicas/orgânicas como features adicionais no modelo preditivo.

A diferença de **classe de enquadramento** entre os pontos (Santos como corpo salobro, sujeito à mistura com água do mar, versus Bertioga em Classe 2 de água doce) é um fator relevante a considerar na modelagem: os padrões de referência de qualidade variam por classe, o que pode enviesar comparações diretas do IQA bruto entre municípios se não for tratado explicitamente.
