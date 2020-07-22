
#extract proteins from mikado output and remove ones with a single exon 
gffread -U -J  -y mikado_prot.fasta -g Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa  mikado.loci.gff3 #I didn't use -JU since it removed too many

#run scipio to get genbank file
/tools/scipio-1.4/scipio.1.4.1.pl --blat_output=prot.vs.genome.psl Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa mikado_prot.fasta > scipio.yaml

cat scipio.yaml | /tools/scipio-1.4/yaml2gff.1.4.pl > scipio.scipiogff

~/programs/augustus-3.2/scripts/scipiogff2gff.pl --in=scipio.scipiogff --out=scipio.gff

cat scipio.yaml | /tools/scipio-1.4/yaml2log.1.4.pl > scipio.log

~/programs/augustus-3.2/scripts/gff2gbSmallDNA.pl scipio.gff Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa 1000 genes.raw.gb

etraining --species=generic --stopCodonExcludedFromCDS=true genes.raw.gb 2> train.err

cat train.err | perl -pe 's/.*in sequence (\S+): .*/$1/' > badgenes.lst
~/programs/augustus-3.2/scripts/filterGenes.pl badgenes.lst genes.raw.gb > genes.gb
grep -c "LOCUS" genes.raw.gb genes.gb


#https://vcru.wisc.edu/simonlab/bioinformatics/programs/augustus/docs/tutorial2015/training.html
iget -rPT /iplant/home/shared/Botany2020NMGWorkshop/Annotation

/opt/augustus-3.2.2/scripts/randomSplit.pl genes.raw.gb 100 #normally you would use gene.gb here, but this dataset is sparse

grep -c LOCUS genes.raw.gb*

sudo chown srs57 /opt/augustus/config/species/
/opt/augustus-3.2.2/scripts/new_species.pl --species=Ugibba

etraining --species=Ugibba genes.raw.gb.train

ls -ort $AUGUSTUS_CONFIG_PATH/species/Ugibba

augustus --species=Ugibba genes.raw.gb.test | tee firsttest.out
