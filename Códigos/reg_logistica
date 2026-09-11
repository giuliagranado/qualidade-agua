Dataset <- read.csv('/content/Dataset Infoaguas.csv', sep = ';')

BERTchuva <- c(Dataset[,75][1:16])
BERTPH <- c(as.numeric(gsub(",",".",Dataset[,29][1:16])))
CUBAchuva <- c(Dataset[,75][17:32])
CUBAPH <- c(as.numeric(gsub(",",".",Dataset[,29][17:32])))
SANTchuva <- c(Dataset[,75][33:48])
SANTPH <- c(as.numeric(gsub(",",".",Dataset[,29][33:48])))
plots <- function(bin,desc,n){
  m <- glm(bin ~ desc, family= binomial)
  exp(coef(m))

  cazul <- "steelblue"
  claranja <- "orange"
  cverde <- "green"
  par(mar=c(4,4,1,1), pty= "s") # quadrado
  plot(desc, bin, pch= 19, col = cazul,xlab= "PH", ylab= "Chuva")
  abline(lm(bin~ desc), col = cverde, lwd=2, lty=2)
  s <- seq(5.5, 8, length= n)
  lines(s, predict(m, data.frame(bin = s),type= "response"), col = claranja, lwd=3)
  abline(h=c(0,1), col= "gray", lty=3) }

plots(BERTchuva,BERTPH,16)

plots(CUBAchuva,CUBAPH,16)

plots(SANTchuva,SANTPH,16)

chuva <- c(Dataset[,75][1:48])
PH <- c(as.numeric(gsub(",",".",Dataset[,29][1:48])))

plots(chuva,PH,48)
