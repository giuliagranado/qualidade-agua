# Definição e Diagnóstico da Pergunta de Pesquisa
**Dataset:** Dataset_atual.csv (Análise Físico-Química da Água)

---

## 1. Ficha das Perguntas Candidatas

### Pergunta Candidata 1 (ESCOLHIDA — Regressão + Predição)
* **1. A Pergunta:** "Qual será a concentração de Oxigênio Dissolvido (mg/L) na água com base nas medições físico-químicas e ambientais da amostra?"
* **2. A Resposta (Y):**  | **Quantitativa contínua** | **Unidade:** mg/L (miligramas por litro).
* **3. Os Preditores (X):** 17 parâmetros físico-químicos e ambientais da tabela (metais pesados e etc, ao todo 17).
* **4. O Tipo (As 3 Decisões):** será algo **Supervisionado** | **Regressão** | **Predição**.
* **5. A Métrica:** **RMSE** (*Root Mean Squared Error*), medido em mg/L.
* **6. A Linha de Base a Bater:** (Y) = 1{,}3604$ mg/L — o desvio-padrão da resposta (erro médio ao chutar a média histórica $\bar{Y} = 8{,}4785$ mg/L).

#### Complemento de Classificação (Análise Complementar da Pergunta 1)
* **Pergunta Binária:** "A água apresentará nível adequado de Oxigênio Dissolvido ($\ge 7{,}0$ mg/L) ou estará abaixo do padrão de qualidade ($< 7{,}0$ mg/L)?"
* **Resposta (Y):**  | **Qualitativa nominal binária** ( = Adequado vs  = Abaixo do Padrão).
* **Métrica & Linha de Base:** Acurácia da classe majoritária = 5{,}42\%$.
* **Utilidade:** Testar se a discretização de $ melhora a tomada de decisão para a agência de fiscalização ambiental.

---

### Pergunta Candidata 2 (ALTERNATIVA — Regressão da Biomassa de Algas)
* **1. A Pergunta:** "Qual será a concentração de Clorofila-a (µg/L) na água a partir da carga de nutrientes (Nitrogênio e Fósforo), temperatura, pH e ocorrência de chuvas?"
* **2. A Resposta (Y):**  | **Quantitativa contínua** | **Unidade:** µg/L (microgramas por litro).
* **3. Os Preditores (X):** , , , , , ,  ( = 11$).
* **4. O Tipo (As 3 Decisões):** **Supervisionado** | **Regressão** | **Predição**.
* **5. A Métrica:** **RMSE** (*Root Mean Squared Error*), medido em µg/L.
* **6. A Linha de Base a Bater:** (Y) = 9{,}7477$ µg/L — o desvio-padrão da Clorofila-a ($\bar{Y} = 25{,}6940$ µg/L).

---

## 2. Diagnóstico do Banco de Dados

Aplicou-se o protocolo de 4 testes de diagnóstico diretamente sobre a tabela  ( = 48$ observações distribuídas nos pontos ,  e ):

1. **Vazamento de Dados (*Data Leakage*):**
   Analisou-se a matriz de correlação de todas as variáveis numéricas com as respostas, e não há colunas derivadas diretamente do Oxigênio Dissolvido ou da Clorofila-a.
   Para o Oxigênio, as maiores correlações foram  ( = +0{,}552$),  ( = -0{,}534$),  ( = +0{,}419$) e  ( = -0{,}350$).
   Nenhuma variável apresentou correlação espúria ( \approx 1{,}0$), confirmando ausência de *leakage*.

3. **Proporção $ vs. $:**
   A base contém  = 48 amostras físicas. Para a Pergunta 1 ( = 17 amostras) e para a Pergunta 2 ( = 11 amostras), a razão /p \approx 4,36.
   Ambas as razões são **restritas/pequenas**, o que exige cuidado contra o *overfitting* em modelos complexos e justifica o uso de validação cruzada rigorosa e futuras técnicas de regularização (Lasso/Ridge).

5. **Variabilidade de $ e Balanço de Classes:**
   * **Pergunta 1 (Oxigênio Dissolvido):** Varia entre {,}22$ e 1{,}41$ mg/L ($\bar{Y} = 8{,}4785$,  = 1{,}3604$ mg/L). Seu complemento binário apresenta **forte desbalanço de classes**: 1$ amostras adequadas (5{,}42\%$) vs apenas $ críticas (4{,}58\%$).
   * **Pergunta 2 (Clorofila-a):** Varia entre 1{,}30$ e 9{,}05$ µg/L ($\bar{Y} = 25{,}6940$,  = 9{,}7477$ µg/L).

