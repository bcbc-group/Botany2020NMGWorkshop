#!/bin/sh

#move to annotation directory
cd /opt/annotation

#run Portcullis: https://bioconda.github.io/recipes/portcullis/README.html
docker run --rm -v /scratch/annotation:/data maplesond/portcullis:stable portcullis full -t 7 -v /data/contig_15.fasta /data/SRR5046448_contig15.sort.bam -o SRR5046448_contig15_port

#run Mikado pipeline: https://bioconda.github.io/recipes/mikado/README.htm		l
mikado configure --list list.txt --reference contig_15.fasta --mode permissive --scoring plants.yaml  --copy-scoring plants.yaml --junctions SRR5046448_contig15_port/3-filt/portcullis_filtered.pass.junctions.bed  -bt uniprot_sprot_plants.fasta > configuration.yaml

screen -L mikado prepare --json-conf configuration.yaml

blastx -max_target_seqs 5 -num_threads 7 -query mikado_prepared.fasta -outfmt 5 -db uniprot_sprot_plants.fasta -evalue 0.000001 2> blast.log | sed '/^$/d' | gzip -c - > mikado.blast.xml.gz

screen -L /opt/TransDecoder-TransDecoder-v5.5.0/TransDecoder.LongOrfs -t mikado_prepared.fasta

screen -L hmmscan --cpu 7 --domtblout pfam.domtblout /databases/Pfam/Pfam-A.hmm mikado_prepared.fasta.transdecoder_dir/longest_orfs.pep #this takes awhile

blastp -query mikado_prepared.fasta.transdecoder_dir/longest_orfs.pep -db /databases/plant_swissprot/uniprot_sprot_plants.fasta -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads 30 > blastp.outfmt6

/opt/TransDecoder-TransDecoder-v5.5.0/TransDecoder.LongOrfs/TransDecoder.Predict -t mikado_prepared.fasta --retain_pfam_hits pfam.domtblout --retain_blastp_hits blastp.outfmt6 --cpu 60

mikado serialise --json-conf configuration.yaml --xml mikado.blast.xml.gz --orfs mikado_prepared.fasta.transdecoder.bed --blast_targets uniprot_sprot_plants.fasta

mikado pick --json-conf configuration.yaml --subloci_out mikado.subloci.gff3
