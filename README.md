# Qualidade da Água Potável em Santos: Análise Histórica e Classificação Preditiva
 
## 1. Descrição da Ideia
 
Este projeto tem como objetivo analisar a evolução histórica da qualidade da água em Santos/Baixada Santista e desenvolver um modelo preditivo capaz de **classificar a qualidade da água** (ex: ótima, boa, regular, ruim, péssima) a partir de seus parâmetros físico-químicos e microbiológicos.
 
**Pergunta de pesquisa:** É possível prever a categoria de qualidade da água em Santos a partir de seus parâmetros histórico-físico-químicos, e quais desses parâmetros mais influenciam essa classificação?
 
**Objetivo geral:** Investigar a evolução do Índice de Qualidade das Águas (IQA) em pontos de monitoramento de Santos e construir um modelo de classificação supervisionada que preveja a categoria de qualidade da água com base em seus parâmetros individuais ( físico-químicos e microbiológicos).

**Período da pesquisa:** a ser decidido.

**Área pesquisa:** a ser decidido, o grupo está debatendo sobre se restringir a Santos ou trabalhar com todas as cidades da baixada Santista.
 
---
 
## 2. Base de Dados
 
**Fonte:** CETESB (Companhia Ambiental do Estado de São Paulo) — Índice de Qualidade das Águas (IQA)
obs: os dados são encontrados no sistema [infoaguas](https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/Monitoramento) e é necessário um login para entrar, que pode ser feito de forma rápida e gratuita.
 
