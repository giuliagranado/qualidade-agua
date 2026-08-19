# Qualidade da Água Potável em Santos: Análise Histórica e Classificação Preditiva
 
## 1. Descrição da Ideia Inicial (a ser atualizado)
 
Este projeto tem como objetivo analisar a evolução histórica da qualidade da água em Santos/Baixada Santista e desenvolver um modelo preditivo capaz de **classificar a qualidade da água** (ex: ótima, boa, regular, ruim, péssima) a partir de seus parâmetros físico-químicos e microbiológicos.
 
**Pergunta de pesquisa:** É possível prever a categoria de qualidade da água em Santos a partir de seus parâmetros histórico-físico-químicos, e quais desses parâmetros mais influenciam essa classificação?
 
**Objetivo geral:** Investigar a evolução do Índice de Qualidade das Águas (IQA) em pontos de monitoramento de Santos e construir um modelo de classificação supervisionada que preveja a categoria de qualidade da água com base em seus parâmetros individuais ( físico-químicos e microbiológicos).

**Período da pesquisa:** 2022 a 2025, um período abrangendo 4 anos

**Área pesquisa:** a ser decidido, o grupo está debatendo sobre se restringir a Santos ou trabalhar com todas as cidades da baixada Santista.
atualização: foram escolhidas as cidades de Santos, Bertioga e Cubatão para serem utilizadas na pesquisa, comparando 3 perfis diferentes de cidades: urbana/portuária x industrial x ecoturismo/residencial
 
---
 
## 2. Base de Dados
 
**Fonte:** CETESB (Companhia Ambiental do Estado de São Paulo) — Índice de Qualidade das Águas (IQA)

obs: os dados são encontrados no sistema [infoaguas](https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/Monitoramento) e é necessário um login para entrar, que pode ser feito de forma rápida e gratuita. No 'RelatorioQualidadeAguasSuperficiais' pode ser visto um exemplo de como os dados virão (ainda sem serem filtrados)
 
