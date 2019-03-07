#!/usr/bin/perl 


$indexGenome = 1;

open(TABLE,">Table_idx_genomes.txt");
foreach $ar (@ARGV)
{
	system("sed 's/>/>$indexGenome|/' $ar >> all_fasta.tmp");
	print TABLE "$ar\t$indexGenome\n";
	$indexGenome++;
}

system("$PATH/bin/mmseqs createdb all_fasta.tmp all_fasta.mmseq");
system("$PATH/bin/mmseqs cluster all_fasta.mmseq all_fasta.cluster tmpDir -c 0.8 -e 1e-6 --min-seq-id 0.8");
system("$PATH/bin/mmseqs createtsv all_fasta.mmseq all_fasta.mmseq all_fasta.cluster all_fasta.cluster.tsv");
system("$PATH/bin/mmseqs result2repseq all_fasta.mmseq all_fasta.cluster all_fasta.representatives");
system("$PATH/bin/mmseqs result2flat all_fasta.mmseq all_fasta.mmseq all_fasta.representatives all_fasta.representatives.fasta --use-fasta-header");
