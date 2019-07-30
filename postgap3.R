library(tidyverse)
library(reshape2)
library(viridis)
library(pheatmap)
library(RColorBrewer)
library(rtracklayer)
library(plyr)


aa= unique(substr(grep('snp_posterior.pkl', list.files(),value = T),1,10))
aa2=gsub('block_','',aa)
aax=paste0('block_',gsub("([0-9]+).*$", "\\1", aa2),'.tsv.txt.pkl')
aax=data.frame(aax)
colnames(aax)=NULL

aax2=gsub('block_','',aax[,1])
aax2=as.numeric(gsub('.tsv.txt.pkl','',aax2))
ld=import.bed('../fourier_ls-all.bed')
ld=as.data.frame(ld)
ld$seqnames=gsub('chr','',ld$seqnames)
ld=ld[,c('seqnames','start','end')]
colnames(ld)[1]=c('chr')
rownames(ld) = paste0('block_',rownames(ld)) 
aax3=c()
for (i in aax2){
  a=ld[i,]
  aax3=rbind(aax3,a)}

# aa4=data.frame(rownames(aax3),aax3$chr, aax3$start,aax3$end, aax3$end-aax3$start)
# colnames(aa4)=c('block','chr','start','end','diff')
######## #######
setwd(file.path('../', 'heatmap_blocks'))
filex= grep('csv',list.files(),value = T)


resultx=c()
for (x in 1:length(filex)){
  gg=read_csv(filex[x])
  gg=as.data.frame(gg)
  gg=gg[,-1]
  gg[,1]= paste0(gg[,1],'  (',paste0('chr',aax3[gsub('.tsv.txt.pkl.csv','',filex[x])==rownames(aax3),][,1],
                                       '',aax3[gsub('.tsv.txt.pkl.csv','',filex[x])==rownames(aax3),][,2],
                                       '-',aax3[gsub('.tsv.txt.pkl.csv','',filex[x])==rownames(aax3),][,3],')'))
  resultx=rbind(resultx, gg)
}

colnames(resultx)=c('gene', 'tissue','clpp')
mat=dcast(resultx, gene~tissue)
rownames(mat)=mat$gene
mat$gene = NULL


color = colorRampPalette(brewer.pal(8,'Reds'))(1000)
pheatmap(as.matrix(mat),
         silent=T, border_color=NA, na_col='gray44', cellwidth = 20, cellheight = 10,
         col= color, cluster_rows= F, cluster_cols= F, show_rownames= T,
         main= '', filename = paste0('../outfiles_blocks/CLPP.pdf'))
