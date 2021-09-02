#!/bin/bash

# Step1: Input the prefix of your .fastq file
# For example: SRR5339940
# Download the data before use it from GEO by using command:
# fastq-dump --split-files SRR5339940

fq1=$1

# Give output file a prefix

name=$2

# Here is index of reference genome which is used to do mapping

index = ${HISAT2 mapping index}

# Step2 : Start mapping your fastq file (raw read)

hisat2 -x $index -p 7 --sp 1000,1000 -1 $fq1 -2 $fq2  | samtools view -bS - > $name.bam

# Step3: Sort bam file by using coordinate before we remove PCR duplication.

samtools sort -@ 12 $name.bam > $name.sorted.bam

# Step4: Remove PCR duplication by using picard

java -jar -Xmx4g picard-tools/MarkDuplicates.jar \
      I=$name.sorted.bam \
      O=${name}.dedup.bam \
      M=marked_dup_metrics.txt

# Step5: Annotate your non-duplicated reads into transcription by featureCounts.

gtf=hg19.refFlat.gtf

featureCounts --ignoreDup -p -B -a $gtf -t exon -g gene_id -o counts.txt ${name}.dedup.bam

cut -f1,7 counts.txt > $name.count.bed

wait
exit;
