#!/bin/bash
if [ "$#" -lt 1 ]; then
 echo ""
 echo "Usage: Driver_ASE_Installation_with_conda.sh 
(1) Dir4InstallationFullpath (enter \".\" to install in current directory)
(2) Force (force installation: default is \"0\", enter \"1\" to force installation)
Note: wget needs to be installed for running this shell script to download data!"
 echo "";
 exit 0;
fi

force2install=0;

if [ "$#" -ge 1 ]; then 
 dir=$1;
 force2install=$2;
fi

#check whether conda is available;
if [ -x "$(command -v conda)" ]; then
   driverase_env=`conda info --envs|grep driverase|perl -ane 'print 1 if /^driverase/'`;
   if ! [ "$driverase_env" == "1" ]; then
      echo "You system have conda installed but no driverase environment,"
      echo "and we will use conda directly to create driverase environment!"
      conda create -n driverase --yes
      echo "conda driverase environment has been created,"
      echo "but we need to exit the shell script to activate it first!"
      echo ""
      echo "Please rerun the following command after exit this shell script:"
      echo "conda activate driverase"
      echo "bash $0 $dir"
      echo ""
      exit 0
    elif [[ ! -d "$dir/Driver_ASE" || "$force2install" -eq 1 ]]; then 
     if [ "$force2install" -eq 0 ]; then 
      echo "The conda driverase environment exists,"
      echo "but the Drive_ASE and its dependencies are not installed!"
      echo ""
      echo "Now we will exit the shell script first and activate driverase environment,"
      echo "and then start installing all dependencies and databases by running the following command:"
      echo "conda activate driverase"
      echo "bash $0 $dir 1"
      echo ""
      exit 0;
     else
      echo "The conda driverase environment exists, and we will force to install Driver-ASE and its dependencies and databases!";
      #conda deactivate; 
      #conda activate driverase; exit 0;
     fi
      
    else
      echo ""
      echo "We found you have the conda driverase environment and $dir/Driver_ASE installed."
      echo "The shell script will not install it again!"
      echo ""
      echo "If you want to install Driver_ASE again, there would be two ways to force install it:"
      echo ""
      echo "(1) please delete the dir Driver_ASE and rerun the shell script with the command:"
      echo "    conda activate driverase";
      echo "    bash $0 $dir 1";
      echo ""
      echo "(2) Alternatively, please delete driverase environment via the command:"
      echo "    conda remove --name driverase --all"
      echo "    You can rerun the above shell script again!"
      echo ""
      exit 0
    fi
else
     echo "There is no conda installed in your system. We will install it in the dir: $dir";
     cd $dir
     echo "Going to download miniconda and install it in the dir:";
     echo "$dir";
     wget https://repo.anaconda.com/miniconda/Miniconda3-py37_4.10.3-Linux-x86_64.sh --no-check-certificate -O miniconda.sh
     #wget https://repo.anaconda.com/miniconda/Miniconda-2.2.2-Linux-x86_64.sh --no-check-certificate -O miniconda.sh
     rm -rf $dir/miniconda
     bash miniconda.sh -b -p $dir/miniconda
     $dir/miniconda/bin/conda create -n driverase --yes
     $dir/miniconda/bin/conda init bash
     echo "conda has been installed and the conda environment driverase is also created!"
     echo "but we need to exit the terminal and rerun the shell script to initiate conda" 
     echo "for the installation of all dependencies in the driverase conda environment!"
     echo ""
     echo "Please CLOSE the Linux terminal and open a new termine to rerun the following commands:"
     echo "conda activate driverase"
     echo "bash $0 $dir"
     echo ""
     exit 0
fi

#get fullpath for the installation directory

cd $dir
dir=`pwd`;
echo "";
echo "You installation directory is:"
echo "$dir";
echo "";


#setup channels for conda;
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

echo ""

#conda activate driverase
if [ "$(conda list|perl -0 -ane '(/^make/m)? (print 1):(print 0)')" -ne 1 ]; then
conda install make --yes
else
echo "No need to install make in conda, as it is there!";
echo "";
fi
if [ "$(conda list|perl -0 -ane '(/^curl/m)? (print 1):(print 0)')" -ne 1 ]; then
conda install curl --yes
else
echo "No need to install curl in conda, as it is there!";
echo "";
fi

if [ "$(conda list|perl -0 -ane '(/^c-compiler/m)? (print 1):(print 0)')" -ne 1 ]; then
conda install -c conda-forge c-compiler  --yes
else
echo "No need to install c-compiler in conda, as it is there!";
echo "";
fi

if [ "$(conda list|perl -0 -ane '(/^perl-file-which/m)? (print 1):(print 0)')" -ne 1 ]; then
conda install -c bioconda perl-file-which --yes
else
echo "No need to install perl-file-which in conda, as it is there!";
echo "";
fi

if [ "$(conda list|perl -0 -ane '(/^git/m)? (print 1):(print 0)')" -ne 1 ]; then
conda install git --yes
else
echo "No need to install git in conda, as it is there!";
echo "";
fi

if [ "$(conda list|perl -0 -ane '(/^impute2/m)? (print 1):(print 0)')" -ne 1 ]; then
conda install impute2 --yes
else
echo "No need to install impute2 in conda, as it is there!";
echo "";
fi

if [ "$(conda list|perl -0 -ane '(/^shapeit/m)? (print 1):(print 0)')" -ne 1 ]; then
conda install -c dranew shapeit --yes
else
echo "No need to install shapeit in conda, as it is there!";
echo "";
fi

if [ "$(conda list|perl -0 -ane '(/^plink/m)? (print 1):(print 0)')" -ne 1 ]; then
conda install -c bioconda plink --yes
else
echo "No need to install plink in conda, as it is there!";
echo "";
fi

if [ "$(conda list|perl -0 -ane '(/^varscan/m)? (print 1):(print 0)')" -ne 1 ]; then
conda install -c bioconda varscan --yes
else
echo "No need to install varscan in conda, as it is there!";
echo "";
fi

if [ "$(conda list|perl -0 -ane '(/^bedtools/m)? (print 1):(print 0)')" -ne 1 ]; then
conda install bedtools --yes
else
echo "No need to install bedtools in conda, as it is there!";
echo "";
fi

if [ "$(conda list|perl -0 -ane '(/^perl-mce/m)? (print 1):(print 0)')" -ne 1 ]; then
conda install -c bioconda perl-mce --yes
else
echo "No need to install perl-mce in conda, as it is there!";
echo "";
fi

if [ "$(conda list|perl -0 -ane '(/^perl-lwp-simple/m)? (print 1):(print 0)')" -ne 1 ]; then
conda install -c bioconda perl-lwp-simple  --yes
else
echo "No need to install perl-lwp-simple in conda, as it is there!";
echo "";
fi

if [ "$(conda list|perl -0 -ane '(/^perl-math-cdf/m)? (print 1):(print 0)')" -ne 1 ]; then
conda install -c bioconda perl-math-cdf --yes
else
echo "No need to install perl-match-cdf in conda, as it is there!";
echo "";
fi

if [ "$(conda list|perl -0 -ane '(/^samtools/m)? (print 1):(print 0)')" -ne 1 ]; then
conda install -c bioconda samtools --yes
else
echo "No need to install samtools in conda, as it is there!";
echo "";
fi

if [ "$(conda list|perl -0 -ane '(/^ucsc-overlapselect/m)? (print 1):(print 0)')" -ne 1 ]; then
conda install -c bioconda ucsc-overlapselect --yes
else
echo "No need to install ucsc-overlapselect in conda, as it is there!";
echo "";
fi



#install matlab run time in linux silently

if [ ! -d "MCR" ]; then
mkdir MCR
fi

cd MCR

if [ ! -d "v90" ]; then
#for linux
wget --no-check-certificate https://ssd.mathworks.com/supportfiles/downloads/R2015b/deployment_files/R2015b/installers/glnxa64/MCR_R2015b_glnxa64_installer.zip
unzip MCR_R2015b_glnxa64_installer.zip
rm -rf MCR_R2015b_glnxa64_installer.zip

#for Mac
#wget https://ssd.mathworks.com/supportfiles/downloads/R2015b/deployment_files/R2015b/installers/maci64/MCR_R2015b_maci64_installer.zip
#unzip MCR_R2015b_maci64_installer.zip
#Note: only mac matlab compiled executable file can be run successfully with matlab MCR for Mac;

#if install MCR in Mac, need to run the following code to allow it to be installed successfully;
#sudo spctl --master-disable

cwd=`pwd`;

./install -mode silent -agreeToLicense yes -destinationFolder `pwd`

#For different linux systems, including CentOS and Ubuntu, Linux version of matlab compiled executable file
#can run it successfully.
#Once built MCR v90 in Linux system, it can be copied to anywhere in the same system;
#This would be very handy, as it only needs to be built once in docker linux system
#and can be copied into a dir for the driver-ase pipeline running within docker!

#add the MCR environmental vars into ~/.bashrc
echo "Going to check whether in the ~/.bashrc there is previously added MATLAB runtime environmental vars....";

chk_matlab_runtime=`perl -ane '
$tag=0;
$tag=1 if (/v90.runtim/i and /v90.sys.os/i and /v90.bin/i and /v90.sys.opengl/i);
print $tag and exit if $tag==1' < ~/.bashrc`;

#update the $pwd with the right one;
if [ "$chk_matlab_runtime" -eq 1 ]; then
 echo "No previous MATLAB runtime environmental vars in your bashrc!"
 echo "We will add LD_LIBRARY_PATH for your MATLAB runtime now....";
 echo "Putting the following into your ~/.bashrc file";
 echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$cwd/v90/runtime/glnxa64:$cwd/v90/bin/glnxa64:$cwd/v90/sys/os/glnxa64:$cwd/v90/sys/opengl/lib/glnxa64
XAPPLRESDIR=$cwd/v90/X11/app-defaults
"
 echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$cwd/v90/runtime/glnxa64:$cwd/v90/bin/glnxa64:$cwd/v90/sys/os/glnxa64:$cwd/v90/sys/opengl/lib/glnxa64
XAPPLRESDIR=$cwd/v90/X11/app-defaults
" >>~/.bashrc
 source ~/.bashrc
 echo "The global var LD_LIBRARY_PATH is $LD_LIBRARY_PATH"

else
 echo "In the ~/.bashrc file, there is MATLAB runtime vars, which is as follows:";
 echo "$LD_LIBRARY_PATH"
 echo "We will not add current MATLAB runtime path again!";
 echo "Current MATLAB runtime path is:";
 echo "$cwd/v90/runtime/glnxa64:$cwd/v90/bin/glnxa64:$cwd/v90/sys/os/glnxa64:$cwd/v90/sys/opengl/lib/glnxa64"
fi

echo "Removing unnecessary data after completing the installation of MATLAB runtime v90....";
#ls |grep v90 -v|xargs rm -rf
#It would be more safer to remove these files or directory specifically!
rm -rf java bin archieves install MCR_license.txt  productdata sys;

else

echo "No need to install MATLAB runtime v90, since it was found in the directory:"
echo "$cwd";

fi


cd $dir

if [ ! -d "Driver_ASE" ]; then
echo ""
echo "Going to install Driver-ASE in the directory $dir ...."
#download Driver-ASE from github
git clone https://github.com/michaelcvermeulen/driver-ase.git
mv driver-ase Driver_ASE
echo "Uncompress Matlab testing data for Driver-ASE"
unzip Driver_ASE/Driver_ASE_MatLab/MatLab_Analysis.zip 
rm -rf Driver_ASE/Driver_ASE_MatLab/MatLab_Analysis.zip
mv MatLab_Analysis Driver_ASE/Driver_ASE_MatLab/ 
chmod a+x Driver_ASE/Driver_ASE_MatLab/Driver_ASE_MatLab_Lib/Driver_ASE_MatLab_Scripts/M1_Import_ASE_and_Mutation_data
chmod a+x Driver_ASE/Driver_ASE_Lib/Driver_ASE_Scripts/*
cd Driver_ASE
mkdir Analysis
cd Analysis
mv ../sample_tables_for_33_cancer_types.tgz
echo "Uncompress the predownloaded tables for 33 cancer types"
tar -zxvf sample_tables_for_33_cancer_types.tgz 
rm -rf sample_tables_for_33_cancer_types.tgz
cd ../..
echo "Completed the downloading of Driver-ASE scripts from github"
echo ""
else
echo ""
echo "No need to install Driver-ASE, as it is there!"
echo ""
fi

################################################################################################
if [ ! -d "Driver_ASE/Database" ]; then
mkdir -p Driver_ASE/Database
fi

cd Driver_ASE/Database

if [ ! -d "reg" ]; then
echo "Start to download Driver-ASE required 1000 Genome Project databases for shapeit2 and impute2"
echo "Going to download partial Driver-ASE database first from https://data.mendeley.com/datasets/8x3y5swppw/5";
wget https://md-datasets-public-files-prod.s3.eu-west-1.amazonaws.com/3987fd82-d0b9-4547-bfd1-2f3591112929 -O Database.tgz
tar -xzvf Database.tgz
rm -rf Database.tgz 
else
echo "No need to download the partial Driver-ASE database from Mendeley, as it was there!";
echo "";
fi


if [ ! -d "1000GP_Phase3" ]; then
echo "Going to install 1000 Genome Project reference datasets for Impute2...."
Download 1000 Genome Project reference haplotype files;
https://mathgen.stats.ox.ac.uk/impute/1000GP_Phase3.html
wget https://mathgen.stats.ox.ac.uk/impute/1000GP_Phase3.tgz -O 1000GP_Phase3.tgz
tar -xzvf 1000GP_Phase3.tgz
rm -rf 1000GP_Phase3.tgz
wget https://mathgen.stats.ox.ac.uk/impute/1000GP_Phase3_chrX.tgz -O 1000GP_Phase3_chrX.tgz
tar -xzvf 1000GP_Phase3_chrX.tgz
rm -rf 1000GP_Phase3_chrX.tgz
mv genetic_map* *hap.gz *legend.gz 1000GP_Phase3
else
echo "No need to downlad the impute2 datasets, as it was there already!"
echo "";
fi

if [ ! -d "ALL.integrated_phase1_SHAPEIT_16-06-14.nomono" ]; then
echo "Going to download shapeit2 reference files"
#Download shapeit2 phased 1000 Genome Project reference files;
#https://mathgen.stats.ox.ac.uk/impute/data_download_1000G_phase1_integrated_SHAPEIT2_16-06-14.html
wget https://mathgen.stats.ox.ac.uk/impute/ALL.integrated_phase1_SHAPEIT_16-06-14.nomono.tgz -O ALL.integrated_phase1_SHAPEIT_16-06-14.nomono.tgz
#singleton removed
#https://mathgen.stats.ox.ac.uk/impute/ALL.integrated_phase1_SHAPEIT_16-06-14.nosing.tgz
tar -xzvf ALL.integrated_phase1_SHAPEIT_16-06-14.nomono.tgz
else
echo "No need to download shapeit datasets, as it was there already!"
echo "";
fi


cd ../Driver_ASE_Lib/Driver_ASE_Scripts
if [ ! -d "Pipeline2MapMuts2DiffRegulatoryRegions" ]; then
echo "";
echo "Download a pipeline to map user input mutations data for Driver-ASE....";
wget https://md-datasets-public-files-prod.s3.eu-west-1.amazonaws.com/5c40a59c-bb44-4d90-b3e6-8d202143e981 -O Pipeline2MapMuts2DiffRegulatoryRegions.zip
unzip Pipeline2MapMuts2DiffRegulatoryRegions.zip
rm -rf Pipeline2MapMuts2DiffRegulatoryRegions.zip
else
echo "No need to download Pipeline2MapMuts2DiffRegulatoryRegions.zip, as it was there already!"
echo "";
fi

cwd=`pwd`;

echo "" 
echo "You have successfully installed Driver-ASE and its dependencies and databases via conda!"
echo ""
echo "Please go into the directory containing all perl and shell scripts of Driver-ASE:"
echo ""
echo "$cwd";
echo "";
echo "Before testing any of these scripts, please ensure conda driverase environment is activated by running the following command in bash:"
echo ""
echo "conda activate driverase"
echo "cd $cwd"
echo ""
