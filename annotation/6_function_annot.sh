#!/bin/sh

#remove proteins with internal “.”

#run InterProScan
screen -L /tools/InterProScan/interproscan-5.36-75.0/interproscan.sh -f TSV -goterms -iprlookup -pa -i maker_prot_complete.fasta -o IPS.output -cpu 20

#filter out transposons
grep -f transposons.lsit all_IPS.out |cut -f1 > IPS_tran.list

#run Diamond
diamond blastp -d /databases/Trembl_04-17-19/uniprot_trembl.dmnd -q maker_prot_complete.fasta -o diamond_trembl.out

sort -k1,1 -k12,12nr -k11,11n diamond_trembl.out |sort -u -k1,1 --merge > tophits.out

cat inc_tophiht.out tophits.out |awk '$11 < 0.00000000000000000001 {print $0}' > all_tophits_e20.out
