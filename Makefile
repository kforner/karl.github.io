USER := 
REPO := 

RSCRIPT=Rscript-2.15.3



blogify:
	$(RSCRIPT) --vanilla -e  'library(poirot, lib.loc="~/R/x86_64-unknown-linux-gnu-library/2.15/"); blogify()'


clean:
	rm -rf *.html *.md *.R *~ posts/*.html posts*/.md .cache posts/.cache payload.RData posts/payload.RData
 
preview:
	python -m SimpleHTTPServer 8081

deploy:
	cd $(REPO) && \
	git init . && \
	git add . && \
	git commit -m 'update blog'; \
	git push git@github.com:$(USER)/$(REPO) master:gh-pages --force && \
	rm -rf .git && \
	cd ../..