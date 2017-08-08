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

	num_pages = int(int(num_articles)/10)

	with open("get_articles_nyt.tsv", "a") as f:
				f.write("section_name\tweb_url\tpub_date\tsnippet\n")

	for page in range(num_pages):
		params = {
			'api-key': api_key,
			'fq': "section_name: %s OR section_name: %s" % (section_name1, section_name2), 
			'sort': "newest",
			'page': page
		}


		# object r stores the server's response
		r = requests.get(ARTICLE_SEARCH_URL, params)

		# r.text returns "str" objects; r.content returns "bytes" objects. 
		# json.loads() can only accept 'str' object as argument
		# json.load() can only accept objects that it can read from, e.g. a file object that has been `opened`

		data = json.loads(r.text)

		for doc in data['response']['docs']:
			oneline_snippet = str(doc['snippet']).replace("\n", " ")
			section = str(doc['section_name'])
			url = str(doc['web_url'])
			pdate = doc['pub_date']
			with open("get_articles_nyt.tsv", "a") as f:
		 		f.write(section + "\t" +
		 				url 	+ "\t" +
		 				pdate   + "\t" +
		 				oneline_snippet +
		 				"\n")

			'''if not isinstance(oneline_snippet, str):
				print(oneline_snippet)
				print(page)'''
		time.sleep(2)