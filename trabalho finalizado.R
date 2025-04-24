library(dplyr)
library(ggplot2)
library(tidyr)
library(readr)
library(stringr)
library(forcats)
library(plotly)

dados <- read_csv(
  "C:/Users/PC/Downloads/CreditScrore.csv",
  col_types = cols(
    ID = col_character(),
    Customer_ID = col_character(),
    Month = col_character(),
    Name = col_character(),
    Age = col_double(),
    SSN = col_character(),
    Occupation = col_character(),
    Annual_Income = col_double(),
    Monthly_Inhand_Salary = col_double(),
    Num_Bank_Accounts = col_double(),
    Num_Credit_Card = col_double(),
    Interest_Rate = col_double(),
    Num_of_Loan = col_character(),
    Type_of_Loan = col_character(),
    Delay_from_due_date = col_double(),
    Num_of_Delayed_Payment = col_character(),
    Changed_Credit_Limit = col_character(),
    Num_Credit_Inquiries = col_double(),
    Credit_Mix = col_character(),
    Outstanding_Debt = col_character(),
    Credit_Utilization_Ratio = col_double(),
    Credit_History_Age = col_character(),
    Payment_of_Min_Amount = col_character(),
    Total_EMI_per_month = col_double(),
    Amount_invested_monthly = col_character(),
    Payment_Behaviour = col_character(),
    Monthly_Balance = col_double(),
    Credit_Score = col_character()
  )
)

dados <- dados %>% mutate(across(where(is.numeric), ~replace_na(., 0)))

dados$Outstanding_Debt <- as.numeric(gsub(",", "", dados$Outstanding_Debt))
dados$Credit_History_Age_Num <- as.numeric(str_extract(dados$Credit_History_Age, "\\d+"))

unique(dados$Outstanding_Debt)

dados_clean <- dados[!is.na(dados$Outstanding_Debt), ]
dados$Outstanding_Debt[is.na(dados$Outstanding_Debt)] <- mean(dados$Outstanding_Debt, na.rm = TRUE)
dados$Outstanding_Debt[is.na(dados$Outstanding_Debt)] <- median(dados$Outstanding_Debt, na.rm = TRUE)

plot_ly(dados, x = ~Age, type = "histogram", nbinsx = 30, name = "Idade") %>%
  layout(title = "Distribuição da Idade", xaxis = list(title = "Idade"), yaxis = list(title = "Frequência"))

ggplot(dados, aes(x = Monthly_Inhand_Salary)) +
  geom_density(fill = "#33a02c", alpha = 0.6) +
  labs(title = "Distribuição do Salário Mensal", x = "Salário", y = "Densidade") +
  theme_minimal(base_size = 16)

plot_ly(dados, x = ~factor(Num_Bank_Accounts), type = "histogram", name = "Contas Bancárias") %>%
  layout(
    title = "Distribuição do Número de Contas Bancárias",
    xaxis = list(title = "Nº de Contas Bancárias (discretas)", type = "category"),
    yaxis = list(title = "Frequência", range = c(0, 1000))
  )

plot_ly(dados, x = ~factor(Num_Credit_Card), type = "histogram", name = "Cartões de Crédito") %>%
  layout(
    title = "Distribuição do Número de Cartões de Crédito",
    xaxis = list(title = "Nº de Cartões de Crédito (discretos)", type = "category"),
    yaxis = list(title = "Frequência", range = c(0, 1000))
  )

plot_ly(dados, x = ~Credit_Score, type = "histogram", name = "Score de Crédito") %>%
  layout(title = "Distribuição do Score de Crédito", xaxis = list(title = "Score"), yaxis = list(title = "Frequência"))

plot_ly(dados, x = ~Annual_Income, type = "histogram", nbinsx = 20, name = "Renda Anual") %>%
  layout(
    title = "Distribuição da Renda Anual",
    xaxis = list(title = "Renda Anual (em unidades monetárias)", range = c(0, max(dados$Annual_Income, na.rm = TRUE))),
    yaxis = list(title = "Frequência", range = c(0, 1500))
  )

plot_ly(dados, x = ~Outstanding_Debt, type = "histogram", nbinsx = 30, name = "Dívida Pendente") %>%
  layout(title = "Distribuição da Dívida Pendente", xaxis = list(title = "Valor da Dívida"), yaxis = list(title = "Frequência"))

plot_ly(dados, x = ~Payment_Behaviour, type = "histogram", name = "Comportamento de Pagamento") %>%
  layout(title = "Comportamento de Pagamento", xaxis = list(title = "Comportamento"), yaxis = list(title = "Frequência"))

ggplot(dados, aes(x = Credit_Utilization_Ratio)) +
  geom_density(fill = "#fb9a99") +
  labs(title = "Razão de Utilização de Crédito", x = "Razão", y = "Densidade") +
  theme_minimal(base_size = 16)

dados$Credit_History_Age_Num <- as.numeric(str_extract(dados$Credit_History_Age, "\\d+"))
ggplot(dados, aes(x = Credit_History_Age_Num)) +
  geom_histogram(binwidth = 1, fill = "#a6cee3", color = "white") +
  labs(title = "Idade do Histórico de Crédito", x = "Meses", y = "Frequência") +
  theme_minimal(base_size = 16)