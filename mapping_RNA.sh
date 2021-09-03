#!/bin/bash

# Step1: Input the prefix of your .fastq file
# For example: SRR5339940
# Download the data before use it from GEO by using command example:
# fastq-dump --split-files SRR5339940

ref=${PATH OF REFERENCE INDEX}
software=${PATH OF SOFTWARE}
genome=$1
fq=$2

# Give output file a prefix

name=$3

# Here is index of reference genome which is used to do mapping

index=$ref/${genome}

# Step2 : Start mapping your fastq file (raw read)

echo Total read `cat ${fq}_1.fastq | grep ^@ | wc -l` >> summary

hisat2 -x $index -p 7 --sp 1000,1000 -1 ${fq}_1.fastq -2 ${fq}_2.fastq  | samtools view -bS - > $name.bam

# Step3: Keep uniquely mapped reads and then sort them by using coordinate before we remove PCR duplication.

samtools view -F 1804 -b $name.bam | samtools sort -@ 12 - > $name.sorted.bam

echo Uniquely mapped reads `samtools view -c $name.sorted.bam` >> summary

# Step4: Remove PCR duplication by using picard

java -jar -Xmx4g $software/picard-tools/MarkDuplicates.jar \
      I=$name.sorted.bam \
      O=${name}.dedup.bam \
      M=marked_dup_metrics.txt

echo Non-redundant mapped reads `samtools view -c ` >> summary
# Step5: Annotate your non-duplicated reads into transcription by featureCounts.

gtf=$ref/${genome}.refFlat.gtf

featureCounts --ignoreDup -p -B -a $gtf -t exon -g gene_id -o counts.txt ${name}.dedup.bam

cut -f1,7 counts.txt > $name.count.bed

wait
exit;
