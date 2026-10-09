# Análise Preditiva da Qualidade da Água

**Disciplina: Projeto Integrador III**

* Integrantes: Gabrielle Lara, Giulia Granado, Yuri Salgado
* Professor: João Paulo de Mello
* Curso: Tecnologia em Ciência de Dados — FATEC

---

## 📋 Descrição da pesquisa

### ❓ Pergunta de pesquisa

> Qual será a concentração de Oxigênio Dissolvido (mg/L) na água com base nas medições físico-químicas e ambientais da amostra?

### 🎯 Objetivo geral

Prever a concentração de Oxigênio Dissolvido (OD) na água do Complexo Billings a partir de medições físico-químicas e ambientais (como pH, temperatura, turbidez, nutrientes, clorofila-a e pluviometria). A previsão serve de apoio à decisão de operadores de Estações de Tratamento de Água (ETA) e gestores da bacia hidrográfica, que podem acionar aeração preventiva e ajustar a dosagem de insumos antes que a água chegue ao ponto de captação.

### 📅 Período da pesquisa

2022 a 2025 (histórico de monitoramento das estações amostradoras).

### 🔬 Área da pesquisa

Ciência de Dados aplicada ao monitoramento da qualidade da água e dos recursos hídricos, com foco em aprendizado estatístico supervisionado (regressão e predição).

---

## 🗂️ Dados utilizados

- **Base:** `Dataset_atual.csv`, com o histórico de monitoramento contínuo de estações amostradoras.
- **Pontos amostradores:** BILL02900, BIRP00500 e CFUG02900.
- **Tamanho:** 48 observações e 17 preditores físico-químicos e ambientais (pH, temperatura, turbidez, nutrientes, sólidos, pluviometria, clorofila-a, metais).
- **Variável resposta:** Oxigênio Dissolvido (OD), em mg/L.

---

## 📊 Resultados preliminares

Um modelo de regressão linear, avaliado por validação cruzada de 5 dobras, foi comparado com a linha de base (prever sempre a média).

| Modelo | RMSE (mg/L) |
|---|---|
| Linha de base (média) | 1,3604 |
| Regressão linear | 0,8557 |

O modelo reduziu o erro em **37,10%** em relação à linha de base, o que indica que os preditores ambientais carregam sinal real sobre o OD.

---

## 📁 Estrutura do repositório

```
qualidade-agua/
├── AnaliseExploratoria.md
├── Códigos/
├── entrega/
│   └── entrega_TeoriaAprendizado.pdf
├── estrutura/
├── LICENSE
└── README.md
```

---

## 📄 Documento da entrega

O texto completo da pesquisa está em [`entrega/entrega_TeoriaAprendizado.pdf`](./entrega/entrega_TeoriaAprendizado.pdf).
