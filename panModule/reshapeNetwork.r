library(tidyverse)

network = read_tsv("/storage/accnet2Pan/all.cluster.tsv", col_names = FALSE)
colnames(network) = c("Source","Target","kk")

freq = read_tsv("/storage/accnet2Pan/all.freq.tsv", col_names = FALSE)
colnames(freq) = c("Pangenome","Target","Freq")

Table = network %>% select(-kk) %>% group_by(Source) %>% mutate(grado = n()) %>% filter(grado >1) %>% left_join(freq)

TableOut = Table %>% mutate(Weight = 1+Freq, Type = "Undirected") %>% 
  select(Source, Target = Pangenome, Weight, Type)

TableOut = Table %>% write_tsv("/storage/accnet2Pan/PanNetwork.tsv")

GenomesTable = read.csv("/storage/accnet2Pan/TablePangenomes.tsv", sep = "\t", header = TRUE)

GenomesTable = GenomesTable %>% mutate(dummy = "Pangenome") %>% unite("Pangenome",dummy,PanGenome, sep = "") %>% as_tibble()

GenomesTable %>% separate(organism_name, c("genus","specie"), sep = " ") %>% 
  unite("specie",genus,specie, sep = " ") %>% group_by(ID =Pangenome) %>% 
  summarise(PanGenomeSize = max(PanGenomeSize), Label = first(specie)) %>% mutate(Specie = Label) %>%
  write.table("/storage/accnet2Pan/AnnotationTable.tsv",sep = "\t",col.names = TRUE, row.names = FALSE, quote = FALSE)
