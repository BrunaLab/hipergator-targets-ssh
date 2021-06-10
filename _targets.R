## Set to connect to Hipergator by ssh
options(
  clustermq.scheduler = "ssh",
  clustermq.ssh.host = "ericscott@hpg.rc.ufl.edu", # use your user and host
  clustermq.ssh.log = "~/cmq_ssh.log" # log for easier debugging
)

## Load your packages, e.g. library(targets).
source("./packages.R")
lapply(list.files("R", full.names = TRUE), source)

## Set options
options(tidyverse.quiet = TRUE)
tar_option_set(deployment = "worker") #default to running targets on Hipergator

## tar_plan supports drake-style targets and also tar_target()
tar_plan(
  # This first target will run locally because of deploy = "main"
  tar_target(many_vects, make_vects(), deploy = "main"),
  # The rest run on Hipergator
  means = map(many_vects, ~mean(.x)),
  sds = map(many_vects, ~sd(.x)),
  # these targets should be able to run in parallel:
  means_mean = mean(unlist(means)),
  sd_means = mean(unlist(sds))
)
