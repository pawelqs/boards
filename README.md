
<!-- README.md is generated from README.Rmd. Please edit that file -->

# boards <img src="man/figures/logo.png" align="right" height="120" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/pawelqs/boards/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/pawelqs/boards/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of boards is to manage local [pins](https://pins.rstudio.com/)
boards from many projects. [pins](https://pins.rstudio.com/) allows to
easily read, save and version data using *board* objects. When working
on many parallel projects, it can be useful to have an easy access to a
selection of objects from many boards. The *boards* package uses a
*central board* - all the project boards are a subdirectories of the
main, central directory, and the data *pinned* to these boards can be
easily searched and read.

[pins](https://pins.rstudio.com/) allows to specify many different types
of boards, including the Posit Cloud and AWS S2. **boards** package uses
a local folder boards.

## Installation

You can install the development version of boards from
[GitHub](https://github.com/) with:

``` r
devtools::install_github("pawelqs/boards")
```

## Usage

``` r
library(boards)
```

### Set the local boards directory

First, specify the directory in which all the boards should be placed.

``` r
boards_dir <- tempdir()
use_local_boards_directory(boards_dir)
```

### Add project data

Now it is time to create project boards and save the data. In this
example we simulate 2 projects. We want to save two data.frames from
Project A:

``` r
data1 <- data.frame(a = 1)
data2 <- data.frame(b = 1)

create_local_project("Project A")
write_pin("Project A", data1)
#> Using `name = 'data1'`
#> Guessing `type = 'rds'`
#> Creating new version '20231026T144835Z-8e47e'
#> Writing to pin 'data1'
write_pin("Project A", data2)
#> Using `name = 'data2'`
#> Guessing `type = 'rds'`
#> Creating new version '20231026T144835Z-fc5bb'
#> Writing to pin 'data2'
```

and 2 lists from project B.

``` r
l1 <- list(a = 1)
l2 <- list(a = 1)

create_local_project("Project B")
write_pin("Project B", l1)
#> Using `name = 'l1'`
#> Guessing `type = 'json'`
#> Creating new version '20231026T144835Z-6930c'
#> Writing to pin 'l1'
write_pin("Project B", l2)
#> Using `name = 'l2'`
#> Guessing `type = 'json'`
#> Creating new version '20231026T144835Z-6930c'
#> Writing to pin 'l2'
```

Project name is the first argument of the `write_pin()` function. All
other arguments (e.g. `versioned = TRUE`) are passed to
`pins::pin_write()` function.

### Search projects and pins

Now we can print all the projects created in **boards**:

``` r
show_local_projects()
#> • Project A
#> • Project B
```

or to just get them as a vector:

``` r
get_local_projects()
#> [1] "Project A" "Project B"
```

Knowing the neme of the project, we can list all the pins in this
project:

``` r
show_pins("Project A")
#> # A tibble: 2 × 7
#>   name  version            created             hash  title description file_size
#>   <chr> <chr>              <dttm>              <chr> <chr> <lgl>       <fs::byt>
#> 1 data1 20231026T144835Z-… 2023-10-26 16:48:35 8e47e data… NA                108
#> 2 data2 20231026T144835Z-… 2023-10-26 16:48:35 fc5bb data… NA                108
#> NULL
```

If no project name is specified, `show_pins()` and `get_pins()` will
return the pins from all the projects:

``` r
show_pins()
#> # A tibble: 4 × 8
#>   project   name  version  created             hash  title description file_size
#>   <chr>     <chr> <chr>    <dttm>              <chr> <chr> <lgl>       <fs::byt>
#> 1 Project A data1 2023102… 2023-10-26 16:48:35 8e47e data… NA                108
#> 2 Project A data2 2023102… 2023-10-26 16:48:35 fc5bb data… NA                108
#> 3 Project B l1    2023102… 2023-10-26 16:48:35 6930c l1: … NA                  8
#> 4 Project B l2    2023102… 2023-10-26 16:48:35 6930c l2: … NA                  8
#> NULL
```

### Read pins

Pins can be read using `read_pin()` function, which takes a project name
and a pin name. All other arguments (e.g. the requested version of the
pin) are passed to `pins::pin_read()` function.

``` r
read_pin("Project A", "data1")
#> Reading data1 from Project A project
#> Title:       data1: a pinned 1 x 1 data frame
#> Warning in stri_c(list("Description: ", character(0)), sep = sep, collapse =
#> collapse): argument is not an atomic vector; coercing
#> Description: character(0)
#> Created:     2023-10-26 16:48:35
#>   a
#> 1 1
```

For cenvenience, if no project name is provided, `read_pin()` shows the
list of existing projects, and when no pin name is provided, it shows
the list of pins in the project.

``` r
read_pin()
#> No project name provided. Found projects:
#> • Project A
#> • Project B
```

``` r
read_pin("Project A")
#> No pin name provided. Found pins:
#> # A tibble: 2 × 7
#>   name  version            created             hash  title description file_size
#>   <chr> <chr>              <dttm>              <chr> <chr> <lgl>       <fs::byt>
#> 1 data1 20231026T144835Z-… 2023-10-26 16:48:35 8e47e data… NA                108
#> 2 data2 20231026T144835Z-… 2023-10-26 16:48:35 fc5bb data… NA                108
#> NULL
```
