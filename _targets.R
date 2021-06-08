## Set to connect to Hipergator by ssh


## Load your packages, e.g. library(targets).
source("./packages.R")
lapply(list.files("R", full.names = TRUE), source)

## Set options
options(tidyverse.quiet = TRUE)

## tar_plan supports drake-style targets and also tar_target()
tar_plan(
  many_vects = make_vects(),
  means = map(many_vects, ~mean(.x)),
  sds = map(many_vects, ~sd(.x)),
  # these targets should be able to run in parallel:
  means_mean = mean(unlist(means)),
  sd_means = mean(unlist(sds))
)