**Link oficial (relatórios e dados):** [Publicações e Relatórios — CETESB](https://www.cetesb.sp.gov.br/cetesb/qualidade_ambiental/agua/aguas_interiores/publicacoes_e_relatorios)
 
**Contexto e explicações sobre o monitoramento:** [Águas Interiores — CETESB](https://www.cetesb.sp.gov.br/cetesb/qualidade_ambiental/agua/aguas_interiores/)
 
**Mapa interativo com dados históricos:** [SIGRH — IQA](https://sigrh.sp.gov.br/iqa)
 
**Descrição:** <cite index="11-1">O IQA fornece informação básica sobre as condições de qualidade das águas superficiais, refletindo principalmente a contaminação dos corpos hídricos causada pelo lançamento de esgotos domésticos, e é calculado em todos os pontos da Rede Básica de monitoramento do Estado de São Paulo pela CETESB.</cite> <cite index="12-1">O índice foi originalmente desenvolvido para avaliar a qualidade da água bruta destinada ao abastecimento público após tratamento.</cite>
 
O índice é composto por **9 parâmetros**, cada um com peso relativo próprio, combinados por meio de um produtório ponderado que gera um valor final de 0 a 100, posteriormente enquadrado em faixas de classificação (de "péssima" a "ótima").
 
**Granularidade:** dados por ponto de amostragem (estações de monitoramento), com coletas periódicas, permitindo série histórica de vários anos.
 
---
 
## 3. Dicionário de Dados
 
### Tipos de variáveis
 
As variáveis do banco se dividem em dois grandes grupos:
 
- **Qualitativa (categórica)**
  - *Nominal*: categorias sem ordem — ex.: `ponto_amostragem`.
  - *Ordinal*: categorias com ordem — ex.: `categoria_iqa` (Péssima < Ruim < Regular < Boa < Ótima).
- **Quantitativa (numérica)**
  - *Discreta*: contagem, val### Tipos de variáveis
 
- **Qualitativa (categórica)**
  - *Nominal*: sem ordem — ex.: `Tipo Rede`, `UGRHI`, `Status Ponto`, `Parametro`, `Sinal`, `Unidade`, `Tipo Parâmetro`, `Sistema Hídrico`, `Tipo de Sistema Hídrico`, `Município`, `UF`, `Localização`, `Captação`.
  - *Ordinal*: com ordem — ex.: `CLASSE` (classe de enquadramento do corpo hídrico segundo a legislação).
- **Quantitativa (numérica)**
  - *Contínua*: `Valor` (o valor medido do parâmetro), `Altitude`.
- **Identificador**: `Cod_Interaguas`, `Código Ponto` — não são medidas, apenas códigos de referência.
- **Temporal**: `Período DE`, `Período ATE`, `Data Coleta`, `Hora Coleta`, `Inicio Operação`, `Fim Operação`.
- **Coordenada geográfica (texto em graus/minutos/segundos)**: `Latitude`, `Longitude`.
### Dicionário de variáveis
 
| Variável | Descrição | Tipo | Domínio / valores observados |
|---|---|---|---|
| `Período DE` / `Período ATE` | Intervalo de datas coberto pela extração do relatório | Temporal | dd/mm/aaaa |
| `Cod_Interaguas` | Código interno do ponto no sistema Infoáguas da CETESB | Identificador | código numérico |
| `Tipo Rede` | Rede de monitoramento à qual o ponto pertence | Qualitativa nominal | Rede Básica |
| `UGRHI` | Unidade de Gerenciamento de Recursos Hídricos do ponto | Qualitativa nominal | 07 - BAIXADA SANTISTA |
| `Código Ponto` | Código do ponto de amostragem | Identificador | ex.: SABO22500 |
| `Status Ponto` | Situação operacional do ponto | Qualitativa nominal | Ativo \| Inativo |
| `Data Coleta` | Data em que a amostra foi coletada | Temporal | dd/mm/aaaa |
| `Hora Coleta` | Hora da coleta da amostra | Temporal | hh:mm |
| `Parametro` | Nome do parâmetro analisado nesse registro | Qualitativa nominal | 120 valores possíveis (ex.: `pH`, `Turbidez`, `DBO (5, 20)`, `Oxigênio Dissolvido`, `Escherichia coli**`...) |
| `Sinal` | Indica se o valor está abaixo (`<`) ou acima (`>`) do limite de detecção do método | Qualitativa nominal | `<` \| `>` \| vazio (valor medido diretamente) |
| `Valor` | Valor numérico medido do parâmetro, na unidade correspondente | Quantitativa contínua | numérico, decimal com vírgula |
| `Unidade` | Unidade de medida do valor | Qualitativa nominal | U.pH, ºC, mg/L, µg/L, UFC/100mL, µS/cm, UNT, m, Adimensional, EC20(%) |
| `Tipo Parâmetro` | Categoria/grupo do parâmetro | Qualitativa nominal | ex.: 01- Campo, 02- Físicos, 03- Químicos, 04- Microbiológicos, 05- Hidrobiológicos, 06- Ecotoxicológicos, COVs, PAHs, BTEX |
| `Sistema Hídrico` | Corpo d'água monitorado | Qualitativa nominal | ex.: Rio Saboó - SABO |
| `Tipo de Sistema Hídrico` | Classificação hidrológica do corpo d'água | Qualitativa nominal | Rio (Lótico) \| Reservatório (Lêntico) |
| `CLASSE` | Classe de enquadramento do corpo hídrico (legislação estadual/CONAMA) | Qualitativa ordinal | ex.: Especial, 1, 2, 3, 4, Salobra 1, Salobra 2, Salina 1... |
| `Município` | Município do ponto de coleta | Qualitativa nominal | SANTOS |
| `UF` | Unidade federativa | Qualitativa nominal | SP |
| `Inicio Operação` / `Fim Operação` | Datas de início e (se houver) encerramento do monitoramento no ponto | Temporal | dd/mm/aaaa ou vazio (ponto ainda ativo) |
| `Latitude` / `Longitude` | Coordenadas do ponto, em graus/minutos/segundos (texto) | Coordenada geográfica | ex.: 23 55 51 / 46 20 59 |
| `Altitude` | Altitude aproximada do ponto de coleta | Quantitativa contínua | metros |
| `Localização` | Descrição textual do local exato da coleta | Qualitativa nominal | texto livre, ex.: "Ponte na Av. Pres. Getúlio Vargas..." |
| `Captação` | Indica se o ponto é usado para captação de água para abastecimento público | Qualitativa nominal | S \| N |
 
### Parâmetros usados no cálculo do IQA (subconjunto de `Parametro`)
 
Dos 120 parâmetros monitorados neste ponto, apenas 9 compõem o IQA. Veja como cada um aparece **exatamente** na coluna `Parametro` do arquivo, e o cuidado necessário em cada caso:
 
| Variável do IQA | Nome exato em `Parametro` | Unidade observada | Observação |
|---|---|---|---|
| pH | `pH` | U.pH | Direto, sem ajuste |
| Temperatura | `Temperatura da Água` | ºC | O IQA usa o *afastamento* da temperatura de equilíbrio (Δt), não o valor absoluto |
| Oxigênio Dissolvido | `Oxigênio Dissolvido` | mg/L | ⚠️ A fórmula oficial do IQA exige **% de saturação**, não mg/L — é necessário converter (depende de temperatura e altitude) |
| DBO | `DBO (5, 20)` | mg/L | Direto |
| Coliformes Termotolerantes | `Escherichia coli**` | UFC/100mL | CETESB substitui coliformes termotolerantes por E. coli desde 2008, aplicando fator de correção de 1,25 sobre o resultado |
| Nitrogênio Total | *não existe coluna única* — somar `Nitrogênio Kjeldahl` + `Nitrogênio-Nitrato` + `Nitrogênio-Nitrito` | mg/L | Precisa ser calculado somando os 3 registros da mesma data |
| Fósforo Total | `Fósforo Total` | mg/L | Direto |
| Turbidez | `Turbidez` | UNT | Direto |
| Resíduo Total | `Sólido Total` | mg/L | Direto (existe também `Sólido Dissolvido Total` e `Sólido Suspenso Total`, que são componentes separados) |

### Observações específicas
 
- **Formato longo:** para calcular o IQA de uma data específica, é necessário **pivotar** os dados — transformar `Parametro` em colunas e `Valor` nos respectivos valores, filtrando apenas os 9 parâmetros da tabela acima, agrupados por `Data Coleta`.
- **`Sinal`:** quando preenchido (`<` ou `>`), o valor em `Valor` é o **limite de detecção do método**, não a medição real — é uma censura estatística à esquerda ou à direita, comum em variáveis-traço (ex.: compostos orgânicos voláteis). Isso deve ser tratado com cuidado na modelagem (não é um valor exato).
- **`Valor`:** decimal com vírgula na base original; precisa conversão para ponto antes de qualquer cálculo numérico (`str.replace(',', '.')`).
- **Um único ponto de amostragem:** este arquivo cobre apenas `SABO22500` (Rio Saboó).
- **`CLASSE`:** neste ponto a classe é "Salobra 2", o que indica água com influência de maré/mistura com água do mar — relevante para a discussão de resultados, já que corpos hídricos salobros têm padrões de qualidade distintos dos de água doce.
  
**Dicionário oficial (fonte primária):** as definições, pesos e curvas de qualidade de cada parâmetro do IQA seguem a documentação técnica oficial da CETESB, publicada como apêndice específico ("Índices de Qualidade das Águas") dentro do relatório anual de Qualidade das Águas Interiores. Como esse apêndice é republicado a cada ano, o caminho oficial para acessá-lo é pela própria página de [dicionário](https://www.cetesb.sp.gov.br/cetesb/qualidade_ambiental/agua/aguas_interiores/publicacoes_e_relatorios), selecionando o relatório do ano correspondente aos dados utilizados na pesquisa e localizando o apêndice de Índices de Qualidade das Águas dentro dele.
