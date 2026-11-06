library(splines); library(mgcv)
d <- na.omit(data.frame(y = DBO, x1 = PH, x2 = NITRO_TOT, x3 = TEMP))

set.seed(1); dobra <- sample(rep(1:6, length = nrow(d)))
cv_de <- function(ajusta) mean(sapply(1:5, function(j) { # CV(5) de um modelo
tr <- d[dobra != j, ]; va <- d[dobra == j, ]
mean((va$y - ajusta(tr, va))^2)
}))

cv_de(function(tr, va) mean(tr$y)) # linha de base
cv_de(function(tr, va) predict(lm(y ~ x1 + x2 + x3, data = tr), va)) # MQO
sapply(2:8, function(k) cv_de(function(tr, va) # spline em x1
predict(lm(y ~ ns(x1, df = k) + x2 + x3, data = tr), va)))
print(cv_de(function(tr, va) mean(tr$y)))
cv_de(function(tr, va) predict(gam(y ~ s(x1, k = 3) + s(x2, k = 3) + s(x3, k = 3), data = tr), va)) # GAM
g <- gam(y ~ s(x1, k = 3) + s(x2, k = 3) + s(x3, k = 3), data = d)
round(summary(g)$s.table[, "edf"], 2) # perto de 1 = reta
par(mfrow = c(1, 3), pty = "s"); plot(g, scheme = 1) 
