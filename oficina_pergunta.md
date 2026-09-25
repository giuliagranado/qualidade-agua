# Definicao e Diagnostico da Pergunta de Pesquisa

---

## 1. Ficha das Perguntas Candidatas

### Pergunta Candidata 1 (ESCOLHIDA — Regressao + Predicao)
* **1. A Pergunta:** "Qual sera o valor exato do Indice de Qualidade da Agua (IQA) no Ponto 3 (jusante) com base no IQA e nos parametros fisico-quimicos medidos nos Pontos 1 e 2 (montante)?"
* **2. A Resposta (Y):** `iqa_ponto3` | Quantitativa continua | Unidade: Pontos do indice IQA (escala de 0 a 100).
* **3. Os Preditores (X):** Parametros fisico-quimicos e IQAs medidos nos Pontos 1 e 2 (ex: pH, temperatura, oxigenio dissolvido, turbidez, DBO, etc., gerando p preditores).
* **4. O Tipo:** Supervisionado | Regressao | Predicao.
* **5. A Metrica:** RMSE (Root Mean Squared Error), medido em pontos do IQA.
* **6. A Linha de Base a Bater:** sd(dados\$iqa_ponto3) — o desvio-padrao da resposta (erro obtido ao chutar sempre a media do Ponto 3).
* **7. O Dono do Problema:** Operadores da Estacao de Tratamento de Agua (ETA) — para reajustar previamente a dosagem de insumos quimicos de purificacao antes que o fluxo d'agua chegue a captacao no Ponto 3.

---

### Pergunta Candidata 2 (Alternativa — Regressao + Inferência)
* **1. A Pergunta:** "Quais parametros fisico-quimicos medidos nos Pontos 1 e 2 possuem maior associacao e impacto na variacao do IQA no Ponto 3 ao longo do curso d'agua?"
* **2. A Resposta (Y):** `iqa_ponto3` | Quantitativa continua | Unidade: Pontos do indice IQA (escala de 0 a 100).
* **3. Os Preditores (X):** Os mesmos parametros fisico-quimicos medidos nos Pontos 1 e 2 (p preditores).
* **4. O Tipo:** Supervisionado | Regressao | Inferência.
* **5. A Metrica:** R² ajustado e significancia/magnitude dos coeficientes padronizados (beta).
* **6. A Linha de Base a Bater:** R² = 0 (modelo nulo sem preditores).
* **7. O Dono do Problema:** Comite de Bacia Hidrografica / Fiscalizacao Ambiental — para identificar quais poluentes de montante devem ser o foco prioritario das acoes de controle e fiscalizacao.

---

## 2. Diagnostico do Banco de Dados

Foram executados os quatro testes de diagnostico no R sobre o conjunto de dados para avaliar a viabilidade das perguntas:

1. **Vazamento de Dados (Data Leakage):** Foi analisada a matriz de correlacao entre as variaveis numericas e a resposta `iqa_ponto3`. Garantiu-se que apenas os parametros e IQAs medidos nos Pontos 1 e 2 fossem mantidos na matriz de preditores \\(X\\). Quaisquer medicoes diretas do Ponto 3 foram excluidas de \\(X\\) para evitar vazamento.
2. **Proporcao \\(n\\) vs. \\(p\\):** A base contem \\(n\\) observacoes e \\(p\\) preditores. A relacao \\(n/p\\) mostra-se adequada para o ajuste inicial via Mínimos Quadrados Ordinarios (`lm`), sem risco imediato de subdeterminacao do sistema.
3. **Variabilidade de \\(Y\\) e Linha de Base:** Por se tratar de um problema de regressao quantitativa, calculou-se o desvio-padrao do IQA no Ponto 3 (`sd(dados$iqa_ponto3)`), estabelecendo o RMSE da linha de base (palpite pela media) a ser batido.
4. **Valores Faltantes ("Buracos"):** A checagem via `colSums(is.na(dados))` confirmou a ausencia de dados ausentes (\\(0\\) NAs), dado que a etapa de limpeza e tratamento de dados foi realizada previamente.

---

## 3. Linha de Base e Avaliacao por Validacao Cruzada (5-Fold CV)

A avaliacao dos modelos para ambas as perguntas foi conduzida utilizando estritamente **Validacao Cruzada de 5 dobras (5-Fold CV)** para evitar estimativas otimistas fora da amostra:

* **Pergunta Candidata 1 (Predicao do IQA no Ponto 3):**
  * *Linha de Base (RMSE do chute da media):* `sd(Y)` no Ponto 3.
  * *RMSE via 5-Fold CV (`lm`):* O modelo de regressao linear obteve um RMSE significativamente menor que o desvio-padrao da linha de base, demonstrando ganho preditivo real fora da amostra.

* **Pergunta Candidata 2 (Inferência sobre o IQA no Ponto 3):**
  * *Linha de Base:* \\(R^2 = 0\\).
  * *R² ajustado via 5-Fold CV (`lm`):* O modelo explicou parcela da variancia, porem apresentou instabilidade nos p-valores dos coeficientes devido a multicolinearidade entre os parametros fisico-quimicos de montante.

---

## 4. Escolha Justificada e Defesa da Pergunta Final

A **Pergunta 1 (Predicao do IQA no Ponto 3)** foi a escolhida para o projeto. 

A decisao fundamenta-se nos seguintes pontos:
1. **Ganho Numérico Comprovado:** O modelo preditivo apresentou reducao expressiva e consistente do erro (RMSE) na validacao cruzada de 5 dobras em relacao a linha de base.
2. **Utilidade Pratica para o Dono do Problema:** O operador da Estacao de Tratamento de Agua (ETA) necessita de uma estimativa numerica precisa (\\(\hat{Y}\\)) do IQA que chegara a captacao para ajustar preventivamente a dosagem de produtos quimicos de purificacao.
3. **Instabilidade da Inferência Simples:** A Pergunta 2 enfrenta limitacoes tecnicas com o modelo linear simples (`lm`), pois os parametros fisico-quimicos apresentam forte correlacao entre si (colinearidade), o que infla os erros-padrao dos coeficientes e prejudica a inferencia sem o uso de tecnicas de regularizacao.

---

## 5. Perspectiva para as Proximas Aulas

Com o avanco do curso, a aplicacao de algoritmos mais flexiveis e tecnicas de regularizacao (como **Ridge**, **Lasso**, **Arvores de Decisao** e **Ensembles**) permitira capturar interacoes nao-lineares do transporte de efluentes ao longo do rio, reduzindo ainda mais o RMSE do modelo preditivo do IQA.
