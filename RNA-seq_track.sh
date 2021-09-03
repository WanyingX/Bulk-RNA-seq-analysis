#!/bin/bash

genome=$1
name=$2

if [ $genome == "mm10" ];then
  chrom_size=/mnt/rstor/genetics/JinLab/xxl244/Reference_Indexes/mm10_bowtie_index/mm10.chrom.sizes
fi

if [ $genome == "hg19" ];then
  chrom_size=/mnt/rstor/genetics/JinLab/xxl244/Reference_Indexes/hg19/Homo_sapiens/UCSC/hg19/Sequence/Chromosomes/chrom.sizes
fi

$software/genomeCoverageBed -bg -ibam $name.dedup.bam -g $chrom_size > $name.bedgraph

sort -k1,1 -k2,2n $name.bedgraph -o $name.bedgraph

$software/bedGraphToBigWig $name.bedgraph $chrom_size $name.bw
chmod 644 *.bw

wait
exit
