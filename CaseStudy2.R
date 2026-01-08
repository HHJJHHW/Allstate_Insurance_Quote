# Case Study 2
# Section A, Team #12
# Ankit Chandekar, Jinghua He, Abigail Miller
# Muhammad Memon, Nikki Reddy, Katherine Zhang
#################################################3

source("DataAnalyticsFunctions.R")
ALLcost <- read.csv("ALLSTATEcost.csv")

### Data Preparation ######

# Drop irrelevant columns
drop <- c("customer_ID","shopping_pt","record_type","time","location")
DATA <- ALLcost[,!(names(ALLcost) %in% drop)]


# create factors
DATA$car_value <-  factor(DATA$car_value)
DATA$day <-  factor(DATA$day)
DATA$state <-  factor(DATA$state)
duration_NA <-  ifelse( is.na(DATA$duration_previous) , 1, 0 )


# number of NA in duration corresponds to 5% of the sample 783/15483
sum(duration_NA)/length(duration_NA)

# create a dummy variable
# making NA to zero
DATA$duration_previous[duration_NA>0] <-0 

# lets look at C_previous
# creating a dummy variable for NA
C_NA <-  ifelse( is.na(DATA$C_previous), 1, 0 ) 

# 783 NA that is directly correlated with nulls in duration
sum(C_NA)
cor(C_NA,duration_NA)

# C_previous as factor
# making NA to zero
DATA$C_previous[C_NA>0] <-0 
DATA$C_previous <-  factor(DATA$C_previous)

# Lets look at risk_factor as well
risk_NA <- ifelse(is.na(DATA$risk_factor), 1, 0 )
sum(risk_NA)

# The NA for those are different observations
DATA$risk_factor[risk_NA>0] <-0                     
# treat that as a level "0" (a new category of risk...)
DATA$risk_factor <-  factor(DATA$risk_factor)                           

DATA$homeowner <-  factor(DATA$homeowner)
DATA$married_couple <-  factor(DATA$married_couple)
summary(DATA)
# no NA's in the data at this point

#################################
#### Question 1: Visualization
#################################
library(ggplot2)
ggplot(DATA, aes(x = car_age, y = cost)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(
    title = "Insurance Cost Dependent on Car Age",
    x = "Car Age (years)",
    y = "Insurance Cost"
  ) +
  theme_minimal()


#################################
#### Question 2: A first linear Regression Model. 
#################################
# Model with interaction variables. R2 = 0.4780337
result_interactions <- glm(cost ~ .+(A+B+C+D+E+F+G)^2, data = DATA) 
summary(result_interactions)
1 - (result_interactions$dev/result_interactions$null)


#################################
### Question 4 Provide quotes for new.customers
#################################
library(quantreg)
new.customers <- readRDS("NewCustomers.Rda")
##
# quantile set + lower bound
grid    <- seq(0.10, 0.90, by = 0.05)   # evaluate 0.10, 0.15, ..., 0.90
min_tau <- 0.10                         # choose among taus >= 0.10
floor_price <- 5

# model with interactions, fit for all taus in grid
model <- rq(cost ~ . + (A+B+C+D+E+F+G)^2, tau = grid, data = DATA)

# predict quantiles for new customers (n_customers x length(grid))
preds <- predict(model, newdata = new.customers)

# expected revenue for taus >= min_tau
keep <- grid >= min_tau
preds_keep <- preds[, keep, drop = FALSE]
taus_keep  <- grid[keep]

preds_floor <- pmax(preds_keep, floor_price)
ER          <- sweep(preds_floor, 2, 1 - taus_keep, "*")

# pick the best quantile per customer
best_idx <- apply(ER, 1, which.max)
ChosenQuantile <- taus_keep[best_idx]
FinalQuote     <- preds_floor[cbind(1:nrow(preds_floor), best_idx)]
ExpectedRevenue <- ER[cbind(1:nrow(ER), best_idx)]

# median for context (closest column to 0.5 in 'grid')
median_col <- which.min(abs(grid - 0.5))
Median <- preds[, median_col]

# summary table
out <- data.frame(
  Customer       = seq_len(nrow(new.customers)),
  Median         = round(Median, 2),
  ChosenQuantile = ChosenQuantile,
  FinalQuote     = round(FinalQuote, 2),
  ExpectedRevenue = round(ExpectedRevenue, 2)
)
print(out)