6. **Valores Faltantes ("Buracos"):**
   Mapeamento de NAs na tabela original:
   * : 3$ valores ausentes de 48 (8{,}75\%$ de buracos) $\rightarrow$ **Variável excluída do modelo**.
   * : $ valores ausentes ({,}17\%$) $\rightarrow$ **Imputados pela mediana**.
   *  e : Valores constantes em todas as amostras $\rightarrow$ **Removidos por ausência de variância**.
   * Demais variáveis físico-químicas: -bash$ NAs (00\%$ preenchidos).

---

## 3. Linha de Base e Avaliação Inicial (Validação Cruzada de 5 Dobras - 5-Fold CV)

Para garantir estimativas realistas fora da amostra (*out-of-sample*), os modelos iniciais foram avaliados por **Validação Cruzada de 5 dobras (5-Fold CV)**:

* **Pergunta Candidata 1 (Regressão Linear do Oxigênio Dissolvido):**
  * *Linha de Base (RMSE do chute da média):* **{,}3604$ mg/L**
  * *RMSE via 5-Fold CV ():* **-bash{,}8557$ mg/L**
  * *Desempenho:* O modelo de regressão linear **reduziu o erro de predição em 7{,}10\%* em relação à linha de base.

* **Complemento de Classificação da Pergunta 1 (Regressão Logística ):**
  * *Linha de Base (Acurácia majoritária):* **5{,}42\%*
  * *Acurácia via 5-Fold CV ():* **5{,}11\%*
  * *Desempenho:* Devido ao severo desbalanço de classes (1$ vs $), a regressão logística estagnou no nível da linha de base, sem ganho preditivo.

* **Pergunta Candidata 2 (Regressão Linear da Clorofila-a):**
  * *Linha de Base (RMSE do chute da média):* **{,}7477$ µg/L**
  * *RMSE via 5-Fold CV ():* **{,}4466$ µg/L**
  * *Desempenho:* Obteve modesta **redução de {,}09\%$ no erro**, refletindo que a dinâmica de floração de algas possui forte componente não-linear que o modelo linear simples não consegue capturar isoladamente.

---

## 4. Escolha Justificada e Defesa da Pergunta Final

A **Pergunta Candidata 1 (Predição do Oxigênio Dissolvido via Regressão)** foi a escolhida para o projeto final.

### Argumentos de Defesa:
1. **Maior Ganho Preditivo Comprovado Numericamente:**
   O modelo linear da Pergunta 1 alcançou um ganho preditivo expressivo, reduzindo o erro de estimativa de **{,}3604$ mg/L para -bash{,}8557$ mg/L** (ganho de **7{,}10\%$ no RMSE**). Em comparação, a Pergunta 2 (Clorofila-a) teve ganho inicial de apenas {,}09\%$, e o complemento de classificação estagnou na linha de base (5{,}11\%$).
2. **Relevância Prática e Decisória:**
   O Oxigênio Dissolvido é o indicador biótico primário de saúde aquática. Prever o valor contínuo em mg/L permite que os gestores de bacia identifiquem gradientes de degradação e acionem sistemas de aeração preventiva antes que os níveis atinjam patamares mortais para a fauna aquática ($< 5{,}0$ mg/L).
3. **Inviabilidade do Problema Binário no Dataset Atual:**
   A análise do complemento de classificação provou empiricamente que transformar a resposta em categoria binária destrói a capacidade preditiva do modelo devido ao pequeno número de eventos críticos ({crítico} = 7$), justificando a escolha pela abordagem quantitativa contínua.

---

## 5. Perspectiva Futura (Próximas Aulas)

Com o avanço da disciplina:
* Dado que a proporção /p \approx 2{,}82$ é pequena e existe multicolinearidade entre os nutrientes (Nitrogênio e Fósforo), a aplicação de métodos de regularização (**Ridge e Lasso**) permitirá encolher coeficientes e selecionar automaticamente os preditores mais relevantes.
* Para a Clorofila-a e o Oxigênio, a utilização de modelos não-lineares (**Árvores de Decisão, Random Forests e Redes Neurais**) permitirá capturar relações complexas e interações ambientais.
