#!/bin/bash
#----------Build your own path--------------
software=
genome=$1
name=$2


chrom_size=$ref/$genome.chrom.sizes
$software/genomeCoverageBed -bg -ibam $name.dedup.bam -g $chrom_size > $name.bedgraph

sort -k1,1 -k2,2n $name.bedgraph -o $name.bedgraph

$software/bedGraphToBigWig $name.bedgraph $chrom_size $name.bw
chmod 644 *.bw

wait
exit
