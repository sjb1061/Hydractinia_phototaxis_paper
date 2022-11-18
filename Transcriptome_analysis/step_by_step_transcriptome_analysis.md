# Step by Step Methods of Hydractinia Planula Transcriptome Analysis and Outputs

This file is the step by step instructions of our Transcriptome analysis. You will find the scripts used and an explanation of what they do as well as outputs. I am following the Transcriptome workflow we previously developed, which can be found in my Actinula_paper repository.  

### 1. Prep Reads for Transcriptome Assembly
   We sequenced planulae larvae over 4 developmental days: Day 1, Day 2, Day 3 (when known to be phototactic), and Day 4. We have 3 replicates for each of the 4 developmental Days (we will call stages here). The first step of our developmental transcriptome assembly is to prepare our reads for assembling a reference transcriptome. Here in this step you can either run the full cohesive script: 1_Full_Ref_Transcriptome_prep.py or run it as 2 scripts (1_steps_1-3a_v3.py and 1_steps_3b-4b.py) but with running it as 2 scripts you have to hardcode a collection in the second script (I would recommend running just the cohesive script which is what I demonstrate below).   
   
   **The goal of 1_Full_Ref_Transcriptome_prep.py** is to identify the highest quality replicate for each of the 6 stages and then concatenate the high-quality reps into representitive R1 and R2 files to be used in the assembly. The way this script identifies high-quality reps is by running FastQC on each R1 and R2 file for all reps in all stages and then calculating the following basic stats from the FastQC data:  
   
  1. ID the number of nucleotides: num_nucs = Number of Sequences * Read Length.  
  2. ID Normalized Quality: norm_qual = (Quality (the avg of means from FastQC file) - total min across all files)/(total max - total min).  
  3. Calculate Final Score: final_score = num_nucs * norm_qual.   

   The script then compares each of the final scores within each stage and then concatenates the 6 highest quality reads (1 from each stage) into a total_R1.fastq.gz and total_R2.fastq.gz (the output files). The script will also report the time it took to run the full script and a FastQC dir with all the FastQC results (note: the FastQC step will take the longest). 
   
   To run this script you will need to organize your directory as such:   
    `mkdir ORP_Prep`.  
    `mkdir ORP_Prep/raw_larva_reads`.    
    
   Within raw_larva_reads dir you should have subdirectories for each sample. Rename your subdirs with this format: group_info_additional-info, for example: STG_1_R1, STG_1_R2, STG_1_R3, ... If you need to add additional info after the R# add a dash and the info (STG_1_R3-additional-info). The group for this example will be STG1 and within that group there will be STG_1_R1, STG_1_R2, STG_1_R3, .... This is important because the script will find the best representative sample within each of your groups which will be concatenated in the total_R1.fastq.gz and total_R2.fastq.gz files. For the actinula data there are a total of 36 sub dirs with a total of 72 files (an R1 and R2 read file for each sample). Side Note: You do not need to rename the actual sample files (the R1 and R1 files within each sub directory) and keep everything zipped.   
   
   ##### Once your directory is set up, run the script:   
   `./1_Full_Ref_Transcriptome_prep.py -d raw_larva_reads`  
    
   The highest quality replicates that are used in the Reference transcriptome are:  
   winners_R1 = ['STG_1_DP-18.R1', 'STG_2_DP-20.R1', 'STG_4_DP-28.R1', 'STG_3_DP-26.R1']   
   winners_R2 = ['STG_1_DP-18.R2', 'STG_2_DP-20.R2', 'STG_4_DP-28.R2', 'STG_3_DP-26.R2']  
   
   
