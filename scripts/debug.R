library(poirot, lib.loc="~/R/x86_64-unknown-linux-gnu-library/2.15/")
library(slidify, lib.loc="~/R/x86_64-unknown-linux-gnu-library/2.15/")





debug(blogify)

blogify()

p <- pagify('about.Rmd')

load("payload.RData")

# [1] "layout"   "partials" "payload" 


library(knitr)
?knit

render_pages

# copied from slidify(dev)::publish_rpubs
# karl
publish_in_dir <- function(dir, html_file = 'index.html'){
	
	#html <- slidify:::enable_cdn(slidify:::embed_images(html_file))
	html <- slidify:::embed_images(html_file)
	
	if (! file.exists(dir)) {
		message("creating dir ", dir)
		dir.create(dir)
	}
	
	html_out <- file.path(dir, basename(html_file))
	
	writeLines(html, html_out)

}

publish_in_dir("publish_test", "index.html")

setwd('posts')

publish_in_dir("publish_test", "package-depends-dirty-hack-solution.html")

undebug(markdown:::.b64EncodeImages)
