#' Validate User Authorization
#'
#' This function checks if the user is authorized based on their token.
#'
#' @return TRUE if authorized, otherwise stops with an error.
#' @export
validate_user <- function() {
  # 获取硬盘序列号
  serial <- get_hard_drive_serial()

  # 根据硬盘序列号生成令牌
  user_token <- digest::digest(serial, algo = "sha256")

  # **这里使用本地路径** 读取授权文件
  auth_file <- "D:/桌面/自创包/FASTchemistry/inst/extdata/authorized_tokens.csv"  # 修改为你的本地路径
  if (!file.exists(auth_file)) {
    stop("Authorization file not found. Please contact the package maintainer.")
  }

  # 读取授权文件
  auth_tokens <- read.csv(auth_file, stringsAsFactors = FALSE)

  # 检查用户令牌是否在授权列表中
  if (user_token %in% auth_tokens$token) {
    cat("User authorized. Access granted.\n")
    return(TRUE)
  } else {
    stop("Unauthorized user. Please contact the package maintainer for access.")
  }
}

