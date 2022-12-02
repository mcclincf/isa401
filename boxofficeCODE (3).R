pacman::p_load(tidyverse, rvest)

boxoffice_urls = c('https://www.the-numbers.com/market/2019/top-grossing-movies',
              'https://www.the-numbers.com/market/2020/top-grossing-movies',
              'https://www.the-numbers.com/market/2021/top-grossing-movies',
              'https://www.the-numbers.com/market/2022/top-grossing-movies')

boxoffice = tibble() # initialization
for (i in 1:length(boxoffice_urls) ) {
  # making the url
  
  complete_url = boxoffice_urls[i]
  
  step1_bo = read_html(complete_url)
  
  step2_bo_movie = html_elements(step1_bo, "td > b > a")
  step3_bo_movie = html_text2(step2_bo_movie)
  
  step2_bo_genre = html_elements(step1_bo, "tr > td:nth-child(5)")
  step3_bo_genre = html_text2(step2_bo_genre)
  
  step2_bo_gross = html_elements(step1_bo, "tr > td:nth-child(6)")
  step3_bo_gross = html_text2(step2_bo_gross)
  
  step2_bo_sold = html_elements(step1_bo, "tr > td:nth-child(7)")
  step3_bo_sold = html_text2(step2_bo_sold)
  
  temp_df = tibble(movie = step3_bo_movie,
                   genre = step3_bo_genre,
                   gross = step3_bo_gross,
                   'tickets sold' = step3_bo_sold)
  
  boxoffice = rbind(boxoffice, temp_df)
}

df <-boxoffice %>%
  select(movie, genre, gross, 'tickets sold') %>%
  summarize(movie, genre, gross, 'tickets sold')
df

write.csv(df, "boxoffice")
                 