#!/usr/bin/env perl

#####!/usr/bin/perl -w

use MCE::Map;
use FindBin qw($Bin);
use lib "$Bin/..";
use Parsing_Routines;
use Imputation_Plink;
use Cwd 'realpath';
use Cwd 'abs_path';
use Getopt::Long;
use strict;
use autodie;
no warnings 'once';

my $time = localtime;
print "\nScript started: $time.\n\n";

#Changes to the directory of the script executing;
chdir $Bin;

my $parsing = Driver_ASE_Lib::Parsing_Routines->new;
#my $impute_plink = Driver_ASE_Lib::Imputation_Plink->new;

GetOptions(
    'cancer|c=s' => \my $cancer_type, #e.g. OV
    'plink|p=s' => \my $plink, #path to plink
    'PlinkBinaryBed|b=s' => \my $plink_bed, #path to plink binary bed format data, only .bed is needed and assume .bim and .fam locatd in the same dir
    'help|h' => \my $help
) or die "Incorrect options!\n",$parsing->usage("1.1");

if ($help)
{
    $parsing->usage("1.1.1");
}

if (!defined $cancer_type)
{
    print STDERR "Cancer type was not entered!\n";
    $parsing->usage("1.1.1");
}

if (!defined $plink_bed){
   print STDERR "No plink  binary bed was provided\n";
   $parsing->usage("1.1.1");

}

my ($bed_prefix)=$plink_bed=~/(.*)\.bed$/;
    $bed_prefix=abs_path($bed_prefix);

if (defined $plink_bed)
{
    if (!-f "$plink_bed" || ! -f "$bed_prefix.bim" || ! -f "$bed_prefix.fam")
    {  
       my $tag=0;
       foreach my $x (qw(.bim .fam .bed)){
       unless (-f "$bed_prefix$x"){
	print STDERR "No plink file:\n$bed_prefix$x\n";
        $tag++;
        }
    }
	$parsing->usage("1.1") if $tag>0;
    }
}

if (!defined $plink)
{
    $plink = "plink";
}

$parsing->CheckSoftware("$plink");

my $Driver_ASE_Dir = realpath("../../");
my $Analysispath = realpath("../../Analysis");
my $RNA_Path = "$Analysispath/$cancer_type/RNA_Seq_Analysis";

my $map_dir = "maps";
my $ped_dir = "peds";
my $database_path = "$Driver_ASE_Dir/Database";

$parsing->check_directory_existence("$database_path","$Analysispath","$Analysispath/$cancer_type","$RNA_Path"); #check if directories or files exist
$parsing->check_cancer_type($database_path,$cancer_type); #checks if the cancer type entered is valid

chdir "$RNA_Path";
mkdir "peds" unless (-d "peds");
mkdir "maps" unless (-d "maps");

print "Making ped files.\n";

#Split Bed into peds and move them into the dir peds
my @chrs=(1..23);
my @plink_cmds;
while (my $chr=<@chrs>)
{   
   #Only use snps with MAF >= 0.01 for downstream phasing and imputaiton;
   #get duplicated vars and remove them;
   #The plink command --list-duplicate-vars will only rely on id to remove dups,
   #but it is actually these duplicated positions on each chr should be removed to avoid of failure in phasing process in running shapeit;
   #my $cmd="$plink --bfile $bed_prefix --list-duplicate-vars \'ids-only\' \'suppress-first\' --out Removed.$chr;$plink --bfile $bed_prefix --chr $chr -maf 0.01 --exclude Removed.$chr.dupvar --recode --out $RNA_Path/$ped_dir/$chr;rm Removed.$chr.dupvar";
   my $cmd="$plink --bfile $bed_prefix --list-duplicate-vars \'suppress-first\' --out Removed.$chr;
$plink --bfile $bed_prefix --chr $chr --geno 0.1 -maf 0.01 --mind 0.01 --exclude Removed.$chr.dupvar --recode --out $RNA_Path/$ped_dir/$chr;
sort -u -k4,4 $RNA_Path/$ped_dir/$chr.map\|perl -ane \'print \$F[1],\"\\n\";\' >Kept.$chr.var;
$plink --bfile $bed_prefix --chr $chr --geno 0.1 -maf 0.01 --mind 0.1 --extract Kept.$chr.var --recode --out $RNA_Path/$ped_dir/$chr;
rm Removed.$chr.* Kept.$chr.var";
  push @plink_cmds,$cmd;

}

mce_map
{   print STDERR "\nGoing to run the plink cmd:\n$plink_cmds[$_]\n";
    system("$plink_cmds[$_]");
}0..$#plink_cmds;

`mv $ped_dir/*.map $map_dir/`;
system("find $RNA_Path/$ped_dir -type f -name \"*.log\" -o -name \"Removed*\" 2>/dev/null |xargs rm -rf");
#`rm -f $ped_dir/*.log`;

print "All Jobs have finished for $cancer_type.\n",
      "ped and maps are saved into the dir:\n$RNA_Path/$ped_dir\n$RNA_Path/$map_dir\n";

$time = localtime;
print "Script finished: $time.\n";

exit;
