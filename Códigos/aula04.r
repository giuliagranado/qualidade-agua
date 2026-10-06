IQA <- read.csv('/content/Dataset_filtrado (1).csv',sep=";")
library(ggplot2)

PH <- c(as.numeric(gsub(",",".",IQA[,8][1:48])))
QUALIS <- c(as.numeric(gsub(",",".",IQA[,31][1:48])))
BERTIOGA_IQA <- QUALIS[1:16]
CUBATÃO_IQA <- QUALIS[17:32]
SANTOS_IQA <- QUALIS[33:48]

SÓLIDOS <- c(as.numeric(IQA[,17][1:48]))
BERTIOGA_S <- sum(SÓLIDOS[1:16])
CUBATÃO_S <- sum(SÓLIDOS[17:32])
SANTOS_S <- sum(SÓLIDOS[33:48])

OXIGÊNIODISS <- c(as.numeric(gsub(",",".",IQA[,6][1:48])))
BERTIOGA <- OXIGÊNIODISS[1:16]
CUBATÃO <- OXIGÊNIODISS[17:32]
SANTOS <- OXIGÊNIODISS[33:48]

#COLI <- c(as.numeric(gsub(",",".",IQA[,7][1:48])))
TEMP <- c(as.numeric(gsub(",",".",IQA[,9][1:48])))
NIT <- c(as.numeric(gsub(",",".",IQA[,10][1:48])))
FOS <- c(as.numeric(gsub(",",".",IQA[,15][1:48])))
TURB <- c(as.numeric(gsub(",",".",IQA[,16][1:48])))

CIDADES = data.frame(
  cidades=c("Bertioga","Cubatão","Santos") ,
  sólidos=c(BERTIOGA_S,CUBATÃO_S,SANTOS_S))

  cazul = "steel blue"
  claranja ="orange"


plot(BERTIOGA, BERTIOGA_IQA, pch = 19, col = cazul,
xlab = "OXIGÊNIODISS Bertioga", ylab = "IQA TOTAL Bertioga")
abline(lm(BERTIOGA_IQA ~ BERTIOGA), col = claranja, lwd = 3)

plot(CUBATÃO, CUBATÃO_IQA, pch = 19, col = cazul,
xlab = "OXIGÊNIODISS Cubatão", ylab = "IQA TOTAL Cubatão")
abline(lm(CUBATÃO_IQA ~ CUBATÃO), col = claranja, lwd = 3)

plot(SANTOS, SANTOS_IQA, pch = 19, col = cazul,
xlab = "OXIGÊNIODISS Santos", ylab = "IQA TOTAL Santos")
abline(lm(SANTOS_IQA ~ SANTOS), col = claranja, lwd = 3)

plot(OXIGÊNIODISS, QUALIS, pch = 19, col = cazul,
xlab = "OXIGÊNIODISS", ylab = "IQA TOTAL")
abline(lm(QUALIS ~ OXIGÊNIODISS), col = claranja, lwd = 3)

m <- lm(PH ~ QUALIS)
coef(m)

n <- lm(OXIGÊNIODISS ~ QUALIS)
coef(n)

cazul <- "steelblue"
claranja <- "orange"
plot(fitted(m), resid(m), pch = 19, col = cazul,
xlab = "PH", ylab = "IQA TOTAL")
abline(h = 0, col = claranja, lwd = 3, lty = 2)

cazul <- "steelblue"
claranja <- "orange"
plot(fitted(n), resid(n), pch = 19, col = cazul,
xlab = "OXIGÊNIODISS", ylab = "IQA TOTAL")
abline(h = 0, col = claranja, lwd = 3, lty = 2)

TreinoPH <- c(PH[1:11],PH[17:27],PH[33:43])
TreinoIQA <- c(BERTIOGA_IQA[1:11],CUBATÃO_IQA[1:11],SANTOS_IQA[1:11])
Teste <- c(PH[12:16],PH[28:32],PH[44:48])
TesteIQA <- c(BERTIOGA_IQA[12:16],CUBATÃO_IQA[12:16],SANTOS_IQA[12:16]) # Adicionado: Variável de resposta para o conjunto de teste

cverde = "green"
croxo = "purple"

par(mar = c(4,4,1,1), pty = "s")
plot(TreinoPH, TreinoIQA, pch = 19, col = cazul,
xlab = "PH", ylab = "IQA")
g <- seq(50, 250, length = 200)
for (k in 1:3)
lines(g, predict(lm(TreinoIQA ~ poly(TreinoPH, c(1,3,12)[k])),
data.frame(TreinoPH = g)),
col = c(cverde, claranja, croxo)[k], lwd = 2)

par(mar=c(4,4,1,1), pty= "s")
plot(TreinoIQA, TreinoPH, pch= 19, col = cazul,xlab= "", ylab= "")
g <- seq(5, 250, length= 200)
for (k in 1:3)
lines(g, predict(lm(TreinoPH~ poly(TreinoIQA,c(1,3,12)[k])),data.frame(TreinoIQA = g)),col=c(cverde, claranja, croxo)[k], lwd=2)

mse <- function(model, actual_response, predictor_values) {
  predictions <- predict(model, data.frame(TreinoPH = predictor_values))
  return(mean((actual_response - predictions)^2))
}

for (g in c(1, 3, 12)) {
  m <- lm(TreinoIQA ~ poly(TreinoPH, g))

  mse_treino_val <- mse(m, TreinoIQA, TreinoPH)

  mse_teste_val <- mse(m, TesteIQA, Teste) 

  cat("grau", format(g, width = 2),
      "| MSE treino:", format(round(mse_treino_val, 2), width = 5), 
      "| MSE teste:", round(mse_teste_val, 2), "\n") 
}

graus <- 1:12; etr <- ete <- numeric(12)
for (g in graus) {
  # Treinar o modelo com os dados de treino
  m <- lm(TreinoIQA ~ poly(TreinoPH, g))

  # Calcular o MSE para o conjunto de treino
  etr[g] <- mse(m, TreinoIQA, TreinoPH)

  # Calcular o MSE para o conjunto de teste
  ete[g] <- mse(m, TesteIQA, Teste)
}

par(mar = c(4,4,1,1), pty = "s")
matplot(graus, cbind(etr, ete), type = "l", lwd = 3, lty = 1, col = c(cverde, claranja),
        xlab = "grau (flexibilidade)", ylab = "MSE")
points(which.min(ete), min(ete), pch = 19, cex = 1.4, col = croxo)
legend("topright", legend = c("MSE Treino", "MSE Teste"), col = c(cverde, claranja), lty = 1, lwd = 3)
