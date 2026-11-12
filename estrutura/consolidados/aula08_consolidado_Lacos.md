<h1> Expansão e regularização </h1>
Foi escolhido testar com duas variáveis de nitrogênio distintas, por serem quase idênticas com a colinearidade de 0.978217984054931. Usando as duas o erro aumenta em torno de cinco vezes, como demonstra a tabela:

Estimate	Std. Error
ints(Nitrogˆnio.Kjeldahl.mg.l)	4.373598	0.6622833
ints(Nitrogˆnio.Amoniacal.mg.L)	2.440935	0.9655337

comparando o MQO com o Ridge para essas variáveis o resultados reduzem o range de pouco mais de -2 á 2 para pouco menos de 0 á 1, que descreve o range da variável mais adequadamente.

<h1>Ridge</h1>

O teste do ridge foi aplicado para a predição do IQA utilizando todos os parêmetros, resultando na seguinte tabela: 

lambda   0.01 | soma |beta|:   69.3 | maior |beta|: 8.4 <br>
lambda     50 | soma |beta|:     10 | maior |beta|: 0.9 <br>
lambda    500 | soma |beta|:    5.8 | maior |beta|: 0.3 <br>

O modelo foi escolheu um lambda minimo de 133.641444102936, com um RMSE de 11656.0227988738

<h1>Lasso</h1>

Assim como o ridge, o lasso foi aplicado no IQA descrito por todo o restante. o CV minimo foi de 65
