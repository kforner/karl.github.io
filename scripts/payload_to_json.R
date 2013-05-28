#! /usr/bin/env Rscript
library(rjson)
load("payload.RData")
cat(toJSON(payload))
