# R/get_missense_snp.R

#' 查询基因的错义突变
#'
#' @param gene_name 基因名称（如："ACTN3"）
#' @return 返回该基因的错义突变信息，并将其保存为 CSV 文件
#' @export
get_missense_snp <- function(gene_name) {
  library(biomaRt)

  # 确保基因名为UTF-8编码
  gene_name <- iconv(gene_name, from = "latin1", to = "UTF-8")

  # 连接到Ensembl Gene数据库来查询基因的Ensembl Gene ID
  ensembl_gene <- useMart("ENSEMBL_MART_ENSEMBL", dataset = "hsapiens_gene_ensembl")

  # 根据基因名称查询Ensembl Gene ID
  gene_id_info <- getBM(attributes = c('ensembl_gene_id'),
                        filters = 'external_gene_name', values = gene_name, mart = ensembl_gene)

  # 查看查询结果，确认是否返回了基因ID
  if (nrow(gene_id_info) == 0) {
    cat("没有找到该基因的相关信息，请检查基因名称是否正确。\n")
    return(NULL)
  } else {
    cat("查询到的基因ID为：", gene_id_info$ensembl_gene_id[1], "\n")

    # 连接到Ensembl SNP数据库来查询该基因的所有SNP
    ensembl_snp <- useMart("ENSEMBL_MART_SNP", dataset = "hsapiens_snp")

    # 使用查询得到的 Ensembl Gene ID 来查询该基因的所有SNP
    gene_id <- gene_id_info$ensembl_gene_id[1]  # 使用返回的基因ID

    # 查询该基因的所有SNP信息，使用有效的属性
    gene_info <- getBM(attributes = c('refsnp_id', 'consequence_type_tv', 'allele', 'allele_1'),
                       filters = 'ensembl_gene', values = gene_id, mart = ensembl_snp)

    # 标注所有变异类型
    gene_info$mutation_type <- ifelse(gene_info$consequence_type_tv == "missense_variant", 
                                      "Missense Variant", "Other Variant")

    # 过滤出错义突变（missense variant）
    missense_snp <- gene_info[gene_info$consequence_type_tv == "missense_variant", ]

    # 输出错义突变信息
    if (nrow(missense_snp) > 0) {
      cat("找到错义突变，正在保存为 CSV 文件...\n")
      write.csv(missense_snp, file = paste0(gene_name, "_missense_snp.csv"), row.names = FALSE)
      return(missense_snp)
    } else {
      cat("没有找到错义突变（missense variant）\n")
      return(NULL)
    }
  }
}
