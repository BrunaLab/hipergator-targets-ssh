
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hipergator-targets-ssh

<!-- badges: start -->
<!-- badges: end -->

This is a minimal example of a
[`targets`](https://docs.ropensci.org/targets/) workflow that can run on
[HiperGator](https://www.rc.ufl.edu/services/hipergator/) HPC using the
[`clustermq`](https://mschubert.github.io/clustermq/) back-end for
paralellization. This is intended to be run **locally** in RStudio. For
an alternative workflow that is run *on HiperGator* via the command
line, see [this repo](https://github.com/BrunaLab/hipergator-targets).

## Prerequisites:

-   Some familiarity with HiperGator
-   Ability to SSH into HiperGator without a password. Set this up with
    `ssh-keygen` and by creating a SSH config file locally (see details
    here: <https://help.rc.ufl.edu/doc/Authentication_With_MFA>)

## To Use:

1.  Click the green “Use this template” button to make a copy into your
    own GitHub account or use the “Code” button to download a zip file
    of this repo.

2.  This project uses
    [`renv`](https://rstudio.github.io/renv/articles/renv.html) to
    manage R package dependencies. After opening the .Rproj file in
    RStudio, run `renv::restore()` to install all needed packages.

3.  SSH into HiperGator. Launch R and install the `clustermq` package.

4.  On HiperGator, edit your `~/.Rprofile` (e.g. with
    `nano ~/.Rprofile`) to include:

    ``` r
    options(
      clustermq.scheduler = "slurm",
      clustermq.template = "~/slurm_clustermq.tmpl"
    )
    ```

5.  Edit the `slurm_clustermq.tmpl` file if needed (but don’t touch the
    wildcards in double curly braces) and then copy it to HiperGator
    with
    `scp slurm_clustermq.tmpl username@hpg.rc.ufl.edu:slurm_clustermq.tmpl`.
    [More detailed instructions on setting up
    `clustermq`](https://mschubert.github.io/clustermq/articles/userguide.html)

    **NOTE:** While you’re logged into HiperGator, you should also
    install any R packages your project uses. Launch R and install them
    manually (sorry, I don’t know an easy way to use the local `renv`
    lock file to automatically install packages on HiperGator).

6.  Run `targets` workflow:

    To run this example workflow, you can either run
    `targets::tar_make_clustermq()` in the console, or use the “Jobs”
    feature of RStudio to run the `run.R` script as a local job—this
    keeps the console from being tied up waiting for the jobs to run on
    the cluster. You can watch the progress of the pipeline with
    `tar_watch()` or by running `tar_visnetwork()` to see a graph like
    this:

``` mermaid
graph LR
  subgraph Legend
    x7420bd9270f8d27d([""Up to date""]):::uptodate --- x5b3426b4c7fa7dbc([""Started""]):::started
    x5b3426b4c7fa7dbc([""Started""]):::started --- xbf4603d6c2c2ad6b([""Stem""]):::none
    xbf4603d6c2c2ad6b([""Stem""]):::none --- xf0bce276fe2b9d3e>""Function""]:::none
  end
  subgraph Graph
    x89d7607898dce999>"make_vects"]:::uptodate --> xc7a97a0c3f5c7239(["many_vects"]):::uptodate
    xc7a97a0c3f5c7239(["many_vects"]):::uptodate --> x7093befdb6050f4e(["means"]):::uptodate
    xc7a97a0c3f5c7239(["many_vects"]):::uptodate --> x5746aa97a820c5ac(["sds"]):::uptodate
    x5746aa97a820c5ac(["sds"]):::uptodate --> xc75015002057228e(["sd_means"]):::uptodate
    x7093befdb6050f4e(["means"]):::uptodate --> xe00cc1033f4aed9a(["means_mean"]):::uptodate
    x6e52cb0f1668cc22(["readme"]):::started --> x6e52cb0f1668cc22(["readme"]):::started
  end
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef started stroke:#000000,color:#000000,fill:#DC863B;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
  linkStyle 1 stroke-width:0px;
  linkStyle 2 stroke-width:0px;
  linkStyle 8 stroke-width:0px;
```

## Notes

If you only want certain targets to run on Hipergator, you can control
this with the `deploy` argument to `tar_options_set()` and
`tar_target()`. Targets with `deploy = "main"` will run locally and
targets with `deploy = "worker"` will run on HiperGator. Set the default
behavior with `tar_options_set()` inside of `_targets.R` and then adjust
individual targets as needed. See `_targets.R` for an example and see
the [`targets`
manual](https://books.ropensci.org/targets/hpc.html#advanced) for more
detail. Note that you will still have to wait for remote targets to
finish running for the pipeline to finish, so if any targets take a very
long time to run, [this alternative
approach](https://github.com/BrunaLab/hipergator-targets) might be
better.

Currently (as of May 2022) there is a bug with R version 4.1+ on
HiperGator that affects this workflow. To get around this, I’ve edited
the `ssh_clustermq.tmpl` and `slurm_clustermq.tmpl` files to load R
version 4.0.

## Troubleshooting:

Problems with HiperGator:

-   <https://help.rc.ufl.edu/doc/UFRC_Help_and_Documentation>

Problems with `clustermq`:

-   <https://mschubert.github.io/clustermq/articles/userguide.html#ssh>

Problems with `targets` (i.e. problem still exists with `tar_make()`
instead of `tar_make_clustermq()`:

-   <https://docs.ropensci.org/targets/index.html#help>

## How it works:

Using `tar_make_clustermq()` sends necessary data to HiperGator via SSH
and spawns worker jobs using the `slurm_clustermq.tmpl` file as a
template for the SLURM submission scripts for each worker.

The parallelization happens at the level of targets. In this example, a
list of numeric vectors is stored as `many_vects`. Then, independently,
means and standard deviations are calculated for each vector in the
list. These two targets (the means and the sd’s) should be able to run
on separate workers in parallel if things are set up correctly.
Parallelizing code *within* a target (e.g. a function that does parallel
computation) will require more setup.
