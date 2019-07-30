library(tidyverse)
list.files()
aa= unique(substr(grep('snp_posterior.pkl', list.files(),value = T),1,10))
aa2=gsub('block_','',aa)
aax=paste0('block_',gsub("([0-9]+).*$", "\\1", aa2),'.tsv.txt.pkl')
aax=data.frame(aax)
write.table(aax, file.path('..','heatmap_blocks','heatmap_blocks.tsv'), quote = FALSE, col.names = F, row.names = F)

