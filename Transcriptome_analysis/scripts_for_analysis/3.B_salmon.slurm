#!/bin/bash

## Note - Slurm script comments require two hash symbols (##).  A single
## hash symbol immediately followed by SBATCH indicates an SBATCH
## directive.  "##SBATCH" indicates the SBATCH command is commented
## out and is inactive.

## NTasks is not thread count, be sure to leave it set at 1
#SBATCH --ntasks=1

## If your program will be using less than 24 threads, or you
## require more than 24 threads, set cpus-per-task to the 
## desired threadcount.  Leave this commented out for the
## default 24 threads.
#SBATCH --cpus-per-task=24

## You will need to specify a minimum amount of memory in the
## following situaitons:
##   1. If you require more than 128GB of RAM, specify either:
##      a. "--mem=512000" for at least 512GB of RAM (6 possible nodes)
##      b. "--mem=1000000" for at least 1TB of RAM (2 possible nodes)
##   2. If you are running a job with less than 24 threads, you will
##      normally be given your thread count times 5.3GB in RAM.  So
##      a single thread would be given about 5GB of RAM.  If you
##      require more, please specify it as a "--mem=XXXX" option,
##      but avoid using all available RAM so others may share the node.
##SBATCH --mem=512000

## Normally jobs will restart automatically if the cluster experiences
## an unforeseen issue.  This may not be desired if you want to retain
## the work that's been performed by your script so far.   
## --no-requeue

## Normal Slurm options
## SBATCH -p shared
#SBATCH --job-name="salmon"
#SBATCH --output=salmon_orp.output

## Load the appropriate modules first.  Linuxbrew/colsa contains most
## programs, though some are contained within the anaconda/colsa
## module.  Refer to http://premise.sr.unh.edu for more info.
module purge
module load linuxbrew/colsa


## Instruct your program to make use of the number of desired threads.
## As your job will be allocated an entire node, this should normally
## be 24.

##format actinulae ORP reference transcriptome - make index 	
salmon index -t hydractinia_total.ORP.fasta-mod.fa -i hydractinia_orp_index --type quasi -k 31  



##map libraries
##STG_1_DP-17
salmon quant -p 8 --seqBias --gcBias -i hydractinia_orp_index -l a -1 ../ORP_prep/raw_larva_reads/STG_1_DP-17.R1.fastq.gz -2 ../ORP_prep/raw_larva_reads/STG_1_DP-17.R2.fastq.g -o STG_1_DP-17

##STG_1_DP-18
salmon quant -p 8 --seqBias --gcBias -i hydractinia_orp_index -l a -1 ../ORP_prep/raw_larva_reads/STG_1_DP-18.R1.fastq.gz -2 ../ORP_prep/raw_larva_reads/STG_1_DP-18.R2.fastq.gz -o STG_1_DP-18

##STG_1_DP-23
salmon quant -p 8 --seqBias --gcBias -i hydractinia_orp_index -l a -1 ../ORP_prep/raw_larva_reads/STG_1_DP-23.R1.fastq.gz -2 ../ORP_prep/raw_larva_reads/STG_1_DP-23.R2.fastq.gz -o STG_1_DP-23



##STG_2_DP-19 
salmon quant -p 8 --seqBias --gcBias -i hydractinia_orp_index -l a -1 ../ORP_prep/raw_larva_reads/STG_2_DP-19.R1.fastq.gz -2 ../ORP_prep/raw_larva_reads/STG_2_DP-19.R2.fastq.gz -o STG_2_DP-19

##STG_2_DP-20 
salmon quant -p 8 --seqBias --gcBias -i hydractinia_orp_index -l a -1 ../ORP_prep/raw_larva_reads/STG_2_DP-20.R1.fastq.gz -2 ../ORP_prep/raw_larva_reads/STG_2_DP-20.R2.fastq.gz -o STG_2_DP-20

##STG_2_DP-24
salmon quant -p 8 --seqBias --gcBias -i hydractinia_orp_index -l a -1 ../ORP_prep/raw_larva_reads/STG_2_DP-24.R1.fastq.gz -2 ../ORP_prep/raw_larva_reads/STG_2_DP-24.R2.fastq.gz -o STG_2_DP-24



##STG_3_DP-21
salmon quant -p 8 --seqBias --gcBias -i hydractinia_orp_index -l a -1 ../ORP_prep/raw_larva_reads/STG_3_DP-21.R1.fastq.gz -2 ../ORP_prep/raw_larva_reads/STG_3_DP-21.R2.fastq.gz -o STG_3_DP-21

##STG_3_DP-25
salmon quant -p 8 --seqBias --gcBias -i hydractinia_orp_index -l a -1 ../ORP_prep/raw_larva_reads/STG_3_DP-25.R1.fastq.gz -2 ../ORP_prep/raw_larva_reads/STG_3_DP-25.R2.fastq.gz -o STG_3_DP-25

##STG_3_DP-26
salmon quant -p 8 --seqBias --gcBias -i hydractinia_orp_index -l a -1 ../ORP_prep/raw_larva_reads/STG_3_DP-26.R1.fastq.gz -2 ../ORP_prep/raw_larva_reads/STG_3_DP-26.R2.fastq.gz -o STG_3_DP-26



##STG_4_DP-22
salmon quant -p 8 --seqBias --gcBias -i hydractinia_orp_index -l a -1 ../ORP_prep/raw_larva_reads/STG_4_DP-22.R1.fastq.gz -2 ../ORP_prep/raw_larva_reads/STG_4_DP-22.R2.fastq.gz -o STG_4_DP-22

##STG_4_DP-27 
salmon quant -p 8 --seqBias --gcBias -i hydractinia_orp_index -l a -1 ../ORP_prep/raw_larva_reads/STG_4_DP-27.R1.fastq.gz -2 ../ORP_prep/raw_larva_reads/STG_4_DP-27.R2.fastq.gz -o STG_4_DP-27

##STG_4_DP-28
salmon quant -p 8 --seqBias --gcBias -i hydractinia_orp_index -l a -1 ../ORP_prep/raw_larva_reads/STG_4_DP-28.R1.fastq.gz -2 ../ORP_prep/raw_larva_reads/STG_4_DP-28.R2.fastq.gz -o STG_4_DP-28


