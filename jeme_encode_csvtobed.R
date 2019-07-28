library(tidyverse)
jemex=list.files()

# jeme='encoderoadmap_lasso.92.csv'
# jedat = read_csv(jeme, col_names = FALSE)

for (jeme in 1:length(jemex)){
  jedat = read_csv(jemex[jeme], col_names = FALSE)
  jedatgene <- data.frame(do.call('rbind', strsplit(as.character(jedat$X2),'$',fixed=TRUE)))
  jedatgene2=as.character(jedatgene$X1)
  jedatgene3=data.frame(do.call('rbind',strsplit(jedatgene2,'.',fixed=TRUE)))
  jedatgene4=as.character(jedatgene3$X1)
  
  jedat0 <- data.frame(do.call('rbind', strsplit(as.character(jedat$X1),':',fixed=TRUE)))
  jedat1 <- data.frame(do.call('rbind', strsplit(as.character(jedat0$X2),'-',fixed=TRUE)))
  jedat0[,1]=gsub('chr','',as.character(jedat0[,1]))
  jedata= cbind(jedat0[,1], as.numeric(as.character(jedat1$X1)), as.numeric(as.character(jedat1$X2)), jedat$X3, as.character(jedatgene4))
  colnames(jedata)=c("chr",'start','end','score','gene')
  jedata=jedata[jedata[,1]!='X',]
  jedata=as_tibble(jedata)
  jedata$chr=as.numeric(jedata$chr)
  jedata$start=as.numeric(jedata$start)
  jedata$end=as.numeric(jedata$end)
  jedata$score =as.numeric(jedata$score)
  jedata$gene =as.character(jedata$gene)
  
  # pick max value for each gene
  jedata=jedata %>%
    group_by(gene) %>%
    filter(score==max(score))

  jedata= jedata[order(jedata$chr),]
  assign(jemex[jeme], jedata)
  write_tsv(get(jemex[jeme]), gsub('.csv','.bed',jemex[jeme]), col_names = F)
  
}
