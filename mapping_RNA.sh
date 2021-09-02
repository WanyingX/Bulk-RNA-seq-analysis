#!/bin/bash

# step1: input your fastq file 

fq1=$1
fq2=$2
name=$3

# Here is index of reference genome which is used to do mapping

index = ${HISAT2 mapping index}

# step2 : maping your raw reads

hisat2 -x $index -p 7 --sp 1000,1000 -1 $fq1 -2 $fq2  | samtools view -bS - > $name.merge.bam

# step3: sort your bam file by using coordin

samtools sort -@ 12 $name.merge.bam > $name.sorted.bam

# step4: remove duplication by using picard

java -jar -Xmx4g picard-tools/MarkDuplicates.jar \
      I=$name.sorted.bam \
      O=${file/.sorted.bam}.dedup.bam \
      M=marked_dup_metrics.txt

# Here is gene annotation file (can be download from UCSC)

gtf=hg19.refFlat.gtf

# step5: annotate your gene 

featureCounts --ignoreDup -p -B -a $gtf -t exon -g gene_id -o counts.txt ${file/.sorted.bam}.dedup.bam

cut -f1,7 counts.txt > $name.count.bed

wait
exit;
