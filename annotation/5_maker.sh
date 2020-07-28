#generate control files
maker -CTL

#edit the input control file
emacs maker_opts.ctl
#genome=contig_15_masked.fasta
#protein=uniprot_sprot_plants.fasta
#model_org= #all
#repeat_protein= #/opt/maker/data/te_proteins.fasta 
#snaphmm=Ugibba_snap.hmm
#augustus_species=Ugibba
#pred_gff=mikado.loci.gff3
#est2genome=0
#protein2genome=0

screen -L mpirun -np 7 maker -base maker1
#put maker output on datastore

#make a gff3 files from maker results
gff3_merge -d maker1.maker.output/maker1_master_datastore_index.log
gff3_merge -g -o maker1_models.gff -d maker1.maker.output/maker1_master_datastore_index.log

#maker a protein file from maker output
gffread -g contig_15.fasta -y maker1_proteins.fasta maker1_models.gff

#run BUSCO
cd /scratch/annotation

iget -rPT /iplant/home/shared/Botany2020NMGWorkshop/embryophyta_odb9

docker run  -v /scratch/annotation:/busco_wd -w /busco_wd/  upendradevisetty/busco:v3.0 -i maker1_proteins.fasta --out Ugibba_maker1 -c 7 --lineage_path embryophyta_odb9/ --mode prot
#/tools/busco/scripts/run_BUSCO.py -i Ugibba_maker_proteins.fasta -c 8 -m prot -l /tools/busco/embryophyta_odb10 -o Ugibba_maker1
