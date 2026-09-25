## Explicação do Código — Avaliação de Modelos (IQA × pH)

### 1. Divisão treino/teste

```r
TreinoPH <- c(PH[1:11], PH[17:27], PH[33:43])
Teste    <- c(PH[12:16], PH[28:32], PH[44:48])
```

Seguindo o protocolo do anexo, os dados são divididos antes de qualquer ajuste: 11 observações por cidade vão para o treino (33 no total) e 5 por cidade vão para o teste (15 no total) — aproximadamente 70/30. O anexo é enfático: o modelo nunca pode ver o teste antes da avaliação final.

---

### 2. Três candidatos polinomiais

```r
for (k in 1:3)
  lines(g, predict(lm(TreinoIQA ~ poly(TreinoPH, c(1,3,12)[k])), ...))
```

Ajustam-se três polinômios de graus 1, 3 e 12 — exatamente os três candidatos do anexo (reta simples, curva suave, e o que persegue cada ponto). O `poly(TreinoPH, g)` fabrica as colunas de potências e entrega ao mesmo estimador de mínimos quadrados, como o anexo descreve.

---

### 3. Função `mse()` e comparação treino vs. teste

```r
for (g in c(1, 3, 12)) {
  mse_treino_val <- mse(m, TreinoIQA, TreinoPH)
  mse_teste_val  <- mse(m, TesteIQA, Teste)
}
```

Para cada grau, o MSE é calculado nos dois conjuntos separadamente. O anexo prevê exatamente esse resultado: o erro de treino só cai com a flexibilidade, enquanto o erro de teste cai até certo grau e volta a subir — o grau 12 "decora a lista" (sobreajuste).

---

### 4. Curva em U

```r
matplot(graus, cbind(etr, ete), ...)
points(which.min(ete), min(ete), pch = 19, cex = 1.4, col = croxo)
```

O loop de graus 1 a 12 calcula `etr` (treino, verde) e `ete` (teste, laranja) para cada flexibilidade. O `matplot` plota as duas curvas — a verde só desce, a laranja forma o **U**. O ponto roxo marca o fundo do U, o grau com menor MSE de teste, que o anexo identifica como o melhor candidato: nem rígido demais, nem decorador.
