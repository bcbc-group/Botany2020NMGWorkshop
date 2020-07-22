#!/bin/sh

#run EDTA (https://github.com/oushujun/EDTA)
~/programs/EDTA/./EDTA.pl --genome Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa --threads 40

#run protexcluder
blastx -db /databases/plant_swissprot/uniprot_sprot_plants.fasta -query Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa -out repeats2swissprot_blast.out -num_threads 20

/tools/ProtExcluder1.1/ProtExcluder.pl  -f 0 repeats2swissprot_blast.out Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa 
 
#run Repeatmasker
/tools/RepeatMasker/RepeatMasker -pa 30 -qq -lib consensi.fa.classifiednoProtFinal -noisy -a -gff -u Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa

