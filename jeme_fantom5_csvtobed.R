library(tidyverse)
jemex=list.files()

for (jeme in 1:length(jemex)){
  jedat = read_csv(jemex[jeme], col_names = FALSE)
  colnames(jedat)=c('pos','name','score')

  jedat=jedat %>%
    group_by(name) %>%
    filter(score==max(score))

  jedatgene <- strsplit(jedat$name, '[$]')
  jedatgene2=sapply(jedatgene, "[", 2 )
  head(jedatgene2)
  jedat0 <- data.frame(do.call('rbind', strsplit(as.character(jedat$pos),':',fixed=TRUE)))
  jedat1 <- data.frame(do.call('rbind', strsplit(as.character(jedat0$X2),'-',fixed=TRUE)))
  
  jedat0[,1]=gsub('chr','',as.character(jedat0[,1]))
  jedata= cbind(jedat0[,1], jedat1, as.character(jedatgene2), jedat$score)
  colnames(jedata)=c("chr",'start','end','gene','score')
  jedata=as.data.frame(jedata)
  jedata=jedata[jedata$chr!='X',]
  jedata=jedata[order(as.numeric(as.character(jedata$chr))),]
  
  jedata=as_tibble(jedata) 
  jedata$chr=as.numeric(as.character((jedata$chr)))
  jedata$start=as.numeric(as.character((jedata$start)))
  jedata$end=as.numeric(as.character((jedata$end)))
  jedata$gene=as.character(jedata$gene)
  jedata$score=as.numeric(as.character((jedata$score)))
  
  jedata=jedata%>%
    group_by(gene)%>%
    filter(score==max(score))
  
  assign(jemex[jeme], jedata)
  write_tsv(get(jemex[jeme]), gsub('.csv','.bed',jemex[jeme]), col_names = F)
  }