### 2. Run Transcriptome Assembler: Oyster River Protocol (ORP)    
   Now that we have our representative R1 and R2 files, we can assemble the transcriptome. Here we used the ORP which generates 3 assemblies and merges them into 1 high quality assembly. More information on this method can be found here: https://oyster-river-protocol.readthedocs.io/en/latest/  
   
   ##### Submit the slurm:   
   `sbatch 2_ORP.slurm`  
   
   The code in this slurm (full slurm script can be found in scripts_for_analysis folder):   
   ```oyster.mk \   
   MEM=150 \   
   CPU=24 \   
   READ1=total_R1.fastq.gz \   
   READ2=total_R2.fastq.gz \   
   RUNOUT=hydractinia_total   
   ```

   Output Quality Metrics for the assembly:  
   
   *****  QUALITY REPORT FOR: hydractinia_total using the ORP version 2.2.8 ****.  
   *****  THE ASSEMBLY CAN BE FOUND HERE: /mnt/oldhome/plachetzki/sjb1061/hydractinia_transcriptomics/ORP/assemblies/hydractinia_total.ORP.fasta ****    

   *****  BUSCO SCORE ~~~~~~~~~~~~~~~~~~~~~~>      C:100.0%[S:48.2%,D:51.8%],F:0.0%,M:0.0%,n:303   
   *****  TRANSRATE SCORE ~~~~~~~~~~~~~~~~~~>      0.39257.  
   *****  TRANSRATE OPTIMAL SCORE ~~~~~~~~~~>      0.444.  
   *****  UNIQUE GENES ORP ~~~~~~~~~~~~~~~~~>      13186.  
   *****  UNIQUE GENES TRINITY ~~~~~~~~~~~~~>      11449.  
   *****  UNIQUE GENES SPADES55 ~~~~~~~~~~~~>      12060.  
   *****  UNIQUE GENES SPADES75 ~~~~~~~~~~~~>      10900.  
   *****  UNIQUE GENES TRANSABYSS ~~~~~~~~~~>      11098.  
   *****  READS MAPPED AS PROPER PAIRS ~~~~~>      93.87% 	 

### 3. Quantify Reads - Run Salmon
   Before we quantify our reads, we first need to change the headers in our new assembly. Some of the headers are very long and will be difficult to work with when we run Transdecoder in the next step so it is better to re-format the headers now. 
   
   ##### To reformat the headers, Run 3.A_rename_fa_headers.py.   
   `./3.A_rename_fa_headers.py -a hydractinia_total.ORP.fasta -b Hs_planula`   
   
   The second argument here is the base of the new header, this script counts each header in order so the first header will look like: Hs_planula_t.1   
  
   The output from this script will be the modified fasta file:  hydractinia_total.ORP.fasta-mod.fa
     
   Now that the headers have been reformated, we can use this assembly in Salmon which quantifies reads. Info on salmon can be found here: https://salmon.readthedocs.io/en/latest/salmon.html#using-salmon. The two inputs you will need for this program are the assembly and all of the raw reads. This slurm script (3.B_salmon.slurm) will map each replicate to the assembly (note: you only have to make the index once). 
   
   ##### Run the salmon Slurm.  
   `sbatch 3.B_salmon.slurm`  
   
   Output: You will get directories for each sample - here I secure copied all of my output directories to my desktop and placed them in a folder named mapping. This will be used with EdgeR to find DEGs and when making heatmaps in R towards the end of this workflow. 
   
   
