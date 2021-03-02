#!/usr/bin/perl
use File::Basename;
use File::Copy;
$CON1="bamboo_rat"; #趋同物种1
$CON2="node22";
$ANC1="node16";  #祖先物种1
$ANC2="node21";
$REF="Homo";
$CONTROL1="nide19";
$CONTROL2="node23";
@spe=qw/bamboo_rat zokor Heterocephalus_glaber_female Mus Cricetulus_griseus_chok1gshd Jaculus_jaculus Nannospalax_galili Fukomys_damarensis Octodon_degus Cavia Ictidomys Homo  node13 node14 node15 node16 node17 node18 node19 node20 node21 node22 node23/; 

#((((((3_bamboo_rat, 5_zokor) 18 , 4_Nannospalax_galili) 17 , (1_Mus, 2_Cricetulus_griseus_chok1gshd) 19 ) 16 , 6_Jaculus_jaculus) 15 , (((10_Heterocephalus_glaber_female, 11_Fukomys_damarensis) 22 , (9_Octodon_degus, 8_Cavia) 23 ) 21 , 7_Ictidomys) 20 ) 14 , 12_Homo) 13 ;

system("mkdir convergence_genes divergence_genes");
open OUT, ">convergence_sites";
open CC, ">divergence_sites";
print OUT "gene\tposition\t$CON1\t$REF\t$ANC1\t$ANC2";
print CC "gene\tposition\t$CON1\t$CON2\t$REF\t$ANC1\t$ANC2";
foreach $species (@spe) {
	print OUT "\t$species";
	print CC "\t$species";
}
print OUT "\n";
print CC "\n";
open BL, ">convergence_gene_length";
@name=glob("./ancestor_for_convergence/*");
$total=$#name+1;
$deal_num=0;
foreach $name (@name) {
	$deal_num++;
	print "it is dealing $deal_num/$total now ...................................\n";
	$name1=basename $name;
	$num=0;
	print BL "$name1\t";
	$flag="no";
	$flag1="no";
	open IN, "<$name";
	undef %hash;
    undef $len;
	while (<IN>) {
	s/\r\n//;
	chomp;
	if (/^\>/) {
		($spe)=$_=~/^\>(\S+)/;
	}else{
		if (/^$/ or /^\s+$/) {
		}else{
		$hash{$spe}=$_;
	  }
    }
}
close IN;

	$len=length($hash{$REF});
	for ($i=0;$i<$len;$i++) {
		undef %site;
		while (($k,$v)=each %hash) {
			$site=substr($v,$i,1);
			$site{$k}=$site;
	}

		if ($site{$CON1} !~/[X*~-]/ and $site{$CON2} !~/[X*~-]/ and$site{$ANC1} !~/[X*~-]/ and $site{$ANC2} !~/[X*~-]/ and $site{$REF} !~/[X*~-]/ and $site{$CONTROL1}!~/[X*~-]/ and $site{$CONTROL2}!~/[X*~-]/) {   
          $num++;
	    if ($site{$CON1} ne $site{$ANC1} and $site{$CON2} ne $site{$ANC2}) {		 
            if ($site{$CON1} eq $site{$CON2}) {
			  $flag="ok";
			  $j=$i+1;
			  print OUT "$name1\t$j\t$site{$CON1}\t$site{$REF}\t$site{$ANC1}\t$site{$ANC2}";
			   foreach $species (@spe) {
				   print OUT "\t$site{$species}";
			   }
			   print OUT "\n";
		  }
		  
		  if ($site{$CON1} ne $site{$CON2}) {
			  $flag1="ok";
			  $j=$i+1;
			  print CC "$name1\t$j\t$site{$CON1}\t$site{$CON2}\t$site{$REF}\t$site{$ANC1}\t$site{$ANC2}";
			   foreach $species (@spe) {
				   print CC "\t$site{$species}";
			   }
			   print CC "\n";
		  }
		  

		}
  }
}
	
	print BL "$num\n";
	if ($flag eq "ok") {
		copy("$name", "./convergence_genes/$name1");
	}
	if ($flag1 eq "ok") {
		copy("$name", "./divergence_genes/$name1");
	}
}
close OUT;
close BL;
