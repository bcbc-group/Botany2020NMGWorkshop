#!/bin/sh
###############################################################
# pipeline for running hisat2  on multiple single end files   #
#                                                             #
# usage:                                                      #
#                                                             #
#      hisat_se_annot.sh $base_dir                            #
#                                                             #
###############################################################
#input_file-directory=$1

cd $1
CPU=$2

#index reference file
hisat2-build Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa Ugibba_FLYE_assembly.fasta.PolcaCorrected

#map reads to reference
for file in `dir -d *.fastq.gz` ; do

    samfile=`echo "$file" | sed 's/.fastq.gz/.sam/'`
    
    hisat2 --max-intronlen 100000 --dta -p $CPU -x Ugibba_FLYE_assembly.fasta.PolcaCorrected -U $file -S $samfile

done

ls *.sam |parallel --gnu -j $CPU samtools view -Sb -o {.}.bam {}
ls *.sort.bam |parallel --gnu -j $CPU samtools flagstat {} ">" {.}.flagstat
cat *flagstat |grep "mapped (" |sed 's/.*(\(.*\)%.*/\1/g' |awk '{sum+=$1} END { print "Average = ",sum/NR}' > average_mapping.txt

#calc mapping percent
for file in `dir -d *.flagstat` ; do

    num_mapped=`echo "$file" | sed 's/.flagstat/.mapped/'`
    grep "mapped (" $file | sed 's/.*(\(.*\)%.*/\1/g' > $num_mapped

done

for file in `ls -1 *mapped`; do
    echo "$file" > ./tmpfile
    cat "$file" >> ./tmpfile
    mv ./tmpfile "$file"
    cat $file |tr "\n" "\t" |sed -e '$a\' > $file.csv
done

cat *.csv > mapping_efficiency.csv

#run stringtie
for file in `dir -d *.sort.bam` ; do
    
    outdir=`echo "$file" |sed 's/.bam//'`
    
    stringtie --rf -p $CPU -o $outdir $file

done
