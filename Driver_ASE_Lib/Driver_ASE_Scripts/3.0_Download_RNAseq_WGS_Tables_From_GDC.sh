#!/bin/bash 
cat ../../Database/Cancer_Types.txt|\
perl -ane '
chomp;
next if /^\s*$/;
print "query genotype array tables for RNA-Seq and WGS of cancer type $_","\n";
`./3.0_Dwnld_RNASeq_WGS_Table_From_GDC.pl -c $_ -E RNA-Seq -d curl`;
`./3.0_Dwnld_RNASeq_WGS_Table_From_GDC.pl -c $_ -E WGS -d curl`;
'
