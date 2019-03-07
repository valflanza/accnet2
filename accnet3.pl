#!/usr/bin/perl



system("rm *.rnm all.msh");
system("rm -r tmpDir");
foreach $k (@ARGV)
{
	#print "$k\n";	
	system("sed 's/>/>$k#/' $k >> all.rnm");
}


system("mmseqs easy-linclust  all.rnm accnet tmpDir --threads 20 -e 1e-4 --min-seq-id 0.8 -c 0.8");
system("grep '>' accnet_rep_seq.fasta | sed 's/>//' | sed 's/\t/ /g' | sed 's/ /\t/' > AnnotFile.tsv");

system("mash sketch -p 20 -a -o all.msh @ARGV");
system("mash dist -p 20 -t all.msh all.msh > Dist.tab");


open(TABLE,"accnet_cluster.tsv");


$threshold = 0.8;

while ($l = <TABLE>)
{
	chomp $l;
	@cols =split(/\t/,$l);
	
	@gen	=split("#",$cols[1]);
	
	$net{$cols[0]}{$gen[0]}++;

}

open(ANNOT,"AnnotFile.tsv");

while ($l = <ANNOT>)
{
	chomp $l;
	@c = split(/\t/,$l);
	$annot{$c[0]} = $c[1];
}
close ANNOT;

open(NET,">Network.tsv");
print NET "Source\tTarget\n";
open(TABLE, ">Table.tsv");
print TABLE "ID\tAnnotation\tType\n";


foreach $gu (@ARGV)
{
	print TABLE "$gu\t$gu\tGU\n";
}


$i=0;
foreach $k1 (keys(%net))
{
	
	if(scalar(keys(%{$net{$k1}}))/scalar(@ARGV) <= $threshold)
	{
		
		$i = $i+1;
		print TABLE "Cluster_$i\t$annot{$k1}\tProtein\n";
		foreach $k2 (keys(%{$net{$k1}}))
		{
			@cluster = split("#",$k1);
			
			print NET "Cluster_$i\t$k2\n";
		}
	}
}
close NET;
close TABLE;


