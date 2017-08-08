#
# file: get_articles_nyt.py
#
# description: fetches article urls from the NYTimes API
#
# usage: get_articles_nyt.py <api_key> <num_articles> <section_name1> <section_name2>
#
# requirements: a NYTimes API key
#   available at https://developer.nytimes.com/signup
#

import requests
import json
import sys
import time

ARTICLE_SEARCH_URL = 'https://api.nytimes.com/svc/search/v2/articlesearch.json'

'''
Your code should take an API key, 
						section name, 
						and number of articles as command line arguments, 
	and write out a tab-delimited file where each article is in a separate row, 
					with section_name, 
						web_url, 
						pub_date, 
					and snippet as columns 
	(hint: use the codecs package to deal with unicode issues if you run into them)
You'll have to loop over pages of API results until you have enough articles, and you'll want to remove any newlines from article snippets to keep each article on one line
Finally, run your code to get articles from the Business and World sections of the NYT.
'''

if __name__=='__main__':
	# sys.argv refers to the command arguments you'll type in Bash
	if len(sys.argv) != 5:
		sys.stderr.write('usage: %s <api_key> <num_articles> <section_name1> <section_name2> \n' % sys.argv[0])
		sys.exit(1)

	api_key = sys.argv[1]
	num_articles = sys.argv[2]
	section_name1 = sys.argv[3]
	section_name2 = sys.argv[4]

	num_pages = int((int(num_articles))/10)

	for page in range(num_pages):
		params = {
			'api-key': api_key,
			'fq': "section_name: %s" % section_name,
			'sort': "newest",
			'page': page
		}

		r = requests.get(ARTICLE_SEARCH_URL, params)
		data = r.json()

		for doc in data['response']['docs']:
			oneline_snippet = doc['snippet'].replace("\n", " ")
			print(doc['section_name'] + "\t" + doc['web_url'] + "\t" + doc['pub_date'] + "\t" + oneline_snippet)
			with open("get_articles_nyt.tsv", "a") as f:
				f.write(doc['section_name'] + "\t" + doc['web_url'] + "\t" + doc['pub_date'] + "\t" + oneline_snippet)
		time.sleep(2)
