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

#----------------Build your mapping index----------------------

index=$ref/${genome}

#----------------Step1: Start mapping--------------------------

echo Total read `cat ${fq}_1.fastq | grep ^@ | wc -l` >> summary

hisat2 -x $index -p 7 --sp 1000,1000 -1 ${fq}_1.fastq -2 ${fq}_2.fastq  | samtools view -bS - > $name.bam

#------------Step2: Keep uniquely mapped reads-----------------

samtools view -F 1804 -b $name.bam | samtools sort -@ 12 - > $name.sorted.bam

echo Uniquely mapped reads `samtools view -c $name.sorted.bam` >> summary

#------------Step3: remove PCR duplication---------------------

java -jar -Xmx4g $software/picard-tools/MarkDuplicates.jar \
      I=$name.sorted.bam \
      O=${name}.dedup.bam \
      M=marked_dup_metrics.txt

echo Non-redundant mapped reads `samtools view -c ` >> summary
#-------Step4: Annotate genes by using reads--------------------

gtf=$ref/${genome}.refFlat.gtf

featureCounts --ignoreDup -p -B -a $gtf -t exon -g gene_id -o counts.txt ${name}.dedup.bam

cut -f1,7 counts.txt > $name.count.bed
rm $name.bam $name.sorted.bam

#!/bin/bash
#---------Generate genomic track of your RNA-seq data------------

chrom_size=$ref/$genome.chrom.sizes
$software/genomeCoverageBed -bg -ibam ${name}.dedup.bam -g $chrom_size > $name.bedgraph

sort -k1,1 -k2,2n $name.bedgraph -o $name.bedgraph

$software/bedGraphToBigWig $name.bedgraph $chrom_size $name.bw
chmod 644 *.bw

wait
exit;
