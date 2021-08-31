cat ../../Database/Cancer_Types.txt|\
perl -ane '
chomp;
next if /^\s*$/;
print "query genotype array tables for cancer type $_","\n";
#`./0_Download_SNPArray_Table_From_GDC.pl -c $_ -a Genotypes`;
`./0_Download_SNPArray_Table_From_GDC.pl -c $_ -a "Copy number estimate"`;
'
