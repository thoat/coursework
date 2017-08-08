#
# file: get_articles.py
#
# description: fetches article urls from the NYTimes API
#
# usage: get_articles.py <api_key>
#
# requirements: a NYTimes API key
#   available at https://developer.nytimes.com
#

import requests
import json
import sys
import time
import logging
import codecs

logging.basicConfig(level=logging.INFO,
                    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s")
logger=logging.getLogger('get_articles')

ARTICLE_SEARCH_URL = 'https://api.nytimes.com/svc/search/v2/articlesearch.json'

if __name__=='__main__':
   if len(sys.argv) != 4:
      sys.stderr.write('usage: %s <api_key> <section> <max_articles>\n' % sys.argv[0])
      sys.exit(1)

   api_key = sys.argv[1]
   section = sys.argv[2]
   max_articles = int(sys.argv[3])

   # output output file
   filename='%s.tsv' % section.lower()
   fid = codecs.open(filename, 'w', 'utf-8')
   fid.write("section\turl\tdate\tsnippet\n")

   page = 0
   num_articles = 0
   while num_articles < max_articles:

      params = {'api-key': api_key,
                'sort': 'newest',
                'fq': 'section_name:%s AND source:("The New York Times")' % section,
                'page': page}

      logger.info("page %d of %s section (%d of %d articles)" % (page, section, num_articles, max_articles))

      r = requests.get(ARTICLE_SEARCH_URL, params)
      try:
         data = json.loads(r.content)
      except ValueError:
         print r.content
         continue
      
      for doc in data['response']['docs']:
         url = doc['web_url'] if doc['web_url'] else ''
         date = doc['pub_date'] if doc['pub_date'] else ''
         snippet = doc['snippet'] if doc['snippet'] else ''

         fid.write("\t".join( (section, url, date, snippet) ) + "\n")

         num_articles += 1

      page += 1
      time.sleep(3)


   fid.close()
