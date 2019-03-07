library(tidyverse)




out = paste(name,".freq.tsv", sep = "", collapse = "")

Pangenomes.cluster = read_tsv(tabla, col_names=FALSE)
colnames(Pangenomes.cluster) = c("Pangenome","Cluster","Prot","kk")
Pangenomes.cluster = Pangenomes.cluster %>% separate(Prot, c("Genome","Prot"), sep = "\\|") %>% select(-kk)
NGenomes = Pangenomes.cluster %>% select(Genome) %>% distinct() %>% count()
Pangenomes.cluster %>% 
  select(Pangenome,Cluster,Genome) %>% 
  distinct() %>% 
  group_by(Pangenome,Cluster) %>% 
  summarise(Freq = n()/NGenomes$n) %>% 
  write_tsv(out)




