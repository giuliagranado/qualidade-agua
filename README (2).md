# Qualidade da Água Potável em Santos: Análise Histórica e Classificação Preditiva

## 1. Descrição da Ideia

Este projeto tem como objetivo analisar a evolução histórica da qualidade da água em Santos/Baixada Santista e desenvolver um modelo preditivo capaz de **classificar a qualidade da água** (ex: ótima, boa, regular, ruim, péssima) a partir de seus parâmetros físico-químicos e microbiológicos.

**Pergunta de pesquisa:** É possível prever a categoria de qualidade da água em Santos a partir de seus parâmetros histórico-físico-químicos, e quais desses parâmetros mais influenciam essa classificação?

**Objetivo geral:** Investigar a evolução do Índice de Qualidade das Águas (IQA) em pontos de monitoramento de Santos e construir um modelo de classificação supervisionada que preveja a categoria de qualidade da água com base em seus parâmetros individuais.

**Objetivos específicos:**
- Levantar e organizar a série histórica do IQA e de seus parâmetros componentes para Santos;
- Analisar a evolução temporal de cada parâmetro (tendências, sazonalidade, pontos críticos);
- Identificar, por meio de um modelo de classificação, quais parâmetros têm maior peso na determinação da categoria final de qualidade da água;
- Discutir os resultados à luz de fatores locais (urbanização, saneamento, sazonalidade de chuvas).

**Justificativa:** Santos é um município costeiro e altamente urbanizado, com desafios conhecidos de saneamento básico e escoamento de esgoto doméstico — fatores que impactam diretamente a qualidade dos corpos d'água. Entender quais variáveis mais afetam essa qualidade, e ser capaz de prevê-la, tem valor prático para gestão ambiental e saúde pública.

**Abordagem técnica:** Trata-se de um problema de **aprendizado supervisionado (classificação)**. A variável-alvo é a categoria de qualidade da água (derivada das faixas oficiais do IQA), e as variáveis preditoras são os parâmetros físico-químicos e microbiológicos que compõem o índice.

---

## 2. Base de Dados

**Fonte:** CETESB (Companhia Ambiental do Estado de São Paulo) — Índice de Qualidade das Águas (IQA)

**Link oficial:** [Relatórios de Qualidade das Águas Interiores do Estado de São Paulo](https://cetesb.sp.gov.br/aguas-interiores/publicacoes-e-relatorios/)

**Mapa interativo com dados históricos:** [SIGRH — IQA](https://sigrh.sp.gov.br/iqa)

**Descrição:** <cite index="11-1">O IQA fornece informação básica sobre as condições de qualidade das águas superficiais, refletindo principalmente a contaminação dos corpos hídricos causada pelo lançamento de esgotos domésticos, e é calculado em todos os pontos da Rede Básica de monitoramento do Estado de São Paulo pela CETESB.</cite> <cite index="12-1">O índice foi originalmente desenvolvido para avaliar a qualidade da água bruta destinada ao abastecimento público após tratamento.</cite>

O índice é composto por **9 parâmetros**, cada um com peso relativo próprio, combinados por meio de um produtório ponderado que gera um valor final de 0 a 100, posteriormente enquadrado em faixas de classificação (de "péssima" a "ótima").

**Granularidade:** dados por ponto de amostragem (estações de monitoramento em Santos e proximidades), com coletas periódicas (geralmente mensais), permitindo série histórica de vários anos.

**Fonte única:** todos os parâmetros abaixo pertencem ao mesmo levantamento/índice da CETESB, atendendo à exigência de utilizar apenas um banco de dados.

---

## 3. Dicionário de Dados

| Variável | Descrição | Tipo | Unidade / Faixa |
|---|---|---|---|
| `ponto_amostragem` | Identificação do ponto/estação de coleta em Santos | Categórica | Código CETESB |
| `data_coleta` | Data da coleta da amostra | Data | dd/mm/aaaa |
| `temperatura_agua` | Temperatura da água no momento da coleta | Numérica (contínua) | °C |
| `ph` | Potencial hidrogeniônico, mede acidez/alcalinidade da água | Numérica (contínua) | 0–14 |
| `oxigenio_dissolvido` | Quantidade de oxigênio disponível na água, indicador de saúde do corpo hídrico | Numérica (contínua) | mg/L (% saturação) |
| `dbo` | Demanda Bioquímica de Oxigênio — indica matéria orgânica poluente | Numérica (contínua) | mg/L |
| `coliformes_termotolerantes` | Indicador de contaminação fecal/esgoto doméstico | Numérica (contínua) | NMP/100mL |
| `nitrogenio_total` | Concentração total de nitrogênio, associado a esgoto e fertilizantes | Numérica (contínua) | mg/L |
| `fosforo_total` | Concentração total de fósforo, associado a esgoto e eutrofização | Numérica (contínua) | mg/L |
| `residuo_total` | Sólidos totais presentes na água (dissolvidos + em suspensão) | Numérica (contínua) | mg/L |
| `turbidez` | Grau de transparência da água, afetado por partículas em suspensão | Numérica (contínua) | UNT (unidade nefelométrica de turbidez) |
| `iqa` | Índice de Qualidade das Águas — valor final calculado a partir dos 9 parâmetros acima | Numérica (contínua) | 0–100 |
| `categoria_iqa` | Classificação da qualidade da água com base na faixa do IQA (**variável-alvo do modelo**) | Categórica (ordinal) | Ótima / Boa / Regular / Ruim / Péssima |

> **Observação metodológica:** <cite index="17-1">a CETESB utiliza o IQA desde 1975 como informação básica de qualidade de água para gestão ambiental das Unidades de Gerenciamento de Recursos Hídricos do Estado de São Paulo</cite>, o que garante consistência histórica e confiabilidade para a análise de série temporal proposta neste projeto.

**Dicionário oficial (fonte primária):** as definições, pesos e curvas de qualidade de cada parâmetro do IQA seguem a documentação técnica oficial da CETESB — [dicionário](https://cetesb.sp.gov.br/aguasinteriores/wp-content/uploads/sites/12/2022/11/Apendice-E-Indices-de-Qualidade-das-Aguas.pdf)

---

## Próximos passos

- [ ] Download e limpeza dos dados históricos de Santos junto à CETESB
- [ ] Análise exploratória (distribuição dos parâmetros, valores faltantes, outliers)
- [ ] Definição da variável-alvo (categorias do IQA)
- [ ] Treinamento do modelo de classificação
- [ ] Avaliação do modelo (matriz de confusão, importância de variáveis)
- [ ] Discussão dos resultados e conclusões
