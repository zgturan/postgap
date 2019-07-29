library(tidyverse)
anno=grep('.bb.bed3$',list.files(),value = T)

for (x in 1:length(anno)){
bb =read_tsv(anno[x], col_names = FALSE) %>%
select(X1,X2,X3,X5)
bb$X1=as.numeric(gsub('chr','',bb$X1))
bb$X5=as.numeric(gsub('1000','1',bb$X5))

write_tsv(bb, gsub('.bb.bed3', '.bed', anno[x]), col_names = FALSE)
}
