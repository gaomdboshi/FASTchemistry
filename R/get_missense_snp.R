get_missense_snp <- function(gene_name) {
  # 先进行用户授权验证
  validate_user()  # 调用你定义的授权验证函数

  library(biomaRt)

  # 确保基因名为UTF-8编码
  gene_name <- iconv(gene_name, from = "latin1", to = "UTF-8")

  # 连接到Ensembl Gene数据库来查询基因的Ensembl Gene ID
  ensembl_gene <- useMart("ENSEMBL_MART_ENSEMBL", dataset = "hsapiens_gene_ensembl")

  # 根据基因名称查询Ensembl Gene ID
  gene_id_info <- getBM(attributes = c('ensembl_gene_id'),
                        filters = 'external_gene_name', values = gene_name, mart = ensembl_gene)

  if (nrow(gene_id_info) == 0) {
    cat("没有找到该基因的相关信息，请检查基因名称是否正确。\n")
    return(NULL)
  } else {
    cat("查询到的基因ID为：", gene_id_info$ensembl_gene_id[1], "\n")

    ensembl_snp <- useMart("ENSEMBL_MART_SNP", dataset = "hsapiens_snp")

    gene_id <- gene_id_info$ensembl_gene_id[1]

    gene_info <- getBM(attributes = c('refsnp_id', 'consequence_type_tv', 'allele', 'allele_1'),
                       filters = 'ensembl_gene', values = gene_id, mart = ensembl_snp)

    gene_info$mutation_type <- ifelse(gene_info$consequence_type_tv == "missense_variant",
                                      "Missense Variant", "Other Variant")

    missense_snp <- gene_info[gene_info$consequence_type_tv == "missense_variant", ]

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
