library(dplyr)
library(tidyr)
library(readr)
library(tibble)
library(igraph)

AssemblyTable = read.csv("/storage/accnet2Pan/CompleteGenomesTable.tsv", header = FALSE, sep = "\t")
prot = read.table("/storage/accnet2Pan/all.prot", header = FALSE, sep = "\t")
colnames(prot) = c("folder","assembly_accession","ID2","Path","Nprot")
colnames(AssemblyTable) = c(
  "assembly_accession",
  "bioproject",
  "biosample",
  "wgs_master",
  "refseq_category",
  "taxid",
  "species_taxid",
  "organism_name",
  "infraspecific_name",
  "isolate",
  "version_status",
  "assembly_level",
  "release_type",
  "genome_rep",
  "seq_rel_date",
  "asm_name",
  "submitter",
  "gbrs_paired_asm",
  "paired_asm_comp",
  "ftp_path",
  "excluded_from_refseq",
  "relation_to_type_material"
)

Table = inner_join(AssemblyTable,prot)

Table = Table %>% group_by(species_taxid) %>% mutate(NGenomes = n()) %>% filter(NGenomes > 100)



A2A = read_tsv("/storage/accnet2Pan/A2A.tsv", col_names = FALSE)
colnames(A2A) = c("Source","Target","dist","pvalue","sketch")
A2A = as_tibble(A2A)
#gr = graph_from_data_frame(A2A %>% select(Source,Target,dist) %>% mutate(weight = 2-dist),directed = FALSE)

tmp2 = A2A %>% filter(Source %in% Table$Path) %>% filter(Target %in% Table$Path)


## Eliminamos Redundancias

tmp = A2A %>% filter(dist < 0.0001)

gr = graph_from_data_frame(tmp %>% select(Source,Target,dist) %>% mutate(weight = 2-dist),directed = FALSE)
gr_u = simplify(gr, remove.multiple = TRUE, remove.loops = TRUE)
cl = cluster_fast_greedy(gr_u)

Table = as.data.frame(as.matrix(membership(cl)))  %>% rownames_to_column("Path") %>% as_tibble() %>% select(Path,ClusterNR = V1) %>% inner_join(Table)

tmp = Table %>% group_by(ClusterNR) %>% summarise_all(first) %>% select(Source = Path)

tmp2 = A2A %>% filter(Source %in% tmp$Source) %>% filter(Target %in% tmp$Source)


## Calculamos clusters para 2000 pangenomas

gr2 = graph_from_data_frame(tmp2 %>% select(Source,Target,dist) %>% filter(dist < selection(2000,0,0.05, tmp2, 0.05))%>% mutate(weight = 2-dist),directed = FALSE)
gr_2 = simplify(gr2, remove.multiple = TRUE, remove.loops = TRUE)
cl2 = cluster_fast_greedy(gr_2)
Table = as.data.frame(as.matrix(membership(cl2)))  %>% rownames_to_column("Path") %>% as_tibble() %>% select(Path,PanGenome = V1) %>% inner_join(Table) %>% group_by(PanGenome) %>% mutate(PanGenomeSize = n())



## Eliminamos los pangenomas con menos de 10 genomas y volvemos a calcular 500 pangenomas
Table = Table %>% ungroup() %>% filter(PanGenomeSize >= 10)


write.table(Table,"/storage/accnet2Pan/TablePangenomes.tsv", sep = "\t")

selection <- function(x, min, max, tabla_mash,tolerancia){
  
  colnames(tabla_mash) = c("Source","Target","dist","pvalue","sketch")
  grafo <- tabla_mash %>% select(Source,Target,dist) %>% graph_from_data_frame(, directed=FALSE)
  componentes<-components(grafo)
  Nc <- as.numeric(componentes$no)
  Th <- max/2
  
  contador <- 0
  
  while (Nc != x) { 
    
    if (contador >=100000){    
      break
    }
    
    if (abs(1-(Nc/x)) < tolerancia){
      print(paste("Th elegido:", Th, sep = " "))
      print(paste("Nc final:", Nc, sep = " "))
      break
    }
    
    if (Nc > x){
      min <- Th
      Th <-(max + Th)/2
      print("hola")
      print(paste("min:", min, sep = " "))
      print(paste("Th:", Th, sep = " "))
      
    }
    
    else if (Nc < x){
      max <- Th
      Th <- (Th - min)/2
      print("adios")
      print(paste("max:", max, sep = " "))
      print(paste("Th:", Th, sep = " "))
    }
    
    
    grafo <- tabla_mash %>% select(Source,Target,dist) %>% filter(dist < Th) %>% graph_from_data_frame(, directed=FALSE)
    componentes <- components(grafo)
    Nc <- as.numeric(componentes$no)
    
    print(Nc)
    contador <- contador +1
    print(paste("FIN VUELTA:", contador, sep = " "))
    
  }
  print(paste("Th elegido:", Th, sep = " "))
  print(paste("Nc final:", Nc, sep = " "))
  return(Th)
  
}
