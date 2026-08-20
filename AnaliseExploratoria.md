# 3. Análise Exploratória dos Dados

## 3.1 Objetivo da análise

A análise exploratória tem como objetivo compreender as características do conjunto de dados antes da aplicação dos modelos de classificação.

Nesta etapa serão investigados:

- a estrutura e dimensão do dataset;
- os tipos de variáveis;
- a presença de dados ausentes;
- possíveis inconsistências;
- a distribuição dos parâmetros de qualidade da água;
- valores extremos (outliers);
- a variação dos parâmetros ao longo do período analisado;
- relações entre os diferentes parâmetros físico-químicos e microbiológicos.

A análise é realizada sobre os dados provenientes do monitoramento da qualidade da água disponibilizado pela CETESB.

---

## 3.2 Caracterização do Dataset

### 3.2.1 Estrutura dos dados

O dataset utilizado contém dados de monitoramento da qualidade da água coletados entre **2022 e 2025**, correspondendo a um período de quatro anos.

O conjunto de dados foi previamente filtrado de acordo com o recorte definido para a pesquisa.

O arquivo contém informações relacionadas a:

- identificação do ponto de coleta;
- data e horário da coleta;
- parâmetros físico-químicos;
- parâmetros microbiológicos;
- parâmetros hidrobiológicos;
- compostos orgânicos;
- características do corpo hídrico;
- localização do ponto de monitoramento.

A estrutura original dos dados é apresentada em formato longo, em que cada registro representa a medição de um determinado parâmetro em uma determinada coleta.

### 3.2.2 Tipos de variáveis

As variáveis presentes no dataset podem ser divididas em diferentes categorias.

| Categoria | Exemplos |
|---|---|
| Identificador | `Cod_Interaguas`, `Código Ponto` |
| Temporal | `Data Coleta`, `Hora Coleta` |
| Categórica nominal | `Município`, `Sistema Hídrico`, `Parametro`, `Unidade` |
| Categórica ordinal | `CLASSE` |
| Quantitativa contínua | `Valor`, `Altitude` |
| Coordenada | `Latitude`, `Longitude` |

O dicionário de dados utilizado no projeto classifica `Valor` como variável quantitativa contínua e `Parametro` como variável qualitativa nominal. :contentReference[oaicite:1]{index=1}

---

## 3.3 Qualidade dos Dados

Antes da realização das análises estatísticas, foi necessário verificar a qualidade dos dados.

Foram avaliados:

- valores ausentes;
- tipos de dados;
- valores abaixo ou acima do limite de detecção;
- possíveis valores extremos;
- consistência das unidades de medida.

### 3.3.1 Valores ausentes

A quantidade de valores ausentes foi calculada para cada variável.

```python
df.isnull().sum()
