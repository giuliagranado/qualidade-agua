csv_path <- ifelse(file.exists("material/Dataset_novo_V3.csv"), "material/Dataset_novo_V3.csv", "Dataset_novo_V3.csv")
raw <- read.csv(csv_path, stringsAsFactors = FALSE, check.names = FALSE, fileEncoding = "UTF-8")

# Verificação automática de valores censurados (< ou >)
tem_censura <- any(sapply(raw, function(col) any(grepl("[<>]", as.character(col)))))

# Função auxiliar para converter texto com vírgula decimal em numérico
to_num <- function(x) {
  as.numeric(gsub(",", ".", trimws(as.character(x)), fixed = TRUE))
}

# Mapeamento dos 7 parâmetros do IQA selecionados

param_cols <- c(
  "Oxigênio Dissolvido mg/L",
  "pH U.pH",
  "Temperatura da Água ºC",
  "Nitrogênio Total",
  "Fósforo Total mg/L",
  "Turbidez UNT",
  "Sólido Dissolvido Total mg/L"
)

param_labels <- c(
  "Oxigênio dissolvido (mg/L)",
  "pH (U.pH)",
  "Temperatura da água (°C)",
  "Nitrogênio total (mg/L)",
  "Fósforo total (mg/L)",
  "Turbidez (UNT)",
  "Sólidos dissolvidos totais (mg/L)"
)

param_short <- c("OD", "pH", "Temperatura", "Nitrogênio Total",
                 "Fósforo Total", "Turbidez", "Sólidos Dissolvidos")

dados <- data.frame(
  ponto = trimws(raw[["Código Ponto"]]),
  data  = as.Date(raw[["Data Coleta"]], format = "%d/%m/%Y"),
  chuva = to_num(raw[["Chuvas nas últimas 24h 0/1"]]),
  stringsAsFactors = FALSE
)

for (i in seq_along(param_cols)) {
  dados[[param_short[i]]] <- to_num(raw[[param_cols[i]]])
}

# Separação por ponto de coleta em ordem cronológica (16 campanhas por ponto)
bill <- dados[dados$ponto == "BILL02900", ]; bill <- bill[order(bill$data), ]
birp <- dados[dados$ponto == "BIRP00500", ]; birp <- birp[order(birp$data), ]
cfug <- dados[dados$ponto == "CFUG02900", ]; cfug <- cfug[order(cfug$data), ]

# Diferenças de datas no pareamento montante-jusante
diff_dias <- pmax(abs(as.numeric(cfug$data - bill$data)),
                  abs(as.numeric(cfug$data - birp$data)))

# Ajuste dos 7 modelos de regressão linear simples (CFUG02900 ~ média SBC) + LOO-CV
n_pares <- nrow(cfug)
modelos <- list()
pred_loo_mat <- matrix(NA_real_, nrow = n_pares, ncol = length(param_short))
colnames(pred_loo_mat) <- param_short
obs_mat <- matrix(NA_real_, nrow = n_pares, ncol = length(param_short))
colnames(obs_mat) <- param_short
x_mat <- matrix(NA_real_, nrow = n_pares, ncol = length(param_short))
colnames(x_mat) <- param_short

res_list <- vector("list", length(param_short))

for (j in seq_along(param_short)) {
  nm <- param_short[j]
  x <- (bill[[nm]] + birp[[nm]]) / 2
  y <- cfug[[nm]]
  x_mat[, j] <- x
  obs_mat[, j] <- y
  df_xy <- data.frame(x = x, y = y)

  m_full <- lm(y ~ x, data = df_xy)
  modelos[[nm]] <- m_full
  sm <- summary(m_full)

  beta0 <- coef(m_full)[1]
  beta1 <- coef(m_full)[2]
  r_val <- cor(x, y)
  r2_in <- sm$r.squared
  p_val <- sm$coefficients[2, 4]

  y_pred_loo <- numeric(n_pares)
  y_base_loo <- numeric(n_pares)
  for (i in seq_len(n_pares)) {
    m_i <- lm(y ~ x, data = df_xy[-i, , drop = FALSE])
    y_pred_loo[i] <- suppressWarnings(predict(m_i, newdata = df_xy[i, , drop = FALSE]))
    y_base_loo[i] <- mean(df_xy$y[-i])
  }
  pred_loo_mat[, j] <- y_pred_loo

  rmse_loo <- sqrt(mean((y - y_pred_loo)^2))
  rmse_base_loo <- sqrt(mean((y - y_base_loo)^2))
  mae_loo <- mean(abs(y - y_pred_loo))
  r2_loo <- 1 - sum((y - y_pred_loo)^2) / sum((y - mean(y))^2)
  reducao_rmse <- (rmse_base_loo - rmse_loo) / rmse_base_loo * 100

  res_list[[j]] <- data.frame(
    Parametro = param_labels[j],
    Curto = nm,
    Intercepto = beta0,
    Beta = beta1,
    r = r_val,
    R2_in = r2_in,
    p_valor = p_val,
    R2_LOO = r2_loo,
    RMSE_LOO = rmse_loo,
    RMSE_Base_LOO = rmse_base_loo,
    MAE_LOO = mae_loo,
    Reducao_RMSE = reducao_rmse,
    stringsAsFactors = FALSE
  )
}

