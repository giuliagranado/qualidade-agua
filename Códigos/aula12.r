DADOS <- read.csv('/content/Dataset_novo_V3.csv', sep = ',')
ints <- ints <- function(col) as.numeric(gsub(",",".",col))

silhueta <- function(g, D) { 
D <- as.matrix(D); n <- length(g)
sapply(1:n, function(i) {
a <- mean(D[i, g == g[i] & seq_len(n) != i]) 
b <- min(tapply(D[i, g != g[i]], g[g != g[i]], mean))
if (is.nan(a)) 0 else (b - a) / max(a, b) }) 
}
       
d <- na.omit(data.frame(y = ints(DADOS$DBO..5..20..mg.L), x1 = ints(DADOS$pH.U.pH), x2 = ints(DADOS$Temperatura.da.Água.ºC), x3 = ints(DADOS$Nitrogênio.Total), x4 = ints(DADOS$Turbidez.UNT)))
X <- d[, -1]
pca <- prcomp(X, scale. = TRUE)
summary(pca); round(pca$rotation[, 1:2], 2)

Z <- scale(X); D <- dist(Z)
S <- sapply(2:8, function(k) { set.seed(1)
mean(silhueta(kmeans(Z, centers = k, nstart = 25)$cluster, D)) })
K <- (2:8)[which.max(S)]; set.seed(1); km <- kmeans(Z, centers = K, nstart = 25)
aggregate(X, list(grupo = km$cluster), mean) 
par(mfrow = c(1, 2), pty = "s")
plot(pca$x[, 1:2], col = km$cluster, pch = 16)
boxplot(d$y ~ km$cluster, xlab = "grupo", ylab = "y") 
