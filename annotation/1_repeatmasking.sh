#!/bin/sh

##These steps were performed for you on the whole genome; we don't have time to run it in the workshop
docker pull kapeel/edta

#run EDTA (https://github.com/oushujun/EDTA)
docker run -v /scratch/Botany2020NMGWorkshop/annotation:/data -w /data/ kapeel/edta:latest --genome Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa --threads 7

#run protexcluder
blastx -db uniprot_sprot_plants.fasta -query consensi.fa.classified -out repeats2swissprot_blast.out -num_threads 20

/opt/ProtExcluder1.1/ProtExcluder.pl  -f 0 repeats2swissprot_blast.out consensi.fa.classified 
 
#run Repeatmasker
/opt/RepeatMasker/RepeatMasker -pa 7 -qq -lib consensi.fa.classifiednoProtFinal -noisy -a -gff -u Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa

#Soft mask genome
bedtools maskfasta -fi Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa -bed Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa.out.gff -fo contig_15.masked.fasta -soft -fullHeader

#Extract contig 15 for our test annotation
git clone https://github.com/solgenomics/sgn-biotools.git #to get fasta_extract.pl script
sgn-biotools/bin/fasta_extract.pl -f Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa -i ext -z fasta -o contig_15  #ext is a text file containing the contigs we want to extract
