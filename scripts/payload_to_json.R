#! /usr/bin/env Rscript
# convert the rdata file given as argument in JSON format, and output it in stdout
library(rjson)

args <- commandArgs(TRUE)
payload <- args[1]
if ( !nzchar(payload) ) {
	stop("must give the payload rda")
}

load(payload)

cat(toJSON(payload))
