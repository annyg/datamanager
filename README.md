
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
#> → Will download 90 CRAN packages (98.53 MB).
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
#> + datamanager       0.1.0 → 0.1.0   [bld][cmp][dl] (GitHub: 293f434)
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
#> + openssl                   2.3.2   [dl] (3.47 MB)
#> + pillar                    1.10.1  [dl] (671.54 kB)
#> + pkgconfig                 2.0.3   [dl] (22.81 kB)
#> + processx                  3.8.5   [dl] (689.25 kB)
#> + promises                  1.3.2   [dl] (2.02 MB)
#> + ps                        1.8.1   [dl] (642.64 kB)
#> + purrr                     1.0.4   [dl] (551.10 kB)
#> + R.methodsS3               1.8.2   [dl] (84.80 kB)
#> + R.oo                      1.27.0  [dl] (1.00 MB)
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
#> + stringi                   1.8.4   [dl] (15.03 MB)
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
#> + uuid                      1.2-1   [dl] (52.93 kB)
#> + vctrs                     0.6.5   [dl] (1.36 MB)
#> + vroom                     1.6.5   [dl] (1.34 MB)
#> + webshot                   0.5.5   [dl] (217.16 kB)
#> + withr                     3.0.2   [dl] (231.37 kB)
#> + writexl                   1.5.1   [dl] (203.83 kB)
#> + xfun                      0.50    [dl] (591.96 kB)
#> + xml2                      1.3.6   [dl] (1.61 MB)
#> + yaml                      2.3.10  [dl] (119.45 kB)
#> + zip                       2.3.2   [dl] (452.35 kB)
#> ℹ Getting 90 pkgs (98.53 MB) and 1 pkg with unknown size
#> ✔ Cached copy of gdtools 0.4.1 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of rmarkdown 2.29 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of xfun 0.50 (x86_64-w64-mingw32) is the latest build
#> ✔ Got DT 0.33 (i386+x86_64-w64-mingw32) (2.03 MB)
#> ✔ Got datamanager 0.1.0 (source) (42.82 kB)
#> ✔ Got R.methodsS3 1.8.2 (i386+x86_64-w64-mingw32) (84.57 kB)
#> ✔ Got R6 2.5.1 (i386+x86_64-w64-mingw32) (85.19 kB)
#> ✔ Got Rcpp 1.0.14 (x86_64-w64-mingw32) (2.90 MB)
#> ✔ Got R.oo 1.27.0 (i386+x86_64-w64-mingw32) (1.00 MB)
#> ✔ Got base64enc 0.1-3 (x86_64-w64-mingw32) (33.13 kB)
#> ✔ Got R.utils 2.12.3 (i386+x86_64-w64-mingw32) (1.45 MB)
#> ✔ Got cachem 1.1.0 (x86_64-w64-mingw32) (74.06 kB)
#> ✔ Got codebookr 0.1.8 (i386+x86_64-w64-mingw32) (91.49 kB)
#> ✔ Got digest 0.6.37 (x86_64-w64-mingw32) (223.51 kB)
#> ✔ Got generics 0.1.3 (i386+x86_64-w64-mingw32) (84.59 kB)
#> ✔ Got bslib 0.9.0 (i386+x86_64-w64-mingw32) (5.92 MB)
#> ✔ Got fontBitstreamVera 0.1.1 (i386+x86_64-w64-mingw32) (697.82 kB)
#> ✔ Got hms 1.1.3 (i386+x86_64-w64-mingw32) (105.89 kB)
#> ✔ Got httpuv 1.6.15 (x86_64-w64-mingw32) (1.00 MB)
#> ✔ Got dplyr 1.1.4 (x86_64-w64-mingw32) (1.59 MB)
#> ✔ Got highr 0.11 (i386+x86_64-w64-mingw32) (44.33 kB)
#> ✔ Got later 1.4.1 (x86_64-w64-mingw32) (468.24 kB)
#> ✔ Got fontLiberation 0.1.0 (i386+x86_64-w64-mingw32) (4.53 MB)
#> ✔ Got lifecycle 1.0.4 (i386+x86_64-w64-mingw32) (141.56 kB)
#> ✔ Got lazyeval 0.2.2 (x86_64-w64-mingw32) (164.73 kB)
#> ✔ Got openssl 2.3.2 (x86_64-w64-mingw32) (3.47 MB)
#> ✔ Got rappdirs 0.3.3 (x86_64-w64-mingw32) (53.00 kB)
#> ✔ Got officer 0.6.7 (i386+x86_64-w64-mingw32) (1.84 MB)
#> ✔ Got readxl 1.4.3 (x86_64-w64-mingw32) (1.20 MB)
#> ✔ Got readr 2.1.5 (x86_64-w64-mingw32) (1.21 MB)
#> ✔ Got stringr 1.5.1 (i386+x86_64-w64-mingw32) (324.66 kB)
#> ✔ Got tinytex 0.54 (i386+x86_64-w64-mingw32) (146.37 kB)
#> ✔ Got uuid 1.2-1 (x86_64-w64-mingw32) (52.93 kB)
#> ✔ Got bit64 4.6.0-1 (x86_64-w64-mingw32) (511.87 kB)
#> ✔ Got withr 3.0.2 (i386+x86_64-w64-mingw32) (232.95 kB)
#> ✔ Got askpass 1.2.1 (x86_64-w64-mingw32) (74.80 kB)
#> ✔ Got vctrs 0.6.5 (x86_64-w64-mingw32) (1.37 MB)
#> ✔ Got bit 4.5.0.1 (x86_64-w64-mingw32) (1.18 MB)
#> ✔ Got forcats 1.0.0 (i386+x86_64-w64-mingw32) (429.23 kB)
#> ✔ Got curl 6.2.0 (x86_64-w64-mingw32) (3.50 MB)
#> ✔ Got flextable 0.9.7 (i386+x86_64-w64-mingw32) (2.36 MB)
#> ✔ Got htmltools 0.5.8.1 (x86_64-w64-mingw32) (365.00 kB)
#> ✔ Got stringi 1.8.4 (x86_64-w64-mingw32) (15.03 MB)
#> ✔ Got data.table 1.16.4 (x86_64-w64-mingw32) (2.67 MB)
#> ✔ Got jsonlite 1.8.9 (x86_64-w64-mingw32) (1.11 MB)
#> ✔ Got labelled 2.14.0 (i386+x86_64-w64-mingw32) (358.45 kB)
#> ✔ Got magrittr 2.0.3 (x86_64-w64-mingw32) (229.75 kB)
#> ✔ Got rematch 2.0.0 (i386+x86_64-w64-mingw32) (19.47 kB)
#> ✔ Got rio 1.2.3 (i386+x86_64-w64-mingw32) (623.74 kB)
#> ✔ Got writexl 1.5.1 (x86_64-w64-mingw32) (204.04 kB)
#> ✔ Got knitr 1.49 (i386+x86_64-w64-mingw32) (1.18 MB)
#> ✔ Got ragg 1.3.3 (x86_64-w64-mingw32) (1.97 MB)
#> ✔ Got rlang 1.1.5 (x86_64-w64-mingw32) (1.63 MB)
#> ✔ Got yaml 2.3.10 (x86_64-w64-mingw32) (119.74 kB)
#> ✔ Got clipr 0.8.0 (i386+x86_64-w64-mingw32) (55.92 kB)
#> ✔ Got fansi 1.0.6 (x86_64-w64-mingw32) (324.57 kB)
#> ✔ Got fastmap 1.2.0 (x86_64-w64-mingw32) (135.59 kB)
#> ✔ Got sass 0.4.9 (x86_64-w64-mingw32) (2.61 MB)
#> ✔ Got xml2 1.3.6 (x86_64-w64-mingw32) (1.62 MB)
#> ✔ Got glue 1.8.0 (x86_64-w64-mingw32) (184.13 kB)
#> ✔ Got ps 1.8.1 (x86_64-w64-mingw32) (645.57 kB)
#> ✔ Got tidyselect 1.2.1 (i386+x86_64-w64-mingw32) (229.19 kB)
#> ✔ Got haven 2.5.4 (x86_64-w64-mingw32) (775.16 kB)
#> ✔ Got jquerylib 0.1.4 (i386+x86_64-w64-mingw32) (526.15 kB)
#> ✔ Got webshot 0.5.5 (i386+x86_64-w64-mingw32) (217.53 kB)
#> ✔ Got zip 2.3.2 (x86_64-w64-mingw32) (452.51 kB)
#> ✔ Got crayon 1.5.3 (i386+x86_64-w64-mingw32) (166.49 kB)
#> ✔ Got vroom 1.6.5 (x86_64-w64-mingw32) (1.35 MB)
#> ✔ Got htmlwidgets 1.6.4 (i386+x86_64-w64-mingw32) (813.97 kB)
#> ✔ Got mime 0.12 (x86_64-w64-mingw32) (40.89 kB)
#> ✔ Got pillar 1.10.1 (i386+x86_64-w64-mingw32) (671.70 kB)
#> ✔ Got pkgconfig 2.0.3 (i386+x86_64-w64-mingw32) (23.08 kB)
#> ✔ Got crosstalk 1.2.1 (i386+x86_64-w64-mingw32) (416.98 kB)
#> ✔ Got cellranger 1.1.0 (i386+x86_64-w64-mingw32) (107.67 kB)
#> ✔ Got evaluate 1.0.3 (i386+x86_64-w64-mingw32) (104.11 kB)
#> ✔ Got textshaping 1.0.0 (x86_64-w64-mingw32) (1.47 MB)
#> ✔ Got callr 3.7.6 (i386+x86_64-w64-mingw32) (477.72 kB)
#> ✔ Got cli 3.6.3 (x86_64-w64-mingw32) (1.37 MB)
#> ✔ Got tibble 3.2.1 (x86_64-w64-mingw32) (696.69 kB)
#> ✔ Got utf8 1.2.4 (x86_64-w64-mingw32) (151.25 kB)
#> ✔ Got fontawesome 0.5.3 (i386+x86_64-w64-mingw32) (1.39 MB)
#> ✔ Got memoise 2.0.1 (i386+x86_64-w64-mingw32) (51.50 kB)
#> ✔ Got processx 3.8.5 (x86_64-w64-mingw32) (689.25 kB)
#> ✔ Got purrr 1.0.4 (x86_64-w64-mingw32) (551.10 kB)
#> ✔ Got sys 3.4.3 (x86_64-w64-mingw32) (48.10 kB)
#> ✔ Got systemfonts 1.2.1 (x86_64-w64-mingw32) (1.60 MB)
#> ✔ Got tzdb 0.4.0 (x86_64-w64-mingw32) (1.02 MB)
#> ✔ Got fs 1.6.5 (x86_64-w64-mingw32) (415.01 kB)
#> ✔ Got tidyr 1.3.1 (x86_64-w64-mingw32) (1.27 MB)
#> ✔ Got promises 1.3.2 (x86_64-w64-mingw32) (2.02 MB)
#> ✔ Got fontquiver 0.2.1 (i386+x86_64-w64-mingw32) (2.28 MB)
#> ✔ Installed R.oo 1.27.0  (950ms)
#> ✔ Installed R.methodsS3 1.8.2  (1.5s)
#> ✔ Installed R.utils 2.12.3  (2.1s)
#> ✔ Installed R6 2.5.1  (2.4s)
#> ✔ Installed base64enc 0.1-3  (2.7s)
#> ✔ Installed askpass 1.2.1  (3.2s)
#> ✔ Installed bit 4.5.0.1  (2.5s)
#> ✔ Installed bit64 4.6.0-1  (3.3s)
#> ✔ Installed cachem 1.1.0  (2.2s)
#> ✔ Installed DT 0.33  (5.7s)
#> ✔ Installed cellranger 1.1.0  (2.8s)
#> ✔ Installed callr 3.7.6  (3.9s)
#> ✔ Installed codebookr 0.1.8  (2.3s)
#> ✔ Installed cli 3.6.3  (3.4s)
#> ✔ Installed crayon 1.5.3  (2.2s)
#> ✔ Installed clipr 0.8.0  (6.6s)
#> ✔ Installed Rcpp 1.0.14  (11.8s)
#> ✔ Installed crosstalk 1.2.1  (6s)
#> ✔ Installed curl 6.2.0  (6s)
#> ✔ Installed digest 0.6.37  (5.8s)
#> ✔ Installed dplyr 1.1.4  (5.9s)
#> ✔ Installed data.table 1.16.4  (6.7s)
#> ✔ Installed evaluate 1.0.3  (3s)
#> ✔ Installed fansi 1.0.6  (2.5s)
#> ✔ Installed fastmap 1.2.0  (2.3s)
#> ✔ Installed bslib 0.9.0  (13.1s)
#> ✔ Installed flextable 0.9.7  (2.5s)
#> ✔ Installed fontBitstreamVera 0.1.1  (2.4s)
#> ✔ Installed fontLiberation 0.1.0  (2.4s)
#> ✔ Installed fontawesome 0.5.3  (2.4s)
#> ✔ Installed fontquiver 0.2.1  (2.4s)
#> ✔ Installed forcats 1.0.0  (2.2s)
#> ✔ Installed fs 1.6.5  (2.1s)
#> ✔ Installed gdtools 0.4.1  (2.1s)
#> ✔ Installed generics 0.1.3  (1.9s)
#> ✔ Installed glue 1.8.0  (1.9s)
#> ✔ Installed haven 2.5.4  (1.9s)
#> ✔ Installed highr 0.11  (1.9s)
#> ✔ Installed hms 1.1.3  (1.9s)
#> ✔ Installed htmltools 0.5.8.1  (2s)
#> ✔ Installed htmlwidgets 1.6.4  (2s)
#> ✔ Installed httpuv 1.6.15  (2.1s)
#> ✔ Installed jquerylib 0.1.4  (2.2s)
#> ✔ Installed jsonlite 1.8.9  (2.1s)
#> ✔ Installed later 1.4.1  (1.6s)
#> ✔ Installed labelled 2.14.0  (2.1s)
#> ✔ Installed lazyeval 0.2.2  (1.9s)
#> ✔ Installed lifecycle 1.0.4  (2s)
#> ✔ Installed knitr 1.49  (3.7s)
#> ✔ Installed magrittr 2.0.3  (2.5s)
#> ✔ Installed memoise 2.0.1  (2.5s)
#> ✔ Installed mime 0.12  (2.5s)
#> ✔ Installed officer 0.6.7  (2.4s)
#> ✔ Installed openssl 2.3.2  (2.5s)
#> ✔ Installed pillar 1.10.1  (2.5s)
#> ✔ Installed pkgconfig 2.0.3  (2.4s)
#> ✔ Installed processx 3.8.5  (1.9s)
#> ✔ Installed promises 1.3.2  (1.9s)
#> ✔ Installed ps 1.8.1  (2s)
#> ✔ Installed purrr 1.0.4  (2.1s)
#> ✔ Installed ragg 1.3.3  (2.2s)
#> ✔ Installed rappdirs 0.3.3  (2.1s)
#> ✔ Installed readr 2.1.5  (2.2s)
#> ✔ Installed readxl 1.4.3  (2.2s)
#> ✔ Installed rematch 2.0.0  (2.8s)
#> ✔ Installed rio 1.2.3  (2.9s)
#> ✔ Installed rlang 1.1.5  (3s)
#> ✔ Installed sass 0.4.9  (2.7s)
#> ✔ Installed rmarkdown 2.29  (3.6s)
#> ✔ Installed stringr 1.5.1  (2.9s)
#> ✔ Installed sys 3.4.3  (2.9s)
#> ✔ Installed stringi 1.8.4  (3.8s)
#> ✔ Installed systemfonts 1.2.1  (2.8s)
#> ✔ Installed textshaping 1.0.0  (2.6s)
#> ✔ Installed tibble 3.2.1  (2.4s)
#> ✔ Installed tidyr 1.3.1  (2.2s)
#> ✔ Installed tinytex 0.54  (1.8s)
#> ✔ Installed tidyselect 1.2.1  (2.5s)
#> ✔ Installed tzdb 0.4.0  (2.1s)
#> ✔ Installed utf8 1.2.4  (2s)
#> ✔ Installed uuid 1.2-1  (2s)
#> ✔ Installed vctrs 0.6.5  (2s)
#> ✔ Installed webshot 0.5.5  (1.7s)
#> ✔ Installed vroom 1.6.5  (2.1s)
#> ✔ Installed withr 3.0.2  (1.5s)
#> ✔ Installed writexl 1.5.1  (1.4s)
#> ✔ Installed xfun 0.50  (1.2s)
#> ✔ Installed xml2 1.3.6  (1.1s)
#> ✔ Installed yaml 2.3.10  (1s)
#> ✔ Installed zip 2.3.2  (845ms)
#> ℹ Packaging datamanager 0.1.0
#> ✔ Packaged datamanager 0.1.0 (1.2s)
#> ℹ Building datamanager 0.1.0
#> ✔ Built datamanager 0.1.0 (2.4s)
#> ✔ Installed datamanager 0.1.0 (github::annyg/datamanager@293f434) (120ms)
#> ✔ 1 pkg + 91 deps: upd 1, added 90, dld 88 (NA B) [57s]
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
