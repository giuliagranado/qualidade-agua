## Explicação do Código — reg_linear

### 1. Carregamento e preparação dos dados

O CSV é lido com separador `;`, e as principais variáveis são extraídas: 
pH(PH), oxigênio dissolvido(OXIGÊNIODISS), sólidos totais(SÓLIDOS), temperatura(TEMP),
nitrogênio(NIT), fósforo(FOS), turbidez(TURB) e IQA total(QUALIS) (coluna 31).

Os dados são divididos em três grupos de 16 observações cada: 
Bertioga (1–16), Cubatão (17–32) e Santos (33–48). 

A função `gsub(",",".")` converte vírgulas decimais para o padrão do R.

---

### 2. Análise descritiva por cidade

Calcula-se a soma dos sólidos totais(SÓLIDOS) por cidade e cria-se um dataframe `CIDADES` para comparação.
Em seguida, são gerados quatro gráficos de dispersão entre oxigênio dissolvido e IQA — um por cidade e um geral — 
cada um com uma reta de regressão linear (`abline(lm(...))`).

---

### 3. Regressão linear simples

Dois modelos lineares são ajustados:
- `m`: IQA previsto pelo **pH**
- `n`: IQA previsto pelo **oxigênio dissolvido**

Os coeficientes são exibidos com `coef()`. 
Os gráficos de resíduos (`resid` vs `fitted`) verificam se os erros têm comportamento 
aleatório — um pressuposto da regressão linear.

---

### 4. Divisão treino/teste

Os dados são particionados: 11 observações por cidade → treino (33 no total) e 5 por cidade → teste (15 no total).
Essa separação permite avaliar a capacidade do modelo de generalizar para dados novos.

---

### 5. Regressão polinomial e seleção de grau

Modelos polinomiais de graus 1, 3 e 12 são ajustados com `poly(TreinoPH, g)` para prever IQA a partir do pH.
Os gráficos mostram o ajuste de cada grau sobre os dados de treino. 
A função `mse()` calcula o Erro Quadrático Médio tanto no treino quanto no teste para os três graus.

---

### 6. Curva de bias-variância

Todos os graus de 1 a 12 são testados em loop. O gráfico final (`matplot`) plota MSE treino vs MSE teste por 
grau de flexibilidade — ilustrando o clássico trade-off: modelos muito simples têm alto erro (viés),
modelos muito complexos superajustam (variância).
O ponto roxo marca o grau com menor MSE de teste, indicando o modelo com melhor generalização.
