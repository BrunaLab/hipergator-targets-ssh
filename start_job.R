# Source this as a local job to get the targets pipeline running the background.
# Check progress with tar_visnetwork() or tar_progress().
library(targets)
targets::tar_make_clustermq(workers = 2L)