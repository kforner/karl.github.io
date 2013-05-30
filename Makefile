USER := 
REPO := 

RSCRIPT=Rscript-2.15.3


payload.RData: *.Rmd posts/*.Rmd
	$(RSCRIPT) --vanilla -e  'library(poirot, lib.loc="~/R/x86_64-unknown-linux-gnu-library/2.15/"); blogify()'
	
blogify: payload.RData

clean:
	rm -rf *.html *.md *.R *~ posts/*.html posts*/.md .cache posts/.cache payload.RData posts/payload.RData
	rm -f rss.json feed.xml
	cd rss && rm -f *.html *.md payload.RData
 
preview:
	python -m SimpleHTTPServer 8081

rss/payload.RData: posts/*.Rmd 
	scripts/build_rss.R
	
rss.json: rss/payload.RData
	scripts/payload_to_json.R $< >$@

feed.xml: rss.json
	cd rss &&  ../scripts/make_feed_from_rss_files.pl http://kforner.github.io  http://kforner.github.io/posts  http://kforner.github.io/libraries/frameworks/qb_minimal/css/main.css <../$< >../$@

all: blogify feed.xml


deploy:
	cd $(REPO) && \
	git init . && \
	git add . && \
	git commit -m 'update blog'; \
	git push git@github.com:$(USER)/$(REPO) master:gh-pages --force && \
	rm -rf .git && \
	cd ../..