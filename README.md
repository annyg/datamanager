
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datamanager

<!-- badges: start -->

[![R-CMD-check](https://github.com/annyg/datamanager/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/annyg/datamanager/actions/workflows/R-CMD-check.yaml)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.14825940%20.svg)](https://doi.org/10.5281/zenodo.14825940)
[![codecov](https://codecov.io/gh/annyg/datamanager/branch/main/graph/badge.svg)](https://codecov.io/gh/annyg/datamanager)
![License:GPL-3.0](https://img.shields.io/badge/license-GPL--3.0-green.svg)

<!-- badges: end -->

`datamanager` is an R package designed for the efficient management and
scoring of research data, particularly focusing on questionnaire and
survey data. It provides a suite of functions to handle common tasks in
data preparation and scoring, including support for instruments such as
RAND-12 and EMQ.

## Features

- **Data Management**: Effortlessly clean and organize questionnaire
  data.
- **Scoring Functions**: Compute scores for recognized instruments
  including RAND-12 and EMQ.
- **Efficient Workflow**: Streamline your data processing tasks in
  research settings.

## Installation

You can install the latest version of `datamanager` directly from GitHub
using:

``` r
if (!require("pak")) install.packages("pak")
pak::pak("annyg/datamanager")
library(datamanager)
```

### Offline install from a source tarball

For users on a remote server without internet access to GitHub (but with
CRAN dependencies already available), `datamanager` can be installed
from a source tarball (`.tar.gz`) transferred to the machine.

1.  On a machine with internet access, download the source tarball from
    the [GitHub releases](https://github.com/annyg/datamanager/releases)
    page (file named `datamanager_<version>.tar.gz`), or build one from
    a clone of the repository:

    ``` r
    # From the package root
    devtools::build()           # writes ../datamanager_<version>.tar.gz
    ```

2.  Transfer the `.tar.gz` file to the server (e.g. via SFTP or a shared
    drive).

3.  On the server, install from the local file. Use
    `remotes::install_local()` so that CRAN dependencies listed in
    `DESCRIPTION` are pulled from the server’s configured CRAN mirror:

    ``` r
    # install.packages("remotes")  # if not already available
    remotes::install_local("/path/to/datamanager_<version>.tar.gz")
    library(datamanager)
    ```

    Plain `install.packages(file, repos = NULL, type = "source")` also
    works, but it will not resolve missing CRAN dependencies — install
    those first if you take that route.

## Usage

The `datamanager` package is designed to handle data frames and
primarily builds on tidyverse syntax. Below are examples demonstrating
how to use the main functions in `datamanager`.

### Data Management

``` r
# library(datamanager)

# Example function call for cleaning common typos often found in email adresses
# cleaned_df <- df %>%
#   mutate(clean_emails = datamanager::prep_email(messy_emails))
```

### Scoring Instruments

#### RAND-12 Scoring

``` r
# Example for scoring RAND-12
# rand12_scores <- score_rand12(cleaned_data)
```

#### EMQ Scoring

``` r
# Example for scoring EMQ
# emq_scores <- score_emq(cleaned_data)
```

For detailed documentation on these functions and more, please refer to
the package help files or vignette.

## Citation

If you use `datamanager` in your research, please cite it as follows:

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.14825940%20.svg)](https://doi.org/10.5281/zenodo.14825940)

Example BibTeX entry:

``` bibtex
@software{Anders B. Nygaard_2023_XXXXXXX,
  author       = {Anders B. Nygaard},
  title        = {datamanager: Tools for Questionnaire and Survey Data Management},
  year         = {2025},
  publisher    = {GitHub},
  journal      = {GitHub repository},
  version      = {v1.0.0},
  doi          = {10.5281/zenodo.14825940},
  url          = {https://github.com/annyg/datamanager}
}
```

## Lifecycle

This package is currently an experimental, as defined by the [RECON
software lifecycle](https://www.reconverse.org/lifecycle.html). This
means that it is functional, but interfaces and functionalities may
change over time, testing and documentation may be lacking.

## Contributing

We welcome contributions! If you’d like to contribute to `datamanager`,
please fork the repository, create a branch, and submit a pull request.

## License

`datamanager` is licensed under the GNU General Public License v3.0. See
the `LICENSE` file for more information.

------------------------------------------------------------------------

We hope you find `datamanager` useful in your research projects. For any
questions, issues, or suggestions, please open an issue on GitHub or
contact us.
