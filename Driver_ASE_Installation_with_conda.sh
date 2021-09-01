#!/bin/bash
if [ "$#" -gt 1 ]; then
 echo ""
 echo "Usage: Install_DriverASE_and_its_Dependencies.sh Dir4InstallationFullpath (default is current directory)"
 echo "";
 exit 0;
fi

dir=`pwd`;
if [ "$#" -eq 1 ]; then 
 dir=$1;
fi

#cd /media/zhongshan/LargeSeagateNew/Driver_ASE/Driver-ASE-master/Driver-ASE-master
cd $dir
echo "Going to download conda and install it in the dir:";
echo "$dir";
#wget https://repo.anaconda.com/miniconda/Miniconda3-py37_4.10.3-Linux-x86_64.sh --no-check-certificate -O miniconda.sh
wget https://repo.anaconda.com/miniconda/Miniconda-2.2.2-Linux-x86_64.sh --no-check-certificate -O miniconda.sh
rm -rf $dir/miniconda
bash miniconda.sh -b -p $dir/miniconda
#add alias of conda to ~/.bashrc
#echo "alias conda=$dir/miniconda/bin/conda" >>~/.bashrc
#source ~/.bashrc

#setup channels for conda;
$dir/miniconda/bin/conda config --add channels defaults
$dir/miniconda/bin/conda config --add channels bioconda
$dir/miniconda/bin/conda config --add channels conda-forge

$dir/miniconda/bin/conda create -n driverase --yes

#conda activate driverase
$dir/miniconda/bin/conda install make --yes
$dir/miniconda/bin/conda install curl --yes
$dir/miniconda/bin/conda install perl --yes
$dir/miniconda/bin/conda install -c conda-forge c-compiler  --yes

#install perl modules silently via cpan
#export PERL_MM_USE_DEFAULT=1
#cpan install File::Which
#If this failed, try cpanm
#conda install -c bioconda perl-app-cpanminus 
#Not necessary, just install it via conda
$dir/miniconda/bin/conda install -c bioconda perl-file-which --yes

$dir/miniconda/bin/conda install git --yes
$dir/miniconda/bin/conda install impute2 --yes
$dir/miniconda/bin/conda install -c dranew shapeit --yes
$dir/miniconda/bin/conda install -c bioconda plink --yes
$dir/miniconda/bin/conda install -c bioconda varscan --yes

$dir/miniconda/bin/conda install bedtools --yes
$dir/miniconda/bin/conda install -c bioconda perl-mce --yes
$dir/miniconda/bin/conda install -c bioconda perl-lwp-simple  --yes
$dir/miniconda/bin/conda install -c bioconda perl-math-cdf --yes
$dir/miniconda/bin/conda install -c bioconda samtools --yes

#conda install -c bioconda bioconductor-gsva --yes

#install matlab run time in linux silently
mkdir MCR
cd MCR

#for linux
wget --no-check-certificate https://ssd.mathworks.com/supportfiles/downloads/R2015b/deployment_files/R2015b/installers/glnxa64/MCR_R2015b_glnxa64_installer.zip
unzip MCR_R2015b_glnxa64_installer.zip
rm MCR_R2015b_glnxa64_installer.zip

#for Mac
#wget https://ssd.mathworks.com/supportfiles/downloads/R2015b/deployment_files/R2015b/installers/maci64/MCR_R2015b_maci64_installer.zip
#unzip MCR_R2015b_maci64_installer.zip
#Note: only mac matlab compiled executable file can be run successfully with matlab MCR for Mac;

#if install MCR in Mac, need to run the following code to allow it install in Mac;
#sudo spctl --master-disable
./install -mode silent -agreeToLicense yes -destinationFolder `pwd`
#For different linux systems, including Centos and Ubuntu, Linux version of matlab compiled executable file
#can run it successfully.
#Once built MCR v90 in Linux system, it can be copied to anywhere in the same system;
#This would be very handy, as it only needs to be built once in docker linux system
#and can be copied into a dir for the driver-ase pipeline running within docker!

#add the following into ~/.bashrc
#update the $pwd with the right one;
cwd=`pwd`;
echo "Putting the following into your ~/.bashrc file";
echo "export LD_LIBRARY_PATH=$cwd/v90/runtime/glnxa64:$cwd/v90/bin/glnxa64:$cwd/v90/sys/os/glnxa64:$cwd/v90/sys/opengl/lib/glnxa64
XAPPLRESDIR=$cwd/v90/X11/app-defaults
"
echo "export LD_LIBRARY_PATH=$cwd/v90/runtime/glnxa64:$cwd/v90/bin/glnxa64:$cwd/v90/sys/os/glnxa64:$cwd/v90/sys/opengl/lib/glnxa64
XAPPLRESDIR=$cwd/v90/X11/app-defaults
" >>~/.bashrc
source ~/.bashrc
echo "The global var LD_LIBRARY_PATH is $LD_LIBRARY_PATH"

cd $dir
echo "Going to install Driver-ASE...."
#download Driver-ASE from github
git clone https://github.com/michaelcvermeulen/driver-ase.git
mv driver-ase Driver_ASE
echo "Uncompress Matlab testing data for Driver-ASE"
unzip Driver_ASE/Driver_ASE_MatLab/MatLab_Analysis.zip 
mv MatLab_Analysis Driver_ASE/Driver_ASE_MatLab/ 
chmod a+x Driver_ASE/Driver_ASE_MatLab/Driver_ASE_MatLab_Lib/Driver_ASE_MatLab_Scripts/M1_Import_ASE_and_Mutation_data

###############################################################################################
mkdir -p Driver_ASE/Database
cd Driver_ASE/Database

echo "Going to install 1000 Genome Project reference datasets from Shapeit2 and Impute2...."
#Download 1000 Genome Project reference haplotype files;
#https://mathgen.stats.ox.ac.uk/impute/1000GP_Phase3.html
#wget https://mathgen.stats.ox.ac.uk/impute/1000GP_Phase3.tgz
#wget https://mathgen.stats.ox.ac.uk/impute/1000GP_Phase3_chrX.tgz

#Download shapeit2 phased 1000 Genome Project reference files;
#https://mathgen.stats.ox.ac.uk/impute/data_download_1000G_phase1_integrated_SHAPEIT2_16-06-14.html
#wget https://mathgen.stats.ox.ac.uk/impute/ALL.integrated_phase1_S#HAPEIT_16-06-14.nomono.tgz
#singleton removed
#https://mathgen.stats.ox.ac.uk/impute/ALL.integrated_phase1_SHAPEIT_16-06-14.nosing.tgz


# a potential bug for cpanm, which will modify the bashrc and prevent 
# perl to find the installed packages;
# thus, the following lines need to be comment in the file ~/.bashrc.
#This will affect the accessiblities of perl packages installed;
#PATH="/home/zhongshan/perl5/bin${PATH:+:${PATH}}"; export PATH;
#PERL5LIB="/home/zhongshan/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
#PERL_LOCAL_LIB_ROOT="/home/zhongshan/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
#PERL_MB_OPT="--install_base \"/home/zhongshan/perl5\""; export PERL_MB_OPT;
#PERL_MM_OPT="INSTALL_BASE=/home/zhongshan/perl5"; export PERL_MM_OPT;


