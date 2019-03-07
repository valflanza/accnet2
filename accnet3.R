library("dplyr")
library("tidyr")
library("readr")

file = "/storage/faeciumDB_faa/pruebasLinclust_cluster.tsv"
annotFile = "/storage/faeciumDB_faa/AnnotFile"
threshold = 0.8



Table = read_tsv(file, col_names = FALSE)
Annot = read_tsv(annotFile, col_names = FALSE)
colnames(Annot) = c("Cluster","Annot")
Annot = Annot %>% separate(Cluster,c("GenomeCluster","GeneCluster"), sep = "#", remove = FALSE)
colnames(Table) = c("Cluster","Gene")

Table = Table %>% separate(Cluster,c("GenomeCluster","GeneCluster"), sep = "#", remove = FALSE) %>% separate(Gene, c("GenomeGene","GeneGene"), sep = "#", remove = FALSE)
Table = Table %>% group_by(GeneCluster) %>% mutate(freqGeneCluster = n_distinct(GenomeGene))
Table = Table %>% ungroup() %>%mutate(NGenomes = n_distinct(GenomeCluster)) 
Table = Table %>% mutate(freq = freqGeneCluster/NGenomes)
Table_filtered = Table %>% filter(freq <= threshold)



Table_filtered %>% group_by(GeneCluster)