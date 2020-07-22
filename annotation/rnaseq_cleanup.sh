#!/bin/sh

#Map RNA-seq data
screen -L ./hisat_se_annot.sh . 10

#run Portcullis: https://bioconda.github.io/recipes/portcullis/README.html
docker run --rm -v /home/srs57/Botany_workshop_2020/:/data maplesond/portcullis:stable portcullis full -t 20 -v /data/assemblies/Ugibba/PNAS2017/Utricularia_gibba.faa /data/Ugibba_transcriptome_data/Ugibba_bladderR1.fastq.bam -o Ugibba_bladderR1_portls home/srs57/Botany_workshop_2020/

#run Mikado: https://bioconda.github.io/recipes/mikado/README.htm		l
mikado configure --list list.txt --reference ../../Asclepias_syriaca_v0.3_chromosomes_and_contigs.fasta --mode permissive --scoring plants.yaml  --copy-scoring plants.yaml --junctions all_junc_pass.bed  -bt /databases/plant_swissprot/uniprot_sprot_plants.fasta
screen -L mikado prepare --json-conf configuration.yaml

blastx -max_target_seqs 5 -num_threads 30 -query mikado_prepared.fasta -outfmt 5 -db /databases/plant_swissprot/uniprot_sprot_plants.fasta -evalue 0.000001 2> blast.log | sed '/^$/d' | gzip -c - > mikado.blast.xml.gz

screen -L /tools/TransDecoder-TransDecoder-v5.5.0/TransDecoder.LongOrfs -t mikado_prepared.fasta

screen -L hmmscan --cpu 60 --domtblout pfam.domtblout /databases/Pfam/Pfam-A.hmm mikado_prepared.fasta.transdecoder_dir/longest_orfs.pep

blastp -query mikado_prepared.fasta.transdecoder_dir/longest_orfs.pep -db /databases/plant_swissprot/uniprot_sprot_plants.fasta -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads 30 > blastp.outfmt6

/tools/TransDecoder-TransDecoder-v5.5.0/TransDecoder.Predict -t mikado_prepared.fasta --retain_pfam_hits pfam.domtblout --retain_blastp_hits blastp.outfmt6 --cpu 60

mikado serialise --json-conf configuration.yaml --xml mikado.blast.xml.gz --orfs mikado_prepared.fasta.transdecoder.bed --blast_targets /databases/plant_swissprot/uniprot_sprot_plants.fasta

mikado pick --json-conf configuration.yaml --subloci_out mikado.subloci.gff3
