# hipergator-targets-ssh

<!-- badges: start -->

<!-- badges: end -->

This is a minimal example of a [`targets`](https://docs.ropensci.org/targets/) workflow that can run on [HiperGator](https://www.rc.ufl.edu/services/hipergator/) HPC using the [`clustermq`](https://mschubert.github.io/clustermq/) backend for paralellization. This is intended to be run **locally** in RStudio. For an alternative workflow that is run *on Hipergator* via the commandline, see [this repo](https://github.com/BrunaLab/hipergator-targets).

## Setup
0. All of this works best if you can SSH into Hipergator without a password.  Set this up with `ssh-keygen`.
1. SSH into Hipergator.  Launch R and install the `clustermq` package.
1. On Hipergator, edit your `~/.Rprofile` (e.g. with `nano ~/.Rprofile`) to include:

```r
options(
  clustermq.scheduler = "slurm",
  cluster.template = "~/slurm_clustermq.tmpl"
)
```
2. Edit the `slurm_clustermq.tmpl` file to include your email address (if you want email notifications for every worker task) and then copy it to Hipergator with `scp slurm_clustermq.tmpl username@hpg.rc.ufl.edu:slurm_clustermq.tmpl`

## Run `targets` workflow
To run this example workflow, you can either run `targets::tar_make_clustermq()` in the console, or use the "Jobs" feature of RStudio to run the `start_job.R` script as a local job---this keeps the console from being tied up waiting for the jobs to run on the cluster.

# Troubleshooting:

- https://mschubert.github.io/clustermq/articles/userguide.html#ssh


## How it works:

Using `tar_make_clustermq()` sends necessary data to HiperGator via SSH and spawns worker jobs using the `slurm_clustermq.tmpl` file as a template for the SLURM submission scripts for each worker.

The parallelization happens at the level of targets.
In this example, a list of numeric vectors is stored as `many_vects`.
Then, independently, means and standard deviations are calculated for each vector in the list.
These two targets (the means and the sd's) should be able to run on separate workers in parallel if things are set up correctly.
Parallelizing code *within* a target (e.g. a function that does parallel computation) will require more setup.

See [documentation for the `targets` package](https://books.ropensci.org/targets/) for more information.
