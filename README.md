# Setup tools

1. hisat2
  http://daehwankimlab.github.io/hisat2/download/
2. featureCounts
  https://sourceforge.net/projects/subread/files/
  build tools under your own path
  tar zxvf subread-1.x.x.tar.gz
  Enter the src subdirectory under the home directory of the package and then issue the following command to build it on a Linux/unix computer:
    make -f Makefile.Linux
  To build it on a Mac OS X computer, issue the following command:
    make -f Makefile.MacOS
  To build it on a FreeBSD computer, issue the following command:
    make -f Makefile.FreeBSD
  To build it on a Oracle Solaris or OpenSolaris computer, issue the following command:
    make -f Makefile.SunOS
3. picard (Includes in .zip file

# Reference index 
  Download zip file:
    hisat2 reference index
      mm10.*.ht2
      hg19.*.ht2
    Gene annotation file
      mm10.refFlat.gtf
      hg19.refFlat.gtf
# Run RNAseq.sh
  RNAseq.sh {genome} {prefix of fastq file} {prefix of output file}
# The output of this script
1. *.dedup.bam: mapped reads removes PCR duplication
