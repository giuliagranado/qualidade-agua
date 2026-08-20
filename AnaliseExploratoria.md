## 1.Análise Exploratória de Dados
 
### 1.1 Caracterização do dataset
 
| Variável | valores observados |
|---|---|---|---|
| `Quantidade de registros` | 48 |
| `Quantidade de variáveis` | 133 |
| `Período` | 2022–2025 |
| `Pontos` |3 |
| `Cidades` | Bertioga, Cubatão e Santos |

### 1.2 Qualidade dos dados
 
| Variável | valores observados |
|---|---|---|---|
| `Valores ausentes` | 48 |
| `Quantidade de variáveis` | 133 |
| `Período` | 2022–2025 |
| `Pontos` |3 |
| `Cidades` | Bertioga, Cubatão e Santos |

 
### Parâmetros usados no cálculo do IQA (subconjunto de `Parametro`)
 
Dos 120 parâmetros monitorados neste ponto, apenas 9 compõem o IQA. Veja como cada um aparece **exatamente** na coluna `Parametro` do arquivo, e o cuidado necessário em cada caso:
 
| Variável do IQA | Nome exato em `Parametro` | Unidade observada | Observação |
|---|---|---|---|
| pH | `pH` | U.pH | Direto, sem ajuste |
| Temperatura | `Temperatura da Água` | ºC | O IQA usa o *afastamento* da temperatura de equilíbrio (Δt), não o valor absoluto |
| Oxigênio Dissolvido | `Oxigênio Dissolvido` | mg/L | ⚠️ A fórmula oficial do IQA exige **% de saturação**, não mg/L — é necessário converter (depende de temperatura e altitude) |
| DBO | `DBO (5, 20)` | mg/L | Direto |
| Coliformes Termotolerantes | `Escherichia coli**` | UFC/100mL | CETESB substitui coliformes termotolerantes por E. coli desde 2008, aplicando fator de correção de 1,25 sobre o resultado |
| Nitrogênio Total | *não existe coluna única* — somar `Nitrogênio Kjeldahl` + `Nitrogênio-Nitrato` + `Nitrogênio-Nitrito` | mg/L | Precisa ser calculado somando os 3 registros da mesma data |
| Fósforo Total | `Fósforo Total` | mg/L | Direto |
| Turbidez | `Turbidez` | UNT | Direto |
| Resíduo Total | `Sólido Total` | mg/L | Direto (existe também `Sólido Dissolvido Total` e `Sólido Suspenso Total`, que são componentes separados) |

### Observações específicas
 
- **Formato longo:** para calcular o IQA de uma data específica, é necessário **pivotar** os dados — transformar `Parametro` em colunas e `Valor` nos respectivos valores, filtrando apenas os 9 parâmetros da tabela acima, agrupados por `Data Coleta`.
- **`Sinal`:** quando preenchido (`<` ou `>`), o valor em `Valor` é o **limite de detecção do método**, não a medição real — é uma censura estatística à esquerda ou à direita, comum em variáveis-traço (ex.: compostos orgânicos voláteis). Isso deve ser tratado com cuidado na modelagem (não é um valor exato).
- **`Valor`:** decimal com vírgula na base original; precisa conversão para ponto antes de qualquer cálculo numérico (`str.replace(',', '.')`).
- **Um único ponto de amostragem:** este arquivo cobre apenas `SABO22500` (Rio Saboó).
- **`CLASSE`:** neste ponto a classe é "Salobra 2", o que indica água com influência de maré/mistura com água do mar — relevante para a discussão de resultados, já que corpos hídricos salobros têm padrões de qualidade distintos dos de água doce.
  
**Dicionário oficial (fonte primária):** as definições, pesos e curvas de qualidade de cada parâmetro do IQA seguem a documentação técnica oficial da CETESB, publicada como apêndice específico ("Índices de Qualidade das Águas") dentro do relatório anual de Qualidade das Águas Interiores. Como esse apêndice é republicado a cada ano, o caminho oficial para acessá-lo é pela própria página de [dicionário](https://www.cetesb.sp.gov.br/cetesb/qualidade_ambiental/agua/aguas_interiores/publicacoes_e_relatorios), selecionando o relatório do ano correspondente aos dados utilizados na pesquisa e localizando o apêndice de Índices de Qualidade das Águas dentro dele.
