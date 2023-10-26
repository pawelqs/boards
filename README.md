
<!-- README.md is generated from README.Rmd. Please edit that file -->

# boards <img src="man/figures/logo.png" align="right" height="120" />

<!-- badges: start -->
<!-- badges: end -->

The goal of boards is to manage data from many projects. boards uses
pins package.

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

``` r
boards_dir <- tempdir()
set_local_boards_directory(boards_dir)
```

### Add project data

``` r
show_local_projects()
#> •
```
