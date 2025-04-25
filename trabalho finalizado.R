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

dados <- dados %>%
  mutate(Credit_Score = fct_na_value_to_level(Credit_Score, level = "Desconhecido"))

dados_agrupados <- dados %>%
  group_by(Customer_ID) %>%
  summarise(
    Age = mean(Age, na.rm = TRUE),
    Annual_Income = mean(Annual_Income, na.rm = TRUE),
    Monthly_Inhand_Salary = mean(Monthly_Inhand_Salary, na.rm = TRUE),
    Num_Bank_Accounts = mean(Num_Bank_Accounts, na.rm = TRUE),
    Num_Credit_Card = mean(Num_Credit_Card, na.rm = TRUE),
    Interest_Rate = mean(Interest_Rate, na.rm = TRUE),
    Outstanding_Debt = mean(Outstanding_Debt, na.rm = TRUE),
    Credit_Utilization_Ratio = mean(Credit_Utilization_Ratio, na.rm = TRUE),
    Credit_History_Age_Num = mean(Credit_History_Age_Num, na.rm = TRUE),
    Total_EMI_per_month = mean(Total_EMI_per_month, na.rm = TRUE),
    Monthly_Balance = mean(Monthly_Balance, na.rm = TRUE),
    Credit_Score = first(Credit_Score),
    Payment_Behaviour = first(Payment_Behaviour)
  )


plot_ly(dados, x = ~Monthly_Inhand_Salary, type = "histogram", nbinsx = 30, name = "Salário Mensal") %>%
  layout(title = "Distribuição do Salário Mensal", xaxis = list(title = "Salário"), yaxis = list(title = "Frequência"))

ggplot(dados, aes(x = Monthly_Inhand_Salary)) +
  geom_density(fill = "#33a02c", alpha = 0.6) +
  labs(title = "Distribuição do Salário Mensal", x = "Salário", y = "Densidade") +
  theme_minimal(base_size = 16)

plot_ly(dados_agrupados, x = ~Credit_Score, y = ~Age, type = "box", name = "Idade por Score") %>%
  layout(title = "Idade por Score de Crédito", xaxis = list(title = "Score de Crédito"), yaxis = list(title = "Idade"))

ggplot(dados_agrupados, aes(x = Credit_Score, y = Age, fill = Credit_Score)) +
  geom_boxplot() +
  labs(title = "Idade por Score de Crédito (Agrupado por Customer_ID)", x = "Score de Crédito", y = "Idade") +
  theme_minimal(base_size = 16) +
  theme(legend.position = "none")

plot_ly(dados_agrupados, x = ~Outstanding_Debt, type = "histogram", nbinsx = 30, name = "Dívida Pendente") %>%
  layout(title = "Distribuição da Dívida Pendente", xaxis = list(title = "Dívida Pendente"), yaxis = list(title = "Frequência"))

ggplot(dados_agrupados, aes(x = Outstanding_Debt)) +
  geom_histogram(binwidth = 500, fill = "#fb9a99", color = "white") +
  labs(title = "Distribuição da Dívida Pendente", x = "Dívida Pendente", y = "Frequência") +
  theme_minimal(base_size = 16)

plot_ly(dados_agrupados, x = ~Credit_Utilization_Ratio, type = "box", name = "Utilização de Crédito") %>%
  layout(title = "Razão de Utilização de Crédito", xaxis = list(title = "Razão"), yaxis = list(title = "Frequência"))

ggplot(dados_agrupados, aes(x = Credit_Utilization_Ratio)) +
  geom_density(fill = "#a6cee3", alpha = 0.6) +
  labs(title = "Razão de Utilização de Crédito", x = "Razão (%)", y = "Densidade") +
  theme_minimal(base_size = 16)