**Link oficial (relatórios e dados):** [Publicações e Relatórios — CETESB](https://www.cetesb.sp.gov.br/cetesb/qualidade_ambiental/agua/aguas_interiores/publicacoes_e_relatorios)
 
**Contexto e explicações sobre o monitoramento:** [Águas Interiores — CETESB](https://www.cetesb.sp.gov.br/cetesb/qualidade_ambiental/agua/aguas_interiores/)
 
**Mapa interativo com dados históricos:** [SIGRH — IQA](https://sigrh.sp.gov.br/iqa)
 
**Descrição:** <cite index="11-1">O IQA fornece informação básica sobre as condições de qualidade das águas superficiais, refletindo principalmente a contaminação dos corpos hídricos causada pelo lançamento de esgotos domésticos, e é calculado em todos os pontos da Rede Básica de monitoramento do Estado de São Paulo pela CETESB.</cite> <cite index="12-1">O índice foi originalmente desenvolvido para avaliar a qualidade da água bruta destinada ao abastecimento público após tratamento.</cite>
 
O índice é composto por **9 parâmetros**, cada um com peso relativo próprio, combinados por meio de um produtório ponderado que gera um valor final de 0 a 100, posteriormente enquadrado em faixas de classificação (de "péssima" a "ótima").
 
**Granularidade:** dados por ponto de amostragem (estações de monitoramento em Santos e proximidades), com coletas periódicas (geralmente mensais), permitindo série histórica de vários anos.
 
---
 
## 3. Dicionário de Dados
 
### Tipos de variáveis
 
As variáveis do banco se dividem em dois grandes grupos:
 
- **Qualitativa (categórica)**
  - *Nominal*: categorias sem ordem — ex.: `ponto_amostragem`.
  - *Ordinal*: categorias com ordem — ex.: `categoria_iqa` (Péssima < Ruim < Regular < Boa < Ótima).
- **Quantitativa (numérica)**
  - *Discreta*: contagem, valores isolados — nenhuma variável do IQA se enquadra aqui.
  - *Contínua*: medida, qualquer valor num intervalo — ex.: `ph`, `oxigenio_dissolvido`, `dbo`, `coliformes_termotolerantes`, `nitrogenio_total`, `fosforo_total`, `temperatura`, `turbidez`, `residuo_total`, `iqa`.
Duas variáveis não se enquadram nessa dicotomia:
 
- `ponto_amostragem` é um **identificador**, não uma medida numérica.
- `data_coleta` é uma **referência temporal**, usada para construir a série histórica.
### Dicionário de variáveis
 
| Variável | Descrição | Tipo | Peso no IQA (w_i) | Unidade / domínio |
|---|---|---|---|---|
| `ponto_amostragem` | Código do ponto/estação de coleta da rede de monitoramento CETESB em Santos | Identificador | — | código alfanumérico CETESB |
| `data_coleta` | Data da coleta da amostra | Temporal | — | dd/mm/aaaa |
| `coliformes_termotolerantes` | Indicador de contaminação fecal/esgoto doméstico | Quantitativa contínua | 0,15 | NMP/100mL |
| `ph` | Potencial hidrogeniônico, mede acidez/alcalinidade da água | Quantitativa contínua | 0,12 | 0–14 (Sörensen) |
| `dbo` | Demanda Bioquímica de Oxigênio (5 dias) — indica matéria orgânica poluente | Quantitativa contínua | 0,10 | mg/L |
| `nitrogenio_total` | Concentração total de nitrogênio, associado a esgoto e fertilizantes | Quantitativa contínua | 0,10 | mg/L |
| `fosforo_total` | Concentração total de fósforo, associado a esgoto e eutrofização | Quantitativa contínua | 0,10 | mg/L |
| `temperatura` | Afastamento da temperatura da água em relação à temperatura de equilíbrio | Quantitativa contínua | 0,10 | °C (Δt) |
| `turbidez` | Grau de transparência da água, afetado por partículas em suspensão | Quantitativa contínua | 0,08 | UNT (unidade nefelométrica de turbidez) |
| `residuo_total` | Sólidos totais presentes na água (dissolvidos + em suspensão) | Quantitativa contínua | 0,08 | mg/L |
| `oxigenio_dissolvido` | Percentual de saturação de oxigênio na água, indicador de saúde do corpo hídrico | Quantitativa contínua | 0,17 | % de saturação |
| `iqa` | Índice de Qualidade das Águas — produtório ponderado das 9 variáveis acima | Quantitativa contínua | — (resultado) | 0–100 |
| `categoria_iqa` | Classificação da qualidade da água com base na faixa do IQA (**variável-alvo do modelo**) | Qualitativa ordinal | — (derivada) | Péssima (≤19) \| Ruim (19–36) \| Regular (36–51) \| Boa (51–79) \| Ótima (79–100) |
 
> Se o valor de qualquer uma das 9 variáveis que compõem o IQA estiver ausente em um registro, o cálculo do índice para aquele registro é inviabilizado, conforme a própria metodologia oficial da CETESB.
 
### Observações específicas
 
- **`ponto_amostragem`:** cada ponto tem coletas periódicas ao longo dos anos; o mesmo código se repete em vários registros (uma linha por data de coleta).
- **`categoria_iqa`:** variável derivada, não coletada diretamente — é calculada a partir do valor de `iqa` aplicando as faixas oficiais da CETESB (Tabela 1 do Apêndice de Índices de Qualidade das Águas).
- **`iqa`:** calculado pelo produtório ponderado `IQA = Π (q_i)^(w_i)`, onde `q_i` é a qualidade normalizada (0–100) de cada parâmetro segundo curvas específicas, e `w_i` é o peso listado na tabela acima. O cálculo é feito pela própria CETESB e publicado já pronto nos relatórios — não é necessário recalculá-lo a partir das variáveis brutas, a menos que o grupo queira reproduzir a metodologia.
- **`temperatura`:** na metodologia oficial, a variável usada no IQA não é a temperatura absoluta, mas o afastamento (Δt) em relação à temperatura de equilíbrio do corpo d'água.
- **Pesos (`w_i`):** são fixos e somam 1,0; não variam de registro para registro nem de ponto para ponto — fazem parte da metodologia nacional adaptada pela CETESB desde 1975.
**Dicionário oficial (fonte primária):** as definições, pesos e curvas de qualidade de cada parâmetro do IQA seguem a documentação técnica oficial da CETESB, publicada como apêndice específico ("Índices de Qualidade das Águas") dentro do relatório anual de Qualidade das Águas Interiores. Como esse apêndice é republicado a cada ano (ex: Apêndice D em relatórios mais antigos, Apêndice E em relatórios mais recentes), o caminho oficial para acessá-lo é pela própria página de [dicionário](https://www.cetesb.sp.gov.br/cetesb/qualidade_ambiental/agua/aguas_interiores/publicacoes_e_relatorios), selecionando o relatório do ano correspondente aos dados utilizados na pesquisa e localizando o apêndice de Índices de Qualidade das Águas dentro dele.
 