resultados <- do.call(rbind, res_list)

# Função de relatório para exibir summary() no texto
relatorio <- function(m) {
  op <- options(OutDec = ".", width = 78)
  on.exit(options(op))
  print(summary(m))}

for (j in seq_along(param_short)) {
  v <- dados[[param_short[j]]]
  dig <- ifelse(param_short[j] == "Fósforo Total", 3, 2)
  cat(sprintf("%s & %s & %s & %s & %s & %s \\\\\n",
              param_labels[j],
              formatC(mean(v), format = "f", digits = dig, decimal.mark = ","),
              formatC(sd(v), format = "f", digits = dig, decimal.mark = ","),
              formatC(min(v), format = "f", digits = dig, decimal.mark = ","),
              formatC(median(v), format = "f", digits = dig, decimal.mark = ","),
              formatC(max(v), format = "f", digits = dig, decimal.mark = ",")))}

par(mfrow = c(2, 4), mar = c(3.2, 3.6, 2.2, 0.8), cex.main = 0.9, cex.axis = 0.78)
cols_pt <- c("#4C78A8", "#72B7B2", "#E45756")
dados$ponto_f <- factor(dados$ponto, levels = c("BILL02900", "BIRP00500", "CFUG02900"))
for (j in seq_along(param_short)) {
  nm <- param_short[j]
  boxplot(dados[[nm]] ~ dados$ponto_f, col = cols_pt,
          names = c("BILL", "BIRP", "CFUG"),
          main = nm, xlab = "", ylab = "", las = 1)
}
plot.new()
legend("center", legend = c("BILL02900 (SBC - Montante)",
                            "BIRP00500 (SBC - Montante)",
                            "CFUG02900 (Cubatão - Jusante)"),
       fill = cols_pt, bty = "n", cex = 0.85)

for (j in seq_len(nrow(resultados))) {
  row <- resultados[j, ]
  dig_err <- ifelse(row$Curto == "Fósforo Total", 4, 2)
  dig_b0  <- ifelse(row$Curto == "Fósforo Total", 3, 2)
  cat(sprintf("%s & %s & %s & %s & %s & %s & %s & %s & %s & %s \\\\\n",
              row$Curto,
              formatC(row$Intercepto, format = "f", digits = dig_b0, decimal.mark = ","),
              formatC(row$Beta, format = "f", digits = 3, decimal.mark = ","),
              formatC(row$r, format = "f", digits = 3, decimal.mark = ","),
              formatC(row$R2_in, format = "f", digits = 3, decimal.mark = ","),
              formatC(row$p_valor, format = "f", digits = 3, decimal.mark = ","),
              formatC(row$R2_LOO, format = "f", digits = 2, decimal.mark = ","),
              formatC(row$RMSE_LOO, format = "f", digits = dig_err, decimal.mark = ","),
              formatC(row$RMSE_Base_LOO, format = "f", digits = dig_err, decimal.mark = ","),
              formatC(row$MAE_LOO, format = "f", digits = dig_err, decimal.mark = ",")))

par(mfrow = c(2, 4), mar = c(3.6, 3.6, 2.2, 0.8), cex.main = 0.88, cex.axis = 0.78, cex.lab = 0.8)
for (j in seq_along(param_short)) {
  nm <- param_short[j]
  x <- x_mat[, j]
  y <- obs_mat[, j]
  plot(x, y, pch = 19, col = "#2C5F8A",
       main = sprintf("%s (R2 LOO = %.2f)", nm, resultados$R2_LOO[j]),
       xlab = "Média SBC", ylab = "CFUG02900", las = 1)
  abline(modelos[[nm]], col = "#E45756", lwd = 2)}

plot.new()
legend("center", legend = c("Campanha (n = 16)", "Reta MQO"),
       col = c("#2C5F8A", "#E45756"), pch = c(19, NA), lty = c(NA, 1), lwd = c(NA, 2),
       bty = "n", cex = 0.85)

par(mfrow = c(3, 1), mar = c(2.8, 4.0, 2.0, 1.0), cex.main = 0.95, cex.axis = 0.82)
idx_sig <- c(3, 6, 1) # Temperatura, Turbidez, OD
datas_cfug <- cfug$data
for (k in idx_sig) {
  nm <- param_short[k]
  y_obs <- obs_mat[, k]
  y_hat <- pred_loo_mat[, k]
  ylim_r <- range(c(y_obs, y_hat), na.rm = TRUE)
  plot(datas_cfug, y_obs, type = "b", pch = 19, col = "#1F4E78", lwd = 1.8,
       ylim = ylim_r, main = paste0(param_labels[k], " — RMSE LOO = ",
                                    formatC(resultados$RMSE_LOO[k], format = "f", digits = 2, decimal.mark = ",")),
       xlab = "", ylab = nm, las = 1)
  lines(datas_cfug, y_hat, type = "b", pch = 17, col = "#D95F02", lty = 2, lwd = 1.6)
  legend("topright", legend = c("Observado (CFUG02900)", "Previsto (LOO)"),
         col = c("#1F4E78", "#D95F02"), pch = c(19, 17), lty = c(1, 2), bty = "n", cex = 0.8)
}
