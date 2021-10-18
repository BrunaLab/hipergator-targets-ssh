## Set to connect to Hipergator by ssh 

# You will be prompted to enter your
# gatorlink password and select an option for 2-factor authentication.  If you've
# set up an SSH key, then you need to use port 2222 for it to work, hence the '-p
# 2222 ' below.

options(
  clustermq.scheduler = "ssh",
  clustermq.template = "ssh_clustermq.tmpl", #custom SSH template to use R 4.0
  clustermq.ssh.host = "-p 2222 ericscott@hpg.rc.ufl.edu", # use your user and host. 
  clustermq.ssh.log = "~/cmq_ssh.log" # log for easier debugging
)

## Load your packages, e.g. library(targets).
source("./packages.R")
lapply(list.files("R", full.names = TRUE), source)

## Set options
options(tidyverse.quiet = TRUE)
tar_option_set(deployment = "main") #default to running targets locally

## tar_plan supports drake-style targets and also tar_target()
tar_plan(
  many_vects = make_vects(),
  means = map(many_vects, ~mean(.x)),
  sds = map(many_vects, ~sd(.x)),
  # these targets should be able to run in parallel on HiperGator:
  tar_target(means_mean, ~mean(unlist(means)), deployment = "worker"),
  tar_target(sd_means,  ~mean(unlist(sds)), deployment = "worker")
)
