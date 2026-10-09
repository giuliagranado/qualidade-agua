DADOS <- read.csv("/content/Dataset_novo_V3.csv", sep=",")
ints <- function(col) as.numeric(gsub(",",".",col))
x <- ints(DADOS[,7]); y <- ints(DADOS[,6])

knn_reg <- function(x0, x, y, k) mean(y[order(abs(x - x0))[1:k]])
nw <- function(x0, x, y, h) { w <- dnorm((x - x0) / h); sum(w * y) / sum(w) }
reta <- function(x0, x, y) sum(coef(lm(y ~ x)) * c(1, x0))
set.seed(1); dobra <- sample(rep(1:5, length = length(y)))
cv_de <- function(prever) mean(sapply(1:5, function(j) { 
  tr <- dobra != j; va <- dobra == j
mean((y[va] - sapply(x[va], prever, x = x[tr], y = y[tr]))^2)
}))

KKKKKMMMM <- function(x,y) { cv_de(reta) # a reta
ks <- c(3, 5, 10, 20, 40); ks <- ks[ks < 0.8 * length(y)] # KNN
sapply(ks, function(k) cv_de(function(x0, x, y) knn_reg(x0, x, y, k)))
hs <- sd(x) * c(0.05, 0.1, 0.2, 0.4) # kernel
sapply(hs, function(h) cv_de(function(x0, x, y) nw(x0, x, y, h)))
g <- seq(min(x), max(x), length = 200) # a figura
plot(x, y, col = "gray60"); lines(g, sapply(g, nw, x = x, y = y, h = hs[2]), lwd = 2) }

print("para PH")
KKKKKMMMM(x,y)

x <- ints(DADOS[,8])
print("para Temperatura")
KKKKKMMMM(x,y)

x <- ints(DADOS[,13])
print("para Nitro total")
KKKKKMMMM(x,y)

x <- ints(DADOS[,14])
print("para Fósforo total")
KKKKKMMMM(x,y)

x <- ints(DADOS[,15])
print("para Turbidez")
KKKKKMMMM(x,y)

x <- ints(DADOS[,16])
print("para Sólidos")
KKKKKMMMM(x,y)

x <- ints(DADOS[,19])
print("para Clorofila A")
KKKKKMMMM(x,y)
