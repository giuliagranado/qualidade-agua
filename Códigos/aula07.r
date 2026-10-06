IQA <- read.csv("/content/Dataset_filtrado.csv",sep=";")
library(ggplot2)

PH <- c(as.numeric(gsub(",",".",IQA[,8][1:48])))
QUALIS <- c(as.numeric(gsub(",",".",IQA[,31][1:48])))

cazul = "steel blue"
claranja ="orange"
cverde = "green"
croxo = "purple"

mse <- function(model, actual_response, predictor_values) {
  predictions <- predict(model, data.frame(ph = predictor_values))
  return(mean((actual_response - predictions)^2))
}

n = length(PH)

k <- 14
dobra <- sample(rep(1:k, length = n))
DADOS <- data.frame (
  ph = PH,
  qualis = QUALIS)
erro <- numeric(k)
for (j in 1:k) {
  m <- lm(qualis ~ poly(ph, 3), data = DADOS[dobra != j,])
  erro[j] <- mse(m,DADOS[dobra == j, 2],DADOS[dobra == j, 1])
}
round(erro)
mean(erro)

cv <- function(g, k = 5) { d <- sample(rep(1:k, length = n))
mean(sapply(1:k, function(j)
mse(lm(qualis ~ poly(ph, g), data = DADOS[d != j, ]),
DADOS[dobra == j, 2],DADOS[dobra == j, 1])))
}

graus <- 1:6

round(setNames(sapply(graus, cv), paste0("grau ", graus)))

avulsa <- function(g) {
  i <- sample(n,33)
  mse(lm(qualis ~ poly(ph, g),
  data = DADOS[i, ]), DADOS[-i,2],DADOS[-i,1])
}
M <- replicate(6, sapply(graus, avulsa))
cv5 <- sapply(graus, cv)
par(mar = c(4,4,1,1), pty = "s")
matplot(graus, M, type = "l", lty = 1, lwd = 1,
col = "gray70", log = "y",
xlab = "grau (flexibilidade)",
ylab = "MSE de validacao")
lines(graus, cv5, col = croxo, lwd = 4)


B <- 2000
b1 <- replicate(B, {
i <- sample(n, 48, replace = TRUE)
coef(lm(qualis ~ ph, data = DADOS[i, ]))[2]
})
par(mar = c(4,4,1,1), pty = "s")
hist(b1, breaks = 30,
main = "", xlab = "beta1 reamostrado",
ylab = "frequencia")
abline(v = quantile(b1, c(.025, .975)), col = claranja, lwd = 2, lty = 2)
abline(v = coef(lm(QUALIS ~ PH)[2],col = croxo, lwd = 3))

sd(b1)
quantile(b1, c(0.025, 0.975)) 
summary(lm(QUALIS ~ PH))$coef[2, 1:2]
