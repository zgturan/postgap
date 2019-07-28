# To convert to 0-start, half-open: subtract 1 from start, end = same

library(tidyverse)
anno=grep('.vcf',list.files(),value = T)

for (x in 1:length(anno)){
  annox = read_tsv(anno[x])
  annox=as.data.frame(annox)
  annox[,'#CHROM']=gsub('chr','',annox[,'#CHROM'])
  annox=data.frame(annox[,'#CHROM'], annox[,'POS']-1, annox[,'POS'], annox[,'VALUE'])
  colnames(annox)=c('#chr','start','stop','score')
  write_tsv(annox, gsub('vcf', 'bed', anno[x]), col_names = FALSE)
}
