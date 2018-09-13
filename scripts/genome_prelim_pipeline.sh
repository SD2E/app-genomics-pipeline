#!/bin/bash

#1. for quality assessments
#cd /test/output
#fastqc ../input/*.gz
fastqc ./*gz

READ1=${1}
READ2=${2}
NUMTHREADS=${3}

READ1_PREFIX=${READ1%.f*}
READ2_PREFIX=${READ2%.f*}

#2. Trimmomatic
#as single use
java -jar /opt/Trimmomatic-0.36/trimmomatic-0.36.jar PE \
     -threads ${NUMTHREADS} \
     -trimlog Plaurentii1_log \
     ./${READ1} \
     ./${READ2} \
     ${READ1_PREFIX}_S1_L001_R1_001_paired.fastq \
     ${READ1_PREFIX}_S1_L001_R1_001_unpaired.fastq \
     ${READ2_PREFIX}_S1_L001_R2_001_paired.fastq \
     ${READ2_PREFIX}_S1_L001_R2_001_unpaired.fastq \
     LEADING:3 \
     TRAILING:3 \
     SLIDINGWINDOW:4:15 \
     MINLEN:36 \
     -phred33

#     ILLUMINACLIP:/path/to/software/Trimmomatic-0.36/adapters/TruSeq3-PE-2.fa:2:30:1 \

#3. Genome assembly using Spades
spades.py --pe1-1 ${READ1_PREFIX}_S1_L001_R1_001_paired.fastq \
          --pe1-2 ${READ2_PREFIX}_S1_L001_R2_001_paired.fastq \
          --careful \
          --only-assembler \
          -t ${NUMTHREADS} \
          -o spades_output_${READ1_PREFIX}


#4. Quast assembly assessment
/opt/quast-4.6.3/quast.py spades_output_${READ1_PREFIX}/contigs.fasta \
                          --eukaryote \
                          -o quast_spades_${READ1_PREFIX}


#5. Busco analysis
#export AUGUSTUS_CONFIG_PATH="/home/vanessavaraljay/software/config/"
#python ~/software/busco/scripts/run_BUSCO.py \
#       --in contigs.fasta \
#       --out busco_Plaurentii_contigs \
#       --lineage_path ~/databases/https://busco.ezlab.org/datasets/basidiomycota_odb9 \
#       --mode genome \
#       --cpu 8


#still to incorporate into the pipeline, repeatmasker, gene prediction and annotation 
