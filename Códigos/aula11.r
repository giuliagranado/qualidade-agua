install.packages('randomForest')
library(rpart); library(randomForest)

DADOS <- read.csv('/content/Dataset_novo_V3.csv', sep = ',')
DADOSM <- read.csv('/content/cancer_boca.csv', sep = ',')
ints <- ints <- function(col) as.numeric(gsub(",",".",col))
names(DADOS)
names(DADOSM)

d <- na.omit(data.frame(y = DADOS$Chuvas.nas.últimas.24h.0.1, x1 = ints(DADOS$Cod_Interaguas), x2 = ints(DADOS$DBO..5..20..mg.L), x3 = DADOS$Hora.Coleta))
set.seed(1); dobra <- sample(rep(1:8, length = nrow(d)))
cheia <- rpart(y ~ ., data = d, cp = 0.001, xval = dobra) # cresce e valida
tab <- cheia$cptable; i <- which.min(tab[, "xerror"])
tab[i, "xerror"] * mean((d$y - mean(d$y))^2) # CV(5) da melhor poda
arv <- prune(cheia, cp = tab[i, "CP"])

par(pty = "s"); plot(arv, uniform = TRUE, margin = 0.1); text(arv, cex = 0.7)
p <- ncol(d) - 1; ms <- unique(pmax(1, round(c(sqrt(p), p/3, p/2, p)))) # m candidatos
oob <- sapply(ms, function(m) { set.seed(1); tail(randomForest(y ~ ., data = d, mtry = m)$mse, 1) })
set.seed(1); rf <- randomForest(y ~ ., data = d, mtry = ms[which.min(oob)], importance = TRUE)
rf; varImpPlot(rf, scale = FALSE)
