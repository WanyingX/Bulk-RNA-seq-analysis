# Setup tools

1. hisat2
2. featureCounts download and installation
  Download subread in this link: https://sourceforge.net/projects/subread/files/
  tar zxvf subread-1.x.x.tar.gz
  Enter the src subdirectory under the home directory of the package and then issue the following command to build it on a Linux/unix computer:
    make -f Makefile.Linux
  To build it on a Mac OS X computer, issue the following command:
    make -f Makefile.MacOS
  To build it on a FreeBSD computer, issue the following command:
    make -f Makefile.FreeBSD
  To build it on a Oracle Solaris or OpenSolaris computer, issue the following command:
    make -f Makefile.SunOS

# Run RNAseq.sh
  RNAseq.sh {genome} {prefix of fastq file} {prefix of output file}
# The output of this script
1. *.dedup.bam: mapped reads removes PCR duplication
