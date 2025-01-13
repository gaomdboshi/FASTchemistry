#' Get Hard Drive Serial Number
#'
#' This function retrieves the hard drive serial number.
#' It works on Windows, Linux, and macOS systems.
#'
#' @return A character string of the hard drive serial number.
#' @export
get_hard_drive_serial <- function() {
  os_type <- Sys.info()["sysname"]  # 检测系统类型

  if (os_type == "Windows") {
    # Windows 系统获取硬盘序列号
    serial <- system("wmic diskdrive get SerialNumber", intern = TRUE)
    serial <- serial[2]  # 提取序列号
  } else if (os_type == "Linux" || os_type == "Darwin") {
    # Linux 或 macOS 系统获取硬盘序列号
    serial <- system("lsblk -o SERIAL 2>/dev/null | tail -n 1", intern = TRUE)
    if (is.na(serial) || serial == "") {
      serial <- system("diskutil info disk0 | grep 'Serial Number' | awk '{print $NF}'", intern = TRUE)
    }
  } else {
    stop("Unsupported operating system!")
  }

  # 清理并返回序列号
  serial <- gsub("\\s+", "", serial)
  if (is.na(serial) || serial == "") {
    stop("Failed to retrieve hard drive serial number.")
  }

  return(serial)
}
#' Generate User Token
#'
#' This function generates a unique token based on the hard drive serial number.
#' The token can be sent to the package maintainer for authorization.
#'
#' @return A character string representing the unique token.
#' @export
generate_token <- function() {
  # 获取硬盘序列号
  serial <- get_hard_drive_serial()

  # 生成令牌
  token <- digest::digest(serial, algo = "sha256")

  # 显示令牌给用户
  cat("Your generated token is:\n", token, "\n")

  # 返回令牌
  return(token)
}
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

  # 加载授权文件
  auth_file <- system.file("extdata", "authorized_tokens.csv", package = "FASTchemistry")
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
