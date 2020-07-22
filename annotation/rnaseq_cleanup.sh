#!/bin/sh

#Map RNA-seq data
hisat2-build Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa Ugibba_FLYE_assembly.fasta.PolcaCorrected
hisat2 --max-intronlen 100000 --dta -p $CPU -x Ugibba_FLYE_assembly.fasta.PolcaCorrected -U $file -S $samfile

#run stringtie
stringtie --rf -p 20 -o Ugibba_stemR1_st.gtf Ugibba_stemR1.sort.bam

#For mapping many files:
#screen -L ./hisat_se_annot.sh . 10

#run Portcullis: https://bioconda.github.io/recipes/portcullis/README.html
docker run --rm -v /home/srs57/Botany_workshop_2020/Ugibba_transcriptome_data:/data maplesond/portcullis:stable portcullis full -t 7 -v /data/Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa /data/Ugibba_stemR1.sort.bam -o Ugibba_stemR1_port

#run Mikado: https://bioconda.github.io/recipes/mikado/README.htm		l
mikado configure --list list.txt --reference Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa --mode permissive --scoring plants.yaml  --copy-scoring plants.yaml --junctions Ugibba_stemR1_port/3-filt/portcullis_filtered.pass.junctions.bed  -bt /databases/plant_swissprot/uniprot_sprot_plants.fasta > configuration.yaml

screen -L mikado prepare --json-conf configuration.yaml

blastx -max_target_seqs 5 -num_threads 30 -query mikado_prepared.fasta -outfmt 5 -db /databases/plant_swissprot/uniprot_sprot_plants.fasta -evalue 0.000001 2> blast.log | sed '/^$/d' | gzip -c - > mikado.blast.xml.gz

screen -L /tools/TransDecoder-TransDecoder-v5.5.0/TransDecoder.LongOrfs -t mikado_prepared.fasta

screen -L hmmscan --cpu 60 --domtblout pfam.domtblout /databases/Pfam/Pfam-A.hmm mikado_prepared.fasta.transdecoder_dir/longest_orfs.pep

blastp -query mikado_prepared.fasta.transdecoder_dir/longest_orfs.pep -db /databases/plant_swissprot/uniprot_sprot_plants.fasta -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads 30 > blastp.outfmt6

/tools/TransDecoder-TransDecoder-v5.5.0/TransDecoder.Predict -t mikado_prepared.fasta --retain_pfam_hits pfam.domtblout --retain_blastp_hits blastp.outfmt6 --cpu 60

mikado serialise --json-conf configuration.yaml --xml mikado.blast.xml.gz --orfs mikado_prepared.fasta.transdecoder.bed --blast_targets /databases/plant_swissprot/uniprot_sprot_plants.fasta

mikado pick --json-conf configuration.yaml --subloci_out mikado.subloci.gff3
