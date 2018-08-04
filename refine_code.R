# 0: Load the data in RStudio. 
install.packages("tidyr")
library(tidyr)
install.packages("dplyr")
library(dplyr)

read_csv(file.choose())
refine <- as.data.frame(refine_original)

# 1: Clean up brand names
refine$company <- tolower(refine$company)
refine$company <- refine$company %>% 
  sub(pattern = ".*\\ps$", replacement = "philips") %>%
  sub(pattern = "^ak.*", replacement = "akzo") %>%
  sub(pattern = "^u.*", replacement = "unilever") %>%
  sub(pattern = "^v.*", replacement = "van houten")

# 2: Separate product code and number
refine <- refine %>% 
  separate('Product code / number', c("product_code", "product_number"), sep = "-")

# 3: Add product categories 
refine <- refine %>% 
  mutate(product_category = ifelse(product_code == "p", "Smartphone", ifelse(product_code == "v", "TV", ifelse(product_code == "x", "Laptop", ifelse(product_code == "q", "Tablet", NA)))))

# 4: Add full address for geocoding
refine <- refine %>% 
  unite(full_address, c("address", "city", "country"), sep = ", ")

# 5: Create dummy variables for company and product category
refine <- refine %>% 
  mutate(company_philips = ifelse(company == "phillips", 1, 0)) %>% 
  mutate(company_akzo = ifelse(company == "akzo", 1, 0)) %>% 
  mutate(company_van_houte = ifelse(company == "van houten", 1, 0)) %>%
  mutate(company_unilever = ifelse(company == "unilever", 1, 0)) %>% 
  mutate(product_smartphone = ifelse(product_category == "Smartphone", 1, 0)) %>%
  mutate(product_tv = ifelse(product_category == "TV", 1, 0)) %>%
  mutate(product_laptop = ifelse(product_category == "Laptop", 1, 0)) %>%
  mutate(product_tablet = ifelse(product_category == "Tablet", 1, 0))

# 6: Submit the project on Github
write.csv(refine,'refine_clean.csv')
