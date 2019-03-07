#!/usr/bin/perl

system("grep  'Escherichia' /storage/BD/assembly_summary_refseq.txt > CompleteGenomesTable.tsv");
system("grep  'Klebsiella' /storage/BD/assembly_summary_refseq.txt >> CompleteGenomesTable.tsv");
system("grep  'Salmonella' /storage/BD/assembly_summary_refseq.txt >> CompleteGenomesTable.tsv ");
system("grep  'Serratia' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv ");
system("grep  'Shigella' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv ");
system("grep  'Pseudomonas' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv ");
system("grep  'Enterobacter' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv ");
system("grep  'Citrobacter' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv ");
system("grep  'Proteus' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv ");
system("grep  'Legionella' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv");
system("grep  'Vibrio' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv");
system("grep  'Shewanella' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv");
system("grep  'Aeromonas' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv");
system("grep  'Haemophilus' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv");
system("grep  'Pasteurella' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv");
system("grep  'Acinetobacter' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv");
system("grep  'Yersinia' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv");
system("grep  'Buchnera' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv");
system("grep  'Hafnia' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv");
system("grep  'Morganella' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv");
system("grep  'Stenotrophomonas' /storage/BD/assembly_summary_refseq.txt >>CompleteGenomesTable.tsv");






