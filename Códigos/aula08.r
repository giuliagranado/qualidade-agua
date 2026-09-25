pacotes <- c(
  "readr",
  "dplyr",
  "stringr",
  "ggplot2",
  "scales",
  "glmnet",
  "tibble"
)

instalar <- pacotes[!(pacotes %in% rownames(installed.packages()))]

if (length(instalar) > 0) {
  install.packages(instalar, repos = "https://cloud.r-project.org")

  #install.packages("glmnet", repos = " http://cran.rstudio.com")
#library(glmnet)

DADOS <- read.csv('/content/Dataset_infoaguas2.csv', sep = ';')
dados <- data.frame(DADOS[1:48,2:133])

dim(DADOS)
dim(dados)

nomes <- names(dados)
nomes

ints <- function(col) as.numeric(gsub(",",".",col))

treino <- dados[1:34,]
teste <- dados[35:48,]

# addicionar: filtragem que possa inluir tudo do dataset!

mse <- function(actual, predicted) mean((actual - predicted)^2)
rmse <- function (actual, predicted) sqrt(mse(ints(actual), as.numeric(predicted)))

#FUTURO: FAZER GENÉRICO
m_mqo <- lm(ints(IQA) ~ ints(Turbidez..UNT.), data = treino)
res <- c(R2 = summary(m_mqo)$r.squared,
R2_ajustado = summary(m_mqo)$adj.r.squared,
RMSE_treino = rmse(treino$IQA,fitted(m_mqo)),
RMSE_teste = rmse(teste$IQA,predict(m_mqo, newdata = teste)))
res

cor(ints(treino$Nitrogˆnio.Kjeldahl.mg.l), ints(treino$Nitrogˆnio.Amoniacal.mg.L))

summary(lm(ints(IQA) ~ ints(Nitrogˆnio.Kjeldahl.mg.l), data = treino))$coef[2, 1:2]

summary(lm(ints(IQA) ~ ints(Nitrogˆnio.Kjeldahl.mg.l) + ints(Nitrogˆnio.Amoniacal.mg.L),
data = treino))$coef[2:3, 1:2]

set.seed(7)
est <- replicate(300, {
i <- sample(35, 35, replace = TRUE); d <- dados[i, ]
clean <- cbind(c(ints(d[,16])),c(ints(d[,17])))
Xp <- as.matrix(clean)
c(coef(lm(ints(IQA) ~ ints(Temperatura.do.ar.Cø) + ints(Temperatura.Da.Agua.Cø), data = d))[2], # MQO
as.vector(coef(glmnet(Xp, ints(d$IQA), alpha = 0, lambda = 40)))[2]) # Ridge
})
par(mfrow = c(1,2), mar = c(4,4,2.2,1), pty = "s")
br <- seq(-3.5, 7.5, by = 0.4)
for (j in 1:2) {
hist(est[j, ], breaks = br, xlim = c(-3, 3), col = "steel blue",
border = "white", main = c("MQO","Ridge")[j],
xlab = "beta de Nitro", ylab = "frequencia")
abline(v = 0, col = "orange", lwd = 3)
}

lm(ints(IQA) ~ poly(ints(IQA), 3), data = dados) # polinomio (Aula 6)
lm(ints(IQA) ~  ints(Nitrogˆnio.Kjeldahl.mg.l) + I(ints(Nitrogˆnio.Kjeldahl.mg.l)^2), data = dados) # potencia explicita
lm(ints(IQA) ~ ints(Nitrogˆnio.Kjeldahl.mg.l) * ints(PH.U.pH), data = dados) # interacao: area, quartos, area:quartos
lm(ints(IQA) ~ log(ints(Nitrogˆnio.Kjeldahl.mg.l)), data = dados) # transformacao
lm(ints(IQA) ~ factor(ints(PH.U.pH)), data = dados) # qualitativa -> colunas 0/1

#FUTURO: FAZER GENÉRICO
S <- c(ints(dados[,132]))
for (i in 16:22){
  S <- cbind(S,c(ints(dados[,i])))
}
S <- as.data.frame(S)
X <- model.matrix(S ~ . * ., data = S) # TODAS as interacoes de 2 a 2
#dim(X)

S_treino <- c(ints(treino[,132]))
for (i in 16:22){
  S_treino <- cbind(S_treino,c(ints(treino[,i])))
}
S_treino <- as.data.frame(S_treino)

X_treino <- model.matrix(S_treino ~ . * ., data = S_treino)
Xs <- scale(X_treino[,-1]); yc <- ints(treino$IQA) - mean(ints(treino$IQA)) # padronizar e centrar
num_cols_Xs <- ncol(Xs)

for (lam in c(0.01, 50, 500)) {
b <- solve(crossprod(Xs) + lam*diag(num_cols_Xs), crossprod(Xs, yc))
cat("lambda", format(lam, width = 6),
"| soma |beta|:", format(round(sum(abs(b)), 1), width = 6),
"| maior |beta|:", round(max(abs(b)), 1), "\n")
}

set.seed(1)
cvr <- cv.glmnet(X[1:34,], ints(treino$IQA), alpha = 0) # alpha = 0 <=> Ridge
S_teste <- c(ints(teste[,132]))
for (i in 16:22){
  S_teste <- cbind(S_teste,c(ints(teste[,i])))
}
S_teste <- as.data.frame(S_teste)

Xn <- model.matrix(S_teste ~ . * ., data = S_teste)


c(lambda_min = cvr$lambda.min,
RMSE_teste = rmse(teste$PH.U.pH,predict(cvr, Xn, s = "lambda.min")))

gr <- glmnet(X_treino, ints(treino$IQA), alpha = 0) # Ridge
gl <- glmnet(X_treino, ints(treino$IQA), alpha = 1) # Lasso
par(mfrow = c(1,2), mar = c(4,4,3.6,1), pty = "s")
plot(gr, xvar = "lambda"); title("Ridge (L2)", line = 2.6)
plot(gl, xvar = "lambda"); title("Lasso (L1)", line = 2.6)

set.seed(1)
cvl <- cv.glmnet(X_treino, ints(treino$IQA), alpha = 1) # Lasso
par(mar = c(4,4,3.4,1), pty = "s")
plot(cvl) # o eixo x sai em LOG de lambda
# ... entao anotamos o lambda de verdade:
rot <- c("min = 4,8", "1ep = 12,2")
dx <- c(-0.18, 0.18); al <- c(1, 0)
for (k in 1:2) {
L <- c(cvl$lambda.min, cvl$lambda.1se)[k]
abline(v = log(L), lwd = 2,
col = c("purple", "orange")[k])
text(log(L) + dx[k], par("usr")[4] - 800,
rot[k], col = c("purple", "orange")[k],
adj = c(al[k], 0.5), cex = 0.72) }

i1 <- which(cvl$lambda == cvl$lambda.min); i2 <- which(cvl$lambda == cvl$lambda.1se)
data.frame(lambda = round(cvl$lambda[c(i1,i2)], 2), CV_mse = round(cvl$cvm[c(i1,i2)]),
CV_rmse = round(sqrt(cvl$cvm[c(i1,i2)]), 1),
preditores = as.integer(cvl$nzero[c(i1,i2)]),
row.names = c("lambda.min", "lambda.1se"))

c(CV_min = round(cvl$cvm[i1]), ep = round(cvl$cvsd[i1]),
limiar = round(cvl$cvm[i1] + cvl$cvsd[i1]), CV_1se = round(cvl$cvm[i2]))

cl <- coef(cvl, s = "lambda.1se")
round(cl[as.vector(cl) != 0, ], 2)

