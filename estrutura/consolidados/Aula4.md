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

### 4. Conclusão do código

Em geral os dados de cada cidade estavam disperssos, mas no de todas as cidades tem um agrupamento forte proveniente de santos que tem uma faixa de valores muito diferente dos outros. os dados de PH pareiam estar em funil, significando que a variância não era 0
