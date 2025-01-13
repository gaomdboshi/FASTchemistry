#' Install Chemistry Package
#'
#' This function installs the MR-SPI package from GitHub with user-friendly messages displaying "Chemistry".
#'
#' @return NULL
#' @export
install_chemistry <- function() {
  # 调用授权验证函数
  validate_user()

  # 如果用户通过验证，继续安装 Chemistry 包
  if (!requireNamespace("devtools", quietly = TRUE)) {
    stop("The 'devtools' package is required but not installed. Please install it first using install.packages('devtools').")
  }

  # 显示下载 Chemistry 包的信息
  message("Installing Chemistry package from GitHub...")

  # 实际安装 MinhaoYaooo/MR-SPI 包
  devtools::install_github("MinhaoYaooo/MR-SPI")

  # 安装成功后的消息
  message("Chemistry package has been successfully installed.")
}
