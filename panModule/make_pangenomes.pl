#!/usr/bin/perl

use Statistics::R;
use Cwd;


$R = Statistics::R->new(shared => 1);
$R->start();
$RUNPATH = getcwd();
$R->run("library(tidyverse)");

$coverage = 0.8;
$evalue = 1e-6;
$minIdentity = 0.8;

open(A,$ARGV[0]);
@tabla = <A>;
close A;

shift(@tabla);

foreach $l (@tabla)
{
	chomp $l;
	@c= split(/\t/,$l);

	$pangenomes{"Pangenome$c[2]"} = 1;
	
	if( ! -d "Pangenome$c[2]")
	{
		system("mkdir Pangenome$c[2]");
		
	}
	if( ! -e "./Pangenome$c[2]/$c[4].faa")
	{
		system("sed 's/>/>$c[4]|/' $c[1] > ./Pangenome$c[2]/$c[4].faa");
	}
}


foreach $k (keys(%pangenomes))
{
	print "$k\n";
	chdir($k);
		
	system("sed 's/^/$k\t/' $k.cluster.tsv > $k.cluster.add.tsv");
	$R->set('tabla',"$k/$k.cluster.add.tsv");
	$R->set('name',$k);
	$R->run_from_file("prueba.r");
	system("cp $k.representatives.fasta ..");
		
	chdir("..");
}


system("mmseqs createdb *.representatives.fasta all.mmseq");
system("mmseqs linclust all.mmseq all.cluster tmpDir -c $coverage -e $evalue --min-seq-id $minIdentity");
system("mmseqs createtsv all.mmseq all.mmseq all.cluster all.cluster.tsv");
system("mmseqs result2repseq all.mmseq all.cluster all.representatives");
system("mmseqs result2flat all.mmseq all.mmseq all.representatives all.representatives.fasta --use-fasta-header");



