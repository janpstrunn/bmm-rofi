import sys
import requests
from bs4 import BeautifulSoup

def fetch_title(url):
    try:
        response = requests.get(url)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')

        title = soup.title.string if soup.title else "No title found"

        return title
    except requests.RequestException as e:
        return f"An error occurred: {e}", None

def main():
    url = sys.stdin.readline().strip()
    if not url:
        print("No URL provided")
        return

    title = fetch_title(url)
    print(title)

if __name__ == "__main__":
    main()
