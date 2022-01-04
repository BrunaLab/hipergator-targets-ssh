#For debugging at the level of `clustermq` (i.e. ruling out `targets`)
library(clustermq)
options(
  clustermq.scheduler = "ssh",
  clustermq.template = "ssh_clustermq.tmpl", #custom SSH template to use R 4.0
  clustermq.ssh.host = "-p 2222 ericscott@hpg.rc.ufl.edu",
  clustermq.ssh.log = "~/cmq_ssh.log" # log for easier debugging
)
# Uncomment to test if it works locally:
# options(
#   clustermq.scheduler = "multiprocess"
# )
fx = function(x) x * 2
Q(fx, x=1:3, n_jobs=1)
