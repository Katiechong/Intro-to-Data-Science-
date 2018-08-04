# 0: Load the data in RStudio
titanic_original <- read.csv(file.choose())
titanic <- as.data.frame(titanic_original)
library(tidyr)
library(dplyr)

# 1: Port of embarkation
titanic$embarked[titanic$embarked == ""] <- "S"

# 2: Age
mean_age <- mean(titanic$age, na.rm = TRUE)
titanic$age[is.na(titanic$age)] <- mean_age

# 3: Lifeboat
titanic$boat[titanic$boat == ""] <- NA

# 4: Cabin
titanic %>% mutate(has_cabin_number = ifelse(titanic$cabin == "", 0, 1))

# 5: Submit the project on Github
write.csv(titanic, "titanic_clean.csv")
