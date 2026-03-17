import requests
from bs4 import BeautifulSoup
import re
import pandas as pd
from time import sleep
from urllib.parse import urljoin

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
}

# def get_article_links_and_next(url):
#     resp = requests.get(url, headers=HEADERS)
#     resp.raise_for_status()
#     soup = BeautifulSoup(resp.text, "html.parser")

#     links = []

#     # 1) Only inside the news list
#     list_div = soup.select_one("div.news-page__list")
#     if list_div:
#         for a in list_div.find_all("a", href=True):
#             href = a["href"]
#             title = a.get_text(strip=True)
#             if href.startswith("/news/") and title:
#                 full_link = urljoin("https://kun.uz", href)
#                 links.append(full_link)

#     # 2) Find the "load more" button
#     next_btn = soup.select_one("a.point-view__footer-btn")
#     if next_btn and next_btn.get("href"):
#         next_url = urljoin("https://kun.uz", next_btn["href"])
#     else:
#         next_url = None

#     return list(set(links)), next_url

def scrape_kun_uz(url):
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"}
    resp = requests.get(url, headers=headers)
    resp.raise_for_status()
    soup = BeautifulSoup(resp.text, "html.parser")

    # TITLE
    title = soup.select_one("h1.news-inner__content-title")
    title = title.get_text(strip=True) if title else "—"
    # print(f'Title {title}')

    # AUTHOR
    author = "—"
    auth = soup.select_one("div.news-inner__author")
    if auth:
        text = auth.get_text(strip=True)
        if "Tayyorlangan:" in text:
            author = text.split("Tayyorlangan:", 1)[1].strip()
        else:
            a = auth.find("a")
            author = a.get_text(strip=True) if a else text
    # print(f'author {author}')

    # CATEGORY + DATE
    meta_line = soup.select_one("div.news-date, span:contains(' | '), news-inner__content-stats")
    # print(meta_line)
    category_date = "—"
    if meta_line:
        text = meta_line.get_text(strip=True)
        # print(f'text {text}')
        match = re.search(r"([^\d|]+)\s*\|\s*(\d{2}\.\d{2}\.\d{4})", text)
        if match:
            category_date = f"{match.group(1).strip()} | {match.group(2)}"
        else:
            category_date = re.sub(r"\s*/\s*\d{2}:\d{2}.*", "", text).strip()

    category = category_date.split("|")[0].strip() if "|" in category_date else "—"
    date_only = category_date.split("|")[1].strip() if "|" in category_date else "—"
    # print(f'category {category}')
    # print(f'date_only {date_only}')

    # TAGS
    tags = []
    tags_div = soup.select_one("div.news-inner__tags")
    if tags_div:
        tags = [t.get_text(strip=True) for t in tags_div.select("a")]
    # print(f'tags {tags}')

    # BODY
    content = soup.select_one("div.news-inner__content-head")

    if content:
        paragraphs = [
            p.get_text(" ", strip=True)
            for p in content.find_all("p")
            if len(p.get_text(strip=True)) > 10
        ]
        body = " ".join(paragraphs)
    else:
        body = ""
    # print(f'Body {body}')

    return {
        "title": title,
        "author": author,
        "category": category,
        "date": date_only,
        "category_and_date": category_date,
        "tags": tags,
        "body": body,
        "url": url
    }



# all_links = set()
# url = "https://kun.uz/news/category/talim"
df = pd.read_csv(r'C:\\Users\\HP\\Desktop\\kunuz_news_links_limited.csv')
print(len(df))

df['urls'] = (
    df['urls']
    .astype(str)
    .str.strip()
    .str.replace('👉', '', regex=False)
    .str.strip()
)

all_links = df['urls'].tolist()
print(len(all_links))
all_links = set(all_links)
articles = []

for i, link in enumerate(all_links, start=1):
    try:
        article = scrape_kun_uz(link)
        articles.append(article)
        body_len = len(article.get("body", ""))
        # print(f"{i}/{len(all_links)} scraped → {body_len} chars")
        print(i)
    except Exception as e:
        print("Error scraping", link, "→", e)

# max_pages = 400
# pages_scraped = 0

# while url and pages_scraped < max_pages:
#     links, next_url = get_article_links_and_next(url)
#     all_links.update(links)
#     url = next_url
#     pages_scraped += 1
#     print("Total unique links:", len(all_links))


# articles = []

# total = len(all_links)
# count = 0

# for link in all_links:
#     try:
#         article = scrape_kun_uz(link)
#         articles.append(article)

#         count += 1
#         print(f"Scraped {count}/{total}")

#     except Exception as e:
#         print("Error scraping", link, "→", e)

df = pd.DataFrame(articles)
df.to_csv("kunuz.csv", index=False, encoding="utf-8-sig")
print("Saved", len(df), "articles to kunuz.csv")


