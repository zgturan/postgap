#!/bin/bash

mkdir -p blocks
mkdir -p outfiles_blocks
mkdir -p errfiles_blocks 
mkdir -p result_blocks 
mkdir -p heatmap_blocks
mkdir -p GWAS_lambdas_blocks
mkdir -p eQTL_lambdas_blocks
mkdir -p prepped_clusters_blocks

mkdir -p databases
cd databases

# GWAS databases
wget https://storage.googleapis.com/postgap-data/GWAS_DB.txt
wget https://storage.googleapis.com/postgap-data/GRASP.txt
wget https://storage.googleapis.com/postgap-data/Phewas_Catalog.txt
wget https://storage.googleapis.com/postgap-data/postgap_input.nealeUKB_20170915.clumped.1Mb.tsv -O Neale_UKB.txt


# Cisregulatory databases
wget https://storage.googleapis.com/postgap-data/Fantom5.bed.gz
wget https://storage.googleapis.com/postgap-data/Fantom5.bed.gz.tbi
wget https://storage.googleapis.com/postgap-data/Fantom5.fdrs
wget https://storage.googleapis.com/postgap-data/DHS.bed.gz
wget https://storage.googleapis.com/postgap-data/DHS.bed.gz.tbi
wget https://storage.googleapis.com/postgap-data/DHS.fdrs
wget https://storage.googleapis.com/postgap-data/Ensembl_TSSs.bed.gz
wget https://storage.googleapis.com/postgap-data/Ensembl_TSSs.bed.gz.tbi
wget https://storage.googleapis.com/postgap-data/Regulome.bed.gz
wget https://storage.googleapis.com/postgap-data/Regulome.bed.gz.tbi
wget https://storage.googleapis.com/postgap-data/pchic.bed.gz
wget https://storage.googleapis.com/postgap-data/pchic.bed.gz.tbi
wget https://storage.googleapis.com/postgap-data/GERP.bw

# Regulatory databases
wget ftp://ftp.ncbi.nlm.nih.gov/pub/snpdelscore/rawdata/CATO_Average.vcf.gz
gunzip CATO_Average.vcf.gz
Rscript ../vcftobed.R

# Jeme-ENCODE+Roadmap
mkdir Jeme_ENCODE
cd Jeme_ENCODE
IFS=","
for i in `cat ../../Jeme_ENCODE.txt`
do
echo $i
wget http://yiplab.cse.cuhk.edu.hk/jeme/"$i"
done
Rscript ../../jeme_encode_csvtobed.R
cd ../


# Jeme-FANTOM5
mkdir Jeme_FANTOM5
cd Jeme_FANTOM5
IFS=","
for i in `cat ../../Jeme_FANTOM5.txt`
do
echo $i
wget  http://yiplab.cse.cuhk.edu.hk/jeme/"$i"
done
Rscript ../../jeme_fantom5_csvtobed.R
cd ../


# DNase1
mkdir DNase1
cd DNase1
IFS=","
for i in `cat ../../DNase1.txt`
do
echo $i
wget -nd -r -P ./ -A .bb ftp://ftp.ensembl.org/pub/grch37/current/regulation/homo_sapiens/Peaks/"$i"/DNase1/
done
export PATH=$PATH:../../bigBedToBed/bigBedToBed
for filename in *
do 
../../bigBedToBed/bigBedToBed ${filename} ${filename}.bed
egrep "^chr[0-9]" ${filename}.bed > ${filename}.bed2
sort -k1,1V -k2,2n ${filename}.bed2 > ${filename}.bed3
done
rm *bb.bed *bb.bed2
rename 'homo_sapiens.GRCh37.' '' *.bb.bed3
rename '.DNase1.SWEmbl_R0025.peaks.20180925' '' *.bb.bed3
rename '.DNase1.SWEmbl_R0005.peaks.20180925' '' *.bb.bed3
Rscript ../../DNase1.R
cd ../


# deltaSVM
mkdir deltaSVM
cd deltaSVM
IFS=","
for i in `cat ../../deltaSVM.txt`
do
echo $i
wget ftp://ftp.ncbi.nlm.nih.gov/pub/snpdelscore/rawdata/"$i"
done
gunzip *
Rscript ../../vcftobed.R
cd ../

#DeepSEA
mkdir DeepSEA
cd DeepSEA
IFS=","
for i in `cat ../../DeepSEA.txt`
do
echo $i
wget  ftp://ftp.ncbi.nlm.nih.gov/pub/snpdelscore/rawdata/"$i"
done
gunzip *
Rscript ../../vcftobed.R
cd ../

#CAPE_dsQTL
IFS=","
mkdir CAPE_dsQTL
cd CAPE_dsQTL
for i in `cat ../../CAPE_dsQTL.txt`
do
echo $i
wget ftp://ftp.ncbi.nlm.nih.gov/pub/snpdelscore/rawdata/"$i"
done
gunzip *
Rscript ../../vcftobed.R
cd ../

#CAPE_eQTL
mkdir CAPE_eQTL
cd CAPE_eQTL
IFS=","
for i in `cat ../../CAPE_eQTL.txt`
do
echo $i
wget ftp://ftp.ncbi.nlm.nih.gov/pub/snpdelscore/rawdata/"$i"
done
gunzip *
Rscript ../../vcftobed.R
cd ../


# Population structure data
mkdir 1000Genomes
cd 1000Genomes

mkdir EUR
cd EUR

wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr1.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr1.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr10.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr10.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr11.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr11.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr12.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr12.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr13.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr13.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr14.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr14.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr15.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr15.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr16.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr16.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr17.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr17.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr18.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr18.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr19.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr19.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr2.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr2.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr20.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr20.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr21.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr21.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr3.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr3.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr4.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr4.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr5.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr5.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr6.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr6.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr7.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr7.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr8.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr8.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr9.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf
wget https://storage.googleapis.com/postgap-data/1000Genomes/EUR/ALL.chr9.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf.csi

cd ..

cd ..

cd ..
