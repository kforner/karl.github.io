#! /usr/bin/env Rscript
# this script generates the RSS html files from the posts/*.Rmd files
POSTS <- 'posts'
RSS <- 'rss'
IMG_BASE_URL <- 'http://kforner.github.io/posts'
CDN  <-  'http://kforner.github.io/libraries/'

library(poirot, lib.loc="~/R/x86_64-unknown-linux-gnu-library/2.15/")

# modify <IMG> urls using a custom function
modifyImgUrls <- function (html, fun) {
	reg <- "(<\\s*img\\s+src\\s*=\\s*[\"'])([^\"']+)([\"'])"
	url_regexp <- "([^\"']+)[\"']"
	m <- gregexpr(reg, html, perl=TRUE, ignore.case=TRUE)
	if (m[[1]][1] != -1) {
		.fixUrl <- function(img_src) {
			url <- sub(reg, "\\2", img_src)
			new_url <- fun(url)
			sub(reg, paste0("\\1", new_url, "\\3"), img_src)
		}
		regmatches(html, m) <- list(unlist(lapply(regmatches(html, 
										m)[[1]], .fixUrl)))
	}
	html
}

old_dir <- setwd(RSS)
on.exit( setwd(old_dir))

# first create symlinks of the posts src inside rss dir
rmd_files = dir(file.path("..", POSTS), recursive = FALSE, pattern = '*.Rmd', full.names=TRUE)
# cleanup previous links
file.remove(dir('.', pattern = '*.Rmd', full.names=TRUE))
file.symlink(rmd_files, '.')

# build the html files
blogify('.')
file.remove(dir('.', pattern = '*.Rmd', full.names=TRUE))

# post-process the html files
html_files <- dir(".", recursive = TRUE, pattern = '*.html')
for (f in html_files) {
	message("processing file ", f)
	html <- paste(readLines(f, warn=FALSE), collapse = "\n")
	.absolutizeUrl <- function(url) paste0(IMG_BASE_URL, "/", url)
	html <- modifyImgUrls(html, .absolutizeUrl)
	
	# fix links to library css
	
	html  <- gsub("/../libraries/", CDN, html, fixed=TRUE)
	
	writeLines(html, f)
}
