pacman::p_load(tidyverse, rvest)

imdb_solution = tibble() # initialization
for (i in seq(1, 1759, 50) ) {
  # making the url
  middle_url = i
  start_url = 'https://www.imdb.com/search/title/?title_type=feature&release_date=2019-01-01,2022-12-31&user_rating=1.0,10.0&certificates=US%3AG,US%3APG,US%3APG-13,US%3AR,US%3ANC-17&start='
  end_url = '&ref_=adv_nxt'
  
  complete_url = paste0(start_url, middle_url, end_url)
  
  step1_imdb = read_html(complete_url)
  
  step2_imdb_title = 
    html_elements(
      step1_imdb,
      "#main > div > div.lister.list.detail.sub-list > div > div > div.lister-item-content > h3 > a")
  step3_imdb_title = html_text2(step2_imdb_title)
  
  step3_imdb_urls = html_attr(x = step2_imdb_title, name = 'href')
  step4_imdb_urls = rvest::url_absolute(x = step3_imdb_urls,
                                        base = 'https://www.imdb.com/')
  
  step2_imdb_rating = 
    html_elements(
      step1_imdb,
      "#main > div > div.lister.list.detail.sub-list > div > div > div.lister-item-content > div > div.inline-block.ratings-imdb-rating > strong"
    )
  step3_imdb_rating = html_text2(step2_imdb_rating)
  
  step2_imdb_agerating = 
    html_elements(
      step1_imdb,
      "#main > div > div.lister.list.detail.sub-list > div > div > div.lister-item-content > p:nth-child(2) > span.certificate"
    )
  step3_imdb_agerating = html_text2(step2_imdb_agerating)
  
  step2_imdb_releaseyear = 
    html_elements(
      step1_imdb,
      "#main > div > div.lister.list.detail.sub-list > div > div > div.lister-item-content > h3 > span.lister-item-year.text-muted.unbold")
  step3_imdb_releaseyear = html_text2(step2_imdb_releaseyear)
  
  step2_imdb_movielength = 
    html_elements(
      step1_imdb,
      "#main > div > div.lister.list.detail.sub-list > div > div > div.lister-item-content > p:nth-child(2) > span.runtime")
  step3_imdb_movielength = html_text2(step2_imdb_movielength)
  
  
  temp_df = tibble(title = step3_imdb_title,
                   url = step4_imdb_urls,
                   rating = step3_imdb_rating,
                   agerating = step3_imdb_agerating,
                   releaseyear = step3_imdb_releaseyear)
  
  imdb_solution = rbind(imdb_solution, temp_df)
}

df <-imdb_solution %>%
  select(title, url, rating, agerating, releaseyear) %>%
  summarize(title, url, rating, agerating, releaseyear)
df

df$title = as.character(df$title)
df$url = as.character(df$url)
df$rating = as.numeric(df$rating)
df$agerating = as.character(df$agerating)

df

write.csv(df, "imdb_solution_finished.csv")

                 