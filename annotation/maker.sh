#generate control files
maker -CTL

emacs maker_opts.ctl
#genome=Ugibba_FLYE_assembly.fasta.PolcaCorrected.fa.masked
#protein=uniprot_sprot_plants.fasta
#repeat_protein= #/opt/maker/data/te_proteins.fasta 

 mpirun -np 6 maker
