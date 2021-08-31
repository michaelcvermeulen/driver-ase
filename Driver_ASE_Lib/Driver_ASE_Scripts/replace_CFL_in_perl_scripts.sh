ls *.pl *.pm|perl -ane '
chomp;
print STDERR "processing file: $_\n";
`ReplaceStringInFile.pl $_ "\r" "" 0 0`;
'
