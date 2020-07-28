#!/bin/sh
###############################################################
# pipeline for running hisat2 on paired end files   #
#                                                             #
# usage:                                                      #
#                                                             #
#      hisat_pe_annot.sh $base_dir $CPU                       #
#                                                             #
###############################################################

cd $1
CPU=$2

#index reference fasta file; We will use only contig_15 for demo purposes
/opt/hisat2-2.1.0/hisat2-build contig_15.fasta contig_15

#map RNA-seq reads to reference genome fasta file
for file in `dir -d *_1.fastq` ; do

    samfile=`echo "$file" | sed 's/_1.fastq/.sam/'`
    file2=`echo "$file" | sed 's/_1.fastq/_2.fastq/'`
    
    /opt/hisat2-2.1.0/hisat2 --max-intronlen 100000 --dta -p $CPU -x contig_15 -1 $file -2 $file2 -S $samfile   

done

ls *.sam |parallel --gnu -j $CPU samtools view -Sb -o {.}.bam {}
ls *.bam |parallel --gnu -j $CPU samtools -o {.}.sort.bam {}
ls *sort.bam |parallel --gnu -j $CPU samtools flagstat {} ">" {.}.flagstat
cat *flagstat |grep "mapped (" |sed 's/.*(\(.*\)%.*/\1/g' |awk '{sum+=$1} END { print "Average = ",sum/NR}' > average_mapping.txt

#calc mapping percent
for file in `dir -d *.flagstat` ; do

    num_mapped=`echo "$file" | sed 's/.flagstat/.mapped/'`
    grep "mapped (" $file | sed 's/.*(\(.*\)%.*/\1/g' > $num_mapped

done

for file in `ls -1 *mapped` ; do
    echo "$file" > ./tmpfile
    cat "$file" >> ./tmpfile
    mv ./tmpfile "$file"
    cat $file |tr "\n" "\t" |sed -e '$a\' > $file.csv
done

cat *.csv > mapping_efficiency.csv

#run stringtie to get gtf files of transcript annotations
for file in `dir -d *sort.bam` ; do
    
    outdir=`echo "$file" |sed 's/.bam/.gtf/'`
    
    /opt/stringtie-2.1.4.Linux_x86_64/stringtie --rf -p $CPU -o $outdir $file

done
