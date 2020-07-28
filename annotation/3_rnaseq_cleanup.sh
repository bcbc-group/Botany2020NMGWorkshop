#!/bin/sh

#move to annotation directory
cd /opt/annotation

#run Portcullis: https://bioconda.github.io/recipes/portcullis/README.html
docker pull maplesond/portcullis:stable
docker run --rm -v /scratch/Botany2020NMGWorkshop/annotation2:/data maplesond/portcullis:stable portcullis full -t 7 -v /data/contig_15.fasta /data/SRR5046448_contig15.sort.bam -o SRR5046448_contig15_port

#run Mikado pipeline: https://bioconda.github.io/recipes/mikado/README.html
docker pull cyverseuk/mikado
docker run --rm -v /scratch/Botany2020NMGWorkshop/annotation2:/data cyverseuk/mikado mikado configure --list list.txt --reference data/contig_15.fasta --mode permissive --scoring /data/plants.yaml  --copy-scoring /data/plants.yaml --junctions /data/SRR5046448_contig15_port/3-filt/portcullis_filtered.pass.junctions.bed  -bt /data/uniprot_sprot_plants.fasta > /data/configuration.yaml

docker run --rm -v /scratch/Botany2020NMGWorkshop/annotation2:/data cyverseuk/mikado mikado prepare --json-conf /data/configuration.yaml

blastx -max_target_seqs 5 -num_threads 7 -query mikado_prepared.fasta -outfmt 5 -db uniprot_sprot_plants.fasta -evalue 0.000001 2> blast.log | sed '/^$/d' | gzip -c - > mikado.blast.xml.gz

screen -L /opt/TransDecoder-TransDecoder-v5.5.0/TransDecoder.LongOrfs -t mikado_prepared.fasta

screen -L hmmscan --cpu 7 --domtblout pfam.domtblout Pfam-A.hmm mikado_prepared.fasta.transdecoder_dir/longest_orfs.pep #this takes awhile

blastp -query mikado_prepared.fasta.transdecoder_dir/longest_orfs.pep -db uniprot_sprot_plants.fasta -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads 7 > blastp.outfmt6

/opt/TransDecoder-TransDecoder-v5.5.0/TransDecoder.Predict -t mikado_prepared.fasta --retain_pfam_hits pfam.domtblout --retain_blastp_hits blastp.outfmt6 --cpu 7

docker run --rm -v /scratch/Botany2020NMGWorkshop/annotation2:/data cyverseuk/mikado mikado serialise --json-conf /data/configuration.yaml --xml /data/mikado.blast.xml.gz --orfs /data/mikado_prepared.fasta.transdecoder.bed --blast_targets /data/uniprot_sprot_plants.fasta

docker run --rm -v /scratch/Botany2020NMGWorkshop/annotation2:/data cyverseuk/mikado mikado pick --json-conf /data/configuration.yaml --subloci_out /data/mikado.subloci.gff3
