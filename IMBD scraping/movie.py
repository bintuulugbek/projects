# movie
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
import time
import requests
from bs4 import BeautifulSoup
import pandas as pd
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36",
    "Accept-Language": "en-US,en;q=0.9"
}

driver = webdriver.Chrome()
driver.get("https://www.imdb.com/chart/top/")
time.sleep(2) 

movie_links = driver.find_elements(By.CSS_SELECTOR, "ul.ipc-metadata-list a.ipc-title-link-wrapper")
movie_urls = [elem.get_attribute("href") for elem in movie_links]

driver.quit()

movie_titles = []
release_years = []
ratings = []
number_of_votes = []
genres = []
directors = []
stars = []

for link in movie_urls:
    response = requests.get(link, headers=headers)
    soup = BeautifulSoup(response.text, 'html.parser')
    title_div = soup.find('div', class_='sc-42c2285c-3 fEamwA')

    title = title_div.find('span', class_='hero__primary-text').text.strip()
    movie_titles.append(title)

    year = title_div.find('li', class_='ipc-inline-list__item').text.strip()
    release_years.append(year)

    rating = title_div.find('span', class_='sc-d541859f-1 imUuxf').text.strip()
    ratings.append(rating)

    number_of_vote = title_div.find('div', class_='sc-d541859f-3 dwhNqC').text.strip()
    number_of_votes.append(number_of_vote)

    genre_div = soup.find('div', class_='ipc-chip-list__scroller') 
    genres_div = genre_div.find_all('a', class_='ipc-chip ipc-chip--on-baseAlt')
    genre = []
    for g in genres_div:
        genre.append(g.text.strip())
    genres.append(genre)

    directors_div = soup.find('ul', class_='ipc-metadata-list ipc-metadata-list--dividers-all title-pc-list ipc-metadata-list--baseAlt')
    director_div = directors_div.find_all('div', class_='ipc-metadata-list-item__content-container')
    dr = []
    st = []
    for i, d in enumerate(directors_div.find_all('div', class_='ipc-metadata-list-item__content-container')):
        if i == 0:
            dr.append(', '.join(d.stripped_strings))
        elif i == 2:
            st.append(', '.join(d.stripped_strings))
        else: 
            pass

    directors.append(dr)
    stars.append(st)
    print(title)
 
movie_info = {
    'title': movie_titles,
    'release year': release_years,
    'rating': ratings,
    'number of vote': number_of_votes,
    'genres': genres,
    'directors': directors,
    'stars': stars
}

df = pd.DataFrame(movie_info)
df.to_csv("top_movies.csv", index=False)

print("Successfully finished, Bahor😍")
