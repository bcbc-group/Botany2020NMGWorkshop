#generate control files
maker -CTL

emacs maker_opts.ctl
#genome=Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa.masked
#protein=uniprot_sprot_plants.fasta
#model_org= #all
#repeat_protein= #/opt/maker/data/te_proteins.fasta 

screen -L mpirun -np 6 maker
#put maker output on datastore

#make a gff3 files from maker results
gff3_merge -d Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa.all.gff
gff3_merge -g -o Ugibba_FLYE_assembly.fasta.PolcaCorrected_maker_models.gff -d Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa.all.gff

#maker a protein file from maker output
gffread -g Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa -y Ugibba_maker_proteins.fasta Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa.all.gff
gffread -g Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa -y Ugibba_maker_proteins.fasta Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa.all.gff

#run BUSCO
cd /scratch/annotation

iget -rPT /iplant/home/shared/Botany2020NMGWorkshop/embryophyta_odb9

docker run  -v /scratch/annotation:/busco_wd -w /busco_wd/  upendradevisetty/busco:v3.0 -i Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa --out Ugibba_maker1 -c 6 --lineage_path embryophyta_odb9/ --mode prot
#/tools/busco/scripts/run_BUSCO.py -i Ugibba_maker_proteins.fasta -c 8 -m prot -l /tools/busco/embryophyta_odb10 -o Ugibba_maker1
