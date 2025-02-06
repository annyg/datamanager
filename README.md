
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datamanager

<!-- badges: start -->

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.xxxxxxx.svg)](https://doi.org/10.5281/zenodo.xxxxxxx)
[![codecov](https://codecov.io/gh/annyg/datamanager/branch/main/graph/badge.svg)](https://codecov.io/gh/annyg/datamanager)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

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
#> Loading required package: pak
pak::pak("annyg/datamanager")
#> ℹ Loading metadata database
#> ✔ Loading metadata database ... done
#>  
#> → Will install 90 packages.
#> → Will update 1 package.
#> → Will download 85 CRAN packages (78.42 MB), cached: 5 (20.10 MB).
#> → Will download 1 package with unknown size.
#> + askpass                   1.2.1   [dl] (74.69 kB)
#> + base64enc                 0.1-3   [dl] (33.12 kB)
#> + bit                       4.5.0.1 [dl] (1.18 MB)
#> + bit64                     4.6.0-1 [dl] (512.02 kB)
#> + bslib                     0.9.0   [dl] (5.92 MB)
#> + cachem                    1.1.0   [dl] (73.84 kB)
#> + callr                     3.7.6   [dl] (473.92 kB)
#> + cellranger                1.1.0   [dl] (106.58 kB)
#> + cli                       3.6.3   [dl] (1.36 MB)
#> + clipr                     0.8.0   [dl] (55.53 kB)
#> + codebookr                 0.1.8   [dl] (90.92 kB)
#> + crayon                    1.5.3   [dl] (165.17 kB)
#> + crosstalk                 1.2.1   [dl] (416.29 kB)
#> + curl                      6.2.0   [dl] (3.50 MB)
#> + data.table                1.16.4  [dl] (2.67 MB)
#> + datamanager       0.1.0 → 0.1.0   [bld][cmp][dl] (GitHub: 16865be)
#> + digest                    0.6.37  [dl] (223.14 kB)
#> + dplyr                     1.1.4   [dl] (1.58 MB)
#> + DT                        0.33    [dl] (2.03 MB)
#> + evaluate                  1.0.3   [dl] (104.13 kB)
#> + fansi                     1.0.6   [dl] (322.97 kB)
#> + fastmap                   1.2.0   [dl] (135.36 kB)
#> + flextable                 0.9.7   [dl] (2.35 MB)
#> + fontawesome               0.5.3   [dl] (1.39 MB)
#> + fontBitstreamVera         0.1.1   [dl] (697.82 kB)
#> + fontLiberation            0.1.0   [dl] (4.53 MB)
#> + fontquiver                0.2.1   [dl] (2.28 MB)
#> + forcats                   1.0.0   [dl] (428.20 kB)
#> + fs                        1.6.5   [dl] (413.43 kB)
#> + gdtools                   0.4.1   [dl] (2.21 MB)
#> + generics                  0.1.3   [dl] (83.69 kB)
#> + glue                      1.8.0   [dl] (183.78 kB)
#> + haven                     2.5.4   [dl] (768.44 kB)
#> + highr                     0.11    [dl] (44.22 kB)
#> + hms                       1.1.3   [dl] (105.34 kB)
#> + htmltools                 0.5.8.1 [dl] (363.20 kB)
#> + htmlwidgets               1.6.4   [dl] (813.36 kB)
#> + httpuv                    1.6.15  [dl] (1.00 MB)
#> + jquerylib                 0.1.4   [dl] (526.06 kB)
#> + jsonlite                  1.8.9   [dl] (1.11 MB)
#> + knitr                     1.49    [dl] (1.18 MB)
#> + labelled                  2.14.0  [dl] (358.56 kB)
#> + later                     1.4.1   [dl] (468.16 kB)
#> + lazyeval                  0.2.2   [dl] (162.85 kB)
#> + lifecycle                 1.0.4   [dl] (140.93 kB)
#> + magrittr                  2.0.3   [dl] (229.42 kB)
#> + memoise                   2.0.1   [dl] (51.10 kB)
#> + mime                      0.12    [dl] (40.92 kB)
#> + officer                   0.6.7   [dl] (1.83 MB)
#> + openssl                   2.3.2   
#> + pillar                    1.10.1  [dl] (671.54 kB)
#> + pkgconfig                 2.0.3   [dl] (22.81 kB)
#> + processx                  3.8.5   [dl] (689.25 kB)
#> + promises                  1.3.2   [dl] (2.02 MB)
#> + ps                        1.8.1   [dl] (642.64 kB)
#> + purrr                     1.0.4   
#> + R.methodsS3               1.8.2   [dl] (84.80 kB)
#> + R.oo                      1.27.0  
#> + R.utils                   2.12.3  [dl] (1.44 MB)
#> + R6                        2.5.1   [dl] (84.98 kB)
#> + ragg                      1.3.3   [dl] (1.97 MB)
#> + rappdirs                  0.3.3   [dl] (52.59 kB)
#> + Rcpp                      1.0.14  [dl] (2.90 MB)
#> + readr                     2.1.5   [dl] (1.19 MB)
#> + readxl                    1.4.3   [dl] (1.20 MB)
#> + rematch                   2.0.0   [dl] (19.27 kB)
#> + rio                       1.2.3   [dl] (623.48 kB)
#> + rlang                     1.1.5   [dl] (1.63 MB)
#> + rmarkdown                 2.29    [dl] (2.70 MB)
#> + sass                      0.4.9   [dl] (2.61 MB)
#> + stringi                   1.8.4   
#> + stringr                   1.5.1   [dl] (323.42 kB)
#> + sys                       3.4.3   [dl] (47.84 kB)
#> + systemfonts               1.2.1   [dl] (1.60 MB)
#> + textshaping               1.0.0   [dl] (1.47 MB)
#> + tibble                    3.2.1   [dl] (695.05 kB)
#> + tidyr                     1.3.1   [dl] (1.27 MB)
#> + tidyselect                1.2.1   [dl] (228.15 kB)
#> + tinytex                   0.54    [dl] (146.10 kB)
#> + tzdb                      0.4.0   [dl] (1.02 MB)
#> + utf8                      1.2.4   [dl] (150.80 kB)
#> + uuid                      1.2-1   
#> + vctrs                     0.6.5   [dl] (1.36 MB)
#> + vroom                     1.6.5   [dl] (1.34 MB)
#> + webshot                   0.5.5   [dl] (217.16 kB)
#> + withr                     3.0.2   [dl] (231.37 kB)
#> + writexl                   1.5.1   [dl] (203.83 kB)
#> + xfun                      0.50    [dl] (591.96 kB)
#> + xml2                      1.3.6   [dl] (1.61 MB)
#> + yaml                      2.3.10  [dl] (119.45 kB)
#> + zip                       2.3.2   [dl] (452.35 kB)
#> ℹ Getting 85 pkgs (78.42 MB) and 1 pkg with unknown size, 5 (20.10 MB) cached
#> ✔ Cached copy of DT 0.33 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of R.methodsS3 1.8.2 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of R.utils 2.12.3 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of R6 2.5.1 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of Rcpp 1.0.14 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of askpass 1.2.1 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of base64enc 0.1-3 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of bit64 4.6.0-1 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of bit 4.5.0.1 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of bslib 0.9.0 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of cachem 1.1.0 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of callr 3.7.6 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of cellranger 1.1.0 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of cli 3.6.3 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of clipr 0.8.0 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of codebookr 0.1.8 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of crayon 1.5.3 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of crosstalk 1.2.1 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of curl 6.2.0 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of data.table 1.16.4 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of digest 0.6.37 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of dplyr 1.1.4 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of evaluate 1.0.3 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of fansi 1.0.6 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of fastmap 1.2.0 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of flextable 0.9.7 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of fontBitstreamVera 0.1.1 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of fontLiberation 0.1.0 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of fontawesome 0.5.3 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of fontquiver 0.2.1 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of forcats 1.0.0 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of fs 1.6.5 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of gdtools 0.4.1 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of generics 0.1.3 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of glue 1.8.0 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of haven 2.5.4 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of highr 0.11 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of hms 1.1.3 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of htmltools 0.5.8.1 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of htmlwidgets 1.6.4 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of httpuv 1.6.15 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of jquerylib 0.1.4 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of jsonlite 1.8.9 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of knitr 1.49 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of labelled 2.14.0 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of later 1.4.1 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of lazyeval 0.2.2 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of lifecycle 1.0.4 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of magrittr 2.0.3 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of memoise 2.0.1 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of mime 0.12 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of officer 0.6.7 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of pillar 1.10.1 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of pkgconfig 2.0.3 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of processx 3.8.5 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of promises 1.3.2 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of ps 1.8.1 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of ragg 1.3.3 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of rappdirs 0.3.3 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of readr 2.1.5 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of readxl 1.4.3 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of rematch 2.0.0 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of rio 1.2.3 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of rlang 1.1.5 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of rmarkdown 2.29 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of sass 0.4.9 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of stringr 1.5.1 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of sys 3.4.3 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of systemfonts 1.2.1 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of textshaping 1.0.0 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of tibble 3.2.1 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of tidyr 1.3.1 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of tidyselect 1.2.1 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of tinytex 0.54 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of tzdb 0.4.0 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of utf8 1.2.4 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of vctrs 0.6.5 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of vroom 1.6.5 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of webshot 0.5.5 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of withr 3.0.2 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of writexl 1.5.1 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of xfun 0.50 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of xml2 1.3.6 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of yaml 2.3.10 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of zip 2.3.2 (x86_64-w64-mingw32) is the latest build
#> ✔ Got datamanager 0.1.0 (source) (46.50 kB)
#> ✔ Installed R.oo 1.27.0  (666ms)
#> ✔ Installed R.methodsS3 1.8.2  (1.1s)
#> ✔ Installed askpass 1.2.1  (1.3s)
#> ✔ Installed R6 2.5.1  (1.7s)
#> ✔ Installed R.utils 2.12.3  (2.1s)
#> ✔ Installed base64enc 0.1-3  (2.2s)
#> ✔ Installed bit64 4.6.0-1  (2s)
#> ✔ Installed bit 4.5.0.1  (1.8s)
#> ✔ Installed cachem 1.1.0  (1.6s)
#> ✔ Installed cellranger 1.1.0  (2.1s)
#> ✔ Installed callr 3.7.6  (2.9s)
#> ✔ Installed DT 0.33  (5.5s)
#> ✔ Installed codebookr 0.1.8  (2.8s)
#> ✔ Installed cli 3.6.3  (4.4s)
#> ✔ Installed crayon 1.5.3  (3.6s)
#> ✔ Installed crosstalk 1.2.1  (4s)
#> ✔ Installed curl 6.2.0  (4.5s)
#> ✔ Installed clipr 0.8.0  (13.6s)
#> ✔ Installed digest 0.6.37  (10s)
#> ✔ Installed Rcpp 1.0.14  (18s)
#> ✔ Installed dplyr 1.1.4  (9.9s)
#> ✔ Installed data.table 1.16.4  (12.6s)
#> ✔ Installed evaluate 1.0.3  (10s)
#> ✔ Installed fansi 1.0.6  (9.6s)
#> ✔ Installed bslib 0.9.0  (18.9s)
#> ✔ Installed fastmap 1.2.0  (3.6s)
#> ✔ Installed flextable 0.9.7  (3.5s)
#> ✔ Installed fontBitstreamVera 0.1.1  (3.2s)
#> ✔ Installed fontLiberation 0.1.0  (2.9s)
#> ✔ Installed fontawesome 0.5.3  (3.1s)
#> ✔ Installed fontquiver 0.2.1  (3s)
#> ✔ Installed forcats 1.0.0  (3s)
#> ✔ Installed fs 1.6.5  (2.9s)
#> ✔ Installed gdtools 0.4.1  (3.2s)
#> ✔ Installed generics 0.1.3  (3.2s)
#> ✔ Installed glue 1.8.0  (3.5s)
#> ✔ Installed haven 2.5.4  (3.6s)
#> ✔ Installed highr 0.11  (3.4s)
#> ✔ Installed hms 1.1.3  (3.7s)
#> ✔ Installed htmltools 0.5.8.1  (3.8s)
#> ✔ Installed htmlwidgets 1.6.4  (3.7s)
#> ✔ Installed httpuv 1.6.15  (3.9s)
#> ✔ Installed jquerylib 0.1.4  (3.9s)
#> ✔ Installed jsonlite 1.8.9  (3.5s)
#> ✔ Installed labelled 2.14.0  (3.2s)
#> ✔ Installed later 1.4.1  (3.2s)
#> ✔ Installed lazyeval 0.2.2  (3.5s)
#> ✔ Installed knitr 1.49  (6.4s)
#> ✔ Installed lifecycle 1.0.4  (5.1s)
#> ✔ Installed magrittr 2.0.3  (5.1s)
#> ✔ Installed memoise 2.0.1  (5.4s)
#> ✔ Installed mime 0.12  (5.5s)
#> ✔ Installed officer 0.6.7  (5.7s)
#> ✔ Installed openssl 2.3.2  (5.6s)
#> ✔ Installed pillar 1.10.1  (5.7s)
#> ✔ Installed processx 3.8.5  (4.2s)
#> ✔ Installed pkgconfig 2.0.3  (5s)
#> ✔ Installed ps 1.8.1  (3.9s)
#> ✔ Installed promises 1.3.2  (5.2s)
#> ✔ Installed purrr 1.0.4  (4.3s)
#> ✔ Installed rappdirs 0.3.3  (3.2s)
#> ✔ Installed ragg 1.3.3  (4.1s)
#> ✔ Installed readxl 1.4.3  (2.5s)
#> ✔ Installed readr 2.1.5  (4.1s)
#> ✔ Installed rematch 2.0.0  (3.8s)
#> ✔ Installed rio 1.2.3  (3.7s)
#> ✔ Installed rlang 1.1.5  (3.8s)
#> ✔ Installed sass 0.4.9  (3.6s)
#> ✔ Installed stringr 1.5.1  (3.5s)
#> ✔ Installed stringi 1.8.4  (4.5s)
#> ✔ Installed sys 3.4.3  (3.5s)
#> ✔ Installed rmarkdown 2.29  (5.6s)
#> ✔ Installed systemfonts 1.2.1  (3.7s)
#> ✔ Installed textshaping 1.0.0  (3.2s)
#> ✔ Installed tibble 3.2.1  (3.2s)
#> ✔ Installed tidyr 1.3.1  (3.2s)
#> ✔ Installed tidyselect 1.2.1  (3s)
#> ✔ Installed tinytex 0.54  (3s)
#> ✔ Installed tzdb 0.4.0  (3s)
#> ✔ Installed utf8 1.2.4  (2.9s)
#> ✔ Installed uuid 1.2-1  (2.7s)
#> ✔ Installed vctrs 0.6.5  (2.6s)
#> ✔ Installed vroom 1.6.5  (2.4s)
#> ✔ Installed webshot 0.5.5  (2.2s)
#> ✔ Installed withr 3.0.2  (1.9s)
#> ✔ Installed writexl 1.5.1  (1.7s)
#> ✔ Installed xfun 0.50  (1.6s)
#> ✔ Installed xml2 1.3.6  (1.5s)
#> ✔ Installed yaml 2.3.10  (1.4s)
#> ✔ Installed zip 2.3.2  (1.1s)
#> ℹ Packaging datamanager 0.1.0
#> ✔ Packaged datamanager 0.1.0 (1.6s)
#> ℹ Building datamanager 0.1.0
#> ✔ Built datamanager 0.1.0 (3.3s)
#> ✔ Installed datamanager 0.1.0 (github::annyg/datamanager@16865be) (128ms)
#> ✔ 1 pkg + 91 deps: upd 1, added 90, dld 1 (NA B) [1m 6.2s]
library(datamanager)
```

## Usage

The `datamanager` package is designed to handle data frames and
primarily builds on tidyverse syntax. Below are examples demonstrating
how to use the main functions in `datamanager`.

### Data Management

    #> Warning: package 'dplyr' was built under R version 4.4.2
    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union

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

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.xxxxxxx.svg)](https://doi.org/10.5281/zenodo.xxxxxxx)

Example BibTeX entry:

``` bibtex
@software{Anders B. Nygaard_2023_XXXXXXX,
  author       = {Anders B. Nygaard},
  title        = {datamanager: Tools for Questionnaire and Survey Data Management},
  month        = month,
  year         = 2023,
  publisher    = {GitHub},
  journal      = {GitHub repository},
  version      = {v1.0.0},
  doi          = {10.5281/zenodo.xxxxxxx},
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

`datamanager` is licensed under the MIT License. See the `LICENSE` file
for more information. \#FIXME

------------------------------------------------------------------------

We hope you find `datamanager` useful in your research projects. For any
questions, issues, or suggestions, please open an issue on GitHub or
contact us.
