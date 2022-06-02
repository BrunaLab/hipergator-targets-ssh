# To run as a background process in RStudio use the "Source" button and choose "Source as Local Job ..."
# Check progress with tar_visnetwork() or tar_progress().
# Increase number of workers as your QOS allows with the `workers` argument

targets::tar_make_clustermq(workers = 2L)
