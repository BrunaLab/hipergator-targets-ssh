suppressPackageStartupMessages({
  ## library() calls go here
  library(conflicted)
  library(dotenv)
  library(targets)
  library(tarchetypes)
  library(purrr)
  library(clustermq)
  library(visNetwork) #only needs to be installed locally for tar_visnetwork()
  library(rmarkdown) #only needed for rendering .Rmd files
})