### 4. Run TransDecoder 
   Next we need to translate our assembly into protien space so we can use our assembly in Orthofinder in the next step. We will also have to alter the headers again keeping only valuable information and then we will reduce the assembly by using cd-hit to get rid of duplicates. For more info on transdecoder go here: https://github.com/TransDecoder/TransDecoder/wiki.  
   
   ##### First, run Transdecoder:    
   `sbatch 4.A_transdecoder.slurm`   
   
   The code in the slurm is:  
   `TransDecoder.LongOrfs -t hydractinia_total.ORP.fasta-mod.fa`.    
   Use the longest_orfs.pep file in the transdecoder dir - copy the file and rename it: hydractinia_total_ORP_prot.fa   
   
   ##### Next, rename the headers in the prot fasta:   
   `./4.B_rename_prot_headers.py -a hydractinia_total_ORP_prot.fa`      
   
   The headers after running Transdecoder look like:   
    >Gene.1::Hs_planula_t.2::g.1::m.1 type:complete len:719 gc:universal Hs_planula_t.2:105-2261(+)  
    	
   This script will take the last segment of the transdecoder header (>Gene.1::Hs_planula_t.2::g.1::m.1 type:complete len:719 gc:universal **Hs_planula_t.2:105-2261(+)**) and will remove the direction ((-) or (+)) and the colon to make the new header which would be: >Hs_planula_t.2..105-2261. This header provides the original transcript from which it came (t.#) and also provides where in that sequence it came (#-#). The output file will have the -mod.fa tag at the end of the input fasta file.   
   
   The output file is: hydractinia_total_ORP_prot.fa-mod.fa.  
   
   ##### Now to get rid of potential duplicates in the assembly, run cd-hit on our protien assembly:   
   `sbatch 4.C_cdhit.slurm`
   
   The code in the slurm:  
   `cd-hit -i hydractinia_total_ORP_prot.fa-mod.fa -o hydractinia_total_ORP_prot.fa-mod_reduced.fa -c 0.98`  
   
   output file: hydractinia_total_ORP_prot.fa-mod_reduced.fa  
   
   The number of transcripts: `grep ">" hydractinia_total.ORP.fasta-mod.fa | wc -l`  = **92784 transcripts**.  
   The number of Protien models: `grep ">" hydractinia_total_ORP_prot.fa-mod.fa | wc -l` = **73297 prot mods**.  
   
   The number of Protien models after cd-hit: `grep ">" hydractinia_total_ORP_prot-mod_reduced.fa | wc -l` = **48629 prot mods**.  
   
  ##### Side Note: At this point there should now be 5 fasta files:   
 * The original ORP nuc fasta: *hydractinia_total.ORP.fa*.  
 * The modified header ORP nuc fasta: *hydractinia_total.ORP.fasta-mod.fa*.  
 * The original Transdecoder prot fasta: *hydractinia_total_ORP_prot.fa*    
 * The modified header prot fasta: *hydractinia_total_ORP_prot.fa-mod.fa*.  
 * The reduced (cd-hit) prot fasta (w/ mod headers): *hydractinia_total_ORP_prot-mod_reduced.fa*.  
   
   From here on, we will be using the reduced prot fasta: *hydractinia_total_ORP_prot-mod_reduced.fa*.  
   

### 5. Run OrthoFinder
   Now that we have our reduced Hydractinia planula prot models, we can use it with OrthoFinder to identify orthogroups among taxa, for more info on OrthoFinder go here: https://github.com/davidemms/OrthoFinder. For this run, we will use a total of 7 taxa:  
  * actinula (*E. crocea* larva).  
  * Hydractinia planula (this transcriptome).   
  * Hydractinia adult polyp.  
  * *Nematostella*  
  * *Hydra*  
  * *Drosophila*.  
  * *Homo sapiens*.  
  
  ##### Run OrthoFinder slurm:  
  `sbatch 5_orthofinder.slurm`  
  
  The code in the slurm:   
  `orthofinder.py -f ./fastas/ -t 24 -M msa -S diamond`   
  
   The ouput files you need to transfer to your desktop to be used in R in later steps are: 
  * Orthogroups.tsv (renamed it to: Orthogroups_5-11-20.tsv).  
  * Orthogroups.GeneCount.tsv (renamed it to: Orthogroups.GeneCount_5-11-20.tsv).  

### 6. Download Gene Sets  

   The goal of step 6 is to download the protien fastas for genes in different sensory gene sets currated by the Broad Institute. This section is split up into two major steps, A and B. Within the B step there are 4 sub steps that need to be performed. This method uses the python module bio entrez to download each sequence within a gene set and it double checks that the correct number of sequences have been downloaded.     
   
   ##### A. Select gene sets from the Broad Institute Gene Set Enrichment Analysis (GSEA) https://www.gsea-msigdb.org/gsea/msigdb/genesets.jsp    
   We used 3 gene sets for this paper:   
   [GO_SENSORY_PERCEPTION_OF_LIGHT_STIMULUS](https://www.gsea-msigdb.org/gsea/msigdb/cards/GO_SENSORY_PERCEPTION_OF_LIGHT_STIMULUS.html).  
   [GO_SENSORY_SYSTEM_DEVELOPMENT](https://www.gsea-msigdb.org/gsea/msigdb/human/geneset/GOBP_SENSORY_SYSTEM_DEVELOPMENT.html).  
   [GO_TRANSCRIPTION_FACTOR_ACTIVITY](https://www.gsea-msigdb.org/gsea/msigdb/human/geneset/GOMF_DNA_BINDING_TRANSCRIPTION_FACTOR_BINDING.html).  

   For each gene set, click on the show members link and then copy all info into seperate excel files and save as csv files. Make sure you have the entrez id, gene symbol, and the description.   
   
   ##### B. Download Gene set sequences *(run on each gene set)* 
   
   ###### B.1 Import CSV files to terminal 
   You can either secure copy csv files and send to terminal or open a nano window and copy and paste. 
   
   ###### B.2 Run clean up script: 6.B.2_clean_up_csv.py
   This script will go through the csv file and will clean up the descriptions, it will remove the trailing .. and any brackets with text.   
   `./6.B.2_clean_up_csv.py -i sensory_percep_light_stim_geneset.txt`   
   
   output: sensory_percep_chem_light_geneset.txt-mod   
   
   ###### B.3 Download Sequences using NCBI Entrez database.  
   There are two options here, both do the same thing but because of the number of sequences in a gene set, there needs to be a pause in the connection to the database. **Choose the correct option based on the number of genes in the gene set.**   
   
   There are 3 parts to downloading sequences in these scripts. The first part performs the intial search of genes in *Homo sapiens* to get accession IDs. This will generate two ouput files:   
   summary_info.txt which contains the info for each gene symbol (we need the gene ID from this file).   
   gene_tables.txt which has all of the gene information (we need the protien accession IDs from this file for each symbol).   
   
   The second part creates a dictionary where the gene symbols are the keys and accession ids are the values - this is populated by going through the gene_tables.txt file and adding accession ids that have been verified and start with NP_ . If you are using option 1 because your gene set has 1-150 genes the script will move right into part 3, if you are using option 2 then the script will write a temporary file of this dicitonary to be used in part 3.  
   
   The third part of the script will use the dictionary just created to search the accession id that starts with NP for each gene symbol in the human database and will write out the protien sequence to a FASTA file. This part will also generate a file called gene_symbol_accid which will be tab delimited with 2 columns with gene symbols in the first and accession ids in the second. These are the two files you will need in the following steps, I recommend copying those 2 files into a new directory for step 7.   
   
   Option 1: **1-150** genes in gene set use 6.B.3a_get_entrez_fastas-v5.py   
   `./6.B.3a_get_entrez_fastas-v5.py -i sensory_percep_light_stim_geneset.txt-mod -o sensory_percep_chem_stim.fa`   

   Option 2: **150-500** genes in gene set use 2 scripts:  
   `./6.B.3b_1_split_get_entrez_fasta-v5.py -i sensory_percep_light_stim_geneset.txt-mod`     
   `./6.B.3b_2_split_get_entrez_fasta-v5.py -o sensory_percep_light_stim.fa`    

###### B.4 Check for missing seqs: 6.B.4_check_missing_seqs-v2.py   
   Make sure you have downloaded all of the genes in the gene set. This script will compare one of the output files (gene_symbol_accid) with the cleaned up csv file from step B.2. If there are missing/incorrect genes you will have to change them by hand by searching the entrez gene id in the NCBI gene database. Make sure to adjust both the FASTA file and the gene_symbol_accid file accordingly. At the end, copy your FASTA file and your gene_symbol_accid file into a new directory to be used in the next step.  
  
  Run script  
  `./6.B.4_check_missing_seqs-v2.py -a sensory_percep_light_stim_geneset.txt-mod -b gene_symbol_accid`   





