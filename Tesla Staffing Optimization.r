# TESLA SUPPORT STAFFING OPTIMIZATION

if(!require(lpSolve)) install.packages("lpSolve")
library(lpSolve)

# Call Volume Data (7am - 9pm)
calls <- c(40, 85, 70, 95, 80, 35, 10) 

# Cost Vector
# 1-5:  FT Start 7am, 7am(B), 9am, 9am(B), 11am      ($120)
# 6-9:  FT Start 11am(B), 1pm, 1pm(B), 3pm           ($150 - Includes evening pay)
# 10:   PT Start 3pm                                 ($150)
# 11:   PT Start 5pm                                 ($180)
costs <- c(120, 120, 120, 120, 120, 150, 150, 150, 150, 150, 180)

# Constraint Matrix
A_matrix <- matrix(c(
  1,0,0,0,0,0,0,0,0,0,0, # 7-9
  0,1,1,0,0,0,0,0,0,0,0, # 9-11
  1,0,0,1,1,0,0,0,0,0,0, # 11-1
  0,1,1,0,0,1,1,0,0,0,0, # 1-3
  0,0,0,1,1,0,0,1,1,1,0, # 3-5
  0,0,0,0,0,1,1,0,0,1,1, # 5-7
  0,0,0,0,0,0,0,1,1,0,1  # 7-9
), nrow=7, byrow=TRUE)

# Demand Calculation
eng_demand <- ceiling((calls * 0.8)/6)
span_demand <- ceiling((calls * 0.2)/6)
total_demand <- ceiling(calls/6)


# =============================================================================
# QUESTION 1 & 2: SEPARATE LANGUAGES (STAFFING & COST)

# English
res_eng <- lp("min", costs, A_matrix, rep(">=", 7), eng_demand, all.int=TRUE)

# Spanish
res_span <- lp("min", costs[1:9], A_matrix[,1:9], rep(">=", 7), span_demand, all.int=TRUE)

# Total Cost
total_cost_Q2 <- res_eng$objval + res_span$objval

cat("\nQUESTION 1: STAFFING PLAN\n")
print("English Agents (Cols 1-11):")
print(res_eng$solution)
print("Spanish Agents (Cols 1-9):")
print(res_span$solution)

cat("\nQUESTION 2: MINIMUM COST (SEPARATE)\n")
cat("Total Operating Cost: $", total_cost_Q2, "\n")


# ==============================================================================
# QUESTION 3 & 4: RESTRICTED AVAILABILITY (STAFFING & COST)

# Restriction: Max 1 English agent starting at 1pm and 3pm
rest_1 <- c(0,0,0,0,0,0,1,1,0,0,0) # 1pm Limit
rest_2 <- c(0,0,0,0,0,0,0,0,1,0,0) # 3pm Limit

A_rest <- rbind(A_matrix, rest_1, rest_2)
rhs_rest <- c(eng_demand, 1, 1)
dir_rest <- c(rep(">=", 7), "<=", "<=")

# English Restricted
res_cap <- lp("min", costs, A_rest, dir_rest, rhs_rest, all.int=TRUE)
total_cost_Q4 <- res_cap$objval + res_span$objval

cat("\nQUESTION 3: STAFFING PLAN\n")
print("English Agents (Restricted):")
print(res_cap$solution)
print("(Spanish staffing remains same as Question 1)")

cat("\nQUESTION 4: MINIMUM COST\n")
cat("Total Operating Cost: $", total_cost_Q4, "\n")


# ==============================================================================
# QUESTION 5 & 6: BILINGUAL AGENTS (STAFFING & COST)

# Solve (Single pool using all 11 shift options)
res_bi <- lp("min", costs, A_matrix, rep(">=", 7), total_demand, all.int=TRUE)

cat("\nQUESTION 5: STAFFING PLAN\n")
print("Bilingual Agents (Cols 1-11):")
print(res_bi$solution)

cat("\nQUESTION 6: MINIMUM COST\n")
cat("Total Operating Cost: $", res_bi$objval, "\n")


# ==============================================================================
# QUESTION 7: WAGE INCREASE

cost_diff <- total_cost_Q2 - res_bi$objval
percent_inc <- cost_diff / res_bi$objval

cat("\nQUESTION 7: MAX WAGE INCREASE\n")
cat("Maximum Percentage Increase:", round(percent_inc*100, 1), "%\n")