#' Install MR-SPI Package
#'
#' This function installs the MR-SPI package from GitHub.
#'
#' @return NULL
#' @export
install_mr_spi <- function() {
  if (!requireNamespace("devtools", quietly = TRUE)) {
    stop("The 'devtools' package is required but not installed. Please install it first using install.packages('devtools').")
  }

  message("Installing MR-SPI from GitHub...")
  devtools::install_github("MinhaoYaooo/MR-SPI")
  message("MR-SPI has been successfully installed.")
}
