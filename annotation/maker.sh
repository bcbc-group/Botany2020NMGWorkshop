#generate control files
maker -CTL

emacs maker_opts.ctl
#genome=Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa.masked
#protein=uniprot_sprot_plants.fasta
#model_org= #all
#repeat_protein= #/opt/maker/data/te_proteins.fasta 

screen -L mpirun -np 6 maker
#put maker output on datastore

gff3_merge -d 

Busco
