#!/bin/bash
#fq=$1
name=$1

#index=/mnt/rds/genetics01/JinLab/xww/Reference_Index/mm10/mm10

#hisat2 -x $index -p 7 --sp 1000,1000 -1 ${fq}_1.fastq -2 ${fq}_2.fastq  | samtools view -bS - > $name.merge.bam

#wait

#gtf=/mnt/rds/genetics01/JinLab/xww/RNA-seq/hg19.refFlat.gtf

#samtools sort $name.merge.bam > $name.merge.sorted.bam &
samtools merge $name.bam $name.rep1.merge.sorted.bam $name.rep2.merge.sorted.bam $name.rep3.merge.sorted.bam 
#wait

samtools sort $name.bam > $name.sorted.bam

#wait


#genomeCoverageBed -bg -ibam $name.merge.sorted.bam -g $chrom_size -strand - | awk '{$4 = - $4;print $0}' > $name.rev.bedgraph

# mouse chrom size 
chrom_size=/mnt/rstor/genetics/JinLab/xxl244/Reference_Indexes/mm10_bowtie_index/mm10.chrom.sizes

# human chrom size
chrom_size=/mnt/rstor/genetics/JinLab/xxl244/Reference_Indexes/hg19/Homo_sapiens/UCSC/hg19/Sequence/Chromosomes/chrom.sizes

genomeCoverageBed -bg -ibam $name.sorted.bam -g $chrom_size > $name.bedgraph

wait

sort -k1,1 -k2,2n $name.bedgraph -o $name.bedgraph

bedGraphToBigWig $name.bedgraph $chrom_size $name.bw
#bedGraphToBigWig $name.forward.bedgraph $chrom_size $name.forward.bw &
#bedGraphToBigWig $name.reverse.bedgraph $chrom_size $name.reverse.bw &

wait
chmod 644 *.bw
wait

exit
