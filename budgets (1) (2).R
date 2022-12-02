pacman::p_load(tidyverse, rvest)

budgets = tibble() # initialization
for (i in seq(1, 6001, 100) ) {
  # making the url
  start_url = 'https://www.the-numbers.com/movie/budgets/all/'
  end_url = i
  
  complete_url = paste0(start_url, end_url)
  
  step1_bu = read_html(complete_url)
  
  step2_bu_releasedate = html_elements(step1_bu, "tr > td:nth-child(2) > a")
  step3_bu_releasedate = html_text2(step2_bu_releasedate)
  
  step2_bu_title = html_elements(step1_bu, "tr > td:nth-child(3) > b > a")
  step3_bu_title = html_text2(step2_bu_title)
  
  step2_bu_budget = html_elements(step1_bu, "tr > td:nth-child(4)")
  step3_bu_budget = html_text2(step2_bu_budget)
  
  temp_df = tibble(releaseDate = step3_bu_releasedate,
                   title = step3_bu_title,
                   budget = step3_bu_budget)
  
  budgets = rbind(budgets, temp_df)
}

df <-budgets %>%
  select(releaseDate, title, budget) %>%
  summarize(releaseDate, title, budget)
df

df$title = as.character(df$title)
df$releaseDate = lubridate::mdy(df$releaseDate)
df$budget = str_remove_all(df$budget, ',') %>% str_extract(pattern = "[:digit:]{1,}") %>% as.numeric()

df

write.csv(df, "budgets1.csv")

install.packages("DataExplorer")

library(DataExplorer)
create_report(df)

